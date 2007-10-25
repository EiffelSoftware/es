indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_ROUTINES

inherit

	CDD_CONSTANTS

feature {NONE} -- Implementation

	is_creation_feature (a_feature: E_FEATURE): BOOLEAN is
			--
		require
			a_feature_not_void: a_feature /= Void
		local
			l_class: CLASS_C
		do
			l_class := a_feature.associated_class
			Result := l_class.creation_feature = a_feature.associated_feature_i
			if not Result then
				Result := l_class.creators /= Void and then l_class.creators.has (a_feature.name)
			end
		end

	is_valid_status (an_application_status: APPLICATION_STATUS): BOOLEAN is
			-- Is 'an_application_status' valid for creating a test case?
		do
			Result := an_application_status.is_stopped and
					an_application_status.exception_occurred and
					(an_application_status.exception_code = {EXCEP_CONST}.void_call_target or
					an_application_status.exception_code = {EXCEP_CONST}.postcondition or
					an_application_status.exception_code = {EXCEP_CONST}.class_invariant or
					an_application_status.exception_code = {EXCEP_CONST}.precondition or
					an_application_status.exception_code = {EXCEP_CONST}.check_instruction)
		end

	tester_target_name (a_target: CONF_TARGET): STRING is
			-- Name of tester target for `a_target'
		do
			Result := a_target.name + tester_target_suffix
		ensure
			not_void: Result /= Void
		end

	test_routines (a_class: CLASS_C): DS_LINKED_LIST [STRING] is
			--
		require
			a_class_not_void: a_class /= Void
		local
			l_ft: FEATURE_TABLE
			l_name: STRING
		do
			l_ft := a_class.feature_table
			from
				l_ft.start
				create Result.make
			until
				l_ft.after
			loop
				l_name := l_ft.item_for_iteration.feature_name
				if l_name.count >= test_routine_prefix.count and then
					l_name.substring (1, test_routine_prefix.count).is_case_insensitive_equal (test_routine_prefix) then
					Result.put_last (l_name)
				end
				l_ft.forth
			end
		end

end
