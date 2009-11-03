note
	description: "Test creator representing AutoTest"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_GENERATOR

inherit
	TEST_GENERATOR_I

	TEST_CREATOR
		redefine
			make,
			start_process_internal,
			is_valid_typed_configuration,
			stop_process
		end

-- Following ancestors copied from {AUTO_TEST}

	EIFFEL_ENV
		export
			{NONE} all
		end

	AUT_SHARED_INTERPRETER_INFO
		export
			{NONE} all
		end

	AUT_SHARED_TYPE_FORMATTER
		export
			{NONE} all
		end

	AUT_SHARED_CONSTANTS
		export
			{NONE} all
		end

	ERL_G_TYPE_ROUTINES
		export
			{NONE} all
		end

	ERL_CONSTANTS
		export
			{NONE}
		end

	KL_SHARED_FILE_SYSTEM
		export
			{NONE} all
		end

	DT_SHARED_SYSTEM_CLOCK
		export
			{NONE} all
		end

	KL_SHARED_STREAMS
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

	make (a_test_suite: like test_suite)
			-- <Precursor>
		do
			Precursor (a_test_suite)
			create source_writer
			create output_stream.make_empty
		end

feature {NONE} -- Access

	status: NATURAL
			-- Current status

	session: AUT_SESSION
			-- Current AutoTest session
		require
			running: is_running
		local
			l_session: like internal_session
		do
			l_session := internal_session
			check l_session /= Void end
			Result := l_session
		end

	internal_session: detachable AUT_SESSION
			-- Internal storage for `session'

	current_results: detachable DS_ARRAYED_LIST [AUT_TEST_CASE_RESULT]
			-- Results printed to new test class

	source_writer: TEST_GENERATED_SOURCE_WRITER
			-- Source writer used for creating test classes

	output_stream: KL_STRING_OUTPUT_STREAM
			-- String stream for storing output

	output_file: detachable KL_TEXT_OUTPUT_FILE
			-- Output file to which output should be written to

	output: detachable OUTPUT_I
			-- Output interface for printing log messages

feature {NONE} -- Access: tasks

	test_task: detachable AUT_STRATEGY
			-- Task running tests through an interpreter

	last_witness: detachable AUT_WITNESS
			-- Last witness derived from `test_task'

	minimize_task: detachable AUT_WITNESS_MINIMIZER
			-- Task for minimizing found witnesses

	statistics_task: detachable AUT_TASK

