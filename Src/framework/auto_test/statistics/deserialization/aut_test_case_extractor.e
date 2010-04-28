note
	description: "Summary description for {AUT_TEST_CASE_EXTRACTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_TEST_CASE_EXTRACTOR

inherit

	AUT_TEST_CASE_WRITTER_I

	AUT_DESERIALIZATION_DATA_REGISTER
		undefine
			copy,
			is_equal
		end

create
	default_create

feature -- Data event handler

	on_serialization_data (a_data: AUT_DESERIALIZED_DATA; a_is_unique: BOOLEAN)
			-- <Precursor>
		do
			if a_is_unique then
				generate_test_case (a_data)
			end
		end

feature -- Configuration

	config (a_sys: like system; a_session: like session; a_conf: like configuration)
			-- <Precursor>
		local
			l_dir_name: STRING
			l_dir: DIRECTORY
		do
			system := a_sys
			session := a_session
			configuration := a_conf

			-- Prepare directory.
			l_dir_name := test_case_dir.twin
			create l_dir.make (l_dir_name)
			if l_dir.exists then
				l_dir.recursive_delete
			end
		end

feature -- Access

	configuration: TEST_GENERATOR_CONF_I
			-- Configuration of current AutoTest run.

	session: AUT_SESSION
			-- Current AutoTest Session.

	system: SYSTEM_I
			-- Current system.

	test_case_dir: STRING
			-- Directory where the generated test cases would be saved.
		do
			Result := configuration.data_output
		end

