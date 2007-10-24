indexing
	description: "Objects that print all cdd activities to a log file"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_LOG_PRINTER

create
	make_with_manager

feature {NONE} -- Initialization

	make_with_manager (a_manager: like manager) is
			-- Assign `manager' to `a_manager' and subscribe `Current' as observer.
		require
			a_manager_not_void: a_manager /= Void
		do
			manager := a_manager
			manager.refresh_actions.extend (agent note_refresh)
		ensure
			manager_set: manager = a_manager
		end

feature -- Access

	manager: CDD_MANAGER
			-- Manager containing current test suite

feature -- Basic operations

	note_refresh is
			--
		local
			l_cursor: DS_LINKED_LIST_CURSOR [CDD_TEST_CASE]
		do
			if manager.is_testing_enabled then
				manager.test_suite.add_test_case_actions.extend (agent note_test_case_add)
				manager.test_suite.remove_test_case_actions.extend (agent note_test_case_remove)
				from
					l_cursor := manager.test_suite.test_cases.new_cursor
					l_cursor.start
				until
					l_cursor.off
				loop
					l_cursor.item.update_status_actions.extend (agent note_test_case_status (l_cursor.item))
					l_cursor.forth
				end
			end
		end

	note_test_case_add (a_tc: CDD_TEST_CASE) is
			--
		require
			testing_enabled: manager.is_testing_enabled
			a_tc_not_void: a_tc /= Void
		do
			a_tc.update_status_actions.extend (agent note_test_case_status (a_tc))
			write_log_message (a_tc, "created")
		end

	note_test_case_remove (a_tc: CDD_TEST_CASE) is
			--
		require
			testing_enabled: manager.is_testing_enabled
			a_tc_not_void: a_tc /= Void
		do
			write_log_message (a_tc, "removed")
		end

	note_test_case_status (a_tc: CDD_TEST_CASE) is
			--
		require
			testing_enabled: manager.is_testing_enabled
			a_tc_not_void: a_tc /= Void
		do
			write_log_message (a_tc, "executed")
		end

	note_start_examinating (a_tc: CDD_TEST_CASE) is
			--
		require
			testing_enabled: manager.is_testing_enabled
			a_tc_not_void: a_tc /= Void
		do
			write_log_message (a_tc, "start_fix")
		end

	note_examintaing_success (a_tc: CDD_TEST_CASE) is
			--
		require
			testing_enabled: manager.is_testing_enabled
			a_tc_not_void: a_tc /= Void
		do
			write_log_message (a_tc, "pre_state_captured")
		end

feature -- Obsolete

feature {NONE} -- Implementation

feature {NONE} -- Basic log operations

	write_log_message (a_tc: CDD_TEST_CASE; an_action: STRING) is
			-- Try to write `a_message' into `file' and add information like time etc.
		require
			an_action_not_void: an_action /= Void and then not an_action.is_empty
			a_tc_not_empty: a_tc /= Void
		local
			l_string: STRING
			l_date: DATE_TIME
		do
			prepare_file
			if can_write_to_file then
				create l_date.make_now
				create l_string.make_empty
				l_string.append (an_action)
				l_string.append_character (';')
				l_string.append (l_date.out)
				l_string.append_character (';')
				l_string.append (a_tc.tester_class.name)
				l_string.append_character (';')
				l_string.append (a_tc.class_under_test.name)
				l_string.append_character (';')
				l_string.append (a_tc.feature_under_test.name)
				l_string.append_character (';')
				if a_tc.is_verified then
					l_string.append ("verified")
				else
					l_string.append ("unverified")
				end
				l_string.append_character (';')
				inspect a_tc.status
				when {CDD_TEST_CASE}.fail_code then
					l_string.append ("fails")
				when {CDD_TEST_CASE}.pass_code then
					l_string.append ("passes")
				when {CDD_TEST_CASE}.invalid_code then
					l_string.append ("invalid")
				else
					l_string.append ("untested")
				end
				l_string.append_character (';')
				if a_tc.last_exception_class_name /= Void then
					l_string.append (a_tc.last_exception_class_name)
				end
				l_string.append_character (';')
				if a_tc.last_exception_feature_name /= Void then
					l_string.append (a_tc.last_exception_feature_name)
				end
				l_string.append_character (';')
				if a_tc.last_exception_tag /= Void then
					l_string.append (a_tc.last_exception_tag)
				end
				file.put_string (l_string)
				file.put_new_line
				close_file
			end
		end

feature {NONE} -- Log file operations

	can_write_to_file: BOOLEAN is
			-- Is `file' opened and writable?
		do
			Result := file /= Void and then file.is_open_write
		end

	file: KL_TEXT_OUTPUT_FILE
			-- File where all logs are written to

	file_name: FILE_NAME is
			-- File name for `file'
		require
			testing_enabled: manager.is_testing_enabled
		do
			create Result.make_from_string (manager.test_suite.tests_cluster.location.build_path ("", "cdd_history.log"))
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end

	prepare_file is
			-- Try to open `file' so log messages can be written.
		do
			create file.make (file_name)
			file.open_append
		end

	close_file is
			-- Close `file'
		require
			opened: can_write_to_file
		do
			file.close
		ensure
			closed: not can_write_to_file
		end

invariant
	manager_not_void: manager /= Void

end
