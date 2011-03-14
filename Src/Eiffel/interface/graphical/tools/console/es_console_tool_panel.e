note
	description	: "Tool where output and error of external commands are displayed."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date		: "$Date$"
	revision	: "$Revision$"
	author		: ""

class
	ES_CONSOLE_TOOL_PANEL

inherit
	ES_OUTPUT_TOOL_PANEL
		export
			{EB_EXTERNAL_OUTPUT_MANAGER}
				develop_window
		undefine
			Ev_application
		redefine
			make_with_tool,
			clear,
			internal_recycle,
			internal_detach_entities,
			scroll_to_end,set_focus,
			quick_refresh_editor,quick_refresh_margin, is_general,
			show
		end

	EB_EXTERNAL_OUTPUT_CONSTANTS

	SHARED_PLATFORM_CONSTANTS

	EB_TEXT_OUTPUT_TOOL

	EB_CONSTANTS

	EPA_UTILITY

	SEM_UTILITY

	EPA_CONTRACT_EXTRACTOR

	EPA_TEMPORARY_DIRECTORY_UTILITY

	EPA_PROCESS_UTILITY

	DKN_UTILITY

	EGX_UTILITY

	RM_VISUALIZATION_UTILITY

create
	make

feature{NONE} -- Initialization

	make_with_tool
			-- Create a new external output tool.
		do
			initialization (develop_window)
			widget := main_frame
			external_output_manager.extend (Current)
		end

	initialization (a_tool: EB_DEVELOPMENT_WINDOW)
			-- Initialize interface.
		local
			l_ev_horizontal_box_1: EV_HORIZONTAL_BOX
			l_ev_horizontal_box_2: EV_HORIZONTAL_BOX
			l_ev_horizontal_box_3: EV_HORIZONTAL_BOX
			l_ev_horizontal_box_4: EV_HORIZONTAL_BOX
			l_ev_horizontal_box_5: EV_HORIZONTAL_BOX
			l_ev_horizontal_box_6: EV_HORIZONTAL_BOX
			l_ev_horizontal_box_7: EV_HORIZONTAL_BOX
			l_ev_vertical_box_1: EV_VERTICAL_BOX
			l_ev_vertical_box_2: EV_VERTICAL_BOX
			l_locale_text: EV_LABEL
			l_cell: EV_CELL

			l_ev_cmd_lbl: EV_LABEL
			l_ev_output_lbl: EV_LABEL
			l_ev_input_lbl: EV_LABEL
			l_ev_empty_lbl: EV_LABEL
			cmd_toolbar: SD_TOOL_BAR
			output_toolbar: SD_TOOL_BAR
			clear_output_toolbar: SD_TOOL_BAR
			input_toolbar: SD_TOOL_BAR
			tbs: SD_TOOL_BAR_SEPARATOR
			l_del_tool_bar: SD_TOOL_BAR
			l_provider: EB_EXTERNAL_CMD_COMPLETION_PROVIDER
		do
			create del_cmd_btn.make
			create tbs.make
			create cmd_toolbar.make
			create output_toolbar.make
			create input_toolbar.make
			create main_frame
			create l_ev_empty_lbl
			create l_ev_vertical_box_2
			create l_ev_cmd_lbl
			create l_ev_output_lbl
			create l_ev_input_lbl
			create l_ev_vertical_box_1
			create l_ev_horizontal_box_1
			create l_ev_horizontal_box_2
			create l_ev_horizontal_box_3
			create l_ev_horizontal_box_4
			create l_ev_horizontal_box_5
			create l_ev_horizontal_box_6
			create l_ev_horizontal_box_7
			create terminate_btn.make
			create run_btn.make
			create cmd_lst
			create l_provider.make (Void)
			l_provider.set_code_completable (cmd_lst)
			cmd_lst.set_completion_possibilities_provider (l_provider)
			create edit_cmd_detail_btn.make
			create hidden_btn.make
			create state_label.make_with_text (l_no_command_is_running)
			create send_input_btn.make
			create input_field
			create save_output_btn.make
			create clear_output_btn.make
			create clear_output_toolbar.make
			create toolbar.make
			create l_del_tool_bar.make

			create l_locale_text.make_with_text (interface_names.l_locale)

			l_ev_empty_lbl.set_minimum_height (State_bar_height)
			l_ev_empty_lbl.set_minimum_width (State_bar_height * 2)
			l_ev_horizontal_box_7.extend (l_ev_empty_lbl)
			l_ev_horizontal_box_7.disable_item_expand (l_ev_empty_lbl)
			output_toolbar.extend (save_output_btn)

			save_output_btn.set_tooltip (f_save_output_button)
			save_output_btn.set_pixmap (stock_pixmaps.general_save_icon)
			save_output_btn.set_pixel_buffer (stock_pixmaps.general_save_icon_buffer)
			save_output_btn.select_actions.extend (agent on_save_output_to_file)

			clear_output_toolbar.extend (clear_output_btn)
			l_ev_horizontal_box_7.extend (output_toolbar)
			l_ev_horizontal_box_7.disable_item_expand (output_toolbar)
			l_ev_horizontal_box_7.extend (clear_output_toolbar)
			l_ev_horizontal_box_7.disable_item_expand (clear_output_toolbar)
			l_ev_horizontal_box_6.extend (l_ev_input_lbl)
			l_ev_horizontal_box_6.extend (input_field)
			l_ev_horizontal_box_6.disable_item_expand (l_ev_input_lbl)
			input_toolbar.extend (send_input_btn)
			l_ev_horizontal_box_6.extend (input_toolbar)
			l_ev_horizontal_box_6.extend (l_ev_horizontal_box_7)
			l_ev_horizontal_box_6.disable_item_expand (l_ev_horizontal_box_7)
			l_ev_horizontal_box_6.disable_item_expand (input_toolbar)
			l_ev_horizontal_box_6.set_padding (5)
			main_frame.extend (l_ev_vertical_box_1)
			l_ev_vertical_box_1.extend (l_ev_horizontal_box_1)
			l_ev_horizontal_box_1.extend (l_ev_horizontal_box_2)
			l_ev_horizontal_box_2.extend (l_ev_cmd_lbl)
			l_ev_horizontal_box_2.extend (cmd_lst)
			create l_cell
			l_cell.set_minimum_width (5)
			l_ev_horizontal_box_2.extend (l_cell)
			l_ev_horizontal_box_2.disable_item_expand (l_cell)
			l_ev_horizontal_box_2.extend (l_locale_text)
			l_ev_horizontal_box_2.disable_item_expand (l_locale_text)
			l_ev_horizontal_box_2.extend (locale_combo)
			locale_combo.set_minimum_width (200)
			l_ev_horizontal_box_2.disable_item_expand (locale_combo)
			l_ev_horizontal_box_2.set_padding_width (5)
			l_ev_horizontal_box_5.extend (cmd_toolbar)
			l_ev_horizontal_box_5.extend (toolbar)
			l_ev_horizontal_box_5.disable_item_expand (toolbar)
			l_ev_horizontal_box_5.extend (l_del_tool_bar)
			l_ev_horizontal_box_5.disable_item_expand (cmd_toolbar)
			cmd_toolbar.extend (run_btn)
			cmd_toolbar.extend (terminate_btn)
			cmd_toolbar.extend (tbs)
			cmd_toolbar.extend (edit_cmd_detail_btn)

			edit_external_commands_cmd_btn := a_tool.commands.edit_external_commands_cmd.new_sd_toolbar_item (False)
			toolbar.extend (edit_external_commands_cmd_btn)

			l_del_tool_bar.extend (del_cmd_btn)
			l_ev_horizontal_box_2.extend (l_ev_horizontal_box_5)
			l_ev_horizontal_box_2.disable_item_expand (l_ev_horizontal_box_5)
			l_ev_horizontal_box_2.disable_item_expand (l_ev_cmd_lbl)
			l_ev_vertical_box_1.extend (l_ev_horizontal_box_3)
			l_ev_horizontal_box_3.extend (l_ev_vertical_box_2)
			l_ev_output_lbl.align_text_left
			l_ev_vertical_box_2.extend (l_ev_output_lbl)
			l_ev_vertical_box_2.disable_item_expand (l_ev_output_lbl)
			l_ev_vertical_box_2.extend (output_text)
			l_ev_vertical_box_1.extend (l_ev_horizontal_box_6)
			l_ev_vertical_box_1.disable_item_expand (l_ev_horizontal_box_6)
			l_ev_vertical_box_1.extend (l_ev_horizontal_box_4)
			l_ev_horizontal_box_4.extend (state_label)
			l_ev_vertical_box_1.disable_item_expand (l_ev_horizontal_box_1)
			l_ev_vertical_box_1.disable_item_expand (l_ev_horizontal_box_4)
			l_ev_vertical_box_1.set_padding (4)
			l_ev_vertical_box_1.set_border_width (4)

			del_cmd_btn.set_pixmap (stock_pixmaps.general_delete_icon)
			del_cmd_btn.set_pixel_buffer (stock_pixmaps.general_delete_icon_buffer)
			del_cmd_btn.set_tooltip (f_delete_command)
			del_cmd_btn.select_actions.extend (agent on_delete_command)

			clear_output_btn.set_pixmap (stock_pixmaps.general_reset_icon)
			clear_output_btn.set_pixel_buffer (stock_pixmaps.general_reset_icon_buffer)
			clear_output_btn.set_tooltip (f_clear_output)
			clear_output_btn.select_actions.extend (agent on_clear_output_window)

			output_text.set_foreground_color (preferences.editor_data.normal_text_color)
			output_text.set_background_color (preferences.editor_data.normal_background_color)
			output_text.set_font (preferences.editor_data.font)
			output_text.disable_edit

			terminate_btn.set_pixmap (stock_pixmaps.debug_stop_icon)
			terminate_btn.set_pixel_buffer (stock_pixmaps.debug_stop_icon_buffer)
			stone_director.bind (output_text, Current)

			terminate_btn.set_tooltip (f_terminate_command_button)
			terminate_btn.select_actions.extend (agent on_terminate_process)

			edit_cmd_detail_btn.set_text ("")
			edit_cmd_detail_btn.set_tooltip (f_edit_cmd_detail_button)
			edit_cmd_detail_btn.set_pixmap (stock_pixmaps.general_save_icon)
			edit_cmd_detail_btn.set_pixel_buffer (stock_pixmaps.general_save_icon_buffer)

			state_label.set_minimum_height (State_bar_height)
			state_label.align_text_right
			stone_director.bind (state_label, Current)

			run_btn.set_pixmap (stock_pixmaps.debug_run_icon)
			run_btn.set_pixel_buffer (stock_pixmaps.debug_run_icon_buffer)
			run_btn.set_tooltip (f_start_command_button)
			run_btn.select_actions.extend (agent on_run_process)

			cmd_lst.key_press_actions.extend (agent on_external_cmd_list_key_down (?))
			cmd_lst.change_actions.extend (agent on_cmd_lst_text_change)
			cmd_lst.focus_in_actions.extend (agent on_focus_in_in_cmd_lst)
			cmd_lst.set_text ("")
			check not_void: cmd_lst.choices /= Void end
			register_action (cmd_lst.choices.focus_in_actions, agent on_focus_in_completion_window)

			edit_cmd_detail_btn.set_pixmap (stock_pixmaps.general_add_icon)
			edit_cmd_detail_btn.set_pixel_buffer (stock_pixmaps.general_add_icon_buffer)
			edit_cmd_detail_btn.select_actions.extend (agent on_edit_command_detail)

			input_field.key_press_actions.extend (agent on_key_pressed_in_input_field (?))

			stone_director.bind (input_field, Current)

			send_input_btn.set_pixmap (stock_pixmaps.general_send_enter_icon)
			send_input_btn.set_pixel_buffer (stock_pixmaps.general_send_enter_icon_buffer)
			send_input_btn.set_tooltip (f_send_input_button)
			send_input_btn.select_actions.extend (agent on_send_input_btn_pressed)

			l_ev_cmd_lbl.set_text (l_command)
			l_ev_output_lbl.set_text (l_output)
			l_ev_input_lbl.set_text (l_input)
			stone_director.bind (l_ev_cmd_lbl, Current)
			stone_director.bind (l_ev_output_lbl, Current)
			stone_director.bind (l_ev_input_lbl, Current)

			synchronize_command_list (Void)
			if external_launcher.is_launch_session_over then
				synchronize_on_process_exits
			else
				synchronize_on_process_starts ("")
			end

			output_toolbar.compute_minimum_size
			clear_output_toolbar.compute_minimum_size
			input_toolbar.compute_minimum_size
			cmd_toolbar.compute_minimum_size
			toolbar.compute_minimum_size
			l_del_tool_bar.compute_minimum_size
			cmd_lst.drop_actions.extend (agent on_stone_dropped_at_cmd_list)
		end

