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
			on_removed_item,
			on_event,
			initialize
		end

feature -- Initialization

	initialize is
			-- Initialize `Current'
		local
			target, h_ret: POINTER
		do
			Precursor
			event_id := app_implementation.get_id (current)
			target := get_control_event_target_external( c_object )
			h_ret := app_implementation.install_event_handler ( event_id, target, {CARBONEVENTS_ANON_ENUMS}.keventclasscontrol, {CARBONEVENTS_ANON_ENUMS}.keventcontrolboundschanged )
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

	setup_binding ( upper_control, lower_control : POINTER ) is
			-- Setup Carbon Layout API
		deferred
		end

	carbon_arrange_children is
			-- Setup positioning constraints for all children
		require
			at_least_one_child : count > 0
		deferred
		end

feature -- Event handling

	on_event (a_inhandlercallref, a_inevent, a_inuserdata: POINTER ) : INTEGER is
			-- Called when a Carbon event arrives
		local
			event_class, event_kind : INTEGER_32
			actual_type, actual_size : NATURAL_32
			prev_rect, cur_rect :CGRECT_STRUCT
			attributes : NATURAL_32
			err : INTEGER
		do
			event_class := get_event_class_external (a_inevent)
			event_kind := get_event_kind_external (a_inevent)

			if event_class = {CARBONEVENTS_ANON_ENUMS}.kEventClassControl and event_kind =  {CARBONEVENTS_ANON_ENUMS}.keventcontrolboundschanged then
				create prev_rect.make_new_unshared
				create cur_rect.make_new_unshared
				err := get_event_parameter_external ( a_inevent, {CARBONEVENTS_ANON_ENUMS}.keventparamattributes, {AEDATA_MODEL_ANON_ENUMS}.typeWildCard, $actual_type, 4, $actual_size, $attributes ) -- 4 = sizeof(INTEGER_32)
				err := get_event_parameter_external ( a_inevent, {CARBONEVENTS_ANON_ENUMS}.keventparamoriginalbounds, {CARBONEVENTS_ANON_ENUMS}.typehirect, $actual_type, prev_rect.sizeof, $actual_size, prev_rect.item )
				err := get_event_parameter_external ( a_inevent, {CARBONEVENTS_ANON_ENUMS}.keventparamcurrentbounds, {CARBONEVENTS_ANON_ENUMS}.typehirect, $actual_type, cur_rect.sizeof, $actual_size, cur_rect.item )
				bounds_changed ( attributes, prev_rect, cur_rect )
				Result := noErr -- Event handled
			else
				Result := {CARBON_EVENTS_CORE_ANON_ENUMS}.eventnothandlederr
			end
		end

	bounds_changed ( options : NATURAL_32; original_bounds, current_bounds : CGRECT_STRUCT ) is
			-- Handler for the bounds changed event
		deferred
		end

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
			if count > 0 then
				carbon_arrange_children
			end
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

