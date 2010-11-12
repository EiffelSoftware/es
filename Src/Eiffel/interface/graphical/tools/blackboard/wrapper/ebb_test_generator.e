note
	description: "Summary description for {EBB_TEST_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_TEST_GENERATOR

inherit

	TEST_GENERATOR
		rename
			make as make_generator
		redefine
			remove_task,
			print_test_set
--			step
		end

	EBB_SHARED_ALL

create
	make

feature {NONE} -- Initialization

	make (a_instance: like instance; a_test_suite: like test_suite; a_etest_suite: like etest_suite)
			-- Initialize generator for instance `a_instance'.
		do
			make_generator (a_test_suite, a_etest_suite)
			instance := a_instance
		end

feature -- Access

	instance: EBB_AUTOTEST_INSTANCE
			-- Instance running this test generator.

feature -- Element change

	set_time_out_in_seconds (a_time_out: NATURAL)
			-- Set seconds for `time_out'.
			--
			-- `a_time_out': Timout in seconds for `time_out'.
		require
			not_running: not has_next_step
		do
			create time_out.make (0, 0, 0, 0, 0, a_time_out.as_integer_32)
		ensure
			time_out_set: time_out.second_count = a_time_out
		end

feature -- Basic operations

	print_test_set (a_list: DS_ARRAYED_LIST [AUT_TEST_CASE_RESULT])
			-- Print test case results as test.
			--
			-- `a_list': List of test case results to be printed to a test set.
		do
			current_results := a_list
--			Precursor (a_list)
			current_results := Void
		end

--	step
--			-- <Precursor>
--		local
--			l_retry: BOOLEAN
--		do
--			if l_retry then
--				instance.execution.cancel
--			else
--				Precursor
--			end
--		rescue
--			if not l_retry then
--				l_retry := True
--				retry
--			end
--		end

feature {NONE}

	remove_task (a_task: attached like sub_task; a_cancel: BOOLEAN)
			-- <Precursor>
		local
			l_feature: FEATURE_I
			l_failed: BOOLEAN
			l_path: DIRECTORY_NAME
			l_filename: FILE_NAME
		do

			Precursor (a_task, a_cancel)
				-- Report results when the testing is finished
			if not a_cancel and not has_next_step then
				l_path := system.eiffel_project.project_directory.testing_results_path.twin
				l_path.extend ("auto_test")
				l_path.extend ("log")
				create l_filename.make
				l_filename.set_directory (l_path.out)
				l_filename.set_file_name ("statistics.txt")

				parse_statistics (l_filename)
			end
		end

	parse_statistics (a_filename: STRING)
		local
			l_file: PLAIN_TEXT_FILE
		do
			from
				create l_file.make_open_read (a_filename)
			until
				l_file.end_of_file or not l_file.readable
			loop
				l_file.read_line

				if l_file.last_string ~ "<test_cases>" then
					parse_test_cases (l_file)
					check l_file.last_string = "</test_cases>" end
				elseif l_file.last_string ~ "<fault>" then
					parse_fault (l_file)
				end
			end
		end

	parse_test_cases (a_file: PLAIN_TEXT_FILE)
		local
			l_type: STRING
			l_class_name: STRING
			l_feature_name: STRING
			l_feature: FEATURE_I
			l_number: INTEGER

			l_result: EBB_AUTOTEST_VERIFICATION_RESULT
		do
			l_type := read_single_line_entry (a_file)
			l_class_name := read_single_line_entry (a_file)
			l_feature_name := read_single_line_entry (a_file)
			l_number := read_single_line_entry (a_file).to_integer

			l_feature := feature_with_name (l_class_name, l_feature_name)

			if is_feature_verified (l_feature) then
				if l_type ~ "passing" then
					if l_number >= 50 then
						create l_result.make (l_feature, instance.configuration, 1.0)
					else
						create l_result.make (l_feature, instance.configuration, (l_number / 50.0).truncated_to_real)
					end
					l_result.set_number_of_passing (l_number)
					blackboard.add_verification_result (l_result)
				end
			end

			a_file.read_line
		end


	parse_fault (a_file: PLAIN_TEXT_FILE)
		local
			l_class_name: STRING
			l_feature_name: STRING
			l_code: STRING
			l_breakpoint: STRING
			l_tag: STRING
			l_trace: STRING
			l_feature: FEATURE_I
			l_result: EBB_AUTOTEST_VERIFICATION_RESULT
		do
			l_class_name := read_single_line_entry (a_file)
			l_feature_name := read_single_line_entry (a_file)
			l_code := read_single_line_entry (a_file)
			l_breakpoint := read_single_line_entry (a_file)
			l_tag := read_single_line_entry (a_file)
			l_trace := read_multi_line_entry (a_file)

			l_feature := feature_with_name (l_class_name, l_feature_name)

			create l_result.make (l_feature, instance.configuration, 0)
			l_result.set_exception_trace (l_trace)
			l_result.set_code (l_code.to_integer)
			if l_tag /= Void and then not l_tag.is_empty then
				l_result.set_tag (l_tag)
			end
			blackboard.add_verification_result (l_result)

			a_file.read_line
		end

	read_single_line_entry (a_file: PLAIN_TEXT_FILE): STRING
		do
			a_file.read_line
			a_file.read_line
			Result := a_file.last_string.twin
			a_file.read_line
		end

	read_multi_line_entry (a_file: PLAIN_TEXT_FILE): STRING
		local
			l_tag_name: STRING
		do
			a_file.read_line
			l_tag_name := a_file.last_string.substring (2, a_file.last_string.count - 1)

			from
				a_file.read_line
				create Result.make (100)
			until
				a_file.last_string ~ "</" + l_tag_name + ">"
			loop
				Result.append_string (a_file.last_string)
				Result.append_character ('%N')
				a_file.read_line
			end
		end

	feature_with_name (a_class_name, a_feature_name: STRING): FEATURE_I
			-- Feature with name `a_feature_name' in class `a_class_name'
		require
			a_class_name_not_void: a_class_name /= Void
			a_feature_name_not_void: a_feature_name /= Void
		local
			l_class: CLASS_C
		do
			l_class := system.universe.classes_with_name (a_class_name).first.compiled_class
			check l_class /= Void end
			Result := l_class.feature_named_32 (a_feature_name.to_string_32)
			check Result /= Void end
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
