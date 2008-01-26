indexing
	description:
		"[
			Objects that represent a node in a tree with
			child nodes created by CDD_TREE_VIEW.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TREE_PARENT_NODE

inherit
	
	CDD_TREE_NODE
		redefine
			internal_children
		end

create {CDD_TREE_VIEW}
	make

feature {NONE} -- Initialization

	make (a_tag: like tag; a_parent: like parent) is
			-- Initialize `Current' with `a_tag' and `a_parent'.
			-- Note: `a_parent' can be Void if `Current' is root
			-- node in tree.
		require
			a_tag_not_void: a_tag /= Void
		do
			tag := a_tag
			parent := a_parent
			create internal_children.make
		ensure
			tag_set: tag = a_tag
			parent_set: parent = a_parent
		end

feature -- Access

	is_leaf: BOOLEAN is False
			-- Is this node a leaf node? Note that a leaf node
			-- can be sibling to an inner node.

feature {CDD_TREE_VIEW} -- Access

	internal_children: DS_LINKED_LIST [like Current]
			-- Internally stored child nodes accessible
			-- by CDD_TREE_VIEW for building the tree.

invariant
	internal_children_not_void: internal_children /= Void
	internal_children_valid: not internal_children.has (Void)

end
