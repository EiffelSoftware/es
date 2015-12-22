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

	make_with_arguments (a_arguments: LINKED_LIST [READABLE_STRING_32])
			-- Initialize `auto_test_arguments' with `a_arguments'.
		require
			a_arguments_attached: a_arguments /= Void
		do
			create {DS_LINKED_LIST [STRING_32]} auto_test_arguments.make
			across a_arguments as ac loop auto_test_arguments.force_last (ac.item) end
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
			l_generator: TEST_GENERATOR_WRAPPER
				-- Use a wrapper class in batch mode to enable interpreter class generation before testing.
				-- This is needed to support research ideas such as precondition-satisfaction.
				-- Ideally, we should be able to enable all research ideas in both GUI and batch mode. 15.10.2010 Jasonw
			l_type, l_types: STRING
			l_root_group: CONF_GROUP
			l_project: E_PROJECT
			l_exceptions: EXCEPTIONS

			l_feature_contract_remover: AUT_FEATURE_CONTRACT_REMOVER
			l_names: LIST [STRING_8]

		do
			l_args := auto_test_arguments
			if l_args /= Void then
				l_project := etest_suite.project_access.project
				create l_error_handler.make (l_project.system.system)
				create l_ap.make_with_arguments (l_args, l_error_handler)
				--l_ap.process_arguments (l_args)

				if l_ap.should_display_help_message then
					io.put_string (l_ap.help_message)
						-- Exit after displaying help message.
					create l_exceptions
					l_exceptions.die (0)
				end

				create l_generator.make (a_test_suite, etest_suite, False)
				l_generator.log_start_time ("Test preparation started")
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
					l_types.append (l_type)
					l_ap.class_names.forth
				end

				create l_session
				if attached l_session.service as l_manager then
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

						-- Should agent features be tested?
				l_generator.set_is_executing_agent_features_enabled (l_ap.is_executing_agent_features_enabled)

						-- Should normal features be tested?
				l_generator.set_is_executing_normal_features_enabled (l_ap.is_executing_normal_features_enabled)

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
				l_generator.set_test_case_serialization_file (l_ap.test_case_serialization_file)
				l_generator.set_is_test_case_serialization_retrieved_online (l_ap.is_test_case_serialization_retrieved_online)
				l_generator.set_output_dir_for_test_case_online (l_ap.output_dir_for_test_case_online)
				l_generator.set_output_test_case_online_filter (l_ap.output_test_case_online_filter)
				l_generator.set_clear_online_test_case_dir (l_ap.should_clear_online_test_case_dir)

					-- Set test case deserialization arguments.
				l_generator.set_is_passing_test_case_deserialization_enabled (l_ap.is_passing_test_cases_deserialization_enabled)
				l_generator.set_is_failing_test_case_deserialization_enabled (l_ap.is_failing_test_cases_deserialization_enabled)

					-- Use STRING_8 internally
				l_generator.set_features_under_test_to_deserialize (create {EPA_STRING_HASH_SET}.make_equal(l_ap.features_under_test_to_deserialize.count))
				from l_ap.features_under_test_to_deserialize.start
				until l_ap.features_under_test_to_deserialize.after
				loop
					l_generator.features_under_test_to_deserialize.force (l_ap.features_under_test_to_deserialize.item_for_iteration.out)
					l_ap.features_under_test_to_deserialize.forth
				end

				l_generator.set_building_behavioral_models (l_ap.is_building_behavioral_model)
				l_generator.set_model_directory (l_ap.model_dir)
				l_generator.set_building_faulty_feature_list (l_ap.is_building_faulty_feature_list)
				l_generator.set_faulty_feature_list_file_name (l_ap.faulty_feature_list_file_name)
				l_generator.set_deserialization_for_fixing (l_ap.is_deserializing_for_fixing)
				l_generator.set_serialization_validity_log (l_ap.serialization_validity_log)

				l_generator.set_recursive (l_ap.is_recursive)
				l_generator.set_feature_to_disable_contracts (l_ap.disable_feature_contracts)

				l_generator.set_data_input (l_ap.data_input)
				l_generator.set_data_output (l_ap.data_output)

				l_generator.set_is_interpreter_log_enabled (l_ap.is_interpreter_log_enabled)
				l_generator.set_is_console_output_enabled (l_ap.is_console_log_enabled)

					-- Use STRING_8 internally
				l_generator.set_proxy_log_options (create {HASH_TABLE [BOOLEAN, STRING]}.make_equal (l_ap.log_types.count))
				from l_ap.log_types.start
				until l_ap.log_types.after
				loop
					l_generator.proxy_log_options.put (l_ap.log_types.item_for_iteration, l_ap.log_types.key_for_iteration)
					l_ap.log_types.forth
				end
					-- l_generator.set_proxy_log_options (l_ap.log_types)

				l_generator.set_is_duplicated_test_case_serialized (l_ap.is_duplicated_test_case_serialized)

				l_generator.set_is_post_state_serialized (l_ap.is_post_state_serialized)

					-- Use STRING_8 internally
				from l_ap.excluded_features.start
				until l_ap.excluded_features.after
				loop
					l_generator.excluded_features.force ([l_ap.excluded_features.item_for_iteration.class_name.out, l_ap.excluded_features.item_for_iteration.feature_name.out])
					l_ap.excluded_features.forth
				end
					-- l_generator.excluded_features.append (l_ap.excluded_features)

					-- Use STRING_8 internally
				from l_ap.popular_features.start
				until l_ap.popular_features.after
				loop
					l_generator.popular_features.force ([l_ap.popular_features.item_for_iteration.class_name.out, l_ap.popular_features.item_for_iteration.feature_name.out, l_ap.popular_features.item_for_iteration.level])
					l_ap.popular_features.forth
				end
				-- l_generator.popular_features.append (l_ap.popular_features)

				l_generator.set_collecting_interface_related_classes (l_ap.is_collecting_interface_related_classes)
				l_generator.set_should_freeze_before_testing (l_ap.should_freeze_before_testing)

					-- Setup for precondition reduction strategy.
				l_generator.set_is_precondition_reduction_enabled (l_ap.is_precondition_reduction_enabled)
				l_generator.set_semantic_database_config (l_ap.semantic_data_base_config)
				l_generator.set_prestate_invariant_path (l_ap.precondition_reduction_file)
				l_generator.set_should_check_invariant_violating_objects (l_ap.should_check_invariant_violating_objects)
				l_generator.set_arff_directory (l_ap.arff_directory)
				l_generator.set_online_statistics_frequency (l_ap.online_statistics_frequency)

				if l_generator.feature_to_disable_contracts /= Void then
					create l_feature_contract_remover
					l_names := l_generator.feature_to_disable_contracts.split ('.')
					l_feature_contract_remover.remove_contracts_by_name (l_names [1], l_names [2])
					Io.put_string ("Contracts removed from feature: " + l_generator.feature_to_disable_contracts)
					Io.put_new_line
				end

				a_test_suite.launch_session (l_generator)

				if l_feature_contract_remover /= Void then
					l_feature_contract_remover.recover_previous_contracts
				end
			else

			end
		end

	auto_test_arguments: detachable DS_LIST [STRING_32]
			-- Arguments for AutoTest

	check_arguments_and_execute
			-- Check the arguments and then perform then
			-- command line action.
		local
			i: INTEGER
			l_args: DS_LINKED_LIST [STRING_32]
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
	copyright: "Copyright (c) 1984-2015, Eiffel Software"
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
