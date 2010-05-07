note
	description: "Loader to load a test case into a transition"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_FEATURE_CALL_TRANSITION_LOADER_FROM_TEST_CASE

inherit
	EPA_UTILITY

	ITP_VARIABLE_CONSTANTS

	ERL_G_TYPE_ROUTINES

create
	make

feature -- Initialization

	make (a_error_handler: UT_ERROR_HANDLER)
			-- Initialization.
		do
			error_handler := a_error_handler
		end

feature -- Access

	error_handler: UT_ERROR_HANDLER
			-- Error handler.

	last_transition: detachable SEM_FEATURE_CALL_TRANSITION
			-- Transition from last `load_transition' operation.


feature -- Operation

	load_transition (a_file: STRING)
			-- Load a transition from a test case file 'a_file'.
			-- Save the result into `last_transition'.
		local
			l_file: KL_TEXT_INPUT_FILE
			l_handler: like error_handler
			l_length: INTEGER
			l_content, l_line: STRING
			l_reg: RX_PCRE_REGULAR_EXPRESSION
		do
			last_transition := Void
			l_handler := error_handler

			create l_file.make (a_file)
			if l_file.exists then
				l_length := l_file.count
				l_file.open_read
				if l_file.is_open_read then
					from
						create l_content.make (l_length)
					until
						l_file.end_of_file
					loop
						l_file.read_line
						l_content.append (l_file.last_string)
						l_content.append_character ('%N')
					end

					parse_transition_from_string (l_content)
				else
					l_handler.report_error_message ("Error opening file to read: " + a_file)
				end
			else
				l_handler.report_error_message ("File does not exist: " + a_file)
			end
		end

