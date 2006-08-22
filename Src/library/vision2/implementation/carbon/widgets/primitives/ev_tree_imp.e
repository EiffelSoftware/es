indexing
	description:
		"EiffelVision Tree, Carbon implementation"
	legal: "See notice at end of class."
	status: "See notice at end of class.";
	date: "$Date$";
	revision: "$Revision$"

class
	EV_TREE_IMP

inherit
	EV_TREE_I
		redefine
			interface,
			initialize,
			call_pebble_function,
			append
		end

	EV_PRIMITIVE_IMP
		redefine
			interface,
			initialize,
			call_button_event_actions,
			create_pointer_motion_actions,
			set_to_drag_and_drop,
			able_to_transport,
			ready_for_pnd_menu,
			disable_transport,
			on_mouse_button_event,
			pre_pick_steps,
			post_drop_steps,
			call_pebble_function,
			on_pointer_motion
		end

	EV_ITEM_LIST_IMP [EV_TREE_NODE]
		redefine
			interface,
			insert_i_th,
			remove_i_th,
			append,
			initialize
		end

	EV_TREE_ACTION_SEQUENCES_IMP

	EV_PND_DEFERRED_ITEM_PARENT

	CONTROLDEFINITIONS_FUNCTIONS_EXTERNAL
	CARBONEVENTS_FUNCTIONS_EXTERNAL

create
	make

feature {NONE} -- Initialization

	needs_event_box: BOOLEAN is True

	make (an_interface: like interface) is
			-- Create an empty Tree.
		local
			ptr: POINTER
			rect : RECT_STRUCT
			ret: INTEGER
			window: EV_WINDOW_IMP
		do
			base_make (an_interface)

			-- Fix Problems: A DataBrowser Control does not follow the standard hirarchical widgets idea, but is attached directly to the window: UGLY!
			create rect.make_new_unshared
			rect.set_left(20)
			rect.set_right(100)
			rect.set_bottom(40)
			rect.set_top (20)
--			app_implementation.windows.start
--			window ?= app_implementation.windows.item.implementation -- HACK
--			ret := create_data_browser_control_external (window.c_object, rect.item, {CONTROLDEFINITIONS_ANON_ENUMS}.kDataBrowserListView, $ptr)
--			set_c_object (ptr)
			set_c_object ($current)
		end

	call_selection_action_sequences is
			-- Call the appropriate selection action sequences
		local
			a_selected_item: EV_TREE_NODE
			a_selected_item_imp: EV_TREE_NODE_IMP
			previous_selected_item_imp: EV_TREE_NODE_IMP
		do
			a_selected_item := selected_item

			if a_selected_item /= previous_selected_item then
				if previous_selected_item /= Void then
					previous_selected_item_imp ?= previous_selected_item.implementation
					if previous_selected_item_imp.deselect_actions_internal /= Void then
						previous_selected_item_imp.deselect_actions_internal.call (Void)
					end
					if deselect_actions_internal /= Void then
						deselect_actions_internal.call (Void)
					end
				end
				if a_selected_item /= Void then
					a_selected_item_imp ?= a_selected_item.implementation
					if a_selected_item_imp.select_actions_internal /= Void then
						a_selected_item_imp.select_actions_internal.call (Void)
					end
					if select_actions_internal /= Void then
						select_actions_internal.call (Void)
					end
				end
			end
			previous_selected_item := a_selected_item
		end

	initialize is
			-- Connect action sequences to signals.
		do
			Precursor {EV_ITEM_LIST_IMP}
			Precursor {EV_PRIMITIVE_IMP}
			Precursor {EV_TREE_I}
		end

	create_pointer_motion_actions: EV_POINTER_MOTION_ACTION_SEQUENCE is
			-- Create a pointer_motion action sequence.
		do
--			create Result
		end

	call_button_event_actions (
			a_type: INTEGER;
			a_x, a_y, a_button: INTEGER;
			a_x_tilt, a_y_tilt, a_pressure: DOUBLE;
			a_screen_x, a_screen_y: INTEGER)
		is

		do

		end

	on_pointer_motion (a_motion_tuple: TUPLE [INTEGER, INTEGER, DOUBLE, DOUBLE, DOUBLE, INTEGER, INTEGER]) is
		do
		end

