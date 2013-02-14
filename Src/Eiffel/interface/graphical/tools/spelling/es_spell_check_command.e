note
	description: "[
		Command to launch spell checker.
		
		Can be added to toolbars and menus.
		Can be executed using stones.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	ES_SPELL_CHECK_COMMAND

inherit

	EB_TOOLBARABLE_AND_MENUABLE_COMMAND
		redefine
			tooltext,
			new_sd_toolbar_item,
			new_mini_sd_toolbar_item
		end

	SHARED_EIFFEL_PROJECT

	SHARED_ERROR_HANDLER

	COMPILER_EXPORTER

	SC_LANGUAGE_UTILITY
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Creation method.
		do
			enable_sensitive
			create spell_checker
				-- TODO. spell_checker.set_language (Default_source_code_language)
			create visitor.make
		end

feature -- Execution

	execute
			-- Execute menu command.
		local
			l_window: EB_DEVELOPMENT_WINDOW
		do
			l_window := window_manager.last_focused_development_window
			if droppable (l_window.stone) then
				execute_with_stone (l_window.stone)
			end
		end

	execute_with_stone (a_stone: STONE)
			-- Execute with `a_stone'.
		do
			execute_with_stone_content (a_stone, Void)
		end

	execute_with_stone_content (a_stone: STONE; a_content: SD_CONTENT)
			-- Execute with `a_stone'.
		local
			l_save_confirm: ES_DISCARDABLE_COMPILE_SAVE_FILES_PROMPT
			l_classes: DS_ARRAYED_LIST [CLASS_I]
		do
			if not eiffel_project.is_compiling then
				if window_manager.has_modified_windows then
					create l_classes.make_default
					window_manager.all_modified_classes.do_all (agent l_classes.force_last)
					create l_save_confirm.make (l_classes)
					l_save_confirm.set_button_action (l_save_confirm.dialog_buttons.yes_button, agent save_compile_and_check(a_stone))
					l_save_confirm.set_button_action (l_save_confirm.dialog_buttons.no_button, agent compile_and_check(a_stone))
					l_save_confirm.show_on_active_window
				else
					compile_and_check (a_stone)
				end
			end
		end

feature {NONE} -- Basic operations

	save_compile_and_check (a_stone: STONE)
			-- Save modified windows, compile project and start spell checker.
		do
			window_manager.save_all_before_compiling
			compile_and_check (a_stone)
		end

	compile_and_check (a_stone: STONE)
			-- Compile project and start spell checker.
		do
			eiffel_project.quick_melt (True, True, True)
			if eiffel_project.successful then
				do_spell_check (a_stone)
			end
		end

	do_spell_check (a_stone: STONE)
			-- Spell check `a_stone'.
		local
			maybe_node: detachable AST_EIFFEL
			failure_information: STRING_32
		do
				-- Reset visitor and find out AST node to check.
			if attached {FEATURE_STONE} a_stone as s then
					-- Check `s.e_feature'.
				visitor.reset_with_root (s.e_feature.associated_class.ast)
				maybe_node := s.e_feature.ast
			elseif attached {CLASSI_STONE} a_stone as s then
					-- Check `s.class_i'.
				if s.class_i.is_compiled then
					visitor.reset_with_root (s.class_i.compiled_class.ast)
					maybe_node := s.class_i.compiled_class.ast
				end
			else
					-- This should not happen.
				check
					False
				end
			end
			if attached maybe_node as node then
				visitor.process_ast_node (node)
				spell_checker.check_words (visitor.words)
				if spell_checker.are_words_checked then
					show_result (generate_text)
				else
					failure_information := "Sorry, the spell checker failed with the following message."
					failure_information.append (Default_newline)
					failure_information.append (spell_checker.failure_message)
					show_result (failure_information)
				end
			end
		end

	spelling_tool: detachable ES_SPELLING_TOOL
			-- Spelling tool (if applicable).
		local
			l_tool: ES_TOOL [EB_TOOL]
			l_window: EB_DEVELOPMENT_WINDOW
		do
			l_window := window_manager.last_focused_development_window
			if not l_window.is_recycled and then l_window.is_visible and then l_window = window_manager.last_focused_development_window then
				l_tool := l_window.shell_tools.tool ({ES_SPELLING_TOOL})
				if attached {ES_SPELLING_TOOL} l_tool as l_spelling_tool then
					Result := l_spelling_tool
				else
					check
						False
					end
				end
			end
		end

	show_spelling_tool
			-- Show spelling tool.
		local
			l_tool: ES_SPELLING_TOOL
		do
			l_tool := spelling_tool
			if l_tool /= Void and then not l_tool.is_recycled then
				l_tool.show (True)
			end
		end

	show_result (results: ANY)
			-- Show results in spelling tool.
		local
			l_tool: ES_SPELLING_TOOL
		do
			l_tool := spelling_tool
			if l_tool /= Void and then not l_tool.is_recycled then
				show_spelling_tool
				l_tool.show_result (results)
			end
		end

feature -- Items

	new_sd_toolbar_item (display_text: BOOLEAN): EB_SD_COMMAND_TOOL_BAR_BUTTON
			-- <Precursor>
		do
			create Result.make (Current)
			initialize_sd_toolbar_item (Result, display_text)
			Result.select_actions.extend (agent execute)
			Result.drop_actions.extend (agent execute_with_stone)
			Result.drop_actions.set_veto_pebble_function (agent droppable)
		end

	new_mini_sd_toolbar_item: EB_SD_COMMAND_TOOL_BAR_BUTTON
			-- <Precursor>
		do
			Result := Precursor {EB_TOOLBARABLE_AND_MENUABLE_COMMAND}
			Result.drop_actions.extend (agent execute_with_stone)
			Result.drop_actions.set_veto_pebble_function (agent droppable)
		end

feature -- Status report

	droppable (a_pebble: ANY): BOOLEAN
			-- Can user drop `a_pebble' on `Current'?
		do
			Result := (attached {FEATURE_STONE} a_pebble) or else (attached {CLASSI_STONE} a_pebble as s and then s.class_i.is_compiled)
		end

