note
	description: "Summary description for {TEST_GENERATOR_CONF}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_GENERATOR_CONF

inherit
	TEST_GENERATOR_CONF_I

	TEST_CREATOR_CONF
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (a_preference: TEST_PREFERENCES)
			-- <Precursor>
		local
			l_timeout, l_test_count, l_proxy, l_seed: INTEGER
		do
			create types_cache.make_default
			Precursor (a_preference)
			l_timeout := a_preference.autotest_timeout.value
			if l_timeout > 0 then
				time_out_cache := l_timeout.to_natural_32
			end
			l_test_count := a_preference.autotest_test_count.value
			if l_test_count > 0 then
				test_count_cache := l_test_count.to_natural_32
			end
			l_proxy := a_preference.autotest_proxy_timeout.value
			if l_proxy > 0 then
				proxy_time_out_cache := l_proxy.to_natural_32
			end
			l_seed := a_preference.autotest_seed.value
			if l_seed >= 0 then
				seed_cache := l_seed.to_natural_32
			end
			is_slicing_enabled_cache := a_preference.autotest_slice_minimization.value
			is_ddmin_enabled_cache := a_preference.autotest_ddmin_minimization.value
			is_html_output_cache := a_preference.autotest_html_statistics.value
			is_on_the_fly_test_case_generation_enabled_cache := True
		end

feature -- Access

	types: attached DS_LINEAR [attached STRING]
			-- <Precursor>
		do
			Result := types_cache
		end

	time_out: NATURAL
			-- <Precursor>
		do
			Result := time_out_cache
		ensure then
			result_equals_cache: Result = time_out_cache
		end

	test_count: NATURAL
			-- <Precursor>
		do
			Result := test_count_cache
		ensure then
			result_equals_cache: Result = test_count_cache
		end

	proxy_time_out: NATURAL
			-- <Precursor>
		do
			Result := proxy_time_out_cache
		ensure then
			result_equals_cache: Result = proxy_time_out_cache
		end

	seed: NATURAL
			-- <Precursor>
		do
			Result := seed_cache
		ensure then
			result_equals_cache: Result = seed_cache
		end

	log_file_path: detachable STRING
			-- Path for the log file to load
		do
			Result := log_file_path_cache
		ensure then
			result_set: Result = log_file_path_cache
		end

	object_state_config: detachable AUT_OBJECT_STATE_CONFIG
			-- Configuration related to object states retrieval

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

	is_random_cursor_used: BOOLEAN is
			-- When searching in predicate pool, should random cursor be used?
			-- Default: False
		do
			Result := is_random_cursor_used_cache
		ensure then
			good_result: Result = is_random_cursor_used_cache
		end

	is_interpreter_log_enabled: BOOLEAN
			-- Should messages from the interpreter be logged?
			-- Default: False
		do
			Result := is_interpreter_log_enabled_cache
		ensure then
			good_result: Result = is_interpreter_log_enabled_cache
		end

	is_on_the_fly_test_case_generation_enabled: BOOLEAN
			-- Is test case generation on the fly enabled?
		do
			Result := is_on_the_fly_test_case_generation_enabled_cache
		ensure then
			good_result: Result = is_on_the_fly_test_case_generation_enabled_cache
		end

	proxy_log_options: STRING
			-- Proxy log options.
		do
			Result := is_proxy_log_options_cache
		ensure then
			good_result: Result = is_proxy_log_options_cache
		end

	is_console_output_enabled: BOOLEAN
			-- Is console output enabled?
			-- Default: True
		do
			Result := is_console_output_enabled_cache
		ensure then
			good_result: Result = is_console_output_enabled_cache
		end


