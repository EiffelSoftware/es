note
	description: "TODO"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_SEQUENCE_ACROSS_HANDLER

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
			seq_access := a_set_access
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
	seq_access: ACCESS_B
	object_test_local: OBJECT_TEST_LOCAL_B
	sequence_expression: IV_EXPRESSION

feature -- Basic operations

	handle_across_expression (a_expr: LOOP_EXPR_B)
			-- <Precursor>
		local
			l_counter: IV_ENTITY
			l_lower: IV_EXPRESSION
			l_upper: IV_EXPRESSION
			l_binop1, l_binop2: IV_BINARY_OPERATION
			l_and: IV_BINARY_OPERATION
			l_quantifier: IV_QUANTIFIER
			l_expression: IV_EXPRESSION
			l_seq: IV_EXPRESSION
			l_bounds: IV_EXPRESSION
		do
				-- Sequence expression
			seq_access.process (expression_translator)
			l_seq := expression_translator.last_expression
			sequence_expression := l_seq

				-- Loop content
			expression_translator.create_iterator (types.int)
			l_counter := expression_translator.last_local
			expression_translator.locals_map.put (l_counter, object_test_local.position)
			loop_expr.expression_code.process (expression_translator)
			l_expression := expression_translator.last_expression
			expression_translator.locals_map.remove (object_test_local.position)

			l_bounds := factory.and_ (
				factory.less_equal (factory.int_value (0), l_counter),
				factory.less (l_counter, factory.function_call ("Seq#Length", << l_seq >>, types.int)))

			if loop_expr.is_all then
				create {IV_FORALL} l_quantifier.make (factory.implies_ (l_bounds, l_expression))
			else
				create {IV_EXISTS} l_quantifier.make (factory.and_ (l_bounds, l_expression))
			end
			l_quantifier.add_bound_variable (l_counter.name, l_counter.type)
			if attached {IV_FUNCTION_CALL} l_expression as l_fcall then
				if across l_fcall.arguments as i some attached {IV_ENTITY} i.item as j and then j.name ~ l_counter.name end then
					l_quantifier.add_trigger (l_expression)
				end
			end
			expression_translator.set_last_expression (l_quantifier)
		end

	handle_call_item (a_feature: FEATURE_I)
			-- <Precursor>
		do
			expression_translator.set_last_expression (
				factory.function_call ("Seq#Index",
					<< sequence_expression, expression_translator.locals_map.item (object_test_local.position) >>,
					types.generic))
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
