indexing
	description: "Objects that represent a tree node for classes"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_CLASS_NODE

inherit

	CDD_FILTER_NODE

feature {NONE} -- Initialization

	make_with_class (a_class: like eclass) is
			-- Create a class node for `a_class'.
		require
			a_class_not_void: a_class /= Void
		do
			initialize
			eclass := a_class
		ensure
			eclass_set: eclass = a_class
		end

feature -- Access

	is_leaf: BOOLEAN is False
			-- Is `Current' a leave within the filter result tree?

	eclass: EIFFEL_CLASS_I
			-- Eiffel class represented by `Current'

	tag: STRING is
			-- Tag for describing `Current'
		do
			Result := eclass.name
		end

feature -- Processing

	process (a_visitor: CDD_FILTER_NODE_VISITOR) is
			-- Call appropriate processor for `Current'.
		do
			a_visitor.process_class_node (Current)
		end

invariant

	class_not_void: eclass /= Void

end