feature -- Access: cache

	types_cache: attached DS_HASH_SET [attached STRING]
			-- Cache for `types'

	time_out_cache: like time_out assign set_time_out
			-- Cache for `time_out'

	test_count_cache: like test_count assign set_test_count
			-- Cache for `test_count'

	proxy_time_out_cache: like proxy_time_out assign set_proxy_time_out
			-- Cache for `proxy_time_out'		

	seed_cache: like seed assign set_seed
			-- Cache for `seed'

	is_slicing_enabled_cache: like is_slicing_enabled assign set_slicing_enabled
			-- Cache for `is_slicing_enabled'

	is_ddmin_enabled_cache: like is_ddmin_enabled assign set_ddmin_enabled
			-- Cache for `is_ddmin_enabled'

	is_html_output_cache: like is_html_output assign set_html_output
			-- Cache for `is_html_output'

	is_debugging_cache: like is_debugging assign set_debugging
			-- Cache for `is_debugging'
	is_random_testing_enabled_cache: like is_random_testing_enabled assign set_is_random_testing_enabled
			-- Cache for `is_random_testing_enabled'

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

	max_precondition_search_tries_cache: like max_precondition_search_tries
			-- Cache for `max_precondition_search_tries'

	max_precondition_search_time_cache: like max_precondition_search_time
			-- Cache for `max_precondition_search_time'

	is_citadel_test_generation_enabled_cache: like is_citadel_test_generation_enabled assign set_is_citadel_test_generation_enabled
			-- Cache for `is_citadel_test_generation_enabled'

	max_candidate_count_cache: like max_candidate_count
			-- Cache for `max_candidate_count'

	is_pool_statistics_logged_cache: like is_pool_statistics_logged
			-- Cache for `is_pool_statistics_logged'

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

	is_interpreter_log_enabled_cache: BOOLEAN
			-- Cache for `is_interpreter_log_enabled'

	is_on_the_fly_test_case_generation_enabled_cache: BOOLEAN
			-- Cache for `on_the_fly_test_case_generation_enabled_cache'	

	is_proxy_log_options_cache: STRING
			-- Cache for `is_proxy_log_options'	

	is_console_output_enabled_cache: BOOLEAN
			-- Cache for `is_console_output_enabled'		

	is_duplicated_test_case_serialized_cache: BOOLEAN
			-- Cache for `is_duplicated_test_case_serialized_cache'

feature -- Status report

	is_new_class: BOOLEAN = True
			-- <Precursor>

	is_multiple_new_classes: BOOLEAN = True
			-- <Precursor>

	is_slicing_enabled: BOOLEAN
			-- <Precursor>
		do
			Result := is_slicing_enabled_cache
		ensure then
			result_equals_cache: Result = is_slicing_enabled_cache
		end

	is_ddmin_enabled: BOOLEAN
			-- <Precursor>
		do
			Result := is_ddmin_enabled_cache
		ensure then
			result_equals_cache: Result = is_ddmin_enabled_cache
		end

	is_html_output: BOOLEAN
			-- <Precursor>
		do
			Result := is_html_output_cache
		ensure then
			result_equals_cache: Result = is_html_output_cache
		end

	is_debugging: BOOLEAN
			-- <Precursor>
		do
			Result := is_debugging_cache
		ensure then
			result_equals_cache: Result = is_debugging_cache
		end
	is_load_log_enabled: BOOLEAN is
			-- Should a specified load file be loaded?
		do
			Result := log_file_path /= Void
		end

	is_random_testing_enabled: BOOLEAN
			-- Is random testing enabled?
		do
			Result := is_random_testing_enabled_cache
		ensure then
			result_set: Result = is_random_testing_enabled_cache
		end

feature -- Object state retrieval

	is_target_state_retrieved: BOOLEAN is
			-- Should states of target objects be retrieved?
		do
			Result := object_state_config /= Void and then object_state_config.is_target_object_state_retrieval_enabled
		end

	is_argument_state_retrieved: BOOLEAN is
			-- Should states of argument objects be retrieved?
		do
			Result := object_state_config /= Void and then object_state_config.is_argument_object_state_retrieval_enabled
		end

	is_query_result_state_retrieved: BOOLEAN is
			-- Should states of objects returned as query results be retrieved?
		do
			Result := object_state_config /= Void and then object_state_config.is_query_result_object_state_retrieval_enabled
		end

feature -- Precondition satisfaction

	is_precondition_checking_enabled: BOOLEAN is
			-- Is precondition checking before feature call enabled?
		do
			Result := precondition_evaluation_cache
		ensure then
			good_result: Result = precondition_evaluation_cache
		end

	is_linear_constraint_solving_enabled: BOOLEAN is
			-- Is linear constraint solving for integers enabled?
		do
			Result := linear_solving_cache
		ensure then
			good_result: Result = linear_solving_cache
		end

	is_pool_statistics_logged: BOOLEAN is
			-- Should statistics of object pool and predicate be logged?
			-- Default: False
		do
			Result := is_pool_statistics_logged_cache
		ensure then
			good_result: Result = is_pool_statistics_logged_cache
		end

	is_smt_linear_constraint_solver_enabled: BOOLEAN is
			-- Is SMT-LIB based linear constraint solver enabled?
			-- Default: True
		do
			Result := is_smt_linear_constraint_solver_enabled_cache
		ensure then
			good_result: Result = is_smt_linear_constraint_solver_enabled_cache
		end

	is_lpsolve_linear_constraint_solver_enabled: BOOLEAN is
			-- Is lp_solve based linear constraint solver enabled?
			-- Default: False
		do
			Result := is_lpsolve_linear_constraint_solver_enabled_cache
		ensure then
			good_result: Result = is_lpsolve_linear_constraint_solver_enabled_cache
		end

