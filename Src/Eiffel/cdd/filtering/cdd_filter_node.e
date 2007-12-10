indexing
	description: "Objects that represent an abstract node of the filter result tree"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CDD_FILTER_NODE

feature {NONE} -- Initialization

	initialize is
			-- Initialize `Current'.
		do
			create children.make
		end

feature -- Status

	is_leaf: BOOLEAN is
			-- Is this node a leaf node?
		do
			Result := children.is_empty
		ensure
			definition: Result = children.is_empty0
		end

feature -- Access

	children: DS_LINEAR [CDD_FILTER_NODE]
			-- Childnodes of this node

	tag: STRING is
			-- Tag matched by all leaves of this node
		deferred
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end

	test_routine:  CDD_TEST_ROUTINE
			-- Test routine associated with this node; only applies
			-- to leaf nodes.
invariant

	tag_not_void: tag /= Void
	children_not_void: children /= Void
	children_doesnt_have_void: not children.has (Void)
	test_routine_validity: not is_leaf implies (test_routine = Void)

end
