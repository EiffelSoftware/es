note
	description: "Facade to access and manipulate Repositories"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_REPOSITORIES_MANAGER

inherit
	EB_CONSTANTS

	EB_SHARED_MANAGERS

	EB_RECYCLABLE

	ES_SHARED_PROMPT_PROVIDER
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (a_parent: EB_TOOL_MANAGER)
			-- Initialization: build the widget and the menu.
		do
			development_window ?= a_parent
			create widget.make (Current, development_window.menus.context_menu_factory)
		end

feature -- Access

	widget: EB_REPOSITORIES_TREE
			-- Widget corresponding to the tree of repositories.

	show_add_repository_dialog
		do
			add_repository_dialog.show
		end

feature -- Basic operations

	new_repository (a_repository_url: STRING_8; a_username, a_password: detachable STRING_8)
		do
			repositories.add_repository (a_repository_url, a_username, a_password)
		end

	remove_repository
		do
			if not (widget.count = 0) then
					-- Only root items can be deleted
				if attached {EB_REPOSITORIES_ROOT}widget.selected_item.data as a_repository then
					repositories.prune (a_repository)
				end
			end
		end

feature {NONE} -- Memory management

	internal_recycle
			-- Recycle `Current', but leave `Current' in an unstable state,
			-- so that we know whether we're still referenced or not.
		do
			if widget /= Void then
				widget.recycle
			end
--			cleanup
			widget := Void
			development_window := Void
		end

feature {EB_REPOSITORIES_TREE} -- Implementation

	development_window: EB_DEVELOPMENT_WINDOW
			-- Associated development window.

	add_repository_dialog: EB_CREATE_REPOSITORY_DIALOG
		once
			create Result.make_default (Current)
		ensure
			result_not_void: Result /= Void
		end
			-- Dialog window to add a new repository

note
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
