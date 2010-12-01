note
	description: "Summary description for {AFX_FIXING_OPERATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_FIXING_OPERATION

inherit

	AFX_FIXING_OPERATION_CONSTANT

	EPA_HASH_CALCULATOR
		redefine
			is_equal
		end

	DEBUG_OUTPUT
		redefine
			is_equal
		end

	AFX_SHARED_SESSION
		redefine
			is_equal
		end

feature -- Access

	fixing_target: AFX_FIXING_TARGET
			-- Fixing targets associated with the operation.

	target_expressions: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			-- Actual target expressions that the fixing operation will be applied to.

	operation_text: STRING
			-- Text of the fixing operation.
		deferred
		end

	type: INTEGER
			-- Type of fixing operation.

feature -- Status report

	is_equal (a_operation: AFX_FIXING_OPERATION): BOOLEAN
			-- <Precursor>
		do
			Result := type = a_operation.type
					and then target_expressions ~ a_operation.target_expressions
		end

	debug_output: STRING
			-- <Precursor>
		do
			Result := operation_text
		end

	operation_text_template: STRING
			-- Operation text template.
		do
			inspect type
			when Fixing_operation_integer_increase_by_one then
				Result := "{1} := ({1}) + 1"
			when Fixing_operation_integer_decrease_by_one then
				Result := "{1} := ({1}) - 1"
			when Fixing_operation_integer_set_to_zero then
				Result := "{1} := 0"
			when Fixing_operation_integer_set_to_one then
				Result := "{1} := 1"
			when Fixing_operation_integer_set_to_minus_one then
				Result := "{1} := -1"
			when Fixing_operation_boolean_negate then
				Result := "{1} := not ({1})"
			when Fixing_operation_reference_call_command then
				Result := "({1}).{2}"
			when Fixing_operation_integers_set_equal_forward then
				Result := "{1} := ({2})"
			when Fixing_operation_integers_set_equal_backward then
				Result := "{2} := ({1})"
			when Fixing_operation_integers_set_bigger_by_one_forward then
				Result := "{1} := ({2}) + 1"
			when Fixing_operation_integers_set_bigger_by_one_backward then
				Result := "{2} := ({1}) + 1"
			when Fixing_operation_integers_set_less_by_one_forward then
				Result := "{1} := ({2}) - 1"
			when Fixing_operation_integers_set_less_by_one_backward then
				Result := "{2} := ({1}) - 1"
			else
				check should_not_happen: False end
			end
		end

feature{NONE} -- Implementation

	key_to_hash: DS_LINEAR [INTEGER]
			-- <Precursor>
		local
			l_list: DS_ARRAYED_LIST [INTEGER]
		do
			create l_list.make (target_expressions.count + 3)
			l_list.force_last (fixing_target.hash_code)
			target_expressions.do_all (
					agent (a_expr: AFX_PROGRAM_STATE_EXPRESSION; a_list: DS_ARRAYED_LIST [INTEGER])
						do
							a_list.force_last (a_expr.hash_code)
						end (?, l_list))
			l_list.force_last (type)

			Result := l_list
		end

end