feature -- Status report

	is_compiling: BOOLEAN
			-- <Precursor>
		do
			Result := status = compile_status_code
		end

	is_executing: BOOLEAN
			-- <Precursor>
		do
			Result := status = execute_status_code
		end

	is_replaying_log: BOOLEAN
			-- <Precursor>
		do
			Result := status = replay_status_code
		end

	is_minimizing_witnesses: BOOLEAN
			-- <Precursor>
		do
			Result := status = minimize_status_code
		end

	is_generating_statistics: BOOLEAN
			-- <Precursor>
		do
			Result := status = statistic_status_code
		end

	is_loading_log: BOOLEAN
			-- Is `Current' loading a log?
		do
		end

--	is_generating_citadel_tests: BOOLEAN
--		do
--			Result := status = citadel_status_code
--		end

feature {TEST_PROCESSOR_SCHEDULER_I} -- Status report

	sleep_time: NATURAL = 0
			-- <Precursor>

feature {NONE} -- Status report

	is_creating_new_class: BOOLEAN
			-- <Precursor>
		do
			Result := current_results /= Void and then not current_results.is_empty
		ensure then
			definition: Result = (current_results /= Void and then not current_Results.is_empty)
		end

feature {NONE} -- Query

	is_valid_typed_configuration (a_arg: like conf_type): BOOLEAN
			-- <Precursor>
		do
			Result := Precursor (a_arg) and then a_arg.is_multiple_new_classes
		end

feature {NONE} -- Basic operations

	start_process_internal (a_conf: like conf_type)
			-- <Precursor>
		local
			l_consumer: SERVICE_CONSUMER [OUTPUT_MANAGER_S]
			l_service: OUTPUT_MANAGER_S
			l_key: UUID
			l_output: detachable OUTPUT_I
		do

				-- TODO: remove gui check once output manager works properly in tty mode (Arno 05/09/09)
			if (create {SHARED_FLAGS}).is_gui then
				create l_consumer
				if l_consumer.is_service_available then
					l_service := l_consumer.service
					l_key := (create {OUTPUT_MANAGER_KINDS}).testing
					if
						l_service.is_interface_usable and then
						l_service.is_valid_registration_key (l_key)
					then
						l_output := l_service.output_or_default (l_key, "Testing Output")
						if l_output.is_interface_usable then
							if not l_output.is_locked then
								l_output.activate
								l_output.lock
								l_output.clear
							end
							output:= l_output
						end
					end
				end
			end
			Precursor (a_conf)
			create internal_session.make (system, configuration)
		end

	proceed_process
			-- <Precursor>
		local
			l_total, l_remaining: INTEGER
			l_totalc, l_remainingc: NATURAL
			l_progress: REAL
			l_cancel: BOOLEAN
			l_witnesses: DS_LIST [AUT_WITNESS]
			l_witness: detachable AUT_WITNESS
			l_minimize_task: like minimize_task
			l_error_handler: AUT_ERROR_HANDLER
			l_itp: AUT_INTERPRETER_PROXY
			l_repo: AUT_TEST_CASE_RESULT_REPOSITORY
			l_last_class: EIFFEL_CLASS_I
			l_project_helper: TEST_PROJECT_HELPER_I
		do
			is_finished := is_stop_requested

			if is_finished then
			else
				if is_compiling then
					prepare
					status := execute_status_code
				else
					if is_executing then
						if attached minimize_task as l_task and then l_task.has_next_step then
							l_task.step
							if not l_task.has_next_step then
								l_witness := l_task.minimized_witness
								if l_witness = Void then
										-- Note: if we were not able to minimize witness, we use it directly to generate a test
									l_witness := l_task.witness
								end
								if l_witness /= Void then
									session.used_witnesses.force_last (l_witness)
									create current_results.make_from_linear (l_witness.classifications)
									l_project_helper := test_suite.eiffel_project_helper
									if l_project_helper.is_class_added then
										l_last_class := l_project_helper.last_added_class
									end
									create_new_class
									if
										l_project_helper.is_class_added and then
										attached l_project_helper.last_added_class as l_new_class and then
										l_last_class /= l_new_class
									then
										session.error_handler.report_test_synthesis (l_new_class)
									end
									current_results := Void
								end
							end
						elseif attached test_task as l_task then
							l_total := session.options.time_out.second_count
							if l_total > 0 then
								update_remaining_time
							end
							l_error_handler := session.error_handler
							if l_task.has_next_step then
								l_progress := {REAL} 1.0
								if l_total > 0 then
									l_remaining := l_error_handler.remaining_time.second_count
									l_progress := l_remaining/l_total
									if l_remaining <= 0 then
										l_cancel := True
									end
								end
								l_totalc := session.options.test_count
								if l_totalc > 0 then
									l_remainingc := l_error_handler.counter
									l_progress := l_progress.min (l_remainingc/l_totalc)
									if l_remainingc = 0 then
										l_cancel := True
									end
								end
								if l_total = 0 and l_totalc = 0 then
									l_progress := {REAL} 0.5
								else
									l_progress := {REAL} 1.0 - l_progress
								end
								internal_progress := {REAL} 0.1 + ({REAL} 0.5)*l_progress
								if l_cancel then
									l_task.cancel
								else
									l_task.step
									if configuration.is_on_the_fly_test_case_generation_enabled then
										l_repo := session.result_repository_builder.result_repository
										l_witnesses := l_repo.witnesses
											-- TODO: it is possible that more than one witness is added per `step', so we need to
											--       check for the last `k' witnesses added (Arno: 05/03/2009)
										if not l_witnesses.is_empty and then l_witnesses.last /= last_witness then
											l_witness := l_witnesses.last
											if l_witness.is_fail then
													-- If no minimization algorithm is provided, we disable test creation.
												if
													session.options.is_minimization_enabled and then
													not session.used_witnesses.there_exists (agent {AUT_WITNESS}.is_same_bug (l_witness))
												then
													l_minimize_task := minimize_task
													if l_minimize_task = Void then
														l_itp := new_interpreter
														if l_itp /= Void then
															create l_minimize_task.make (l_itp, system, l_error_handler)
															minimize_task := l_minimize_task
														end
													end
													if l_minimize_task /= Void then
														l_minimize_task.set_witness (l_witness)
														l_minimize_task.start
													end
												end
											end
											last_witness := l_witness
										end
									end
								end
							else
								status := statistic_status_code
							end
						else
							if configuration.is_random_testing_enabled then
								execute_random_tests
							else
								if configuration.is_load_log_enabled then
									load_log (configuration.log_file_path)
								end
							end
							is_finished := test_task = Void
						end
					elseif is_generating_statistics then
						if attached statistics_task as l_stask then
							if l_stask.has_next_step then
								l_stask.step
							else
								is_finished := True
							end
						else
							if attached {AUT_RANDOM_STRATEGY} test_task as l_task then
								request_stop
								fixme ("Uncomment the following lines to enable statistics generation. I commented out because there is no way to avoid this and it takes a lot of time. Jasonw 2009.7.23")
--								generate_failure_statistics -- Ilinca, "number of faults law" experiment

--								if session.options.is_text_statistics_format_enabled then
--									generate_text_statistics (session.result_repository_builder.result_repository, l_task.classes_under_test)
--								end
--								if session.options.is_html_statistics_format_enabled then
--									generate_html_statistics (session.result_repository_builder.result_repository, l_task.classes_under_test)
--								else
--									is_finished := True
--								end
							end
						end
					else
						check bad: False end
					end
				end
			end

			if is_finished then

			elseif is_replaying_log then
				internal_progress := {REAL} 0.65
			elseif is_minimizing_witnesses then
				internal_progress := {REAL} 0.75
			elseif is_generating_statistics then
				internal_progress := {REAL} 0.85
			end
			flush_output
		end

	stop_process
			-- <Precursor>
		do
			if attached test_task as l_task then
				if l_task.has_next_step then
					l_task.cancel
				end
				test_task := Void
			end
			if attached minimize_task as l_task then
				if l_task.has_next_step then
					l_task.cancel
				end
				minimize_task := Void
			end
			if attached statistics_task as l_task then
				if l_task.has_next_step then
					l_task.cancel
				end
				statistics_task := Void
			end
			last_witness := Void
			internal_session := Void
			status := compile_status_code
			flush_output
			if attached output as l_output and then l_output.is_interface_usable then
				l_output.unlock
				output := Void
			end
			if attached output_file as l_file then
				if l_file.is_closable then
					l_file.close
				end
				output_file := Void
			end
			Precursor
		end

feature {NONE} -- Implementation

	prepare
		local
			l_file_name: FILE_NAME
			l_file: KL_TEXT_OUTPUT_FILE
			l_error_handler: AUT_ERROR_HANDLER
		do
			check_environment_variable
			set_precompile (False)

			l_error_handler := session.error_handler

			create l_file_name.make_from_string (session.output_dirname)
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
			if configuration.is_debugging then
				l_error_handler.set_debug_to_file (output_stream)
			end

			if session.options.should_display_help_message then
				l_error_handler.report_info_message (session.options.help_message)
				is_finished := True
			else
				find_types_under_test
				setup_for_precondition_evaluation
				generate_interpreter

				if is_finished then
					test_suite.propagate_error ("Unable to use workbench executable for interpreter", [], Current)
					is_finished := True
				end
			end
		end

feature {NONE} -- Interpreter generation

	generate_interpreter
			-- Generate interpreter for `a_project' and store result in `interpreter'.		
			-- The generated interpreter classes will be located in auto_test_gen directory in project directoryin EIFGENs
			-- for example EIFGENs/project01/auto_test_gen
		require
			system_compiled: system.workbench /= Void
		local
			--factory: AUT_INTERPRETER_GENERATOR
			interpreter_base_dirname: STRING
			log_dirname: STRING
		do
				-- Setup paths for interpreter generation.
			log_dirname := file_system.pathname (session.output_dirname, "log")

			--create factory.make (a_session)
				-- We generate the skeleton of the interpreter when asked.
				-- Interpreter skeleton only need to be generated once.				
			if not session.options.just_test then
				--factory.generate_interpreter_skeleton (interpreter_base_dirname)
			end

				-- Melt system with interpreter as its new root.			
			compile_project (session.options.class_names)
			if system.eiffel_project.successful then
				system.make_update (False)
				compute_interpreter_root_class
			else
				is_finished := True
			end
		end

	compile_project (a_class_name_list: DS_LIST [STRING_8])
			-- Compile `a_project' with new `a_root_class' and `a_root_feature'.
			--
			-- TODO: `class_names' should be retrieved from `session'
		local
			l_dir: PROJECT_DIRECTORY
			l_file: KL_TEXT_OUTPUT_FILE
			l_file_name: FILE_NAME
			l_source_writer: TEST_INTERPRETER_SOURCE_WRITER
			l_system: SYSTEM_I
		do
			l_system := session.eiffel_system
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
			create l_source_writer.make (configuration)
			if l_file.is_open_write then
				l_source_writer.write_class (l_file, a_class_name_list, l_system)
				l_file.flush
				l_file.close
			end

			if not l_system.is_explicit_root (interpreter_root_class_name, interpreter_root_feature_name) then
				l_system.add_explicit_root (Void, interpreter_root_class_name, interpreter_root_feature_name)
			end
			if test_suite.eiffel_project_helper.can_compile then
				test_suite.eiffel_project_helper.compile
			end
			l_system.remove_explicit_root (interpreter_root_class_name, interpreter_root_feature_name)

				-- Print a root class without any references to avoid compiler errors
