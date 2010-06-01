note
	description: "Test creator representing AutoTest"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_GENERATOR

inherit
	ETEST_CREATION
		redefine
			make
		end

	ROTA_SERIAL_TASK_I
		redefine
			step,
			remove_task
		end

	DISPOSABLE_SAFE

	EIFFEL_ENV
		export
			{NONE} all
		end

	ERL_G_TYPE_ROUTINES
		export
			{NONE} all
		end

	KL_SHARED_FILE_SYSTEM
		export
			{NONE} all
		end

	AUT_SHARED_RANDOM
		export
			{NONE} all
		end

	AUT_SHARED_PREDICATE_CONTEXT
		undefine
			system
		end

create
	make

feature {NONE} -- Initialization

	make (a_test_suite: like test_suite; a_etest_suite: like etest_suite)
			-- <Precursor>
		do
			Precursor (a_test_suite, a_etest_suite)
			create output_stream.make_empty


			create source_writer

				-- Initialize options
			create class_names.make_default
			class_names.set_equality_tester (create {KL_STRING_EQUALITY_TESTER_A [STRING]})
			proxy_time_out := 2
			set_time_out (3)
			output_dirname := file_system.pathname (etest_suite.project_access.project.project_directory.testing_results_path, "auto_test")
			set_seed ((create {TIME}.make_now).milli_second.as_natural_32)
			create error_handler.make (system)
			error_handler.set_configuration (Current)
		end

feature -- Access

	progress: REAL_32
			-- <Precursor>
		do
			if attached {ETEST_MELT_TASK} sub_task then
				Result := {REAL_32} 0.1
			elseif attached {ETEST_GENERATION_TESTING} sub_task as l_task then
				Result := {REAL_32} 0.1 + l_task.progress * ({REAL_32} 0.85)
			else
				Result := {REAL_32} 0.95
			end
		end

feature -- Options: basic

	output_dirname: STRING
			-- Name of output directory

	class_names: DS_HASH_SET [STRING]
			-- List of class names to be tested

	time_out: DT_DATE_TIME_DURATION
			-- Maximal time to test;
			-- A timeout value of `0' means no time out.

	test_count: NATURAL
			-- Maximum number of tests to be executed
			--
			-- Note: a value of `0' means no upper limit

	is_minimization_enabled: BOOLEAN
			-- Should bug reproducing examples be minimized?
		do
			Result := is_slicing_enabled or is_ddmin_enabled
		end

	is_text_statistics_format_enabled: BOOLEAN
			-- Should statistics be output as plain text?

	is_html_statistics_format_enabled: BOOLEAN
			-- Should statistics be output static HTML?

	is_slicing_enabled: BOOLEAN
			-- Should test cases be minimized via slicing?


	is_ddmin_enabled: BOOLEAN assign set_is_ddmin_enabled
			-- Should test cases be minimized via ddmin?

	proxy_time_out: NATURAL
			-- Proxy time out in second

	is_debugging: BOOLEAN
			-- True if debugging output should be written to log.

	integer_lower_bound: INTEGER is
			-- Lower bound for integer arguments that are to be solved by a linear constraint solver.
			-- Default is -512.
		do
			Result := integer_lower_bound_cache
		ensure then
			good_result: Result = integer_lower_bound_cache
		end

	integer_upper_bound: INTEGER is
			-- Upper bound for integer arguments that are to be solved by a linear constraint solver.
			-- Default is 512.
		do
			Result := integer_upper_bound_cache
		ensure then
			good_result: Result = integer_upper_bound_cache
		end

	is_console_output_enabled: BOOLEAN
			-- Is console output enabled?
			-- Default: True
		do
			Result := is_console_output_enabled_cache
		ensure then
			good_result: Result = is_console_output_enabled_cache
		end

	excluded_features: LINKED_LIST [TUPLE [class_name: STRING; feature_name: STRING]]
			-- List of features excluded from being tested
		do
			if excluded_features_cache = Void then
				create excluded_features_cache.make
			end
			Result := excluded_features_cache
		end

	types_under_test: DS_LIST [CL_TYPE_A]
			-- Types under test

feature -- Options: logging

	proxy_log_options: HASH_TABLE[BOOLEAN, STRING]
			-- Proxy log options.
			-- Key is the type name, value indicates if messages of that type is logged.
			-- Missing types are treated as not to be logged.
		do
			Result := proxy_log_options_cache
		ensure then
			good_result: Result = proxy_log_options_cache
		end

	is_interpreter_log_enabled: BOOLEAN
			-- Should messages from the interpreter be logged?
			-- Default: False
		do
			Result := is_interpreter_log_enabled_cache
		ensure then
			good_result: Result = is_interpreter_log_enabled_cache
		end

	is_pool_statistics_logged: BOOLEAN
			-- Should statistics of object pool and predicate be logged?
			-- Default: False
		do
			Result := proxy_log_options.has ("statistics")
		end

	is_precondition_satisfaction_logged: BOOLEAN
			-- Should messaged related to precondition satisfaction be logged?
			-- Default: False
		do
			Result := proxy_log_options_cache.has ("precondition")
		end

