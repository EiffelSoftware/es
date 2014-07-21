
deferred class
	ES_ADB_INTERFACE_STRINGS

inherit
	ANY
		undefine
			default_create,
			copy,
			is_equal
		end

feature

	Tool_name: STRING = "AutoFix"

	Tab_name_setting: STRING = "Settings"
	Tab_name_faults:  STRING = "Faults"
	Tab_name_fixes:   STRING = "Fixes"
	Tab_name_output:  STRING = "Output"

		-- Tab settings
	Frame_text_classes_to_debug: STRING = "Groups of classes to AutoFix"
	Button_text_add: STRING = "Add"
	Button_text_remove: STRING = "Remove"
	Button_text_remove_all: STRING = "Removel all"

	Frame_text_general: STRING = "General"
	Label_text_working_directory: STRING = "Working directory"
	checkbutton_text_test_classes_in_groups: STRING = "Test classes in groups"

	Frame_text_testing: STRING = "Testing"
	Label_text_each_session_tests: STRING = "Each session tests"
	combobox_text_test_session_type_one_class: STRING = "one class"
	combobox_text_test_session_type_one_group: STRING = "one group of classes"
	combobox_text_test_session_type_all_classes: STRING = "all classes"
	label_text_maximum_session_length_for_testing: STRING = "Maximum session length for testing (in minutes)"
	Checkbutton_text_testing_use_fixed_seed: STRING = "Use fixed seed"

	Frame_text_fixing: STRING = "Fixing"
	Label_text_start_fixing: STRING = "Start fixing"
	Combobox_text_start_fixing_type_after_each_testing_session: STRING = "after each testing session"
	Combobox_text_start_fixing_type_after_all_testing_sessions: STRING = "after all testing sessions"
	Combobox_text_start_fixing_type_manually: STRING = "manually"
	label_text_maximum_session_length_for_fixing: STRING = "Maximum session length for fixing (in minutes)"
	Label_text_fixing_number_of_fixes: STRING = "Maximum fix candidates to propose"
	Checkbutton_text_fixing_implementation: STRING = "Propose fixes to implementation"
	Checkbutton_text_fixing_contracts: STRING = "Propose fixes to contracts"
	Label_text_fixing_number_of_tests: STRING = "Maximum number of tests to use in fixing"
	Label_text_fixing_passing_tests: STRING = "Passing: "
	Label_text_fixing_failing_tests: STRING = "Failing: "

	Button_text_load_config: STRING = "Load settings"
	Button_text_save_config: STRING = "Save settings"
	Button_text_start: STRING = "Start AutoFixing"
	Button_text_stop: STRING = "Stop AutoFixing"

		-- Tab faults
	Button_text_fix_all: STRING = "Start AutoFixing all to-be-attempted"
	Button_text_fix_all_stop: STRING = "Stop AutoFixing all to-be-attempted"
	Button_text_fix_selected: STRING = "Start AutoFixing selected"
	Button_text_fix_selected_stop: STRING = "Stop AutoFixing selected"
	Button_text_mark_as_manually_fixed: STRING = "Mark as manually fixed"

	Button_text_filter_by_approachability: STRING = "filter by fault"
	Button_text_filter_by_fixes: STRING = "filter by fixes"
	Menu_text_all: STRING = "All"
	Menu_text_automatic_implementation_fixable: STRING = "Automatically fixable by changing implementation"
	Menu_text_automatic_specification_fixable: STRING = "Automatically fixable by changing contracts"
	Menu_text_not_automatic_fixable: STRING = "Not automatically fixable"
	Menu_text_not_yet_attempted: STRING = "Not yet attempted"
	Menu_text_candidate_fix_available: STRING = "Candidate fix available"
	Menu_text_candidate_fix_unavailable: STRING = "Candidate fix unavailable"
	Menu_text_candidate_fix_accepted: STRING = "Candidate fix accepted"
	Menu_text_manually_fixed: STRING = "Manually fixed"

--	toggle_text_show_to_be_attempted: STRING = "To be attempted"
--	Toggle_text_show_candidate_fix_available: STRING = "Candidate fix available"
--	Toggle_text_show_candidate_fix_unavailable: STRING = "Candidate fix unavailable"
--	Toggle_text_show_candidate_fix_accepted: STRING = "Candidate fix accepted"
--	Toggle_text_show_manual_fixed: STRING = "Manually fixed"

	Grid_column_text_class_and_feature_under_test: STRING = "Class and feature under test"
	Grid_column_text_fault: STRING = "Fault"
	Grid_column_text_passing_tests: STRING = "Passing tests"
	Grid_column_text_failing_tests: STRING = "Failing tests"
	Grid_column_text_status: STRING = "Status"
	Grid_column_text_info: STRING = "Info"

	Fault_status_out_of_scope: STRING = "Out of scope"
	Fault_status_to_be_attempted: STRING = "To be attempted"
	Fault_status_candidate_fix_available: STRING = "Candidate fix available"
	Fault_status_candidate_fix_unavailable: STRING = "Candidate fix unavailable"
	Fault_status_candidate_fix_accepted: STRING = "Candidate fix applied"
	Fault_status_manually_fixed: STRING = "Manually fixed"

	Grid_no_fault: STRING = "No fault to list"

		-- Tab fixes
	Grid_column_text_fix_id: STRING = "ID"
	Grid_column_text_type: STRING = "Type"
	Grid_column_text_nature: STRING = "Nature of change"
	Grid_column_text_is_proper: STRING = "Is proper?"
--	Grid_column_text_status: STRING = "Status"

	Grid_label_text_yes: STRING = "Yes"
	Grid_label_text_no:  STRING = "No"

	Frame_text_fix: STRING = "Fix"
	Label_text_before_fix: STRING = "Before fix"
	Label_text_after_fix: STRING = "After fix"
	Button_text_apply: STRING = "Apply"

	Fix_type_unconditional_add: STRING = "Unconditional add"
	Fix_type_conditional_add: STRING = "Conditional add"
	Fix_type_conditional_execute: STRING = "Conditional execute"
	Fix_type_conditional_replace: STRING = "Conditional replace"

	Fix_status_applied: STRING = "Applied"

feature

	Msg_delete_directory_content: STRING = "The selected directory is not empty. Should all contents be deleted?"
	Msg_remove_existing_debugging_results: STRING = "Starting a new AutoFix session will REMOVE all existing results in the current working directory. Do you want to continue?"
	Msg_failed_to_copy_project: STRING = "Failed to copy the project into working directory."
	Msg_discard_existing_fixing_results: STRING = "The selected fault has been attempted by AutoFix already. Do you want to discard the previous results and AutoFix it again?"
	Msg_apply_fix: STRING = "Change to your code cannot be rolled back. Do you want to continue?"
	Msg_set_contract_fix_applied: STRING = "Fixes to contracts need to be applied manually. This operation will only set the fix status to %"applied%" without changing the code. Do you want to continue?"

;note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
