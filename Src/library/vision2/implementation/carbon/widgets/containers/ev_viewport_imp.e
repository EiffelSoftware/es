indexing
	description: "Eiffel Vision viewport. Carbon implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_VIEWPORT_IMP

inherit
	EV_VIEWPORT_I
		undefine
			propagate_foreground_color,
			propagate_background_color
		redefine
			interface,
			set_item_width,
			set_item_height
		end

	EV_CELL_IMP
		redefine
			interface,
			make,
			on_removed_item,
			replace
		end

	HIVIEW_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end

	CONTROLDEFINITIONS_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Initialize.
		local
			ret: INTEGER
			rect: RECT_STRUCT
		do
			base_make (an_interface)
			create rect.make_new_unshared
			rect.set_left (20)
			rect.set_right (100)
			rect.set_bottom (40)
			rect.set_top (20)
			ret := create_user_pane_control_external ( null, rect.item, {CONTROLS_ANON_ENUMS}.kControlSupportsEmbedding, $viewport )
			set_c_object ( viewport )
			rect.set_left (20)
			rect.set_right (200)
			rect.set_bottom (100)
			rect.set_top (20)
			ret := create_user_pane_control_external ( null, rect.item, {CONTROLS_ANON_ENUMS}.kControlSupportsEmbedding, $container )
			ret := hiview_set_visible_external (viewport, 1)
			ret := hiview_set_visible_external (container, 1)
			ret := hiview_add_subview_external (viewport, container)
		end

feature -- Access

--	minimum_width: INTEGER is
--			-- Minimum width of widget.
--		do
--		end
--
--	minimum_height: INTEGER is
--			-- Minimum_height of widget.
--		do
--		end

	x_offset: INTEGER is
			-- Horizontal position of viewport relative to `item'.
		do
		end

	y_offset: INTEGER is
			-- Vertical position of viewport relative to `item'.
		do
		end

feature -- Element change

	replace (v: like item) is
			-- Replace `item' with `v'.
		local
			w: EV_WIDGET_IMP
			ret: INTEGER
			root_control_ptr: POINTER
			cfstring: EV_CARBON_CF_STRING
		do
			if not interface.is_empty then
				w ?= interface.item.implementation
				on_removed_item (w)
				check
					item_has_implementation: w /= Void
				end
				ret := hiview_remove_from_superview_external (w.c_object)
				check
					view_removed: ret = 0
				end
				item := void
			end
			if v /= Void then
				w ?= v.implementation
				ret := hiview_add_subview_external ( container, w.c_object )
				get_child_size (container, w.c_object )
				check
					view_added: ret = 0
				end

--				create cfstring.make_unshared (hiview_copy_text_external (w.c_object))
--				print (cfstring.string + " " + w.generator +" attached to ")
--				create cfstring.make_unshared (hiview_copy_text_external (c_object))
--				print (cfstring.string + " " + generator + "%N")

				setup_layout (w)

				on_new_item (w)
				item := v
--				print (current.height.out + " - " +  w.height.out + "%N")
			end
		end


	block_resize_actions is
			-- Block any resize actions that may occur.
		do
		end

	unblock_resize_actions is
			-- Unblock all resize actions.
		do
		end

	set_x_offset (a_x: INTEGER) is
			-- Set `x_offset' to `a_x'.
		do
			internal_set_offset (a_x, -1)
		end

	set_y_offset (a_y: INTEGER) is
			-- Set `y_offset' to `a_y'.
		do
		 internal_set_offset (-1, a_y)
		end

	set_item_size (a_width, a_height: INTEGER) is
			-- Set `a_widget.width' to `a_width'.
			-- Set `a_widget.height' to `a_height'.
		do
			internal_set_item_size (a_width, a_height)
		end

	set_item_width (a_width: INTEGER) is
			-- Set `a_widget.width' to `a_width'.
		do
			internal_set_item_size (a_width, -1)
		end

	set_item_height (a_height: INTEGER) is
			-- Set `a_widget.height' to `a_height'.
		do
			internal_set_item_size (-1, a_height)
		end

feature {NONE} -- Implementation

	get_child_size (a_control, a_child : POINTER) is
			-- What does this do?
		external
			"C inline use <Carbon/Carbon.h>"
		alias
			"[
				{
					HILayoutInfo LayoutInfo;
					LayoutInfo.version = kHILayoutInfoVersionZero;
					
					LayoutInfo.scale.x.toView = $a_child;
					LayoutInfo.scale.x.kind = kHILayoutScaleAbsolute;
					LayoutInfo.scale.x.ratio = 1.1;
					
					LayoutInfo.scale.y.toView = $a_child;
					LayoutInfo.scale.y.kind = kHILayoutScaleAbsolute;
					LayoutInfo.scale.y.ratio = 1.1;
					

					HIViewSetLayoutInfo( $a_control, &LayoutInfo );
					HIViewApplyLayout( $a_control );
				}
			]"
		end

	container_widget: POINTER
			-- Pointer to the event box

	visual_widget: POINTER is
			--
		do
		end

	internal_set_offset (a_x, a_y: INTEGER) is
			local
			item_width, item_height: INTEGER
			w_imp: EV_WIDGET_IMP
			a_rect: CGRECT_STRUCT
			a_size: CGSIZE_STRUCT
			ret: INTEGER
			rect: RECT_STRUCT
			ptr: POINTER
		do
			create a_rect.make_new_unshared

			ret := hiview_get_frame_external ( c_object, a_rect.item )
			create a_size.make_shared ( a_rect.size )


			create rect.make_new_unshared
			ptr := get_control_bounds_external (c_object, rect.item)
			if ((a_x - a_size.width.rounded) > 0) then
				rect.set_right(a_x - a_size.width.rounded)
				rect.set_left (a_x)
			end
			if ((a_y - a_size.height.rounded) > 0) then
				rect.set_top (a_y - a_size.height.rounded)
				rect.set_bottom(a_y)
			end
			set_control_bounds_external (c_object,rect.item)
		end


	internal_set_item_size (a_width, a_height: INTEGER) is
			-- Set `a_widget.width' to `a_width'.
			-- Set `a_widget.height' to `a_height'.
		local
			item_width, item_height: INTEGER
			w_imp: EV_WIDGET_IMP
			a_rect: CGRECT_STRUCT
			a_size: CGSIZE_STRUCT
			ret: INTEGER
		do
			create a_rect.make_new_unshared
			ret := hiview_get_frame_external ( c_object, a_rect.item )
			create a_size.make_shared ( a_rect.size )


			if a_width > 0 then
				a_size.set_width (a_width)
			end

			if a_height > 0 then
				a_size.set_height (a_height)
			end

			w_imp ?= item.implementation
			w_imp.store_minimum_size

			a_rect.set_size (a_size.item)

			ret := hiview_set_frame_external (w_imp.c_object, a_rect.item)
		end

	on_removed_item (an_item_imp: EV_WIDGET_IMP) is
			-- Reset minimum size.
		do
			an_item_imp.set_parent_imp (Void)
		end

	internal_x_offset, internal_y_offset: INTEGER

	internal_set_value_from_adjustment (l_adj: POINTER; a_value: INTEGER) is
			-- Set `value' of adjustment `l_adj' to `a_value'.
		require
			l_adj_not_null: l_adj /= default_pointer
		do

  		end

	viewport: POINTER
			-- Pointer to viewport, used for reuse of adjustment functions from descendants.
	container: POINTER

feature {EV_ANY_I} -- Implementation

	interface: EV_VIEWPORT;

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




end -- class EV_VIEWPORT_IMP