feature{NONE} -- Implementation

	generate_test_case (a_data: AUT_DESERIALIZED_DATA)
			-- Generate the test case from 'a_data' and save it into `test_case_dir'.
		require
			is_data_ready: a_data.is_resolved and then a_data.is_good
		local
			l_transition_loader: AUT_FEATURE_CALL_TRANSITION_LOADER_FROM_TEST_CASE
			l_transition: SEM_FEATURE_CALL_TRANSITION
			l_file_name: FILE_NAME
		do
			reset_cache
			current_data := a_data
			write_to (test_case_dir)

			create l_transition_loader.make (create {AUT_ERROR_HANDLER}.make (system))
			create l_file_name.make_from_string (test_case_dir)
			l_file_name.set_subdirectory (tc_class_under_test)
			l_file_name.set_subdirectory (tc_feature_under_test + "__" + tc_directory_postfix)
			l_file_name.set_file_name (tc_class_name)
			l_file_name.add_extension (tc_name_extension)
			l_transition_loader.load_transition (l_file_name)
			l_transition := l_transition_loader.last_transition

			current_data := Void
		end

	tc_class_name: STRING
			-- <Precursor>
			-- Get test case class name 'tc_class_name_cache'.
		local
			l_name: STRING
		do
			if tc_class_name_cache = Void then
				create l_name.make (128)
				l_name.copy (tc_class_name_template)
				l_name.replace_substring_all (ph_class_under_test, tc_class_under_test)
				l_name.replace_substring_all (ph_feature_under_test, tc_feature_under_test)
				l_name.replace_substring_all (ph_success_status, tc_success_status)
				l_name.replace_substring_all (ph_exception_code, tc_exception_code)
				l_name.replace_substring_all (ph_breakpoint_index, tc_breakpoint_index)
				l_name.replace_substring_all (ph_recipient, tc_recipient)
				l_name.replace_substring_all (ph_assertion_tag, tc_assertion_tag)
				l_name.replace_substring_all (ph_hash_code, tc_hash_code)
				l_name.replace_substring_all (ph_uuid, tc_uuid)
				tc_class_name_cache := l_name
			end
			Result := tc_class_name_cache
		end

	tc_exception_code: STRING
			-- If the test case is a failing one, return the exception code.
			-- Otherwise, return "0".
		do
			if tc_exception_code_cache = Void then
				resolve_test_case_information
			end
			Result := tc_exception_code_cache
		end

	tc_breakpoint_index: STRING
			-- If the test case is a failing one, return the breakpoint index.
			-- Otherwise, return "0".
		do
			if tc_breakpoint_index_cache = Void then
				resolve_test_case_information
			end
			Result := tc_breakpoint_index_cache
		end

	tc_recipient: STRING
			-- If the test case is a failing one, return the recipient info in the
			-- 	format of "RC_$(CLASS_NAME)__$(FEATURE_NAME)"
			-- Otherwise, use the class name and feature name under test.
		do
			if tc_recipient_cache = Void then
				resolve_test_case_information
			end
			Result := tc_recipient_cache
		end

	tc_assertion_tag: STRING
			-- If the test case is a failing one, return the tag of violated assertion
			--	in the format of "TAG_$(ASSERTION_TAG)".
			-- Otherwise, return "TAG_noname".
		do
			if tc_assertion_tag_cache = Void then
				resolve_test_case_information
			end
			Result := tc_assertion_tag_cache
		end

	tc_uuid: STRING
			-- <Precursor>
		do
			if tc_uuid_cache = Void then
				update_uuid
			end
			Result := tc_uuid_cache
		end

	tc_summary: STRING
			-- <Precursor>
			-- in the format of 'class_name.feature_name'.
		do
			Result := tc_class_under_test.twin
			Result.append (once ".")
			Result.append (tc_feature_under_test)
		end

	tc_directory_postfix: STRING
			-- <Precursor>
		local
			l_value_set: DS_HASH_SET [AUT_DESERIALIZED_DATA]
			l_count: INTEGER
		do
			l_value_set := register.value_set (current_data.feature_, current_data.class_)
			l_count := l_value_set.count
			Result := (l_count // 5000).out
		end

	tc_code: STRING
			-- <Precursor>
		do
			Result := current_data.code_str
		end

	tc_class_under_test: STRING
			-- <Precursor>
		do
			Result := current_data.class_name_str
		end

	tc_feature_under_test: STRING
			-- <Precursor>
		do
			Result := current_data.feature_.feature_name
		end

	tc_success_status: STRING
			-- <Precursor>
		do
			if current_data.trace_str.count /= 0 then
				Result := "F"
			else
				Result := "S"
			end
		end

	tc_operands_declaration: STRING
			-- <Precursor>
		do
			Result := current_data.operands_str.twin
		end

	tc_variables_declaration: STRING
			-- <Precursor>
		do
			Result := current_data.variables_str.twin
		end

	tc_all_variable_declaration: STRING
			-- <Precursor>
		local
			l_data: like current_data
			l_all_var_table: HASH_TABLE [TYPE_A, ITP_VARIABLE]
			l_var_name: STRING
			l_var: ITP_VARIABLE
			l_type: TYPE_A
			l_line, l_dec: STRING
		do
			l_data := current_data
			create l_all_var_table.make (l_data.operand_types.count + l_data.variable_types.count)
			l_all_var_table.copy (l_data.operand_types)
			l_all_var_table.fill (l_data.variable_types)

			from
				create l_dec.make (128)
				l_all_var_table.start
			until
				l_all_var_table.after
			loop
				l_var := l_all_var_table.key_for_iteration
				l_type := l_all_var_table.item_for_iteration
				l_line := "%T%T%T" + l_var.name (l_data.variable_name_prefix) + ": " + l_type.name + "%N"
				l_dec.append (l_line)

				l_all_var_table.forth
			end
			l_dec.prune_all_trailing ('%N')
			Result := l_dec
		end

	tc_body: STRING
			-- <Precursor>
		local
			l_data: like current_data
			l_testcase: AUT_CALL_BASED_REQUEST
			l_arg_list: DS_LINEAR [ITP_EXPRESSION]
			l_var: ITP_VARIABLE
			l_var_name: STRING
			l_var_index: INTEGER
			l_line: STRING
			l_operand_types, l_variable_types, l_all_types: HASH_TABLE [TYPE_A, ITP_VARIABLE]
		do
			create Result.make (128)
			l_data := current_data
			l_operand_types := l_data.operand_types
			l_variable_types := l_data.variable_types
			create l_all_types.make (l_operand_types.count + l_variable_types.count)
			l_all_types.compare_objects
			l_all_types.copy (l_operand_types)
			l_all_types.fill (l_variable_types)

			-- Initialize all local variables.
			from
				l_all_types.start
			until
				l_all_types.after
			loop
				l_var := l_all_types.key_for_iteration
				l_var_name := l_var.name (l_data.variable_name_prefix)
				l_var_index := l_var.index

				-- Output one line.
				l_line := "%T%T%T" + tc_var_initialization_template.twin
				l_line.replace_substring_all ("$(VAR)", l_var_name)
				l_line.replace_substring_all ("$(INDEX)", l_var_index.out)
				Result.append (l_line)

				l_all_types.forth
			end

			-- Output test case.
			Result.append ("%T%T%T" + l_data.code_str)
		end

	tc_pre_state: STRING
			-- <Precursor>
		do
			Result := current_data.pre_state_str.twin
		end

	tc_post_state: STRING
			-- <Precursor>
		do
			Result := current_data.post_state_str.twin
		end

	tc_trace: STRING
			-- <Precursor>
		do
			Result := "%"[%N"
			Result.append (current_data.trace_str)
			Result.append ("]%"")
		end

	tc_pre_serialization: STRING
			-- <Precursor>
		do
			Result := tc_serialized_data (current_data.pre_serialization)
		end

	tc_post_serialization: STRING
			-- <Precursor>
		do
			Result := tc_serialized_data (current_data.post_serialization)
		end

	tc_serialized_data (a_object: ARRAYED_LIST[NATURAL_8]): STRING
			-- Serialization data, i.e. an array of {NATURAL_8} values, in {STRING}.
		local
			l_data: ARRAYED_LIST[NATURAL_8]
			l_index: INTEGER
			l_line: STRING
		do
			l_data := a_object
			check l_data.count /= 0 end

			from
				create Result.make (l_data.count * 4)
				create l_line.make (128)
				l_index := 1
				l_data.start
			until
				l_data.after
			loop
				l_line.append (l_data.item.out)
				if not l_data.islast then
					l_line.append (", ")
				end

				if l_line.count > 120 or else l_data.islast then
					l_line.append ("%N")
					Result.append (l_line)
					l_line.wipe_out
				end

				l_index := l_index + 1
				l_data.forth
			end
			Result.prune_all_trailing ('%N')
		end

	tc_hash_code: STRING
			-- <Precursor>
		local
			l_hash_string: STRING
			l_index: INTEGER
			l_hash_value: INTEGER
		do
			l_hash_string := current_data.trans_hashcode
			l_index := l_hash_string.index_of ('.', 1)
			l_index := l_hash_string.index_of ('.', l_index + 1)
			l_hash_string := l_hash_string.substring (l_index + 1, l_hash_string.count)
			l_hash_value := l_hash_string.hash_code
			Result := l_hash_value.out
		end

feature{NONE} -- Implementation

	reset_cache
			-- Reset all cached information.
		do
			tc_class_name_cache := Void
			tc_uuid_cache := Void

			-- test case information.
			tc_exception_code_cache := Void
			tc_breakpoint_index_cache := Void
			tc_recipient_cache := Void
			tc_assertion_tag_cache := Void
		end

	tc_exception_code_cache: STRING
	tc_breakpoint_index_cache: STRING
	tc_recipient_cache: STRING
	tc_assertion_tag_cache: STRING

	resolve_test_case_information
			-- Resolve relevant test case information from the exception trace, if any.
			-- The information would be used for constructing the test case class name.
		require
			trace_attached: current_data /= Void and then current_data.trace_str /= Void
		local
			l_trace: STRING
			l_lines: LIST[STRING]
			l_exception_code: STRING
			l_recipient_class, l_recipient_feature: STRING
			l_assertion_tag: STRING
			l_start, l_end: INTEGER
			l_str: STRING
			l_done: BOOLEAN
			l_analyzer: EPA_EXCEPTION_TRACE_ANALYZER
			l_frames: DS_LINEAR [EPA_EXCEPTION_CALL_STACK_FRAME_I]
			l_frame: EPA_EXCEPTION_CALL_STACK_FRAME_I
		do
			l_trace := current_data.trace_str
			if l_trace.is_empty then
				tc_exception_code_cache := once "c0"
				tc_breakpoint_index_cache := once "b0"
				tc_recipient_cache := "REC_" + tc_class_under_test + "__" + tc_feature_under_test
				tc_assertion_tag_cache := "TAG_noname"
			else
				l_trace.prune_all_leading ('%N')
				l_trace.prune_all_trailing ('%N')
				l_lines := l_trace.split ('%N')

				-- Exception code.
				l_exception_code := l_lines[1]
				l_exception_code.prune_all_leading ('-')
				check valid_exception_code: l_exception_code.is_integer end
				tc_exception_code_cache := "c" + l_exception_code

				-- Recipient
				l_recipient_feature := l_lines[2]
				l_recipient_feature.prune_all_leading ('-')
				l_recipient_class := l_lines[3]
				l_recipient_class.prune_all_leading ('-')
				tc_recipient_cache := "REC_" + l_recipient_class + "__" + l_recipient_feature

				-- Assertion tag
				l_assertion_tag := l_lines[4]
				l_assertion_tag.prune_all_leading ('-')
				if l_assertion_tag.is_empty then
					tc_assertion_tag_cache := "TAG_noname"
				else
					tc_assertion_tag_cache := "TAG_" + l_assertion_tag
				end

				-- Breakpoint index
				l_start := l_trace.substring_index ("----", 1)
				l_trace := l_trace.substring (l_start, l_trace.count)
				create l_analyzer
				l_analyzer.analyse (l_trace)
				from
					l_frames := l_analyzer.last_relevant_exception_frames
					l_frames.start
				until
					l_frames.after or else l_done
				loop
					l_frame := l_frames.item_for_iteration
					if l_frame /= Void and then l_frame.breakpoint_slot_index /= 0 then
						check correct_context: l_recipient_class ~ l_frame.context_class_name and then l_recipient_feature ~ l_frame.feature_name end
						tc_breakpoint_index_cache := "b" + l_frame.breakpoint_slot_index.out
						l_done := True
					end
					l_frames.forth
				end
				check tc_breakpoint_index_attached: tc_breakpoint_index /= Void end

			end
		ensure
			test_case_information_attached:
				tc_exception_code /= Void and then
				tc_breakpoint_index_cache /= Void and then
				tc_recipient_cache /= Void and then
				tc_assertion_tag_cache /= Void
		end

	update_uuid
			-- Ask `uuid_generator' to provide a new uuid string.
		do
			tc_uuid_cache := uuid_generator.generate_uuid.out
			tc_uuid_cache.prune_all ('-')

			-- Reset class name cache.
			tc_class_name_cache := Void
		end

	tc_class_name_cache: STRING
			-- Cache for calculated class name.

	tc_uuid_cache: STRING
			-- Cache for the uuid generated last time.

	current_data: detachable AUT_DESERIALIZED_DATA
			-- Current data from which the test case would be extracted.

;note
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