feature {NONE} -- Spell checking

	spell_checker: SC_SPELL_CHECKER
			-- Spell checker functionality.

	visitor: ES_SPELL_CHECK_AST_VISITOR
			-- Visitor for source code to collect text.

	generate_text: STRING_32
			-- Generate textual results for completed spell check.
		require
			words_checked: spell_checker.are_words_checked
			counts_equal: spell_checker.last_words_corrections.count = visitor.count
		local
			all_correct: BOOLEAN
		do
			Result := ""
			all_correct := True
			visitor.words.start
			visitor.bases.start
			across
				spell_checker.last_words_corrections as correction
			loop
				if not correction.item.is_correct then
					all_correct := False
					Result.append (visitor.bases.item.line.out + ":" + visitor.bases.item.column.out + " ")
					Result.append ("Misspelled word: " + visitor.words.item + ". ")
					inspect correction.item.suggestions.count
					when 0 then
						Result.append ("No suggestions")
					when 1 then
						Result.append ("Suggestion: ")
					else
						Result.append ("Suggestions: ")
					end
					Result.append (concatenate_texts (correction.item.suggestions, Default_separator))
					Result.append ("." + Default_newline + Default_newline)
				end
				visitor.words.forth
				visitor.bases.forth
			end
			if all_correct then
				Result := "No spelling mistakes found." + Default_newline
			end
		ensure
			exists: Result /= Void and then not Result.is_empty
		end

feature {NONE} -- Implementation

	pixmap: EV_PIXMAP
			-- Pixmap representing command.
		do
			Result := pixmaps.icon_pixmaps.general_tick_icon
		end

	pixel_buffer: EV_PIXEL_BUFFER
			-- Pixel buffer representing command.
		do
			Result := pixmaps.icon_pixmaps.general_tick_icon_buffer
		end

feature {NONE} -- Implementation

	frozen service_consumer: SERVICE_CONSUMER [EVENT_LIST_S]
			-- Access to event list service {EVENT_LIST_S} consumer.
		once
			create Result
		ensure
			result_attached: Result /= Void
		end

	frozen event_list: EVENT_LIST_S
			-- Access to event list service.
		do
			check
				service_consumer.is_service_available
			end
			Result := service_consumer.service
		end

	menu_name: STRING_GENERAL
			-- Name as it appears in menu (with & symbol).
		do
			Result := "Check spelling"
		end

	tooltip: STRING_GENERAL
			-- Tooltip for toolbar button.
		do
			Result := "Check spelling in current class"
		end

	tooltext: STRING_GENERAL
			-- Text for toolbar button.
		do
			Result := "Check spelling"
		end

	description: STRING_GENERAL
			-- Description for this command.
		do
			Result := "Check spelling in current class"
		end

	name: STRING_GENERAL
			-- Name of command. Used to store command in preferences.
		do
			Result := "SpellCheck"
		end

note
	copyright: "Copyright (c) 1984-2013, Eiffel Software"
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
