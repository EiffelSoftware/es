note
	description: "The panel of the alias analysis tool."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ALIAS_ANALYSIS_TOOL_PANEL

inherit

	ES_DOCKABLE_STONABLE_TOOL_PANEL [EV_NOTEBOOK]

create
	make

feature

	create_widget: EV_NOTEBOOK
		local
			l_vertical_box: EV_VERTICAL_BOX
			l_tool_bar: SD_TOOL_BAR
		do
			create text_area
			create l_tool_bar.make
			across create_console_tool_bar_items as c loop
				l_tool_bar.extend (c.item)
			end
			l_tool_bar.compute_minimum_size

			create l_vertical_box
			l_vertical_box.extend (l_tool_bar)
			l_vertical_box.disable_item_expand (l_tool_bar)
			l_vertical_box.extend (text_area)

			create Result
			Result.extend (l_vertical_box)
			Result.set_item_text (l_vertical_box, "Console")
		end

	build_tool_interface (root_widget: EV_NOTEBOOK)
		local
			l_gui: ALIAS_ANALYZER_GUI
			l_test_suite: ALIAS_ANALYZER_TEST_SUITE
			l_ast_viewer: ALIAS_ANALYZER_AST_VIEWER
		do
			create {ALIAS_ANALYZER_ON_RELATION} alias_analyzer.make
			--create {ALIAS_ANALYZER_ON_GRAPH} alias_analyzer.make
			create {CHANGE_ANALYZER_ON_RELATION} change_analyzer.make
			analyzer := change_analyzer
			propagate_drop_actions (Void)

			-- add these after the `propagate_drop_actions' call:
			create l_gui.make (develop_window)
			root_widget.put_front (l_gui)
			root_widget.set_item_text (l_gui, "GUI")

			create l_test_suite.make
			root_widget.extend (l_test_suite)
			root_widget.set_item_text (l_test_suite, "Test Suite")

			create l_ast_viewer.make
			root_widget.extend (l_ast_viewer)
			root_widget.set_item_text (l_ast_viewer, "AST Viewer")

			root_widget.select_item (l_gui)
		end

	create_tool_bar_items: detachable ARRAYED_LIST [SD_TOOL_BAR_ITEM]
		do
		end

	create_console_tool_bar_items: detachable ARRAYED_LIST [SD_TOOL_BAR_ITEM]
		do
			create Result.make (6)
			create analyze_button.make
			analyze_button.set_text ("Analyze")
			analyze_button.set_tooltip ("Analyze selected item.")
			analyze_button.set_pixmap (stock_pixmaps.debug_run_icon)
			analyze_button.set_pixel_buffer (stock_pixmaps.debug_run_icon_buffer)
			analyze_button.select_actions.extend (agent run_analyzer)
			analyze_button.select_actions.extend (agent text_area.append_text ("%N"))
			analyze_button.select_actions.extend (agent text_area.append_text (guide_drop_message))
			analyze_button.disable_sensitive
			Result.extend (analyze_button)
			create stop_button.make
			stop_button.set_text ("Stop")
			stop_button.set_tooltip ("Stop current analysis.")
			stop_button.set_pixmap (stock_pixmaps.debug_stop_icon)
			stop_button.set_pixel_buffer (stock_pixmaps.debug_stop_icon_buffer)
			stop_button.select_actions.extend (agent stop_analyzer)
			stop_button.disable_sensitive
			Result.extend (stop_button)
			create inherited_assertions_toggle.make
			inherited_assertions_toggle.set_text ("Inherited asserions")
			inherited_assertions_toggle.set_tooltip ("Process inherited assertions.")
			Result.extend (inherited_assertions_toggle)
			create feature_from_any_toggle.make
			feature_from_any_toggle.set_text ("ANY")
			feature_from_any_toggle.set_tooltip ("Process all features, including non-redeclared ones  inherited from ANY.")
			Result.extend (feature_from_any_toggle)
			create change_check_toggle.make
			change_check_toggle.set_text ("Change")
			change_check_toggle.set_tooltip ("Detect changed attributes.")
			change_check_toggle.select_actions.extend
				(agent
					do
						if change_check_toggle.is_selected then
							model_toggle.enable_sensitive
						else
							model_toggle.disable_sensitive
						end
					end)
			Result.extend (change_check_toggle)
			create model_toggle.make
			model_toggle.set_text ("Model")
			model_toggle.set_tooltip ("Report affected model queries instead of attribute changes for change analysis.")
			model_toggle.disable_sensitive
			Result.extend (model_toggle)
		end

feature {NONE}

	on_stone_changed (s: detachable like stone)
			-- Switch to a new `stone'.
		local
			l_retry: BOOLEAN
			l_error_prompt: ES_ERROR_PROMPT
			e: EXCEPTION
		do
			if not l_retry then
				ev_application.process_events
				if not is_runnable then
						-- There is no context to perform the analysis.
					analyze_button.disable_sensitive
					text_area.set_text ("")
				elseif is_in_stone_synchronization then
					analyze_button.enable_sensitive
					text_area.set_text ({STRING_32} "Press Analyze to process " + stone.stone_name + ".")
				elseif is_runnable then
					analyze_button.enable_sensitive
					run_analyzer
				end
				text_area.append_text ("%N")
				text_area.append_text (guide_drop_message)
			end
				-- The following line forces postcondition satisfaction.
				-- Violations happen once in a blue moon, and are possibly related to compilation.
			has_performed_stone_change_notification := False
		rescue
			e := (create {EXCEPTION_MANAGER}).last_exception
			if attached e.description as m then
				create l_error_prompt.make_standard (m)
			else
				create l_error_prompt.make_standard (e.tag)
			end
			l_error_prompt.set_title ("Error while computing aliases")
			l_error_prompt.show_on_active_window
			l_retry := True
			retry
		end

	window_references: LINKED_LIST [EV_TITLED_WINDOW]
			-- References to the displayed windows, so that they don't get garbage collected.

