note
	description: "Summary description for {AFX_LOGGING_EVENT_OBSERVER_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_LOGGING_EVENT_OBSERVER_I

inherit

    SHARED_AFX_LOGGING_EVENT

feature -- Logging

	log (an_entry: AFX_LOG_ENTRY_I)
			-- log an entry
		do
		    an_entry.log (Current)
		end

	start_logging
			-- start logging
		deferred
		end

	finish_logging
			-- finish logging
		deferred
		end

	log_error (an_error: AFX_LOG_ENTRY_ERROR)
			-- log an error
		deferred
		end

	log_warning (a_warning: AFX_LOG_ENTRY_WARNING)
			-- log a warning
		deferred
		end

	log_info (an_info: AFX_LOG_ENTRY_INFO)
			-- log an info
		deferred
		end

	log_debug (a_debug: AFX_LOG_ENTRY_DEBUG)
			-- log a debug
		deferred
		end

feature -- Status reporting

	is_logging: BOOLEAN
			-- is logging enabled?
		deferred
		end

	is_logging_error: BOOLEAN
			-- is error logging enabled?
		deferred
		end

	is_logging_warning: BOOLEAN
			-- is warning logging enabled?
		deferred
		end

	is_logging_info: BOOLEAN
			-- is info-logging enabled?
		deferred
		end

	is_logging_debug: BOOLEAN
			-- is debug-logging enabled?
		deferred
		end

	is_benchmarking: BOOLEAN
			-- should time stamps be logged?
		deferred
		end

feature -- Settings

	enable_error_logging (a_state: BOOLEAN)
			-- set state of error-logging to be `a_state'
		deferred
		end

	enable_warning_logging (a_state: BOOLEAN)
			-- set state of warning-logging to be `a_state'
		deferred
		end

	enable_info_logging (a_state: BOOLEAN)
			-- set state of info-logging to be `a_state'
		deferred
		end

	enable_debug_logging (a_state: BOOLEAN)
			-- set state of debug-logging to be `a_state'
		deferred
		end

	enable_benchmarking (a_state: BOOLEAN)
			-- set the state of benchmarking to be `a_state'
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
