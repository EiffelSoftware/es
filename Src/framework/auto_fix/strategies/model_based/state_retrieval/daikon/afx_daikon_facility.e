note
	description: "Summary description for {AFX_DAIKON_FACILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_DAIKON_FACILITY

inherit
	AFX_SHARED_STATE_SERVER

create
	make

feature{NONE} -- Initialization

	make (a_config: like config)
			-- Initialize set the file names to store the daikon declaration
			-- and create the tables to store the daikon decl and trace.
		do
			config := a_config
			create daikon_generator.make
			create daikon_fail_states.make (100)
			create daikon_pass_states.make (100)
			create passing_declaractions.make (20)
			create failing_declaractions.make (20)
		end

feature -- Access

	pass_result: AFX_DAIKON_RESULT
			-- Result of all pass test cases

	fail_result: AFX_DAIKON_RESULT
			-- Result of all fail test cases

	exception_spot: AFX_EXCEPTION_SPOT
			-- Spot describing the current expressions

feature -- Actions

	on_test_case_breakpoint_hit (a_tc: EPA_TEST_CASE_INFO; a_state: EPA_STATE; a_bpslot: INTEGER)
			-- Action to perform when a breakpoint `a_bpslot' is hit in test case `a_tc'.
			-- `a_state' is the set of expressions with their evaluated values.
		require
			a_tc_attached: a_tc /= Void
		do
			if pass_test_case_info = void then
				if (a_tc.is_passing) then
					set_pass_test_case_info (a_tc)
				end
			end

			if fail_test_case_info = void then
				if (a_tc.is_failing) then
					set_fail_test_case_info (a_tc)
				end
			end

			daikon_generator.add_state (exception_spot.skeleton, a_state, a_bpslot, a_tc.is_failing)
		end

	on_new_test_case_found (tc_info: EPA_TEST_CASE_INFO) is
			-- Store the current
		require
			tc_info_attached: tc_info /= Void
		do
			store_daikon_state
		end

	on_application_exited (a_dm: DEBUGGER_MANAGER)
			-- Execute daikon
		do
			store_daikon_state

				--write daikon files
			write_daikon_to_file

				-- Run and load daikon output
			load_daikon_result

				-- Set the daikon output
			create pass_result.make_from_string (daikon_pass_result, pass_test_case_info)
			create fail_result.make_from_string (daikon_fail_result, fail_test_case_info)

				-- Store Daikon output into files for cacheing.
			store_invariant_in_file (daikon_pass_result, daikon_result_file_name (pass_test_case_info))
			store_invariant_in_file (daikon_fail_result, daikon_result_file_name (fail_test_case_info))

				-- Put results into server.
			state_server.put_state_for_fault (fail_test_case_info, [pass_result, fail_result])
		end

feature -- Setting

	set_pass_test_case_info (a_tc: like pass_test_case_info)
			-- Set `pass_test_case_info' with `a_tc'.
		require
			a_tc_attached: a_tc /= Void
		do
			pass_test_case_info_internal := a_tc
		ensure
			pass_test_case_info_set: pass_test_case_info = a_tc
		end

	set_fail_test_case_info (a_tc: like fail_test_case_info)
			-- Set `fail_test_case_info' with `a_tc'.
		require
			a_tc_attached: a_tc /= Void
		do
			fail_test_case_info := a_tc
		ensure
			fail_test_case_info_set: fail_test_case_info = a_tc
		end

	set_exception_spot (a_spot: like exception_spot)
			-- Set `exception_spot' with `a_spot'.
		do
			exception_spot := a_spot
		end

