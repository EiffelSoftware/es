note
	description: "Summary description for {EB_REPOSITORIES_FOLDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_REPOSITORIES_FOLDER

inherit
	EB_REPOSITORIES_ITEM
		undefine
			make
		end

	EB_REPOSITORIES_ITEM_LIST
		rename
			make as item_list_make
		undefine
			is_equal,
			copy
		redefine
			string_representation
		end

create
	make

feature {NONE} -- Initialization

	make (a_name: like name; a_parent: EB_REPOSITORIES_ITEM_LIST)
			-- Initialize Current with `name' set to `a_name' and
			-- with parent `a_parent'.
		do
				--| To prevent forgetting about current sub items
				--| create the item_list only if never done.
			if not item_list_make_done then
				item_list_make (5)
				item_list_make_done := True
			end

			name := a_name
			parent := a_parent
		end

	item_list_make_done: BOOLEAN
		-- is `item_list_make' already called

feature -- Status

	is_folder: BOOLEAN
			-- Is the current item a folder?
		do
			Result := True
		end

	is_root: BOOLEAN
			-- Is the current item the repository root?
		do
			Result := False
		end

	is_file: BOOLEAN
			-- Is the current item a generic file?
		do
			Result := False
		end

feature -- Element change

	recursively_add_items (a_items: SVN_CLIENT_FOLDER)
			-- Add svn items to `Current' folder
		local
			l_folder: EB_REPOSITORIES_FOLDER
			l_file: EB_REPOSITORIES_FILE
		do
			from a_items.start
			until a_items.after
			loop
				if a_items.item_for_iteration.is_folder and then attached {SVN_CLIENT_FOLDER}a_items.item_for_iteration as a_folder then
					create l_folder.make(a_folder.name, Current)
					extend (l_folder)
					l_folder.recursively_add_items (a_folder)
				else
					create l_file.make(a_items.item_for_iteration.name, Current)
					extend (l_file)
				end
				a_items.forth
			end
		end

	refresh
		do

		end

feature {NONE} -- Implementation

	string_representation: STRING_32
			-- String representation for Current.
		do
				-- do not store folder right now. In the future we might want to store it for caching reasons
			Result := ""
		end

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
