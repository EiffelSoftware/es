note
	description: "Summary description for {AFX_TIME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_TIME_UTILITY

inherit
	DT_SHARED_SYSTEM_CLOCK

feature -- Access

	time_now: DT_DATE_TIME
			-- Current system time
		do
			Result := system_clock.date_time_now
		end

	duration_from_time (a_start_time: DT_DATE_TIME): INTEGER
			-- Duration in millisecond until now, relative to `a_start_time'
		local
			l_time_now: DT_DATE_TIME
			l_duration: DT_DATE_TIME_DURATION
		do
			l_time_now := system_clock.date_time_now
			l_duration := l_time_now.duration (a_start_time)
			l_duration.set_time_canonical
			Result := l_duration.millisecond_count
		end
note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