feature -- Options: log loading

	log_file_path: detachable STRING
			-- Path for the log file to load
		do
			Result := log_file_path_cache
		ensure then
			result_set: Result = log_file_path_cache
		end

	log_processor: detachable STRING
			-- Name of the specified log processor
		do
			Result := log_processor_cache
		ensure then
			good_result: Result = log_processor_cache
		end

	log_processor_output: detachable STRING
			-- Name of the output file from log processor
		do
			Result := log_processor_output_cache
		ensure then
			good_result: Result = log_processor_output_cache
		end

feature -- Options: precondition satisfaction

	max_precondition_search_tries: INTEGER
			-- Max times to search for an object combination satisfying precondition of a feature.
			-- 0 means search until a satisfying object combination is found.
		do
			Result := max_precondition_search_tries_cache
		ensure then
			good_result: max_precondition_search_tries = max_precondition_search_tries_cache
		end

	max_precondition_search_time: INTEGER
			-- <Precursor>
		do
			Result := max_precondition_search_time_cache
		ensure then
			good_result: max_precondition_search_time = max_precondition_search_time_cache
		end

	max_candidate_count: INTEGER
			-- Max number of returned candidates that satisfy the precondition
			-- of the feature to call.
			-- 0 means no limit.
		do
			Result := max_candidate_count_cache
		ensure then
			good_result: Result = max_candidate_count_cache
		end

	object_selection_for_precondition_satisfaction_rate: INTEGER
			-- Possibility under which smart object selection for precondition satisfaction
			-- is used.
			-- Only have effect when precondition evaluation is enabled.
		do
			Result := object_selection_for_precondition_satisfaction_rate_cache
		ensure then
			good_result: Result = object_selection_for_precondition_satisfaction_rate_cache
		end

	smt_enforce_old_value_rate: INTEGER is
			-- Possibility [0-100] to enforce SMT solver to choose an already used value.
			-- Default is 25
		do
			Result := smt_enforce_old_value_rate_cache
		ensure then
			good_result: Result = smt_enforce_old_value_rate_cache
		end

	smt_use_predefined_value_rate: INTEGER is
			-- Possibility [0-100] to for the SMT solver to choose a predefined value for integers.
			-- Default is 25
		do
			Result := smt_use_predefined_value_rate_cache
		ensure then
			good_result: Result = smt_use_predefined_value_rate_cache
		end

	is_random_cursor_used: BOOLEAN is
			-- When searching in predicate pool, should random cursor be used?
			-- Default: False
		do
			Result := is_random_cursor_used_cache
		ensure then
			good_result: Result = is_random_cursor_used_cache
		end

	is_precondition_checking_enabled: BOOLEAN
			-- Is precondition checking before feature call enabled?
		do
			Result := precondition_evaluation_cache
		ensure then
			good_result: Result = precondition_evaluation_cache
		end

	is_linear_constraint_solving_enabled: BOOLEAN
			-- Is linear constraint solving for integers enabled?
		do
			Result := linear_solving_cache
		ensure then
			good_result: Result = linear_solving_cache
		end

	is_smt_linear_constraint_solver_enabled: BOOLEAN
			-- Is SMT-LIB based linear constraint solver enabled?
			-- Default: True
		do
			Result := is_smt_linear_constraint_solver_enabled_cache
		ensure then
			good_result: Result = is_smt_linear_constraint_solver_enabled_cache
		end

	is_lpsolve_linear_constraint_solver_enabled: BOOLEAN
			-- Is lp_solve based linear constraint solver enabled?
			-- Default: False
		do
			Result := is_lpsolve_linear_constraint_solver_enabled_cache
		ensure then
			good_result: Result = is_lpsolve_linear_constraint_solver_enabled_cache
		end

feature -- Options: object State exploration

	is_object_state_exploration_enabled: BOOLEAN is
			-- Is object state exploration enabled?
		do
			Result := object_state_exploration_cache
		ensure then
			good_result: Result = object_state_exploration_cache
		end

	is_object_state_retrieval_enabled: BOOLEAN
			-- Should object state be retrieved?
		do
			Result :=
				is_all_query_state_enabled or else
				is_only_argumentless_query_state_enabled
		end

	object_state_config: detachable AUT_OBJECT_STATE_CONFIG
			-- Configuration related to object states retrieval

	is_post_state_serialized: BOOLEAN
			-- Should post-state information be serialized as well?
			-- Normally, only pre-state information is necessary, because
			-- we can re-execute the test case to observe the post-state.
		do
			Result := is_post_state_serialized_cache
		ensure then
			good_result: Result = is_post_state_serialized_cache
		end

	is_all_query_state_enabled: BOOLEAN
			-- Is state retrieval enabled for all queries?
		do
			Result := attached {AUT_OBJECT_STATE_CONFIG} object_state_config as l_config and then l_config.is_all
		end

	is_only_argumentless_query_state_enabled: BOOLEAN

		do
			Result := attached {AUT_OBJECT_STATE_CONFIG} object_state_config as l_config and then l_config.is_only_argumentless
		end

