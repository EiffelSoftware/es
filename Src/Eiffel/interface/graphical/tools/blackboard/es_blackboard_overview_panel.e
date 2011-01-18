note
	description: "Summary description for {ES_BLACKBOARD_SYSTEM_PANEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_BLACKBOARD_OVERVIEW_PANEL

inherit

	EBB_SHARED_BLACKBOARD

	ES_SHARED_FONTS_AND_COLORS

	EB_SHARED_PIXMAPS

create
	make

feature {NONE} -- Initialization

	make (a_window: EB_DEVELOPMENT_WINDOW)
			-- Initialize panel.
		local
			l_col: EV_GRID_COLUMN
		do
			create grid
			grid.enable_tree
			grid.set_column_count_to (message_column)

--			l_col := grid.column (status_column)
--			l_col.set_width (25)
--			l_col.set_title ("")

			l_col := grid.column (item_column)
			l_col.set_width (200)
			l_col.set_title ("Item")

			l_col := grid.column (score_column)
			l_col.set_width (50)
			l_col.set_title ("Score")

			l_col := grid.column (score2_column)
			l_col.set_width (25)
			l_col.set_title ("L")

			l_col := grid.column (weight_column)
			l_col.set_width (25)
			l_col.set_title ("W")

			l_col := grid.column (message_column)
			l_col.set_width (300)
			l_col.set_title ("Message")

			grid_token_support.synchronize_color_or_font_change_with_editor
			grid_token_support.enable_grid_item_pnd_support
			grid_token_support.enable_ctrl_right_click_to_open_new_window
			grid_token_support.set_context_menu_factory_function (agent (a_window.menus).context_menu_factory)

			grid.item_select_actions.extend (agent on_item_selected)
			grid.item_deselect_actions.extend (agent on_item_deselected)

				-- Set up default filter
			class_name_filter := Void
			feature_name_filter := Void
			is_filtering_score := False
			is_filtering_weight := False
			is_query_visible := True
			is_command_visible := True
			is_routine_visible := True
			is_attribute_visible := True
			is_only_compiled_visible := False
		end

feature -- Access

	grid: ES_GRID
			-- Grid to display system data.

	class_name_filter: STRING
			-- Text to filter class names with.

	feature_name_filter: STRING
			-- Text to filter feature names with.

	is_filtering_class_names: BOOLEAN
			-- Is filtering by name enabled?
		do
			Result := class_name_filter /= Void and then not class_name_filter.is_empty
		end

	is_filtering_feature_names: BOOLEAN
			-- Is filtering by name enabled?
		do
			Result := feature_name_filter /= Void and then not feature_name_filter.is_empty
		end

	is_filtering_score: BOOLEAN
			-- Is filtering by scores enabled?

	is_filtering_weight: BOOLEAN
			-- Is filtering by weight enabled?

	is_query_visible: BOOLEAN
			-- Are queries visible?

	is_command_visible: BOOLEAN
			-- Are commands visible?

	is_attribute_visible: BOOLEAN
			-- Are attributes visible?

	is_routine_visible: BOOLEAN
			-- Are routines visible?

	is_only_compiled_visible: BOOLEAN
			-- Are only compiled classes visible?

feature -- Initialization

	update_blackboard_data
			-- Update display of blackboard data.
		local
			l_row: EV_GRID_ROW
			l_classes: LIST [EBB_CLASS_DATA]
			l_class_data: EBB_CLASS_DATA
			i: INTEGER
		do
			l_classes := blackboard.data.classes
				-- Remove classes which are not there anymore
			from
				i := 1
			until
				i > grid.row_count
			loop
				l_row := grid.row (i)
				if l_row.parent = Void then
					l_class_data ?= l_row.data
					if not l_classes.has (l_class_data) then
						grid.remove_and_clear_subrows_from (l_row)
						grid.remove_row (i)
					end
				else
					i := i + 1
				end
			end
				-- Update all classes
			from
				l_classes.start
			until
				l_classes.after
			loop
				update_class_data (l_classes.item)
				l_classes.forth
			end
		end

