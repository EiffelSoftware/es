note
	description: "Utilities for contract inference"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_UTILITY

inherit
	CI_SHARED_EQUALITY_TESTERS

	KL_SHARED_STRING_EQUALITY_TESTER

feature -- Access

	interface_transitions_from_test_cases (a_test_cases: LINKED_LIST [CI_TEST_CASE_TRANSITION_INFO]): DS_HASH_TABLE [SEM_FEATURE_CALL_TRANSITION, CI_TEST_CASE_TRANSITION_INFO]
			-- Build interface transitions from `a_test_cases'.
			-- Result is a table of interface transtions
			-- Key is test case, value is the interface transition adapted from the transition in that test case.
			-- The pre- and post-conditions of the interface transition only mentions operands in the feature.
		local
			l_transition: SEM_FEATURE_CALL_TRANSITION
			l_test_case: CI_TEST_CASE_TRANSITION_INFO
			l_original_transition: SEM_FEATURE_CALL_TRANSITION
		do
			create Result.make (a_test_cases.count)
			Result.set_key_equality_tester (ci_test_case_transition_info_equality_tester)

				-- Iterate through all test cases in `transition_data',
				-- for each test case, build the corresponding interface transition.
			across a_test_cases as l_test_cases loop
				l_test_case := l_test_cases.item
				l_original_transition := l_test_case.transition
				create l_transition.make (
					l_test_case.test_case_info.class_under_test,
					l_test_case.test_case_info.feature_under_test,
					l_test_case.test_case_info.operand_map,
					l_test_case.transition.context,
					l_test_case.transition.is_creation)
				l_transition.set_uuid (l_original_transition.uuid)
				l_transition.set_preconditions_unsafe (l_original_transition.interface_preconditions.subtraction (l_original_transition.written_preconditions))
				l_transition.set_postconditions_unsafe (l_original_transition.interface_postconditions.subtraction (l_original_transition.written_postconditions))
				Result.force_last (l_transition, l_test_case)
			end
		end

end
