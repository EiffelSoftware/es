note
	description: "Summary description for {SHARED_AFX_LOGGING_EVENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_AFX_LOGGING_EVENT

feature -- Access

	logging_event: EVENT_TYPE [TUPLE [info: AFX_LOG_ENTRY_I]]
			-- logging event of autoFix process
		do
		    Result := logging_event_cell.item
		end

	set_logging_event (an_event: like logging_event)
			-- set the shared logging event
		do
		    logging_event_cell.put (an_event)
		ensure
		    logging_event_cell_set: an_event = logging_event
		end

feature{NONE} -- Implementation

	logging_event_cell: CELL [EVENT_TYPE [TUPLE [info: AFX_LOG_ENTRY_I]]]
			-- internal storage for logging event
		once
		    create Result.put (create {EVENT_TYPE [TUPLE [info: AFX_LOG_ENTRY_I]]})
		ensure
		    logging_event_cell_not_void: Result /= Void
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
