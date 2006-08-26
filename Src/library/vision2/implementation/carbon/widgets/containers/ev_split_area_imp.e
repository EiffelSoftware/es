indexing
	description:
		"EiffelVision Split Area. Carbon implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	id: "$Id$"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_SPLIT_AREA_IMP

inherit
	EV_SPLIT_AREA_I
		undefine
			propagate_foreground_color,
			propagate_background_color
		redefine
			interface
		end

	EV_CONTAINER_IMP
		undefine
			replace
		redefine
			interface,
			initialize
		end

feature {NONE} -- Initialization

	initialize is
		do
			Precursor {EV_CONTAINER_IMP}

		end

feature -- Access

	split_position: INTEGER is
			-- Position from the left/top of the splitter from `Current'.
		do

		end

	set_first (an_item: like item) is
			-- Make `an_item' `first'.
		local
			item_imp: EV_WIDGET_IMP
		do
			item_imp ?= an_item.implementation
			item_imp.set_parent_imp (Current)
			--{EV_GTK_EXTERNALS}.gtk_paned_pack1 (container_widget, item_imp.c_object, False, False)
			first := an_item
			set_item_resize (first, False)
		end

set_second (an_item: like item) is
			-- Make `an_item' `second'.
		local
			item_imp: EV_WIDGET_IMP
		do
			item_imp ?= an_item.implementation
			item_imp.set_parent_imp (Current)
		--	{EV_GTK_EXTERNALS}.gtk_paned_pack2 (container_widget, item_imp.c_object, True, False)
			second := an_item
			set_item_resize (second, True)
		end

	prune (an_item: like item) is
			-- Remove `an_item' if present from `Current'.
		local
			item_imp: EV_WIDGET_IMP
		do
			if has (an_item) and then an_item /= Void then
				item_imp ?= an_item.implementation
				item_imp.set_parent_imp (Void)
				check item_imp_not_void: item_imp /= Void end
				--{EV_GTK_EXTERNALS}.gtk_container_remove ({EV_GTK_EXTERNALS}.gtk_widget_struct_parent (item_imp.c_object), item_imp.c_object)
				if an_item = first then
					first_expandable := False
					first := Void
					set_split_position (0)
					if second /= Void then
						set_item_resize (second, True)
					end
				else
					second := Void
					second_expandable := True
					if first /= Void then
						set_item_resize (first, True)
					end
				end
			end
		end

	enable_item_expand (an_item: like item) is
			-- Let `an_item' expand when `Current' is resized.
		do

		end

	disable_item_expand (an_item: like item) is
			-- Make `an_item' non-expandable on `Current' resize.
		do
			set_item_resize (an_item, False)
		end

	set_split_position (a_split_position: INTEGER) is
			-- Set the position of the splitter.
		do

		end

feature {NONE} -- Implementation

	splitter_width: INTEGER is 8

	set_item_resize (an_item: like item; a_resizable: BOOLEAN) is
			-- Set whether `an_item' is `a_resizable' when `Current' resizes.
		do
			if an_item = first then
				first_expandable := a_resizable
			else
				second_expandable := a_resizable
			end
			--set_gtk_paned_struct_child1_resize (container_widget, first_expandable)
			--set_gtk_paned_struct_child2_resize (container_widget, second_expandable)
		end

	get_split_view_class : INTEGER is
			-- Register the custom SplitView Class
		local
			event_array : EVENT_TYPE_SPEC_ARRAY
		do
			create event_array.make_new_unshared( 4 )
			event_array.item ( 1 ).set_eventclass ( {HIOBJECT_ANON_ENUMS}.kEventClassHIObject )
			event_array.item ( 1 ).set_eventkind ( {HIOBJECT_ANON_ENUMS}.kEventHIObjectConstruct )

			event_array.item ( 2 ).set_eventclass ( {HIOBJECT_ANON_ENUMS}.kEventClassHIObject )
			event_array.item ( 2 ).set_eventkind ( {HIOBJECT_ANON_ENUMS}.kEventHIObjectDestruct )

			event_array.item ( 3 ).set_eventclass ( {CARBONEVENTS_ANON_ENUMS}.kEventClassControl )
			event_array.item ( 3 ).set_eventkind ( {CARBONEVENTS_ANON_ENUMS}.kEventControlDraw )

			--app_implementation.register_custom_control (inclassid, inbaseclassid: STRING_32, inconstructproc: FUNCTION [ANY, TUPLE [POINTER, POINTER, POINTER], INTEGER_32], ineventlist: EVENT_TYPE_SPEC_ARRAY, outclassref: POINTER)
		end

	--default_event_handler


feature {EV_ANY_I} -- Implementation

	interface: EV_SPLIT_AREA;


indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end -- class EV_SPLIT_AREA_IMP

