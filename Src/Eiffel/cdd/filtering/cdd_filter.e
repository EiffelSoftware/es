indexing
	description: "Objects that filter test classes/routines for a given test suite"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_FILTER

feature {NONE} -- Initialization

	make_with_test_suite (a_test_suite: like test_suite) is
			-- Create a filter for `a_test_suite'.
		require
			a_test_suite_not_void: a_test_suite /= Void
		do
			test_suite := a_test_suite
			create filter_patterns.make
		ensure
			test_suite_set: test_suite = a_test_suite
		end

feature -- Access

	test_suite: CDD_TEST_SUITE
			-- Test suite containing test cases to be filtered

	result_nodes: DS_LINKED_LIST [CDD_FILTER_NODE] is
			-- Selection of test routines according to `filter_text'
			-- represented in a tree structure according to `grouping_text'
		do
			if cached_result_nodes = Void then
			end
			Result := cached_result_nodes
		end

	grouping_code: INTEGER
			-- Code characterising grouping of `result_nodes'

	none_code, cnf_code, outcome_code: INTEGER is unique
			-- Valid codes for `grouping_code'

	is_valid_code (a_code: like grouping_code): BOOLEAN is
			-- Is `a_code' a valid code for `grouping_code'?
		do
			Result := a_code = none_code or a_code = cnf_code or a_code = outcome_code
		end

	filter_patterns: DS_LINKED_LIST [CDD_FILTER_PATTERN]
			-- String characterising `result_nodes'

feature -- Settings

	set_grouping_code (a_code: like grouping_code) is
			-- Set `grouping_code' to `a_code' and clear cached `result_nodes'.
		require
			a_code_valid: is_valid_code (a_code)
		do
			grouping_code := a_code
		ensure
			grouping_code_set: grouping_code = a_code
			cache_cleared: cached_result_nodes = Void
		end

feature {NONE} -- Implementation

	cached_result_nodes: like result_nodes

	internal_refresh_action: PROCEDURE [like Current, TUPLE]



invariant
	test_suite_not_void: test_suite /= Void
	filter_patterns_not_void: filter_patterns /= Void
	grouping_code_vliad: is_valid_code (grouping_code)

end
