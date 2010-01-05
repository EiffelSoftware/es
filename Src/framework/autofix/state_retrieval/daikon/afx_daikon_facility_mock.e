note
	description: "Summary description for {AFX_DAIKON_FACILITY_MOCK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_DAIKON_FACILITY_MOCK

inherit
	AFX_DAIKON_FACILITY
		redefine
			on_test_case_breakpoint_hit,
			on_new_test_case_found,
			on_application_exited
		end

create
	make

feature -- Actions

	on_test_case_breakpoint_hit (a_tc: AFX_TEST_CASE_INFO; a_state: AFX_STATE; a_bpslot: INTEGER)
			-- Action to perform when a breakpoint `a_bpslot' is hit in test case `a_tc'.
			-- `a_state' is the set of expressions with their evaluated values.
		do
			-- Do nothing
		end

	on_new_test_case_found (tc_info: AFX_TEST_CASE_INFO) is
			-- Store the current
		local
			l_tc_info: AFX_TEST_CASE_INFO
		do
			if pass_test_case_info = Void or fail_test_case_info = Void then
				if tc_info.is_passing then
					set_pass_test_case_info (tc_info)
					l_tc_info := tc_info.twin
					l_tc_info.set_is_passing (False)
					set_fail_test_case_info (l_tc_info)
				else
					set_fail_test_case_info (tc_info)
					l_tc_info := tc_info.twin
					l_tc_info.set_is_passing (True)
					set_pass_test_case_info (l_tc_info)
				end
			end
		end

	on_application_exited
			-- Execute daikon
		do
			create pass_result.make_from_string (invariants_from_file (daikon_result_file_name (pass_test_case_info)), pass_test_case_info)
			create fail_result.make_from_string (invariants_from_file (daikon_result_file_name (fail_test_case_info)), fail_test_case_info)

				-- Put results into server.
			state_server.put_state_for_fault (fail_test_case_info, [pass_result, fail_result])
		end

feature{NONE} -- Implementation

	invariants_from_file (a_file: STRING): STRING
			-- Invariants loaded from `a_file'
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_open_read (a_file)
			l_file.read_stream (l_file.count)
			Result := l_file.last_string.twin
			l_file.close
		end

end
