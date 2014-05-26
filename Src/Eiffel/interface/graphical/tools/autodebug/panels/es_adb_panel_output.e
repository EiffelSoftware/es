note
	description: "Summary description for {ES_ADB_PANEL_OUTPUT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_PANEL_OUTPUT

inherit

	ES_ADB_PANEL_OUTPUT_IMP

	ES_ADB_ACTIONS
		undefine
			copy,
			default_create,
			is_equal
		end

create
	make

feature{NONE} -- Initialization

	make (a_tool: like tool_panel)
			-- Initialization
		require
			a_tool /= Void
		do
			set_tool_panel (a_tool)
			default_create

--			reset_config_widgets (False)
--			reset_command_widgets (False)
--			register_event_handlers

			info_center.extend (Current)
		end

feature

feature -- ADB Action

	on_project_loaded
			-- Action to be performed when project loaded
		do
		end

	on_project_unloaded
			-- Action to be performed when project unloaded
		do
		end

	on_compile_start
			-- Action to be performed when Eiffel compilation starts
		do
		end

	on_compile_stop
			-- Action to be performed when Eiffel compilation stops
		do
		end

	on_debugging_start
			-- Action to be performed when debugging starts
		do

		end

	on_debugging_stop
			-- Action to be performed when debugging stops.
		do
		end

	on_testing_start
			-- Action to be performed when debugging starts
		do
		end

	on_test_case_generated (a_test: ES_ADB_TEST)
			-- Action to be performed when a new test case is generated
		do
		end

	on_testing_stop
		do
		end

	on_fixing_start (a_fault: ES_ADB_FAULT)
			-- <Precursor>
		do
		end

	on_valid_fix_found (a_fix: ES_ADB_FIX)
			-- <Precursor>
		do
		end

	on_fix_applied (a_fix: ES_ADB_FIX)
			-- <Precursor>
		do
		end

	on_fixing_stop (a_fault: ES_ADB_FAULT)
			-- <Precursor>
		do
		end

	on_output (a_line: STRING)
		local
			l_is_caret_at_end: BOOLEAN
		do
			evtext_output.append_text (a_line)
			evtext_output.append_text ("%N")
			evtext_output.set_caret_position (evtext_output.text_length)
		end

feature --

	update_ui
			-- <Precursor>
		do

		end

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