feature -- Options: test case serialization

	is_test_case_serialization_enabled: BOOLEAN
			-- Is test case serialization enabled?
		do
			Result :=
				is_passing_test_case_serialization_enabled or
				is_failing_test_case_serialization_enabled
		end

	is_passing_test_case_serialization_enabled: BOOLEAN
			-- Is passing test case serialization enabled?
		do
			Result := is_passing_test_case_serialization_enabled_cache
		end

	is_failing_test_case_serialization_enabled: BOOLEAN
			-- Is failing test case serialization enabled?
		do
			Result := is_failing_test_case_serialization_enabled_cache
		end

	is_duplicated_test_case_serialized: BOOLEAN
			-- Should duplicated test case be serialized?
			-- Two test cases are considered duplicated if their operands have
			-- the same abstract states.
		do
			Result := is_duplicated_test_case_serialized_cache
		end

feature -- Options: test case deserialization

	is_test_case_deserialization_enabled: BOOLEAN
			-- Is test case deserialization enabled?
		do
			Result := is_passing_test_case_deserialization_enabled or is_failing_test_case_deserialization_enabled
		end

	is_passing_test_case_deserialization_enabled: BOOLEAN is
			-- <Precursor>
		do
			Result := is_passing_test_case_deserialization_enabled_cache
		end

	is_failing_test_case_deserialization_enabled: BOOLEAN is
			-- <Precursor>
		do
			Result := is_failing_test_case_deserialization_enabled_cache
		end

	is_recursive: BOOLEAN
			-- Is searching for serialization files recursive in sub-directories?
		do
			Result := is_recursive_cache
		ensure then
			good_result: Result = is_recursive_cache
		end

	data_input: detachable STRING
			-- Directory or file name of the serialization files.
		do
			Result := data_input_cache
		ensure then
			good_result: Result = data_input_cache
		end

	data_output: detachable STRING
			-- Directory to store deserialized test cases.
		do
			Result := data_output_cache
		ensure then
			good_result: Result = data_output_cache
		end

feature -- Access: session

	system: SYSTEM_I
			-- Eiffel system containing compiled project information
		do
			Result := etest_suite.project_access.project.system.system
		end

	error_handler: AUT_ERROR_HANDLER
			-- AutoTest error handler

feature {NONE} -- Access

	current_results: detachable DS_ARRAYED_LIST [AUT_TEST_CASE_RESULT]
			-- Results printed to new test class

	source_writer: TEST_GENERATED_SOURCE_WRITER
			-- Source writer used for creating test classes

	output_stream: KL_STRING_OUTPUT_STREAM
			-- String stream for storing output

	output_file: detachable KL_TEXT_OUTPUT_FILE
			-- Output file to which output should be written to

feature {NONE} -- Access: tasks

	sub_task: detachable ROTA_TASK_I
			-- <Precursor>

feature -- Status report

	sleep_time: NATURAL
			-- <Precursor>
		do
			if attached {ETEST_MELT_TASK} sub_task as l_task then
				Result := l_task.sleep_time
			else
				Result := 0
			end
		end

feature {NONE} -- Status report

	is_creating_new_class: BOOLEAN
			-- <Precursor>
		do
			Result := current_results /= Void and then not current_results.is_empty
		ensure then
			definition: Result = (current_results /= Void and then not current_Results.is_empty)
		end

	creates_multiple_classes: BOOLEAN = True
			-- <Precursor>