--			l_file.recursive_open_write
--			if l_file.is_open_write then
--				l_source_writer.write_class (l_file, create {DS_ARRAYED_LIST [!STRING]}.make (0), l_system)
--				l_file.flush
--				l_file.close
--			end
		end

feature{NONE} -- Test case generation and execution

	execute_random_tests
			-- Execute random tests.
		require
			system_not_empty: system /= Void
		local
			l_cursor: DS_LINEAR_CURSOR [CL_TYPE_A]
			l_strategy: AUT_RANDOM_STRATEGY
			l_itp: like new_interpreter
			l_session: like session
			l_error_handler: AUT_ERROR_HANDLER
		do
			test_task := Void
			l_itp := new_interpreter
			if l_itp /= Void then

				l_session := session
				l_error_handler := l_session.error_handler
				if configuration.is_on_the_fly_test_case_generation_enabled then
					l_itp.add_observer (l_session.result_repository_builder)
				end
				l_itp.set_is_logging_enabled (True)

				create l_strategy.make (l_itp, system, l_session.error_handler)
				l_strategy.add_class_names (session.options.class_names)

				l_error_handler.report_random_testing

				l_error_handler.set_start_time (system_clock.date_time_now)
				l_error_handler.reset_counters (session.options.test_count)
				if l_session.options.time_out.second_count > 0 then
					update_remaining_time
				end

				l_strategy.start
				test_task := l_strategy
			end
		end

	update_remaining_time
			-- Update `error_handler.remaining_time' and mark in the proxy log every elapsed minute.
		require
			running: is_running
			time_out_set: session.options.time_out /= Void
		local
			duration: DT_DATE_TIME_DURATION
			time_left: DT_DATE_TIME_DURATION
			elapsed_minutes: INTEGER
		do
			duration := session.error_handler.duration_to_now

			elapsed_minutes := (duration.second_count / 60).floor
			if elapsed_minutes /= times_duration_logged then
				--interpreter.log_line (time_passed_mark + duration.second_count.out)
				times_duration_logged := times_duration_logged + 1
			end

			time_left := session.options.time_out - duration
			time_left.set_time_canonical
			if time_left.second_count < 0 then
				create time_left.make (0, 0, 0, 0, 0, 0)
			end
			session.error_handler.set_remaining_time (time_left)
		end

feature{NONE} -- Test result analyizing

	replay_log (a_log_file: STRING)
			-- Replay log stored in `a_log_file'.
		require
			running: is_running
		local
			l_replay_strategy: AUT_REQUEST_PLAYER
			l_itp: like new_interpreter
		do
			--interpreter.set_is_in_replay_mode (True)
			test_task := Void
			l_itp := new_interpreter
			if l_itp /= Void then
				create l_replay_strategy.make (l_itp, system, session.error_handler)
				l_replay_strategy.set_request_list (requests_from_file (a_log_file, create {AUT_LOG_PARSER}.make (system, session.error_handler)))
				l_replay_strategy.set_is_interpreter_started_by_default (False)
				l_replay_strategy.start
				test_task := l_replay_strategy
			end
		end

	requests_from_file (a_log_file_name: STRING; a_log_loader: AUT_LOG_PARSER): DS_ARRAYED_LIST [AUT_REQUEST]
			-- Result repository from log file `a_log_file_name' loaded by `a_log_loader'
		require
			a_log_file_name_attached: a_log_file_name /= Void
			a_log_loader_attached: a_log_loader /= Void
		local
			log_stream: KL_TEXT_INPUT_FILE
			l_recorder: AUT_PROXY_EVENT_RECORDER
		do
			create log_stream.make (a_log_file_name)
			log_stream.open_read
			if not log_stream.is_open_read then
				session.error_handler.report_cannot_read_error (a_log_file_name)
				create Result.make (0)
			else
				create l_recorder.make (system)
				a_log_loader.add_observer (l_recorder)
				a_log_loader.parse_stream (log_stream)
				a_log_loader.remove_observer (l_recorder)
				l_recorder.cleanup
				Result := l_recorder.request_history
			end
			log_stream.close
		ensure
			result_attached: Result /= Void
		end

	generate_pre_minimize_statistics (a_result_repository: AUT_TEST_CASE_RESULT_REPOSITORY; a_class_name_list: DS_ARRAYED_LIST [CLASS_C])
			-- Generate statistics about executed tests.
		require
			result_repository_not_void: a_result_repository /= Void
		local
			text_generator: AUT_TEXT_STATISTICS_GENERATOR
		do
			if session.options.is_text_statistics_format_enabled then
				create text_generator.make ("pre_minimization_", file_system.pathname (session.output_dirname, "result"), system, a_class_name_list)
				text_generator.generate (a_result_repository)
				if text_generator.has_fatal_error then
					session.error_handler.report_text_generation_error
				else
					session.error_handler.report_text_generation_finished (text_generator.absolute_index_filename)
				end
			end
		end

	generate_text_statistics (a_result_repository: AUT_TEST_CASE_RESULT_REPOSITORY; a_class_name_list: DS_ARRAYED_LIST [CLASS_C])
		require
			result_repository_not_void: a_result_repository /= Void
		local
			l_generator: AUT_TEXT_STATISTICS_GENERATOR
		do
			create l_generator.make ("", file_system.pathname (session.output_dirname, "result"), system, a_class_name_list)
			l_generator.generate (a_result_repository)
			if l_generator.has_fatal_error then
				session.error_handler.report_text_generation_error
			else
				session.error_handler.report_text_generation_finished (l_generator.absolute_index_filename)
			end
		end

	generate_html_statistics (a_result_repo: AUT_TEST_CASE_RESULT_REPOSITORY; a_class_name_list: DS_ARRAYED_LIST [CLASS_C])
			-- Generate statistics about executed tests.
		require
			result_repository_not_void: a_result_repo /= Void
		local
			l_generator: AUT_HTML_STATISTICS_GENERATOR
		do
			create l_generator.make (file_system.pathname (session.output_dirname, "result"), system, a_class_name_list)
			l_generator.set_repository (a_result_repo)
			l_generator.start
			statistics_task := l_generator
		end

	add_result (a_result: attached AUT_TEST_CASE_RESULT)
		require
			current_results_attached: current_results /= Void
			a_result_fails: a_result.is_fail
		local
			l_item: AUT_TEST_CASE_RESULT
		do
			if current_results.is_empty then
				current_results.force_last (a_result)
			else
				from
					current_results.start
				until
					current_results.after
				loop
					l_item := current_results.item_for_iteration
					if l_item.witness.is_same_bug (a_result.witness) then
						if l_item.witness.count > a_result.witness.count then
							current_results.replace_at (a_result)
						end
						current_results.go_after
					else
						current_results.forth
						if current_results.after then
							current_results.force_last (a_result)
						end
					end
				end
			end
		end

	print_new_class (a_file: attached KL_TEXT_OUTPUT_FILE; a_class_name: attached STRING)
			-- <Precursor>
		local
			l_system: like system
			l_count: NATURAL
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
			end
			source_writer.finish
		ensure then
			results_decreased: current_results.count < old current_results.count
		end