feature {NONE} -- GUI elements

	analyze_button: SD_TOOL_BAR_BUTTON
			-- Button to trigger analyzer.

	stop_button: SD_TOOL_BAR_BUTTON
			-- Button to stop analyzer.

	inherited_assertions_toggle: SD_TOOL_BAR_TOGGLE_BUTTON
			-- Toggle to enable/disable inherited assertion processing.

	feature_from_any_toggle: SD_TOOL_BAR_TOGGLE_BUTTON
			-- Toggle to enable/disable processing of features declared in class ANY.

	change_check_toggle: SD_TOOL_BAR_TOGGLE_BUTTON
			-- Toggle to enable/disable change check.

	model_toggle: SD_TOOL_BAR_TOGGLE_BUTTON
			-- Toggle to enable/disable reporting model queries instead of attribute changes.

	text_area: EV_TEXT

feature {NONE} -- Message

	guide_drop_message: STRING_32 = "Drop a class or a feature to perform alias analysis for it."

feature {NONE} -- Analyzer

	is_runnable: BOOLEAN
			-- Can the analyzer be run?
		do
			Result := attached current_class
		end

	current_class: detachable CLASS_C
			-- The class to run the analyzer on (if any).
		do
			if attached current_feature then
					-- The class is computed from the feature stone.
				check attached {FEATURE_STONE} stone as s and then attached s.e_feature.associated_class as c then
					Result := c
				end
			elseif attached {CLASSC_STONE} stone as s and then attached {CLASS_C} s.e_class as c then
					-- The class is computed from the class stone.
				Result := c
			end
		end

	current_feature: detachable FEATURE_I
			-- The feature to run the analyzer on (if any).
		do
			if attached {FEATURE_STONE} stone as s and then attached s.e_feature.associated_feature_i as f then
				Result := f
			end
		end

	run_analyzer
			-- Run the analysis with associated reports if possible.
		local
			is_explicit_report: BOOLEAN
			s: STRING_32
		do
			stop_button.enable_sensitive
			if attached current_class as c then
				if change_check_toggle.is_selected then
					analyzer := change_analyzer
					change_analyzer.set_is_model_report (model_toggle.is_selected)
				else
					analyzer := alias_analyzer
				end
				analyzer.set_is_inherited_assertion_included (inherited_assertions_toggle.is_selected)
				is_explicit_report := change_check_toggle.is_selected
				analyzer.set_is_all_features (feature_from_any_toggle.is_selected)
				if attached current_feature as f then
					analyzer.process_feature (f, c,
						agent (ff: FEATURE_I; cc: CLASS_C; ag_data: ANY)
							local
								m: STRING_32
							do
								m := {STRING_32} "Processing {"
								m.append_string (cc.name)
								m.append_character ('}')
								m.append_character ('.')
								m.append_string (ff.feature_name_32)
								m.append_string ({STRING_32} "...%N")
								analyzer.report_statistics_to (m)
								text_area.set_text (m)
								ev_application.process_events
							end
						(f, c, ?))
					s := {STRING_32} "Processed {"
					s.append_string (c.name)
					s.append_character ('}')
					s.append_character ('.')
					s.append_string (f.feature_name_32)
					s.append_character ('%N')
					s.append_character ('%N')
					analyzer.report_to (s)
				else
					text_area.set_text ({STRING_32} "Processing " + c.name + "...")
					analyzer.process_class (c,
						agent (cc: CLASS_C; ag_data: ANY)
							local
								m: STRING_32
							do
								m := {STRING_32} "Processing "
								m.append_string (cc.name)
								m.append_string ({STRING_32} "...%N")
								analyzer.report_statistics_to (m)
								text_area.set_text (m)
								ev_application.process_events
							end
						(c, ?)
					)
					s := {STRING_32} "Processed "
					s.append_string (c.name)
					s.append_character ('.')
					if is_explicit_report then
						s.append_character ('%N')
						s.append_character ('%N')
						analyzer.report_to (s)
					end
				end
				s.append_character ('%N')
				s.append_character ('%N')
				analyzer.report_statistics_to (s)
				text_area.set_text (s)
			end
			stop_button.disable_sensitive
		end

	stop_analyzer
			-- Request the analysis to stop.
		do
			analyzer.stop
		end

	analyzer: ALIAS_ANALYZER
			-- The current engine to perform analysis.

	alias_analyzer: ALIAS_ANALYZER
			-- The engine to perform alias analysis.

	change_analyzer: CHANGE_ANALYZER_ON_RELATION
			-- The engine to perform alias analysis.

;note
	copyright: "Copyright (c) 1984-2015, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