feature -- Status setting

	set_output_dirname (a_dirname: like output_dirname)
			-- Set `output_dirname' to given name.
			--
			-- `a_dirname': New directory name for `output_dirname'.
		require
			a_dirname_attached: a_dirname /= Void
			not_running: not has_next_step
		do
			create output_dirname.make_from_string (a_dirname)
		ensure
			output_dirname_set: output_dirname.same_string (a_dirname)
		end

	add_class_name (a_class_name: STRING_8)
			-- Add given name to `class_names'.
			--
			-- `a_class_name': New class name to test.
		require
			a_class_name_attached: a_class_name /= Void
			not_running: not has_next_step
		do
			class_names.force_last (a_class_name.as_string_8)
		ensure
			added: class_names.there_exists (agent {STRING_8}.same_string (a_class_name))
		end

	set_time_out (a_time_out: NATURAL)
			-- Set minutes for `time_out'.
			--
			-- `a_time_out': Timout in minutes for `time_out'.
		require
			not_running: not has_next_step
		do
			create time_out.make (0, 0, 0, 0, a_time_out.as_integer_32, 0)
		ensure
			time_out_set: time_out.minute = a_time_out
		end

	set_test_count (a_test_count: like test_count)
			-- Set `test_count' to given value.
			--
			-- `a_test_count': Number of test routines to be called.
		require
			not_running: not has_next_step
		do
			test_count := a_test_count
		ensure
			test_count_set: test_count = a_test_count
		end

	enable_slicing
			-- Enable slicing.
		require
			no_minimization: not is_minimization_enabled
			not_running: not has_next_step
		do
			is_slicing_enabled := True
		end

	set_is_slicing_enabled (b: BOOLEAN)
			-- Set `is_slicing_enabled' with `b'.
		do
			is_slicing_enabled := b
		ensure
			is_slicing_enabled_set: is_slicing_enabled = b
		end

	enable_ddmin
			-- Enable ddmin.
		require
			no_minimization: not is_minimization_enabled
			not_running: not has_next_step
		do
			is_ddmin_enabled := True
		end

	set_is_ddmin_enabled (b: like is_ddmin_enabled)
			-- Set `is_ddmin_enabled' to `a_is_ddmin_enabled'.
		do
			is_ddmin_enabled := b
		ensure
			is_ddmin_enabled_set: is_ddmin_enabled = b
		end

	set_text_statistics (a_text_statistics: like is_text_statistics_format_enabled)
			-- Enable/disable text statistics.
		require
			not_running: not has_next_step
		do
			is_text_statistics_format_enabled := a_text_statistics
		ensure
			set: is_text_statistics_format_enabled = a_text_statistics
		end

	set_html_statistics (a_html_statistics: like is_html_statistics_format_enabled)
			-- Enable/disable html statistics.
		require
			not_running: not has_next_step
		do
			is_html_statistics_format_enabled := a_html_statistics
		ensure
			set: is_html_statistics_format_enabled = a_html_statistics
		end

	set_proxy_timeout (a_timeout: like proxy_time_out)
			-- Set `proxy_time_out' to given value.
		require
			not_running: not has_next_step
			a_timeout_positive: a_timeout > 0
		do
			proxy_time_out := a_timeout
		ensure
			set: proxy_time_out = a_timeout
		end

	set_debugging (a_is_debugging: like is_debugging)
			-- Set `is_debugging' to given value.
		require
			not_running: not has_next_step
		do
			is_debugging := a_is_debugging
		ensure
			set: is_debugging = a_is_debugging
		end

	set_seed (a_seed: NATURAL)
			-- Set random testing seed to `a_seed'.
		require
			not_running: not has_next_step
		do
			if a_seed > 0 then
				random.set_seed (a_seed.as_integer_32)
			else
				random.set_seed ((create {TIME}.make_now).seconds)
			end
		end

	set_load_file_path (a_path: like log_file_path) is
			-- Set `log_file_path' with `a_path'.
		do
			log_file_path_cache := a_path
		ensure
			log_file_path_set: log_file_path = a_path
		end

	set_is_random_testing_enabled (b: BOOLEAN) is
			-- Set `is_random_testing_enabled' with `b'.
		do
			is_random_testing_enabled_cache := b
		ensure
			is_random_testing_enabled_set: is_random_testing_enabled = b
		end

	set_is_evolutionary_testing_enabled (b: BOOLEAN) is
			-- Set `is_evolutionary_testing_enabled' with `b'.
		do
			is_evolutionary_testing_enabled_cache := b
		ensure
			is_evolutionary_testing_enabled_set: is_evolutionary_testing_enabled = b
		end

	set_object_state_config (a_config: like object_state_config) is
			-- Set `object_state_config' with `a_config'.
		do
			object_state_config := a_config
		ensure
			object_state_config_set: object_state_config = a_config
		end

	set_is_precondition_evaluation_enabled (b: BOOLEAN) is
			-- Set `is_precondition_checking_enabled' with `b'.
		do
			precondition_evaluation_cache := b
		ensure
			is_precondition_checking_enabled_set: is_precondition_checking_enabled = b
		end

	set_is_linear_solving_enabled (b: BOOLEAN) is
			-- Set `is_precondition_checking_enabled' with `b'.
		do
			linear_solving_cache := b
		ensure
			is_linear_solving_enabled_set: is_linear_constraint_solving_enabled = b
		end

	set_is_object_state_exploration_enabled (b: BOOLEAN) is
			-- Set `is_precondition_checking_enabled' with `b'.
		do
			object_state_exploration_cache := b
		ensure
			is_object_state_exploration_enabled_set: is_object_state_exploration_enabled = b
		end

	set_log_processor (a_processor: like log_processor) is
			-- Set `log_processor' with `a_processor'.
		do
			if a_processor /= Void then
				create log_processor_cache.make_from_string (a_processor)
			else
				log_processor_cache := Void
			end
		end

	set_log_processor_output (a_processor_output: like log_processor_output) is
			-- Set `log_processor_output' with `a_processor_output'.
		do
			if a_processor_output /= Void then
				create log_processor_output_cache.make_from_string (a_processor_output)
			else
				log_processor_output_cache := Void
			end
		end

	set_max_precondition_search_tries (a_tries: like max_precondition_search_tries) is
			-- Set `max_precondition_search_tries' with `a_tries'.
		do
			max_precondition_search_tries_cache := a_tries
		ensure
			good_result: max_precondition_search_tries = a_tries
		end

	set_max_precondition_search_time (a_time: like max_precondition_search_time) is
			-- Set `max_precondition_search_time' with `a_time'.
		do
			max_precondition_search_time_cache := a_time
		ensure
			good_result: max_precondition_search_time = a_time
		end

	set_max_candidate_count (a_count: like max_candidate_count) is
			-- Set `is_object_state_request_logged' with `a_count'.
		do
			max_candidate_count_cache := a_count
		ensure
			max_candidate_count_cache_set: max_candidate_count_cache = a_count
		end

	set_is_smt_linear_constraint_solver_enabled (b: BOOLEAN) is
			-- Set `is_smt_linear_constraint_solver_enabled' with `b'.
		do
			is_smt_linear_constraint_solver_enabled_cache := b
		ensure
			is_smt_linear_constraint_solver_enabled_set: is_smt_linear_constraint_solver_enabled = b
		end

	set_is_lpsolve_linear_constraint_solver_enabled (b: BOOLEAN) is
			-- Set `is_lpsolve_linear_constraint_solver_enabled' with `b'.
		do
			is_lpsolve_linear_constraint_solver_enabled_cache := b
		ensure
			is_lpsolve_linear_constraint_solver_enabled_set: is_lpsolve_linear_constraint_solver_enabled = b
		end

	set_object_selection_for_precondition_satisfaction_rate (a_value: INTEGER) is
			-- Set `object_selection_for_precondition_satisfaction_rate' with `a_value'.
		do
			object_selection_for_precondition_satisfaction_rate_cache := a_value
		ensure
			object_selection_for_precondition_satisfaction_rate_set: object_selection_for_precondition_satisfaction_rate = a_value
		end

	set_smt_enforce_old_value_rate (a_rate: INTEGER) is
			-- Set `smt_enforce_old_value_rate' with `a_rate'.
		do
			smt_enforce_old_value_rate_cache := a_rate
		ensure
			smt_enforce_old_value_rate_set: smt_enforce_old_value_rate_cache = a_rate
		end

	set_smt_use_predefined_value_rate (a_rate: INTEGER) is
			-- Set `smt_use_predefined_value_rate' with `a_rate'.
		do
			smt_use_predefined_value_rate_cache := a_rate
		ensure
			good_result: smt_use_predefined_value_rate = a_rate
		end

	set_integer_lower_bound (a_bound: INTEGER) is
			-- Set `integer_lower_bound' with `a_bound'.
		do
			integer_lower_bound_cache := a_bound
		ensure
			integer_lower_bound_set: integer_lower_bound = a_bound
		end

	set_integer_upper_bound (a_bound: INTEGER) is
			-- Set `integer_upper_bound' with `a_bound'.
		do
			integer_upper_bound_cache := a_bound
		ensure
			integer_upper_bound_set: integer_upper_bound = a_bound
		end

	set_is_random_cursor_used (b: BOOLEAN) is
			-- Set `is_random_cursor_used' with `b'.
		do
			is_random_cursor_used_cache := b
		ensure
			is_random_cursor_used_set: is_random_cursor_used = b
		end

	set_is_passing_test_case_serialization_enabled (b: BOOLEAN) is
			-- Set `is_passing_test_case_serialization_enabled' with `b'.
		do
			is_passing_test_case_serialization_enabled_cache := b
		ensure
			is_passing_test_case_serialization_enabled_set: is_passing_test_case_serialization_enabled = b
		end

	set_is_failing_test_case_serialization_enabled (b: BOOLEAN) is
			-- Set `is_failing_test_case_serialization_enabled' with `b'.
		do
			is_failing_test_case_serialization_enabled_cache := b
		ensure
			is_failing_test_case_serialization_enabled_set: is_failing_test_case_serialization_enabled = b
		end

	set_is_passing_test_case_deserialization_enabled (b: BOOLEAN) is
			-- Set `is_passing_test_case_deserialization_enabled' with `b'.
		do
			is_passing_test_case_deserialization_enabled_cache := b
		ensure
			is_passing_test_case_deserialization_enabled_set: is_passing_test_case_deserialization_enabled = b
		end

	set_is_failing_test_case_deserialization_enabled (b: BOOLEAN) is
			-- Set `is_failing_test_case_deserialization_enabled' with `b'.
		do
			is_failing_test_case_deserialization_enabled_cache := b
		ensure
			is_failing_test_case_deserialization_enabled_set: is_failing_test_case_deserialization_enabled = b
		end

	set_recursive (b: BOOLEAN)
			-- Set `is_recursive_cache' with 'b'.
		do
			is_recursive_cache := b
		ensure
			is_recursive_set: is_recursive = b
		end

	set_data_input (a_input: detachable STRING)
			-- Set `data_input' with 'a_input'.
		do
			if a_input = Void then
				data_input_cache := Void
			else
				data_input_cache := a_input.twin
			end
		ensure
			data_input_set: a_input = Void implies data_input_cache = Void
						and then a_input /= Void implies data_input_cache ~ a_input
		end

	set_data_output (a_output: detachable STRING)
			-- Set `data_output' with 'a_output'.
		do
			if a_output = Void then
				data_output_cache := Void
			else
				data_output_cache := a_output.twin
			end
		ensure
			data_output_set: a_output = Void implies data_output_cache = Void
						and then a_output /= Void implies data_output_cache ~ a_output
		end

	set_is_interpreter_log_enabled (b: BOOLEAN)
			-- Set `is_interpreter_log_enabled' with `b'.
		do
			is_interpreter_log_enabled_cache := b
		ensure
			is_interpreter_log_enabled_set: is_interpreter_log_enabled = b
		end

	set_is_duplicated_test_case_serialized (b: BOOLEAN)
			-- Set `is_duplicated_test_case_serialized' with `b'.
		do
			is_duplicated_test_case_serialized_cache := b
		ensure
			is_duplicated_test_case_serialized_set: is_duplicated_test_case_serialized = b
		end

	set_proxy_log_options (b: like proxy_log_options)
			-- Set `proxy_log_options' with `b'.
		do
			proxy_log_options_cache := b.twin
		ensure
			proxy_log_options_set: proxy_log_options ~ b
		end

	set_is_console_output_enabled (b: BOOLEAN)
			-- Set `is_console_output_enabled'.
		do
			is_console_output_enabled_cache := b
		ensure
			is_console_output_enabled_set: is_console_output_enabled = b
		end

	set_is_post_state_serialized (b: BOOLEAN)
			-- Set `is_post_state_serialized' with `b'.
		do
			is_post_state_serialized_cache := b
		ensure
			is_post_state_serialized_set: is_post_state_serialized = b
		end

	set_types_under_test (a_types: like types_under_test) is
			-- Set `types_under_test' with `a_types'.
		do
			create {DS_ARRAYED_LIST [CL_TYPE_A]} types_under_test.make (a_types.count)
			types_under_test.append_last (a_types)
		end