feature -- Basic operations

	set_class_name_filter (a_text: STRING)
			-- Set class filter to `a_text'.
		do
			class_name_filter := a_text
			update_visibility
		end

	set_feature_name_filter (a_text: STRING)
			-- Set class filter to `a_text'.
		do
			feature_name_filter := a_text
			update_visibility
		end

	update_visibility
			-- Update row visibility.
		local
			l_class_row, l_feature_row: EV_GRID_ROW
			l_count_class, l_count_features, i, j: INTEGER
			l_class_data: EBB_CLASS_DATA
			l_feature_data: EBB_FEATURE_DATA
			l_any_feature_visible: BOOLEAN
		do
			from
				i := 1
				l_count_class := grid.row_count
			until
				i > l_count_class
			loop
				l_class_row := grid.row (i)
				l_class_data ?= l_class_row.data
				if l_class_data /= Void then
					from
						j := 1
						l_count_features := l_class_row.subrow_count
						l_any_feature_visible := False
					until
						j > l_count_features
					loop
						l_feature_row := l_class_row.subrow (j)
						l_feature_data ?= l_feature_row.data
						check l_feature_data /= Void end
						check l_class_data.children.has (l_feature_data) end
						if is_feature_visible (l_feature_data) then
							l_feature_row.show
							l_any_feature_visible := True
						else
							l_feature_row.hide
						end
						j := j + 1
					end
					if is_filtering_class_names and is_filtering_feature_names then
						if l_any_feature_visible and then is_class_visible (l_class_data) then
							l_class_row.show
						else
							l_class_row.hide
						end
					elseif is_filtering_class_names then
						if is_class_visible (l_class_data) then
							l_class_row.show
						else
							l_class_row.hide
						end
					elseif is_filtering_feature_names then
						if l_any_feature_visible then
							l_class_row.show
						else
							l_class_row.hide
						end
					else
						if l_any_feature_visible or else is_class_visible (l_class_data) then
							l_class_row.show
						else
							l_class_row.hide
						end
					end
				end
				i := i + 1
			end
		end

	is_class_visible (a_class_data: EBB_CLASS_DATA): BOOLEAN
			-- Is class `a_class_data' visible?
		local
			l_text: STRING
		do
			Result := True
			if is_filtering_class_names then
				if not a_class_data.class_name.has_substring (class_name_filter.as_upper) then
					Result := False
				end
			end
			if is_filtering_score then

			end
			if is_filtering_weight then

			end
			if is_only_compiled_visible and not a_class_data.is_compiled then
				Result := False
			end
		end

	is_feature_visible (a_feature_data: EBB_FEATURE_DATA): BOOLEAN
			-- Is feature `a_feature_data' visible?
		local
			l_text: STRING
			l_feature: FEATURE_I
		do
			Result := True
			l_feature := a_feature_data.associated_feature
			if is_filtering_feature_names then
				if not a_feature_data.feature_name.as_lower.has_substring (feature_name_filter.as_lower) then
					Result := False
				end
			end
			if is_filtering_score then

			end
			if is_filtering_weight then

			end
			if l_feature.has_return_value and not is_query_visible then
				Result := False
			end
			if not l_feature.has_return_value and not is_command_visible then
				Result := False
			end
			if l_feature.is_attribute and not is_attribute_visible then
				Result := False
			end
			if l_feature.is_routine and not is_routine_visible then
				Result := False
			end
		end

	on_item_selected (a_item: EV_GRID_ITEM)
			-- Action when `a_item' is selected.
		local
			i, l_count: INTEGER
		do
			apply_background_color_recursively (a_item.row, gray_color)
			if attached {EBB_CLASS_DATA} a_item.row.data as l_class_data then
				update_class_data (l_class_data)
			elseif attached {EBB_FEATURE_DATA} a_item.row.data as l_feature_data then
				update_feature_data (a_item.row.parent_row, l_feature_data)
			end
		end

	on_item_deselected (a_item: EV_GRID_ITEM)
			-- Action when `a_item' is deselected.
		do
			apply_background_color_recursively (a_item.row, Void)
			if attached {EBB_CLASS_DATA} a_item.row.data as l_class_data then
				update_class_data (l_class_data)
			elseif attached {EBB_FEATURE_DATA} a_item.row.data as l_feature_data then
				update_feature_data (a_item.row.parent_row, l_feature_data)
			end
		end

	apply_background_color_recursively (a_row: EV_GRID_ROW; a_color: EV_COLOR)
			-- Apply `a_color' to `a_row' and all its subrows.
		local
			i, l_count: INTEGER
		do
			a_row.set_background_color (a_color)
			l_count := a_row.subrow_count
			from
				i := 1
			until
				i > l_count
			loop
				apply_background_color_recursively (a_row.subrow (i), a_color)
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	initialize_row (a_row: EV_GRID_ROW)
			-- Initialize empty row.
		local
			l_grid_text_item: EV_GRID_TEXT_ITEM
		do
