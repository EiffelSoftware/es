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
			l_gui: ALIAS_ANALYZER_GUI
			l_test_suite: ALIAS_ANALYZER_TEST_SUITE
			l_ast_viewer: ALIAS_ANALYZER_AST_VIEWER
		do
			create Result

			create l_gui.make (develop_window)
			Result.extend (l_gui)
			Result.set_item_text (l_gui, "GUI")

			create l_test_suite.make
			Result.extend (l_test_suite)
			Result.set_item_text (l_test_suite, "Test Suite")

			create l_ast_viewer.make
			Result.extend (l_ast_viewer)
			Result.set_item_text (l_ast_viewer, "AST Viewer")
		end

feature {NONE}

	build_tool_interface (root_widget: EV_NOTEBOOK)
		do
		end

	create_tool_bar_items: detachable ARRAYED_LIST [SD_TOOL_BAR_ITEM]
		do
		end

	on_stone_changed (s: detachable like stone)
		do
		end

note
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
