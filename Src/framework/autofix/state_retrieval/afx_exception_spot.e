note
	description: "Summary description for {AFX_EXCEPTION_SPOT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EXCEPTION_SPOT

inherit
	HASHABLE
		redefine
			is_equal
		end

create
	make

feature{NONE} -- Initialization

	make (a_info: AFX_TEST_CASE_INFO)
			-- Initialize Current with `a_info.
		do
			test_case_info := a_info
			id := test_case_info.id
		end

feature -- Access

	test_case_info: AFX_TEST_CASE_INFO
			-- Test case information

	class_under_test: STRING
			-- Name of class under test
		do
			Result := test_case_info.class_under_test
		end

	feature_under_test: STRING
			-- Name of feature under test
		do
			Result := test_case_info.feature_under_test
		end

	recipient_class: STRING
			-- Name of the class containing `recipient' in case of a failed test case.
			-- In a passing test case, same as `class_under_test'.
		do
			Result := test_case_info.recipient_class
		end

	recipient: STRING
			-- Name of the recipient in case of a failed test case.
			-- In a passing test case, same as `feature_under_test'.
		do
			Result := test_case_info.recipient
		end

	recipient_class_: CLASS_C
			-- Class for `recipient_class'
		do
			Result := test_case_info.recipient_class_
		end

	recipient_: FEATURE_I
			-- Feature for `recipient'
		do
			Result := test_case_info.recipient_
		end

	test_case_breakpoint_slot: INTEGER
			-- Breakpoint slot of the exception in case of a failed test case.
			-- In a passing test case, 0.
		do
			Result := test_case_info.breakpoint_slot
		end

	exception_code: INTEGER
			-- Exception code in case of a failed test case.
			-- In a passing test case, 0.
		do
			Result := test_case_info.exception_code
		end

	tag: STRING
			-- Tag of the failing assertion in case of a failed test case.
			-- In a passing test case, "noname"
		do
			Result := test_case_info.tag
		end

	skeleton: AFX_STATE_SKELETON
			-- Expressions that should be included in the
			-- state model for current exception spot

	ranking: HASH_TABLE [AFX_EXPR_RANK, AFX_EXPRESSION]
			-- Expressions in `skeleton' with rankings

	id: STRING
			-- Identifier of current spot	

	hash_code: INTEGER
			-- Hash code value
		do
			Result := id.hash_code
		ensure then
			good_result: Result = id.hash_code
		end

feature -- Status report

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result := id ~ other.id
		end

feature -- Setting

	set_ranking (a_ranking: like ranking)
			-- Set `ranking' with `a_ranking'.
		do
			ranking := a_ranking
			create skeleton.make_with_expressions (recipient_class_, recipient_, keys_from_hash_table (ranking))
		ensure
			ranking_set: ranking = a_ranking
		end

feature{NONE} -- Implementation

	keys_from_hash_table (a_table: HASH_TABLE [AFX_EXPR_RANK, AFX_EXPRESSION]): LINKED_LIST [AFX_EXPRESSION]
			-- Keys from `a_table' as a list
		do
			create Result.make
			from
				a_table.start
			until
				a_table.after
			loop
				Result.extend (a_table.key_for_iteration)
				a_table.forth
			end
		end

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