feature -- Basic operation

	synchronize_on_process_starts (cmd_line: STRING)
			-- Synchronize states of relative widgets when process starts.
		do
			force_display
			print_command_name (cmd_line)
			run_btn.disable_sensitive
			edit_cmd_detail_btn.disable_sensitive
			hidden_btn.disable_sensitive
			cmd_lst.disable_sensitive
			del_cmd_btn.disable_sensitive
			develop_window.commands.Edit_external_commands_cmd.disable_sensitive
			save_output_btn.disable_sensitive
			if external_output_manager.target_development_window /= Void then
				if develop_window = external_output_manager.target_development_window then
					send_input_btn.enable_sensitive
					terminate_btn.enable_sensitive
					input_field.enable_sensitive
					if input_field.is_displayed then
						input_field.set_focus
					end
				else
					input_field.disable_sensitive
					send_input_btn.disable_sensitive
					terminate_btn.disable_sensitive
				end
			else
					input_field.enable_sensitive
					if input_field.is_displayed then
						input_field.set_focus
					end
				send_input_btn.enable_sensitive
				terminate_btn.enable_sensitive
			end
		end

	synchronize_on_process_exits
			-- Synchronize states of relative widgets when process exits.
		do
			run_btn.enable_sensitive
			edit_cmd_detail_btn.enable_sensitive
			hidden_btn.enable_sensitive
			cmd_lst.enable_sensitive
			develop_window.commands.Edit_external_commands_cmd.enable_sensitive
			save_output_btn.enable_sensitive
			input_field.disable_sensitive
			send_input_btn.disable_sensitive
			terminate_btn.disable_sensitive
			if develop_window = external_output_manager.target_development_window then
				if cmd_lst.is_displayed then
					cmd_lst.set_focus
				end
			end
			del_cmd_btn.enable_sensitive
			synchronize_command_list (corresponding_external_command)
		end

	clear
			-- Clear window
		do
			output_text.set_text ("")
		end

	print_command_name (name: STRING)
			-- Print command `name' to text fielad in command list box.
		require
			name_not_null: name /= Void
		do
			cmd_lst.set_text (name)
		end

	scroll_to_end
			-- Scroll the console to the bottom.
		do
			output_text.scroll_to_line (output_text.line_count)
		end

	set_focus
			-- Give the focus to the editor.		
		local
			l_env: EV_ENVIRONMENT
		do
			create l_env
			l_env.application.do_once_on_idle (agent set_focus_on_idle)
		end

	quick_refresh_editor
			-- Refresh the editor.
		do
		end

	quick_refresh_margin
			-- Refresh the editor's margin.
		do
		end

	synchronize_command_list (selected_cmd: EB_EXTERNAL_COMMAND)
			-- When external command list is modified through Tools->External Commands...,
			-- synchronize change in command list in external output tool.
			-- `selected_cmd', if not Void, indicates the list item which
			-- should be selected as defaulted.
		local
			ms: HASH_TABLE [EB_EXTERNAL_COMMAND, INTEGER]
			ext_cmd: EB_EXTERNAL_COMMAND
			lst_item: EV_LIST_ITEM
			str: STRING
			text_set: BOOLEAN
		do
			if cmd_lst.is_sensitive then
				str := cmd_lst.text
				ms := develop_window.commands.Edit_external_commands_cmd.commands.twin
				cmd_lst.wipe_out
				from
					ms.start
					text_set := False
				until
					ms.after
				loop
					ext_cmd ?= ms.item_for_iteration
					if ext_cmd /= Void then
						create lst_item.make_with_text (ext_cmd.external_command)

						lst_item.set_data (ext_cmd)
						lst_item.set_tooltip (ext_cmd.name)
						cmd_lst.extend (lst_item)
						if  selected_cmd /= Void and then lst_item.data = selected_cmd then
							lst_item.enable_select
							cmd_lst.set_text (selected_cmd.external_command)
							text_set := True
						end
					end
					ms.forth
				end
				if not text_set then
					cmd_lst.set_text (str)
				end
				if not cmd_lst.text.is_empty then
					cmd_lst.select_all
				end
			end
		end