--			a_row.set_item (status_column, create {EV_GRID_TEXT_ITEM})
			a_row.set_item (item_column, create {EV_GRID_TEXT_ITEM})
			create l_grid_text_item
			l_grid_text_item.set_font (fonts.highlighted_label_font)
			l_grid_text_item.align_text_center
			a_row.set_item (score_column, l_grid_text_item)
			create l_grid_text_item
			l_grid_text_item.align_text_center
			a_row.set_item (score2_column, l_grid_text_item)
			a_row.set_item (weight_column, create {EV_GRID_TEXT_ITEM})
			a_row.set_item (message_column, create {EV_GRID_TEXT_ITEM})
		end

	update_class_data (a_class_data: EBB_CLASS_DATA)
			-- Update display of class data `a_class_data'.
		local
			l_row: EV_GRID_ROW
			l_found: BOOLEAN
			l_insert_position: INTEGER
			l_class_data: EBB_CLASS_DATA
			i: INTEGER
		do
				-- Find row for this class.
			from
				i := 1
				l_insert_position := grid.row_count + 1
			until
				i > grid.row_count or l_found
			loop
				l_row := grid.row (i)
				if l_row.parent_row = Void then
					if l_row.data = a_class_data then
						l_found := True
					else
						l_class_data ?= l_row.data
						if a_class_data.class_name < l_class_data.class_name then
							l_insert_position := i
						end
					end
				end
				i := i + 1
			end
			if not l_found then
				grid.insert_new_row (l_insert_position)
				l_row := grid.row (l_insert_position)
				l_row.set_data (a_class_data)
				initialize_row (l_row)
				update_class_row (l_row, a_class_data)
			end
			update_class_row (l_row, a_class_data)
		end

	update_class_row (a_row: EV_GRID_ROW; a_class_data: EBB_CLASS_DATA)
			-- Update `a_row' which is displaying `a_class_data'.
		require
			correct_row: a_row.data = a_class_data
		local
			l_editor_item: EB_GRID_EDITOR_TOKEN_ITEM
			l_feature_data: EBB_FEATURE_DATA
			i: INTEGER
			l_ebb_state: EBB_STATE
			l_message: STRING
		do
				-- Item column
			if attached {EV_GRID_TEXT_ITEM} a_row.item (item_column) then
				token_generator.wipe_out_lines
				a_class_data.associated_class.append_name (token_generator)
				l_editor_item := create_clickable_grid_item (token_generator.last_line, True)
				l_editor_item.set_pixmap (pixmap_factory.pixmap_from_class_i (a_class_data.associated_class))
--				l_editor_item.set_background_color (background_color (a_class_data.score, a_class_data.is_stale))
				a_row.set_item (item_column, l_editor_item)
			elseif attached {EB_GRID_EDITOR_TOKEN_ITEM} a_row.item (item_column) as l_token_item then
				l_token_item.set_pixmap (pixmap_factory.pixmap_from_class_i (a_class_data.associated_class))
			end

				-- Verification score
			set_score (a_row, score_column, a_class_data.score, a_class_data.is_stale, a_class_data.has_manual_score)

				-- Lowest score
			if a_class_data.non_verified_feature_count > 0 then
				set_score (a_row, score2_column, a_class_data.lowest_feature_score, a_class_data.is_stale, a_class_data.has_manual_score)
			else
				set_score (a_row, score2_column, {REAL}.nan, a_class_data.is_stale, a_class_data.has_manual_score)
			end


				-- Weight
			set_weight (a_row, weight_column, a_class_data.weight)

				-- Message
			if attached {EV_GRID_TEXT_ITEM} a_row.item (message_column) as l_text then
				create l_ebb_state
				if a_class_data.is_stale then
					l_text.set_text ("Data is stale")
				elseif not a_class_data.has_score then
					l_text.set_text ("Not yet verified")
				elseif a_class_data.score = {EBB_VERIFICATION_SCORE}.successful then
					l_text.set_text ("Successfully verified")
				elseif a_class_data.score = {EBB_VERIFICATION_SCORE}.failed then
					l_text.set_text ("Verification failed")
				else
					l_message := a_class_data.features_below_threshold (0.0).out + " features failed. "
					l_message := l_message + a_class_data.features_above_threshold (0.0).out + " features verified."
					l_text.set_text (l_message)
				end

