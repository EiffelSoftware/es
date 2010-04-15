note
	description: "[
		Interface defining configuration options for AutoTest.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TEST_GENERATOR_CONF_I

inherit
	TEST_CREATOR_CONF_I

feature -- Access

	types: attached DS_LINEAR [attached STRING]
			-- Names of classes to be tested
		require
			usable: is_interface_usable
		deferred
		end

	time_out: NATURAL
			-- Time in minutes used for testing.
			--
			-- Note: if zero, default will be used.
		require
			usable: is_interface_usable
		deferred
		end

	test_count: NATURAL
			-- Maximum number of tests that will be executed.
			--
			-- Note: if zero, no restriction will be applied.
		require
			usable: is_interface_usable
		deferred
		end

	proxy_time_out: NATURAL
			-- Time in seconds used by proxy to wait for a feature to execute.
			--
			-- Note: if zero, default will be used.
		require
			usable: is_interface_usable
		deferred
		end

	seed: NATURAL
			-- Seed for random number generation.
			--
			-- Note: if zero, current time will be used to generate random numbers.
		require
			usable: is_interface_usable
		deferred
		end

	log_file_path: detachable STRING
			-- Path for the log file to load
		require
			usable: is_interface_usable
		deferred
		end

	log_processor: detachable STRING
			-- Name of the specified log processor
		require
			usable: is_interface_usable
		deferred
		end

	log_processor_output: detachable STRING
			-- Name of the output file from log processor
		require
			usable: is_interface_usable
		deferred
		end

	is_interpreter_log_enabled: BOOLEAN
			-- Should messages from the interpreter be logged?
			-- Default: False
		require
			usable: is_interface_usable
		deferred
		end

feature -- Status report

	is_slicing_enabled: BOOLEAN
			-- Is slicing enabled?
		require
			usable: is_interface_usable
		deferred
		end

	is_ddmin_enabled: BOOLEAN
			-- Is ddmin enabled?
		require
			usable: is_interface_usable
		deferred
		end

	is_html_output: BOOLEAN
			-- Output statistics as html?
		require
			usable: is_interface_usable
		deferred
		end

	is_debugging: BOOLEAN
			-- Should debugging output be printed to log?
		require
			usable: is_interface_usable
		deferred
		end

	is_load_log_enabled: BOOLEAN is
			-- Should a specified load file be loaded?
		require
			usable: is_interface_usable
		deferred
		end

	is_random_testing_enabled: BOOLEAN
			-- Is random testing enabled?
		require
			usable: is_interface_usable
		deferred
		end

	is_on_the_fly_test_case_generation_enabled: BOOLEAN
			-- Is test case generation on the fly enabled?
		require
			usable: is_interface_usable
		deferred
		end

	proxy_log_options: STRING
			-- Proxy_log_options
		require
			usable: is_interface_usable
		deferred
		end

	is_console_output_enabled: BOOLEAN
			-- Is console output enabled?
			-- Default: True
		require
			usable: is_interface_usable
		deferred
		end

feature -- Object state retrieval

	is_target_state_retrieved: BOOLEAN is
			-- Should states of target objects be retrieved?
		require
			usable: is_interface_usable
		deferred
		end

	is_argument_state_retrieved: BOOLEAN is
			-- Should states of argument objects be retrieved?
		require
			usable: is_interface_usable
		deferred
		end

	is_query_result_state_retrieved: BOOLEAN is
			-- Should states of object returned as query results be retrieved?
		require
			usable: is_interface_usable
		deferred
		end

	is_object_state_retrieval_enabled: BOOLEAN is
			-- Should object state be retrieved?
		do
			Result :=
				is_target_state_retrieved or else
				is_argument_state_retrieved or else
				is_query_result_state_retrieved
		ensure
			good_result:
				Result =
					is_target_state_retrieved or else
					is_argument_state_retrieved or else
					is_query_result_state_retrieved
		end