feature {NONE} -- Implementation

	system: SYSTEM_I
			-- System under test
			--
			-- Note: unfortunately the current design does not let us check whether the project is available
		do
			Result := test_suite.eiffel_project.system.system
		end

	times_duration_logged: INTEGER
			-- Number of times that elapsed time has been recorded to proxy file

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
				if attached output as l_output and then l_output.is_interface_usable then
					l_output.formatter.add_string (l_string)
				end
				l_string.wipe_out
			end
		end

feature {NONE} -- Factory

	new_interpreter: detachable AUT_INTERPRETER_PROXY
			-- Create a new interpreter proxy, Void if executable did not exist.
		require
			running: is_running
		local
			l_session: like session
			l_itp_gen: AUT_INTERPRETER_GENERATOR
		do
			l_session := session
			l_itp_gen := l_session.interpreter_generator

			l_itp_gen.create_interpreter (file_system.pathname (session.output_dirname, "log"), configuration)
			Result := l_itp_gen.last_interpreter
			if Result /= Void then
					-- Generate typed object pool for precondition evaluation.
--				if configuration.is_precondition_checking_enabled then
					Result.generate_typed_object_pool
--				end
			end
		end

feature {NONE} -- Constants

	application_name: STRING = "ec"
			-- Name of EiffelStudio exe;
			-- Needed to locate the correct registry keys on windows
			-- in order to find it's install path.

	compile_status_code: NATURAL = 0
	execute_status_code: NATURAL = 1
	replay_status_code: NATURAL = 2
	minimize_status_code: NATURAL = 3
	statistic_status_code: NATURAL = 4

	max_tests_per_class: NATURAL = 9
			-- Maximal number of test routines in a single class

