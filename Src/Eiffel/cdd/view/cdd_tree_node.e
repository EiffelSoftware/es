indexing
	description: "Objects that represent an abstract node of the filter result tree"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CDD_TREE_NODE

feature -- Status

	is_leaf: BOOLEAN is
			-- Is this node a leaf node? Note that a leaf node
			-- can be sibling to an inner node.
		deferred
		end

	failure_count: INTEGER is
			-- Number of test routines failing in subtree
		local
			l_cursor: DS_LINEAR_CURSOR [CDD_TREE_NODE]
		do
			if failure_count_cache < 0 then
				failure_count_cache := 0
				if is_leaf then
					if not test_routine.outcomes.is_empty and then test_routine.outcomes.last.is_fail then
						failure_count_cache := 1
					end
				else
					l_cursor := children.new_cursor
					from
						l_cursor.start
					until
						l_cursor.after
					loop
						failure_count_cache := failure_count_cache + l_cursor.item.failure_count
						l_cursor.forth
					end
				end
			end
			Result := failure_count_cache
		end

feature -- Access

	parent: CDD_TREE_NODE
			-- Parent of this node

	children: DS_LINEAR [like Current] is
			-- Childnodes of this node
			-- NOTE: Has to linked since we might have to insert
			-- or remove nodes during incremental update
		require
			not_leaf: not is_leaf
		do
			Result := internal_children
		ensure
			not_void: Result /= Void
			result_valid: not Result.has (Void)
		end

	tag: STRING
			-- Tag matched by all leaves of this node

	test_routine:  CDD_TEST_ROUTINE is
			-- Test routine associated with this node;
			-- only applies to leaf nodes.
		require
			leaf: is_leaf
		do
		ensure
			not_void: Result /= Void
		end

feature {CDD_TREE_VIEW} -- Implementation

	failure_count_cache: like failure_count
			-- Cache for `failure_count'

	clear_cache is
			-- Set `failure_count_cache' to -1
		do
			failure_count_cache := -1
		end

	internal_children: DS_LINKED_LIST [like Current] is
			-- Internally stored child nodes accessible
			-- by CDD_TREE_VIEW for building the tree.
		require
			not_leaf: not is_leaf
		do
		ensure
			not_void: Result /= Void
			valid: not Result.has (Void)
		end

invariant

	tag_not_void: tag /= Void

end
