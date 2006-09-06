indexing
	description:
		"EiffelVision box. Carbon implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	id: "$Id$"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_BOX_IMP

inherit
	EV_BOX_I
		undefine
			propagate_foreground_color,
			propagate_background_color
		redefine
			interface
		end

	EV_WIDGET_LIST_IMP
		redefine
			interface,
			on_new_item,
			on_removed_item
		end

feature -- Access

	is_homogeneous: BOOLEAN
			-- Are all children restricted to be the same size?

	border_width: INTEGER
			-- Width of border around container in pixels.

	padding: INTEGER
			-- Space between children in pixels.		

feature {EV_ANY, EV_ANY_I} -- Status report

	is_item_expanded (child: EV_WIDGET): BOOLEAN is
			-- Is `child' expanded to occupy available spare space?
		local
			w_imp : EV_WIDGET_IMP
		do
			w_imp ?= child.implementation
			check
				w_imp_not_void : w_imp /= Void
			end
			Result := w_imp.expandable
		end

feature {EV_ANY, EV_ANY_I} -- Status settings

	set_homogeneous (flag: BOOLEAN) is
			-- Set whether every child is the same size.
		do
			is_homogeneous := flag
			carbon_arrange_children
		end

	set_border_width (value: INTEGER) is
			 -- Assign `value' to `border_width'.
		do
				border_width := value
		end

	set_padding (value: INTEGER) is
			-- Assign `value' to `padding'.
		do
			padding := value
			if count > 0 then
				carbon_arrange_children
			end
		end

	set_child_expandable (child: EV_WIDGET; flag: BOOLEAN) is
			-- Set whether `child' expands to fill available spare space.
		local
			w_imp : EV_WIDGET_IMP
		do
			w_imp ?= child.implementation
			check
				w_imp_not_void : w_imp /= Void
			end
			if flag /= w_imp.expandable then
				if flag then
					expandable_item_count := expandable_item_count + 1
				else
					expandable_item_count := expandable_item_count - 1
				end
			end
			w_imp.set_expandable ( flag )
			carbon_arrange_children
		end

feature {NONE} -- Carbon implementation

	expandable_item_count : INTEGER

	setup_binding ( upper_control, lower_control, a_dummy_control : POINTER; a_count : INTEGER; is_expandable : BOOLEAN ) is
			-- Setup Carbon Layout API
		deferred
		end

	setup_dummy_control ( a_control: POINTER ) is
			-- Setup dummy control for size constraints
		deferred
		end

	carbon_arrange_children is
			-- Setup positioning constraints for all children
		require
			at_least_one_child : count > 0
		deferred
		end

feature -- Event handling

	on_new_item (an_item_imp: EV_WIDGET_IMP) is
			-- Called after a new item is added
		do
			Precursor ( an_item_imp )
			an_item_imp.set_expandable ( True )
			expandable_item_count := expandable_item_count + 1
			carbon_arrange_children
		end

	on_removed_item (an_item_imp: EV_WIDGET_IMP) is
			-- Called just before `an_item' is removed.
		do
			Precursor ( an_item_imp )
			if  an_item_imp.expandable then
				expandable_item_count := expandable_item_count - 1
			end
			carbon_arrange_children
		end


feature {EV_ANY_I, EV_ANY} -- Implementation

	interface: EV_BOX;
			-- Provides a common user interface to platform dependent
			-- functionality implemented by `Current'

invariant
	expandable_item_count_correct : expandable_item_count >= 0 and expandable_item_count <= count

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end -- class EV_BOX_IMP