feature -- Precondition satisfaction

	find_types_under_test is
			-- Find types under test and add them into `configuration'.`types_under_test'.
		do
			configuration.set_types_under_test (types_under_test (session.options.class_names, system.root_type.associated_class))
		end

	setup_for_precondition_evaluation is
			-- Setup for precondition evaluation.
		do
			if configuration.is_precondition_checking_enabled then
					-- Get the list of all features under test.
				class_types_under_test.append_last (configuration.types_under_test)
				features_under_test.append_last (testable_features_from_types (class_types_under_test, system))
				setup_feature_id_table

					-- Find out all preconditions.
				find_precondition_predicates

					-- Find out relevant predicates for every feature in `features_under_test'.
				find_relevant_predicates
				build_relevant_predicate_with_operand_table

					-- Setup predicate pool.	
				predicate_pool.setup_predicates (predicates)
			end
		end

	setup_feature_id_table is
			-- Setup `feature_id_table'.
		local
			l_cursor: DS_HASH_SET_CURSOR [AUT_FEATURE_OF_TYPE]
			l_id: INTEGER
		do
			from
				l_cursor := features_under_test.new_cursor
				l_id := 1
				l_cursor.start
			until
				l_cursor.after
			loop
				feature_id_table.force_last (l_id, l_cursor.item.full_name)
				l_id := l_id + 1
				l_cursor.forth
			end
		end

	build_relevant_predicate_with_operand_table is
			-- Build `relevant_predicate_with_operand_table'.
		local
			l_feat_cursor: DS_HASH_TABLE_CURSOR [DS_HASH_TABLE [DS_LINKED_LIST [ARRAY [AUT_FEATURE_SIGNATURE_TYPE]], AUT_PREDICATE], AUT_FEATURE_OF_TYPE]
			l_pred_cursor: DS_HASH_TABLE_CURSOR [DS_LINKED_LIST [ARRAY [AUT_FEATURE_SIGNATURE_TYPE]], AUT_PREDICATE]
			l_predicates: DS_LINKED_LIST [TUPLE [predicate_id: INTEGER; operand_indexes: SPECIAL [INTEGER]]]
			l_index_cursor: DS_LINKED_LIST_CURSOR [ARRAY [AUT_FEATURE_SIGNATURE_TYPE]]
			l_indexes: SPECIAL [INTEGER]
		do
			from
				l_feat_cursor := relevant_predicates_of_feature.new_cursor
				l_feat_cursor.start
			until
				l_feat_cursor.after
			loop
				create l_predicates.make
				from
					l_pred_cursor := l_feat_cursor.item.new_cursor
					l_pred_cursor.start
				until
					l_pred_cursor.after
				loop
					from
						l_index_cursor := l_pred_cursor.item.new_cursor
						l_index_cursor.start
					until
						l_index_cursor.after
					loop
						create l_indexes.make (l_index_cursor.item.count)
						l_index_cursor.item.do_all_with_index (
							agent (a_pos: AUT_FEATURE_SIGNATURE_TYPE; a_index: INTEGER; a_ops: SPECIAL [INTEGER])
								do
									a_ops.put (a_pos.position, a_index - 1)
								end (?, ?, l_indexes))

						l_index_cursor.forth
					end
					l_predicates.force_last ([l_pred_cursor.key.id, l_indexes])
					l_pred_cursor.forth
				end
				if not l_predicates.is_empty then
					relevant_predicate_with_operand_table.force_last (l_predicates.to_array, l_feat_cursor.key.id)
				end
				l_feat_cursor.forth
			end
		end

	find_precondition_predicates is
			-- Find precondition predicates from `features_under_test',
			-- store those predicates into `predicates', and store
			-- the access patterns of those predicates into
			-- `precondition_access_pattern'.
		local
			l_visitor: AUT_PRECONDITION_ANALYZER
			l_features: like features_under_test
			l_feature: AUT_FEATURE_OF_TYPE
		do
			l_features := features_under_test
			from
				l_features.start
			until
				l_features.after
			loop
					-- Get preconditions from `l_feature'.
				l_feature := l_features.item_for_iteration
				create l_visitor.make
				l_visitor.generate_precondition_predicates (l_feature)

					-- Store predicates and their access patterns.
				if not l_visitor.last_predicates.is_empty then
					l_visitor.last_predicates.do_if (agent put_predicate, agent (a_pred: AUT_PREDICATE): BOOLEAN do Result := not predicates.has (a_pred) end (?))
					put_precondition_access_pattern (l_feature, l_visitor.last_predicate_access_patterns)
					put_precondition_of_feature (l_feature, l_visitor.last_predicates)
					l_visitor.last_predicates.do_all (agent put_predicate_in_feature_table (?, l_feature))
				end
				l_features.forth
			end
		end

	find_relevant_predicates is
			-- For each feature in `features_under_test',
			-- find relevant predicates that needs to be reevalated
			-- every time when that feature is executed.
		local
			l_features: like features_under_test
			l_feature: AUT_FEATURE_OF_TYPE
			l_arranger: AUT_PREDICATE_ARGUMENT_ARRANGER
			l_predicates: like predicates
			l_relevant: DS_HASH_TABLE [DS_LINKED_LIST [ARRAY [AUT_FEATURE_SIGNATURE_TYPE]], AUT_PREDICATE]
			l_arrangements: DS_LINKED_LIST [ARRAY [AUT_FEATURE_SIGNATURE_TYPE]]
			l_predicate_cursor: DS_HASH_SET_CURSOR [AUT_PREDICATE]
		do
			l_features := features_under_test
			l_predicates := predicates
			from
				l_features.start
			until
				l_features.after
			loop
				l_feature := l_features.item_for_iteration
				create l_relevant.make (10)
				l_relevant.set_key_equality_tester (predicate_equality_tester)
				relevant_predicates_of_feature.force_last (l_relevant, l_feature)
				from
					l_predicate_cursor := l_predicates.new_cursor
					l_predicate_cursor.start
				until
					l_predicate_cursor.after
				loop
					create l_arranger.make (l_predicate_cursor.item, system)
					l_arrangements := l_arranger.arrangements_for_feature (l_feature)
					if not l_arrangements.is_empty then
						l_relevant.force_last (l_arrangements, l_predicate_cursor.item)
					end
					l_predicate_cursor.forth
				end
				l_features.forth
			end
		end

	types_under_test (a_list: detachable DS_LIST [STRING_8]; a_context: CLASS_C): DS_LINKED_LIST [CL_TYPE_A]
			-- Types under test from class names in `a_list'.
			-- classes_under_test with list of class names.
			--
			-- `a_list': List of class/type names, can be void or empty to indicate that all classes in the
			--           system should be tested.
		local
			l_tester: KL_STRING_EQUALITY_TESTER_A [STRING_8]
			l_class_set: DS_HASH_SET [CLASS_I]
			l_class_cur: DS_HASH_SET_CURSOR [CLASS_I]
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
					l_class_cur := l_class_set.new_cursor
					l_class_cur.start
				until
					l_class_cur.after
				loop
					l_name := l_class_cur.item.name
					check
						l_name /= Void
					end
					l_class_name_set.force_last (l_name)
					l_class_cur.forth
				end
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