--	process_block_text (text_block: EB_PROCESS_IO_DATA_BLOCK) is
--			-- Print `text_block' on `output_text'.
--		local
--			str: STRING
--		do
--			str ?= text_block.data
--			if str /= Void then
--				output_text.append_text (source_encoding.convert_to (destination_encoding, str))
--			end
--		end

	show
			-- Show tool.
		do
			Precursor {ES_OUTPUT_TOOL_PANEL}
			if widget /= Void and then widget.is_displayed and then widget.is_sensitive then
				set_focus
			end
		end

feature{NONE} -- Actions

	on_external_cmd_list_key_down (key: EV_KEY)
			-- Check if user pressed enter key in command list box.
			-- If so, launch process indicated by text in this command list box.	
		do
			if key.code = {EV_KEY_CONSTANTS}.key_enter then
				on_run_process
			end
		end

	on_cmd_lst_text_change
			-- Agent called when text in command list box changed.
		local
			str: STRING
			eb: EB_EXTERNAL_COMMAND
		do
			create str.make_from_string (cmd_lst.text)
			str.left_adjust
			str.right_adjust
			str.replace_substring_all ("%N", "")
			str.replace_substring_all ("%R", "")
				-- If there is a command line in command list box,
				-- enable `run_btn', `del_cmd_btn', otherwise, disable them.
			if str.count > 0 then
				run_btn.enable_sensitive
				del_cmd_btn.enable_sensitive
				eb := corresponding_external_command
				if eb /= Void then
					edit_cmd_detail_btn.set_tooltip (f_edit_cmd_detail_button)
					edit_cmd_detail_btn.set_pixmap (stock_pixmaps.view_editor_icon)
					edit_cmd_detail_btn.set_pixel_buffer (stock_pixmaps.view_editor_icon_buffer)
				else
					edit_cmd_detail_btn.set_tooltip (f_new_cmd_detail_button)
					edit_cmd_detail_btn.set_pixmap (stock_pixmaps.general_add_icon)
					edit_cmd_detail_btn.set_pixel_buffer (stock_pixmaps.general_add_icon_buffer)
				end
			else
				run_btn.disable_sensitive
				del_cmd_btn.disable_sensitive
				edit_cmd_detail_btn.set_tooltip (f_new_cmd_detail_button)
				edit_cmd_detail_btn.set_pixmap (stock_pixmaps.general_add_icon)
				edit_cmd_detail_btn.set_pixel_buffer (stock_pixmaps.general_add_icon_buffer)
			end
		end

	on_edit_command_detail
			-- Called when user selected `edit_cmd_detail_btn' to
			-- modify command external in detail.
		local
			str: STRING
			ec: EB_EXTERNAL_COMMAND
		do
			ec := corresponding_external_command
			if ec /= Void then
					-- If external command indicated by text in command list box
					-- exists, pop up an edit dialog and let user edit this command.
				ec.edit_properties (develop_window.window)
				ec.setup_managed_shortcut (develop_window.commands.edit_external_commands_cmd.accelerators)
				shortcut_manager.update_external_commands
			else
					-- If user has just input a new external command,
					-- first check whether we have room for this command.
				if develop_window.commands.edit_external_commands_cmd.menus.count = 10 then
					prompts.show_error_prompt (interface_names.e_external_command_list_full, develop_window.window, Void)
				else
						-- If we have room for this command, pop up a new command
						-- dialog and let user add this new command.
					create str.make_from_string (cmd_lst.text)
					str.left_adjust
					str.right_adjust
					create ec.make_from_new_command_line (develop_window.window, str)
					ec.setup_managed_shortcut (develop_window.commands.edit_external_commands_cmd.accelerators)
					shortcut_manager.update_external_commands
				end
			end
			on_cmd_lst_text_change
			develop_window.commands.edit_external_commands_cmd.refresh_list_from_outside
			develop_window.commands.edit_external_commands_cmd.update_menus_from_outside
		end

	types: SQL_TYPE_CONFORMANCE_CALCULATOR

	node_text (a_node: EPA_BASIC_BLOCK): STRING
		do
			Result := a_node.debug_output
		end

	edge_text (a_start, a_end: EPA_BASIC_BLOCK; a_edge: EPA_CFG_EDGE): STRING
		do
			Result := a_edge.debug_output
		end


	on_run_process
			--
		local
			l_parts: LIST [STRING]
			l_class_name: STRING
			l_feature_name: STRING
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_expr_relation: EPA_EXPRESSION_RELATION
			l_operands: DS_HASH_TABLE [STRING_8, INTEGER_32]
			l_expr: EPA_AST_EXPRESSION
			l_context: ETR_FEATURE_CONTEXT
			l_exprs: DS_HASH_SET [EPA_EXPRESSION]
			l_qualifier: EPA_EXPRESSION_QUALIFIER
			l_replacements: HASH_TABLE [STRING, STRING]
			l_interesting_expressions: DS_HASH_SET [STRING]
			l_path_cal: EPA_SIMPLE_PATH_CONDITION_GENERATOR
			l_finder: EPA_FEATURE_CALL_FINDER
			l_interesting_expr_finder: EPA_INTERESTING_EXPRESSION_FINDER
			l_cursor: DS_HASH_TABLE_CURSOR [DS_HASH_SET [EPA_EXPRESSION], EPA_EXPRESSION]
			l_cursor2: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_predicate_finder: EPA_INTERESTING_PREDICATE_FINDER
			l_query: SEMQ_QUERYABLE_QUERY
			l_gen: SEM_SIMPLE_QUERY_GENERATOR
			l_result: DS_HASH_TABLE [DS_HASH_SET [INTEGER], EPA_EXPRESSION]
			l_vars: HASH_TABLE [INTEGER, STRING]
			l_var_sel: TUPLE [table: STRING; where: STRING]
			l_var_pred: HASH_TABLE [STRING, STRING]
			l_sql: STRING
			l_cgen: EPA_CONSTANT_QUERY_COLLECTOR
			l_consts: HASH_TABLE [STRING, STRING]
			l_squery: SEMQ_WHOLE_QUERYABLE_QUERY
			l_sexecutor: SEMQ_WHOLE_QUERYABLE_QUERY_EXECUTOR
--			l_config: SEMQ_DATABASE_CONNECTION_CONFIG
			l_feature_selector: EPA_FEATURE_SELECTOR
			l_same_feature_collector: EPA_SIMPLE_SAME_FEATURE_COLLECTOR
			l_utility: SEMQ_UTILITY
		do
			io.put_string ("-------------------------------------------%N")
			l_class := first_class_starts_with_name (cmd_lst.text.as_string_8)
			create l_feature_selector
			l_feature_selector.add_query_selector
			l_feature_selector.add_argumented_feature_selector (0, 1)
			l_feature_selector.add_selector (l_feature_selector.not_from_any_feature_selector)
			l_feature_selector.add_exported_feature_selector

			create l_same_feature_collector
			l_same_feature_collector.collect (l_feature_selector.features_from_class (l_class))
			from
				l_same_feature_collector.features.start
			until
				l_same_feature_collector.features.after
			loop
				io.put_string ("---------%N")
				from
					l_same_feature_collector.features.item_for_iteration.start
				until
					l_same_feature_collector.features.item_for_iteration.after
				loop
					io.put_string (l_same_feature_collector.features.item_for_iteration.item.feature_name + "%N")
					l_same_feature_collector.features.item_for_iteration.forth
				end
				l_same_feature_collector.features.forth
			end


--			create l_squery.make (cmd_lst.text.as_string_8, {SEM_CONSTANTS}.object_field_value)

--			create l_config.make
--			l_config.set_password ("83670327")
--			create l_sexecutor.make (l_config)
--			l_sexecutor.execute (l_squery)

--			io.put_string ("-------------------------------------------%N")
--			l_class := first_class_starts_with_name (cmd_lst.text.as_string_8)
--			create l_cgen
--			l_consts := l_cgen.quries (l_class)
--			from
--				l_consts.start
--			until
--				l_consts.after
--			loop
--				io.put_string (l_consts.key_for_iteration + " = " + l_consts.item_for_iteration + "%N")
--				l_consts.forth
--			end
			-- 'B1CB0F82-0131-4CB4-91AE-DE409BB55129'

--			create l_gen
--			l_class := first_class_starts_with_name ("ARRAY")
--			l_feature := l_class.feature_named ("put")

--			io.put_string ("-------------------------------------------%N")
--			l_sql := l_gen.sql_to_select_objects (l_class, l_feature, cmd_lst.text.to_string_8, True, 100)
--			io.put_string (l_Sql)

--			create l_path_cal
--			create l_interesting_expressions.make (10)
--			l_interesting_expressions.set_equality_tester (string_equality_tester)

--			create l_replacements.make (2)
--			l_replacements.compare_objects
--			l_replacements.force ("Current.", "")
--			io.put_string ("-------------------------------------------%N")
--			l_parts := cmd_lst.text.as_string_8.split ('.')
--			l_class_name := l_parts.first
--			l_feature_name := l_parts.last
--			l_class_name.left_adjust
--			l_feature_name.right_adjust
--			io.put_string ("For " + l_class_name + "." + l_feature_name + "%N")
--			l_class := first_class_starts_with_name (l_class_name)
--			l_feature := l_class.feature_named (l_feature_name)

--			create l_predicate_finder
--			l_predicate_finder.find (l_class, l_feature)
--			from
--				l_predicate_finder.last_predicates.start
--			until
--				l_predicate_finder.last_predicates.after
--			loop
--				io.put_string ("%T" + l_predicate_finder.last_predicates.item_for_iteration.text + "%N")
--				l_predicate_finder.last_predicates.forth
--			end

--			create l_interesting_expr_finder
--			l_interesting_expr_finder.find (l_class, l_feature)
--			from
--				l_cursor := l_interesting_expr_finder.last_relevant_expressions.new_cursor
--				l_cursor.start
--			until
--				l_cursor.after
--			loop
--				io.put_string ("Expressions relevant to " + l_cursor.key.text + "%N")
--				from
--					l_cursor2 := l_cursor.item.new_cursor
--					l_cursor2.start
--				until
--					l_cursor2.after
--				loop
--					io.put_string ("%T" + l_cursor2.item.text + "%N")
--					l_cursor2.forth
--				end
--				l_cursor.forth
--			end

--			io.put_string ("Path conditions:%N")
--			from
--				l_cursor2 := l_interesting_expr_finder.last_path_conditions.new_cursor
--				l_cursor2.start
--			until
--				l_cursor2.after
--			loop
--				io.put_string ("%T" + l_cursor2.item.text + "%N")
--				l_cursor2.forth
--			end
--			create l_expr_relation
--			l_operands := operands_with_feature (l_feature)

--			create l_qualifier
--			from
--				l_operands.start
--			until
--				l_operands.after
--			loop
--				io.put_string ("Expressions relevant to " + l_operands.item_for_iteration + "%N")
--				create l_context.make (l_feature, create {ETR_CLASS_CONTEXT}.make (l_class))
--				create l_expr.make_with_text (l_class, l_feature, l_operands.item_for_iteration, l_feature.written_class)
--				l_exprs := l_expr_relation.relevant_expressions (l_expr, l_context, True)
--				from
--					l_exprs.start
--				until
--					l_exprs.after
--				loop
--					l_qualifier.process_expression (l_exprs.item_for_iteration, l_replacements)
--					if not l_qualifier.is_local_detected then
--						io.put_string ("%T" + l_qualifier.last_expression + "%N")
--						l_interesting_expressions.force_last (l_qualifier.last_expression)
--					end
--					l_exprs.forth
--				end
--				l_operands.forth
--			end

--			io.put_string ("Path conditions:%N")
--			l_path_cal.generate (l_class, l_feature)
--			from
--				l_path_cal.path_conditions.start
--			until
--				l_path_cal.path_conditions.after
--			loop
--				l_qualifier.process_expression (l_path_cal.path_conditions.item_for_iteration, l_replacements)
--				io.put_string ("%T" + l_qualifier.last_expression + "%N")
--				l_interesting_expressions.force_last (l_qualifier.last_expression)
--				l_path_cal.path_conditions.forth
--			end

--			create l_finder
--			l_finder.find (l_class, l_feature)
		end

--	on_run_process
--			-- Agent called when launching a process
--		local
----			str: STRING
----			l_strs: LIST [STRING]
----			l_test: SEM_TEST
----			l_rows: INTEGER
----			l_class_name: STRING
----			l_feature_name: STRING
----			l_class: CLASS_C
----			l_feature: FEATURE_I
----			l_expr: EPA_AST_EXPRESSION

----			l_type: TYPE_A
----			l_sql_type: SQL_TYPE
----			l_qtest: SEMQ_TEST
----			l_loader: SEMQ_QUERYABLE_LOADER
----			l_as: EXPR_AS
----			l_cfg: EPA_CONTROL_FLOW_GRAPH
----			l_cfg_builder: EPA_CFG_BUILDER
----			l_printer: EGX_SIMPLE_DOT_GRAPH_PRINTER [EPA_BASIC_BLOCK, EPA_CFG_EDGE]
----			l_collector: EPA_FEATURE_CONDITION_COLLECTOR
----			l_path_condition_collector: EPA_SIMPLE_PATH_CONDITION_GENERATOR
----			l_nested_collector: EPA_NESTED_FEATURE_CALL_COLLECTOR

----			l_daikon_gen: SEM_ARFF_TO_DAIKON_GENERATOR
----			l_arff_reader: WEKA_ARFF_RELATION_LOADER
----			l_file: PLAIN_TEXT_FILE

----			l_tree_parser: RM_DECISION_TREE_PARSER
----			l_tree: RM_DECISION_TREE
----			l_relations: DS_HASH_TABLE [WEKA_ARFF_RELATION, RM_DECISION_TREE_PATH]
----			l_path: RM_DECISION_TREE_PATH
----			l_arff: WEKA_ARFF_RELATION
----			l_arffs: HASH_TABLE [WEKA_ARFF_RELATION, STRING]
----			l_passing_arff: WEKA_ARFF_RELATION
----			l_failing_arff: WEKA_ARFF_RELATION
----			l_invs, l_passing_invs, l_failing_invs: like invariants_from_arff_relation
----			l_diff: DS_HASH_SET [DKN_INVARIANT]
----			l_faults: LINKED_LIST [ARRAYED_LIST [STRING]]
----			l_column: INTEGER
----			l_graph: EGX_GENERAL_GRAPH [STRING, STRING]
----			l_runner: RM_PROCESS_RUNNER
--		do
----			io.put_string ("----------------------------------------------------------%N")
----			create l_runner.make ("/home/jasonw/rapidminer")
----			l_runner.parameters.force ("/home/jasonw/tmp/arff/ARRAY/force/ARRAY__force__fault__ARRAY.force.c4.b27.arff", "${INPUT}")
----			l_runner.parameters.force ("/tmp/tree.txt", "${OUTPUT}")
----			l_runner.set_process_file_path ("/home/jasonw/rapid/tree.rmp")
----			l_runner.run
----			io.put_string (l_runner.last_output)
----			io.put_string ("-----------------------------------------------------------------%N")
----			create l_arff_reader
----			l_arff_reader.load_relation (cmd_lst.text.as_string_8)

----			create l_daikon_gen.make
----			l_daikon_gen.generate (l_arff_reader.last_relation)
----			l_invs := invariants_from_arff_relation (l_arff_reader.last_relation)
----			from
----				l_invs.start
----			until
----				l_invs.after
----			loop
----				io.put_string (l_invs.key_for_iteration.name + "%N")
----				from
----					l_invs.item_for_iteration.start
----				until
----					l_invs.item_for_iteration.after
----				loop
----					io.put_string ("%T" + decoded_daikon_name (l_invs.item_for_iteration.item_for_iteration.debug_output) + "%N")
----					l_invs.item_for_iteration.forth
----				end
----				l_invs.forth
----			end


----			create str.make_from_string (cmd_lst.text)
----			str.left_adjust
----			str.right_adjust
----			if str.is_empty then
----				str := "APPLICATION.bar"
----			end

----			l_strs := str.split ('.')
----			l_class_name := l_strs.i_th (1)
----			l_feature_name := l_strs.i_th (2)
----			l_class := first_class_starts_with_name (l_class_name)

----			l_feature := l_class.feature_named (l_feature_name)
----			


----			create l_tree_parser.make ("/home/jasonw/tmp/j48.txt")
----			l_tree_parser.parse
----			l_tree := l_tree_parser.last_node_as_tree ("fault_signature")
----			l_graph := graph_of_decision_tree (l_tree)
----			save_graph_to_dot_file (l_graph, "/home/jasonw/tmp/j48.dot")
----			io.put_string ("---------------------------------%N")
----			io.put_string (l_tree_parser.last_node_as_tree ("fault_signature").debug_output)
----			io.put_string ("%N")

----			create l_arff_reader.make ("/home/jasonw/tmp/arff__ARRAY__force/new/ARRAY__force__fault__ARRAY.force.c4.b27.arff")
----			l_arff_reader.parse_relation
----			l_column := l_arff_reader.last_relation.attribute_indexes.item (l_arff_reader.last_relation.attribute_by_name ("fault_signature"))
----			create l_faults.make

----			from
----				l_arff_reader.last_relation.start
----			until
----				l_arff_reader.last_relation.after
----			loop
----				if l_arff_reader.last_relation.item_for_iteration.i_th (l_column) ~ "ARRAY.force.c4.b27" then
----					l_faults.extend (l_arff_reader.last_relation.item_for_iteration)
----				end
----				l_arff_reader.last_relation.forth
----			end

----			from
----				l_faults.start
----			until
----				l_faults.after
----			loop
----				l_arff_reader.last_relation.extend (l_faults.item_for_iteration)
----				l_arff_reader.last_relation.extend (l_faults.item_for_iteration)
----				l_arff_reader.last_relation.extend (l_faults.item_for_iteration)
----				l_arff_reader.last_relation.extend (l_faults.item_for_iteration)
----				l_arff_reader.last_relation.extend (l_faults.item_for_iteration)
----				l_faults.forth
----			end

----			l_relations := l_tree.partitioned_relations (l_arff_reader.last_relation)
----			from
----				l_relations.start
----			until
----				l_relations.after
----			loop
----				l_path := l_relations.key_for_iteration
----				l_arff := l_relations.item_for_iteration
----				io.put_string ("%N" + l_relations.key_for_iteration.debug_output + " : " + l_relations.item_for_iteration.count.out + "%N")

----				if not l_path.is_accurate_with_respect_to_training_data then
----					io.put_string ("The above path is not accurate.%N")
----					l_arffs := l_arff.partitions_by_attribute_value (l_arff.attribute_by_name ("fault_signature"))
----					l_passing_arff := l_arffs.item ("[[nonsensical]]")
----					l_failing_arff := l_arffs.item ("ARRAY.force.c4.b27")
----					l_passing_invs := invariants_from_arff_relation (l_passing_arff, "passing_")
----					l_failing_invs := invariants_from_arff_relation (l_failing_arff, "failing_")
----					from
----						l_passing_invs.start
----					until
----						l_passing_invs.after
----					loop
----						io.put_string ("For program point " + l_passing_invs.key_for_iteration.name + " : %N")
----						io.put_string ("%TPassing - Failing = %N")
----						l_diff := l_passing_invs.item_for_iteration.subtraction (l_failing_invs.item (l_passing_invs.key_for_iteration))
----						from
----							l_diff.start
----						until
----							l_diff.after
----						loop
----							io.put_string ("%T%T" + l_diff.item_for_iteration.text + "%N")
----							l_diff.forth
----						end

----						io.put_string ("%TFailing - Passing = %N")
----						l_diff := l_failing_invs.item (l_passing_invs.key_for_iteration).subtraction (l_passing_invs.item_for_iteration)
----						from
----							l_diff.start
----						until
----							l_diff.after
----						loop
----							io.put_string ("%T%T" + l_diff.item_for_iteration.text + "%N")
----							l_diff.forth
----						end
----						l_passing_invs.forth
----						io.put_string ("%N")
----					end
----				end
----				l_relations.forth
----			end

----			create l_daikon_gen.make
----			l_daikon_gen.generate (l_arff_reader.last_relation)

----			create l_file.make_create_read_write ("/home/jasonw/tmp/daikon.decls")
----			l_file.put_string (l_daikon_gen.last_declaration.out)
----			l_file.close

----			create l_file.make_create_read_write ("/home/jasonw/tmp/daikon.dtrace")
----			l_file.put_string (l_daikon_gen.last_trace.out)
----			l_file.close

----			l_as := parsed_quantification (cmd_lst.text.as_string_8)
----			create l_loader
----			l_loader.load (cmd_lst.text.as_string_8)
----		end
----			if types = Void then
----				create types.make_empty
----			end

----			l_class := first_class_starts_with_name (cmd_lst.text.as_string_8)
----			create l_sql_type.make (l_class.constraint_actual_type, 0)
----			types.add_type (l_sql_type)
----			io.put_string ("--------------------------------------------------------%N")
----			io.put_string (types.dumped_types_and_conformance)
----			l_class := first_class_starts_with_name ("APPLICATION")
----			l_feature := l_class.feature_named ("command_line")
----			create l_expr.make_with_text (l_class, l_feature, "i", l_feature.written_class)

----			create str.make_from_string (cmd_lst.text)
----			str.left_adjust
----			str.right_adjust
----			if str.is_empty then
----				str := "APPLICATION.bar"
----			end

----			l_strs := str.split ('.')
----			l_class_name := l_strs.i_th (1)
----			l_feature_name := l_strs.i_th (2)
----			l_class := first_class_starts_with_name (l_class_name)
----			l_feature := l_class.feature_named (l_feature_name)

----			io.put_string ("---------------------------------------%N")

----			create l_path_condition_collector
----			l_path_condition_collector.generate (l_feature.written_class, l_feature)
----			from
----				l_path_condition_collector.path_conditions.start
----			until
----				l_path_condition_collector.path_conditions.after
----			loop
----				io.put_string (l_path_condition_collector.path_conditions.item_for_iteration.text)
----				io.put_string (" (")
----				create l_nested_collector
----				l_nested_collector.collect (l_path_condition_collector.path_conditions.item_for_iteration.ast)
----				from
----					l_nested_collector.nested_calls.start
----				until
----					l_nested_collector.nested_calls.after
----				loop
----					io.put_string (text_from_ast (l_nested_collector.nested_calls.item_for_iteration))
----					io.put_string (", ")
----					l_nested_collector.nested_calls.forth
----				end
----				io.put_string (")%N")
----				l_path_condition_collector.path_conditions.forth
----			end

----			create l_cfg_builder
----			l_cfg_builder.build_from_feature (l_class, l_feature)
----			create l_printer.make (agent node_text, agent edge_text)
----			l_printer.print_graph (l_cfg_builder.last_control_flow_graph)
----			l_printer.print_and_save_graph (l_cfg_builder.last_control_flow_graph, "/tmp/d.dot")

----			create l_qtest
----			l_qtest.test_basic_query (l_class_name, l_feature_name)
----			if l_strs.count > 2 then
----				l_rows := l_strs.i_th (3).to_integer
----			else
----				l_rows := 10
----			end
----			create l_test
----			l_test.test_search_for_feature (l_class_name, l_feature_name, l_rows)
----			l_test.test_for_find_unvisited_breakpoints (l_class_name, l_feature_name)
--		end

	invariants_from_arff_relation (a_relation: WEKA_ARFF_RELATION): DS_HASH_TABLE [DS_HASH_SET [DKN_INVARIANT], DKN_PROGRAM_POINT]
			-- Invariants generalized from data in `a_relation'
		local
			l_daikon_gen: SEM_ARFF_TO_DAIKON_GENERATOR
			l_daikon_command: STRING
			l_decls_file: STRING
			l_trace_file: STRING
		do
			l_daikon_command := "/usr/bin/java daikon.Daikon"
			create l_daikon_gen.make
			l_daikon_gen.set_is_missing_value_included (True)
			l_daikon_gen.generate (a_relation)
			Result := invariants_from_daikon (l_daikon_command, l_daikon_gen.last_declaration, l_daikon_gen.last_trace)
		end

	on_input_to_process (str: STRING)
			-- Called when user press enter in simulated console.
		do
			if external_launcher.launched and then not external_launcher.has_exited then
				external_launcher.put_string (str)
			end
		end

	on_terminate_process
			-- Agent called when terminate a running process
		do
			if external_launcher.launched and then not external_launcher.has_exited then
				external_launcher.terminate
			end
		end

	on_send_input_btn_pressed
			-- Agent called when user pressed `send_input_btn'
		local
			found: BOOLEAN
			l_text: STRING_32
			l_input_text: STRING
			l_string: STRING_GENERAL
		do
			l_text := input_field.text.twin
			l_text.append ("%N")
			if source_encoding /= Void then
				l_string := utf32_to_console_encoding (source_encoding, l_text)
			end
			if l_string = Void then
					-- Conversion fails.
				l_input_text := l_text.as_string_8
			else
				l_input_text := l_string.as_string_8
			end
			on_input_to_process (l_input_text)

			if not l_text.is_empty then
				from
					input_field.start
					found := False
				until
					input_field.after or found
				loop
					if l_text.is_equal (input_field.item.text) then
						found := True
					end
					input_field.forth
				end
				if not found then
					input_field.put_front (create {EV_LIST_ITEM}.make_with_text (l_text))
					if input_field.count > 10 then
						input_field.go_i_th (input_field.count)
						input_field.remove
					end
				end
			end
			input_field.set_text ("")
		end

	on_key_pressed_in_input_field (key: EV_KEY)
			-- Agent called when user press enter in `input_field'
		do
			if key.code = {EV_KEY_CONSTANTS}.key_enter then
				on_send_input_btn_pressed
			end
		end

	on_focus_in_in_cmd_lst
			-- Agent called when focus goes to `input_field'
		local
			l_env: EV_ENVIRONMENT
		do
			create l_env
			l_env.application.do_once_on_idle (agent on_idle_action_for_cmd_lst)
		end

	on_idle_action_for_cmd_lst
			-- Handle focus issue of `cmd_lst' in idle action.
		do
			if last_focus_at_completion_window then
				last_focus_at_completion_window := False
				if cmd_lst /= Void and then not cmd_lst.is_destroyed then
					cmd_lst.set_caret_position (cmd_lst.text.count + 1)
				end
			end
		end

	on_focus_in_completion_window
			-- Agent called when focus goes to completion window.
		do
			last_focus_at_completion_window := True
		end

	on_save_output_to_file
			-- Called when user press Save output button.
		local
			save_tool: EB_SAVE_STRING_TOOL
		do
			if process_manager.is_external_command_running then
				show_warning_dialog (Warning_messages.w_cannot_save_when_external_running, develop_window.window)
			else
				create save_tool.make_and_save (output_text.text, develop_window.window)
			end
		end

	on_clear_output_window
			-- Clear `output_text'.
		do
			clear
		end

	on_delete_command
			-- Agent when user want to delete an external command.
		local
			comm: EB_EXTERNAL_COMMAND
		do
			comm := corresponding_external_command
			if comm /= Void then
				develop_window.commands.edit_external_commands_cmd.commands.put (Void, comm.index)
				develop_window.commands.edit_external_commands_cmd.refresh_list_from_outside
				develop_window.commands.edit_external_commands_cmd.update_menus_from_outside
				cmd_lst.set_text ("")
				external_output_manager.synchronize_command_list (Void)
			else
				cmd_lst.set_text ("")
			end
		end

	on_stone_dropped_at_cmd_list (a_pebble: ANY)
			-- Action to be performed when `a_pebble' is dropped at `cmd_lst'
		local
			l_classi_stone: CLASSI_STONE
			l_feature_stone: FEATURE_STONE
			l_group_stone: CLUSTER_STONE
			l_done: BOOLEAN
			l_new_text: STRING
		do
			l_feature_stone ?= a_pebble
			if l_feature_stone /= Void then
				l_new_text := "{" + l_feature_stone.class_name + "}." + l_feature_stone.feature_name
				l_done := True
			end
			if not l_done then
				l_classi_stone ?= a_pebble
				if l_classi_stone /= Void then
					l_new_text := "{" + l_classi_stone.class_name + "}"
					l_done := True
				end
			end
			if not l_done then
				l_group_stone ?= a_pebble
				if l_group_stone /= Void then
					l_new_text := l_group_stone.group.location.evaluated_path
				end
			end
			if l_new_text /= Void then
				if cmd_lst.has_selection then
					cmd_lst.delete_selection
					cmd_lst.remove_selection
				end
				cmd_lst.insert_text (l_new_text)
			end
		end

