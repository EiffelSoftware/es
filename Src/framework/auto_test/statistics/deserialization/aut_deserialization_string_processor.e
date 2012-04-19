note
	description: "Test case deserializer which load data from a string"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_DESERIALIZATION_STRING_PROCESSOR

inherit
	AUT_DESERIALIZATION_PROCESSOR_I
		redefine
			is_ready
		end

	ITP_TEST_CASE_SERIALIZATION_CONSTANTS

	EQA_TEST_CASE_SERIALIZATION_UTILITY

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize.
		do
			create deserialization_started_event
			create deserialization_finished_event
			create test_case_deserialized_event
		end

feature -- Access

	deserialization_started_event: detachable EVENT_TYPE [TUPLE[]]
			-- <Precursor>

	test_case_deserialized_event: EVENT_TYPE [TUPLE [AUT_DESERIALIZED_TEST_CASE]]
			-- <Precursor>

	deserialization_finished_event: detachable EVENT_TYPE [TUPLE[]]

feature -- Status report

	is_ready: BOOLEAN = True

feature -- Basic operations

	process
			-- Process the serialization specified in `configuration'.
		local
			l_lines: LIST [STRING]
			l_pre_ser_index: INTEGER
			idx1: INTEGER
			idx2: INTEGER
			l_serialization_length: INTEGER
			l_ser_str: STRING
			l_objects: like last_pre_serialization
			l_test: AUT_DESERIALIZED_TEST_CASE
		do
			if attached test_case_serialization as l_data and then l_data.count > 0 then
				reset_serialization_data
				l_lines := l_data.split ('%N')
				l_pre_ser_index := l_data.substring_index (pre_serialization_tag_start, 1)
				if l_pre_ser_index > 0 then

						-- <time> section
					idx1 := l_data.substring_index (time_tag_start, 1)
					idx2 := l_data.substring_index (time_tag_end, idx1 + 1)
					last_time := l_data.substring (idx1 + time_tag_start.count, idx2 - 1)
					last_time.left_adjust
					last_time.right_adjust

						-- <class> section
					idx1 := l_data.substring_index (class_tag_start, 1)
					idx2 := l_data.substring_index (class_tag_end, idx1 + 1)
					last_class_name := l_data.substring (idx1 + class_tag_start.count, idx2 - 1)
					last_class_name.left_adjust
					last_class_name.right_adjust

						--<code> section
					idx1 := l_data.substring_index (code_tag_start, 1)
					idx2 := l_data.substring_index (code_tag_end, idx1 + 1)
					last_test_case := l_data.substring (idx1 + code_tag_start.count, idx2 - 1)
					last_test_case.left_adjust
					last_test_case.right_adjust

						--<operands> section
					idx1 := l_data.substring_index (operands_tag_start, 1)
					idx2 := l_data.substring_index (operands_tag_end, idx1 + 1)
					last_operands := l_data.substring (idx1 + operands_tag_start.count, idx2 - 1)
					last_operands.replace_substring_all ("%T", "")
					last_operands.left_adjust
					last_operands.right_adjust

						--<all_variables> section
					idx1 := l_data.substring_index (all_variables_tag_start, 1)
					idx2 := l_data.substring_index (all_variables_tag_end, idx1 + 1)
					last_variables := l_data.substring (idx1 + all_variables_tag_start.count, idx2 - 1)
					last_variables.replace_substring_all ("%T", "")
					last_variables.left_adjust
					last_variables.right_adjust

						--<trace> section
					idx1 := l_data.substring_index (trace_tag_start, 1)
					idx2 := l_data.substring_index (trace_tag_end, idx1 + 1)
					last_trace := l_data.substring (idx1 + trace_tag_start.count, idx2 - 1)
					last_trace.left_adjust
					last_trace.right_adjust

						--<hash_code> section
					idx1 := l_data.substring_index (hash_code_tag_start, 1)
					idx2 := l_data.substring_index (hash_code_tag_end, idx1 + 1)
					last_hash_code := l_data.substring (idx1 + hash_code_tag_start.count, idx2 - 1)
					last_hash_code.left_adjust
					last_hash_code.right_adjust

						--<pre_state> section
					idx1 := l_data.substring_index (pre_state_tag_start, 1)
					idx2 := l_data.substring_index (pre_state_tag_end, idx1 + 1)
					last_pre_state := l_data.substring (idx1 + pre_state_tag_start.count, idx2 - 1)
					last_pre_state.replace_substring_all ("%T", "")
					last_pre_state.left_adjust
					last_pre_state.right_adjust

						--<post_state> section
					idx1 := l_data.substring_index (post_state_tag_start, 1)
					idx2 := l_data.substring_index (post_state_tag_end, idx1 + 1)
					last_post_state := l_data.substring (idx1 + post_state_tag_start.count, idx2 - 1)
					last_post_state.replace_substring_all ("%T", "")
					last_post_state.left_adjust
					last_post_state.right_adjust

						--<pre_serialization_length> section
					idx1 := l_data.substring_index (pre_serialization_length_tag_start, 1)
					idx2 := l_data.substring_index (pre_serialization_length_tag_end, idx1 + 1)
					last_length := l_data.substring (idx1 + pre_serialization_length_tag_start.count, idx2 - 1)
					last_length.left_adjust
					last_length.right_adjust
					l_serialization_length := last_length.to_integer

						--<pre_serialization> section					
					idx1 := l_data.substring_index (pre_serialization_tag_start, 1) + pre_serialization_tag_start.count + cdata_tag_start.count
					l_ser_str := l_data.substring (idx1, idx1 + l_serialization_length - 1)
					create last_pre_serialization.make (1, l_serialization_length)
					l_objects := last_pre_serialization
					from
						idx1 := 1
					until
						idx1 > l_serialization_length
					loop
						l_objects.put (l_ser_str.item (idx1).code.as_natural_8, idx1)
						idx1 := idx1 + 1
					end

					create l_test.make (last_class_name,
							last_test_case,
							last_operands,
							last_variables,
							last_trace,
							last_hash_code,
							last_pre_state,
							last_post_state,
							last_time,
							last_pre_serialization)

					if attached test_case_deserialized_event as l_event then
						l_event.publish ([l_test])
					end
				end
			end
		end

	process_test_case (a_data: like test_case_serialization)
			-- Deserialize test case whose serialized data is given by `a_data'.
		do
			set_test_case_serialization (a_data)
			process
		end

feature{NONE} -- Implementation

	test_case_serialization: detachable STRING
			-- Serialized data for a test case

	set_test_case_serialization (a_data: like test_case_serialization)
			-- Set test case serialization data.
		do
			test_case_serialization := a_data
		end

note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
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
