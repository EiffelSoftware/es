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
			set_trace ("")
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

	origin_recipient: FEATURE_I
			-- Origin recipient
		do
			Result := test_case_info.origin_recipient
		end

	recipient_written_class: CLASS_C
			-- Written class of `recipient'
		do
			Result := test_case_info.recipient_written_class
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

	ranking: HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]
			-- Expressions in `skeleton' with rankings

	id: STRING
			-- Identifier of current spot	
		do
			Result := test_case_info.id
		end

	hash_code: INTEGER
			-- Hash code value
		do
			Result := id.hash_code
		ensure then
			good_result: Result = id.hash_code
		end

	trace: STRING
			-- Trace of the exception

	recipient_ast_structure: AFX_FEATURE_AST_STRUCTURE_NODE
			-- AST structure of `recipient_'

	failing_assertion: EPA_EXPRESSION
			-- Failing assertion, rewritten in the context of the recipient.

	original_failing_assertion: EPA_EXPRESSION
			-- Original assertion for `failing_assertion'.
			-- Different from `failing_assertion' in precondition violations,
			-- same as `failing_assertion' in other types of assertion violations.

	failing_assertion_break_point_slot: INTEGER
			-- Break point slot for `failing_assertion'
			-- If the exception is a precondition violation, this is the break point slot for the failing routine call in recipient.
			-- Otherwise, this is equal to `test_case_info'.`break_point_slot'.

	feature_of_failing_assertion: FEATURE_I
			-- Feature which contains `failing_assertion'.
			-- If the exception is a precondition violation, `feature_of_failing_assertion' will be
			-- the feature where `failing_assertion' is written, otherwise,
			-- `feature_of_failing_assertion' will be the recipient of the exception.

	class_of_feature_of_failing_assertion: CLASS_C
			-- Class of `feature_of_failing_assertion'.
			-- Not necessarily the written class of `feature_of_failing_assertion'

	actual_arguments_in_failing_assertion: HASH_TABLE [EPA_EXPRESSION, INTEGER]
			-- Expressions used as routine arguments and mentioned in `failing_assertion'.
			-- This is only used in case of precondition violation, for other types of exceptions
			-- this table is empty.
			-- Key is the argument index, value is the mentioned expression used as actual argument.

	target_expression_of_failing_feature: detachable EPA_EXPRESSION
			-- Target expression of `feature_of_failing_assertion'
			-- Void means that `feature_of_failing_assertion' is a unqualified call.

feature -- Status report

	is_precondition_violation: BOOLEAN
			-- Does current represent a precondition violation?
		do
			Result := exception_code = {EXCEP_CONST}.precondition
		end

	is_postcondition_violation: BOOLEAN
			-- Does current represent a postcondition violation?
		do
			Result := exception_code = {EXCEP_CONST}.postcondition
		end

	is_class_invariant_violation: BOOLEAN
			-- Does current represent a class invariant violation?
		do
			Result := exception_code = {EXCEP_CONST}.class_invariant
		end

	is_check_violation: BOOLEAN
			-- Does current represent a check violation?
		do
			Result := exception_code = {EXCEP_CONST}.check_instruction
		end

feature -- Equality

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

	set_trace (a_trace: STRING)
			-- Set `trace' with `a_trace'.
			-- Make a new copy of `a_trace'.
		do
			create trace.make_from_string (a_trace)
		end

	set_recipient_ast_structure (a_structure: like recipient_ast_structure)
			-- Set `recipient_ast_structure' with `a_structure'.
		do
			recipient_ast_structure := a_structure
		ensure
			recipient_ast_structure_set: recipient_ast_structure = a_structure
		end

	set_failing_assertion (a_assertion: like failing_assertion)
			-- Set `failing_assertion' with `a_assertion'.
		do
			failing_assertion := a_assertion
		end

	set_original_failing_assertion (a_assertion: like original_failing_assertion)
			-- Set `original_failing_assertion' with `a_assertion'.
		do
			original_failing_assertion := a_assertion
		end

	set_feature_of_failing_assertion (a_feature: like feature_of_failing_assertion)
			-- Set `feature_of_failing_assertion' with `a_feature'.
		do
			feature_of_failing_assertion := a_feature
		end

	set_class_of_feature_of_failing_assertion (a_class: like class_of_feature_of_failing_assertion)
			-- Set `class_of_feature_of_failing_assertion' with `a_class'.
		do
			class_of_feature_of_failing_assertion := a_class
		end

	set_actual_arguments_in_failing_assertion (a_table: like actual_arguments_in_failing_assertion)
			-- Set `actual_arguments_in_failing_assertion' with `a_table'.
		do
			actual_arguments_in_failing_assertion := a_table
		end

	set_failing_assertion_break_point_slot (i: INTEGER)
			-- Set `failing_assertion_break_point_slot' with `'i'.
		do
			failing_assertion_break_point_slot := i
		ensure
			failing_assertion_break_point_slot_set: failing_assertion_break_point_slot = i
		end

	set_target_expression_of_failing_feature (a_expr: like target_expression_of_failing_feature)
			-- Set `target_expression_of_failing_feature'.
		do
			target_expression_of_failing_feature := a_expr
		ensure
			target_expression_of_failing_feature_set: target_expression_of_failing_feature = a_expr
		end

feature{NONE} -- Implementation

	keys_from_hash_table (a_table: HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]): LINKED_LIST [EPA_EXPRESSION]
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
