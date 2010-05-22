note
	description: "Class that represents data collected from a feature call transition"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_TRANSITION_INFO

create
	make

feature{NONE} -- Initialization

	make (a_tc_info: like test_case_info; a_transition: like transition; a_pre_valuation: like pre_state_valuations; a_post_valuationi: like post_state_valuations)
			-- Initialize Current.
		do
			test_case_info := a_tc_info
			transition := a_transition
			pre_state_valuations := a_pre_valuation
			post_state_valuations := a_post_valuationi
		end

feature -- Access

	test_case_info: CI_TEST_CASE_INFO
			-- Test case information

	transition: SEM_FEATURE_CALL_TRANSITION
			-- Feature call transition

	pre_state_valuations: DS_HASH_TABLE [EPA_FUNCTION_VALUATIONS, EPA_FUNCTION]
			-- Valuations of functions in pre-execution state
			-- Key is a function, value is the argument(s) to value mapping for that function.

	post_state_valuations: DS_HASH_TABLE [EPA_FUNCTION_VALUATIONS, EPA_FUNCTION]
			-- Valuations of functions in post-execution state
			-- Key is a function, value is the argument(s) to value mapping for that function.

end
