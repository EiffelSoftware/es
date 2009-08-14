note
	description: "Summary description for {AFX_FIX_SELECTION_ARBITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_SELECTION_ARBITOR

feature -- query

	is_fix_active (a_fix_id: NATURAL_32) :BOOLEAN
			-- is the fix with id `a_fix_id' specified "active" in current setting?
		do
		    Result := is_valid_fix_id (a_fix_id) and then Active_fix_ids.has(a_fix_id)
		end

	is_valid_fix_id (a_fix_id: NATURAL_32): BOOLEAN
			-- is `a_fix_id' a valid one?
		do
--		    Result := min_fix_id <= a_fix_id and a_fix_id <= max_fix_id	
			Result := True
		end

feature -- registration

	register_active_fix_id (a_fix_id: NATURAL_32)
			-- register an active fix id
		require
		    fix_id_valid: is_valid_fix_id (a_fix_id)
		do
		    Active_fix_ids.put (a_fix_id)
		end

	clear_active_fix_id
			-- clear all registered fix id
		do
			Active_fix_ids.wipe_out
		end

feature -- Access

	Active_fix_ids: BINARY_SEARCH_TREE_SET[NATURAL_32]
			-- set of id's of all currently active fixes
		once
		    if active_fix_ids_internal = Void then
		        create active_fix_ids_internal.make
		    end

		    Result := active_fix_ids_internal
		end

feature -- implementation

	active_fix_ids_internal: detachable BINARY_SEARCH_TREE_SET[NATURAL_32]

;note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