--				l_text.set_text ("(" + l_ebb_state.name_of_state (a_class_data.work_state) + "/" + l_ebb_state.name_of_state (a_class_data.result_state) + ")")
			end

				-- Children
			if a_class_data.is_compiled then
					-- Remove grid rows which have no feature anymore
				from
					i := 1
				until
					i > a_row.subrow_count
				loop
					l_feature_data ?= a_row.subrow (i).data
					if not a_class_data.children.has (l_feature_data) then
						grid.remove_row (a_row.index + i)
					else
						i := i + 1
					end
				end
					-- Update all features
				from
					a_class_data.children.start
				until
					a_class_data.children.after
				loop
					l_feature_data := a_class_data.children.item

					update_feature_data (a_row, l_feature_data)

					a_class_data.children.forth
				end
			end
		end

	update_feature_data (a_parent_row: EV_GRID_ROW; a_feature_data: EBB_FEATURE_DATA)
			-- Update display of feature data `a_feature_data'.
		require
			correcto_row: a_parent_row.data = a_feature_data.parent
		local
			l_row: EV_GRID_ROW
			l_found: BOOLEAN
			l_insert_position: INTEGER
			l_feature_data: EBB_FEATURE_DATA
			i: INTEGER
		do
				-- Find row for this feature.
			from
				i := 1
				l_insert_position := a_parent_row.subrow_count + 1
			until
				i > a_parent_row.subrow_count or l_found
			loop
				l_row := a_parent_row.subrow (i)
				if l_row.parent_row = a_parent_row then
					if l_row.data = a_feature_data then
						l_found := True
					else
						l_feature_data ?= l_row.data
						if a_feature_data.feature_name < l_feature_data.feature_name then
							l_insert_position := i
						end
					end
				end
				i := i + 1
			end
			if not l_found then
				a_parent_row.insert_subrow (l_insert_position)
				l_row := a_parent_row.subrow (l_insert_position)
				l_row.set_data (a_feature_data)
				initialize_row (l_row)
				update_feature_row (l_row, a_feature_data)
			end
			update_feature_row (l_row, a_feature_data)
		end

	update_feature_row (a_row: EV_GRID_ROW; a_feature_data: EBB_FEATURE_DATA)
			-- Update `a_row' which is displaying `a_feature_data'.
		require
			correct_row: a_row.data = a_feature_data
			correct_row2: a_row.parent_row /= Void and then a_row.parent_row.data = a_feature_data.parent
		local
			l_editor_item: EB_GRID_EDITOR_TOKEN_ITEM
			l_tool_results: like {EBB_FEATURE_DATA}.tool_results_list
			l_tool_result: EBB_VERIFICATION_RESULT
			l_index: INTEGER
			l_row: EV_GRID_ROW
		do
				-- Item column
			if attached {EV_GRID_TEXT_ITEM} a_row.item (item_column) then
				token_generator.wipe_out_lines
				a_feature_data.associated_feature.e_feature.append_name (token_generator)
				l_editor_item := create_clickable_grid_item (token_generator.last_line, True)
				l_editor_item.set_pixmap (pixmap_factory.pixmap_from_e_feature (a_feature_data.associated_feature.e_feature))
--				l_editor_item.set_background_color (background_color (a_feature_data.score, a_feature_data.is_stale))
				a_row.set_item (item_column, l_editor_item)
			end

				-- Verification score
			set_score (a_row, score_column, a_feature_data.score, a_feature_data.is_stale, a_feature_data.has_manual_score)

				-- Weight
			set_weight (a_row, weight_column, a_feature_data.weight)

				-- Message
			token_generator.wipe_out_lines
			a_feature_data.append_message (token_generator)
			l_editor_item := create_clickable_grid_item (token_generator.last_line, True)
			a_row.set_item (message_column, l_editor_item)

				-- Children
			from
