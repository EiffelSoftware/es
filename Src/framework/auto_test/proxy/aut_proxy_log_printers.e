note
	description: "Summary description for {AUT_PROXY_EVENT_OBSERVER_LIST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PROXY_LOG_PRINTERS

inherit
	AUT_PROXY_LOG_PRINTER
		undefine
			is_equal,
			copy
		redefine
			report_message
		end

	LINKED_LIST [AUT_PROXY_EVENT_OBSERVER]

create
	make

feature -- Setting

	set_start_time (a_time: INTEGER)
			-- Set `start_time' with `a_time'.
		do
			do_all (agent {AUT_PROXY_LOG_PRINTER}.set_start_time (a_time))
		end

	set_end_time (a_time: INTEGER)
			-- Set `end_time' with `a_time'.
		do
			do_all (agent {AUT_PROXY_LOG_PRINTER}.set_end_time (a_time))
		end

feature -- Basic operations

	report_request (a_producer: AUT_PROXY_EVENT_PRODUCER; a_request: AUT_REQUEST)
			-- Process new request.
			--
			-- `a_producer' Producer that triggered `a_request'.
			-- `a_request': Last request sent to interpreter.
		do
			do_all (agent {AUT_PROXY_EVENT_OBSERVER}.report_request (a_producer, a_request))
		end

	report_response (a_producer: AUT_PROXY_EVENT_PRODUCER; a_response: AUT_RESPONSE)
			-- Process new response.
			--
			-- `a_producer' Producer that triggered `a_response'.
			-- `a_response': Last response reveiced from interpreter.
		do
			do_all (agent {AUT_PROXY_EVENT_OBSERVER}.report_response (a_producer, a_response))
		end

	report_comment_line (a_producer: AUT_PROXY_EVENT_PRODUCER; a_line: STRING) is
			-- Report comment line `a_line'.
		do
			do_all (agent {AUT_PROXY_EVENT_OBSERVER}.report_comment_line (a_producer, a_line))
		end

	report_message (a_producer: AUT_PROXY_EVENT_PRODUCER; a_message: STRING; a_type: STRING)
			-- Report `a_message' of type `a_type' from `a_producer'.
		do
			do_all (agent {AUT_PROXY_EVENT_OBSERVER}.report_message (a_producer, a_message, a_type))
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
