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
			l_timeout, l_proxy, l_seed: INTEGER
		do
			create types_cache.make_default
			Precursor (a_preference)
			l_timeout := a_preference.autotest_timeout.value
			if l_timeout > 0 then
				time_out_cache := l_timeout.to_natural_32
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

feature -- Access: cache

	types_cache: attached DS_HASH_SET [attached STRING]
			-- Cache for `types'

	time_out_cache: like time_out assign set_time_out
			-- Cache for `time_out'

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

	is_random_testing_enabled_cache: like is_random_testing_enabled assign set_is_random_testing_enabled
			-- Cache for `is_random_testing_enabled'

	log_file_path_cache: like log_file_path assign set_load_file_path
			-- Cache for `log_file_path'

	precondition_evaluation_cache: like is_precondition_checking_enabled
			-- Cache for `is_precondition_checking_enabled'

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
			result_equals_cache: Result = is_html_output
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
