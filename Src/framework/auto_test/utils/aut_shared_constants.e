note
	description: "Shared constants for the proxy"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_SHARED_CONSTANTS

inherit
	ITP_SHARED_CONSTANTS

feature -- Access

	interpreter_log_prefix: STRING = "%T-- > "
			-- Prefix of messages sent from interpreter in log file

	multi_line_value_start_tag: STRING = "---multi-line-value-start---"
			-- Multi line start tag

	multi_line_value_end_tag: STRING = "---multi-line-value-end---"
			-- Multi line end tag

	interpreter_error_prefix: STRING = "error: "
			-- Prefix for interpreter error message

	interpreter_done_message: STRING = "done:"

	interpreter_success_message: STRING = "status: success"

	interpreter_exception_message: STRING = "status: exception"

	interpreter_type_message_prefix: STRING = "-- Types for TC No."

	proxy_has_started_and_connected_message: STRING = "-- Proxy has started and connected to interpreter."
			-- Message printed to the log when a new interpreter is started

	time_passed_mark: STRING = "-- Time passed: "
			-- String used in proxy log to mark the passing of every minute

	itp_start_time_message: STRING = "-- Interpreter started after: "
			-- String used in proxy log to mark the time of every intepreter start

	exception_thrown_message: STRING = "-- Exception thrown after: "
			-- String used in proxy log to mark the time elpased until an exception is thrown

	object_state_query_prefix: STRING = ">>"

	object_state_value_prefix: STRING = "  "

	object_state_void_value: STRING = "<void>"

	object_state_invariant_violation: STRING is "invariant_violation"

	object_is_void: STRING is "object_is_void"

	test_case_start_tag: STRING is "TC start"
			-- Log tag for test case start

	test_case_end_tag: STRING is "TC end"
			-- Log tag for test case end

	start_request_tag: STRING is "start"

	time_stamp_header: STRING is "-- time stamp: "

	test_case_index_header: STRING is "-- test case No."

	nonsensical: STRING is "nonsensical"

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