feature -- Precondition satisfaction

	is_precondition_checking_enabled: BOOLEAN is
			-- Is precondition checking before feature call enabled?
			-- Default: False
		require
			usable: is_interface_usable
		deferred
		end

	is_linear_constraint_solving_enabled: BOOLEAN is
			-- Is linear constraint solving for integers enabled?
			-- Default: False
		require
			usable: is_interface_usable
		deferred
		end

	is_pool_statistics_logged: BOOLEAN is
			-- Should statistics of object pool and predicate be logged?
			-- Default: False
		deferred
		end

	is_smt_linear_constraint_solver_enabled: BOOLEAN is
			-- Is SMT-LIB based linear constraint solver enabled?
			-- Default: True
		deferred
		end

	is_lpsolve_linear_constraint_solver_enabled: BOOLEAN is
			-- Is lp_solve based linear constraint solver enabled?
			-- Default: False
		deferred
		end

	max_precondition_search_tries: INTEGER
			-- Max times to search for an object combination satisfying precondition of a feature.
			-- 0 means search until a satisfying object combination is found.
		require
			usable: is_interface_usable
		deferred
		end

	max_precondition_search_time: INTEGER
			-- Maximal time (in second) that can be spent in searching for
			-- objects satisfying precondition of a feature
		require
			usable: is_interface_usable
		deferred
		end

	max_candidate_count: INTEGER
			-- Max number of returned candidates that satisfy the precondition
			-- of the feature to call.
			-- 0 means no limit.
		require
			usable: is_interface_usable
		deferred
		end

	object_selection_for_precondition_satisfaction_rate: INTEGER
			-- Possibility [0-100] under which smart object selection for precondition satisfaction
			-- is used.
			-- Only have effect when precondition evaluation is enabled.
		require
			usable: is_interface_usable
		deferred
		end

	smt_enforce_old_value_rate: INTEGER is
			-- Possibility [0-100] to enforce SMT solver to choose an already used value.
			-- Default is 25
		require
			usable: is_interface_usable
		deferred
		end

	smt_use_predefined_value_rate: INTEGER is
			-- Possibility [0-100] to for the SMT solver to choose a predefined value for integers.
			-- Default is 25
		require
			usable: is_interface_usable
		deferred
		end

	integer_lower_bound: INTEGER is
			-- Lower bound for integer arguments that are to be solved by a linear constraint solver.
			-- Default is -512.
		require
			usable: is_interface_usable
		deferred
		end

	integer_upper_bound: INTEGER is
			-- Upper bound for integer arguments that are to be solved by a linear constraint solver.
			-- Default is 512.
		require
			usable: is_interface_usable
		deferred
		end

	is_random_cursor_used: BOOLEAN is
			-- When searching in predicate pool, should random cursor be used?
			-- Default: False
		require
			usable: is_interface_usable
		deferred
		end

feature -- Object State Exploration

	is_object_state_exploration_enabled: BOOLEAN is
			-- Is object state exploration enabled?
		deferred
		end

feature -- Test case serialization

	is_passing_test_case_serialization_enabled: BOOLEAN is
			-- Is passing test case serialization enabled?
			-- Only has effect if `is_test_case_serialization_enabled' is True.
		deferred
		end

	is_failing_test_case_serialization_enabled: BOOLEAN is
			-- Is failing test case serialization enabled?
			-- Only has effect if `is_test_case_serialization_enabled' is True.
		deferred
		end

	is_test_case_serialization_enabled: BOOLEAN
			-- Is test case serialization enabled?
		do
			Result := is_passing_test_case_serialization_enabled or is_failing_test_case_serialization_enabled
		end

	is_duplicated_test_case_serialized: BOOLEAN
			-- Is duplicated test case serialized?
			-- Two test cases are duplicated if their operands have the same abstract states.
		deferred
		end

feature -- Types under test

	types_under_test: DS_LIST [CL_TYPE_A]
			-- Types under test

	set_types_under_test (a_types: like types_under_test) is
			-- Set `types_under_test' with `a_types'.
		do
			create {DS_ARRAYED_LIST [CL_TYPE_A]} types_under_test.make (a_types.count)
			types_under_test.append_last (a_types)
		end

feature -- CITADEL

	is_citadel_test_generation_enabled: BOOLEAN
			-- Should AutoTest only generate tests to be input to CITADEL from an existing proxy log?
		require
			usable: is_interface_usable
		deferred
		end

note
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