feature -- Status report

	selected_item: EV_TREE_NODE is
			-- Item which is currently selected
		do
		end

	node_from_tree_path (a_tree_path: POINTER): EV_TREE_NODE_IMP is
			-- Retrieve node from `a_tree_path'
		do

		end

	selected: BOOLEAN is
			-- Is one item selected?
		do

		end

feature -- Implementation

	ensure_item_visible (an_item: EV_TREE_NODE) is

		do

		end

	set_to_drag_and_drop: BOOLEAN is
		do
		end

	able_to_transport (a_button: INTEGER): BOOLEAN is
			-- Is list or row able to transport PND data using `a_button'.
		do

		end

	ready_for_pnd_menu (a_button: INTEGER): BOOLEAN is
			-- Is list or row able to display PND menu using `a_button'
		do

		end

	disable_transport is
		do

		end

	update_pnd_status is
			-- Update PND status of list and its children.
--		local
--			a_enable_flag: BOOLEAN
--			i: INTEGER
--			a_cursor: CURSOR
--			a_tree_node_imp: EV_TREE_NODE_IMP
--			l_child_array: like child_array
		do
--			from
--				a_cursor := child_array.cursor
--				l_child_array := child_array
--				l_child_array.start
--				i := 1
--			until
--				i > l_child_array.count or else a_enable_flag
--			loop
--				l_child_array.go_i_th (i)
--				if l_child_array.item /= Void then
--					a_tree_node_imp ?= l_child_array.item.implementation
--					a_enable_flag := a_tree_node_imp.is_transport_enabled_iterator
--				end
--				i := i + 1
--			end
--			l_child_array.go_to (a_cursor)
--			update_pnd_connection (a_enable_flag)
		end

	update_pnd_connection (a_enable: BOOLEAN) is
			-- Update the PND connection status for `Current'.
		do
--			if not is_transport_enabled then
--				if a_enable or pebble /= Void then
--					is_transport_enabled := True
--				end
--			elseif not a_enable and pebble = Void then
--				is_transport_enabled := False
--			end
		end

	on_mouse_button_event (
			a_type: INTEGER
			a_x, a_y, a_button: INTEGER;
			a_x_tilt, a_y_tilt, a_pressure: DOUBLE;
			a_screen_x, a_screen_y: INTEGER)
		is
			-- Initialize a pick and drop transport.
		do
--			pnd_row_imp := row_from_y_coord (a_y)
--
--			if pnd_row_imp /= Void and then not pnd_row_imp.able_to_transport (a_button) then
--				pnd_row_imp := Void
--			end
--			Precursor (
--				a_type,
--				a_x, a_y, a_button,
--				a_x_tilt, a_y_tilt, a_pressure,
--				a_screen_x, a_screen_y
--			)
		end

	pnd_row_imp: EV_TREE_NODE_IMP
			-- Implementation object of the current row if in PND transport.

	temp_pebble: ANY
			-- Temporary pebble holder used for PND implementation with nodes.

	temp_pebble_function: FUNCTION [ANY, TUPLE [], ANY]
			-- Returns data to be transported by PND mechanism.

	temp_accept_cursor, temp_deny_cursor: EV_CURSOR

	call_pebble_function (a_x, a_y, a_screen_x, a_screen_y: INTEGER) is
			-- Set `pebble' using `pebble_function' if present.
		do
--			temp_pebble := pebble
--			temp_pebble_function := pebble_function
--			if pnd_row_imp /= Void then
--				pebble := pnd_row_imp.pebble
--				pebble_function := pnd_row_imp.pebble_function
--			end
--
--			if pebble_function /= Void then
--				pebble_function.call ([a_x, a_y]);
--				pebble := pebble_function.last_result
--			end
		end

	pre_pick_steps (a_x, a_y, a_screen_x, a_screen_y: INTEGER) is
			-- Steps to perform before transport initiated.
		do