feature{NONE} -- Implementation

	last_test_case_summarization: detachable AUT_TEST_CASE_SUMMARIZATION
			-- Test case summarization from the test case file.

	last_class: detachable CLASS_C
			-- Class of the last feature call.
		require
			last_test_case_summarization_attached: last_test_case_summarization /= Void
		do
			Result := last_test_case_summarization.class_
		end

	last_feature: detachable FEATURE_I
			-- Feature of the last feature call.
		require
			last_test_case_summarization_attached: last_test_case_summarization /= Void
		do
			Result := last_test_case_summarization.feature_
		end

	last_feature_call: detachable AUT_CALL_BASED_REQUEST
			-- Feature call.
		require
			last_test_case_summarization_attached: last_test_case_summarization /= Void
		do
			Result := last_test_case_summarization.test_case
		end

	last_pre_state: detachable EPA_STATE
			-- Object state before the transition.
		require
			last_test_case_summarization_attached: last_test_case_summarization /= Void
		do
			Result := last_test_case_summarization.pre_state
		end

	last_post_state: detachable EPA_STATE
			-- Object state after the transition.
		require
			last_test_case_summarization_attached: last_test_case_summarization /= Void
		do
			Result := last_test_case_summarization.post_state
		end

	last_pre_serialization: ARRAYED_LIST[NATURAL_8]
			-- Serialization data before the test.
		require
			last_pre_serialization_str_attached: last_pre_serialization_str /= Void
		do
			if last_pre_serialization_cache = Void then
				last_pre_serialization_cache := serialization_from_str (last_pre_serialization_str)
			end
			Result := last_pre_serialization_cache
		end

	last_pre_serialization_str: detachable STRING
			-- Last pre serialization data as {STRING}.

	last_post_serialization: ARRAYED_LIST[NATURAL_8]
			-- Serialization data after the test.
		require
			last_post_serialization_str_attached: last_post_serialization_str /= Void
		do
			if last_post_serialization_cache = Void then
				last_post_serialization_cache := serialization_from_str (last_post_serialization_str)
			end
			Result := last_post_serialization_cache
		end

	last_post_serialization_str: detachable STRING
			-- Last post serialization data as {STRING}.

	last_operand_names: detachable HASH_TABLE[STRING, INTEGER]
			-- Hashtable mapping 0-based operand index to the variable name.
		require
			last_test_case_summarization_attached: last_test_case_summarization /= Void
		do
			Result := last_test_case_summarization.operand_position_name_table
		end

	last_operand_types: detachable HASH_TABLE[STRING, STRING]
			-- Map between operand name and its associated type.
		require
			last_test_case_summarization_attached: last_test_case_summarization /= Void
		do
			Result := last_test_case_summarization.operand_name_type_in_string_table
		end

	parse_transition_from_string (a_string: STRING)
			-- Parse a {SEM_FEATURE_CALL_TRANSITION} from 'a_string'.
		local
			l_string: STRING
			l_exception_trace: STRING
			l_class_under_test, l_feature_under_test: STRING
			l_code: STRING
			l_operands_declaration: STRING
			l_pre_state_report, l_post_state_report: STRING
			l_pre_serialization_str, l_post_serialization_str: STRING
			l_summarization: AUT_TEST_CASE_SUMMARIZATION
			l_context: EPA_CONTEXT
			l_pos, l_count: INTEGER
			l_reg: RX_PCRE_REGULAR_EXPRESSION
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_var_table: HASH_TABLE [TYPE_A, ITP_VARIABLE]
			l_pre_state, l_post_state: EPA_STATE_TRANSITION_MODEL_STATE
			l_is_creation: BOOLEAN
		do
			l_count := a_string.count

			-- Exception trace
			l_reg := Reg_exception_trace
			l_reg.match (a_string)
			check l_reg.has_matched end
			l_exception_trace := l_reg.captured_substring (1)
			l_pos := l_reg.captured_end_position (1)

			-- Pre serialization
			l_reg := Reg_pre_serialization
			l_reg.match_substring (a_string, l_pos, l_count)
			check l_reg.has_matched end
			last_pre_serialization_str := l_reg.captured_substring (1)
			l_pos := l_reg.captured_end_position (1)

			-- Post serialization
			l_reg := Reg_post_serialization
			l_reg.match_substring (a_string, l_pos, l_count)
			check l_reg.has_matched end
			last_post_serialization_str := l_reg.captured_substring (1)

			-- Extra information
			l_reg := reg_extra_information
			l_reg.match (a_string)
			check l_reg.has_matched end
			l_string := l_reg.captured_substring (1)
			l_count := l_string.count

			-- Class under test
			l_reg := reg_class_under_test
			l_reg.match (l_string)
			check l_reg.has_matched end
			l_class_under_test := l_reg.captured_substring (1)
			l_pos := l_reg.captured_end_position (1)

			-- Feature under test
			l_reg := reg_feature_under_test
			l_reg.match_substring (l_string, l_pos, l_count)
			check l_reg.has_matched end
			l_feature_under_test := l_reg.captured_substring (1)
			l_pos := l_reg.captured_end_position (1)

			-- Code
			l_reg := Reg_code
			l_reg.match_substring (l_string, l_pos, l_count)
			check l_reg.has_matched end
			l_code := l_reg.captured_substring (1)
			l_pos := l_reg.captured_end_position (1)

			-- Operands declaration
			l_reg := reg_operands_declaration
			l_reg.match_substring (l_string, l_pos, l_count)
			check l_reg.has_matched end
			l_operands_declaration := l_reg.captured_substring (1)
			l_operands_declaration.replace_substring_all ("$", "%N")
			l_pos := l_reg.captured_end_position (1)

			-- Pre state
			l_reg := reg_pre_state
			l_reg.match_substring (l_string, l_pos, l_count)
			check l_reg.has_matched end
			l_pre_state_report := l_reg.captured_substring (1)
			l_pos := l_reg.captured_end_position (1)

			-- Post state
			l_reg := reg_post_state
			l_reg.match_substring (l_string, l_pos, l_count)
			check l_reg.has_matched end
			l_post_state_report := l_reg.captured_substring (1)

			create last_test_case_summarization.make (l_class_under_test, l_code, l_operands_declaration, l_exception_trace, l_pre_state_report, l_post_state_report)
			create last_transition.make (last_class, last_feature, last_operand_names, last_test_case_summarization.context, last_test_case_summarization.is_feature_creation)
			last_transition.set_precondition (last_pre_state)
			last_transition.set_postcondition (last_post_state)
		end

	serialization_from_str (a_str: STRING): ARRAYED_LIST [NATURAL_8]
			-- Get the serialized data in array from the string representation.
		local
			l_numbers: LIST[STRING]
			l_num_str: STRING
			l_num: NATURAL_8
		do
			l_numbers := a_str.split (',')
			create Result.make (l_numbers.count + 1)

			from l_numbers.start
			until l_numbers.after
			loop
				l_num_str := l_numbers.item_for_iteration
				l_num_str.prune_all (' ')
				l_num_str.prune_all ('%N')
				check l_num_str.is_natural_8 end
				Result.force (l_num_str.to_natural_8)

				l_numbers.forth
			end
		end

	last_pre_serialization_cache: detachable ARRAYED_LIST[NATURAL_8]
			-- Cache for `last_pre_serialization'.

	last_post_serialization_cache: detachable ARRAYED_LIST[NATURAL_8]
			-- Cache for `last_post_serialization'.

