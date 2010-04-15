note
	description: "[
		TTY menu for launching AutoTest.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EWB_AUTO_TEST

inherit
	EWB_TEST_CMD
		redefine
			check_arguments_and_execute,
			on_processor_proceeded
		end

create
	default_create,
	make_with_arguments

feature {NONE} -- Initialization

	make_with_arguments (a_arguments: LINKED_LIST [STRING])
			-- Initialize `auto_test_arguments' with `a_arguments'.
		require
			a_arguments_attached: a_arguments /= Void
		do
			create {DS_LINKED_LIST [STRING]} auto_test_arguments.make
			a_arguments.do_all (agent auto_test_arguments.force_last)
		ensure
			auto_test_arguments_set: auto_test_arguments /= Void and then auto_test_arguments.count = a_arguments.count
		end

feature {NONE} -- Access

	current_state: NATURAL_8
			-- Last state

	compiling_state: NATURAL_8 = 1
	executing_state: NATURAL_8 = 2
	replaying_state: NATURAL_8 = 3
	minimizing_state: NATURAL_8 = 4
	generating_state: NATURAL_8 = 5

feature -- Properties

	name: STRING
		do
			Result := "AutoTest"
		end

	help_message: STRING_GENERAL
		do
			Result := "AutoTest"
		end

	abbreviation: CHARACTER
		do
			Result := 'a'
		end

feature -- Execution

	execute_with_test_suite (a_test_suite: attached TEST_SUITE_S)
			-- Action performed when invoked from the
			-- command line.
		local
			l_ap: AUTO_TEST_COMMAND_LINE_PARSER
			l_args: like auto_test_arguments
			l_error_handler: AUT_ERROR_HANDLER

				-- Using wizard information to create AutoTest configuration
			l_shared_prefs: EC_SHARED_PREFERENCES
			l_prefs: TEST_PREFERENCES
			l_conf: TEST_GENERATOR_CONF
			l_type: STRING
			l_root_group: CONF_GROUP
			l_project: E_PROJECT
--			l_profiler: PROFILING_SETTING
		do
