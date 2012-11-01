note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_INTERVAL_ACROSS_HANDLER

inherit
	E2B_ACROSS_HANDLER

create
	make

feature {NONE} -- Initialization

	make (a_translator: E2B_EXPRESSION_TRANSLATOR; a_loop_expr: LOOP_EXPR_B; a_bin_free: BIN_FREE_B; a_object_test_local: OBJECT_TEST_LOCAL_B)
			-- Initialize handler.
		do
			expression_translator := a_translator
			loop_expr := a_loop_expr
			bin_free := a_bin_free
			object_test_local := a_object_test_local
		end

feature -- Access

	loop_expr: LOOP_EXPR_B
	bin_free: BIN_FREE_B
	object_test_local: OBJECT_TEST_LOCAL_B


	lower_bound: IV_EXPRESSION
	upper_bound: IV_EXPRESSION

feature -- Basic operations

	handle_across_expression (a_expr: LOOP_EXPR_B)
			-- <Precursor>
		local
			l_counter: IV_ENTITY
			l_lower: IV_EXPRESSION
			l_upper: IV_EXPRESSION
			l_binop1, l_binop2: IV_BINARY_OPERATION
			l_and: IV_BINARY_OPERATION
			l_implies: IV_BINARY_OPERATION
			l_quantifier: IV_QUANTIFIER
			l_expression: IV_EXPRESSION
			l_array: IV_EXPRESSION
			l_call: IV_FUNCTION_CALL
		do
			expression_translator.create_iterator (types.int)
			l_counter := expression_translator.last_local

			bin_free.left.process (expression_translator)
			l_lower := expression_translator.last_expression
			bin_free.right.process (expression_translator)
			l_upper := expression_translator.last_expression

			lower_bound := l_lower
			upper_bound := l_upper

			expression_translator.locals_map.put (l_counter, object_test_local.position)
			loop_expr.expression_code.process (expression_translator)
			l_expression := expression_translator.last_expression
			expression_translator.locals_map.remove (object_test_local.position)

			create l_binop1.make (l_lower, "<=", l_counter, types.bool)
			create l_binop2.make (l_counter, "<=", l_upper, types.bool)
			create l_and.make (l_binop1, "&&", l_binop2, types.bool)
			create l_implies.make (l_and, "==>", l_expression, types.bool)
			if loop_expr.is_all then
				create {IV_FORALL} l_quantifier.make (l_implies)
			else
				create {IV_EXISTS} l_quantifier.make (l_implies)
			end
			l_quantifier.add_bound_variable (l_counter.name, l_counter.type)
			expression_translator.set_last_expression (l_quantifier)
		end

	handle_call_item (a_feature: FEATURE_I)
			-- <Precursor>
		do
			expression_translator.set_last_expression (expression_translator.locals_map.item (object_test_local.position))
		end

	handle_call_cursor_index (a_feature: FEATURE_I)
			-- <Precursor>
		local
			l_binop1, l_binop2: IV_BINARY_OPERATION
		do
			create l_binop1.make (expression_translator.locals_map.item (object_test_local.position), "+", create {IV_VALUE}.make ("1", types.int), types.int)
			create l_binop2.make (l_binop1, "-", lower_bound, types.int)
			expression_translator.set_last_expression (l_binop2)
		end

	handle_call_after (a_feature: FEATURE_I)
			-- <Precursor>
		local
			l_binop: IV_BINARY_OPERATION
		do
			create l_binop.make (expression_translator.locals_map.item (object_test_local.position), ">", upper_bound, types.bool)
			expression_translator.set_last_expression (l_binop)
		end

	handle_call_forth (a_feature: FEATURE_I)
			-- <Precursor>
		do
		end

end