--			temp_accept_cursor := accept_cursor
--			temp_deny_cursor := deny_cursor
--			App_implementation.on_pick (pebble)
--
--			if pnd_row_imp /= Void then
--				if pnd_row_imp.pick_actions_internal /= Void then
--					pnd_row_imp.pick_actions_internal.call ([a_x, a_y])
--				end
--				accept_cursor := pnd_row_imp.accept_cursor
--				deny_cursor := pnd_row_imp.deny_cursor
--			else
--				if pick_actions_internal /= Void then
--					pick_actions_internal.call ([a_x, a_y])
--				end
--			end
--
--			pointer_x := a_screen_x
--			pointer_y := a_screen_y
--
--			if pnd_row_imp = Void then
--				if (pick_x = 0 and then pick_y = 0) then
--					App_implementation.set_x_y_origin (a_screen_x, a_screen_y)
--				else
--					if pick_x > width then
--						pick_x := width
--					end
--					if pick_y > height then
--						pick_y := height
--					end
--					App_implementation.set_x_y_origin (pick_x + (a_screen_x - a_x), pick_y + (a_screen_y - a_y))
--				end
--			else
--				if (pnd_row_imp.pick_x = 0 and then pnd_row_imp.pick_y = 0) then
--					App_implementation.set_x_y_origin (a_screen_x, a_screen_y)
--				else
--					if pick_x > width then
--						pick_x := width
--					end
--					if pick_y > row_height then
--						pick_y := row_height
--					end
--					App_implementation.set_x_y_origin (
--						pnd_row_imp.pick_x + (a_screen_x - a_x),
--						pnd_row_imp.pick_y +
--						(a_screen_y - a_y) +
--						((child_array.index_of (pnd_row_imp.interface, 1) - 1) * row_height)
--					)
--				end
--			end
		end

	post_drop_steps (a_button: INTEGER)  is
			-- Steps to perform once an attempted drop has happened.
		do
--			App_implementation.set_x_y_origin (0, 0)
--			last_pointed_target := Void
--
--			if pebble_function /= Void then
--				if pnd_row_imp /= Void then
--					pnd_row_imp.set_pebble_void
--				else
--					temp_pebble := Void
--				end
--			end
--
--			accept_cursor := temp_accept_cursor
--			deny_cursor := temp_deny_cursor
--			pebble := temp_pebble
--			pebble_function := temp_pebble_function
--
--			temp_pebble := Void
--			temp_pebble_function := Void
--			temp_accept_cursor := Void
--			temp_deny_cursor := Void
--
--			pnd_row_imp := Void
		end

feature {EV_TREE_NODE_IMP}

	row_from_y_coord (a_y: INTEGER): EV_TREE_NODE_IMP is
			-- Returns the row index at relative coordinate `a_y'.
		local
--			a_tree_path, a_tree_column: POINTER
--			a_success: BOOLEAN
--			a_int_ptr: POINTER
--			mp: MANAGED_POINTER
--			a_depth: INTEGER
--			a_tree_node_imp: EV_TREE_NODE_IMP
--			i: INTEGER
--			current_depth_index: INTEGER
		do
--			a_success := {EV_GTK_DEPENDENT_EXTERNALS}.gtk_tree_view_get_path_at_pos (tree_view, 1, a_y, $a_tree_path, $a_tree_column, NULL, NULL)
--			if a_success then
--				a_int_ptr := {EV_GTK_DEPENDENT_EXTERNALS}.gtk_tree_path_get_indices (a_tree_path)
--				a_depth := {EV_GTK_DEPENDENT_EXTERNALS}.gtk_tree_path_get_depth (a_tree_path)
--				from
----					create mp.share_from_pointer (a_int_ptr, app_implementation.integer_bytes * a_depth)
--					current_depth_index := mp.read_integer_32 (0) + 1
--					a_tree_node_imp ?= child_array.i_th (current_depth_index).implementation
--					i := 1
--				until
--					i = a_depth
--				loop
----					current_depth_index := mp.read_integer_32 (i * app_implementation.integer_bytes) + 1
--					a_tree_node_imp ?= a_tree_node_imp.child_array.i_th (current_depth_index).implementation
--					i := i + 1
--				end
--				Result := a_tree_node_imp
--				{EV_GTK_DEPENDENT_EXTERNALS}.gtk_tree_path_free (a_tree_path)
--			end
		end

feature {NONE} -- Implementation

	previous_selected_item: EV_TREE_NODE
			-- Item that was selected previously.

	append (s: SEQUENCE [EV_TREE_ITEM]) is
			-- Add 's' to 'Current'
		do
			Precursor (s)
		end

	insert_i_th (v: like item; i: INTEGER) is
			-- Insert `v' at position `i'.
		local
			item_imp: EV_TREE_NODE_IMP
		do
			item_imp ?= v.implementation
			item_imp.set_parent_imp (Current)

			child_array.go_i_th (i)
			child_array.put_left (v)