--				l_tool_results := a_feature_data.tool_results_list
--				l_tool_results.start
				a_feature_data.tool_results.start
			until
--				l_tool_results.after
				a_feature_data.tool_results.after
			loop
--				l_tool_result := l_tool_results.item.verification_result
				l_tool_result := a_feature_data.tool_results.item
				l_index := a_feature_data.tool_results.index

					-- Is row already there?
				if a_row.subrow_count >= l_index and then a_row.subrow (l_index).data = l_tool_result then
					a_feature_data.tool_results.finish
					a_feature_data.tool_results.forth
				else
					a_row.insert_subrow (l_index)
					l_row := a_row.subrow (l_index)
					l_row.set_data (l_tool_result)
					initialize_row (l_row)
					update_tool_result_row (l_row, l_tool_result, False)
					a_feature_data.tool_results.forth
				end
			end
		end

	update_tool_result_row (a_row: EV_GRID_ROW; a_result: EBB_VERIFICATION_RESULT; a_stale: BOOLEAN)
			-- Update `a_row' with data from `a_result'.
		require
			correct_row: a_row.data = a_result
		local
			l_editor_item: EB_GRID_EDITOR_TOKEN_ITEM
		do
				-- Item column
			if attached {EV_GRID_TEXT_ITEM} a_row.item (item_column) as l_text then
				l_text.set_text (a_result.tool.name + " - " + a_result.tool_configuration.name)
			end
				-- Verification score
			set_score (a_row, score_column, a_result.score, a_stale, False)
				-- Weight
			set_weight (a_row, weight_column, a_result.weight)
				-- Message
			token_generator.wipe_out_lines
			token_generator.enable_multiline
			a_result.multi_line_message (token_generator)
			l_editor_item := create_multiline_clickable_grid_item (token_generator.lines, True, False)
			a_row.set_item (message_column, l_editor_item)
		end

	set_score (a_row: EV_GRID_ROW; a_column: INTEGER; a_score: REAL; a_stale: BOOLEAN; a_manual: BOOLEAN)
			-- TODO
		local
			l_formatted_score: STRING
			l_pixmap: EV_PIXMAP
		do
			if attached {EV_GRID_TEXT_ITEM} a_row.item (a_column) as l_text then
				if a_stale then
					l_formatted_score := "*"
				else
					l_formatted_score := ""
				end
				if a_score.is_nan then
					l_text.set_text (l_formatted_score)
--					l_text.remove_pixmap
					if a_manual then
						l_text.set_background_color (background_color (0, False, a_manual, a_row.background_color /= Void))
					else
						l_text.set_background_color (Void)
					end
--				elseif a_score = 1.0 then
--					l_text.set_text (l_formatted_score)
--					l_text.set_pixmap (icon_pixmaps.general_tick_icon)
--					l_text.set_background_color (background_color (a_score, a_stale, a_manual))
				else
					l_formatted_score.append ((a_score * 100.0).rounded.out)
					l_text.set_text (l_formatted_score)
