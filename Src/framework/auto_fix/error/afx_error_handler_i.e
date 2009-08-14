note
	description: "Summary description for {AFX_ERROR_HANDLER_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_ERROR_HANDLER_I

feature -- Error report

	report_error (an_error: AFX_ERROR)
			-- report an error
		deferred
		end

	report_warning (a_warning: AFX_WARNING)
			-- report a warning
		deferred
		end

	report_info (an_info: AFX_INFO)
			-- report an info
		deferred
		end

feature -- Error message report

	report_error_message (a_msg: STRING)
			-- report an error message
		deferred
		end

	report_warning_message (a_msg: STRING)
			-- report a warning message
		deferred
		end

	report_info_message (a_msg: STRING)
			-- report an info message
		deferred
		end

feature -- Pre-emptive error report

	raise_error (a_msg: STRING)
			-- error must be processed immediately, raise an exception
		deferred
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
