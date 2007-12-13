indexing
	description: "Objects that filter test classes/routines for a given test suite"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_FILTER

create
	make

feature {NONE} -- Initialization

	make (a_test_suite: like test_suite) is
			-- Create a filter for `a_test_suite'.
		require
			a_test_suite_not_void: a_test_suite /= Void
		do
			test_suite := a_test_suite
			create filters.make_default
		ensure
			test_suite_set: test_suite = a_test_suite
		end

feature {ANY} -- Status Report

	is_matching_routine (a_routine: CDD_TEST_ROUTINE): BOOLEAN is
			-- Does `a_routine' satisfy the filter criteria of
			-- this filter?
		require
			a_routine_not_void: a_routine /= Void
		do
			-- TODO: Implement proper check
			Result := True
		end

feature {ANY} -- Access

	test_suite: CDD_TEST_SUITE
			-- Test suite containing test cases to be filtered

	nodes: DS_LINEAR [CDD_FILTER_NODE] is
			-- Test routines from `test_suite' matching the criteria from
			-- `filters'.
		do
			if nodes_cache = Void then
				update_nodes_cache
			end
			Result := nodes_cache
		ensure
			nodes_not_void: Result /= Void
			nodes_doesnt_have_void: not Result.has (Void)
		end

	filters: DS_ARRAYED_LIST [STRING]
			-- List of tag patterns, restricting what routines should
			-- be in this view of the test suite.

feature {NONE} -- Implementation

	nodes_cache: DS_ARRAYED_LIST [CDD_FILTER_NODE]
			-- Cache for `nodes'

	internal_refresh_action: PROCEDURE [like Current, TUPLE]
			-- Agent subscribed in test suite. Needed for
			-- unsubscription.

	update_nodes_cache is
			-- Update `nodes_cache' with information from `test_suite'.
		local
			class_cs: DS_LINEAR_CURSOR [CDD_TEST_CLASS]
			routine_cs: DS_LINEAR_CURSOR [CDD_TEST_ROUTINE]
			root_node: CDD_FILTER_NODE
			node: CDD_FILTER_NODE
		do
			from
				class_cs := test_suite.test_classes.new_cursor
				class_cs.start
				create nodes_cache.make_default
				create root_node.make
				-- TODO: Implement grouping of test routines into a node tree based on
				-- a grouping criterion.
				nodes_cache.force_last (root_node)
			until
				class_cs.off
			loop
				from
					routine_cs := class_cs.item.test_routines.new_cursor
					routine_cs.start
				until
					routine_cs.off
				loop
					if is_matching_routine (routine_cs.item) then
						create node.make_leaf (routine_cs.item)
						root_node.children.force_last (node)
					end
					routine_cs.forth
				end
				class_cs.forth
			end
		end

	wipe_out_nodes_cache is
			-- Remove all entries from nodes cache.
		do
			nodes_cache := Void
		ensure
			nodes_cache_void: nodes_cache = Void
		end

invariant

	test_suite_not_void: test_suite /= Void
	filters_not_void: filters /= Void
	filters_doesnt_have_void: not filters.has (Void)

end