feature{NONE} -- Implementation

	daikon_result_file_name (a_tc: EPA_TEST_CASE_INFO): STRING
			-- Full file path for the file to store Daikon output
		local
			l_path: FILE_NAME
			l_name: STRING
		do
			create l_path.make_from_string (config.daikon_directory)
			l_name := a_tc.id
			if a_tc.is_passing then
				l_name := l_name + "__S.invariant"
			else
				l_name := l_name + "__F.invariant"
			end
			l_path.set_file_name (l_name)
			Result := l_path
		end

	config: AFX_CONFIG
			-- AutoFix configuration

	daikon_generator: AFX_DAIKON_GENERATOR
			-- Daikon generator

	daikon_pass_states:  DS_ARRAYED_LIST [STRING]
			-- List of pass states

	daikon_fail_states:  DS_ARRAYED_LIST [STRING]
			-- List of fail states

	passing_declaractions: DS_ARRAYED_LIST [STRING]
			-- Variable declaractions for passing test cases

	failing_declaractions: DS_ARRAYED_LIST [STRING]
			-- Variable declaractions for failing test cases

	daikon_pass_result: STRING
			-- Result from running Daikon

	daikon_fail_result: STRING
			-- Result from running Daikon

	pass_test_case_info: detachable EPA_TEST_CASE_INFO
			-- Information about a pass test case
		do
			if attached {EPA_TEST_CASE_INFO} pass_test_case_info_internal as l_pass_info then
				Result := l_pass_info
			else
				if attached {EPA_TEST_CASE_INFO} fail_test_case_info as l_fail_info then
					Result := l_fail_info.deep_twin
					Result.set_is_passing (True)
				end
			end
		end

	fail_test_case_info: detachable EPA_TEST_CASE_INFO
			-- Information about a fail test case

	write_daikon_to_file is
			-- Write the pass and fail declaration and trace to file
		local
			pass_file:PLAIN_TEXT_FILE
			fail_file:PLAIN_TEXT_FILE
		do
			create pass_file.make_open_write (pass_file_name (pass_test_case_info))

				--Save to file.
			pass_file.put_string (daikon_generator.declaraction_for_skeleton (exception_spot.skeleton, exception_spot.recipient_written_class, exception_spot.recipient_, False))
			from
				daikon_pass_states.start
			until
				daikon_pass_states.after
			loop
				pass_file.put_string (daikon_pass_states.item_for_iteration)
				daikon_pass_states.forth
			end
			pass_file.close

			create fail_file.make_create_read_write (fail_file_name (fail_test_case_info))
			pass_file.put_string (daikon_generator.declaraction_for_skeleton (exception_spot.skeleton, exception_spot.recipient_written_class, exception_spot.recipient_, True))
				--Save to file.
			from
				daikon_fail_states.start
			until
				daikon_fail_states.after
			loop
				fail_file.put_string (daikon_fail_states.item_for_iteration)
				daikon_fail_states.forth
			end
			fail_file.close
		end

	load_daikon_result is
			-- Load the result from the Daikon execution
		local
			shell : AFX_BOOGIE_FACILITY
			pass_CMD : STRING
			fail_CMD : STRING
		do
			create shell
			pass_cmd := daikon_command + " " + pass_file_name (pass_test_case_info)
			fail_cmd := daikon_command + " " + fail_file_name (fail_test_case_info)
			daikon_fail_result := shell.output_from_program (fail_cmd, void)
			daikon_pass_result := shell.output_from_program (pass_cmd, void)
		end

	daikon_command: STRING
			-- Command to launch daikon
		do
			if {PLATFORM}.is_windows then
				Result := "java daikon.Daikon"
			else
				Result := "/usr/bin/java daikon.Daikon"
			end
		end

	store_daikon_state is
			-- Store the current state for Daikon
		local
			daikon_state : STRING
		do
			if daikon_generator.number_states > 0 then
--				daikon_state := daikon_generator.declarations + daikon_generator.traces
				daikon_state := daikon_generator.traces
				if daikon_generator.is_failing_tc then
					daikon_fail_states.put_right (daikon_state)
				else
					daikon_pass_states.put_right (daikon_state)
				end
				daikon_generator.restart
			end
		end

	store_invariant_in_file (a_invariant: STRING; a_file: STRING)
			-- Store invariants from `a_invariant' into `a_file'.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_create_read_write (a_file)
			l_file.put_string (a_invariant)
			l_file.close
		end

	pass_file_name (a_tc: EPA_TEST_CASE_INFO): STRING
			-- Faull path for the file to store passing test case states
			-- for fault indicated in `a_Tc'
		require
			a_tc_attached: a_tc /= Void
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (config.daikon_directory)
			l_path.set_file_name (a_tc.id + "__S.dtrace")
			Result := l_path
		end

	fail_file_name (a_tc: EPA_TEST_CASE_INFO): STRING
			-- Faull path for the file to store failing test case states
			-- for fault indicated in `a_Tc'
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (config.daikon_directory)
			l_path.set_file_name (a_tc.id + "__F.dtrace")
			Result := l_path
		end

	pass_test_case_info_internal: like pass_test_case_info
			-- Storage for `pass_test_case_info'

end
