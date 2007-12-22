indexing
	description: "Objects that represent an abstract node of the filter result tree"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TREE_NODE

create
	make, make_leaf

feature {NONE} -- Initialization

	make is
			-- Create new non leaf node.
		do
			create children.make_default
		end

	make_leaf (a_test_routine: like test_routine) is
			-- Create new leaf node with `a_test_routine' as
			-- `test_routine'. Set `tag' to the name of
			-- `test_routine'.
		require
			a_test_routine_not_void: a_test_routine /= Void
		do
			test_routine := a_test_routine
			tag := test_routine.test_class.test_class.name_in_upper + "." + test_routine.name
			create children.make (0)
		ensure
			test_routine_set: test_routine = a_test_routine
		end

feature -- Status

	is_leaf: BOOLEAN is
			-- Is this node a leaf node?
		do
			Result := children.is_empty
		ensure
			definition: Result = children.is_empty
		end

feature -- Access

	children: DS_ARRAYED_LIST [CDD_TREE_NODE]
			-- Childnodes of this node

	recursive_children_count: INTEGER is
			-- Recursive count of `children'
		local
			l_cursor: DS_LINEAR_CURSOR [CDD_TREE_NODE]
		do
			if not is_leaf then
				l_cursor := children.new_cursor
				from
					l_cursor.start
				until
					l_cursor.after
				loop
					Result := 1 + l_cursor.item.recursive_children_count
					l_cursor.forth
				end
			end
		ensure
			leaf_implies_no_children: is_leaf implies Result = 0
		end

	tag: STRING
			-- Tag matched by all leaves of this node

	test_routine:  CDD_TEST_ROUTINE
			-- Test routine associated with this node; only applies
			-- to leaf nodes.

invariant

	tag_not_void: tag /= Void
	children_not_void: children /= Void
	children_doesnt_have_void: not children.has (Void)
	test_routine_validity: not is_leaf implies (test_routine = Void)

end
