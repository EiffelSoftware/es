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
		local
			pass_file_n:FILE_NAME
			fail_file_n:FILE_NAME
		do
			config := a_config
			create daikon_generator.make
			create daikon_fail_states.make (100)
			create daikon_pass_states.make (100)

			create pass_file_n.make_from_string (a_config.data_directory)
			create fail_file_n.make_from_string (a_config.data_directory)
			pass_file_n.extend ("pass.dtrace")
			fail_file_n.extend ("fail.dtrace")
			pass_file_name := pass_file_n.out
			fail_file_name := fail_file_n.out
		end

feature -- Access

	pass_result: AFX_DAIKON_RESULT
			-- Result of all pass test cases

	fail_result: AFX_DAIKON_RESULT
			-- Result of all fail test cases

feature -- Actions

	on_test_case_breakpoint_hit (a_tc: AFX_TEST_CASE_INFO; a_state: AFX_STATE; a_bpslot: INTEGER)
			-- Action to perform when a breakpoint `a_bpslot' is hit in test case `a_tc'.
			-- `a_state' is the set of expressions with their evaluated values.
		do
			if pass_test_case_info = void then
				if (a_tc.is_passing) then
					pass_test_case_info := a_tc
				end
			end

			if fail_test_case_info = void then
				if (a_tc.is_failing) then
					fail_test_case_info := a_tc
				end
			end

			daikon_generator.add_state (a_state,a_bpslot.out,a_tc.is_failing)
		end


	on_new_test_case_found (tc_info :AFX_TEST_CASE_INFO) is
			-- Store the current
		do
			store_daikon_state
		end


	on_application_exited
			-- Execute daikon
		do
			store_daikon_state

				--write daikon files
			write_daikon_to_file

				-- Run and load daikon output
			load_daikon_result

				--Set the daikon output
			create pass_result.make_from_string (daikon_pass_result, pass_test_case_info)
			create fail_result.make_from_string (daikon_fail_result, fail_test_case_info)

			state_server.put_state_for_fault (fail_test_case_info, [pass_result, fail_result])
		end


feature{NONE} -- Implementation
	config: AFX_CONFIG
			-- AutoFix configuration

	daikon_generator: AFX_DAIKON_GENERATOR
			-- Daikon generator

	daikon_pass_states:  DS_ARRAYED_LIST [STRING]
			-- List of pass states

	daikon_fail_states:  DS_ARRAYED_LIST [STRING]
			-- List of fail states

	daikon_pass_result: STRING
			-- Result from running Daikon

	daikon_fail_result: STRING
			-- Result from running Daikon

	pass_file_name: STRING
			-- File used to store Daikon dtrace

	fail_file_name: STRING
			-- File used to store Daikon dtrace

	pass_test_case_info: detachable AFX_TEST_CASE_INFO
			-- Information about a pass test case

	fail_test_case_info: detachable AFX_TEST_CASE_INFO
			-- Information about a fail test case


	write_daikon_to_file is
			-- Write the pass and fail declaration and trace to file
		local
			pass_file:PLAIN_TEXT_FILE
			fail_file:PLAIN_TEXT_FILE
		do

			create pass_file.make_open_write (pass_file_name)
				--Save to file
			from
				daikon_pass_states.start
			until
				daikon_pass_states.after
			loop
				pass_file.put_string (daikon_pass_states.item_for_iteration)
				daikon_pass_states.forth
			end
			pass_file.close

			create fail_file.make_create_read_write (fail_file_name)
			--Save to file
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
			-- load the result from the Daikon execution
		local
			shell : AFX_BOOGIE_FACILITY
			pass_CMD : STRING
			fail_CMD : STRING
		do
			create shell
			pass_cmd := "/usr/bin/java daikon.Daikon " + pass_file_name
			fail_cmd := "/usr/bin/java daikon.Daikon " + fail_file_name
			daikon_fail_result := shell.output_from_program (fail_cmd, void)
			daikon_pass_result := shell.output_from_program (pass_cmd, void)
			--io.put_string ("Received from Daikon FAIL " + daikon_fail_result)
			--io.put_string ("Received from Daikon PASS " + daikon_pass_result)
		end


	store_daikon_state is
			-- Store the current state for Daikon
		local
			daikon_state : STRING

		do
			if daikon_generator.number_states > 0 then
				daikon_state := daikon_generator.declarations + daikon_generator.traces
				if daikon_generator.is_failing_tc then
					daikon_fail_states.put_right (daikon_state)
				else
					daikon_pass_states.put_right (daikon_state)
				end
				daikon_generator.restart
			end
		end
end
