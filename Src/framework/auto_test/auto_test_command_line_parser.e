note
	description:

		"AutoTest command line parser"

	copyright: "Copyright (c) 2004-2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class AUTO_TEST_COMMAND_LINE_PARSER

inherit
	AUT_SHARED_RANDOM

	KL_SHARED_ARGUMENTS

create
	make_with_arguments,
	make_with_configuration

feature{NONE} -- Initialization

	make_with_arguments (a_arguments: DS_LIST [STRING]; error_handler: AUT_ERROR_HANDLER)
			-- Process `a_arguments'.		
		require
			a_arguments_attached: a_arguments /= Void
			error_hadler_not_void: error_handler /= Void
		local
			parser: AUT_AP_PARSER
			version_option: AP_FLAG
			quiet_option: AP_FLAG
			debug_option: AP_FLAG
			just_test_option: AP_FLAG
--			ecf_target_option: AP_STRING_OPTION
--			deep_manual_option: AP_FLAG
			disable_manual_option: AP_FLAG
			disable_auto_option: AP_FLAG
			benchmark_option: AP_FLAG
			disable_minimize_option: AP_FLAG
			minimize_option: AP_STRING_OPTION
			finalize_option: AP_FLAG
			output_dir_option: AP_STRING_OPTION
			time_out_option: AP_INTEGER_OPTION
			test_count_option: AP_INTEGER_OPTION
			seed_option: AP_INTEGER_OPTION
			statistics_format_op: AP_STRING_OPTION
			time: TIME
			proxy_time_out_option: AP_INTEGER_OPTION
			l_log_to_replay: AP_STRING_OPTION
			l_help_option: AP_FLAG
			l_help_flag: AP_DISPLAY_HELP_FLAG
			l_load_log_option: AP_STRING_OPTION
			l_state_option: AP_STRING_OPTION
			l_precondition_option: AP_FLAG
			l_constraint_solving_option: AP_FLAG
			l_object_state_exploration: AP_FLAG
			l_log_processor_op: AP_STRING_OPTION
			l_log_processor_output_op: AP_STRING_OPTION
			l_max_precondition_tries_op: AP_INTEGER_OPTION
			l_max_precondition_time_op: AP_INTEGER_OPTION
			l_prepare_citadel_tests_option: AP_STRING_OPTION
			l_candidate_count_option: AP_INTEGER_OPTION
			l_pool_statistics_logged_option: AP_FLAG
			l_linear_constraint_solver_option: AP_STRING_OPTION
			l_smart_selection_rate_option: AP_INTEGER_OPTION
			l_smt_old_value_rate_option: AP_INTEGER_OPTION
			l_smt_use_predefined_value_rate_option: AP_INTEGER_OPTION
			l_integer_bound_option: AP_STRING_OPTION
			l_use_random_cursor_option: AP_FLAG
			l_test_case_serialization_option: AP_STRING_OPTION
			l_interpreter_log_enabled: AP_STRING_OPTION
			l_on_the_fly_tc_flag: AP_FLAG
			l_proxy_log_option: AP_STRING_OPTION
			l_console_log_option: AP_STRING_OPTION
			l_duplicated_test_case_serialization_option: AP_FLAG
			l_strs: LIST [STRING]
		do
			create parser.make_empty
			parser.set_application_description ("auto_test is a contract-based automated testing tool for Eiffel systems.")
			parser.set_parameters_description ("class-name+")

			create version_option.make ('V', "version")
			version_option.set_description ("Output version information and exit")
			parser.options.force_last (version_option)

			create quiet_option.make ('q', "quiet")
			quiet_option.set_description ("Be quiet.")
			parser.options.force_last (quiet_option)

			create debug_option.make ('d', "debug")
			debug_option.set_description ("Append debugging output to log.")
			parser.options.force_last (debug_option)

			create just_test_option.make ('j', "just-test")
			just_test_option.set_description ("Skip compilation and generation of interpreter and go right to testing.")
			parser.options.force_last (just_test_option)

--			create ecf_target_option.make ('r', "target")
--			ecf_target_option.set_description ("Target (from supplied ECF file) that should be used for testing.")
--			parser.options.force_last (ecf_target_option)

--			create deep_manual_option.make ('d', "deep-manual")
--			deep_manual_option.set_description ("Enable deep relevancy check for manual strategy.")
--			parser.options.force_last (deep_manual_option)

			create disable_manual_option.make ('m', "disable-manual")
			disable_manual_option.set_description ("Disable manual testing strategy.")
			parser.options.force_last (disable_manual_option)

			create disable_auto_option.make ('a', "disable-auto")
			disable_auto_option.set_description ("Disable automated testing strategy.")
			parser.options.force_last (disable_auto_option)

			create benchmark_option.make ('k', "benchmark")
			benchmark_option.set_description ("Log timeing information (usefull for assessing efficiency).")
			parser.options.force_last (benchmark_option)

			create disable_minimize_option.make ('i', "disable-minimize")
			disable_minimize_option.set_description ("Disable minimize testing strategy.")
			parser.options.force_last (disable_minimize_option)

			create minimize_option.make ('n', "minimize")
			minimize_option.set_description ("Minimize with a certain algorithm.")
			parser.options.force_last (minimize_option)

--			create finalize_option.make ('f', "finalize")
--			finalize_option.set_description ("Use finalized intepreter. (Better performance, but no melting)")
--			parser.options.force_last (finalize_option)

			create output_dir_option.make ('o', "output-dir")
			output_dir_option.set_description ("Output directory for reflection library")
			parser.options.force_last (output_dir_option)

			create time_out_option.make ('t', "time-out")
			time_out_option.set_description ("Time used for testing (in minutes). Default is 15 minutes.")
			parser.options.force_last (time_out_option)

			create test_count_option.make ('c', "count")
			test_count_option.set_description ("Maximum number of tests to be executed, 0 means no restriction. Default is 0.")
			parser.options.force_last (test_count_option)

			create seed_option.make ('e', "seed")
			seed_option.set_description ("Integer seed to initialize pseudo-random number generation with. If not specified seed is intialized with current time.")
			parser.options.force_last (seed_option)

			create statistics_format_op.make ('s', "stat-format")
			statistics_format_op.set_description ("Format in which to output statistics. Possibilities are 'html' and 'text'. Default is 'html'.")
			parser.options.force_last (statistics_format_op)

			create proxy_time_out_option.make ('x', "proxy-time-out")
			proxy_time_out_option.set_description ("Time in seconds used by proxy to wait for a feature to execute. Default is 5.")
			parser.options.force_last (proxy_time_out_option)

			create l_log_to_replay.make ('l', "log")
			l_log_to_replay.set_description ("Log file to be replayed. All the test cases in the given log file will be replayed.")
			parser.options.force_last (l_log_to_replay)

			create l_help_option.make ('h', "help")
			l_help_option.set_description ("Display this help message.")
			parser.options.force_last (l_help_option)

			create l_load_log_option.make_with_long_form ("log-file")
			l_load_log_option.set_description ("Process the log file specified as the following parameter.")
			parser.options.force_last (l_load_log_option)

			create l_state_option.make_with_long_form ("state")
			l_state_option.set_description ("Parameters to enable object state monitoring. The format is comma separated names. The supported parameters are target, argument and result. For example: %"target,argument%" means only retrieve state for target and argument objects.")
			parser.options.force_last (l_state_option)

			create l_precondition_option.make ('p', "precondition")
			l_precondition_option.set_description ("Enable precondition evaluation before feature call.")
			parser.options.force_last (l_precondition_option)

			create l_constraint_solving_option.make_with_long_form ("cs")
			l_constraint_solving_option.set_description ("Enable linear constraint solving for integers.")
			parser.options.force_last (l_constraint_solving_option)

			create l_object_state_exploration.make_with_long_form ("state-explore")
			l_object_state_exploration.set_description ("Enable object state exploration.")
			parser.options.force_last (l_object_state_exploration)

			create l_log_processor_op.make_with_long_form ("log-processor")
			l_log_processor_op.set_description ("Processor for the log file specified with the " + l_load_log_option.name + " option. Supported processors are: 1) ps: precondition satisfaction processor 2) state: object state processor.")
			parser.options.force_last (l_log_processor_op)

			create l_log_processor_output_op.make_with_long_form ("log-processor-output")
			l_log_processor_output_op.set_description ("Name of the output file from the log processor specified with the " + l_log_processor_op.name + " option.")
			parser.options.force_last (l_log_processor_output_op)

			create l_max_precondition_tries_op.make_with_long_form ("max-precondition-tries")
			l_max_precondition_tries_op.set_description ("Maximal tries to search for an object combination satisfying precondition of a feature. 0 means that search until an object combination is found.")
			parser.options.force_last (l_max_precondition_tries_op)

			create l_max_precondition_time_op.make_with_long_form ("max-precondition-time")
			l_max_precondition_time_op.set_description ("Maximal time that can be spent in searching for an object combination satisfying precondition of a feature. 0 means that search until an object combination is found.")
			parser.options.force_last (l_max_precondition_time_op)

			create l_prepare_citadel_tests_option.make_with_long_form ("citadel")
			l_prepare_citadel_tests_option.set_description ("Generate, from an existing proxy log given as next parameter, tests which CITADEL can use.")
			parser.options.force_last (l_prepare_citadel_tests_option)

			create l_candidate_count_option.make_with_long_form ("max-candidates")
			l_candidate_count_option.set_description ("Max number of candidates that satisfy the precondition of the feature to call. 0 means no limit, default is 100.")
			parser.options.force_last (l_candidate_count_option)

			create l_pool_statistics_logged_option.make_with_long_form ("pool-statistics-logged")
			l_pool_statistics_logged_option.set_description ("Should statistics of object pool and predicate pool be logged? Default: False")
			parser.options.force_last (l_pool_statistics_logged_option)

			create l_linear_constraint_solver_option.make_with_long_form ("linear-constraint-solver")
			l_linear_constraint_solver_option.set_description ("Linear constraint solver to be used, can be either %"smt%" or %"lpsolve%". Default is %"smt%".")
			parser.options.force_last (l_linear_constraint_solver_option)

			create l_smart_selection_rate_option.make_with_long_form ("ps-selection-rate")
			l_smart_selection_rate_option.set_description ("Rate under which smart selection of object to satisfy preconditions are used.")
			parser.options.force_last (l_smart_selection_rate_option)

			create l_smt_old_value_rate_option.make_with_long_form ("smt-enforce-old-value-rate")
			l_smt_old_value_rate_option.set_description ("Possibility [0-100] to enforce SMT solver to choose an already used value. Default is 25")
			parser.options.force_last (l_smt_old_value_rate_option)

			create l_smt_use_predefined_value_rate_option.make_with_long_form ("smt-use-predefined-value-rate")
			l_smt_use_predefined_value_rate_option.set_description ("Possibility [0-100] to for the SMT solver to choose a predefined value for integers. Default is 25")
			parser.options.force_last (l_smt_use_predefined_value_rate_option)

			create l_integer_bound_option.make_with_long_form ("integer-bounds")
			l_integer_bound_option.set_description ("Lower and upper bounds for integer arguments that are to be solved by a linear constraint solver. In form of %"lower,upper%"")
			parser.options.force_last (l_integer_bound_option)

			create l_use_random_cursor_option.make_with_long_form ("use-random-cursor")
			l_use_random_cursor_option.set_description ("When searching in predicate pool, should random cursor be used? Default is False.")
			parser.options.force_last (l_use_random_cursor_option)

			create l_test_case_serialization_option.make_with_long_form ("serialization")
			l_test_case_serialization_option.set_description ("Enable test case serialization. The value is a string consisting of comma separated keywords: 'passing' or 'failing', indicating passing and failing test cases, respectively, or 'off'. Default: off")
			parser.options.force_last (l_test_case_serialization_option)

			create l_interpreter_log_enabled.make_with_long_form ("interpreter-log")
			l_interpreter_log_enabled.set_description ("Should messaged from the interpreter be logged? Valid options are: on, off. Default: off.")
			parser.options.force_last (l_interpreter_log_enabled)

			create l_on_the_fly_tc_flag.make_with_long_form ("on-the-fly-tc")
			l_on_the_fly_tc_flag.set_description ("Is on-the-fly test case generation enabled? Default: False")
			parser.options.force_last (l_on_the_fly_tc_flag)

			create l_proxy_log_option.make_with_long_form ("proxy-log")
			l_proxy_log_option.set_description ("Proxy-log options. Options consist of comma separated keywords. Valid keywords are: off, passing, failing, invalid, bad, error, type, expr-assign, operand-type, state.")
			parser.options.force_last (l_proxy_log_option)

			create l_console_log_option.make_with_long_form ("console-log")
			l_console_log_option.set_description ("Enable or disable console output. Valid options are: on, off. Default: on")
			parser.options.force_last (l_console_log_option)

			create l_duplicated_test_case_serialization_option.make_with_long_form ("serialize-duplicated-tc")
			l_duplicated_test_case_serialization_option.set_description ("Should duplicated test cases be serialized? Two test cases are duplicated if their operands have the same abstract states. Default: False")
			parser.options.force_last (l_duplicated_test_case_serialization_option)

			parser.parse_list (a_arguments)

--			if version_option.was_found then
--				error_handler.enable_verbose
--				error_handler.report_version_message
--				error_handler.disable_verbose
--				Exceptions.die (0)
--			end

			if not quiet_option.was_found then
				error_handler.enable_verbose
			end

			if debug_option.was_found then
				is_debugging := True
			end

			just_test := just_test_option.was_found

--			if ecf_target_option.was_found then
--				ecf_target := ecf_target_option.parameter
--			end

			is_manual_testing_enabled := not disable_manual_option.was_found
			is_deep_relevancy_enabled := False -- deep_manual_option.was_found
			is_automatic_testing_enabled := not disable_auto_option.was_found
			is_minimization_enabled := not disable_minimize_option.was_found
--			is_debug_mode_enabled := not finalize_option.was_found

			if benchmark_option.was_found then
				error_handler.enable_benchmarking
			end

			if is_minimization_enabled then
				if minimize_option.was_found then
					if minimize_option.parameter.is_equal ("slice") then
						is_slicing_enabled := True
					elseif minimize_option.parameter.is_equal ("ddmin") then
						is_ddmin_enabled := True
					elseif minimize_option.parameter.is_equal ("slice,ddmin") then
						is_slicing_enabled := True
						is_ddmin_enabled := True
					else
						error_handler.report_invalid_minimization_algorithm (minimize_option.parameter)
						--Exceptions.die (1)

					end
				else
					is_slicing_enabled := True -- Default
				end
			else
				if minimize_option.was_found then
					error_handler.report_cannot_specify_both_disable_minimze_and_minimize
					--Exceptions.die (1)
				end
			end

			if not error_handler.has_error then
				if output_dir_option.was_found then
					output_dirname := output_dir_option.parameter
				end

				if time_out_option.was_found and then time_out_option.parameter >= 0 then
					create time_out.make (0, 0 ,0, 0, time_out_option.parameter, 0)
				else
					create time_out.make (0, 0, 0, 0, default_time_out.as_integer_32, 0)
				end

				if test_count_option.was_found then
					if test_count_option.parameter > 0 then
						test_count := test_count_option.parameter.as_natural_32
					end
				end

				if seed_option.was_found then
					random.set_seed (seed_option.parameter)
				else
					create time.make_now
					random.set_seed (time.milli_second)
				end
				random.start

				if statistics_format_op.was_found then
					if statistics_format_op.parameter.is_equal ("text") then
						is_text_statistics_format_enabled := True
					elseif statistics_format_op.parameter.is_equal ("html") then
						is_html_statistics_format_enabled := True
					else
						error_handler.report_statistics_format_error (statistics_format_op.parameter)
					end
				else
					is_html_statistics_format_enabled := True
					is_text_statistics_format_enabled := True
				end
			end

			if not error_handler.has_error then
				if proxy_time_out_option.was_found then
					proxy_time_out := proxy_time_out_option.parameter
				end

				if l_log_to_replay.was_found then
					is_replay_enabled := True
					log_to_replay := l_log_to_replay.parameter.twin
				end

				should_display_help_message := l_help_option.was_found
				if should_display_help_message then
					create l_help_flag.make_with_short_form ('h')
					help_message := l_help_flag.full_help_text (parser)
				end
			end

			if not error_handler.has_error then
				if l_load_log_option.was_found then
					is_load_log_enabled := True
					log_file_path := l_load_log_option.parameter

						-- When we are in load log mode, we disable
						-- automatic testing.
					is_automatic_testing_enabled := False
				end
			end

			if not error_handler.has_error then
				if l_state_option.was_found then
					create object_state_config.make_with_string (l_state_option.parameter)
				end
			end

			if not error_handler.has_error then
				is_precondition_checking_enabled := l_precondition_option.was_found
			end

			if not error_handler.has_error then
				is_linear_constraint_solving_enabled := l_constraint_solving_option.was_found
			end

			if not error_handler.has_error then
				is_object_state_exploration_enabled := l_object_state_exploration.was_found
			end

			if not error_handler.has_error then
				if l_log_processor_op.was_found then
					log_processor := l_log_processor_op.parameter
				end
			end

			if not error_handler.has_error then
				if l_log_processor_output_op.was_found then
					log_processor_output := l_log_processor_output_op.parameter
				end
			end

			if not error_handler.has_error then
				if l_max_precondition_tries_op.was_found then
					max_precondition_search_tries := l_max_precondition_tries_op.parameter
				end
			end

			if not error_handler.has_error then
				is_seed_provided := seed_option.was_found
				if is_seed_provided then
					seed := seed_option.parameter
				end
			end

			if not error_handler.has_error then
				if l_max_precondition_time_op.was_found then
					max_precondition_search_time := l_max_precondition_time_op.parameter
				end
			end

			if not error_handler.has_error then
				if l_prepare_citadel_tests_option.was_found then
					prepare_citadel_tests := True
					is_automatic_testing_enabled := False
					log_file_path := l_prepare_citadel_tests_option.parameter
				end
			end

			if not error_handler.has_error then
				if l_candidate_count_option.was_found then
					max_candidate_count := l_candidate_count_option.parameter
				else
					max_candidate_count := 100
				end
			end

			if not error_handler.has_error then
				is_pool_statistics_logged := l_pool_statistics_logged_option.was_found
			end

			if not error_handler.has_error then
				if l_linear_constraint_solver_option.was_found then
					l_strs := l_linear_constraint_solver_option.parameter.as_lower.split (',')
					l_strs.compare_objects
					if l_strs.has ("smt") then
						is_smt_linear_constraint_solver_enabled := True
					end
					if l_strs.has ("lpsolve") then
						is_lpsolve_contraint_linear_solver_enabled := True
					end
				else
					is_smt_linear_constraint_solver_enabled := True
				end
			end

			if not error_handler.has_error then
				if l_smart_selection_rate_option.was_found then
					object_selection_for_precondition_satisfaction_rate := l_smart_selection_rate_option.parameter
				else
					object_selection_for_precondition_satisfaction_rate := 100
				end
			end

			if not error_handler.has_error then
				if l_smt_old_value_rate_option.was_found then
					smt_enforce_old_value_rate := l_smt_old_value_rate_option.parameter
				else
					smt_enforce_old_value_rate := 25
				end
			end

			if not error_handler.has_error then
				if l_smt_use_predefined_value_rate_option.was_found then
					smt_use_predefined_value_rate := l_smt_use_predefined_value_rate_option.parameter
				else
					smt_use_predefined_value_rate := 25
				end
			end

			if not error_handler.has_error then
				if l_integer_bound_option.was_found then
					l_strs := l_integer_bound_option.parameter.split (',')
					integer_lower_bound := l_strs.first.to_integer
					integer_upper_bound := l_strs.last.to_integer
				else
					integer_lower_bound := -512
					integer_upper_bound := 512
				end
			end

			if not error_handler.has_error then
				is_random_cursor_used := l_use_random_cursor_option.was_found
			end

			if not error_handler.has_error then
				is_passing_test_cases_serialization_enabled := False
				is_failing_test_cases_serialization_enabled := False
				if l_test_case_serialization_option.was_found then
					l_strs := l_test_case_serialization_option.parameter.as_lower.split (',')
					from
						l_strs.start
					until
						l_strs.after
					loop
						if l_strs.item_for_iteration.is_equal ("passing") then
							is_passing_test_cases_serialization_enabled := True
						elseif l_strs.item_for_iteration.is_equal ("failing") then
							is_failing_test_cases_serialization_enabled := True
						end
						l_strs.forth
					end
				end
			end

			if not error_handler.has_error then
				is_interpreter_log_enabled := False
				if l_interpreter_log_enabled.was_found then
					is_interpreter_log_enabled := l_interpreter_log_enabled.parameter.is_case_insensitive_equal ("on")
				end
			end

			if not error_handler.has_error then
				is_console_log_enabled := True
				if l_console_log_option.was_found then
					is_console_log_enabled := l_console_log_option.parameter.is_case_insensitive_equal ("on")
				end
			end

			if not error_handler.has_error then
				is_on_the_fly_test_case_generation_enabled := l_on_the_fly_tc_flag.was_found
			end

			if not error_handler.has_error then
				if l_proxy_log_option.was_found then
					proxy_log_options := l_proxy_log_option.parameter
				else
					proxy_log_options := ""
				end
			end

			if not error_handler.has_error then
				is_duplicated_test_case_serialized := l_duplicated_test_case_serialization_option.was_found
			end

--			if parser.parameters.count = 0 then
--				error_handler.report_missing_ecf_filename_error
--				-- TODO: Display usage_instruction (currently not exported, find better way to do it.)
--				-- error_handler.report_info_message (parser.help_option.usage_instruction (parser))
--				Exceptions.die (1)
--			else
--				ecf_filename := parser.parameters.first
				class_names := parser.parameters.twin
--				create {DS_ARRAYED_LIST []} class_names.make
--				from
--					cs := parser.parameters.new_cursor
--					cs.start
----					cs.forth
--				until
--					cs.off
--				loop
--					class_names.force_last (cs.item)
--					cs.forth
--				end
--			end
		ensure
			help_message_set_when_required: should_display_help_message implies help_message /= Void
		end

	make_with_configuration (a_conf: TEST_GENERATOR_CONF_I; error_handler: AUT_ERROR_HANDLER)
			-- use `configuration' to initialize AutoTest settings
		do
			is_slicing_enabled := a_conf.is_slicing_enabled
			is_ddmin_enabled := a_conf.is_ddmin_enabled
			is_minimization_enabled := is_slicing_enabled or is_ddmin_enabled

			create time_out.make (0, 0, 0, 0, a_conf.time_out.as_integer_32, 0)
			test_count := a_conf.test_count

			if a_conf.seed > 0 then
				random.set_seed (a_conf.seed.to_integer_32)
			else
				random.set_seed ((create {TIME}.make_now).milli_second)
			end
			random.start

			is_text_statistics_format_enabled := True
			is_html_statistics_format_enabled := a_conf.is_html_output

			proxy_time_out := a_conf.proxy_time_out.as_integer_32

			create {DS_ARRAYED_LIST [attached STRING]} class_names.make_from_linear (a_conf.types)
		end

