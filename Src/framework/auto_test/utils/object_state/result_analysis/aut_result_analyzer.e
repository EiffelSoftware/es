note
	description: "Summary description for {AUT_RESULT_ANALYZER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_RESULT_ANALYZER

inherit
	AUT_LOG_PROCESSOR

	AUT_WITNESS_OBSERVER
		redefine
			process_comment_line
		end

	AUT_PREDICATE_UTILITY
		undefine
			system
		end

	EPA_CONTRACT_EXTRACTOR
		undefine
			system
		end

create
	make

feature{NONE} -- Initialization

	make (a_system: like system; a_config: like configuration) is
			-- Initialize.
		require
			a_system_attached: a_system /= Void
			a_config_attached: a_config /= Void
		do
			system := a_system
			configuration := a_config

			create class_under_test.make (10)
			class_under_test.set_equality_tester (create {AGENT_BASED_EQUALITY_TESTER [CLASS_C]}.make (
				agent (a_class, b_class: CLASS_C): BOOLEAN
					do
						Result := a_class.class_id = b_class.class_id
					end
			))
		end

feature -- Access

	system: SYSTEM_I
			-- Current system

feature -- Process

	process is
			-- Process log file specified in `configuration'.
		local
			l_log_publisher: AUT_RESULT_REPOSITORY_PUBLISHER
			l_log_stream: KL_TEXT_INPUT_FILE
			l_output_file: KL_TEXT_OUTPUT_FILE
		do
				-- Setup log file analyzer.
			create l_log_publisher.make (system, configuration)

			create basic_witness_observer.make (system)
			create faulty_witness_observer.make (system)
			create invalid_witness_observer.make (system)
			create number_of_valid_test_case_observer.make (system, 1000 * 60)
			create precondition_evaluation_observer.make (system)
			create precondition_satisfaction_failure_rate_observer.make (system)
			create failed_predicate_proposal_observer.make (system)
			create incorrect_lpsolve_file_observer.make (system)
			create pool_statistics_observer.make (system)
			create precondition_failure_observer.make (system)

			l_log_publisher.register_witness_observer (basic_witness_observer)
			l_log_publisher.register_witness_observer (faulty_witness_observer)
			l_log_publisher.register_witness_observer (invalid_witness_observer)
			l_log_publisher.register_witness_observer (number_of_valid_test_case_observer)
			l_log_publisher.register_witness_observer (precondition_evaluation_observer)
			l_log_publisher.register_witness_observer (precondition_satisfaction_failure_rate_observer)
			l_log_publisher.register_witness_observer (failed_predicate_proposal_observer)
			l_log_publisher.register_witness_observer (incorrect_lpsolve_file_observer)
			l_log_publisher.register_witness_observer (pool_statistics_observer)
			l_log_publisher.register_witness_observer (precondition_failure_observer)
			l_log_publisher.register_witness_observer (Current)

				-- Load log file.
			create l_log_stream.make (configuration.log_file_path)
			l_log_stream.open_read
			l_log_publisher.build (l_log_stream)

				-- Print result.
			create l_output_file.make (configuration.log_processor_output)
			l_output_file.open_write

			print_class_under_test (l_output_file)
			print_last_time_stamp (l_output_file)
			print_fault_result (l_output_file)
			print_sorted_fault_result (l_output_file)
			print_feature_statistics (l_output_file)
			print_test_case_generation_speed (l_output_file)
			print_untested_features (l_output_file)
			print_precondition_evaluation_overhead (l_output_file)
			print_precondition_satisfaction_failure_rate (l_output_file)
			print_failed_precondition_proposal (l_output_file)
			print_incorrect_lpsolve_file (l_output_file)
			print_pool_statistics (l_output_file)
			print_fault_detail (l_output_file)
			print_evolutionary_detail (l_output_file)
			l_output_file.close
		end

feature{NONE} -- Implementation

	basic_witness_observer: AUT_BASIC_WITNESS_OBSERVER

	precondition_failure_observer: AUT_PRECONDITION_FAILURE_OBESERVER

	faulty_witness_observer: AUT_FAULT_WITNESS_OBSERVER

	invalid_witness_observer: AUT_INVALID_WITNESS_OBSERVER

	number_of_valid_test_case_observer: AUT_NUMBER_OF_VALID_TEST_CASE_OBSERVER

	precondition_evaluation_observer: AUT_PRECONDITION_EVALUATION_OVERHEAD_OBSERVER

	precondition_satisfaction_failure_rate_observer: AUT_PREDICATION_EVALUATION_FAILURE_RATE_OBSERVER

	failed_predicate_proposal_observer: AUT_FAILED_PRECONDITION_PROPOSAL_OBSERVER

	incorrect_lpsolve_file_observer: AUT_INCORRECT_LPSOLVE_FILE_OBSERVER

	pool_statistics_observer: AUT_POOL_STATISTICS_OBSERVER

feature -- Result printing

	print_last_time_stamp (a_output_stream: KI_TEXT_OUTPUT_STREAM) is
			-- Print `last_time_stamp' into `a_output_stream'.
		do
			a_output_stream.put_line ("--[Last time stamp]")
			a_output_stream.put_integer (last_time_stamp // 1000)
			a_output_stream.put_character ('%N')
		end

	print_class_under_test (a_output_stream: KI_TEXT_OUTPUT_STREAM) is
			-- Print classes under test into `a_output_stream'.
		do
			a_output_stream.put_line ("--[Class under test]")
			from
				class_under_test.start
			until
				class_under_test.after
			loop
				a_output_stream.put_line (class_under_test.item_for_iteration.name_in_upper)
				class_under_test.forth
			end
			a_output_stream.put_character ('%N')
		end

	print_fault_result (a_output_file: KI_TEXT_OUTPUT_STREAM) is
			-- Print simplified information about found faults to `a_output_file'.
		local
			l_faults: DS_ARRAYED_LIST [AUT_ABS_WITNESS]
			i: INTEGER
		do
			l_faults := faulty_witness_observer.witnesses
			a_output_file.put_string ("--[Faults] " + l_faults.count.out + " %N")
			a_output_file.put_string ("No.%T")
			a_output_file.put_string ("Class%T")
			a_output_file.put_string ("Feature%T")
			a_output_file.put_string ("Code%T")
			a_output_file.put_string ("Tag%T")
			a_output_file.put_string ("Bp_slot%T")
			a_output_file.put_string ("Time%T")
			a_output_file.put_string ("TC_index%N")

			from
				i := 1
				l_faults.start
			until
				l_faults.after
			loop
				a_output_file.put_integer (i)
				a_output_file.put_character ('%T')
				a_output_file.put_string (fault_signature (l_faults.item_for_iteration))
				a_output_file.put_character ('%N')
				i := i + 1
				l_faults.forth
			end
			a_output_file.put_string ("%N")
		end

	print_sorted_fault_result (a_output_file: KI_TEXT_OUTPUT_STREAM) is
			-- Print sorted simplified information about found faults to `a_output_file'.
		local
			l_faults: DS_ARRAYED_LIST [AUT_ABS_WITNESS]
			i: INTEGER
			l_faults_with_name: DS_ARRAYED_LIST [TUPLE [name: STRING; witness: AUT_ABS_WITNESS]]
			l_name: STRING
			l_request: AUT_REQUEST
			l_response: AUT_NORMAL_RESPONSE
			l_sorter: DS_QUICK_SORTER [TUPLE [name: STRING; witness: AUT_ABS_WITNESS]]
		do
			l_faults := faulty_witness_observer.witnesses
			a_output_file.put_string ("--[Sorted faults] " + l_faults.count.out + " %N")
			a_output_file.put_string ("No.%T")
			a_output_file.put_string ("Class%T")
			a_output_file.put_string ("Feature%T")
			a_output_file.put_string ("Code%T")
			a_output_file.put_string ("Tag%T")
			a_output_file.put_string ("Bp_slot%T")
			a_output_file.put_string ("Time%T")
			a_output_file.put_string ("TC_index%N")

			create l_faults_with_name.make (l_faults.count)
			from
				i := 1
				l_faults.start
			until
				l_faults.after
			loop
				l_request := l_faults.item_for_iteration.request
				l_response ?= l_request.response
				l_name := l_response.exception.class_name.to_string_8.as_upper + "." + l_response.exception.recipient_name.to_string_8.as_lower

				l_faults_with_name.force_last ([l_name, l_faults.item_for_iteration])
				l_faults.forth
			end

				-- Sort faults.
			create l_sorter.make (create {AGENT_BASED_EQUALITY_TESTER [TUPLE [name: STRING; witness: AUT_WITNESS]]}.make (
				agent (a, b: TUPLE [name: STRING; witness: AUT_WITNESS]): BOOLEAN
					do
						Result := a.name < b.name
					end
			))

			l_sorter.sort (l_faults_with_name)
			from
				i := 1
				l_faults_with_name.start
			until
				l_faults_with_name.after
			loop
				a_output_file.put_integer (i)
				a_output_file.put_character ('%T')
				a_output_file.put_string (fault_signature (l_faults_with_name.item_for_iteration.witness))
				a_output_file.put_character ('%N')
				i := i + 1
				l_faults_with_name.forth
			end

			a_output_file.put_string ("%N")
		end

	print_feature_statistics (a_output_file: KI_TEXT_OUTPUT_STREAM) is
			-- Print feature statistics.
		local
			l_testable_features: like features_under_test
			l_stat, l_statistics: DS_HASH_TABLE [like statistics_anchored_type, AUT_FEATURE_OF_TYPE]
			l_feature: AUT_FEATURE_OF_TYPE
			l_data: like statistics_anchored_type
		do
			l_testable_features := features_under_test (class_under_test)
			create l_statistics.make (100)
			l_statistics.set_key_equality_tester (create {AUT_FEATURE_OF_TYPE_EQUALITY_TESTER}.make)

			from
				l_testable_features.start
			until
				l_testable_features.after
			loop
				l_statistics.force_last ([0, 0, 0, 0, 0, 0, 0, 0, -1], l_testable_features.item_for_iteration)
				l_testable_features.forth
			end

			l_stat := basic_witness_observer.witnesses
			from
				l_stat.start
			until
				l_stat.after
			loop
				l_statistics.force_last (l_stat.item_for_iteration, l_stat.key_for_iteration)
				l_stat.forth
			end

			a_output_file.put_string ("--[Feature statistics]%N")
			a_output_file.put_string ("Class%T")
			a_output_file.put_string ("Feature%T")
			a_output_file.put_string ("Precondition%T")
			a_output_file.put_string ("#Pass_TC%T")
			a_output_file.put_string ("#Fail_TC%T")
			a_output_file.put_string ("#Bad_TC%T")
			a_output_file.put_string ("#Invalid_TC%T")

			a_output_file.put_string ("Time_pass_TC%T")
			a_output_file.put_string ("Time_fail_TC%T")
			a_output_file.put_string ("Time_bad_TC%T")
			a_output_file.put_string ("Time_invalid_TC%T")

			a_output_file.put_string ("Time_of_first_valid_TC%N")

			from
				l_statistics.start
			until
				l_statistics.after
			loop
				l_feature := l_statistics.key_for_iteration
				l_data := l_statistics.item_for_iteration

				a_output_file.put_string (l_feature.associated_class.name_in_upper)
				a_output_file.put_string ("%T")

				a_output_file.put_string (l_feature.feature_.feature_name.as_lower)
				a_output_file.put_string ("%T")

				if precondition_of_feature (l_feature.feature_, l_feature.feature_.written_class).is_empty then
					a_output_file.put_string ("no_precondition")
				else
					a_output_file.put_string ("has_precondition")
				end
				a_output_file.put_character ('%T')

				a_output_file.put_integer (l_data.pass)
				a_output_file.put_character ('%T')

				a_output_file.put_integer (l_data.fail)
				a_output_file.put_character ('%T')

				a_output_file.put_integer (l_data.bad)
				a_output_file.put_character ('%T')

				a_output_file.put_integer (l_data.invalid)
				a_output_file.put_character ('%T')


				a_output_file.put_integer (l_data.pass_time // 1000)
				a_output_file.put_character ('%T')

				a_output_file.put_integer (l_data.fail_time // 1000)
				a_output_file.put_character ('%T')

				a_output_file.put_integer (l_data.bad_time // 1000)
				a_output_file.put_character ('%T')

				a_output_file.put_integer (l_data.invalid_time // 1000)
				a_output_file.put_character ('%T')

				if l_data.time_of_first_valid_test_case >= 0 then
					a_output_file.put_integer (l_data.time_of_first_valid_test_case // 1000)
				else
					a_output_file.put_integer (-1)
				end

				a_output_file.put_character ('%N')

				l_statistics.forth
			end
			a_output_file.put_string ("%N")
		end

	print_test_case_generation_speed (a_output_stream: KI_TEXT_OUTPUT_STREAM) is
			-- Generate valid test case generation speed to `a_output_stream'.
		local
			l_speed: ARRAY [INTEGER]
			l_upper: INTEGER
			i: INTEGER
		do
			l_speed := number_of_valid_test_case_observer.number_of_test_cases
			a_output_stream.put_line ("--[Valid test case generation speed]")
			a_output_stream.put_line ("Time%T#Valid_TC")
			from
				i := l_speed.lower
				l_upper := l_speed.upper
			until
				i > l_upper
			loop
				a_output_stream.put_integer (i)
				a_output_stream.put_character ('%T')
				a_output_stream.put_integer (l_speed.item (i))
				a_output_stream.put_character ('%N')
				i := i + 1
			end
			a_output_stream.put_string ("%N")
		end

	print_untested_features (a_output_stream: KI_TEXT_OUTPUT_STREAM) is
			-- Print information about untested feature into `a_output_stream'.
		local
			l_untested_features: DS_HASH_TABLE [HASH_TABLE [INTEGER_32, STRING_8], AUT_FEATURE_OF_TYPE]
			l_sorter: DS_QUICK_SORTER [AUT_FEATURE_OF_TYPE]
			l_feats: DS_ARRAYED_LIST [AUT_FEATURE_OF_TYPE]
		do
			l_untested_features := invalid_witness_observer.failed_assertions
			a_output_stream.put_line ("--[Untested features] " + l_untested_features.count.out)
			a_output_stream.put_string ("Class%T")
			a_output_stream.put_string ("Feature%T")
			a_output_stream.put_string ("Arguments%T")
			a_output_stream.put_string ("Failed_assertions(s)")
			a_output_stream.put_string ("%N")

			create l_feats.make (l_untested_features.count)
			from
				l_untested_features.start
			until
				l_untested_features.after
			loop
				l_feats.force_last (l_untested_features.key_for_iteration)
				l_untested_features.forth
			end

				-- Sort features by their CLASS_NAME.feature_name.
			create l_sorter.make (create {AGENT_BASED_EQUALITY_TESTER [AUT_FEATURE_OF_TYPE]}.make (
				agent (a, b: AUT_FEATURE_OF_TYPE): BOOLEAN
					local
						l_class_a: STRING
						l_class_b: STRING
					do
						l_class_a := a.associated_class.name
						l_class_b := b.associated_class.name
						if l_class_a < l_class_b then
							Result := True
						elseif l_class_a > l_class_b then
						else
							Result := a.feature_.feature_name < b.feature_.feature_name
						end
					end
			))
			l_sorter.sort (l_feats)

				-- Print result.
			from
				l_feats.start
			until
				l_feats.after
			loop
				print_non_tested_feature (l_feats.item_for_iteration, l_untested_features.item (l_feats.item_for_iteration), a_output_stream)
				l_feats.forth
			end
			a_output_stream.put_string ("%N")
		end

	print_precondition_evaluation_overhead (a_output_stream: KI_TEXT_OUTPUT_STREAM) is
			-- Print precondition evaluation overhead into `a_output_stream'.
		local
			l_stat: DS_LINKED_LIST [TUPLE [evaluated_times: INTEGER; worst_case_times: INTEGER; start_time: INTEGER; end_time: INTEGER; succeeded: INTEGER; class_name: STRING; feature_name: STRING]]
			l_data: TUPLE [evaluated_times: INTEGER; worst_case_times: INTEGER; start_time: INTEGER; end_time: INTEGER; succeeded: INTEGER; class_name: STRING; feature_name: STRING]
			l_time: INTEGER
			l_ratio: DOUBLE
		do
			a_output_stream.put_line ("--[Precondition evaluation overhead]")
			a_output_stream.put_string ("Class%T")
			a_output_stream.put_string ("Feature%T")
			a_output_stream.put_string ("#Evaluation%T")
			a_output_stream.put_string ("#Wrost_case_evaluation%T")
			a_output_stream.put_string ("Start_time%T")
			a_output_stream.put_string ("End_time%T")
			a_output_stream.put_string ("Duration(ms)%T")
			a_output_stream.put_string ("Succeeded%N")

			l_stat := precondition_evaluation_observer.statistics
			from
				l_stat.start
			until
				l_stat.after
			loop
				l_data := l_stat.item_for_iteration

				a_output_stream.put_string (l_data.class_name)
				a_output_stream.put_string ("%T")

				a_output_stream.put_string (l_data.feature_name)
				a_output_stream.put_string ("%T")

				a_output_stream.put_integer (l_data.evaluated_times)
				a_output_stream.put_string ("%T")

				a_output_stream.put_integer (l_data.worst_case_times)
				a_output_stream.put_string ("%T")

				a_output_stream.put_integer (l_data.start_time // 1000)
				a_output_stream.put_string ("%T")

				a_output_stream.put_integer (l_data.end_time // 1000)
				a_output_stream.put_string ("%T")

				l_time := l_time + (l_data.end_time - l_data.start_time)
				a_output_stream.put_integer ((l_data.end_time - l_data.start_time))
				a_output_stream.put_string ("%T")

				a_output_stream.put_integer (l_data.succeeded)
				a_output_stream.put_string ("%N")

				l_stat.forth
			end
			a_output_stream.put_string ("%N")

			a_output_stream.put_line ("--[Precondition evaluation overhead ratio]")
			l_ratio := l_time.to_double / last_time_stamp.to_double
			a_output_stream.put_line ((l_time // 1000).out + " / " + (last_time_stamp // 1000).out + " = " + l_ratio.out)
			a_output_stream.put_string ("%N")

		end

	print_fault_detail (a_output_stream: KI_TEXT_OUTPUT_STREAM) is
			-- Print found faults in detail into `a_output_stream'.
		local
			l_faults: DS_ARRAYED_LIST [AUT_ABS_WITNESS]
			i: INTEGER
			l_response: AUT_NORMAL_RESPONSE
		do
			l_faults := faulty_witness_observer.witnesses
			a_output_stream.put_string ("--[Fault detail] " + l_faults.count.out + " %N")
			from
				i := 1
				l_faults.start
			until
				l_faults.after
			loop
				a_output_stream.put_integer (i)
				a_output_stream.put_character ('%T')
				a_output_stream.put_string (fault_signature (l_faults.item_for_iteration))
				a_output_stream.put_character ('%N')
				l_response ?= l_faults.item_for_iteration.request.response
				a_output_stream.put_line (l_response.exception.trace)
				a_output_stream.put_character ('%N')
				i := i + 1
				l_faults.forth
			end
			a_output_stream.put_string ("%N")
		end


	print_evolutionary_detail (a_output_stream: KI_TEXT_OUTPUT_STREAM) is
			-- Print detail used by the evolutionary algorithm
		local
			l_faults: DS_ARRAYED_LIST [AUT_ABS_WITNESS]
			i: INTEGER
			n_faults : STRING
			l_untested_features: DS_HASH_TABLE [HASH_TABLE [INTEGER_32, STRING_8], AUT_FEATURE_OF_TYPE]
			n_precondition_passed : REAL
			n_unique_state :STRING
			n_untested_features :STRING
			n_pass_test_cases :INTEGER
			n_fail_test_cases:INTEGER
			n_bad_test_cases:INTEGER
			n_invalid_test_cases :INTEGER
			l_response: AUT_NORMAL_RESPONSE
			l_stat, l_statistics: DS_HASH_TABLE [like statistics_anchored_type, AUT_FEATURE_OF_TYPE]
			l_data: like statistics_anchored_type
		do

			l_faults := faulty_witness_observer.witnesses

			a_output_stream.put_string ("--[Evolutionary Score] %N")
			a_output_stream.put_string ("Number of faults = "+ l_faults.count.out + "%N")

			create l_statistics.make (100)
			l_statistics.set_key_equality_tester (create {AUT_FEATURE_OF_TYPE_EQUALITY_TESTER}.make)

			l_stat := basic_witness_observer.witnesses
			from
				l_stat.start
			until
				l_stat.after
			loop
				l_statistics.force_last (l_stat.item_for_iteration, l_stat.key_for_iteration)
				l_stat.forth
			end

			from
				l_statistics.start
				n_invalid_test_cases := 0
				n_pass_test_cases := 0
			until
				l_statistics.after
			loop
				l_data := l_statistics.item_for_iteration
				n_pass_test_cases := n_pass_test_cases + l_data.pass
				n_fail_test_cases := n_fail_test_cases + l_data.fail
				n_bad_test_cases := n_bad_test_cases + l_data.bad
				n_invalid_test_cases := n_invalid_test_cases + l_data.invalid
				l_statistics.forth
			end

			--Precondition Score
			l_untested_features := invalid_witness_observer.failed_assertions

			from
				l_untested_features.start
			until
				l_untested_features.after
			loop
				if  precondition_failure_observer.precondition_table.has (l_untested_features.key_for_iteration.feature_name) then
					n_precondition_passed := n_precondition_passed + precondition_failure_observer.precondition_table.item (l_untested_features.key_for_iteration.feature_name)
				end
				l_untested_features.forth
			end

			a_output_stream.put_string ("Number of pass test cases = "+ n_pass_test_cases.out + "%N")
			a_output_stream.put_string ("Number of fail test cases = "+ n_fail_test_cases.out + "%N")
			a_output_stream.put_string ("Number of bad test cases = "+ n_bad_test_cases.out + "%N")
			a_output_stream.put_string ("Number of invalid test cases = "+ n_invalid_test_cases.out + "%N")
			a_output_stream.put_string ("Number of untested features = "+ l_untested_features.count.out + "%N")
			a_output_stream.put_string ("Precondition score = "+ n_precondition_passed.out + "%N")
			a_output_stream.put_string ("%N")

	end

	print_precondition_satisfaction_failure_rate (a_output_stream: KI_TEXT_OUTPUT_STREAM) is
			-- Print precondition satisfaction failure rate statistics into `a_output_stream'.
		local
			l_data: TUPLE [time_in_second: INTEGER; full_suggested: INTEGER; full_failed: INTEGER; partial_suggested: INTEGER; partial_failed: INTEGER]
			l_cursor: DS_LINKED_LIST_CURSOR [TUPLE [time_in_second: INTEGER; full_suggested: INTEGER; full_failed: INTEGER; partial_suggested: INTEGER; partial_failed: INTEGER]]
		do
			a_output_stream.put_string ("--[Precondition satisfaction failure rate]%N")
			a_output_stream.put_string ("Time(s)%T")
			a_output_stream.put_string ("Full_suggested%T")
			a_output_stream.put_string ("Full_failed%T")
			a_output_stream.put_string ("Partial_suggested%T")
			a_output_stream.put_string ("Partial_failed%N")
			from
				l_cursor := precondition_satisfaction_failure_rate_observer.statistics.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_data := l_cursor.item
				a_output_stream.put_integer (l_data.time_in_second)
				a_output_stream.put_character ('%T')

				a_output_stream.put_integer (l_data.full_suggested)
				a_output_stream.put_character ('%T')

				a_output_stream.put_integer (l_data.full_failed)
				a_output_stream.put_character ('%T')

				a_output_stream.put_integer (l_data.partial_suggested)
				a_output_stream.put_character ('%T')

				a_output_stream.put_integer (l_data.partial_failed)
				a_output_stream.put_character ('%N')

				l_cursor.forth
			end

			a_output_stream.put_character ('%N')
		end

	print_failed_precondition_proposal (a_output_stream: KI_TEXT_OUTPUT_STREAM) is
			-- Print failed precondition proposal statistics into `a_output_stream'.
		local
			l_data: TUPLE [class_name: STRING; feature_name: STRING; predicate: STRING; time: INTEGER]
			l_cursor: DS_LINKED_LIST_CURSOR [TUPLE [class_name: STRING; feature_name: STRING; predicate: STRING; time: INTEGER]]
		do
			a_output_stream.put_string ("--[Failed precondition proposal]%N")
			a_output_stream.put_string ("Class%T")
			a_output_stream.put_string ("Feature%T")
			a_output_stream.put_string ("Predicate%T")
			a_output_stream.put_string ("time(s)%N")
			from
				l_cursor := failed_predicate_proposal_observer.statistics.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_data := l_cursor.item
				a_output_stream.put_string (l_data.class_name)
				a_output_stream.put_character ('%T')

				a_output_stream.put_string (l_data.feature_name)
				a_output_stream.put_character ('%T')

				a_output_stream.put_string (l_data.predicate)
				a_output_stream.put_character ('%T')

				a_output_stream.put_integer (l_data.time // 1000)
				a_output_stream.put_character ('%N')

				l_cursor.forth
			end

			a_output_stream.put_character ('%N')
		end

	print_incorrect_lpsolve_file (a_output_stream: KI_TEXT_OUTPUT_STREAM) is
			-- Print incorrect lpsolve file statistics into `a_output_stream'.
		local
			l_data: TUPLE [class_name: STRING; feature_name: STRING; time: INTEGER]
			l_cursor: DS_LINKED_LIST_CURSOR [TUPLE [class_name: STRING; feature_name: STRING; time: INTEGER]]
		do
			a_output_stream.put_string ("--[Incorrect lpsolve file]%N")
			a_output_stream.put_string ("Class%T")
			a_output_stream.put_string ("Feature%T")
			a_output_stream.put_string ("time(s)%N")
			from
				l_cursor := incorrect_lpsolve_file_observer.statistics.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_data := l_cursor.item
				a_output_stream.put_string (l_data.class_name)
				a_output_stream.put_character ('%T')

				a_output_stream.put_string (l_data.feature_name)
				a_output_stream.put_character ('%T')

				a_output_stream.put_integer (l_data.time // 1000)
				a_output_stream.put_character ('%N')

				l_cursor.forth
			end

			a_output_stream.put_character ('%N')
		end

	print_pool_statistics (a_output_stream: KI_TEXT_OUTPUT_STREAM) is
			-- Print pool statistics into `a_output_stream'.
		local
			l_data: DS_ARRAYED_LIST [TUPLE [type_name: STRING; time: INTEGER; size: INTEGER]]
			l_predicate_data: DS_ARRAYED_LIST [TUPLE [predicate_name: STRING; time: INTEGER; size: INTEGER]]
		do
				-- Object pool
			a_output_stream.put_string ("--[Object pool by type]%N")
			a_output_stream.put_string ("Type%T")
			a_output_stream.put_string ("Time(s)%T")
			a_output_stream.put_string ("Size%N")
			l_data := pool_statistics_observer.sorted_object_pool_data (pool_statistics_observer.type_time_tester)

			from
				l_data.start
			until
				l_data.after
			loop
				a_output_stream.put_string (l_data.item_for_iteration.type_name)
				a_output_stream.put_character ('%T')
				a_output_stream.put_integer (l_data.item_for_iteration.time // 1000)
				a_output_stream.put_character ('%T')
				a_output_stream.put_integer (l_data.item_for_iteration.size)
				a_output_stream.put_character ('%N')
				l_data.forth
			end
			a_output_stream.put_new_line

			a_output_stream.put_string ("--[Object pool by time]%N")
			a_output_stream.put_string ("Time(s)%T")
			a_output_stream.put_string ("Type%T")
			a_output_stream.put_string ("Size%N")
			l_data := pool_statistics_observer.sorted_object_pool_data (pool_statistics_observer.time_type_tester)

			from
				l_data.start
			until
				l_data.after
			loop
				a_output_stream.put_integer (l_data.item_for_iteration.time // 1000)
				a_output_stream.put_character ('%T')
				a_output_stream.put_string (l_data.item_for_iteration.type_name)
				a_output_stream.put_character ('%T')
				a_output_stream.put_integer (l_data.item_for_iteration.size)
				a_output_stream.put_character ('%N')
				l_data.forth
			end
			a_output_stream.put_new_line

				-- Predicate pool
			a_output_stream.put_string ("--[Predicate pool by predicate]%N")
			a_output_stream.put_string ("Predicate%T")
			a_output_stream.put_string ("Time(s)%T")
			a_output_stream.put_string ("Size%N")
			l_predicate_data := pool_statistics_observer.sorted_predicate_pool_data (pool_statistics_observer.predicate_time_tester)

			from
				l_predicate_data.start
			until
				l_predicate_data.after
			loop
				a_output_stream.put_string (l_predicate_data.item_for_iteration.predicate_name)
				a_output_stream.put_character ('%T')
				a_output_stream.put_integer (l_predicate_data.item_for_iteration.time // 1000)
				a_output_stream.put_character ('%T')
				a_output_stream.put_integer (l_predicate_data.item_for_iteration.size)
				a_output_stream.put_character ('%N')
				l_predicate_data.forth
			end
			a_output_stream.put_new_line

			a_output_stream.put_string ("--[Predicate pool by time]%N")
			a_output_stream.put_string ("Time(s)%T")
			a_output_stream.put_string ("Predicate%T")
			a_output_stream.put_string ("Size%N")
			l_predicate_data := pool_statistics_observer.sorted_predicate_pool_data (pool_statistics_observer.time_predicate_tester)

			from
				l_predicate_data.start
			until
				l_predicate_data.after
			loop
				a_output_stream.put_integer (l_predicate_data.item_for_iteration.time // 1000)
				a_output_stream.put_character ('%T')
				a_output_stream.put_string (l_predicate_data.item_for_iteration.predicate_name)
				a_output_stream.put_character ('%T')
				a_output_stream.put_integer (l_predicate_data.item_for_iteration.size)
				a_output_stream.put_character ('%N')
				l_predicate_data.forth
			end

			a_output_stream.put_character ('%N')
		end


feature -- Process

	class_under_test: DS_HASH_SET [CLASS_C]
			-- Classes under test

	process_comment_line (a_line: STRING) is
			-- Process `a_line'.
		local
			l_parts: LIST [STRING]
			l_header: STRING
			l_count: INTEGER
			l_class_name: STRING
			l_class: CLASS_C
			l_time_stamp_header: STRING
			l_time_stamp_header_count: INTEGER
		do
			l_header := class_under_test_header
			l_count := l_header.count
			l_time_stamp_header := {AUT_RESULT_REPOSITORY_BUILDER}.time_stamp_header
			l_time_stamp_header_count := l_time_stamp_header.count

			if a_line.substring (1, l_count).is_equal (l_header) then
				l_parts := a_line.substring (l_count + 1, a_line.count).split (',')
				from
					l_parts.start
				until
					l_parts.after
				loop
					l_class_name := l_parts.item_for_iteration
					l_class_name.left_adjust
					l_class_name.right_adjust
					if not l_class_name.is_empty then
						l_class := system.universe.classes_with_name (l_class_name).first.compiled_representation
						class_under_test.force_last (l_class)
					end
					l_parts.forth
				end
			elseif a_line.substring (1, l_time_stamp_header_count).is_equal (l_time_stamp_header) then
				l_parts := a_line.substring (l_time_stamp_header_count + 1, a_line.count).split (';')
				check l_parts.count = 3 end
				last_time_stamp := l_parts.i_th (3).to_integer
			end
		end

	process_witness (a_witness: AUT_ABS_WITNESS) is
			-- Handle `a_witness'.
		do
		end

	class_under_test_header: STRING is "-- classes under test: "

	features_under_test (a_classes: DS_HASH_SET [CLASS_C]): DS_LINKED_LIST [AUT_FEATURE_OF_TYPE] is
			-- Features in `a_classes' that are under test
		do
			create Result.make
			from
				a_classes.start
			until
				a_classes.after
			loop
				Result.append_last (testable_features_from_type (a_classes.item_for_iteration.actual_type, system))
				a_classes.forth
			end
		end

	statistics_anchored_type: TUPLE [pass: INTEGER_32; fail: INTEGER_32; invalid: INTEGER_32; bad: INTEGER_32; pass_time: INTEGER_32; fail_time: INTEGER_32; invalid_time: INTEGER_32; bad_time: INTEGER_32; time_of_first_valid_test_case: INTEGER_32]
			-- Anchored type for feature statistics

	last_time_stamp: INTEGER
			-- Last time stamp im millisecond appeared in the log file

	print_non_tested_feature (a_feature: AUT_FEATURE_OF_TYPE; a_precondition_violation: HASH_TABLE [INTEGER, STRING]; a_output_stream: KI_TEXT_OUTPUT_STREAM) is
			-- Print non-tested feature `a_feature'.
		do
			a_output_stream.put_string (a_feature.type.associated_class.name_in_upper)
			a_output_stream.put_character ('%T')
			a_output_stream.put_string (a_feature.feature_.feature_name.as_lower)

			a_output_stream.put_character ('%T')
			a_output_stream.put_string (a_feature.feature_.argument_count.out)

			from
				a_precondition_violation.start
			until
				a_precondition_violation.after
			loop
				if a_precondition_violation.key_for_iteration /= Void and then a_precondition_violation.item_for_iteration /= Void then
					a_output_stream.put_character ('%T')
					a_output_stream.put_string (a_precondition_violation.key_for_iteration)
					a_output_stream.put_character ('%T')
					a_output_stream.put_integer (a_precondition_violation.item_for_iteration)
				end
				a_precondition_violation.forth
			end
			a_output_stream.put_character ('%N')
		end

	fault_signature (a_witness: AUT_ABS_WITNESS): STRING is
			-- Signature of the fault revealed by `a_witness'
		require
			a_witness_is_failing: a_witness.is_fail
		local
			l_request: AUT_REQUEST
			l_response: AUT_NORMAL_RESPONSE
		do
			l_request := a_witness.request
			l_response ?= l_request.response

			create Result.make (128)
			Result.append (l_response.exception.class_name)
			Result.append ("%T")

			Result.append (l_response.exception.recipient_name.as_string_8)
			Result.append ("%T")

			Result.append (l_response.exception.code.out)
			Result.append ("%T")

			Result.append (l_response.exception.tag_name)
			Result.append ("%T")

			Result.append (l_response.exception.break_point_slot.out)
			Result.append ("%T")

			Result.append_integer (l_request.start_time // 1000)
			Result.append ("%T")

			Result.append (l_request.test_case_index.out)
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
