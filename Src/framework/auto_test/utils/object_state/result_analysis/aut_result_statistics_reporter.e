note
	description: "Summary description for {AUT_RESULT_STATISTICS_REPORTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_RESULT_STATISTICS_REPORTER

inherit
	AUT_RESULT_ANALYSIS_UTILITY

	AUT_CONTRACT_EXTRACTOR

create
	make

feature{NONE} -- Initializatoin

	make (a_system: like system; a_error_handler: like error_handler) is
			-- Initialize `system' with `a_system' and
			-- `error_handler' with `a_error_handler'.
		do
			system := a_system
			error_handler := a_error_handler
		ensure
			system_set: system = a_system
			error_handler_set: error_handler = a_error_handler
		end

feature -- Access

	statistics: DS_HASH_TABLE [TUPLE [pass: INTEGER; fail: INTEGER; invalid: INTEGER; bad: INTEGER; pass_time: INTEGER; fail_time: INTEGER; invalid_time: INTEGER; bad_time: INTEGER], AUT_FEATURE_OF_TYPE]
			-- Statistics for features under test
			-- `pass' is the number of passing test cases for that feature.
			-- `fail' is the number of failing test cases for that feature.
			-- `invalid' is the number of invalid test cases for that feature.
			-- `bad' is the number of bad test cases for that feature.
			-- `pass_time' is the accumulated time in millisecond of all passing test cases for the feature.
			-- `fail_time' is the accumulated time in millisecond of all failing test cases for the feature.
			-- `invalid_time' is the accumulated time in millisecond of all invalid test cases for the feature.
			-- `bad_time' is the accumulated time in millisecond of all bad test cases for the feature.

	non_tested_features: DS_HASH_TABLE [HASH_TABLE [INTEGER, STRING], AUT_FEATURE_OF_TYPE]
			-- Table of features that are not tested

	tested_features: DS_HASH_SET [AUT_FEATURE_OF_TYPE] is
			-- Set of tested features
		local
			l_stats: like statistics
			l_feat_stat: like type_anchor
		do
			create Result.make (100)
			Result.set_equality_tester (create {AUT_FEATURE_OF_TYPE_EQUALITY_TESTER}.make)
			l_stats := statistics

			from
				l_stats.start
			until
				l_stats.after
			loop
				l_feat_stat := l_stats.item_for_iteration
				if l_feat_stat.pass > 0 or l_feat_stat.fail > 0 or l_feat_stat.bad > 0 then
					Result.force_last (l_stats.key_for_iteration)
				end
				l_stats.forth
			end
		end

	system: SYSTEM_I
			-- System under which tests are performed

	error_handler: AUT_ERROR_HANDLER
			-- Error handler

feature -- Basic operations

	build (a_log_files: LIST [STRING]) is
			-- Analyze logs from `a_log_files' and put
			-- results in `statistics' and `non_tested_features'.
		local
			l_statistics: like statistics
			l_non_test_features: like non_tested_features
			l_tuple: TUPLE [pass: INTEGER; fail: INTEGER; invalid: INTEGER; bad: INTEGER]
			l_feature: AUT_FEATURE_OF_TYPE
		do
			create statistics.make (100)
			statistics.set_key_equality_tester (create {AUT_FEATURE_OF_TYPE_EQUALITY_TESTER}.make)

			create non_tested_features.make (100)
			non_tested_features.set_key_equality_tester (create {AUT_FEATURE_OF_TYPE_EQUALITY_TESTER}.make)