--					l_text.remove_pixmap
					l_text.set_background_color (background_color (a_score, a_stale, a_manual, a_row.background_color /= Void))
				end
			end
		end

	set_weight (a_row: EV_GRID_ROW; a_column: INTEGER; a_weight: REAL)
			-- TODO
		local
			l_formatted_score: STRING
			l_pixmap: EV_PIXMAP
		do
			if attached {EV_GRID_TEXT_ITEM} a_row.item (a_column) as l_text then
				if a_weight <= 0.5 then
					l_text.set_pixmap (eve_pixmaps.weights_tiny_icon)
				elseif a_weight <= 1.5 then
					l_text.set_pixmap (eve_pixmaps.weights_small_icon)
				elseif a_weight <= 2.5 then
					l_text.set_pixmap (eve_pixmaps.weights_normal_icon)
				elseif a_weight <= 3.5 then
					l_text.set_pixmap (eve_pixmaps.weights_large_icon)
				else
					l_text.set_pixmap (eve_pixmaps.weights_huge_icon)
				end
				l_text.set_tooltip ("Weight: " + real_formatter.formatted (a_weight))
			end
		end

	background_color (a_score: REAL; a_stale: BOOLEAN; a_manual: BOOLEAN; a_highlight: BOOLEAN): EV_COLOR
		local
			l_helper: ES_BLACKBOARD_BENCH_HELPER
			l_hue, l_saturation, l_value: REAL
		do
			if a_score.is_nan then
				Result := white_color
			else
				create l_helper
				l_hue := ((a_score + 1.0) * 0.5)
				l_saturation := 1.0
				if a_stale then
					l_value := 0.6
				elseif a_highlight then
					l_value := 1.0
				else
					l_value := 0.9
				end
				if a_manual then
					Result := l_helper.gradient_color_hsv (l_hue, 0.55, 0.55, l_saturation, l_value)
				else
					Result := l_helper.gradient_color_hsv (l_hue, 0.0, 0.333, l_saturation, l_value)
				end
			end
		end

	white_color: EV_COLOR
		once
			create Result.make_with_rgb (1.0, 1.0, 1.0)
		end

	gray_color: EV_COLOR
		once
			create Result.make_with_rgb (0.93, 0.93, 0.93)
		end

	real_formatter: FORMAT_DOUBLE
		once
			create Result.make (1, 1)
		end

feature {NONE} -- Implementation

	--status_column: INTEGER = 1
	item_column: INTEGER = 1
	score_column: INTEGER = 2
	score2_column: INTEGER = 3
	weight_column: INTEGER = 4
	message_column: INTEGER = 5

