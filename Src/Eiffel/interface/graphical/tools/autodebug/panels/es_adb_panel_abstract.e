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
			-- Window to which `tool_panel' belongs
		do
			Result := tool_panel.develop_window.window
		ensure
			result_attached: Result /= Void
		end

feature -- UI operation

	is_approved_by_user (a_msg: STRING): BOOLEAN
			-- Is it approved by user to continue with the action described in 'a_msg'.
		require
			a_msg /= Void and then not a_msg.is_empty
		local
			l_confirmation_dialog: like confirmation_dialog
		do
			l_confirmation_dialog := confirmation_dialog
			l_confirmation_dialog.set_text (a_msg)
			l_confirmation_dialog.show_modal_to_window (tool_window)
			Result := l_confirmation_dialog.selected_button ~ (create {EV_DIALOG_CONSTANTS}).ev_ok.as_string_32
		end

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

feature -- GUI

	clear_information_display_widget
			-- Clear all information displayed on panel.
		deferred
		end

	enable_information_display_widget (a_flag: BOOLEAN)
			-- Enable/Disable the widgets related to information display.
		deferred
		end

	enable_command_invocation_widget (a_flag: BOOLEAN)
			-- Enable/Disable the widgets related to command invocation.
		deferred
		end

feature{ES_ADB_TOOL_PANEL} -- Config <-> UI sync

	propogate_values_from_config_to_ui
			-- Propogate settings from config to UI.
		do
		end

	propogate_values_from_ui_to_config
			-- Propogate settings from UI to config.
		do
		end

feature{NONE} -- UI operation implementation

	Confirmation_dialog: EV_CONFIRMATION_DIALOG
			-- (export status {NONE})
		do
			create Result
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
