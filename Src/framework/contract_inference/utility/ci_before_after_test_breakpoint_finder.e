note
	description: "[
		Simple AST node searcher based on text]
		Note: The implementation reparses all sub-nodes, this is an expensive implementation.
		More efficient algorithm is needed.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_BEFORE_AFTER_TEST_BREAKPOINT_FINDER

inherit
	AST_ITERATOR
		redefine
			process_access_feat_as,
			process_id_as
		end

	INTERNAL_COMPILER_STRING_EXPORTER

feature -- Access

	before_test_break_point_slot: INTEGER
			-- The break point slot before the test case

	after_test_break_point_slot: INTEGER
			-- The break point slot after the test case

	finish_post_state_calculation_slot: INTEGER
			-- The break point slot after post state calculation

feature -- Basic operation

	find_break_points (a_ast: AST_EIFFEL)
			-- Find break points of statements containing `setup_before_test_name' and `cleanup_after_test_name'.
			-- Make results available in `before_test_break_point_slot' and `after_test_break_point_slot'.
		do
			a_ast.process (Current)
		end

feature{NONE} -- Implementation

	setup_before_test_name: STRING = "setup_before_test"
			-- Name for feature `setup_before_test'

	cleanup_after_test_name: STRING = "cleanup_after_test"
			-- Name for feature `cleanup_after_test'

	finish_post_state_calculation_name: STRING = "finish_post_state_calculation"
			-- Name for feature `finish_post_state_calculation'

feature{NONE} -- Process

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			check_name (l_as.access_name, l_as)
			safe_process (l_as.internal_parameters)
		end

	process_id_as (l_as: ID_AS)
		do
			check_name (l_as.name, l_as)
		end

	check_name (a_name: STRING; a_ast: AST_EIFFEL)
			-- Check if `a_name' is equal to either `setup_before_test_name' or `cleanup_after_test_name'.
		do
			if a_name.is_case_insensitive_equal (setup_before_test_name) then
				before_test_break_point_slot := a_ast.breakpoint_slot
			elseif a_name.is_case_insensitive_equal (cleanup_after_test_name) then
				after_test_break_point_slot := a_ast.breakpoint_slot
			elseif a_name.is_case_insensitive_equal (finish_post_state_calculation_name) then
				finish_post_state_calculation_slot := a_ast.breakpoint_slot
			end
		end

end