feature -- Basic operations

	step
			-- <Precursor>
		do
			Precursor
			flush_output
			proceeded_event.publish ([Current])
		end


feature {NONE} -- Basic operations

	start_creation
			-- <Precursor>
		do
			random.start
			prepare
		end

	remove_task (a_task: attached like sub_task; a_cancel: BOOLEAN)
			-- <Precursor>
		local
			l_test_task: ETEST_GENERATION_TESTING
			l_stat_task: ETEST_GENERATION_STATISTICS
		do
			if not a_cancel then
				if attached {ETEST_MELT_TASK} sub_task as l_task then
					if l_task.is_successful then
						system.remove_explicit_root (interpreter_root_class_name, interpreter_root_feature_name)
						system.make_update (False)
						compute_interpreter_root_class
						if attached interpreter_root_class then
							if is_random_testing_enabled then
								create l_test_task.make_random (Current, class_names)
								l_test_task.start
								sub_task := l_test_task
							elseif is_load_log_enabled then
								load_log
							elseif is_test_case_deserialization_enabled then
								process_deserialization
							end
						end
					end
				elseif attached {ETEST_GENERATION_TESTING} sub_task as l_task then
					if is_html_statistics_format_enabled then
						create l_stat_task.make (Current)
						l_stat_task.start (l_task.result_repository, l_task.classes_under_test)
						sub_task := l_stat_task
					end
				end
			end
			if not has_next_step then
				clean
			end
		end

	clean
			-- Clean up any resources used during testing.
		do
			sub_task := Void
			flush_output
			if attached output_file as l_file then
				if l_file.is_closable then
					l_file.close
				end
				output_file := Void
			end
			clean_record
		end

