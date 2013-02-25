note
	description: "Summary description for {AFX_TEST_CASE_EXECUTION_STATUS_COLLECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_TEST_CASE_EXECUTION_STATUS_COLLECTOR

--inherit
--	AFX_TEST_CASE_EXECUTION_EVENT_LISTENER

--	AFX_SHARED_DYNAMIC_ANALYSIS_REPORT

--	AFX_SHARED_SESSION

--	EPA_CONSTANTS

--	REFACTORING_HELPER

feature -- Access

--	test_case_info: EPA_TEST_CASE_SIGNATURE
--			-- Information of the fault

feature -- Status report

	is_test_case_new (a_tc: EPA_TEST_CASE_INFO): BOOLEAN
			-- <Precursor>
		do
--			Result := not (test_case_execution_status.has (a_tc.id))
		end

feature -- Setting

--	set_test_case_info (a_tc: like test_case_info)
--			-- Set `test_case_info' with `a_tc'.
--		do
--			test_case_info := a_tc
--		ensure
--			test_case_info_set: test_case_info = a_tc
--		end

feature -- Actions

	on_new_test_case (a_tc: EPA_TEST_CASE_INFO)
			-- <Precursor>
		local
			l_status: AFX_TEST_CASE_EXECUTION_SUMMARY
			l_id: STRING
		do
--			l_id := a_tc.id.twin
--			create l_status.make (a_tc, l_id)
--			test_case_execution_status.put (l_status, l_id)

----			if test_case_info = Void then
----				set_test_case_info (a_tc)
----			end
--			current_test_case := a_tc
		end

	on_breakpoint_hit (a_tc: EPA_TEST_CASE_INFO; a_state: EPA_STATE; a_bpslot: INTEGER)
			-- <Precursor>
		local
			l_status: AFX_TEST_CASE_EXECUTION_STATUS
			l_id: STRING
		do
--			l_id := a_tc.id
--			l_status := test_case_execution_status.item (l_id)
--			check l_status.info.id ~ a_tc.id end
--				-- Only store pre-/post state of current test case.
--			if a_bpslot = l_status.first_break_point_slot then
--				l_status.set_pre_state (a_state.cloned_object)
--			elseif a_bpslot = l_status.last_break_point_slot then
--				l_status.set_post_state (a_state.cloned_object)
--			end
		end

	on_application_exit
			-- <Precursor>
		local
			l_keys: LINKED_LIST [STRING]
		do
--			fixme("Remove test case execution status without pre state, this should not happen. 21.12.2009 Jasonw")
--			create l_keys.make
--			from
--				test_case_execution_status.start
--			until
--				test_case_execution_status.after
--			loop
--				if attached {EPA_STATE} test_case_execution_status.item_for_iteration.pre_state as l_pre_state then
--				else
--					l_keys.extend (test_case_execution_status.key_for_iteration)
--				end
--				test_case_execution_status.forth
--			end
--			l_keys.do_all (agent test_case_execution_status.remove)

----			store_in_file
		end

feature{NONE} -- Impelemntation

--	store_in_file
--			-- Store `status' into file.
--		local
--			l_file_name: FILE_NAME
--			l_file: RAW_FILE
--			l_data: HASH_TABLE [TUPLE [tc_info: EPA_TEST_CASE_SIGNATURE; pre_state: detachable STRING; post_state: detachable STRING], STRING]
--			l_status: AFX_TEST_CASE_EXECUTION_STATUS
--		do
--			if attached {EPA_TEST_CASE_SIGNATURE} test_case_info as l_tc then
--				create l_data.make (test_case_execution_status.count)
--				l_data.compare_objects
--				from
--					test_case_execution_status.start
--				until
--					test_case_execution_status.after
--				loop
--					l_status := test_case_execution_status.item_for_iteration
--					l_data.put (l_status.data_as_string, test_case_execution_status.key_for_iteration)
--					test_case_execution_status.forth
--				end

--				create l_file_name.make_from_string (config.data_directory)
--				l_file_name.set_file_name (l_tc.id + ".execution_status")
--				create l_file.make_create_read_write (l_file_name)
--				l_file.independent_store (l_data)
--				l_file.close
--			end
--		end

--	load_from_file
--			-- Load `status' from file.
--		local
--			l_file_name: FILE_NAME
--			l_file: RAW_FILE
--			l_tcstatus: EPA_TEST_CASE_SIGNATURE
--			l_data: TUPLE [tc_info: EPA_TEST_CASE_SIGNATURE; pre_state: detachable STRING; post_state: detachable STRING]
--			l_pre_state: detachable EPA_STATE
--			l_post_state: detachable EPA_STATE
--			l_single_status: AFX_TEST_CASE_EXECUTION_STATUS
--			l_tc_status: like test_case_execution_status
--		do
--			if attached {EPA_TEST_CASE_SIGNATURE} test_case_info as l_tc then
--				create l_file_name.make_from_string (config.data_directory)
--				l_file_name.set_file_name (l_tc.id + ".execution_status")
--				create l_file.make_open_read (l_file_name)
--				if attached {HASH_TABLE [TUPLE [tc_info: EPA_TEST_CASE_SIGNATURE; pre_state: detachable STRING; post_state: detachable STRING], STRING]} l_file.retrieved as l_status then
--					create l_tc_status.make (l_status.count)
--					from
--						l_status.start
--					until
--						l_status.after
--					loop
--						l_data := l_status.item_for_iteration
--						l_tcstatus := l_data.tc_info
--						l_pre_state := Void
--						l_post_state := Void
--						if l_data.pre_state /= Void then
--							create l_pre_state.make_from_string (l_tcstatus.recipient_class_, l_tcstatus.recipient_, l_data.pre_state)
--						else
--							check False end
--						end
--						if l_data.post_state /= Void then
--							create l_post_state.make_from_string (l_tcstatus.recipient_class_, l_tcstatus.recipient_, l_data.post_state)
--						end
--						create l_single_status.make_with_data (l_tcstatus, l_pre_state, l_post_state, l_status.key_for_iteration)
--						l_tc_status.put (l_single_status, l_status.key_for_iteration)
--						l_status.forth
--					end
--					set_test_case_execution_status (l_tc_status)
--				else
--					check should_not_happen: False end
--				end
--				l_file.close
--			end
--		end

end
