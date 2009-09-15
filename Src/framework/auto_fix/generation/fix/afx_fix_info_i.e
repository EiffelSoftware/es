note
	description: "Summary description for {AFX_FIX_INFO_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_FIX_INFO_I

feature -- Access

	fix_id: INTEGER assign set_fix_id
			-- unique id of the fix
		deferred
		end

	last_fix_report: STRING
			-- fix report built last time
		deferred
		end

feature -- Status report

	is_valid_id: BOOLEAN
			-- is `fix_id' valid?
		do
		    Result := fix_id > 0
		end

feature -- Operation

	apply (a_modifier: AFX_FIX_WRITER)
			-- apply the fix
		deferred
		end

	build_fix_report
			-- build fix report
		deferred
		end

feature{AFX_FIX_REPOSITORY} -- Setting

	set_fix_id (an_id: INTEGER)
			-- set the id of the fix
		require
		    valid_id: an_id > 0
		deferred
		ensure
		    is_valid_id: is_valid_id
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
