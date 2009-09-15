note
	description: "Summary description for {SHARED_AFX_LOGGING_INFRASTRUCTURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_AFX_LOGGING_INFRASTRUCTURE

inherit

	SHARED_AFX_LOGGING_SERVICE

	SHARED_AFX_LOG_ENTRY_FACTORY

	AFX_LOGGING_MESSAGE_CONSTANT_I

feature -- Logging

	log_info (a_msg: STRING)
			-- log an info
		local
		    l_logging_service: like logging_service
		    l_entry_factory: like log_entry_factory
		do
		    l_logging_service := logging_service
		    l_entry_factory := log_entry_factory

		    l_logging_service.log (l_entry_factory.make_info_entry (a_msg))
		end

	log_debug (a_msg: STRING)
			-- log a debug info
		local
		    l_logging_service: like logging_service
		    l_entry_factory: like log_entry_factory
		do
		    l_logging_service := logging_service
		    l_entry_factory := log_entry_factory

		    l_logging_service.log (l_entry_factory.make_debug_entry (a_msg))
		end

	log_error (a_msg: STRING)
			-- log an error
		local
		    l_logging_service: like logging_service
		    l_entry_factory: like log_entry_factory
		do
		    l_logging_service := logging_service
		    l_entry_factory := log_entry_factory

		    l_logging_service.log (l_entry_factory.make_error_entry (a_msg))
		end

	log_warning (a_msg: STRING)
			-- log a warning
		local
		    l_logging_service: like logging_service
		    l_entry_factory: like log_entry_factory
		do
		    l_logging_service := logging_service
		    l_entry_factory := log_entry_factory

		    l_logging_service.log (l_entry_factory.make_warning_entry (a_msg))
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