--			create l_profiler.make
--			l_profiler.start_profiling
			l_args := auto_test_arguments
			if l_args /= Void then
				l_project := a_test_suite.eiffel_project
				create l_error_handler.make (l_project.system.system)
				create l_ap.make_with_arguments (l_args, l_error_handler)
				--l_ap.process_arguments (l_args)

				create l_shared_prefs
				l_prefs := l_shared_prefs.preferences.testing_tool_data
				create l_conf.make (l_prefs)

					-- Types
				from
					l_ap.class_names.start
				until
					l_ap.class_names.after
				loop
					l_type := l_ap.class_names.item_for_iteration
					if l_type /= Void then
						l_conf.types_cache.force (l_type)
					end
					l_ap.class_names.forth
				end

					-- Timing
				if l_ap.time_out /= Void then
					l_conf.set_time_out ((l_ap.time_out.second_count // 60).as_natural_32)
				end
				l_conf.set_test_count (l_ap.test_count)
				if l_ap.proxy_time_out > 0 then
					l_conf.set_proxy_time_out (l_ap.proxy_time_out.to_natural_32)
				end

					-- Minimization
				l_conf.set_slicing_enabled (l_ap.is_slicing_enabled)
				l_conf.set_ddmin_enabled (l_ap.is_ddmin_enabled)

					-- Output
				l_conf.set_html_output (l_ap.is_html_statistics_format_enabled)
				l_root_group := l_project.system.system.root_creators.first.cluster

					-- Log file loading
				l_conf.set_load_file_path (l_ap.log_file_path)

					-- Object state retrieval config
				l_conf.set_object_state_config (l_ap.object_state_config)

					-- Should automatic testing be enabled?
				l_conf.set_is_random_testing_enabled (l_ap.is_automatic_testing_enabled)

					-- Should precondition checking be enabled?
				l_conf.set_is_precondition_evaluation_enabled (l_ap.is_precondition_checking_enabled)

					-- Should linear constraint solving be enabled?
				l_conf.set_is_linear_solving_enabled (l_ap.is_linear_constraint_solving_enabled)

					-- Should object state exploration be enabled?
				l_conf.set_is_object_state_exploration_enabled (l_ap.is_object_state_exploration_enabled)

					-- Set log processor.
				l_conf.set_log_processor (l_ap.log_processor)
				l_conf.set_log_processor_output (l_ap.log_processor_output)

					-- Set max tries for precondition search.
				l_conf.set_max_precondition_search_tries (l_ap.max_precondition_search_tries)

					-- Set max time for precondition search.
				l_conf.set_max_precondition_search_time (l_ap.max_precondition_search_time)

					-- Set seed.
				if l_ap.is_seed_provided then
					l_conf.set_seed (l_ap.seed.as_natural_32)
				end

					-- Should AutoTest generate tests for CITADEL from the given proxy log?
				l_conf.set_is_citadel_test_generation_enabled (l_ap.prepare_citadel_tests)

					-- Ilinca, "number of faults law" experiment
				if l_ap.random.seed >= 0 then
					l_conf.set_seed (l_ap.random.seed.to_natural_32)
				else
					l_conf.set_seed ((-l_ap.random.seed).to_natural_32)
				end

					-- Set max candidates count for precondition evaluation
				l_conf.set_max_candidate_count (l_ap.max_candidate_count)

					-- Should statistics of object pool and predicate pool be logged?
				l_conf.set_is_pool_statistics_logged (l_ap.is_pool_statistics_logged)

					-- Set linear constraint solver to be used.
				l_conf.set_is_smt_linear_constraint_solver_enabled (l_ap.is_smt_linear_constraint_solver_enabled)
				l_conf.set_is_lpsolve_linear_constraint_solver_enabled (l_ap.is_lpsolve_contraint_linear_solver_enabled)

					-- Set smart object selection rate
				l_conf.set_object_selection_for_precondition_satisfaction_rate (l_ap.object_selection_for_precondition_satisfaction_rate)

				l_conf.set_smt_enforce_old_value_rate (l_ap.smt_enforce_old_value_rate)
				l_conf.set_smt_use_predefined_value_rate (l_ap.smt_use_predefined_value_rate)

					-- Set lower/upper bound for linearly solvable arguments.
				l_conf.set_integer_lower_bound (l_ap.integer_lower_bound)
				l_conf.set_integer_upper_bound (l_ap.integer_upper_bound)

				l_conf.set_is_random_cursor_used (l_ap.is_random_cursor_used)

					-- Set test case serialization arguments.
				l_conf.set_is_passing_test_case_serialization_enabled (l_ap.is_passing_test_cases_serialization_enabled)
				l_conf.set_is_failing_test_case_serialization_enabled (l_ap.is_failing_test_cases_serialization_enabled)

				l_conf.set_is_interpreter_log_enabled (l_ap.is_interpreter_log_enabled)
				l_conf.set_is_console_output_enabled (l_ap.is_console_log_enabled)

				l_conf.set_is_on_the_fly_test_case_generation_enabled (l_ap.is_on_the_fly_test_case_generation_enabled)

				l_conf.set_proxy_log_options (l_ap.proxy_log_options)

				l_conf.set_is_duplicated_test_case_serialized (l_ap.is_duplicated_test_case_serialized)

				if l_root_group.is_cluster then
					if attached {CONF_CLUSTER} l_root_group as l_cluster then
						l_conf.set_cluster (l_cluster)
						l_conf.set_path ("")
					end
				end
				l_conf.set_new_class_name("NEW_AUTO_TEST")
				l_conf.set_debugging (l_ap.is_debugging)
				launch_ewb_processor (a_test_suite, generator_factory_type, l_conf)
			else

			end
--			l_profiler.stop_profiling
		end

	auto_test_arguments: detachable DS_LIST [STRING]
			-- Arguments for AutoTest

	check_arguments_and_execute
			-- Check the arguments and then perform then
			-- command line action.
		local
			i: INTEGER
			l_args: DS_LINKED_LIST [STRING]
		do
				-- Retrieve all arguments for AutoTest.
			create l_args.make
			from
				i := 2
			until
				i > command_line_io.command_arguments.count
			loop
				if command_line_io.command_arguments.item (i) /= Void then
					l_args.force_last (command_line_io.command_arguments.item (i))
				end
				i := i + 1
			end

			auto_test_arguments := l_args

			if not command_line_io.abort then
				if Workbench.is_already_compiled then
					execute
				else
					output_window.put_string (Warning_messages.w_Must_compile_first)
					output_window.put_new_line
				end
			else
				command_line_io.reset_abort
			end
			auto_test_arguments := Void
		ensure then
		--	auto_test_arguments_attached: auto_test_arguments /= Void
		end

feature {NONE} -- Events

	on_processor_proceeded (a_test_suite: attached TEST_SUITE_S; a_processor: attached TEST_PROCESSOR_I)
			-- <Precursor>
		local
			l_generator: detachable TEST_GENERATOR_I
		do
			l_generator := generator_factory_type.attempt (a_processor)
			if l_generator /= Void then

				if l_generator.is_running then
					if l_generator.is_compiling then
						if current_state /= compiling_state then
							print_string ("Compiling%N")
							current_state := compiling_state
						end
					elseif l_generator.is_executing then
						if current_state /= executing_state then
							print_string ("Executing random tests%N")
							current_state := executing_state
						end
					elseif l_generator.is_replaying_log then
						if current_state /= replaying_state then
							print_string ("Replaying log%N")
							current_state := replaying_state
						end
					elseif l_generator.is_minimizing_witnesses then
						if current_state /= minimizing_state then
							print_string ("Minimizing witnesses%N")
							current_state := minimizing_state
						end
					elseif l_generator.is_generating_statistics then
						if current_state /= generating_state then
							print_string ("Generating statistics%N")
							current_state := generating_state
						end
					end
				end
			end
		end

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
