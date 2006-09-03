indexing
	description:
		"EiffelVision multi-column-list, implementation interface."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_MULTI_COLUMN_LIST_IMP

inherit
	EV_MULTI_COLUMN_LIST_I
		redefine
			interface,
			initialize,
			call_pebble_function,
			wipe_out,
			pixmaps_size_changed,
			remove_row_pixmap
		end

	EV_PRIMITIVE_IMP
		redefine
			disable_transport,
			pre_pick_steps,
			call_pebble_function,
			post_drop_steps,
			on_mouse_button_event,
			initialize,
			interface,
			destroy,
			able_to_transport,
			ready_for_pnd_menu,
			set_to_drag_and_drop,
			create_pointer_motion_actions,
			on_pointer_motion
		end

	EV_ITEM_LIST_IMP [EV_MULTI_COLUMN_LIST_ROW]
		redefine
			i_th,
			count,
			insert_i_th,
			remove_i_th,
			destroy,
			interface,
			wipe_out,
			initialize
		end

	EV_MULTI_COLUMN_LIST_ACTION_SEQUENCES_IMP

	EV_PND_DEFERRED_ITEM_PARENT

	EV_CARBON_DATABROWSER
		undefine
			destroy
		redefine
			make,
			initialize,
			interface,
			insert_i_th
		end

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Create a list widget with `par' as
			-- parent and `col_nb' columns.
			-- By default, a list allow only one selection.
		do
			Precursor {EV_CARBON_DATABROWSER} (an_interface)

			create ev_children.make (0)
		end

	initialize is
			-- Initialize `Current'
		local
			l_release_actions: EV_POINTER_BUTTON_ACTION_SEQUENCE
		do
			Precursor {EV_ITEM_LIST_IMP}
			Precursor {EV_PRIMITIVE_IMP}
			Precursor {EV_MULTI_COLUMN_LIST_I}
			resize_model_if_needed (25)
				-- Create our model with 25 columns to avoid recomputation each time the column count increases
			create_list (2)

			previous_selection := selected_items
			initialize_pixmaps
			disable_multiple_selection

				-- Needed so that we can query if the mouse button is down for column resize actions
			l_release_actions := pointer_button_release_actions
		end

feature {NONE} -- Implementation

	call_selection_action_sequences is
			-- Call appropriate selection and deselection action sequences
		do
		end

	previous_selection: ARRAYED_LIST [EV_MULTI_COLUMN_LIST_ROW]
		-- Previous selection of `Current'

	create_pointer_motion_actions: EV_POINTER_MOTION_ACTION_SEQUENCE is
			-- Create a pointer_motion action sequence.
		do
			create Result
		end

