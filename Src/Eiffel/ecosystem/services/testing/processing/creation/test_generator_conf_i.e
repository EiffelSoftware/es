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
			-- Note: is zero, default will be used.
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
		deferred
		end

	is_linear_constraint_solving_enabled: BOOLEAN is
			-- Is linear constraint solving for integers enabled?
		deferred
		end

feature -- Object State Exploration

	is_object_state_exploration_enabled: BOOLEAN is
			-- Is object state exploration enabled?
		deferred
		end

end