feature -- Object State Exploration

	is_object_state_exploration_enabled: BOOLEAN is
			-- Is object state exploration enabled?
		do
			Result := object_state_exploration_cache
		ensure then
			good_result: Result = object_state_exploration_cache
		end

	is_citadel_test_generation_enabled: BOOLEAN
			-- Is random testing enabled?
		do
			Result := is_citadel_test_generation_enabled_cache
		ensure then
			result_set: Result = is_citadel_test_generation_enabled_cache
		end

feature -- Test case serialization

	is_passing_test_case_serialization_enabled: BOOLEAN is
			-- Is passing test case serialization enabled?
			-- Only has effect if `is_test_case_serialization_enabled' is True.
		do
			Result := is_passing_test_case_serialization_enabled_cache
		end

	is_failing_test_case_serialization_enabled: BOOLEAN is
			-- Is failing test case serialization enabled?
			-- Only has effect if `is_test_case_serialization_enabled' is True.
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

feature -- Status setting

	set_ddmin_enabled (a_is_ddmin_enabled: like is_ddmin_enabled)
			-- Set `is_ddmin_enabled' to `a_is_ddmin_enabled'.
		do
			is_ddmin_enabled_cache := a_is_ddmin_enabled
		ensure
			is_ddmin_enabled_set: is_ddmin_enabled_cache = a_is_ddmin_enabled
		end

	set_slicing_enabled (a_is_slicing_enabled: like is_slicing_enabled)
			-- Set `is_slicing_enabled' to `a_is_slicing_enabled'.
		do
			is_slicing_enabled_cache := a_is_slicing_enabled
		ensure
			is_slicing_enabled_set: is_slicing_enabled_cache = a_is_slicing_enabled
		end

	set_html_output (a_is_html_output: like is_html_output)
			-- Set `is_html_output' to `a_is_html_output'.
		do
			is_html_output_cache := a_is_html_output
		ensure
			is_html_output_set: is_html_output_cache = a_is_html_output
		end

	set_debugging (a_is_debugging: like is_debugging)
			-- Set `is_debugging' to `a_is_debugging'.
		do
			is_debugging_cache := a_is_debugging
		ensure
			is_debugging_set: is_debugging_cache = a_is_debugging
		end

	set_seed (a_seed: like seed)
			-- Set `seed' to `a_seed'.
		do
			seed_cache := a_seed
		ensure
			seed_set: seed_cache = a_seed
		end

	set_time_out (a_time_out: like time_out)
			-- Set `time_out' to `a_time_out'.
		do
			time_out_cache := a_time_out
		ensure
			time_out_set: time_out_cache = a_time_out
		end

	set_test_count (a_test_count: like test_count)
			-- Set `test_count' to `a_test_count'.
		do
			test_count_cache := a_test_count
		ensure
			test_count_set: test_count_cache = a_test_count
		end

	set_proxy_time_out (a_proxy_time_out: like proxy_time_out)
			-- Set `proxy_time_out' to `a_proxy_time_out'.
		do
			proxy_time_out_cache := a_proxy_time_out
		ensure
			proxy_time_out_set: proxy_time_out_cache = a_proxy_time_out
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

	set_is_citadel_test_generation_enabled (b: BOOLEAN) is
			-- Set `is_citadel_test_generation_enabled' with `b'.
		do
			is_citadel_test_generation_enabled_cache := b
		ensure
			is_citadel_test_generation_enabled_set: is_citadel_test_generation_enabled = b
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

	set_is_pool_statistics_logged (b: like is_pool_statistics_logged) is
			-- Set `is_pool_statistics_logged' with `b'.
		do
			is_pool_statistics_logged_cache := b
		ensure
			is_pool_statistics_logged_set: is_pool_statistics_logged_cache = b
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

	set_is_interpreter_log_enabled (b: BOOLEAN)
			-- Set `is_interpreter_log_enabled' with `b'.
		do
			is_interpreter_log_enabled_cache := b
		ensure
			is_interpreter_log_enabled_set: is_interpreter_log_enabled = b
		end

	set_is_on_the_fly_test_case_generation_enabled (b: BOOLEAN)
			-- Set `on_the_fly_test_case_generation_enabled' with `b'.
		do
			is_on_the_fly_test_case_generation_enabled_cache := b
		ensure
			on_the_fly_test_case_generation_enabled_set: is_on_the_fly_test_case_generation_enabled = b
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
			is_proxy_log_options_cache := b.twin
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