feature {NONE} -- Implementation

	call_selection_actions (clicked_row: EV_MULTI_COLUMN_LIST_ROW_IMP) is
			-- Call the selections actions for `clicked_row'
		do
			if not previous_selection.has (clicked_row.interface) then
					if clicked_row.select_actions_internal /= Void then
						clicked_row.select_actions_internal.call (void)
					end
					if select_actions_internal /= Void then
						select_actions_internal.call ([clicked_row.interface])
					end
			end
		end

	call_deselect_actions (deselected_row: EV_MULTI_COLUMN_LIST_ROW_IMP) is
			-- Call deselect actions for `deselected_row'
		do
				if deselected_row.deselect_actions_internal /= Void then
					deselected_row.deselect_actions_internal.call (Void)
				end
				if deselect_actions_internal /= Void then
					deselect_actions_internal.call ([deselected_row.interface])
				end
		end

	resize_model_if_needed (a_columns: INTEGER) is
			--
		do

		end


	create_list (a_columns: INTEGER) is
			-- Create the clist with `a_columns' columns.
		require
			a_columns_positive: a_columns > 0
		do

		end

	on_pointer_motion (a_motion_tuple: TUPLE [INTEGER, INTEGER, DOUBLE, DOUBLE, DOUBLE, INTEGER, INTEGER]) is
		local
			a_row_number: INTEGER
			a_row_imp: EV_MULTI_COLUMN_LIST_ROW_IMP
		do
			Precursor (a_motion_tuple)
			if not app_implementation.is_in_transport and then a_motion_tuple.integer_item (2) > 0 and a_motion_tuple.integer_item (1) <= width then
				a_row_number := row_index_from_y_coord (a_motion_tuple.integer_item (2))
				if a_row_number > 0 and then a_row_number <= count then
					a_row_imp := ev_children @ a_row_number
					if a_row_imp.pointer_motion_actions_internal /= Void then
						a_row_imp.pointer_motion_actions_internal.call (a_motion_tuple)
					end
				end
			end
		end

	pixmaps_size_changed is
			--
		do
			--| FIXME IEK Add pixmap scaling code with gtk+ 2
--			if pixmaps_height > {EV_GTK_EXTERNALS}.gtk_clist_struct_row_height (list_widget) then
--				set_row_height (pixmaps_height)
--			end
		end

feature -- Access

	column_count: INTEGER is
			-- Number of columns in the list.
		local
			col_list: POINTER
		do
		end

	model_column_count: INTEGER is
			-- Number of columns in GtkTreeModel
		do

		end

	rows, count: INTEGER is
			-- Number of rows in the list.
		do
			Result := ev_children.count
		end

	i_th (i: INTEGER): EV_MULTI_COLUMN_LIST_ROW is
			-- `i_th' row in `Current'
		do
			Result := (ev_children @ i).interface
		end

	selected_item: EV_MULTI_COLUMN_LIST_ROW is
			-- Item which is currently selected
		do

		end

	selected_items: ARRAYED_LIST [EV_MULTI_COLUMN_LIST_ROW] is
			-- List of all the selected items. For a single
			-- selection list, it gives a list with only one
			-- element which is `selected_item'. Therefore, one
			-- should use `selected_item' rather than
			-- `selected_items' for a single selection list.
		do

		end

feature -- Status report

	selected: BOOLEAN is
			-- Is at least one item selected ?
		do

		end

	multiple_selection_enabled: BOOLEAN is
			-- True if the user can choose several items
			-- False otherwise.
		do
		end

	title_shown: BOOLEAN is
			-- True if the title row is shown.
			-- False if the title row is not shown.
		do
			Result := True
		end

feature -- Status setting

	destroy is
			-- Destroy screen widget implementation and EV_LIST_ITEM objects.
		do
			wipe_out
			Precursor {EV_PRIMITIVE_IMP}
		end

	enable_multiple_selection is
			-- Allow the user to do a multiple selection simply
			-- by clicking on several choices.
			-- For constants, see EV_GTK_CONSTANTS.
		do
		end

	disable_multiple_selection is
			-- Allow the user to do only one selection. It is the
			-- default status of the list.
			-- For constants, see EV_GTK_CONSTANTS.
		do
		end

	select_item (an_index: INTEGER) is
			-- Select an item at the one-based `index' of the list.
		do

		end

	deselect_item (an_index: INTEGER) is
			-- Unselect the item at the one-based `index'.
		do
		end

	clear_selection is
			-- Clear the selection of the list.
		do
		end

	resize_column_to_content (a_column: INTEGER) is
			-- Resize column `a_column' to width of its widest text.
		do
		end

