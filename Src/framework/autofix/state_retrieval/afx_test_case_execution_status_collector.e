note
	description: "Summary description for {AFX_TEST_CASE_EXECUTION_STATUS_COLLECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_TEST_CASE_EXECUTION_STATUS_COLLECTOR

inherit
	AFX_CONSTANTS

	REFACTORING_HELPER

create
	make

feature{NONE} -- Initialization

	make (a_config: like config)
			-- Initialize.
		do
			set_config (a_config)
			create status.make (50)
			status.compare_objects
		end

feature -- Access

	status: HASH_TABLE [AFX_TEST_CASE_EXECUTION_STATUS, STRING]
			-- Table of test case status (including both passing and failing test cases)
			-- Key is test case uuid, value is the execution status of that test case.

	test_case_info: AFX_TEST_CASE_INFO
			-- Information of the fault

	config: AFX_CONFIG
			-- Current config for AutoFix

feature -- Setting

	set_config (a_config: like config)
			-- Set `config' with `a_config'.
		do
			config := a_config
		ensure
			config_set: config = a_config
		end

	set_test_case_info (a_tc: like test_case_info)
			-- Set `test_case_info' with `a_tc'.
		do
			test_case_info := a_tc
		ensure
			test_case_info_set: test_case_info = a_tc
		end

feature -- Actions

	on_test_case_start (a_tc: AFX_TEST_CASE_INFO; a_mocking_mode: BOOLEAN)
			-- Action to ber performed when `a_tc' starts
			-- If `a_mocking_mode' is True, load file directly from disk.
		require
			a_tc_has_uuid: attached {STRING} a_tc.uuid as id and then not id.is_empty
		local
			l_status: AFX_TEST_CASE_EXECUTION_STATUS
			l_uuid: STRING
		do
			if test_case_info = Void then
				set_test_case_info (a_tc)
			end
			if a_mocking_mode then
				load_from_file
			else
				l_uuid := a_tc.uuid.twin
				create l_status.make (a_tc, l_uuid)
				check not status.has (l_uuid) end
				status.put (l_status, l_uuid)
			end
		end

	on_break_point_hit (a_tc: AFX_TEST_CASE_INFO; a_state: AFX_STATE; a_bpslot: INTEGER)
			-- Action to be performed when `a_bpslot' is hit in test case `a_tc'.
			-- `a_state' is the retrieved system state at `a_bpslot'.
		require
			a_tc_has_uuid: attached {STRING} a_tc.uuid as id and then not id.is_empty
		local
			l_status: AFX_TEST_CASE_EXECUTION_STATUS
			l_uuid: STRING
		do
			l_uuid := a_tc.uuid
			check status.has (l_uuid) end
			l_status := status.item (l_uuid)
			check l_status.info.uuid ~ a_tc.uuid end
				-- Only store pre-/post state of current test case.
			if a_bpslot = l_status.first_break_point_slot then
				l_status.set_pre_state (a_state.cloned_object)
			elseif a_bpslot = l_status.last_break_point_slot then
				check l_status.is_passing end
				l_status.set_post_state (a_state.cloned_object)
			end
		end

	on_application_exited
			-- Action to be performed when application exited
		local
			l_keys: LINKED_LIST [STRING]
		do
			fixme("Remove test case execution status without pre state, this should not happen. 21.12.2009 Jasonw")
			create l_keys.make
			from
				status.start
			until
				status.after
			loop
				if attached {AFX_STATE} status.item_for_iteration.pre_state as l_pre_state then
				else
					l_keys.extend (status.key_for_iteration)
				end
				status.forth
			end
			l_keys.do_all (agent status.remove)

			store_in_file
		end

feature{NONE} -- Impelemntation

	store_in_file
			-- Store `status' into file.
		local
			l_file_name: FILE_NAME
			l_file: RAW_FILE
			l_data: HASH_TABLE [TUPLE [tc_info: AFX_TEST_CASE_INFO; pre_state: detachable STRING; post_state: detachable STRING], STRING]
			l_status: AFX_TEST_CASE_EXECUTION_STATUS
		do
			if attached {AFX_TEST_CASE_INFO} test_case_info as l_tc then
				create l_data.make (status.count)
				l_data.compare_objects
				from
					status.start
				until
					status.after
				loop
					l_status := status.item_for_iteration
					l_data.put (l_status.data_as_string, status.key_for_iteration)
					status.forth
				end

				create l_file_name.make_from_string (config.data_directory)
				l_file_name.set_file_name (l_tc.id + ".execution_status")
				create l_file.make_create_read_write (l_file_name)
				l_file.independent_store (l_data)
				l_file.close
			end
		end

	load_from_file
			-- Load `status' from file.
		local
			l_file_name: FILE_NAME
			l_file: RAW_FILE
			l_tcstatus: AFX_TEST_CASE_INFO
			l_data: TUPLE [tc_info: AFX_TEST_CASE_INFO; pre_state: detachable STRING; post_state: detachable STRING]
			l_pre_state: detachable AFX_STATE
			l_post_state: detachable AFX_STATE
			l_single_status: AFX_TEST_CASE_EXECUTION_STATUS
		do
			if attached {AFX_TEST_CASE_INFO} test_case_info as l_tc then
				create l_file_name.make_from_string (config.data_directory)
				l_file_name.set_file_name (l_tc.id + ".execution_status")
				create l_file.make_open_read (l_file_name)
				if attached {HASH_TABLE [TUPLE [tc_info: AFX_TEST_CASE_INFO; pre_state: detachable STRING; post_state: detachable STRING], STRING]} l_file.retrieved as l_status then
					create status.make (l_status.count)
					from
						l_status.start
					until
						l_status.after
					loop
						l_data := l_status.item_for_iteration
						l_tcstatus := l_data.tc_info
						l_pre_state := Void
						l_post_state := Void
						if l_data.pre_state /= Void then
							create l_pre_state.make_from_string (l_tcstatus.recipient_class_, l_tcstatus.recipient_, l_data.pre_state)
						else
							check False end
						end
						if l_data.post_state /= Void then
							create l_post_state.make_from_string (l_tcstatus.recipient_class_, l_tcstatus.recipient_, l_data.post_state)
						end
						create l_single_status.make_with_data (l_tcstatus, l_pre_state, l_post_state, l_status.key_for_iteration)
						status.put (l_single_status, l_status.key_for_iteration)
						l_status.forth
					end
				else
					check should_not_happen: False end
				end
				l_file.close
			end
		end

end
