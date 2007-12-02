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
			if not is_leaf then
				create children.make
			end
		end

feature -- Access

	is_leaf: BOOLEAN is
			-- Is `Current' a leave within the filter result tree?
		deferred
		end

	children: DS_LINKED_LIST [CDD_FILTER_NODE]
			-- Child nodes of `Current'

	tag: STRING is
			-- Tag describing `Current'
		deferred
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end

feature -- Processing

	process (a_visitor: CDD_FILTER_NODE_VISITOR) is
			-- Call appropriate processor for `Current'.
		require
			a_visitor_not_void: a_visitor /= Void
		deferred
		end

invariant

	tag_not_void: tag /= Void
	children_void_equals_is_leaf: (children = Void) = is_leaf

end
