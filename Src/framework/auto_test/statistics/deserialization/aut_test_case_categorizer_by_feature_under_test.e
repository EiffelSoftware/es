note
	description: "Summary description for {AUT_TEST_CASE_CATEGORIZER_BY_FEATURE_UNDER_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_TEST_CASE_CATEGORIZER_BY_FEATURE_UNDER_TEST

inherit
	AUT_TEST_CASE_CATEGORIZER
		redefine
			on_deserialization_started,
			on_deserialization_finished
		end

create
	make

feature -- Data event handler

	on_deserialization_started
			-- <Precursor>
		do
			all_unique_test_cases.wipe_out
		end

	on_test_case_deserialized (a_data: AUT_DESERIALIZED_TEST_CASE)
			-- <Precursor>
		do
			all_unique_test_cases.put_last (a_data)
		end

	on_deserialization_finished
			-- <Precursor>
		local
			l_data: AUT_DESERIALIZED_TEST_CASE
			l_categories: DS_ARRAYED_LIST [STRING]
		do
				-- Log time and UUID of test cases.
			write_test_case_list_to_time_uuid_log (all_unique_test_cases)

				-- Write test cases to disk.
			from all_unique_test_cases.start
			until all_unique_test_cases.after
			loop
				l_data := all_unique_test_cases.item_for_iteration

				if ((l_data.is_execution_successful and then configuration.is_passing_test_case_deserialization_enabled)
						or else (not l_data.is_execution_successful and then configuration.is_failing_test_case_deserialization_enabled))
						and then not l_data.test_case_text.is_empty then
					l_categories := categorize (l_data)
					write_test_case (l_data, l_categories)
				end

				all_unique_test_cases.forth
			end
		end

feature -- Basic operation

	categorize (a_data: AUT_DESERIALIZED_TEST_CASE): DS_ARRAYED_LIST [STRING]
			-- <Precursor>
		do
			create Result.make (2)
			Result.force_last (a_data.tc_class_under_test)
			Result.force_last (a_data.tc_feature_under_test)
		end

feature{NONE}

	all_unique_test_cases: DS_ARRAYED_LIST [AUT_DESERIALIZED_TEST_CASE]
			-- <Precursor>
		do
			if all_unique_test_cases_cache = Void then
				create all_unique_test_cases_cache.make(1024)
			end
			Result := all_unique_test_cases_cache
		end

	all_unique_test_cases_cache: DS_ARRAYED_LIST [AUT_DESERIALIZED_TEST_CASE]
			-- Cache for `all_unique_test_cases'.

;note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
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