feature -- Log processor

	load_log (a_log_file: STRING)
			-- Load log in `a_log_file'.
		local
			l_processor_name: detachable STRING
			l_processor: AUT_LOG_PROCESSOR
		do
			l_processor_name := configuration.log_processor
			if l_processor_name /= Void then
				 l_processor_name.to_lower
				 if log_processors.has (l_processor_name) then
					l_processor := log_processors.item (l_processor_name)
					l_processor.set_configuration (configuration)
					l_processor.process
				 end
			end
		end

	log_processors: HASH_TABLE [AUT_LOG_PROCESSOR, STRING]
			-- Table of registered log processors
			-- [Log processor, name of the processor]
		do
			if log_processors_internal = Void then
				create log_processors_internal.make (5)
				log_processors_internal.compare_objects
				log_processors_internal.extend (create{AUT_RESULT_ANALYZER}.make (system, configuration, session), "ps")
				log_processors_internal.extend (create{AUT_OBJECT_STATE_LOG_PROCESSOR}.make (system, configuration, session), "state")
			end
			Result := log_processors_internal
		end

	log_processors_internal: like log_processors
			-- Implementation of `log_processors'

feature -- CITADEL related

	generate_citadel_tests
			-- Generate tests for CITADEL from an existing proxy log file.
		local
