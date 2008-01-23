indexing
	description: "Objects that represent an abstract node of the filter result tree"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TREE_NODE

create {CDD_TREE_VIEW}
	make, make_leaf, make_with_class, make_with_feature

feature {NONE} -- Initialization

	make (a_tag: like tag) is
			-- Create new node `a_tag' as `tag'.
		require
			a_tag_not_void: a_tag /= Void
		do
			create internal_children.make_default
			tag := a_tag
		ensure
			tag_set: tag = a_tag
		end

	make_leaf (a_test_routine: like test_routine; a_tag: like tag) is
			-- Create new leaf node with `a_test_routine' as
			-- `test_routine' and `a_tag' as `tag'.
		require
			a_test_routine_not_void: a_test_routine /= Void
			a_tag_not_void: a_tag /= Void
		do
			tag := a_tag
			test_routine := a_test_routine
		ensure
			test_routine_set: test_routine = a_test_routine
			tag_set: tag = a_tag
		end

	make_with_class (a_class: like eiffel_class; a_tag: like tag) is
			-- Create new node with `a_class' as
			-- `eiffel_class' and `a_tag' as `tag'.
		require
			a_class_not_void: a_class /= Void
			a_tag_not_void: a_tag /= Void
		do
			make (a_tag)
			eiffel_class := a_class
		ensure
			eiffel_class_set: eiffel_class = a_class
			tag_set: tag = a_tag
		end

	make_with_feature (a_feature: like eiffel_feature; a_tag: like tag) is
			-- Create new node with `a_feature' as
			-- `eiffel_feature' and `a_tag' as `tag'.
		require
			a_feature_not_void: a_feature /= Void
			a_tag_not_void: a_tag /= Void
		do
			make (a_tag)
			eiffel_feature := a_feature
		ensure
			eiffel_feature_set: eiffel_feature = a_feature
			tag_set: tag = a_tag
		end


feature -- Status

	is_leaf: BOOLEAN is
			-- Is this node a leaf node? Note that a leaf node
			-- can be sibling to an inner node.
		do
			Result := test_routine /= Void
		ensure
			definition: Result = (test_routine /= Void)
		end

	test_routine_count: INTEGER is
			-- Number of test routines contained in subtree
		local
			l_cursor: DS_LINEAR_CURSOR [CDD_TREE_NODE]
		do
			if is_leaf then
				Result := 1
			else
				l_cursor := children.new_cursor
				from
					l_cursor.start
				until
					l_cursor.after
				loop
					Result := Result + l_cursor.item.test_routine_count
					l_cursor.forth
				end
			end
		end

	has_test_class: BOOLEAN is
			-- Is `eiffel_class' set?
		do
			Result := eiffel_class /= Void
		ensure
			correct: Result = (eiffel_class /= Void)
		end

	has_feature: BOOLEAN is
			-- Is `eiffel_feature' set?
		do
			Result := eiffel_feature /= Void
		ensure
			correct: Result = (eiffel_feature /= Void)
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

--	NOTE: not sure whether this is used...
--	recursive_children_count: INTEGER is
--			-- Recursive count of `children'
--		local
--			l_cursor: DS_LINEAR_CURSOR [CDD_TREE_NODE]
--		do
--			if not is_leaf then
--				l_cursor := children.new_cursor
--				from
--					l_cursor.start
--				until
--					l_cursor.after
--				loop
--					Result := 1 + l_cursor.item.recursive_children_count
--					l_cursor.forth
--				end
--			end
--		ensure
--			leaf_implies_no_children: is_leaf implies Result = 0
--		end

	tag: STRING
			-- Tag matched by all leaves of this node

	test_routine:  CDD_TEST_ROUTINE
			-- Test routine associated with this node; only applies
			-- to leaf nodes.

	eiffel_class: CLASS_I
			-- Eiffel class associated with this node

	eiffel_feature: FEATURE_I
			-- Eiffel feature associated with this node

feature {CDD_TREE_VIEW} -- Implementation

	internal_children: DS_LINKED_LIST [like Current]
			-- Internally stored child nodes

	set_parent (a_parent: like Current) is
			-- Set `parent' to `a_parent'.
		do
			parent := a_parent
		ensure
			parent_set: parent = a_parent
		end

invariant

	tag_not_void: tag /= Void
	is_leaf_equals_children_void: is_leaf = (internal_children = Void)
	children_doesnt_have_void: (not is_leaf) implies (not internal_children.has (Void))

end
