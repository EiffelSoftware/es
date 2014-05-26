note
	description: "Instance of AutoTest"
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_AUTOTEST_INSTANCE

inherit

	EBB_TOOL_INSTANCE

	SHARED_TEST_SERVICE
		export {NONE} all end

	AUT_SHARED_ONLINE_STATISTICS

	EBB_SHARED_BLACKBOARD

create
	make

feature -- Status report

	is_running: BOOLEAN
			-- <Precursor>
		do
			if attached test_generator then
				Result := test_generator.has_next_step
			end
		end

feature -- Basic operations

	start
			-- <Precursor>
		local
			l_session: SERVICE_CONSUMER [SESSION_MANAGER_S]
			l_test_suite: TEST_SUITE_S
			l_error_handler: EBB_AUT_ERROR_HANDLER
			l_log_options: HASH_TABLE [BOOLEAN, STRING]
			l_project: E_PROJECT
		do
			online_statistics.passing_statistics.wipe_out
			online_statistics.failing_statistics.wipe_out
			online_statistics.faults.wipe_out

			l_project := etest_suite.project_access.project
			create l_error_handler.make (l_project.system.system)

			create test_generator.make (Current, test_suite.service, etest_suite)
			test_generator.log_start_time ("EBB Autotest Start")
			l_error_handler.set_configuration (test_generator)

				-- Add classes to test
			test_generator.add_class_name (input.classes.first.name_in_upper)


				-- Timing
			test_generator.set_time_out_in_seconds (15)

			test_generator.set_test_count (0)

				-- Minimization
			test_generator.set_is_slicing_enabled (False)
			test_generator.set_is_ddmin_enabled (False)

				-- Output
			test_generator.set_html_statistics (True)
			test_generator.set_text_statistics (True)

--			l_root_group := l_project.system.system.root_creators.first.cluster

--			if l_root_group.is_cluster then
--				if attached {CONF_CLUSTER} l_root_group as l_cluster then
--					l_generator.set_cluster_name (l_cluster.name)
--					l_generator.set_path_name ("")
--				end
--			end
			test_generator.set_class_name ("NEW_AUTO_TEST")
			test_generator.set_debugging (False)

				-- Log file loading
--			l_generator.set_load_file_path (l_ap.log_file_path)

				-- Object state retrieval config
			test_generator.set_object_state_config (create {AUT_OBJECT_STATE_CONFIG}.make_with_string ("argumentless"))

				-- Should automatic testing be enabled?
			test_generator.set_is_random_testing_enabled (True)

				-- Should evolutionary algorithm be used?
			test_generator.set_is_evolutionary_testing_enabled (False)

					-- Should agent features be tested?
			test_generator.set_is_executing_agent_features_enabled (False)

					-- Should normal features be tested?
			test_generator.set_is_executing_normal_features_enabled (True)

				-- Should precondition checking be enabled?
			test_generator.set_is_precondition_evaluation_enabled (False)

				-- Should linear constraint solving be enabled?
			test_generator.set_is_linear_solving_enabled (False)

				-- Should object state exploration be enabled?
			test_generator.set_is_object_state_exploration_enabled (False)

				-- Set log processor.
			test_generator.set_log_processor (Void)
			test_generator.set_log_processor_output (Void)

				-- Set max tries for precondition search.
			test_generator.set_max_precondition_search_tries (0)

				-- Set max time for precondition search.
			test_generator.set_max_precondition_search_time (0)

				-- Set seed.
			if False then
				test_generator.set_seed (1)
			end

				-- Set max candidates count for precondition evaluation
			test_generator.set_max_candidate_count (1)

				-- Set linear constraint solver to be used.
			test_generator.set_is_smt_linear_constraint_solver_enabled (False)
			test_generator.set_is_lpsolve_linear_constraint_solver_enabled (False)

				-- Set smart object selection rate
			test_generator.set_object_selection_for_precondition_satisfaction_rate (70)

			test_generator.set_smt_enforce_old_value_rate (25)
			test_generator.set_smt_use_predefined_value_rate (25)

				-- Set lower/upper bound for linearly solvable arguments.
			test_generator.set_integer_lower_bound (-512)
			test_generator.set_integer_upper_bound (512)

			test_generator.set_is_random_cursor_used (True)

				-- Set test case serialization arguments.
			test_generator.set_is_passing_test_case_serialization_enabled (False)
			test_generator.set_is_failing_test_case_serialization_enabled (False)
			test_generator.set_test_case_serialization_file (Void)
			test_generator.set_is_test_case_serialization_retrieved_online (False)
			test_generator.set_output_dir_for_test_case_online (Void)

				-- Set test case deserialization arguments.
			test_generator.set_is_passing_test_case_deserialization_enabled (False)
			test_generator.set_is_failing_test_case_deserialization_enabled (False)

--				-- Use STRING_8 internally
--			l_generator.set_features_under_test_to_deserialize (create {EPA_STRING_HASH_SET}.make_equal(l_ap.features_under_test_to_deserialize.count))
--			from l_ap.features_under_test_to_deserialize.start
--			until l_ap.features_under_test_to_deserialize.after
--			loop
--				l_generator.features_under_test_to_deserialize.force (l_ap.features_under_test_to_deserialize.item_for_iteration.out)
--				l_ap.features_under_test_to_deserialize.forth
--			end

--			l_generator.set_building_behavioral_models (l_ap.is_building_behavioral_model)
--			l_generator.set_model_directory (l_ap.model_dir)
--			l_generator.set_building_faulty_feature_list (l_ap.is_building_faulty_feature_list)
--			l_generator.set_faulty_feature_list_file_name (l_ap.faulty_feature_list_file_name)
--			l_generator.set_deserialization_for_fixing (l_ap.is_deserializing_for_fixing)
--			l_generator.set_serialization_validity_log (l_ap.serialization_validity_log)