--			a_log_files.do_all (agent load_log)
			from
				a_log_files.start
			until
				a_log_files.after
			loop
				io.put_string (a_log_files.index.out + "/" + a_log_files.count.out + "%N")
				load_log (a_log_files.item_for_iteration)
				a_log_files.forth
			end

				-- Synchronize `statistics' and `non_tested_features'.
				-- Remove items from `non_tested_features' if that feature
				-- is actually tested.
			l_statistics := statistics
			l_non_test_features := non_tested_features
			from
				l_statistics.start
			until
				l_statistics.after
			loop
				l_feature := l_statistics.key_for_iteration
				l_tuple := l_statistics.item_for_iteration
				if l_tuple.pass + l_tuple.fail + l_tuple.bad > 0 then
					l_non_test_features.remove (l_feature)
				end
				l_statistics.forth
			end
		end

	put_statistics (a_output_stream: KI_TEXT_OUTPUT_STREAM) is
			-- Store `statistics' into `a_output_stream'.
		require
			a_output_stream.is_open_write
		local
			l_stat: like statistics
			l_feature: AUT_FEATURE_OF_TYPE
			l_tuple: like type_anchor
		do
			l_stat := statistics
			from
				l_stat.start
			until
				l_stat.after
			loop
				l_feature := l_stat.key_for_iteration
				l_tuple := l_stat.item_for_iteration
				a_output_stream.put_string (l_feature.type.associated_class.name_in_upper)
				a_output_stream.put_character ('.')
				a_output_stream.put_string (l_feature.feature_.feature_name.as_lower)
				a_output_stream.put_character ('%T')

				if precondition_of_feature (l_feature.feature_, l_feature.feature_.written_class).is_empty then
					a_output_stream.put_string ("no_precondition")
				else
					a_output_stream.put_string ("has_precondition")
				end
				a_output_stream.put_character ('%T')

				a_output_stream.put_integer (l_tuple.pass)
				a_output_stream.put_character ('%T')

				a_output_stream.put_integer (l_tuple.fail)
				a_output_stream.put_character ('%T')

				a_output_stream.put_integer (l_tuple.invalid)
				a_output_stream.put_character ('%T')

				a_output_stream.put_integer (l_tuple.bad)
				a_output_stream.put_character ('%T')


				a_output_stream.put_integer (l_tuple.pass_time // 1000)
				a_output_stream.put_character ('%T')

				a_output_stream.put_integer (l_tuple.fail_time // 1000)
				a_output_stream.put_character ('%T')

				a_output_stream.put_integer (l_tuple.invalid_time // 1000)
				a_output_stream.put_character ('%T')

				a_output_stream.put_integer (l_tuple.bad_time // 1000)
				a_output_stream.put_character ('%N')

				l_stat.forth
			end
		end

	put_non_tested_features (a_output_stream: KI_TEXT_OUTPUT_STREAM) is
			-- Store `non_tested_features' into `a_output_stream'.
		require
			a_output_stream.is_open_write
		do
			put_non_tested_features_with_agent (a_output_stream, agent put_feature)
		end

	put_non_tested_features_in_detail (a_output_stream: KI_TEXT_OUTPUT_STREAM) is
			-- Store `non_tested_features' into `a_output_stream' in detail.
		require
			a_output_stream.is_open_write
		do
			put_non_tested_features_with_agent (a_output_stream, agent put_feature_in_detail)
		end

	put_non_tested_features_with_agent (a_output_stream: KI_TEXT_OUTPUT_STREAM; a_agent: PROCEDURE [ANY, TUPLE [a_feature: AUT_FEATURE_OF_TYPE; a_precondition_violation: HASH_TABLE [INTEGER, STRING]; a_output_stream: KI_TEXT_OUTPUT_STREAM]]) is
			--
		require
			a_output_stream.is_open_write
		local
			l_feats: like non_tested_features
			l_feature: AUT_FEATURE_OF_TYPE
			l_tbl: HASH_TABLE [INTEGER, STRING]
		do
			l_feats := non_tested_features
			from
				l_feats.start
			until
				l_feats.after
			loop
				l_feature := l_feats.key_for_iteration
				a_agent.call ([l_feature, l_feats.item_for_iteration, a_output_stream])
				l_feats.forth
			end
		end


	put_feature (a_feature: AUT_FEATURE_OF_TYPE; a_precondition_violation: HASH_TABLE [INTEGER, STRING]; a_output_stream: KI_TEXT_OUTPUT_STREAM) is
			--			
		do
			a_output_stream.put_string (a_feature.type.associated_class.name_in_upper)
			a_output_stream.put_character ('.')
			a_output_stream.put_string (a_feature.feature_.feature_name.as_lower)

			a_output_stream.put_character ('%T')
			a_output_stream.put_string (a_feature.feature_.argument_count.out)

			from
				a_precondition_violation.start
			until
				a_precondition_violation.after
			loop
				a_output_stream.put_character ('%T')
				a_output_stream.put_string (a_precondition_violation.key_for_iteration)
				a_output_stream.put_character ('%T')
				a_output_stream.put_integer (a_precondition_violation.item_for_iteration)
				a_precondition_violation.forth
			end
			a_output_stream.put_character ('%N')
		end

	put_feature_in_detail (a_feature: AUT_FEATURE_OF_TYPE; a_precondition_violation: HASH_TABLE [INTEGER, STRING]; a_output_stream: KI_TEXT_OUTPUT_STREAM) is
			--
		local
			l_asserts: LIST [AUT_ASSERTION]
		do
			put_feature (a_feature, a_precondition_violation, a_output_stream)
			l_asserts := precondition_of_feature (a_feature.feature_, a_feature.type.associated_class)
			from
				l_asserts.start
			until
				l_asserts.after
			loop
				a_output_stream.put_character ('%T')
				a_output_stream.put_string (l_asserts.item_for_iteration.text)
				a_output_stream.put_character ('%N')
				l_asserts.forth
			end
			a_output_stream.put_string ("%N")
		end

feature{NONE} -- Implementation

	veto_witness_function (a_witness: AUT_WITNESS; a_class_name: STRING): BOOLEAN is
			-- Function to veto dispatch of `a_witness'
		local
			l_feature: AUT_FEATURE_OF_TYPE
		do
			l_feature := feature_under_test (a_witness)
			Result := l_feature.type.associated_class.name.as_upper.is_equal (a_class_name.as_upper.to_string_8)
		end

	load_log (a_log_file: STRING) is
			-- Load log from `a_log_file'.
		local
			l_builder: AUT_RESULT_REPOSITORY_PUBLISHER
			l_basic_observer: AUT_BASIC_WITNESS_OBSERVER
			l_invalid_observer: AUT_INVALID_WITNESS_OBSERVER
			l_log_stream: KL_TEXT_INPUT_FILE
			l_class_under_test: STRING
		do
			create l_builder.make (system, error_handler)
			create l_basic_observer.make (system)
			create l_invalid_observer.make (system)

			l_builder.witness_observers.extend (l_basic_observer)
			l_builder.witness_observers.extend (l_invalid_observer)

				-- Create input stream for log file.
			create l_log_stream.make (a_log_file)
			l_log_stream.open_read

				-- Find out class under test from log file name.
				-- This can be removed after the class under test can be analyzed from
				-- log file itself.
			l_class_under_test := a_log_file.twin

			l_class_under_test.remove_head (a_log_file.substring_index ("proxy_log_", 1) + 9)
			l_class_under_test.remove_tail (6)

				-- Load log file.
			l_builder.set_witness_veto_function (agent veto_witness_function (?, l_class_under_test))
			l_builder.build (l_log_stream)

				-- Merge result from current log into main results.
			merge_statistics (l_basic_observer.witnesses)
			merge_non_tested_features (l_invalid_observer.failed_assertions)
		end

	merge_non_tested_features (a_statistics: like non_tested_features) is
			-- Merge `a_statistics' into `non_tested_features'.
		local
			l_feat: HASH_TABLE [INTEGER, STRING]
			l_feat_main: HASH_TABLE [INTEGER, STRING]
			l_feature: AUT_FEATURE_OF_TYPE
			l_statistics: like non_tested_features
			l_tag: STRING
		do
			l_statistics := non_tested_features
			from
				a_statistics.start
			until
				a_statistics.after
			loop
				l_feature := a_statistics.key_for_iteration
				l_feat := a_statistics.item_for_iteration
				if l_statistics.has (l_feature) then
					l_feat_main := l_statistics.item (l_feature)
					from
						l_feat.start
					until
						l_feat.after
					loop
						l_tag := l_feat.key_for_iteration
						if l_feat_main.has (l_tag) then
							l_feat_main.force (l_feat_main.item (l_tag) + l_feat.item (l_tag), l_tag)
						else
							l_feat_main.force (l_feat.item (l_tag), l_tag)
						end
						l_feat.forth
					end
				else
					l_feat_main := l_feat.twin
				end
				l_statistics.force_last (l_feat_main, l_feature)
				a_statistics.forth
			end
		end

	merge_statistics (a_statistics: like statistics) is
			-- Merge `a_statistics' into `statistics'.
		local
			l_tuple: like type_anchor
			l_tuple_main: like type_anchor
			l_feature: AUT_FEATURE_OF_TYPE
			l_statistics_main: like statistics
		do
			l_statistics_main := statistics
			from
				a_statistics.start
			until
				a_statistics.after
			loop
				l_feature := a_statistics.key_for_iteration
				l_tuple := a_statistics.item_for_iteration
				if l_statistics_main.has (l_feature) then
					l_tuple_main := l_statistics_main.item (l_feature)
				else
					l_tuple_main := [0, 0, 0, 0, 0, 0, 0, 0]
				end
				l_statistics_main.force_last (
					[l_tuple_main.pass +         l_tuple.pass,
					 l_tuple_main.fail +         l_tuple.fail,
					 l_tuple_main.invalid +      l_tuple.invalid,
					 l_tuple_main.bad +          l_tuple.bad,
					 l_tuple_main.pass_time +    l_tuple.pass_time,
					 l_tuple_main.fail_time +    l_tuple.fail_time,
					 l_tuple_main.invalid_time + l_tuple.invalid_time,
					 l_tuple_main.bad_time +     l_tuple.bad_time
					], l_feature)

				a_statistics.forth
			end
		end

	type_anchor: TUPLE [pass: INTEGER; fail: INTEGER; invalid: INTEGER; bad: INTEGER; pass_time: INTEGER; fail_time: INTEGER; invalid_time: INTEGER; bad_time: INTEGER];
			-- Type anchor

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