feature{NONE} -- Constants

	Eiffel_id_pattern: STRING = "([A-Z]|[a-z])([a-z]|[A-Z]|[0-9]|_)*"

	Reg_extra_information: RX_PCRE_REGULAR_EXPRESSION
		once
			create Result.make
			Result.set_caseless (True)
			Result.set_multiline (True)
			Result.set_dotall (True)
			Result.compile ("--<extra_information>(.*)--</extra_information>")
		end

	Reg_pre_serialization: RX_PCRE_REGULAR_EXPRESSION
		once
			create Result.make
			Result.set_caseless (True)
			Result.set_multiline (True)
			Result.set_dotall (True)
			Result.compile ("--<pre_serialization>(.*)--</pre_serialization>")
		end

	Reg_post_serialization: RX_PCRE_REGULAR_EXPRESSION
		once
			create Result.make
			Result.set_caseless (True)
			Result.set_multiline (True)
			Result.set_dotall (True)
			Result.compile ("--<post_serialization>(.*)--</post_serialization>")
		end

	Reg_class_under_test: RX_PCRE_REGULAR_EXPRESSION
		once
			create Result.make
			Result.set_caseless (True)
			Result.set_multiline (True)
			Result.set_dotall (True)
			Result.compile ("<class_under_test>(" + Eiffel_id_pattern + ")</class_under_test>")
		end

	Reg_feature_under_test: RX_PCRE_REGULAR_EXPRESSION
		once
			create Result.make
			Result.set_caseless (True)
			Result.set_multiline (True)
			Result.set_dotall (True)
			Result.compile ("<feature_under_test>(" + Eiffel_id_pattern + ")</feature_under_test>")
		end

	Reg_code: RX_PCRE_REGULAR_EXPRESSION
		once
			create Result.make
			Result.set_caseless (True)
			Result.set_multiline (True)
			Result.set_dotall (True)
			Result.compile ("<code>(.*)</code>")
		end

	Reg_exception_trace: RX_PCRE_REGULAR_EXPRESSION
		once
			create Result.make
			Result.set_caseless (True)
			Result.set_multiline (True)
			Result.set_dotall (True)
			Result.compile ("--<exception_trace>(.*)--</exception_trace>")
		end

	Reg_variable_declaration: RX_PCRE_REGULAR_EXPRESSION
		once
			create Result.make
			Result.set_caseless (True)
			Result.set_multiline (True)
			Result.set_dotall (True)
			Result.compile ("<variable_declaration>(.*)</variable_declaration>")
		end

	Reg_operands_declaration: RX_PCRE_REGULAR_EXPRESSION
		once
			create Result.make
			Result.set_caseless (True)
			Result.set_multiline (True)
			Result.compile ("<operands_declaration>(.*)</operands_declaration>")
		end

	reg_pre_state: RX_PCRE_REGULAR_EXPRESSION
		once
			create Result.make
			Result.set_caseless (True)
			Result.set_multiline (True)
			Result.set_dotall (True)
			Result.compile ("--<pre_state>(.*)--</pre_state>")
		end

	reg_post_state: RX_PCRE_REGULAR_EXPRESSION
		once
			create Result.make
			Result.set_caseless (True)
			Result.set_multiline (True)
			Result.set_dotall (True)
			Result.compile ("--<post_state>(.*)--</post_state>")
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