feature {NONE} -- Implementation

	prepare
			-- Prepare test generation
		local
			l_file_name: FILE_NAME
			l_file: KL_TEXT_OUTPUT_FILE
			l_error_handler: AUT_ERROR_HANDLER
		do
			check_environment_variable
			set_precompile (False)

			l_error_handler := error_handler

			create l_file_name.make_from_string (output_dirname)
			l_file_name.extend ("log")
			l_file_name.set_file_name ("error")
			l_file_name.add_extension ("log")
			create l_file.make (l_file_name)
			l_file.recursive_open_write
			if l_file.is_open_write then
				output_file := l_file
			end

			l_error_handler.set_error_file (output_stream)
			l_error_handler.set_warning_file (output_stream)
			l_error_handler.set_info_file (output_stream)
			if is_debugging then
				l_error_handler.set_debug_to_file (output_stream)
			end

			find_types_under_test
			setup_for_precondition_evaluation

			compile_project (class_names)
		end

	compile_project (a_class_name_list: like class_names)
			-- Compile `a_project' with new `a_root_class' and `a_root_feature'.
			--
			-- TODO: `class_names' should be retrieved from `session'
		local
			l_dir: PROJECT_DIRECTORY
			l_file: KL_TEXT_OUTPUT_FILE
			l_file_name: FILE_NAME
			l_source_writer: TEST_INTERPRETER_SOURCE_WRITER
			l_system: SYSTEM_I
			l_melt: ETEST_MELT_TASK
		do
			l_system := system
			check l_system /= Void end
				-- Create actual root class in EIFGENs cluster
			l_dir := l_system.project_location
			create l_file_name.make_from_string (l_dir.eifgens_cluster_path)
			l_file_name.set_file_name (interpreter_root_class_name.as_lower)
			l_file_name.add_extension ("e")
			create l_file.make (l_file_name)
			if not l_file.exists then
				l_system.force_rebuild
			end
			l_file.recursive_open_write
			create l_source_writer.make (Current)
			if l_file.is_open_write then
				l_source_writer.write_class (l_file, a_class_name_list, l_system)
				l_file.flush
				l_file.close
			end

			if not l_system.is_explicit_root (interpreter_root_class_name, interpreter_root_feature_name) then
				l_system.add_explicit_root (Void, interpreter_root_class_name, interpreter_root_feature_name)
			end

			append_output (
				agent (a_formatter: TEXT_FORMATTER)
					do
						a_formatter.process_basic_text ("Compiling project%N")
					end, True)

			create l_melt.make (etest_suite)
			l_melt.start (True)
			sub_task := l_melt
		end


