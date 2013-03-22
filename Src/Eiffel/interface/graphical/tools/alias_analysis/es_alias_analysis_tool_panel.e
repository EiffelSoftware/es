note
	description: "The panel of the alias analysis tool."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ALIAS_ANALYSIS_TOOL_PANEL

inherit

	ES_DOCKABLE_STONABLE_TOOL_PANEL [EV_TEXT]

create
	make

feature

	create_widget: EV_TEXT
		do
			create Result
		end

	build_tool_interface (root_widget: EV_TEXT)
		do
			create analyzer.make
			propagate_drop_actions (Void)
		end

	create_tool_bar_items: detachable ARRAYED_LIST [SD_TOOL_BAR_ITEM]
		do
			create Result.make (2)
			create analyze_button.make
			analyze_button.set_text ("Analyze")
			analyze_button.set_tooltip ("Analyze selected item.")
			analyze_button.set_pixmap (stock_pixmaps.debug_run_icon)
			analyze_button.set_pixel_buffer (stock_pixmaps.debug_run_icon_buffer)
			analyze_button.select_actions.extend (agent run_analyzer)
			analyze_button.select_actions.extend (agent user_widget.append_text ("%N"))
			analyze_button.select_actions.extend (agent user_widget.append_text (guide_drop_message))
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
			create frame_check_toggle.make
			frame_check_toggle.set_text ("Frame")
			frame_check_toggle.set_tooltip ("Detect modified attributes.")
			Result.extend (frame_check_toggle)
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
					user_widget.set_text ("")
				elseif is_in_stone_synchronization then
					analyze_button.enable_sensitive
					user_widget.set_text ({STRING_32} "Press Analyze to process " + stone.stone_name + ".")
				elseif is_runnable then
					analyze_button.enable_sensitive
					run_analyzer
				end
				user_widget.append_text ("%N")
				user_widget.append_text (guide_drop_message)
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

feature {NONE} -- Toolbar

	analyze_button: SD_TOOL_BAR_BUTTON
			-- Button to trigger analyzer.

	stop_button: SD_TOOL_BAR_BUTTON
			-- Button to stop analyzer.

	inherited_assertions_toggle: SD_TOOL_BAR_TOGGLE_BUTTON
			-- Toggle to enable/disable inherited assertion processing.

	frame_check_toggle: SD_TOOL_BAR_TOGGLE_BUTTON
			-- Toggle to enable/disable frame check.

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
			is_frame_check: BOOLEAN
			s: STRING_32
		do
			stop_button.enable_sensitive
			if attached current_class as c then
				analyzer.set_is_inherited_assertion_included (inherited_assertions_toggle.is_selected)
				is_frame_check := frame_check_toggle.is_selected
				analyzer.set_is_frame_check (is_frame_check)
				if attached current_feature as f then
					analyzer.process_feature (f, c,
						agent (ff: FEATURE_I; cc: CLASS_C)
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
								user_widget.set_text (m)
								ev_application.process_events
							end
						(f, c))
					s := {STRING_32} "Processed {"
					s.append_string (c.name)
					s.append_character ('}')
					s.append_character ('.')
					s.append_string (f.feature_name_32)
					s.append_character ('%N')
					s.append_character ('%N')
					analyzer.report_to (s)
				else
					user_widget.set_text ({STRING_32} "Processing " + c.name + "...")
					analyzer.process_class (c,
						agent (cc: CLASS_C)
							local
								m: STRING_32
							do
								m := {STRING_32} "Processing "
								m.append_string (cc.name)
								m.append_string ({STRING_32} "...%N")
								analyzer.report_statistics_to (m)
								user_widget.set_text (m)
								ev_application.process_events
							end
						(c)
					)
					s := {STRING_32} "Processed "
					s.append_string (c.name)
					s.append_character ('.')
					if is_frame_check then
						s.append_character ('%N')
						s.append_character ('%N')
						analyzer.report_to (s)
					end
				end
				s.append_character ('%N')
				s.append_character ('%N')
				analyzer.report_statistics_to (s)
				user_widget.set_text (s)
			end
			stop_button.disable_sensitive
		end

	stop_analyzer
			-- Request the analysis to stop.
		do
			analyzer.stop
		end

	analyzer: ALIAS_ANALYZER
			-- The engine to perform alias analysis.

;note
	copyright: "Copyright (c) 1984-2013, Eiffel Software"
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
