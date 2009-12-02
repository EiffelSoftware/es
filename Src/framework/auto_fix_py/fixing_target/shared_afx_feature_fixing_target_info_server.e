note
	description: "Summary description for {SHARED_AFX_FEATURE_FIXING_TARGET_INFO_SERVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_AFX_FEATURE_FIXING_TARGET_INFO_SERVER

feature -- Access

	feature_fixing_target_info_server: AFX_FEATURE_FIXING_TARGET_INFO_SERVER
			-- current effective server
		do
		    Result := server_cell.item
		    if Result = Void then
		        create Result.make
		        server_cell.put (Result)
		    end
		end

feature{AFX_FIX_PROPOSER_I} -- Setting

	set_server_cell (a_server: like feature_fixing_target_info_server)
			-- set `a_server' to be current
		do
		    server_cell.put (a_server)
		ensure
		    server_set: feature_fixing_target_info_server = a_server
		end

feature{NONE} -- Implementation

	server_cell: CELL [detachable AFX_FEATURE_FIXING_TARGET_INFO_SERVER]
			-- once cell
		once
		    create Result.put (Void)
		ensure
		    server_cell_not_void: Result /= Void
		end

note
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