feature -- Element change

	column_title_changed (a_txt: STRING_GENERAL; a_column: INTEGER) is
			-- Make `a_txt' the title of the column number.
		do

		end

	column_width_changed (value: INTEGER; a_column: INTEGER) is
			-- Make `value' the new width of the column number
			-- `a_column'.
		do
		end

	column_alignment_changed (an_alignment: EV_TEXT_ALIGNMENT; a_column: INTEGER) is
			-- Set alignment of `a_column' to corresponding `alignment_code'.
		do

		end

	set_row_height (value: INTEGER) is
			-- Make `value' the new height of all the rows.
		do
		end

	wipe_out is
			-- Remove all items.
		local
			item_imp: EV_MULTI_COLUMN_LIST_ROW_IMP
		do

		end

feature -- Implementation

	set_to_drag_and_drop: BOOLEAN is
			-- Set transport mode to drag and drop.
		do
			if pnd_row_imp /= Void then
				Result := pnd_row_imp.mode_is_drag_and_drop
			else
				Result := mode_is_drag_and_drop
			end
		end

	able_to_transport (a_button: INTEGER): BOOLEAN is
			-- Is list or row able to transport PND data using `a_button'.
		do
			if pnd_row_imp /= Void then
				Result := (pnd_row_imp.mode_is_drag_and_drop and a_button = 1) or
				(pnd_row_imp.mode_is_pick_and_drop and a_button = 3)
			else
				Result := (mode_is_drag_and_drop and a_button = 1) or
				(mode_is_pick_and_drop and a_button = 3)
			end
		end

	ready_for_pnd_menu (a_button: INTEGER): BOOLEAN is
			-- Is list or row able to display PND menu using `a_button'
		do
			if pnd_row_imp /= Void then
				Result := pnd_row_imp.mode_is_target_menu and then a_button = 3
			else
				Result := mode_is_target_menu and then a_button = 3
			end
		end

	disable_transport is
			-- Disable PND transport
		do
			Precursor
			update_pnd_status
		end

	update_pnd_status is
			-- Update PND status of list and its children.
		local
			a_enable_flag: BOOLEAN
		do
			from
				ev_children.start
			until
				ev_children.after or else a_enable_flag
			loop
				a_enable_flag := ev_children.item.is_transport_enabled
				ev_children.forth
			end
			update_pnd_connection (a_enable_flag)
		end

	update_pnd_connection (a_enable: BOOLEAN) is
			-- Update the PND connection of `Current' if needed.
		do
			if not is_transport_enabled then
				if a_enable or pebble /= Void then
					is_transport_enabled := True
				end
			elseif not a_enable and pebble = Void then
				is_transport_enabled := False
			end
		end

	on_mouse_button_event (
			a_type: INTEGER
			a_x, a_y, a_button: INTEGER;
			a_x_tilt, a_y_tilt, a_pressure: DOUBLE;
			a_screen_x, a_screen_y: INTEGER)
		is
			-- Initialize a pick and drop transport.
		local
			a_row_index: INTEGER
		do
			a_row_index := row_index_from_y_coord (a_y)

			if a_row_index > 0 then
				pnd_row_imp := ev_children.i_th (a_row_index)
				if not pnd_row_imp.able_to_transport (a_button) then
					pnd_row_imp := Void
				end
			end

			Precursor (
					a_type,
					a_x, a_y, a_button,
					a_x_tilt, a_y_tilt, a_pressure,
					a_screen_x, a_screen_y
				)
		end

	pnd_row_imp: EV_MULTI_COLUMN_LIST_ROW_IMP
			-- Implementation object of the current row if in PND transport.

	temp_pebble: ANY

	temp_pebble_function: FUNCTION [ANY, TUPLE [], ANY]
			-- Returns data to be transported by PND mechanism.

	temp_accept_cursor, temp_deny_cursor: EV_CURSOR

	call_pebble_function (a_x, a_y, a_screen_x, a_screen_y: INTEGER) is
			-- Set `pebble' using `pebble_function' if present.
		do
			temp_pebble := pebble
			temp_pebble_function := pebble_function
			if pnd_row_imp /= Void then
				pebble := pnd_row_imp.pebble
				pebble_function := pnd_row_imp.pebble_function
			end

			if pebble_function /= Void then
				pebble_function.call ([a_x, a_y]);
				pebble := pebble_function.last_result
			end
		end

	pre_pick_steps (a_x, a_y, a_screen_x, a_screen_y: INTEGER) is
			-- Steps to perform before transport initiated.
		do
			temp_accept_cursor := accept_cursor
			temp_deny_cursor := deny_cursor
			app_implementation.on_pick (pebble)

			if pnd_row_imp /= Void then
				if pnd_row_imp.pick_actions_internal /= Void then
					pnd_row_imp.pick_actions_internal.call ([a_x, a_y])
				end
				accept_cursor := pnd_row_imp.accept_cursor
				deny_cursor := pnd_row_imp.deny_cursor
			else
				if pick_actions_internal /= Void then
					pick_actions_internal.call ([a_x, a_y])
				end
			end

			pointer_x := a_screen_x
			pointer_y := a_screen_y

			if pnd_row_imp = Void then
				if (pick_x = 0 and then pick_y = 0) then
					App_implementation.set_x_y_origin (a_screen_x, a_screen_y)
				else
					if pick_x > width then
						pick_x := width
					end
					if pick_y > height then
						pick_y := height
					end
					App_implementation.set_x_y_origin (pick_x + (a_screen_x - a_x), pick_y + (a_screen_y - a_y))
				end
			else
				if (pnd_row_imp.pick_x = 0 and then pnd_row_imp.pick_y = 0) then
					App_implementation.set_x_y_origin (a_screen_x, a_screen_y)
				else
					if pick_x > width then
						pick_x := width
					end
					if pick_y > row_height then
						pick_y := row_height
					end
					App_implementation.set_x_y_origin (
						pnd_row_imp.pick_x + (a_screen_x - a_x),
						pnd_row_imp.pick_y +
						(a_screen_y - a_y) +
						((ev_children.index_of (pnd_row_imp, 1) - 1) * row_height)
					)
				end
			end
		end

	post_drop_steps (a_button: INTEGER)  is
			-- Steps to perform once an attempted drop has happened.
		do
			App_implementation.set_x_y_origin (0, 0)
			last_pointed_target := Void

			if pebble_function /= Void then
				if pnd_row_imp /= Void then
					pnd_row_imp.set_pebble_void
				else
					temp_pebble := Void
				end
			end

			accept_cursor := temp_accept_cursor
			deny_cursor := temp_deny_cursor
			pebble := temp_pebble
			pebble_function := temp_pebble_function

			temp_pebble := Void
			temp_pebble_function := Void
			temp_accept_cursor := Void
			temp_deny_cursor := Void

			pnd_row_imp := Void
		end

