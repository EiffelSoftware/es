note
	description: "Summary description for {EB_REPOSITORIES_ITEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EB_REPOSITORIES_ITEM

inherit
	EB_CONSTANTS
		undefine
			is_equal
		end

	ANY
		redefine
			is_equal
		end

feature {NONE} -- Initialization

	make (a_name: like name; a_parent: EB_REPOSITORIES_ITEM_LIST)
			-- Initialize Current with `name' set to `a_name'.
		do
			name := a_name
			parent := a_parent
		end

feature -- Access

	name: STRING_32
			-- Name of the repository item

	parent: EB_REPOSITORIES_ITEM_LIST
			-- Parent for the item.

feature -- Status

	is_folder: BOOLEAN
			-- Is the current item a folder?
		deferred
		end

	is_root: BOOLEAN
			-- Is the current item the repository root?
		deferred
		end

	is_file: BOOLEAN
			-- Is the current item a generic file?
		deferred
		end

	is_equal (other: like Current): BOOLEAN
			-- Compare the names
		do
			Result := (other /= Void) and then (name.is_equal (other.name))
		end

feature -- Element change

	set_parent (a_parent: EB_REPOSITORIES_ITEM_LIST)
			-- Set `parent' to `a_parent'.
		do
			parent := a_parent
		end

	refresh
			-- Refresh current item.
		deferred
		end

feature {EB_REPOSITORIES_ITEM_LIST, EB_REPOSITORIES_ITEM} -- Load/Save

	string_representation: STRING_32
			-- String representation for Current.
		deferred
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
