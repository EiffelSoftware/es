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
			check_arguments_and_execute
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

	execute_with_test_suite (a_test_suite: TEST_SUITE_S)
			-- Action performed when invoked from the
			-- command line.
		local
			l_ap: AUTO_TEST_COMMAND_LINE_PARSER
			l_args: like auto_test_arguments
			l_error_handler: AUT_ERROR_HANDLER

				-- Using wizard information to create AutoTest configuration
			l_session: SERVICE_CONSUMER [SESSION_MANAGER_S]
			l_manager: SESSION_MANAGER_S
			l_generator: TEST_GENERATOR_WRAPPER
				-- Use a wrapper class in batch mode to enable interpreter class generation before testing.
				-- This is needed to support research ideas such as precondition-satisfaction.
				-- Ideally, we should be able to enable all research ideas in both GUI and batch mode. 15.10.2010 Jasonw
			l_type, l_types: STRING
			l_root_group: CONF_GROUP
			l_project: E_PROJECT
		do
			l_args := auto_test_arguments
			if l_args /= Void then
				l_project := etest_suite.project_access.project
				create l_error_handler.make (l_project.system.system)
				create l_ap.make_with_arguments (l_args, l_error_handler)
				--l_ap.process_arguments (l_args)

				create l_generator.make (a_test_suite, etest_suite)
				l_error_handler.set_configuration (l_generator)

					-- Types
				create l_types.make (200)
				from
					l_ap.class_names.start
				until
					l_ap.class_names.after
				loop
					l_type := l_ap.class_names.item_for_iteration
					l_generator.add_class_name (l_type)
					if not l_types.is_empty then
						l_types.append_character (',')
					end
					l_types.append (l_types)
					l_ap.class_names.forth
				end

				create l_session
				if l_session.is_service_available then
					l_manager := l_session.service
					l_manager.retrieve (True).set_value (l_types, {TEST_SESSION_CONSTANTS}.temporary_types)
					launch_test_generation (l_generator, l_manager, True)
				end

					-- Timing
				if l_ap.time_out /= Void then
					l_generator.set_time_out ((l_ap.time_out.second_count // 60).as_natural_32)
				end
				l_generator.set_test_count (l_ap.test_count)
				if l_ap.proxy_time_out > 0 then
					l_generator.set_proxy_timeout (l_ap.proxy_time_out.to_natural_32)
				end

					-- Minimization
				l_generator.set_is_slicing_enabled (l_ap.is_slicing_enabled)
				l_generator.set_is_ddmin_enabled (l_ap.is_ddmin_enabled)

					-- Output
				l_generator.set_html_statistics (l_ap.is_html_statistics_format_enabled)
				l_generator.set_text_statistics (l_ap.is_text_statistics_format_enabled)
				l_root_group := l_project.system.system.root_creators.first.cluster

				if l_root_group.is_cluster then
					if attached {CONF_CLUSTER} l_root_group as l_cluster then
						l_generator.set_cluster_name (l_cluster.name)
						l_generator.set_path_name ("")
					end
				end
				l_generator.set_class_name ("NEW_AUTO_TEST")
				l_generator.set_debugging (l_ap.is_debugging)

					-- Log file loading
				l_generator.set_load_file_path (l_ap.log_file_path)

					-- Object state retrieval config
				l_generator.set_object_state_config (l_ap.object_state_config)

					-- Should automatic testing be enabled?
				l_generator.set_is_random_testing_enabled (l_ap.is_automatic_testing_enabled)

				        -- Should evolutionary algorithm be used?
				l_generator.set_is_evolutionary_testing_enabled (l_ap.is_evolutionary_enabled)

					-- Should precondition checking be enabled?
				l_generator.set_is_precondition_evaluation_enabled (l_ap.is_precondition_checking_enabled)

					-- Should linear constraint solving be enabled?
				l_generator.set_is_linear_solving_enabled (l_ap.is_smt_linear_constraint_solver_enabled or l_ap.is_lpsolve_contraint_linear_solver_enabled)

					-- Should object state exploration be enabled?
				l_generator.set_is_object_state_exploration_enabled (l_ap.is_object_state_exploration_enabled)

					-- Set log processor.
				l_generator.set_log_processor (l_ap.log_processor)
				l_generator.set_log_processor_output (l_ap.log_processor_output)

					-- Set max tries for precondition search.
				l_generator.set_max_precondition_search_tries (l_ap.max_precondition_search_tries)

					-- Set max time for precondition search.
				l_generator.set_max_precondition_search_time (l_ap.max_precondition_search_time)

					-- Set seed.
				if l_ap.is_seed_provided then
					l_generator.set_seed (l_ap.seed.as_natural_32)
				end

					-- Set max candidates count for precondition evaluation
				l_generator.set_max_candidate_count (l_ap.max_candidate_count)

					-- Set linear constraint solver to be used.
				l_generator.set_is_smt_linear_constraint_solver_enabled (l_ap.is_smt_linear_constraint_solver_enabled)
				l_generator.set_is_lpsolve_linear_constraint_solver_enabled (l_ap.is_lpsolve_contraint_linear_solver_enabled)

					-- Set smart object selection rate
				l_generator.set_object_selection_for_precondition_satisfaction_rate (l_ap.object_selection_for_precondition_satisfaction_rate)

				l_generator.set_smt_enforce_old_value_rate (l_ap.smt_enforce_old_value_rate)
				l_generator.set_smt_use_predefined_value_rate (l_ap.smt_use_predefined_value_rate)

					-- Set lower/upper bound for linearly solvable arguments.
				l_generator.set_integer_lower_bound (l_ap.integer_lower_bound)
				l_generator.set_integer_upper_bound (l_ap.integer_upper_bound)

				l_generator.set_is_random_cursor_used (l_ap.is_random_cursor_used)

					-- Set test case serialization arguments.
				l_generator.set_is_passing_test_case_serialization_enabled (l_ap.is_passing_test_cases_serialization_enabled)
				l_generator.set_is_failing_test_case_serialization_enabled (l_ap.is_failing_test_cases_serialization_enabled)

					-- Set test case deserialization arguments.
				l_generator.set_is_passing_test_case_deserialization_enabled (l_ap.is_passing_test_cases_deserialization_enabled)
				l_generator.set_is_failing_test_case_deserialization_enabled (l_ap.is_failing_test_cases_deserialization_enabled)

				l_generator.set_recursive (l_ap.is_recursive)

				l_generator.set_data_input (l_ap.data_input)
				l_generator.set_data_output (l_ap.data_output)

				l_generator.set_is_interpreter_log_enabled (l_ap.is_interpreter_log_enabled)
				l_generator.set_is_console_output_enabled (l_ap.is_console_log_enabled)

				l_generator.set_proxy_log_options (l_ap.log_types)

				l_generator.set_is_duplicated_test_case_serialized (l_ap.is_duplicated_test_case_serialized)

				l_generator.set_is_post_state_serialized (l_ap.is_post_state_serialized)

				l_generator.excluded_features.append (l_ap.excluded_features)
				l_generator.popular_features.append (l_ap.popular_features)

				l_generator.set_collecting_interface_related_classes (l_ap.is_collecting_interface_related_classes)

				a_test_suite.launch_session (l_generator)
			else

			end
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
