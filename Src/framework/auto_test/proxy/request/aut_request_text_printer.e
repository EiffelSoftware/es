note
	description: "Printer to print requests into text form"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_REQUEST_TEXT_PRINTER

inherit

	AUT_REQUEST_PROCESSOR

	KL_SHARED_STREAMS
		export {NONE} all end

	AUT_SHARED_TYPE_FORMATTER

	AUT_SHARED_INTERPRETER_INFO

	ITP_VARIABLE_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_system: like system; an_output_stream: like output_stream; a_config: like configuration)
			-- Create new request.
		require
			a_system_not_void: a_system /= Void
			an_output_stream_not_void: an_output_stream /= Void
			an_output_stream_is_writable: an_output_stream.is_open_write
			a_config_attached: a_config /= Void
		do
			system := a_system
			set_output_stream (an_output_stream)
			configuration := a_config
			create expression_printer.make (output_stream)
		ensure
			system_set: system = a_system
			output_stream_set: output_stream = an_output_stream
			configuration_set: configuration = a_config
		end

feature -- Access

	system: SYSTEM_I
			-- system

	output_stream: KI_TEXT_OUTPUT_STREAM
			-- Stream that printer writes to

	configuration: TEST_GENERATOR_CONF_I
			-- Configuration

feature -- Setting

	set_output_stream (an_output_stream: like output_stream)
			-- Set `output_stream' to `an_output_stream'.
		require
			an_output_stream_not_void: an_output_stream /= Void
		do
			output_stream := an_output_stream
		ensure
			output_stream_set: output_stream = an_output_stream
		end

feature {AUT_REQUEST} -- Processing

	process_start_request (a_request: AUT_START_REQUEST)
		do
			-- Do nothing.
		end

	process_stop_request (a_request: AUT_STOP_REQUEST)
		do
			output_stream.put_line (":quit")
		end

	process_create_object_request (a_request: AUT_CREATE_OBJECT_REQUEST)
		do
			output_stream.put_string (execute_request_header)
			output_stream.put_string ("create {")
			output_stream.put_string (type_name (a_request.target_type, a_request.creation_procedure))
			output_stream.put_string ("} ")
			output_stream.put_string (a_request.target.name (variable_name_prefix))
			if not a_request.is_default_create_used then
				output_stream.put_string (".")
				output_stream.put_string (a_request.creation_procedure.feature_name)
				print_argument_list (a_request.argument_list)
			end
			output_stream.put_new_line
		end

	process_invoke_feature_request (a_request: AUT_INVOKE_FEATURE_REQUEST)
		do
			output_stream.put_string (execute_request_header)
			if a_request.is_feature_query then
				output_stream.put_string (a_request.receiver.name (variable_name_prefix))
				output_stream.put_character (' ')
				output_stream.put_character (':')
				output_stream.put_character ('=')
				output_stream.put_character (' ')
			end
			output_stream.put_string (a_request.target.name (variable_name_prefix))
			output_stream.put_string (".")
			output_stream.put_string (a_request.feature_to_call.feature_name)
			print_argument_list (a_request.argument_list)
			output_stream.put_new_line
		end

	process_assign_expression_request (a_request: AUT_ASSIGN_EXPRESSION_REQUEST)
		do
			output_stream.put_string (execute_request_header)
			output_stream.put_string (a_request.receiver.name (variable_name_prefix))
			output_stream.put_character (' ')
			output_stream.put_character (':')
			output_stream.put_character ('=')
			output_stream.put_character (' ')
			a_request.expression.process (expression_printer)
			output_stream.put_new_line
		end

	process_type_request (a_request: AUT_TYPE_REQUEST)
		do
			output_stream.put_string (":type ")
			output_stream.put_line (a_request.variable.name (variable_name_prefix))
		end

	process_object_state_request (a_request: AUT_OBJECT_STATE_REQUEST)
			-- Process `a_request'.
		local
			l_variables: HASH_TABLE [TYPE_A, INTEGER]
			l_cursor: CURSOR
			l_stream: like output_stream
		do
			l_stream := output_stream
			l_stream.put_string (once ":state ")
			l_variables := a_request.variables
			l_cursor := l_variables.cursor
			from
				l_variables.start
			until
				l_variables.after
			loop
				l_stream.put_string (variable_name_prefix)
				l_stream.put_string (l_variables.key_for_iteration.out)
				l_stream.put_string (once ": {")
				l_stream.put_string (l_variables.item_for_iteration.name)
				l_stream.put_string (once "}; ")
				l_variables.forth
			end
			l_stream.put_line (once "")
			l_variables.go_to (l_cursor)
		end

	process_precodition_evaluation_request (a_request: AUT_PRECONDITION_EVALUATION_REQUEST)
			-- Process `a_request'.
		do
			-- Do nothing.
		end

	process_predicate_evaluation_request (a_request: AUT_PREDICATE_EVALUATION_REQUEST)
			-- Process `a_request'.
		do
			-- Do nothing.
		end

feature {NONE} -- Printing

	print_argument_list (an_argument_list: DS_LINEAR [ITP_EXPRESSION])
			-- Print argument list `an_arinstruction' to `output_stream'.
		require
			an_argument_list_not_void: an_argument_list /= Void
			no_argument_void: not an_argument_list.has (Void)
		local
			cs: DS_LINEAR_CURSOR [ITP_EXPRESSION]
		do
			if an_argument_list.count > 0 then
				output_stream.put_character (' ')
				output_stream.put_character ('(')
				from
					cs := an_argument_list.new_cursor
					cs.start
				until
					cs.off
				loop
					cs.item.process (expression_printer)
					cs.forth
					if not cs.after then
						output_stream.put_character  (',')
						output_stream.put_character  (' ')
					end
				end
				output_stream.put_character  (')')
			end
		end

	expression_printer: AUT_EXPRESSION_PRINTER
			-- Expression printer

	execute_request_header: STRING = ":execute "
			-- Header for "execute" request

invariant
	system_not_void: system /= Void
	output_stream_not_void: output_stream /= Void
	output_stream_is_writable: output_stream.is_open_write

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