feature -- Status reporting

	corresponding_external_command: EB_EXTERNAL_COMMAND
			-- If external command indicated by text in command list box
			-- already exists, return corresponding EB_EXTERNAL_COMMAND object,
			-- otherwise return Void.
		local
			str: STRING
			e_cmd: EB_EXTERNAL_COMMAND
			done: BOOLEAN
			l_commands: HASH_TABLE [EB_EXTERNAL_COMMAND, INTEGER]
		do
			create str.make_from_string (cmd_lst.text)
			str.left_adjust
			str.right_adjust
			if not str.is_empty then
				from
					l_commands := develop_window.commands.edit_external_commands_cmd.commands
					l_commands.start
					done := False
				until
					l_commands.after or done
				loop
					e_cmd ?= l_commands.item_for_iteration
					if e_cmd /= Void then
						if e_cmd.external_command.is_equal (str) then
							done := True
						end
					end
					l_commands.forth
				end
			end
			if done then
				Result := e_cmd
			else
				Result := Void
			end
		end

	is_general: BOOLEAN = false;

feature -- State setting

	display_state (s: STRING_GENERAL; warning: BOOLEAN)
			-- Display state `s' in state bar of this output tool
			-- If this is a `warning' state, display in red color,
			-- otherwise in black color.
		do
			if warning then
				state_label.set_foreground_color (red_color)
			else
				state_label.set_foreground_color (black_color)
			end
			state_label.set_text (s)
		end

