note
	description: "Summary description for {EBB_TEST_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_TEST_GENERATOR

inherit

	TEST_GENERATOR
		redefine
			print_test_set
		end

	EBB_SHARED_BLACKBOARD

create
	make

feature -- Basic operations

	print_test_set (a_list: DS_ARRAYED_LIST [AUT_TEST_CASE_RESULT])
			-- Print test case results as test.
			--
			-- `a_list': List of test case results to be printed to a test set.
		local
			l_result: AUT_TEST_CASE_RESULT
			l_verification_result: EBB_FEATURE_VERIFICATION_RESULT
		do
			current_results := a_list

			from
				current_results.start
			until
				current_results.after
			loop
				l_result := current_results.item_for_iteration

				if l_result.is_fail then
					create l_verification_result.make (l_result.feature_)

					l_verification_result.set_time (create {DATE_TIME}.make_now)
					l_verification_result.set_tool (blackboard.tools.i_th (2))
					l_verification_result.is_postcondition_proven.set_proven_to_fail
					l_verification_result.is_postcondition_proven.set_update
					l_verification_result.is_class_invariant_proven.set_proven_to_fail
					l_verification_result.is_class_invariant_proven.set_update

					blackboard.add_verification_result (l_verification_result)
				end

				current_results.forth
			end

				-- TODO: add results to blackboard

			current_results := Void
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
