note
	description: "Summary description for {EB_REPOSITORIES_ROOT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_REPOSITORIES_ROOT

inherit
	EB_REPOSITORIES_FOLDER
		redefine
			make,
			is_folder,
			is_root,
			string_representation
		end

create
	make

feature {NONE} -- Initialization

	make (a_name: like name; a_parent: EB_REPOSITORIES_ITEM_LIST)
		do
			Precursor (a_name, a_parent)

			create svn_client.make
			svn_client.set_working_path (".")
			svn_client.list.set_target (a_name)
		end

feature -- Status

	is_folder: BOOLEAN
			-- Is the current item a folder?
		do
			Result := False
		end

	is_root: BOOLEAN
			-- Is the current item the repository root?
		do
			Result := True
		end

feature -- Access

	username: detachable STRING_32
		-- Username for Current repository, if any

	password: detachable STRING_32
		-- Password for Current repository, if any

feature -- Element change

	load_repository
			-- Receive the items in the repository and add them to the Current root item
		do
			if attached username as u then
				svn_client.list.put_option ("--username", u)
			end
			if attached password as p then
				svn_client.list.put_option ("--password", p)
			end
			svn_client.list.put_option ("--depth", "infinity")
			svn_client.list.set_on_finish_command (agent did_load_repository)
			svn_client.list.execute
		end

	set_name (a_new_name: STRING_32)
			-- Rename the current folder to `a_new_name'.
		require
			valid_new_name: a_new_name /= Void and then not a_new_name.is_empty
		do
			name := a_new_name
		ensure
			name_set: name.is_equal (a_new_name)
		end

	set_username (a_username: detachable like username)
		do
			username := a_username
		end

	set_password (a_password: detachable like password)
		do
			password := a_password
		end

feature {NONE} -- SVN client response

	did_load_repository
		local
			l_list: SVN_CLIENT_FOLDER
			l_folder: EB_REPOSITORIES_FOLDER
			l_file: EB_REPOSITORIES_FILE
		do
			l_list := svn_client.list.last_list
			from l_list.start
			until l_list.after
			loop
				if l_list.item_for_iteration.is_folder and then attached {SVN_CLIENT_FOLDER}l_list.item_for_iteration as a_folder then
					create l_folder.make(a_folder.name, Current)
					extend (l_folder)
					l_folder.recursively_add_items (a_folder)
				else
					create l_file.make(l_list.item_for_iteration.name, Current)
					extend (l_file)
				end

				l_list.forth
			end
		end

feature {NONE} -- Implementation

	string_representation: STRING_32
			-- String representation for Current.
		do
			Result := name
		end

	svn_client: SVN_CLIENT;
			-- SVN client for Current repository.

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
