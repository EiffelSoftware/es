note
	description: "Class to generate Weka relations from test cases"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_WEKA_GENERATION_CMD

inherit
	EPA_UTILITY

	KL_SHARED_STRING_EQUALITY_TESTER

	CI_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_config: like config)
			-- Initialize Current.
		do
			config := a_config
			create logger.make_with_logger_array (<<create{EPA_CONSOLE_LOGGER}>>)
			logger.set_duration_time_mode
			logger.set_level_threshold_to_fine
		ensure
			config_set: config = a_config
		end

feature -- Access

	config: CI_CONFIG
			-- Config of current contract inference session

	logger: EPA_LOG_MANAGER
			-- Logger

feature -- Basic operations

	execute
			-- Execute current command.
		do
			setup_data_structures
			find_test_cases
			generate_weka_relations
		end

feature{NONE} -- Implementation

	class_: CLASS_C
			-- Class whose weka relations are to be generated

	test_cases: DS_HASH_TABLE [DS_HASH_SET [STRING], STRING]
			-- Table of test cases. Key is name of features in `class_', value is the set of test cases
			-- associated with that feature. The features must come from `class_'.

feature{NONE} -- Implementation

	setup_data_structures
			-- Setup data structures.
		do
			class_ := first_class_starts_with_name (config.class_name)
		end

	find_test_cases
			-- Find test cases and store result in `test_cases'.
		local
			l_file_finder: EPA_FILE_SEARCHER
			l_feat_names: SORTED_TWO_WAY_LIST [STRING]
		do
			create test_cases.make (50)

			create l_file_finder.make_with_pattern ("TC__.*\.e")
			l_file_finder.set_is_dir_matched (False)
			l_file_finder.set_is_search_recursive (True)
			l_file_finder.file_found_actions.extend (agent on_test_case_found)
			l_file_finder.search (config.test_case_directory)

				-- Logging.
			logger.put_line_with_time ("Found test cases in class " + class_.name_in_upper)
			logger.push_fine_level

			create l_feat_names.make
			l_feat_names.compare_objects
			test_cases.keys.do_all (agent l_feat_names.extend)
			l_feat_names.sort
			l_feat_names.do_all (
				agent (a_feature_name: STRING)
					do
						logger.put_line (once "%T" + a_feature_name + once ": " + test_cases.item (a_feature_name).count.out + once " test cases.")
					end)

				-- Logging.
			logger.pop_level
		end

feature{NONE} -- Actions

	on_test_case_found (a_path: STRING; a_name: STRING)
			-- Action performed when a test case in `a_file' is found.
		local
			l_tc_info: EPA_TEST_CASE_INFO
			l_feat_name: STRING
			l_tc_set: DS_HASH_SET [STRING]
		do
			create l_tc_info.make_with_string (a_name)
			if l_tc_info.class_under_test.out ~ class_.name_in_upper then
				l_feat_name := l_tc_info.feature_under_test
				test_cases.search (l_feat_name)
				if test_cases.found then
					l_tc_set := test_cases.found_item
				else
					create l_tc_set.make (20)
					l_tc_set.set_equality_tester (string_equality_tester)
					test_cases.force_last (l_tc_set, l_feat_name)
				end
				l_tc_set.force_last (a_path)
			end
		end

	generate_weka_relations
			-- Generate Weka relations from `test_cases'.
		local
			l_cursor: like test_cases.new_cursor
		do
			from
				l_cursor := test_cases.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				generate_weka_relation_for_feature (l_cursor.item, l_cursor.key)
				l_cursor.forth
			end
		end

	generate_weka_relation_for_feature (a_test_cases: DS_HASH_SET [STRING]; a_feature_name: STRING)
			-- Generate a weka relation from `a_test_cases' of feature named `a_feature_name', and
			-- store the relation in `config'.`output_directory'.
		local
			l_cursor: DS_HASH_SET_CURSOR [STRING]
			l_generator: CI_TRANSITION_TO_WEKA_PRINTER
--			l_transition_loader: SEM_TRANSITION_LOADER
			l_relation: WEKA_ARFF_RELATION
			l_file: PLAIN_TEXT_FILE
			l_file_name: FILE_NAME
		do
			create l_generator.make
			l_generator.set_is_union_mode (config.weka_assertion_selection_mode = {CI_CONFIG}.weka_assertion_union_selection_mode)
			l_generator.set_is_absolute_change_included (True)
			l_generator.set_is_relative_change_included (True)
			l_generator.set_is_value_table_generated (True)


				-- Logging.
			logger.put_line_with_time ("Start loading transitions for feature " + a_feature_name + ".")
			logger.push_fine_level

				-- Iterate through all test cases for the feature.			
			from
				l_cursor := a_test_cases.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				logger.put_line (once "%TLoading " + l_cursor.item)
--				create l_transition_loader
--				l_transition_loader.load (l_cursor.item)
--				l_transition_loader.last_transitions.do_all (
--					agent (a_tran: SEM_FEATURE_CALL_TRANSITION; a_gen: CI_TRANSITION_TO_WEKA_PRINTER) do
--						a_gen.extend_transition (create {SEM_FEATURE_CALL_TRANSITION}.make_interface_transition (a_tran))
--					end (?, l_generator))
				l_cursor.forth
			end

				-- Logging.
			logger.pop_level
			logger.put_line_with_time ("Generating Weka relation for feature " + a_feature_name)
			l_relation := l_generator.as_weka_relation

				-- Generate ARFF file.
			create l_file_name.make_from_string (config.output_directory)
			l_file_name.set_file_name (class_.name_in_upper + "__" + a_feature_name + ".arff")
			create l_file.make_create_read_write (l_file_name)
			l_relation.to_medium (l_file)
			l_file.close
		end

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
