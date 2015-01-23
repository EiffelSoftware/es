note
	description: "[
					Command to save project
					]"
	date: "$Date$"
	revision: "$Revision$"

class
	ER_SAVE_PROJECT_COMMAND

inherit
	ER_COMMAND

create
	make

feature {NONE} -- Initlization

	make (a_menu: EV_MENU_ITEM)
			-- Creation method
		require
			not_void: a_menu /= Void
		do
			init
			create shared_singleton
			menu_items.extend (a_menu)
		end

feature -- Command

	execute
			-- <Precursor>
		local
			l_tree_checker: ER_TREE_VALIDATOR
			l_error_dialog: EV_ERROR_DIALOG
		do
			create l_tree_checker
			l_tree_checker.check_tree
			if not l_tree_checker.is_valid then
				if attached main_window as l_win then
					create l_error_dialog.make_with_text ("Error(s) found, please check Layout Constructor's tree.")
					l_error_dialog.set_buttons (<<"OK">>)
					l_error_dialog.show_modal_to_window (l_win)
				end
			end
			if attached shared_singleton.layout_constructor_list.first as l_layout_constructor then
				l_layout_constructor.save_tree
			end
		end

	set_main_window (a_main_window: ER_MAIN_WINDOW)
			-- Set `main_window' with `a_main_window'
		do
			main_window := a_main_window
		end

feature -- Query

	new_menu_item: SD_TOOL_BAR_BUTTON
			-- Create a menu item
		do
			create Result.make
			Result.set_text ("Save Project")
			Result.set_name ("Save Project")
			Result.set_description ("Save Project")
			Result.select_actions.extend (agent execute)
			tool_bar_items.extend (Result)
		end

feature {NONE} -- Implementation

	main_window: detachable EV_WINDOW
			-- Tool's main window

	shared_singleton: ER_SHARED_TOOLS
			-- Shared singleton
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