feature {EV_MULTI_COLUMN_LIST_ROW_IMP} -- Implementation

	row_index_from_y_coord (a_y: INTEGER): INTEGER is
			-- Returns the row index at relative coordinate `a_y'.
		local
			a_tree_path, a_tree_column: POINTER
			a_success: BOOLEAN
			a_int_ptr: POINTER
			mp: MANAGED_POINTER
		do

		end

	row_from_y_coord (a_y: INTEGER): EV_PND_DEFERRED_ITEM is
			-- Returns the row at relative coordinate `a_y'
		local
			a_row_index: INTEGER
		do
			a_row_index := row_index_from_y_coord (a_y)
			if a_row_index > 0 then
				Result := ev_children @ a_row_index
			end
		end

feature {EV_MULTI_COLUMN_LIST_ROW_IMP}

	set_text_on_position (a_column, a_row: INTEGER; a_text: STRING_GENERAL) is
			--
		do

		end

	set_row_pixmap (a_row: INTEGER; a_pixmap: EV_PIXMAP) is
			-- Set row `a_row' pixmap to `a_pixmap'.
		local
			pixmap_imp: EV_PIXMAP_IMP
			a_list_iter: POINTER
			a_pixbuf: POINTER
		do
			pixmap_imp ?= a_pixmap.implementation
			a_pixbuf := pixmap_imp.pixbuf_from_drawable_with_size (pixmaps_width, pixmaps_height)
