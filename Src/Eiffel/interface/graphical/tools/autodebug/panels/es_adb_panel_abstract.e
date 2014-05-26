note
	description: "AutoDebug tool interface"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ES_ADB_PANEL_ABSTRACT

inherit

	ES_ADB_TOOL_HELPER
		undefine
			default_create,
			copy,
			is_equal
		end

feature -- Access

	tool_panel: ES_ADB_TOOL_PANEL
			-- AutoDebug tool

	tool_window: EV_WINDOW
			-- Window where `tool_panel' belongs
		do
			Result := tool_panel.develop_window.window
		ensure
			result_attached: Result /= Void
		end

feature -- Tool panel status report

	is_eiffel_compiling: BOOLEAN
			-- Is eiffel compiling?
		do
			Result := tool_panel.is_eiffel_compiling
		end

	is_project_loaded: BOOLEAN
			-- Is a project loaded?
		do
			Result := tool_panel.is_project_loaded
		end

	is_debugging: BOOLEAN
			-- Is debugging running?
		do
			Result := tool_panel.is_debugging
		end

feature -- Action

	on_select
			--
		do
			update_ui
		end

feature -- Current panel status report

	is_up_to_date: BOOLEAN
			-- Is current panel up-to-date?

	is_selected: BOOLEAN
			-- Is current panel selected?

feature{NONE} -- Implementation

	display_status_message (a_msg: READABLE_STRING_GENERAL)
			-- Display `a_msg' in message bar.
		require
			a_msg_attached: a_msg /= Void
		do
			if tool_panel /= Void and then tool_panel.develop_window /= Void and then tool_panel.develop_window.status_bar /= Void then
				tool_panel.develop_window.status_bar.display_message (a_msg)
			end
		end

	display_error_message
			-- Display last error message in `metric_manager'.
		do
			tool_panel.display_error_message
		end

	display_message (a_message: READABLE_STRING_GENERAL)
			-- Display `a_message' in a prompt-out information dialog.
		require
			a_message_attached: a_message /= Void
		do
			(create {ES_SHARED_PROMPT_PROVIDER}).prompts.show_info_prompt (a_message, tool_window, Void)
		end

	update_ui
			-- Update interface
		deferred
		end

feature -- Setting

	set_tool_panel (a_tool: like tool_panel)
			-- Set tool_panel with `a_tool'.
		require
			a_tool_attached: a_tool /= Void
		do
			tool_panel := a_tool
		ensure
			tool_panel_attached: tool_panel /= Void
		end

feature -- Current panel setting

	set_is_up_to_date (b: BOOLEAN)
			-- Set `is_up_to_date' with `b'.
		do
			is_up_to_date := b
		ensure
			is_up_to_date_set: is_up_to_date = b
		end

	set_is_selected (b: BOOLEAN)
			-- Set `is_selected' with `b'.
		do
			is_selected := b
		ensure
			is_selected_set: is_selected = b
		end

invariant
	tool_panel_attached: tool_panel /= Void

note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
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