feature -- Status report

	output_dirname: STRING
			-- Name of output directory

	ecf_filename: STRING
			-- Name of ecf file of input system

--	ecf_target: STRING
--			-- Name of target in file named `ecf_filename'; Void if no target was specified.

	class_names: DS_LIST [STRING]
			-- List of class names to be tested

	time_out: DT_DATE_TIME_DURATION
			-- Maximal time to test;
			-- A timeout value of `0' means no time out.

	test_count: NATURAL
			-- Maximum number of tests to be executed
			--
			-- Note: a value of `0' means no upper limit

--	is_debug_mode_enabled: BOOLEAN
			-- Should the interpreter runtime be compiled with
			-- assertion checking on?

	just_test: BOOLEAN
			-- Should generation and compilation of the interpreter be skipped

	is_deep_relevancy_enabled: BOOLEAN
			-- Should the manual testing strategy use deep dependence
			-- checking when locating relevant manual unit tests?

	is_manual_testing_enabled: BOOLEAN
			-- Should the manual testing strategy be used?

	is_automatic_testing_enabled: BOOLEAN
			-- Should the automatic testing strategy be used?

	is_minimization_enabled: BOOLEAN
			-- Should bug reproducing examples be minimized?

	is_text_statistics_format_enabled: BOOLEAN
			-- Should statistics be output as plain text?

	is_html_statistics_format_enabled: BOOLEAN
			-- Should statistics be output static HTML?

	is_slicing_enabled: BOOLEAN
			-- Should test cases be minimized via slicing?

	is_ddmin_enabled: BOOLEAN
			-- Should test cases be minimized via ddmin?

	proxy_time_out: INTEGER
			-- Proxy time out in second

	is_replay_enabled: BOOLEAN
			-- Is log replay specified?

	log_to_replay: STRING
			-- File name of the log to be replayed.

	should_display_help_message: BOOLEAN
			-- Should help message be displayed?

	help_message: STRING
			-- Help message for command line arguments
			-- This value is only set if help option presents.

	is_debugging: BOOLEAN
			-- True if debugging output should be written to log.

	is_debug_mode_enabled: BOOLEAN
			-- Should the interpreter runtime be compiled with
			-- assertion checking on?

	log_file_path: detachable STRING
			-- Full path of the log file to be loaded.

	is_load_log_enabled: BOOLEAN
			-- Is log load enabled?

	object_state_config: AUT_OBJECT_STATE_CONFIG
			-- Configuration related object state retrieval

	is_precondition_checking_enabled: BOOLEAN
			-- Should precondition evaluation be enabled?

	is_linear_constraint_solving_enabled: BOOLEAN
			-- Is linare constraint solving for integers enabled?

	is_object_state_exploration_enabled: BOOLEAN
			-- Is object state exploration enabled?

	log_processor: detachable STRING
			-- Name of the log processor

	log_processor_output: detachable STRING
			-- Name of the output file from log processor

	max_precondition_search_tries: INTEGER
			-- Max tries in the search to satisfy precondition of a feature
			-- 0 means that search until a satisfying object comibination is found.

	max_precondition_search_time: INTEGER
			-- Maximal time (in second) that can be spent in searching for
			-- objects satisfying precondition of a feature

	is_seed_provided: BOOLEAN
			-- Is seed to the random number generator provided?

	seed: INTEGER
			-- Provided seed
			-- Only have effect if `is_seed_provided' is True.

	prepare_citadel_tests: BOOLEAN
			-- Should AutoTest prepare tests for CITADEL from a given proxy log file?

	max_candidate_count: INTEGER
			-- Max number of candidates that satisfy the precondition of
			-- the feature to call.
			-- 0 means no limit. Default is 100.

	is_pool_statistics_logged: BOOLEAN
			-- Should statistics of object pool and predicate pool be logged?
			-- Default: False

	is_smt_linear_constraint_solver_enabled: BOOLEAN
			-- Is SMT based linear constraint solver enabled?
			-- Default: True

	is_lpsolve_contraint_linear_solver_enabled: BOOLEAN
			-- Is lp_solve based linear constraint solver enabled?
			-- Default: False

	object_selection_for_precondition_satisfaction_rate: INTEGER
			-- Possibility [0-100] under which smart object selection for precondition satisfaction
			-- is used.
			-- Only have effect when precondition evaluation is enabled.

	smt_enforce_old_value_rate: INTEGER
			-- Possibility [0-100] to enforce SMT solver to choose an already used value
			-- Default is 25

	smt_use_predefined_value_rate: INTEGER
			-- Possibility [0-100] to for the SMT solver to choose a predefined value for integers
			-- Default is 25

	integer_lower_bound: INTEGER
			-- Lower bound (min value) for integer arguments that are to be solved by a linear constraint solver
			-- Default is -512.

	integer_upper_bound: INTEGER
			-- Upper bound (max value) for integer arguments that are to be solved by a linear constraint solver
			-- Default is 512.

	is_random_cursor_used: BOOLEAN
			-- When searching in predicate pool, should random cursor be used?
			-- Default: False

	is_passing_test_cases_serialization_enabled: BOOLEAN
			-- Is test case serialization for passing test cases enabled?
			-- Only has effect if `is_test_case_serialization_enabled' is True.
			-- Default: False

	is_failing_test_cases_serialization_enabled: BOOLEAN
			-- Is test case serialization for failing test cases enabled?
			-- Only has effect if `is_test_case_serialization_enabled' is True.
			-- Default: False

	is_interpreter_log_enabled: BOOLEAN
			-- Is the messages from the interpreter logged?
			-- Default: False

	is_on_the_fly_test_case_generation_enabled: BOOLEAN
			-- Is on-the-fly test case generation enabled?
			-- Default: False

	proxy_log_options: STRING
			-- Proxy log options:
			-- Default: passing,failing,invalid,bad,error,type,expr-assign

	is_console_log_enabled: BOOLEAN
			-- Should console output be enabled?
			-- Default: True

	is_duplicated_test_case_serialized: BOOLEAN
			-- Should duplicated test cases be serialized?
			-- Two test cases are duplicated if their operands have the same abstract states.
			-- Default: False

feature {NONE} -- Constants

	default_time_out: NATURAL = 5
			-- Default value for `time_out' in minutes

invariant
	minimization_is_either_slicing_or_ddmin: is_minimization_enabled implies (is_slicing_enabled xor is_ddmin_enabled)

note
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
