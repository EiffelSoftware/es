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
			create result_nodes.make
		ensure
			test_suite_set: test_suite = a_test_suite
		end

feature -- Access

	test_suite: CDD_TEST_SUITE
			-- Test suite containing test cases to be filtered

	result_nodes: DS_LINKED_LIST [CDD_FILTER_NODE]
			-- Selection of test routines according to `filter_text'
			-- represented in a tree structure according to `grouping_text'

	grouping_text: STRING
			-- String characterising grouping of `result_nodes'

	filter_text: STRING
			-- String characterising `result_nodes'

feature -- Settings

	set_grouping_text (a_text: like grouping_text) is
			-- Set `grouping_text' to `a_text' and reevaluate `result_nodes'.
		require
			a_text_not_void: a_text /= Void
		do
			grouping_text := a_text
		ensure
			grouping_text_set: grouping_text = a_text
		end

	set_filter_text (a_text: like filter_text) is
			-- Set `filter_text' to `a_text' and reevaluate `result_nodes'.
		require
			a_text_nod_void: a_text /= Void
		do
			filter_text := a_text
		ensure
			filter_text_not_void: filter_text /= Void
		end

feature {NONE} -- Implementation

	internal_result_nodes: like result_nodes

invariant
	test_suite_not_void: test_suite /= Void
	result_nodes_not_void: result_nodes /= Void
	filter_text_not_void: filter_text /= Void
	grouping_text_not_void: grouping_text /= Void

end