feature{NONE} -- Test result analyizing

	print_new_class (a_file: KL_TEXT_OUTPUT_FILE; a_class_name: STRING)
			-- <Precursor>
		local
			l_system: like system
			l_count: NATURAL
			l_test_name: IMMUTABLE_STRING_8
		do
			l_system := system
			check l_system /= Void end
			source_writer.prepare (a_file, a_class_name, l_system)
			from
				l_count := 1
			until
				current_results.is_empty or l_count > max_tests_per_class
			loop
				source_writer.print_test_routine (current_results.last)
				current_results.remove_last
				create l_test_name.make_from_string (a_class_name + "." + source_writer.last_test_routine_name)
				publish_test_creation (l_test_name)
			end
			source_writer.finish
		ensure then
			results_decreased: current_results.count < old current_results.count
		end

feature -- Basic operations

	print_test_set (a_list: DS_ARRAYED_LIST [AUT_TEST_CASE_RESULT])
			-- Print test case results as test.
			--
			-- `a_list': List of test case results to be printed to a test set.
		require
			a_list_attached: a_list /= Void
		local
			l_project_helper: TEST_PROJECT_HELPER_I
			l_last_class: EIFFEL_CLASS_I
		do
			current_results := a_list
			l_project_helper := etest_suite.project_helper
			if l_project_helper.is_class_added then
				l_last_class := l_project_helper.last_added_class
			end
			create_new_class
			if
				l_project_helper.is_class_added and then
				attached l_project_helper.last_added_class as l_new_class and then
				l_last_class /= l_new_class
			then
				error_handler.report_test_generation (l_new_class)
			end
			current_results := Void
		end

	flush_output
			-- Redirect output currently stored in `output_stream' to `output_file' and `output_formatter'
			-- (if attached) and wipe out string in `output_stream'.
		local
			l_string: STRING
		do
			l_string := output_stream.string
			if not l_string.is_empty then
				if attached output_file as l_file then
					l_file.put_string (l_string)
					l_file.flush
				end
				append_output (agent {TEXT_FORMATTER}.add_string (l_string), False)
				l_string.wipe_out
			end
		end

feature {NONE} -- Implementation

	safe_dispose (a_explicit: BOOLEAN)
			-- <Precursor>
		do
			if a_explicit and has_next_step then
				cancel
			end
		end

feature {NONE} -- Constants

	application_name: STRING = "ec"
			-- <Precursor>
			--
			-- Name of EiffelStudio exe;
			-- Needed to locate the correct registry keys on windows
			-- in order to find it's install path.

	max_tests_per_class: NATURAL = 9
			-- Maximal number of test routines in a single class

feature -- Precondition satisfaction

	find_types_under_test is
			-- Find types under test and add them into `configuration'.`types_under_test'.
		do
			set_types_under_test (types_under_test_from_names (class_names, system.root_type.associated_class))
		end

	types_under_test_from_names (a_list: detachable DS_HASH_SET [STRING_8]; a_context: CLASS_C): DS_LINKED_LIST [CL_TYPE_A]
			-- Types under test from class names in `a_list'.
			-- classes_under_test with list of class names.
			--
			-- `a_list': List of class/type names, can be void or empty to indicate that all classes in the
			--           system should be tested.
		local
			l_tester: KL_STRING_EQUALITY_TESTER_A [STRING_8]
			l_class_set: SEARCH_TABLE [CLASS_I]
			l_class_cur: INTEGER
			l_type: TYPE_A
			l_class_name_set: DS_HASH_SET [STRING_8]
			l_name_cur: DS_HASH_SET_CURSOR [STRING_8]
			l_name: STRING_8
		do
			fixme ("Duplicated code with {AUT_RANDOM_STRATEGY}.`add_class_names'. 17.06.2009 Jasonw")
			create Result.make
			create l_tester
			if a_list /= Void and then not a_list.is_empty then
				create l_class_name_set.make (a_list.count)
				l_class_name_set.set_equality_tester (l_tester)
				l_class_name_set.append (a_list)
			else
				l_class_set := system.universe.all_classes
				create l_class_name_set.make (l_class_set.count)
				l_class_name_set.set_equality_tester (l_tester)
				from
					l_class_cur := l_class_set.cursor
					l_class_set.start
				until
					l_class_set.after
				loop
					l_name := l_class_set.item_for_iteration.name
					check
						l_name /= Void
					end
					l_class_name_set.force_last (l_name)
					l_class_set.forth
				end
				l_class_set.go_to (l_class_cur)
			end
			from
				l_name_cur := l_class_name_set.new_cursor
				l_name_cur.start
			until
				l_name_cur.after
			loop
				l_type := base_type_with_context (l_name_cur.item, a_context)
				if l_type /= Void then
					if l_type.associated_class.is_generic then
						if not attached {GEN_TYPE_A} l_type as l_gen_type then
							if attached {GEN_TYPE_A} l_type.associated_class.actual_type as l_gen_type2 then
								l_type := generic_derivation_of_type (l_gen_type2, l_gen_type2.associated_class)
							else
								check
									dead_end: False
								end
							end
						end
					end
					if attached {CL_TYPE_A} l_type as l_class_type then
						if l_class_type.associated_class /= Void then
							if not interpreter_related_classes.has (l_class_type.name) then
								Result.force_last (l_class_type)
							end
						end
					else
						check
							dead_end: False
						end
					end
				end
				l_name_cur.forth
			end
		end

	setup_for_precondition_evaluation is
			-- Setup for precondition evaluation.
		local
			l_initializer: AUT_PRECONDITION_SATISFACTION_INITIALIZER
		do
			create l_initializer
			l_initializer.initialize (Current)
		end

