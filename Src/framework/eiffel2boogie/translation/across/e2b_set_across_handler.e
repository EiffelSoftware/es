note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_SET_ACROSS_HANDLER

inherit
	E2B_ACROSS_HANDLER

create
	make

feature {NONE} -- Initialization

	make (a_translator: E2B_EXPRESSION_TRANSLATOR; a_loop_expr: LOOP_EXPR_B; a_set_access: ACCESS_B; a_object_test_local: OBJECT_TEST_LOCAL_B)
			-- Initialize handler.
		do
			expression_translator := a_translator
			loop_expr := a_loop_expr
			set_access := a_set_access
			object_test_local := a_object_test_local
		end

	make_loop (a_loop: LOOP_B; a_object_test_local: OBJECT_TEST_LOCAL_B)
			-- Initialize handler from loop.
		do
			loop_ := a_loop
			object_test_local := a_object_test_local
		end

feature -- Access

	loop_: LOOP_B
	loop_expr: LOOP_EXPR_B
	set_access: ACCESS_B
	object_test_local: OBJECT_TEST_LOCAL_B

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
			l_set: IV_EXPRESSION
			l_map: IV_MAP_ACCESS
		do
				-- Set expression
			set_access.process (expression_translator)
			l_set := expression_translator.last_expression

				-- Loop content
			expression_translator.create_iterator (types.ref)
			l_counter := expression_translator.last_local
			expression_translator.locals_map.put (l_counter, object_test_local.position)
			loop_expr.expression_code.process (expression_translator)
			l_expression := expression_translator.last_expression
			expression_translator.locals_map.remove (object_test_local.position)


			create l_map.make (l_set, l_counter)
			create l_implies.make (l_map, "==>", l_expression, types.bool)
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
		do
		end

	handle_call_after (a_feature: FEATURE_I)
			-- <Precursor>
		do
		end

	handle_call_forth (a_feature: FEATURE_I)
			-- <Precursor>
		do
		end

end