feature {NONE} -- Helpers

	pixmap_factory: EB_PIXMAPABLE_ITEM_PIXMAP_FACTORY
			-- A pixmap factory to create pixmaps for grid items.
		once
			create Result
		end

	token_generator: EB_EDITOR_TOKEN_GENERATOR
			-- An editor token generator for generating editor token on grid items.
		once
			Result := (create {EB_SHARED_WRITER}).token_writer
		end

	frozen grid_token_support: EB_EDITOR_TOKEN_GRID_SUPPORT
			-- Support for using `grid' with editor token-based items
		do
			Result := internal_grid_token_support
			if Result = Void then
				create Result.make_with_grid (grid)
				internal_grid_token_support := Result
--				auto_recycle (internal_grid_token_support)
			end
		ensure
			result_attached: Result /= Void
			result_consistent: Result = grid_token_support
		end

feature {NONE} -- Factory

	create_clickable_grid_item (a_line: EIFFEL_EDITOR_LINE; a_allow_selection: BOOLEAN): EB_GRID_EDITOR_TOKEN_ITEM
			-- Create a new grid item to host the context of `a_lines'.
			--
			-- `a_line': The editor line containing tokens to render on the resulting grid item.
			-- `a_allow_selection': True to allow the contents to be selected; False otherwise.
			-- `Result': A grid item with the tokens set.
		require
			a_line_attached: a_line /= Void
		local
			l_lines: ARRAYED_LIST [EIFFEL_EDITOR_LINE]
		do
			create l_lines.make (1)
			l_lines.extend (a_line)
			Result := create_multiline_clickable_grid_item (l_lines, a_allow_selection, False)
		ensure
			result_attached: Result /= Void
		end

	create_multiline_clickable_grid_item (a_lines: LIST [EIFFEL_EDITOR_LINE]; a_allow_selection: BOOLEAN; a_use_text_wrapping: BOOLEAN): EB_GRID_EDITOR_TOKEN_ITEM
			-- Create a new grid item to host the context of `a_lines'.
			-- Caution: It is the responsibility of the caller to call `try_call_setting_change_actions' when Result has been fully initialized.
			--
			-- `a_lines': The editor lines containing tokens to render on the resulting grid item.
			-- `a_allow_selection': True to allow the contents to be selected; False otherwise.
			-- `a_use_text_wrapping': True to perform automatic text-wrapping; False otherwise.
			-- `Result': A grid item with the tokens set.
		require
			a_lines_attached: a_lines /= Void
		local
			l_tokens: like tokens_list_from_lines
			l_selectable_item: EB_GRID_EDITOR_ITEM
			l_shared_writer: EB_SHARED_WRITER
		do
			if a_allow_selection then
				create l_selectable_item
				Result := l_selectable_item
			else
				create Result
			end
				-- Lock update so that the sizing calculation only occurs once everything has been set.
			Result.lock_update

			Result.set_text_wrap (a_use_text_wrapping)
			l_tokens := tokens_list_from_lines (a_lines)
			if not l_tokens.is_empty then
				create l_shared_writer

				Result.set_left_border (4)
				Result.set_text_with_tokens (tokens_list_from_lines (a_lines))
				Result.set_overriden_fonts (l_shared_writer.label_font_table, l_shared_writer.label_font_height)
			end
			Result.unlock_update
		ensure
			result_attached: Result /= Void
		end

	create_clickable_tooltip (a_lines: LIST [EIFFEL_EDITOR_LINE]; a_item: EV_GRID_ITEM; a_row: EV_GRID_ROW): EB_EDITOR_TOKEN_TOOLTIP
			-- Creates a new clickable tool tip with the context of `a_lines' and attaches itself it `a_item'
			--
			-- Note: If `a_item' already had a tool tip created for it, no new tool tip will be created but the same
			--       one will be returned.
			--
			-- `a_lines': The editor lines containing tokens to render on the resulting tool tip.
			-- `a_item': The tool tip to attached to the item.
			-- `a_row': The row where the item is to be places
			-- `Result': A tool tip attached to `a_item'
		require
			a_lines_attached: a_lines /= Void
			a_item_attached: a_item /= Void
			a_item_is_parented: a_item.is_parented
			a_item_data_unattached_or_is_tool_tip: a_item.data = Void or else (({EB_EDITOR_TOKEN_TOOLTIP}) #? a_item.data) /= Void
		local
			l_tokens: like tokens_list_from_lines
			l_select_actions: EV_NOTIFY_ACTION_SEQUENCE
		do
			Result ?= a_item.data
			if Result = Void then
				if grid.is_single_item_selection_enabled or grid.is_multiple_row_selection_enabled then
					l_select_actions := a_item.row.select_actions
				else
					l_select_actions := a_item.select_actions
				end
				create Result.make (a_item.pointer_enter_actions, a_item.pointer_leave_actions, l_select_actions, agent a_item.is_destroyed)
				Result.enable_pointer_on_tooltip
				a_item.set_data (Result)
			end

			l_tokens := tokens_list_from_lines (a_lines)
			Result.set_tooltip_text (l_tokens)
			if not l_tokens.is_empty then
				Result.enable_tooltip
			else
				Result.disable_tooltip
			end
		ensure
			result_attached: Result /= Void
		end

	tokens_list_from_lines (a_lines: LIST [EIFFEL_EDITOR_LINE]): ARRAYED_LIST [EDITOR_TOKEN]
			-- Create a list of editor tokens from lines `a_lines'
			--
			-- `a_lines': Lines to create a token list from
		require
			a_lines_attached: a_lines /= Void
			not_a_lines_is_empty: not a_lines.is_empty
		local
			l_cursor: CURSOR
			l_eol: EDITOR_TOKEN_EOL
			l_start: BOOLEAN
		do
			create Result.make (a_lines.count)
			l_cursor := a_lines.cursor
			from a_lines.start until a_lines.after loop
				if not l_start then
					l_start := a_lines.item.count > 0
				end
				if l_start then
						-- Ensures no blank lines at the beginning of the text
					Result.append (a_lines.item.content)
					if not a_lines.islast then
						Result.extend (create {EDITOR_TOKEN_EOL}.make)
					end
				end
				a_lines.forth
			end
			a_lines.go_to (l_cursor)

			if not Result.is_empty then
					-- Ensures no blank lines at the end of the text
				l_eol ?= Result.last
				from Result.finish until Result.before or l_eol = Void loop
					l_eol ?= Result.item
					if l_eol /= Void then
						Result.remove
					end
					if not Result.before then
						Result.back
					end
				end
			end
		ensure
			result_attached: Result /= Void
			a_lines_unmoved: a_lines.cursor.is_equal (old a_lines.cursor)
		end

feature {NONE} -- Internal cache

	internal_grid_token_support: like grid_token_support
			-- Cached version of `grid_token_support'
			-- Note: Do not use directly!

;note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
