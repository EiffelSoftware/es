indexing
	description: "Objects that represent a grid for displaying test cases in a tree like structure"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_GRID

inherit
	ES_GRID
		redefine
			row_type,
			-- NOTE: redefined because of typing conflicts
			row,
			remove_and_clear_all_rows
		end

	CDD_GRID_HELPER [CONF_CLUSTER, CDD_GRID_CLUSTER_LINE]
		undefine
			default_create,
			is_equal,
			copy
		end

	EB_SHARED_PREFERENCES
		export
			{NONE} all
		undefine
			default_create,
			is_equal,
			copy
		end

create
	make_with_tool

feature {NONE} -- Initialization

	make_with_tool (a_tool: like tool) is
			-- Call `default_create' and initialize grid layout.
		require
			a_tool_not_void: a_tool /= Void
		do
			default_create
			
			tool := a_tool

			enable_tree
			enable_row_height_fixed
			enable_single_row_selection
			enable_default_tree_navigation_behavior (True, False, True, True)
			hide_tree_node_connectors
			focus_in_actions.extend (agent update_selection)
			focus_out_actions.extend (agent update_selection)
			row_select_actions.extend (agent set_selection_color)
			row_deselect_actions.extend (agent set_selection_color)
			set_focused_selection_color (preferences.editor_data.selection_background_color)
			build_columns
		ensure
			tool_set: tool = a_tool
		end

	build_columns is
			-- Set up the grid colum layout.
		local
			l_col: EV_GRID_COLUMN
		do
			set_column_count_to (2)

			l_col := column (1)
			l_col.set_title ("Test Cases")
			l_col.set_width (200)
			set_auto_resizing_column (1, False)

			l_col := column (2)
			l_col.set_title ("")
			set_auto_resizing_column (2, False)
		end

feature -- Access

	tool: CDD_TOOL
			-- Tool containing `Current'

	row (a_row: INTEGER): like row_type is
			-- Row at index `a_row'.
		do
			Result ?= Precursor (a_row)
		end

	data_from_test_case (a_tc: CDD_TEST_CASE): CONF_CLUSTER is
			-- `cluster_under_test' of `a_tc'
		do
			Result := a_tc.cluster_under_test
		end

	first_subrow: like row_type is
			-- If `Current' contains any rows, return row at index 1,
			-- otherwise return Void
		do
			if row_count > 0 then
				Result := row (1)
			end
		end

	max_row_index: INTEGER is
			-- Maximum row index for inserting a new row
		do
			Result := row_count + 1
		end

feature {NONE} -- GRID Customization

	row_type: CDD_GRID_ROW is do end
		-- Type used for row objects.
		-- May be redefined by EV_GRID descendents.	

feature -- Actions

	update_selection is
			-- Update selection color for all selected rows.
		local
			l_rows: ARRAYED_LIST [EV_GRID_ROW]
		do
			from
				l_rows := selected_rows
				l_rows.start
			until
				l_rows.after
			loop
				set_selection_color (l_rows.item)
				l_rows.forth
			end
		end


	set_selection_color (a_row: EV_GRID_ROW) is
			-- Set selection color for `a_row' according to preferences.
		do
			if a_row.is_selected then
				if has_focus then
					a_row.set_background_color (preferences.editor_data.selection_background_color)
				else
					a_row.set_background_color (preferences.editor_data.focus_out_selection_background_color)
				end
			else
				a_row.set_background_color (preferences.editor_data.class_background_color)
			end
		end

feature -- Element change

	remove_and_clear_all_rows is
			-- Wipe out grid and all lines.
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > row_count
			loop
				row (i).grid_line.unattach
				i := i + 1
			end
			Precursor
		end

feature {NONE} -- Element change

	create_new_line (a_row_index: INTEGER; a_cluster: CONF_CLUSTER) is
			-- Create a new cluster line for displaying `a_cluster' with row at position `a_row_index'.
		do
			create last_created_line.make_with_row (row (a_row_index), a_cluster)
		end

invariant
	column_count_equal_two: column_count = 2

end -- Class CDD_GRID
