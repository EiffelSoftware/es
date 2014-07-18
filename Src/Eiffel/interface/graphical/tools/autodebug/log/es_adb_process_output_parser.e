note
	description: "Summary description for {ES_ADB_PROCESS_OUTPUT_PARSER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_PROCESS_OUTPUT_PARSER

inherit
	ES_ADB_SHARED_INFO_CENTER

	SHARED_PLATFORM_CONSTANTS

create
	make

feature{NONE} -- Initialization

	make
			-- Initialization.
		do
			reset_fix_buffer
			is_inside_valid_fix := False
		end

feature -- Operation

	parse (a_line: STRING)
			-- Parse `a_line' as the output of an `ES_ADB_PROCESS',
			-- and trigger the corresponding actions of `info_center'.
		require
			a_line /= Void
		local
			l_started: BOOLEAN
			l_eol_index, l_left_bracket_index, l_right_bracket_index: INTEGER
			l_eol_character: CHARACTER
			l_tag: STRING
			l_tag_end_index: INTEGER
			l_value: STRING
			l_tc_path: PATH
			l_test: ES_ADB_TEST
			l_file_name, l_class_under_test_str: STRING
			l_column_index, l_semicolumn_index: INTEGER
			l_fault_id, l_fix_id: STRING
			l_fault: ES_ADB_FAULT
		do
			from
				l_started := False
				l_eol_character := eol_character
				l_eol_index := 0
			until
				l_eol_index = 0 and then l_started
			loop
				l_started := True

				if not is_inside_valid_fix then
					if l_eol_index + 3 <= a_line.count and then a_line.item (l_eol_index + 1) ~ '<' and then a_line.item (l_eol_index + 2) ~ '[' and then a_line.item (l_eol_index + 3) ~ '-' then
						l_left_bracket_index := l_eol_index + 1
						l_right_bracket_index := a_line.index_of ('>', l_left_bracket_index)
						l_tag := a_line.substring (l_left_bracket_index, l_right_bracket_index)

						if l_tag ~ {AUT_INTERPRETER_PROXY}.Msg_tc_generated then
							l_right_bracket_index := l_left_bracket_index + {AUT_INTERPRETER_PROXY}.Msg_tc_generated.count - 1
							l_eol_index := a_line.index_of (l_eol_character, l_right_bracket_index)
							l_value := a_line.substring (l_right_bracket_index + 1, l_eol_index - 1)
							l_value.prune_all ('%R')
							create l_tc_path.make_from_string (l_value)
							l_file_name := l_tc_path.entry.out
							l_class_under_test_str := l_file_name.substring (5, l_file_name.substring_index ("__", 5) - 1)
							if info_center.config.all_class_names.has (l_class_under_test_str) then
								create l_test.make (l_tc_path)
								info_center.on_test_case_generated (l_test)
							end

						elseif l_tag ~ {ES_ADB_PROGRESS_LOGGER}.Msg_fixing_started then
							l_eol_index := a_line.index_of (l_eol_character, l_right_bracket_index)
							l_value := a_line.substring (l_right_bracket_index + 1, l_eol_index - 1)
							l_value.prune_all ('%R')
							if attached info_center.fault_with_signature_id (l_value) as lt_fault then
								info_center.on_fixing_start (lt_fault)
							end

						elseif l_tag ~ {ES_ADB_PROGRESS_LOGGER}.msg_fix_applied then
							l_column_index := a_line.index_of (':', l_right_bracket_index)
							l_semicolumn_index := a_line.index_of (';', l_column_index)
							l_fault_id := a_line.substring (l_column_index + 1, l_semicolumn_index - 1)

							l_column_index := a_line.index_of (':', l_semicolumn_index)
							l_semicolumn_index := a_line.index_of (';', l_column_index)
							l_fix_id := a_line.substring (l_column_index + 1, l_semicolumn_index - 1)

							l_fault := info_center.fault_with_signature_id (l_fault_id)
							if l_fault /= Void and then attached l_fault.fix_with_id_string (l_fix_id) as lt_fix then
								if attached {ES_ADB_FIX_AUTOMATIC} lt_fix as lt_auto_fix then
									lt_auto_fix.set_has_been_applied
								end
								info_center.on_fix_applied (lt_fix)
							end

						elseif l_tag ~ {AFX_PROXY_LOGGER}.Msg_valid_fix_start then
							is_inside_valid_fix := True
							l_eol_index := a_line.index_of (l_eol_character, l_right_bracket_index)
						end
					else
						l_eol_index := a_line.index_of (l_eol_character, l_eol_index + 1)
					end
				else
					if l_eol_index = a_line.count then
						l_eol_index := 0
					else
						l_tag_end_index := a_line.substring_index ({AFX_PROXY_LOGGER}.Msg_valid_fix_end, l_eol_index + 1)
						if l_tag_end_index = 0 then
							fix_buffer.append (a_line.substring (l_eol_index + 1, a_line.count))
							l_eol_index := 0
						else
							fix_buffer.append (a_line.substring (l_eol_index + 1, l_tag_end_index - 1))
							is_inside_valid_fix := False
							l_eol_index := a_line.index_of (l_eol_character, l_tag_end_index)

							parse_valid_fix_from_buffer
						end
					end
				end
			end
		end

feature{NONE} -- Access

	is_inside_valid_fix: BOOLEAN
			-- Is paring of output inside a valid fix?

	fix_buffer: STRING
			-- Buffer for storing partial text of a fix from the output.

feature{NONE} -- Implementation

	parse_valid_fix_from_buffer
			-- Parse a fix from `fix_buffer'.
			-- Notify all listeners.
		local
			l_fix_buffer: STRING
			l_second_eol_index, l_first_line_start, l_first_line_end, l_second_line_start: INTEGER
			l_fault_signature_id: STRING
			l_second_line, l_fix_subject, l_fix_id_str, l_fix_type: STRING
			l_start, l_end: INTEGER
			l_fix_text: STRING
			l_fault: ES_ADB_FAULT
			l_fix: ES_ADB_FIX
			l_imp_fix: ES_ADB_FIX_IMPLEMENTATION
			l_contract_fix: ES_ADB_FIX_CONTRACT
			l_manual_fix: ES_ADB_FIX_MANUAL
		do
			l_fix_buffer := fix_buffer

				-- ExampleLine: -- FaultID:TWO_WAY_SORTED_SET.duplicate.3.9.TWO_WAY_SORTED_SET.duplicate
			l_first_line_start := l_fix_buffer.index_of (':', 1)
			l_first_line_end   := l_fix_buffer.index_of (';', 1)
			l_fault_signature_id := l_fix_buffer.substring (l_first_line_start + 1, l_first_line_end - 1)
			if attached info_center.fault_signature_from_id (l_fault_signature_id) as lt_signature then
				l_fault := info_center.fault_with_signature (lt_signature, False)

					-- ExampleLine: -- FixInfo:Subject=Fix to implementation;ID=Auto-174;Validity=True;Type=Conditional add;
				l_second_line_start := l_fix_buffer.index_of (':', l_first_line_end)
				l_second_eol_index := l_fix_buffer.index_of (eol_character, l_second_line_start)
				l_second_line := l_fix_buffer.substring (l_second_line_start + 1, l_second_eol_index - 1)
				l_start := l_fix_buffer.index_of ('=', l_second_line_start)
				l_end := l_fix_buffer.index_of (';', l_start)
				l_fix_subject := l_fix_buffer.substring (l_start + 1, l_end - 1)

				l_start := l_fix_buffer.index_of ('=', l_end)
				l_end := l_fix_buffer.index_of (';', l_start)
				l_fix_id_str := l_fix_buffer.substring (l_start + 1, l_end - 1)

				l_start := l_fix_buffer.last_index_of ('=', l_second_eol_index)
				l_end := l_fix_buffer.index_of (';', l_start)
				l_fix_type := l_fix_buffer.substring (l_start + 1, l_end - 1)

				l_fix_text := l_fix_buffer.substring (l_second_eol_index + 1, l_fix_buffer.count)

				if l_fix_subject ~ {ES_ADB_FIX}.Type_implementation_fix then
					create l_imp_fix.make (l_fault, l_fix_id_str, l_fix_text, l_fix_type, 0.0)
					l_fix := l_imp_fix
				elseif l_fix_subject ~ {ES_ADB_FIX}.type_contract_fix then
					create l_contract_fix.make (l_fault, l_fix_id_str, l_fix_text, l_fix_type, 0.0)
					l_fix := l_contract_fix
				elseif l_fix_subject ~ {ES_ADB_FIX}.type_manual_fix then
					create l_manual_fix.make (l_fault, True, True)
					l_fix := l_manual_fix
				end
				info_center.on_valid_fix_found (l_fix)
			end

			reset_fix_buffer
		end

	eol_character: CHARACTER
			-- EOL character.
		once
			if platform_constants.is_windows then
				Result := '%N'
			elseif platform_constants.is_unix then
				Result := '%N'
			elseif platform_constants.is_mac then
				Result := '%R'
			end
		end

	reset_fix_buffer
			-- Reset the internal state of current.
		do
			fix_buffer := ""
		end



;note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
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
