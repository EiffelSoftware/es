note
	description: "Summary description for {AUT_CONSOLE_REQUEST_PRINTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_CONSOLE_REQUEST_PRINTER

inherit
	AUT_REQUEST_PROCESSOR

	AUT_PROXY_LOG_PRINTER

feature -- Setting

	set_start_time (a_time: INTEGER)
			-- Set `start_time' with `a_time'.
		do
		end

	set_end_time (a_time: INTEGER)
			-- Set `end_time' with `a_time'.
		do
		end

feature -- Basic operations

	report_request (a_producer: AUT_PROXY_EVENT_PRODUCER; a_request: AUT_REQUEST)
			-- Process new request.
			--
			-- `a_producer' Producer that triggered `a_request'.
			-- `a_request': Last request sent to interpreter.
		do
			a_request.process (Current)
		end

	report_response (a_producer: AUT_PROXY_EVENT_PRODUCER; a_response: AUT_RESPONSE)
			-- Process new response.
			--
			-- `a_producer' Producer that triggered `a_response'.
			-- `a_response': Last response reveiced from interpreter.
		do
		end

	report_comment_line (a_producer: AUT_PROXY_EVENT_PRODUCER; a_line: STRING) is
			-- Report comment line `a_line'.
		do
		end


feature{AUT_REQUEST} -- Processing

	process_start_request (a_request: AUT_START_REQUEST)
			-- Process `a_request'.
		do
			io.put_string ("Start interpreter%N")
		end

	process_stop_request (a_request: AUT_STOP_REQUEST)
			-- Process `a_request'.
		do
			io.put_string ("Stop interpreter%N")
		end

	process_create_object_request (a_request: AUT_CREATE_OBJECT_REQUEST)
			-- Process `a_request'.
		do
			io.put_string (a_request.target_type.associated_class.name_in_upper + "." + a_request.creation_procedure.feature_name + "%N")
		end

	process_invoke_feature_request (a_request: AUT_INVOKE_FEATURE_REQUEST)
			-- Process `a_request'.
		do
			io.put_string (a_request.target_type.associated_class.name_in_upper + "." + a_request.feature_to_call.feature_name + "%N")
		end

	process_assign_expression_request (a_request: AUT_ASSIGN_EXPRESSION_REQUEST)
			-- Process `a_request'.
		do
		end

	process_type_request (a_request: AUT_TYPE_REQUEST)
			-- Process `a_request'.
		do
		end

	process_object_state_request (a_request: AUT_OBJECT_STATE_REQUEST)
			-- Process `a_request'.
		do
		end

	process_precodition_evaluation_request (a_request: AUT_PRECONDITION_EVALUATION_REQUEST)
			-- Process `a_request'.
		do
		end

	process_predicate_evaluation_request (a_request: AUT_PREDICATE_EVALUATION_REQUEST)
			-- Process `a_request'.
		do
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