feature -- Log processor

	load_log
			-- Load log in `a_log_file'.
		local
			l_log_loader: AUT_LOG_LOADER
		do
			create l_log_loader.make (Current)
			l_log_loader.load
		end

feature -- Deserialization

	process_deserialization
			-- Test case deserialization.
		local
			l_processor: AUT_DESERIALIZATION_PROCESSOR
		do
			create l_processor.make (system, Current)
			l_processor.process
		end

feature -- Option caches

	is_evolutionary_testing_enabled_cache: like is_evolutionary_testing_enabled assign set_is_evolutionary_testing_enabled
			-- Cache for `is_evolutionary_testing_enabled'

	log_file_path_cache: like log_file_path assign set_load_file_path
			-- Cache for `log_file_path'

	precondition_evaluation_cache: like is_precondition_checking_enabled
			-- Cache for `is_precondition_checking_enabled'

	linear_solving_cache: like is_linear_constraint_solving_enabled
			-- Cache for `is_linear_constraint_solving_enabled'

	object_state_exploration_cache: like is_object_state_exploration_enabled
			-- Cache for `is_object_state_exploration_enabled'

	log_processor_cache: like log_processor
			-- Cache for `log_processor'

	log_processor_output_cache: like log_processor_output
			-- Cache for `log_processor_output'

	data_input_cache: like data_input
			-- Cache for `data_input'.

	data_output_cache: like data_output
			-- Cache for `data_output'.

	is_recursive_cache: BOOLEAN
			-- Cache for `is_recursive'.

	max_precondition_search_tries_cache: like max_precondition_search_tries
			-- Cache for `max_precondition_search_tries'

	max_precondition_search_time_cache: like max_precondition_search_time
			-- Cache for `max_precondition_search_time'

	max_candidate_count_cache: like max_candidate_count
			-- Cache for `max_candidate_count'

	is_lpsolve_linear_constraint_solver_enabled_cache: like is_lpsolve_linear_constraint_solver_enabled
			-- Cache for `is_lpsolve_linear_constraint_solver_enabled'

	is_smt_linear_constraint_solver_enabled_cache: like is_smt_linear_constraint_solver_enabled
			-- Cache for `is_smt_linear_constraint_solver_enabled'

	object_selection_for_precondition_satisfaction_rate_cache: INTEGER
			-- Cache for `object_selection_for_precondition_satisfaction_rate'

	smt_enforce_old_value_rate_cache: INTEGER
			-- Cache for `smt_enforce_old_value_rate'

	smt_use_predefined_value_rate_cache: INTEGER
			-- Cache for `smt_use_predefined_value_rate'

	integer_lower_bound_cache: INTEGER
			-- Cache for `integer_lower_bound'

	integer_upper_bound_cache: INTEGER
			-- Cache for `integer_upper_bound'

	is_random_cursor_used_cache: BOOLEAN
			-- Cache for `is_random_cursor_used'

	is_passing_test_case_serialization_enabled_cache: BOOLEAN
			-- Cache for `is_passing_test_case_serialization_enabled_cache'

	is_failing_test_case_serialization_enabled_cache: BOOLEAN
			-- Cache for `is_passing_test_case_serialization_enabled_cache'

	is_passing_test_case_deserialization_enabled_cache: BOOLEAN
			-- Cache for `is_passing_test_case_deserialization_enabled_cache'

	is_failing_test_case_deserialization_enabled_cache: BOOLEAN
			-- Cache for `is_passing_test_case_deserialization_enabled_cache'

	is_interpreter_log_enabled_cache: BOOLEAN
			-- Cache for `is_interpreter_log_enabled'

	proxy_log_options_cache: like proxy_log_options
			-- Cache for `is_proxy_log_options'	

	is_console_output_enabled_cache: BOOLEAN
			-- Cache for `is_console_output_enabled'		

	is_duplicated_test_case_serialized_cache: BOOLEAN
			-- Cache for `is_duplicated_test_case_serialized_cache'

	is_post_state_serialized_cache: BOOLEAN
			-- Cache for `is_post_state_serialized_cache'

	is_load_log_enabled: BOOLEAN is
			-- Should a specified load file be loaded?
		do
			Result := log_file_path /= Void
		end

--	is_processing_serialization: BOOLEAN
--			-- <Precursor>
--		do
--			Result := serialization_filters /= Void and then is_load_log_enabled
--		end

	is_random_testing_enabled: BOOLEAN
			-- Is random testing enabled?
		do
			Result := is_random_testing_enabled_cache
		ensure then
			result_set: Result = is_random_testing_enabled_cache
		end

	is_evolutionary_testing_enabled: BOOLEAN
			-- Is evolutionary testing enabled?
		do
			Result := is_evolutionary_testing_enabled_cache
		ensure then
			result_set: Result = is_evolutionary_testing_enabled_cache
		end

	is_random_testing_enabled_cache: like is_random_testing_enabled assign set_is_random_testing_enabled
			-- Cache for `is_random_testing_enabled'		

	excluded_features_cache: like excluded_features
			-- Cache for `excluded_features'		

;note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