--			l_gen: AUT_CITADEL_TEST_GENERATOR
		do
--			create l_gen.make (result_repository, interpreter, error_handler, system, output_dirname)
--			l_gen.generate_tests (class_names)
		end

feature -- Repository generation

	build_failure_only_result_repository
			-- Build result repository from failure log file.
			-- Ilinca, "number of faults law" experiment
--		local
--			log_stream: KL_TEXT_INPUT_FILE
--			builder: AUT_RESULT_REPOSITORY_BUILDER
		do
--			create result_repository.make
--			create log_stream.make (log_file_path)
--			log_stream.open_read
--			if not log_stream.is_open_read then
--				error_handler.report_cannot_read_error (log_file_path)
--			else
--				create builder.make  (system, error_handler)
--				builder.build (log_stream)
--				result_repository := builder.last_result_repository
--				log_stream.close
--			end
--		ensure
--			result_repository_not_void: result_repository /= Void
		end

	build_citadel_result_repository
			-- Build result repository from log file.
--		local
--			log_stream: KL_TEXT_INPUT_FILE
--			builder: AUT_CITADEL_RESULT_REPOSITORY_BUILDER
		do
--			create result_repository.make
--			create log_stream.make (log_file_path)
--			log_stream.open_read
--			if not log_stream.is_open_read then
--				error_handler.report_cannot_read_error (log_file_path)
--			else
--				create builder.make  (system, error_handler)
--				builder.build (log_stream)
--				result_repository := builder.last_result_repository
--				log_stream.close
--			end
--		ensure
--			result_repository_not_void: result_repository /= Void
		end

	generate_failure_statistics
--		require
--			result_repository_not_void: result_repository /= Void
--		local
--			l_generator: AUT_FAILURE_STATISTICS_GENERATOR
		do
--			create l_generator.make ("", file_system.pathname (output_dirname, "result"), system, classes_under_test)
--			l_generator.generate (result_repository)
--			if l_generator.has_fatal_error then
--				error_handler.report_text_generation_error
--			else
--				error_handler.report_text_generation_finished (l_generator.absolute_index_filename)
--			end
		end

invariant
	not_running_implies_status_compiling: not is_running implies (status = compile_status_code)
	running_implies_session_attached: is_running implies session /= Void
	output_valid: (attached output as l_output and then l_output.is_interface_usable) implies l_output.is_locked

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