--			a_list_iter := ev_children.i_th (a_row).list_iter.item
		end

	remove_row_pixmap (a_row: INTEGER) is
			-- Remove pixmap from `a_row'
		do
		end

feature {NONE} -- Implementation

	update_child (child: EV_MULTI_COLUMN_LIST_ROW_IMP; a_row: INTEGER) is
			-- Update `child'.
		require
			child_exists: child /= Void
		local
			cur: CURSOR
			txt: STRING_32
			list: EV_MULTI_COLUMN_LIST_ROW
			column_counter: INTEGER
		do
			list := child.interface
			cur := list.cursor

			if child.pixmap /= Void then
				set_row_pixmap (a_row, child.pixmap)
			end
			from
				column_counter := 1
				list.start
			until
				column_counter > column_count
			loop
					-- Set the text in the cell
				if list.after then
					txt := ""
				else
					txt := list.item
					if txt = Void then
						txt := ""
					end
				end
				set_text_on_position (column_counter, a_row, txt)
					-- Pixmap gets updated when the text does.

					-- Prepare next iteration
				if not list.after then
					list.forth
				end
				column_counter := column_counter + 1
			end
			list.go_to (cur)
		end

	ensure_item_visible (a_item: EV_MULTI_COLUMN_LIST_ROW) is
			-- Ensure `a_item' is visible on the screen.
		local
			list_item_imp: EV_MULTI_COLUMN_LIST_ROW_IMP
		do
			list_item_imp ?= a_item.implementation
		end

	insert_i_th (v: like item; i: INTEGER) is
			-- Insert `v' at position `i'.
		local
			item_imp: EV_MULTI_COLUMN_LIST_ROW_IMP
		do
			item_imp ?= v.implementation
			item_imp.set_parent_imp (Current)

				-- Make sure list is large enough to fit `item_imp'
			if v.count > column_count then
				create_list (v.count)
			end

				-- update the list of rows of the column list:			
			ev_children.go_i_th (i)
			ev_children.put_left (item_imp)

				-- Add row to model
--			create a_tree_iter.make
--			item_imp.set_list_iter (a_tree_iter)
--			update_child (item_imp, ev_children.count)

--			if item_imp.is_transport_enabled then
--				update_pnd_connection (True)
--			end

			child_array.go_i_th (i)
			child_array.put_left (v)

			Precursor {EV_CARBON_DATABROWSER} (v, i)
		end

	remove_i_th (a_position: INTEGER) is
			-- Remove item from list at `a_position'.
			-- Set the items parent to void.
		local
			item_imp: EV_MULTI_COLUMN_LIST_ROW_IMP
		do
			item_imp := (ev_children @ (a_position))
			item_imp.set_parent_imp (Void)

			-- remove the row from the `ev_children'
			ev_children.go_i_th (a_position)
			ev_children.remove
			child_array.go_i_th (a_position)
			child_array.remove
			update_pnd_status
		end

	row_height: INTEGER is
			-- Height of rows in `Current'
		local
			a_column_ptr: POINTER
			a_x, a_y, a_width, a_height: INTEGER
		do

		end

feature {EV_MULTI_COLUMN_LIST_ROW_IMP} -- Implementation

	expand_column_count_to (a_columns: INTEGER) is
			-- Expand the number of columns to `a_columns'
		do
			create_list (a_columns)
		end

feature {EV_GTK_DEPENDENT_INTERMEDIARY_ROUTINES} -- Implementation

	tree_view: POINTER
		-- Pointer to the View

feature {EV_ANY_I} -- Implementation

	visual_widget: POINTER is
			-- Pointer to on-screen interactive widget
		do
			Result := tree_view
		end

	scrollable_area: POINTER
		-- Gtk widget used to scroll tree view

	interface: EV_MULTI_COLUMN_LIST;

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




end -- class EV_MULTI_COLUMN_LIST_IMP

