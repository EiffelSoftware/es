note
	description: "Summary description for {AFX_LOG_FILE_CONSTANT_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_LOG_FILE_CONSTANT_I

feature -- Constants

	Error_message_type_char: CHARACTER = 'X'
			-- prefix for error messages

	Warning_message_type_char: CHARACTER = '!'
			-- prefix for warning messages

	Info_message_type_char: CHARACTER = 'i'
			-- prefix for info messages

	Debug_info_message_type_char: CHARACTER = '-'
			-- prefix for debug info messages

	Default_log_directory: STRING = "auto_fix"
			-- default log directory

	Default_log_file_name: STRING = "auto_fix"
			-- default log file name

	Default_log_file_extension: STRING = "log"
			-- default log file extension

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
