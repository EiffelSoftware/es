note
	description: "Class that represents data collected from a feature call transition"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_TEST_CASE_TRANSITION_INFO

inherit
	HASHABLE

create
	make

feature{NONE} -- Initialization

	make (a_tc_info: like test_case_info; a_transition: like transition;
		  a_pre_valuations: like pre_state_valuations; a_post_valuations: like post_state_valuations;
		  a_pre_bounded_functions: like pre_state_integer_bounded_functions; a_post_bounded_functions: like post_state_integer_bounded_functions)
			-- Initialize Current.
		do
			test_case_info := a_tc_info
			transition := a_transition

			create valuations.make (2)
			valuations.put (a_pre_valuations, True)
			valuations.put (a_post_valuations, False)

			create integer_bounded_functions.make (2)
			integer_bounded_functions.put (a_pre_bounded_functions, True)
			integer_bounded_functions.put (a_post_bounded_functions, False)

			hash_code := a_tc_info.hash_code
		end

feature -- Access

	test_case_info: CI_TEST_CASE_INFO
			-- Test case information

	transition: SEM_FEATURE_CALL_TRANSITION
			-- Feature call transition

	pre_state_valuations: DS_HASH_TABLE [EPA_FUNCTION_VALUATIONS, EPA_FUNCTION]
			-- Valuations of functions in pre-execution state
			-- Key is a function, value is the argument(s) to value mapping for that function.
		do
			Result := valuations [True]
		end

	post_state_valuations: DS_HASH_TABLE [EPA_FUNCTION_VALUATIONS, EPA_FUNCTION]
			-- Valuations of functions in post-execution state
			-- Key is a function, value is the argument(s) to value mapping for that function.			
		do
			Result := valuations [False]
		end

	valuations: HASH_TABLE [DS_HASH_TABLE [EPA_FUNCTION_VALUATIONS, EPA_FUNCTION], BOOLEAN]
			-- Hash table containing state valuations.
			-- Key is a boolean indicating if it is pre- or post- state.

	pre_state_integer_bounded_functions: DS_HASH_SET [CI_FUNCTION_WITH_INTEGER_DOMAIN]
			-- Functions with bounded integer domain (with both a lower and an upper bound)
			-- in pre-execution state
		do
			Result := integer_bounded_functions [True]
		end

	post_state_integer_bounded_functions: DS_HASH_SET [CI_FUNCTION_WITH_INTEGER_DOMAIN]
			-- Functions with bounded integer domain (with both a lower and an upper bound)
			-- in post-execution state
		do
			Result := integer_bounded_functions [False]
		end

	integer_bounded_functions: HASH_TABLE [DS_HASH_SET [CI_FUNCTION_WITH_INTEGER_DOMAIN], BOOLEAN]
			-- Hash table containing pre- and post-state integer_bounded_functions.
			-- Key is a boolean indicating if it is pre- or post- state.

	hash_code: INTEGER
			-- Hash code

	serialization_info: detachable CI_TEST_CASE_SERIALIZATION_INFO
			-- Serialization information
			-- Have effect only if semantic search support is enabled

feature -- Setting

	set_serialization_info (a_info: like serialization_info)
			-- Set `serialization_info' with `a_info'.
		do
			serialization_info := a_info
		ensure
			serialization_info_set: serialization_info = a_info
		end

end