--			l_generator.set_recursive (l_ap.is_recursive)
--			l_generator.set_feature_to_disable_contracts (l_ap.disable_feature_contracts)

--			l_generator.set_data_input (l_ap.data_input)
--			l_generator.set_data_output (l_ap.data_output)

--			l_generator.set_is_interpreter_log_enabled (l_ap.is_interpreter_log_enabled)
--			l_generator.set_is_console_output_enabled (l_ap.is_console_log_enabled)

--				-- Use STRING_8 internally
			test_generator.set_proxy_log_options (create {HASH_TABLE [BOOLEAN, STRING]}.make_equal (10))
			test_generator.proxy_log_options.put (True, "passing")
			test_generator.proxy_log_options.put (True, "failing")
			test_generator.proxy_log_options.put (True, "invalid")
			test_generator.proxy_log_options.put (True, "bad")
			test_generator.proxy_log_options.put (True, "error")
			test_generator.proxy_log_options.put (True, "expr-assign")
			test_generator.proxy_log_options.put (True, "batch-assign")
			test_generator.proxy_log_options.put (True, "type")

--			l_generator.set_is_duplicated_test_case_serialized (l_ap.is_duplicated_test_case_serialized)

--			l_generator.set_is_post_state_serialized (l_ap.is_post_state_serialized)

--				-- Use STRING_8 internally
--			from l_ap.excluded_features.start
--			until l_ap.excluded_features.after
--			loop
--				l_generator.excluded_features.force ([l_ap.excluded_features.item_for_iteration.class_name.out, l_ap.excluded_features.item_for_iteration.feature_name.out])
--				l_ap.excluded_features.forth
--			end
--				-- l_generator.excluded_features.append (l_ap.excluded_features)

--				-- Use STRING_8 internally
--			from l_ap.popular_features.start
--			until l_ap.popular_features.after
--			loop
--				l_generator.popular_features.force ([l_ap.popular_features.item_for_iteration.class_name.out, l_ap.popular_features.item_for_iteration.feature_name.out, l_ap.popular_features.item_for_iteration.level])
--				l_ap.popular_features.forth
--			end
--			-- l_generator.popular_features.append (l_ap.popular_features)

--			l_generator.set_collecting_interface_related_classes (l_ap.is_collecting_interface_related_classes)
			test_generator.set_should_freeze_before_testing (False)

				-- Setup for precondition reduction strategy.
--			l_generator.set_is_precondition_reduction_enabled (l_ap.is_precondition_reduction_enabled)
--			l_generator.set_semantic_database_config (l_ap.semantic_data_base_config)
--			l_generator.set_prestate_invariant_path (l_ap.precondition_reduction_file)
--			l_generator.set_should_check_invariant_violating_objects (l_ap.should_check_invariant_violating_objects)
--			l_generator.set_arff_directory (l_ap.arff_directory)
--			l_generator.set_online_statistics_frequency (l_ap.online_statistics_frequency)

--			if l_generator.feature_to_disable_contracts /= Void then
--				create l_feature_contract_remover
--				l_names := l_generator.feature_to_disable_contracts.split ('.')
--				l_feature_contract_remover.remove_contracts_by_name (l_names [1], l_names [2])
--				Io.put_string ("Contracts removed from feature: " + l_generator.feature_to_disable_contracts)
--				Io.put_new_line
--			end


			if test_suite.is_service_available then
				l_test_suite := test_suite.service
				if l_test_suite.is_interface_usable then
					l_test_suite.launch_session (test_generator)
				end
			end

--			test_generator.set_is_random_testing_enabled (True)
--			test_generator.set_is_precondition_evaluation_enabled (True)

--			create l_log_options.make (10)
--			l_log_options.compare_objects
--			l_log_options.put (True, "passing")
--			l_log_options.put (True, "failing")
--			l_log_options.put (True, "invalid")
--			l_log_options.put (True, "bad")
--			l_log_options.put (True, "error")
--			l_log_options.put (True, "state")
--			l_log_options.put (True, "operand-type")
--			l_log_options.put (True, "expr-assign")
--			l_log_options.put (True, "type")
--			l_log_options.put (True, "precondition")
--			l_log_options.put (True, "statistics")
--			test_generator.set_proxy_log_options (l_log_options)
--			test_generator.set_html_statistics (True)
--			test_generator.set_text_statistics (True)

--			create l_session
--			l_session.service.retrieve (True).set_value (input.classes.first.name, {TEST_SESSION_CONSTANTS}.types)
--			launch_test_generation (test_generator, l_session.service, False)

--			test_generator.set_time_out_in_seconds (configuration.integer_setting ("timeout").as_natural_32)
--			test_generator.set_is_random_testing_enabled (True)
--			test_generator.set_is_precondition_evaluation_enabled (True)
--			test_generator.set_is_executing_normal_features_enabled (True)
--			test_generator.set_integer_lower_bound ({INTEGER}.min_value)
--			test_generator.set_integer_upper_bound ({INTEGER}.max_value)
--			test_generator.set_is_slicing_enabled (True)
--			test_generator.set_object_state_config (create {AUT_OBJECT_STATE_CONFIG}.make)

--			test_generator.set_is_failing_test_case_serialization_enabled (True)
--			test_generator.set_is_failing_test_case_deserialization_enabled (True)

--			if test_suite.is_service_available then
--				l_test_suite := test_suite.service
--				if l_test_suite.is_interface_usable then
--					l_test_suite.launch_session (test_generator)
--				end
--			end

		end

	cancel
			-- <Precursor>
		do
			test_generator.cancel
		end

feature {NONE} -- Implementation

	test_generator: EBB_TEST_GENERATOR

invariant
note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
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