feature{NONE}

	show_warning_dialog (msg: STRING_GENERAL; a_window: EV_WINDOW)
			-- Show a warning dialog containing message `msg' in `a_window'.
		require
			msg_not_void: msg /= Void
			msg_not_empty: not msg.is_empty
			a_window_not_void: a_window /= Void
		do
			prompts.show_warning_prompt (msg, a_window, Void)
		end

feature {NONE} -- Recycle

	internal_recycle
			-- To be called before destroying this objects
		do
			cmd_lst.destroy
			state_label.destroy
			main_frame.destroy
			input_field.destroy
			edit_external_commands_cmd_btn.recycle
			external_output_manager.prune (Current)
			toolbar.destroy
			widget.destroy
			Precursor {ES_OUTPUT_TOOL_PANEL}
		end

	internal_detach_entities
			-- <Precursor>
		do
			widget := Void
			text_area := Void
			develop_window := Void
			toolbar := Void
			terminate_btn := Void
			run_btn := Void
			state_label := Void
			main_frame := Void
			cmd_lst := Void
			edit_cmd_detail_btn := Void
			hidden_btn := Void
			input_field := Void
			send_input_btn := Void
			save_output_btn := Void
			clear_output_btn := Void
			del_cmd_btn := Void
			edit_external_commands_cmd_btn := Void
			Precursor {ES_OUTPUT_TOOL_PANEL}
		end

