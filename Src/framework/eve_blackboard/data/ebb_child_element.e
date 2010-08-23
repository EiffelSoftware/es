note
	description: "Data element which has a parent."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EBB_CHILD_ELEMENT [PARENT -> EBB_PARENT_ELEMENT [PARENT, CHILD], CHILD -> EBB_CHILD_ELEMENT [PARENT, CHILD]]

inherit

	EBB_DATA_ELEMENT
		redefine
			set_stale,
			set_fresh
		end

feature -- Access

	parent: detachable PARENT
			-- Parent of this element.

feature -- Element change

	set_parent (a_parent: like parent)
			-- Set `parent' to `a_parent'.
		do
			if attached {CHILD} Current as l_current then
				if attached parent then
					parent.children.prune (l_current)
				end
				parent := a_parent
				if attached parent then
					parent.children.extend (l_current)
				end
			else
				check False end
			end
		ensure
			parent_set: parent = a_parent
		end

feature -- Basic operations

	set_stale
			-- <Precursor>
		do
			Precursor {EBB_DATA_ELEMENT}
			if attached parent as l_parent then
				l_parent.set_stale
			end
		end

	set_fresh
			-- <Precursor>
		do
			Precursor {EBB_DATA_ELEMENT}
			if attached parent as l_parent then
				if across parent.children as l_children all not l_children.item.is_stale end then
					parent.set_fresh
				end
			end
		end

	recalculate_correctness_confidence
			-- <Precursor>
		do
			if attached parent as l_parent then
				l_parent.recalculate_correctness_confidence
			end
		end

end
