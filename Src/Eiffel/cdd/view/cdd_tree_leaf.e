indexing
	description:
		"[
			Objects that represent a leaf in a tree created
			by CDD_TREE_VIEW. All paths of the tree end with
			a leaf in which a test routine is stored.
		]"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TREE_LEAF

inherit

	CDD_TREE_NODE
		redefine
			test_routine
		end

create {CDD_TREE_VIEW}
	make

feature {NONE} -- Initialization

	make (a_tag: like tag; a_routine: like test_routine; a_parent: like parent) is
			-- Initialize `Current' with `a_tag', `a_routine' and
			-- `a_parent'. Note: `a_parent' can be Void if `Current'
			-- is root node in tree.
		require
			a_tag_not_void: a_tag /= Void
			a_routine_not_void: a_routine /= Void
		do
			tag := a_tag
			parent := a_parent
			test_routine := a_routine
			clear_cache
		ensure
			tag_set: tag = a_tag
			test_routine_set: test_routine = a_routine
			parent_set: parent = a_parent
		end

feature -- Access

	is_leaf: BOOLEAN is True
			-- Is this node a leaf node? Note that a leaf node
			-- can be sibling to an inner node.

	test_routine: CDD_TEST_ROUTINE
			-- Test routine associated with this node;
			-- only applies to leaf nodes.

invariant
	test_routine_not_void: test_routine /= Void

end
