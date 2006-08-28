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
			initialize,
			on_event
		end

	HIOBJECT_FUNCTIONS_EXTERNAL

feature {NONE} -- Initialization

	initialize is
		local
			event_array : EVENT_TYPE_SPEC_ARRAY
			target, h_ret : POINTER
		do
			Precursor {EV_CONTAINER_IMP}
			create event_array.make_new_unshared ( 7 )
			event_array.item ( 0 ).set_eventclass ( {CARBONEVENTS_ANON_ENUMS}.kEventClassControl )
			event_array.item ( 0 ).set_eventkind ( {CARBONEVENTS_ANON_ENUMS}.kEventControlDraw )

			event_array.item ( 1 ).set_eventclass ( {CARBONEVENTS_ANON_ENUMS}.kEventClassControl )
			event_array.item ( 1 ).set_eventkind ( {CARBONEVENTS_ANON_ENUMS}.kEventControlHitTest )

			event_array.item ( 2 ).set_eventclass ( {CARBONEVENTS_ANON_ENUMS}.kEventClassControl )
			event_array.item ( 2 ).set_eventkind ( {CARBONEVENTS_ANON_ENUMS}.kEventControlBoundsChanged )

			event_array.item ( 3 ).set_eventclass ( {CARBONEVENTS_ANON_ENUMS}.kEventClassControl )
			event_array.item ( 3 ).set_eventkind ( {CARBONEVENTS_ANON_ENUMS}.kEventControlGetPartRegion )

			event_array.item ( 4 ).set_eventclass ( {CARBONEVENTS_ANON_ENUMS}.kEventClassControl )
			event_array.item ( 4 ).set_eventkind ( {CARBONEVENTS_ANON_ENUMS}.kEventControlGetData )

			event_array.item ( 5 ).set_eventclass ( {CARBONEVENTS_ANON_ENUMS}.kEventClassControl )
			event_array.item ( 5 ).set_eventkind ( {CARBONEVENTS_ANON_ENUMS}.kEventControlSetData )

			event_array.item ( 6 ).set_eventclass ( {CARBONEVENTS_ANON_ENUMS}.kEventClassControl )
			event_array.item ( 6 ).set_eventkind ( {CARBONEVENTS_ANON_ENUMS}.kEventControlTrack )

			target := hiobject_get_event_target_external ( c_object )
			h_ret := app_implementation.install_event_handlers ( event_id, target, event_array )

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

feature {NONE} -- Implementation

	on_event (a_inhandlercallref: POINTER; a_inevent: POINTER; a_inuserdata: POINTER): INTEGER is
			-- Feature that is called if an event occurs
		local
			event_class, event_kind : INTEGER
			actual_type, actual_size : INTEGER_32
			region, context : POINTER
			err : INTEGER
			where : CGPOINT_STRUCT
			part : INTEGER_16
		do
				event_class := get_event_class_external (a_inevent)
				event_kind := get_event_kind_external (a_inevent)

				if event_class = {CARBONEVENTS_ANON_ENUMS}.kEventClassControl then
					if event_kind =  {CARBONEVENTS_ANON_ENUMS}.keventcontroldraw then
						err := get_event_parameter_external ( a_inevent, {CARBONEVENTS_ANON_ENUMS}.keventparamrgnhandle,{CARBONEVENTS_ANON_ENUMS}.typeqdrgnhandle, $actual_type, sizeof(region.item), $actual_size, region.item )
						err := get_event_parameter_external ( a_inevent, {CARBONEVENTS_ANON_ENUMS}.keventparamcgcontextref, {CARBONEVENTS_ANON_ENUMS}.typecgcontextref, $actual_type, sizeof(context.item), $actual_size, context.item)
						draw ( region, context )
						Result := noErr -- event handled
					elseif event_kind =  {CARBONEVENTS_ANON_ENUMS}.keventcontrolhittest then
						create where.make_new_unshared
						err := get_event_parameter_external ( a_inevent, {CARBONEVENTS_ANON_ENUMS}.keventparammouselocation, {CARBONEVENTS_ANON_ENUMS}.typehipoint, $actual_type, where.sizeof, $actual_size, where.item )
						part := hit_test ( where )
						err := set_event_parameter_external ( a_inevent, {CARBONEVENTS_ANON_ENUMS}.keventparamcontrolpart, {CARBONEVENTS_ANON_ENUMS}.typecontrolpartcode, 2, $part ) -- 2 = sizeof(INTEGER_16)
						Result := noErr --event handled
					elseif  event_kind = {CARBONEVENTS_ANON_ENUMS}.keventcontrolgetpartregion then
						err := get_event_parameter_external ( a_inevent, {CARBONEVENTS_ANON_ENUMS}.keventparamcontrolpart, {CARBONEVENTS_ANON_ENUMS}.typecontrolpartcode, $actual_type, 2, $actual_size, $part ) -- 2 = sizeof(INTEGER_16)
						err := get_event_parameter_external ( a_inevent, {CARBONEVENTS_ANON_ENUMS}.keventparamcontrolregion,{CARBONEVENTS_ANON_ENUMS}.typeqdrgnhandle, $actual_type, sizeof(region.item), $actual_size, region.item )
						Result := get_region ( part, region )
					end
				else
					Result := {CARBON_EVENTS_CORE_ANON_ENUMS}.eventnothandlederr
				end
		end

feature {NONE} -- Implementation

	bounds_changed ( options : INTEGER; original_bounds, current_bounds : POINTER ) is
			--
		local

		do

		end

	draw ( limit_rgn, context : POINTER ) is
			-- Draw the splitter
		do

		end

	get_data is
			--
		do

		end

	set_data is
			--
		do

		end

	get_region (  part : INTEGER_16; region : POINTER ) : INTEGER is
			--
		do

		end

	hit_test ( where : CGPOINT_STRUCT ) : INTEGER_16 is
			--
		do

		end

	track ( event :POINTER ) : POINTER is
			--
		do

		end

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

