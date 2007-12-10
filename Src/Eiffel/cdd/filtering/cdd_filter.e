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

	nodes: DS_LINEAR [CDD_FILTER_NODE] is
			-- Test routines from `test_suite' matching the criteria from
			-- `filters'.
		do
			if cached_nodes = Void then
				-- TODO: Implement
			end
			Result := cached_nodes
		ensure
			nodes_not_void: Result /= Void
			nodes_doesnt_have_void: not Result.has (Void)
		end

	filters: DS_LINEAR [STRING]
			-- List of tag patterns, restricting what routines should
			-- be in this view of the test suite.

feature {NONE} -- Implementation

	cached_nodes: like nodes
			-- Cache for `nodes'

	internal_refresh_action: PROCEDURE [like Current, TUPLE]
			-- Agent subscribed in test suite. Needed for
			-- unsubscription.

invariant

	test_suite_not_void: test_suite /= Void
	filters_not_void: filters /= Void
	filters_doesnt_have_void: not filters.has (Void)

end
