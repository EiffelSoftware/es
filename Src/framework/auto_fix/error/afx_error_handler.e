note
	description: "Summary description for {AFX_ERROR_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_ERROR_HANDLER

inherit
    AFX_ERROR_HANDLER_I

    SHARED_AFX_ERROR_FACTORY

    EXCEPTIONS

feature -- Access

	errors: DS_ARRAYED_LIST [AFX_ERROR_I]
			-- <Precursor>

	warnings: DS_ARRAYED_LIST [AFX_ERROR_I]
			-- <Precursor>

	info: DS_ARRAYED_LIST [AFX_ERROR_I]
			-- <Precursor>

feature -- Error report

	report_error (an_error: AFX_ERROR)
			-- <Precursor>
		do
		    errors.force_last (an_error)
		end

	report_warning (a_warning: AFX_WARNING)
			-- <Precursor>
		do
			warnings.force_last (a_warning)
		end

	report_info (an_info: AFX_INFO)
			-- <Precursor>
		do
			info.force_last (an_info)
		end

feature -- Error message report

	report_error_message (a_msg: STRING)
			-- <Precursor>
		do
			report_error (error_factory.make_afx_error (a_msg))
		end

	report_warning_message (a_msg: STRING)
			-- <Precursor>
		do
			report_warning (error_factory.make_afx_warning (a_msg))
		end

	report_info_message (a_msg: STRING)
			-- <Precursor>
		do
			report_info (error_factory.make_afx_info (a_msg))
		end

feature -- Pre-emptive error report

	raise_error (a_msg: STRING)
			-- <Precursor>
		do
			raise (a_msg)
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