feature {NONE} -- Implementation

	toolbar: SD_TOOL_BAR
			-- Tool bar.

	terminate_btn: SD_TOOL_BAR_BUTTON
			-- Button to terminate running process

	run_btn: SD_TOOL_BAR_BUTTON
			-- Button to launch process

	state_label: EV_LABEL
			-- Label to display process launching status.

	main_frame: EV_VERTICAL_BOX

	cmd_lst: EB_EXTERNAL_CMD_COMBO_BOX
			-- List of external commands.

	edit_cmd_detail_btn: SD_TOOL_BAR_BUTTON
			-- Button to open new/edit external command dialog.

	hidden_btn: SD_TOOL_BAR_TOGGLE_BUTTON
			-- Button to set whether or not external command should be run hidden.

	input_field: EV_COMBO_BOX
			-- Text field where user can type data.

	send_input_btn: SD_TOOL_BAR_BUTTON
			-- Button to send data into launched process.

	save_output_btn: SD_TOOL_BAR_BUTTON
			-- Button to save output from process to file.

	clear_output_btn: SD_TOOL_BAR_BUTTON
			-- Button to clear output window.

	del_cmd_btn: SD_TOOL_BAR_BUTTON
			-- Button to delete an already stored external command

	edit_external_commands_cmd_btn: EB_SD_COMMAND_TOOL_BAR_BUTTON;
			-- Button to recycle

	last_focus_at_completion_window: BOOLEAN
		-- Did last focus stayed in code completation window?

	set_focus_on_idle
			-- Set focus on idle actions.
		local
			l_env: EV_ENVIRONMENT
			l_container: EV_CONTAINER
			l_focused_already: BOOLEAN
			l_widget: EV_WIDGET
		do
			create l_env
			l_container ?= widget
			if l_container /= Void then
				if not l_env.application.is_destroyed then
					l_widget := l_env.application.focused_widget
				end
				if not l_container.is_destroyed and then l_container.has_recursive (l_widget) then
					-- If out tool has focus already, then we don't need set focus again later.
					l_focused_already := True
				end
			end

			if not l_focused_already then
				if cmd_lst.is_displayed and then cmd_lst.is_sensitive then
					cmd_lst.set_focus
				else
					if input_field.is_displayed and then input_field.is_sensitive then
						input_field.set_focus
					end
				end
			end
		end

note
	copyright:	"Copyright (c) 1984-2011, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
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

end -- class EB_EXTERNAL_OUTPUT_TOOL
