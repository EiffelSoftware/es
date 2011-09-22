note
	description: "Summary description for {AUT_TEST_CASE_CATEGORIZER_BY_FAULT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_TEST_CASE_CATEGORIZER_BY_FAULT

inherit
	AUT_TEST_CASE_CATEGORIZER

create
	make

feature -- Data event handler

	on_deserialization_started
			-- <Precursor>
		do
			create passing_repository.make_equal (128)
			create failing_repository.make_with_default_equality_testers (128)
		end

	on_test_case_deserialized (a_data: AUT_DESERIALIZED_TEST_CASE)
			-- <Precursor>
		local
			l_summary, l_signature: STRING
			l_set: EPA_HASH_SET [AUT_DESERIALIZED_TEST_CASE]
			l_builder: AUT_TEST_CASE_TEXT_BUILDER
			l_name, l_text: STRING
			l_categories: DS_ARRAYED_LIST [STRING]
		do
			if a_data.test_case_text.is_empty then
				l_summary := a_data.class_and_feature_under_test
				l_signature := a_data.exception_signature

				if l_signature /= Void then
					if a_data.is_execution_successful then
						if passing_repository.has (l_summary) then
							l_set := passing_repository.item (l_summary)
						else
							create l_set.make_equal (16)
							passing_repository.force (l_set, l_summary)
						end
						l_set.force (a_data)
					else
						failing_repository.put_value (a_data, l_summary, l_signature)
					end
				end
			end
		end

	on_deserialization_finished
			-- <Precursor>
		local
			l_summary, l_signature: STRING
			l_data: AUT_DESERIALIZED_TEST_CASE
			l_set: EPA_HASH_SET [AUT_DESERIALIZED_TEST_CASE]
			l_table: like passing_repository
			l_categories: DS_ARRAYED_LIST [STRING]
		do
			from failing_repository.start
			until failing_repository.after
			loop
				l_signature := failing_repository.key_for_iteration
				l_table := failing_repository.item_for_iteration

				from l_table.start
				until l_table.after
				loop
					l_summary := l_table.key_for_iteration
					l_set := l_table.item_for_iteration
					check set_not_empty: not l_set.is_empty end

					l_categories := categorize (l_set.first)
					write_test_cases (l_set, l_categories)
					if passing_repository.has (l_summary) and then not passing_repository.item (l_summary).is_empty then
							-- Fault with both passing and failing test cases.
						write_test_cases (passing_repository.item (l_summary), l_categories)
					end

					l_table.forth
				end

				failing_repository.forth
			end
		end

feature -- Basic operation

	categorize (a_data: AUT_DESERIALIZED_TEST_CASE): DS_ARRAYED_LIST [STRING]
			-- <Precursor>
		do
			create Result.make (2)
			Result.force_last (a_data.class_and_feature_under_test)
			Result.force_last (a_data.exception_signature)
		end

feature{NONE} -- Implementation

	write_test_cases (a_set: EPA_HASH_SET [AUT_DESERIALIZED_TEST_CASE]; a_categories: DS_ARRAYED_LIST [STRING])
			-- Write `a_set' of test cases into `test_case_dir', in `a_categories'.
		do
			from a_set.start
			until a_set.after
			loop
				write_test_case (a_set.item_for_iteration, a_categories)
				a_set.forth
			end
		end

feature{NONE} -- Access

	passing_repository: DS_HASH_TABLE [EPA_HASH_SET [AUT_DESERIALIZED_TEST_CASE], STRING]
			-- Repository of all passing tests.
			-- Key: summary of tests, in the form of "CLASS_UNDER_TEST.feature_under_test'.
			-- Val: set of deserialized test cases.

	failing_repository: EPA_NESTED_HASH_TABLE [AUT_DESERIALIZED_TEST_CASE, STRING, STRING]
			-- Repository of all failing tests.
			-- 1-Key: exception signatures
			-- 2-key: summary of tests
			-- Value: set of deserialized test cases.

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