--			item_imp.add_item_and_children_to_parent_tree (Current, Void, i)
--			update_row_pixmap (item_imp)
--			item_imp.remove_internal_text
--
--			if item_imp.is_transport_enabled_iterator then
--				update_pnd_connection (True)
--			end
		end

	remove_i_th (a_position: INTEGER) is
			-- Remove item at `a_position'
		local
			item_imp: EV_TREE_NODE_IMP
		do
			item_imp ?= (child_array @ (a_position)).implementation
--				-- Remove from tree if present
--			item_imp.set_internal_text (get_text_from_position (item_imp))
--			{EV_GTK_EXTERNALS}.gtk_tree_store_remove (tree_store, item_imp.list_iter.item)
			item_imp.set_parent_imp (Void)
			child_array.go_i_th (a_position)
			child_array.remove
--			update_pnd_status
		end

feature {EV_TREE_NODE_IMP} -- Implementation

	get_text_from_position (a_tree_node_imp: EV_TREE_NODE_IMP): STRING_32 is
			-- Retrieve cell text from `a_tree_node_imp`
		do
--			a_g_value_string_struct := g_value_string_struct
--			{EV_GTK_DEPENDENT_EXTERNALS}.g_value_unset (a_g_value_string_struct)
--			{EV_GTK_DEPENDENT_EXTERNALS}.gtk_tree_model_get_value (tree_store, a_tree_node_imp.list_iter.item, 1, a_g_value_string_struct)
--			a_string := {EV_GTK_DEPENDENT_EXTERNALS}.g_value_get_string (a_g_value_string_struct)
--			if a_string /= default_pointer then
--				a_cs := App_implementation.reusable_gtk_c_string
--				a_cs.share_from_pointer ({EV_GTK_DEPENDENT_EXTERNALS}.g_value_get_string (a_g_value_string_struct))
--				Result := a_cs.string
--			else
--				Result := ""
--			end
		end

	set_text_on_position (a_tree_node_imp: EV_TREE_NODE_IMP; a_text: STRING_GENERAL) is
			-- Set cell text at to `a_text'.
		do
		end

	update_row_pixmap (a_tree_node_imp: EV_TREE_NODE_IMP) is
			-- Set the pixmap for `a_tree_node_imp'.
		do
		end

	tree_store: POINTER
		-- Gtk Model use for storing tree data	

	set_row_height (value: INTEGER) is
			-- Make `value' the new height of all the rows.
		local
			a_column_ptr, a_cell_rend_list, a_cell_rend: POINTER
			a_vert_sep: INTEGER
		do
--			a_column_ptr := {EV_GTK_DEPENDENT_EXTERNALS}.gtk_tree_view_get_column (tree_view, 0)
--			a_cell_rend_list := {EV_GTK_DEPENDENT_EXTERNALS}.gtk_tree_view_column_get_cell_renderers (a_column_ptr)
--			a_cell_rend := {EV_GTK_EXTERNALS}.g_list_nth_data (a_cell_rend_list, 0)
--
--			a_gtk_c_str := "vertical-separator"
--			{EV_GTK_DEPENDENT_EXTERNALS}.gtk_widget_style_get_integer (tree_view, a_gtk_c_str.item, $a_vert_sep)
--
--			a_gtk_c_str := "height"
--			{EV_GTK_DEPENDENT_EXTERNALS}.g_object_set_integer (a_cell_rend, a_gtk_c_str.item, value - a_vert_sep)
--			{EV_GTK_EXTERNALS}.g_list_free (a_cell_rend_list)
		end

	row_height: INTEGER is
			-- Height of rows in `Current'
		do
		end

feature {NONE} -- Implementation

	pixmaps_size_changed is
			-- The size of the displayed pixmaps has just
			-- changed.
		do
			--| FIXME IEK Add pixmap scaling code with gtk+ 2
			--| For now, do nothing.
		end

--	new_tree_store: POINTER is
--			-- New instance of a tree store.
--		external
--			"C inline use <gtk/gtk.h>"
--		alias
--			"gtk_tree_store_new (2, GDK_TYPE_PIXBUF, G_TYPE_STRING)"
--		end

feature {EV_ANY_I} -- Implementation

	interface: EV_TREE;

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end -- class EV_TREE_IMP

