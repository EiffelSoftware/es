note
	description: "Refactoring that fixes a rule violation that has been found by the Code Analysis tool."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	ES_CA_FIX_EXECUTOR

inherit

	ERF_CLASS_TEXT_MODIFICATION

	EB_SHARED_WINDOW_MANAGER
		undefine
			is_equal,
			copy
		end

	SHARED_EIFFEL_PROJECT

	ES_CODE_ANALYSIS_BENCH_HELPER

create
	make_with_fix

feature {NONE} -- Initialization

	make_with_fix (a_fix: attached CA_FIX; a_row: attached EV_GRID_ROW)
			-- Initializes `Current' with fix `a_fix' to apply and with GUI grid
			-- row `a_row' (will be painted green when fix has been applied).
		require
			fix_not_yet_applied: not a_fix.applied
		do
			fix := a_fix
			ui_row := a_row
			create helper
				-- Call initialization of {ERF_CLASS_TEXT_MODIFICATION}.
			make (fix.class_to_change.original_class)
		end

feature {NONE} -- Implementation

	fix: CA_FIX
			-- The fix to apply.

	ui_row: EV_GRID_ROW
			-- The associated grid row of the GUI.

	helper: ES_CODE_ANALYSIS_BENCH_HELPER

feature -- Fixing

    apply_fix
            -- Make the changes.
		local
			l_dialog: ES_INFORMATION_PROMPT
        do
        		-- Only continue fixing when there are no unsaved files.
        	if window_manager.has_modified_windows then
        		create l_dialog.make_standard ("You may not apply a fix when there are unsaved changes.")
        		l_dialog.show_on_active_window
        	else
        		window_manager.display_message ("Fixing rule violation...")

        		eiffel_project.quick_melt (True, True, True)
        			-- The compilation must be successful before the fix.
        		if eiffel_project.successful then
					prepare

					execute_fix (False)

		        	commit

						-- Mark the fix as applied so that it may not be applied a second time. Then
						-- color the rule violation entry in the GUI.
					fix.set_applied (True)

						-- Register the undo action
					helper.ca_command.ca_tool.panel.register_undo_action (agent undo_fix)

		        	ui_row.set_background_color (helper.ca_command.fixed_violation_bgcolor.value)

						-- After applying the fix, refresh the editor and analyze again.
		        	refresh_and_analyze

		        	window_manager.display_message ("Fixing rule violation succeeded.")
		        else
		        	create l_dialog.make_standard ("Fix could not be applied due to failed compilation.")
		        	l_dialog.show_on_active_window
		        end
	        end
        end

    refresh_and_analyze
    	do
				-- Refresh the editor window to show changes
        	window_manager.last_focused_development_window.editors_manager.last_focused_editor.set_focus

        		-- Run the code analyzer. We need to create a new CLASSC_STONE because of the recompilation.
			if attached {CLASSC_STONE} helper.ca_command.ca_tool.panel.scope_label.pebble as l_stone then
				helper.ca_command.execute_with_stone (create {CLASSC_STONE}.make (l_stone.e_class))
			else
				helper.ca_command.execute
			end
    	end

	execute_fix (process_leading: BOOLEAN)
			-- Execute `a_visitor' on this class, if we `process_leading' we process all nodes and process the `BREAK_AS' directly,
			-- otherwise we process the `BREAK_AS' at the end.
		require
			text_managed: text_managed
		do
			compute_ast
			if not is_parse_error then
				fix.setup (ast, match_list, process_leading, true)
				fix.execute (ast)

				if not process_leading then
					fix.process_all_break_as
				end
			end

			rebuild_text
			logger.refactoring_class (class_i)
		end

	undo_fix
		require
			fix_applied: is_fix_applied
		local
			l_helper: ES_CODE_ANALYSIS_BENCH_HELPER
		do
			undo
			fix.set_applied (False)

				-- After undoing the fix refresh the editor and analyze again.
			refresh_and_analyze
		end

	is_fix_applied: BOOLEAN
		do
			Result := fix.applied
		end

note
	copyright:	"Copyright (c) 1984-2014, Eiffel Software"
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

end
