note
	description: "Test case information"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_TEST_CASE_INFO

inherit
	EPA_UTILITY

	EPA_SHARED_EQUALITY_TESTERS

	HASHABLE

create
	make,
	make_empty

feature{NONE} -- Initialization

	make (a_info_state: EPA_STATE)
			-- Initialize current with `a_inf_state', which contains information of a test case.
		local
			l_parts: LIST [STRING]
		do
			test_case_class := first_class_starts_with_name (a_info_state.item_with_expression_text (txt_tci_class_name).value.out)
			class_under_test := first_class_starts_with_name (a_info_state.item_with_expression_text (txt_tci_class_under_test).value.out)
			feature_under_test := class_under_test.feature_named (a_info_state.item_with_expression_text (txt_tci_feature_under_test).value.out)
			test_feature := test_case_class.feature_named ("generated_test_1")
			is_feature_under_test_query := a_info_state.item_with_expression_text (txt_tci_is_query).value.out.to_boolean
			is_feature_under_test_creation := a_info_state.item_with_expression_text (txt_tci_is_creation).value.out.to_boolean

			calculate_break_point_position
			operand_variable_indexes := a_info_state.item_with_expression_text (txt_tci_operand_variable_indexes).value.out
			setup_operand_map (operand_variable_indexes)
			setup_variables (test_case_class)
			hash_code := test_case_class.name_in_upper.hash_code


			l_parts := string_slices (test_case_class.name_in_upper, "__")
			if l_parts.last.item (1).is_digit then
				uuid := l_parts.last.twin
			else
				uuid := ""
			end
		end

	make_empty
			-- Initialize Current, but don't populate test case related attributes
		do
			hash_code := 0
		end

feature -- Access

	test_case_class: CLASS_C
			-- Test case class

	class_under_test: CLASS_C
			-- Class under test

	feature_under_test: FEATURE_I
			-- Feature under test

	test_feature: FEATURE_I
			-- Wrapping feature with execute `feature_under_test'

	before_test_break_point_slot: INTEGER
			-- Break point slot before the execution of `feature_under_test'

	after_test_break_point_slot: INTEGER
			-- Break point slot after the execution of `feature_under_test'

	finish_post_state_calculation_slot: INTEGER
			-- Break point slot after post state calculation finished

	operand_map: HASH_TABLE [STRING, INTEGER]
			-- Map from 0-based operand index in `feature_under_test' to locals in `test_feature'
			-- Key is operand index, value is the name of local in `test_feature'.

	variables: HASH_TABLE [TYPE_A, STRING]
			-- Variables in current test case
			-- Key is the case sensitive name of variable,
			-- value is the type of that variable.

	hash_code: INTEGER
			-- Hash code

	uuid: STRING
			-- UUID of `test_case_class'

	operand_variable_indexes: STRING
			-- Operand variable indexes
			-- Format: comma separated numbers, the i-th number is the object id of the i-th operand
			-- i starts from 0.

feature -- Status report

	is_feature_under_test_query: BOOLEAN
			-- Is `feature_under_test' a query?

	is_feature_under_test_creation: BOOLEAN
			-- Is `feature_under_test' a creation?

feature -- Access

	test_case_info_expressions: DS_HASH_SET [EPA_EXPRESSION]
			-- Expressions to query information of found test cases
		local
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_expr: EPA_AST_EXPRESSION
		do
			create Result.make (10)
			Result.set_equality_tester (expression_equality_tester)

			l_class := test_set_class
			l_feature := feat_setup_test_case

			create l_expr.make_with_text (l_class, l_feature, txt_tci_class_name, l_class)
			Result.force_last (l_expr)

			create l_expr.make_with_text (l_class, l_feature, txt_tci_class_under_test, l_class)
			Result.force_last (l_expr)

			create l_expr.make_with_text (l_class, l_feature, txt_tci_feature_under_test, l_class)
			Result.force_last (l_expr)

			create l_expr.make_with_text (l_class, l_feature, txt_tci_operand_variable_indexes, l_class)
			Result.force_last (l_expr)

			create l_expr.make_with_text (l_class, l_feature, txt_tci_is_creation, l_class)
			Result.force_last (l_expr)

			create l_expr.make_with_text (l_class, l_feature, txt_tci_is_query, l_class)
			Result.force_last (l_expr)
		end

	txt_tci_class_name: STRING = "tci_class_name"
	txt_tci_class_under_test: STRING = "tci_class_under_test"
	txt_tci_feature_under_test: STRING = "tci_feature_under_test"
	txt_tci_operand_variable_indexes: STRING = "tci_operand_variable_indexes"
	txt_tci_is_creation: STRING = "tci_is_creation"
	txt_tci_is_query: STRING = "tci_is_query"

	test_set_class: CLASS_C
			-- Class for the test set
		do
			Result := first_class_starts_with_name ("EQA_SERIALIZED_TEST_SET")
		end

	feat_setup_test_case: FEATURE_I
			-- Feature to setup test case
		do
			Result := test_set_class.feature_named ("setup_before_test")
		end

	calculate_break_point_position
			-- Calculate `before_test_break_point_slot' and `after_test_break_point_slot'.
		local
			l_bp_finder: CI_BEFORE_AFTER_TEST_BREAKPOINT_FINDER
			l_transformable: ETR_TRANSFORMABLE
			l_context: ETR_CLASS_CONTEXT
		do
			create l_context.make (test_case_class)
			create l_transformable.make (test_feature.e_feature.ast, l_context, True)
			l_transformable.calculate_breakpoint_slots

			create l_bp_finder
			l_bp_finder.find_break_points (l_transformable.to_ast)
			before_test_break_point_slot := l_bp_finder.before_test_break_point_slot
			after_test_break_point_slot := l_bp_finder.after_test_break_point_slot
			finish_post_state_calculation_slot := l_bp_finder.finish_post_state_calculation_slot
		end

	setup_operand_map (a_operands: STRING)
			-- Setup `opreand_map'.
			-- `a_operands' is a comma sparated list of integers, each integer represents the variable
			-- used as an operand in `feature_under_test'. The first integer is for target, the second
			-- integer is for the first argument, and so on. The last integer is for (possible) result value
			-- of the feature call.
		local
			l_indexes: LIST [STRING]
			i: INTEGER
			l_tbl: like operand_map
		do
			l_indexes := a_operands.split (',')
			create l_tbl.make (l_indexes.count)
			from
				i := 0
				l_indexes.start
			until
				l_indexes.after
			loop
				l_tbl.put (variable_name (l_indexes.item_for_iteration.to_integer), i)
				i := i + 1
				l_indexes.forth
			end
			operand_map := l_tbl
		end

	variable_name (a_index: INTEGER): STRING
			-- Name of variable with index `a_index'.
		do
			create Result.make (5)
			Result.append (once "v_")
			Result.append (a_index.out)
		end

	setup_variables (a_test_case_class: CLASS_C)
			-- Setup `variables' by analyzing the `generated_test_1' feature in `a_test_case_class'.
		local
			l_feature_context: ETR_FEATURE_CONTEXT
			l_locals: HASH_TABLE [ETR_TYPED_VAR, STRING]
			l_cursor: CURSOR
			l_variables: like variables
		do
			create l_feature_context.make (a_test_case_class.feature_named (test_feature_name), Void)
			l_locals := l_feature_context.local_by_name

			create l_variables.make (l_locals.count)
			l_variables.compare_objects
			variables := l_variables

			l_cursor := l_locals.cursor
			from
				l_locals.start
			until
				l_locals.after
			loop
				l_variables.put (l_locals.item_for_iteration.original_type, l_locals.key_for_iteration)
				l_locals.forth
			end
			l_locals.go_to (l_cursor)
		end

	test_feature_name: STRING = "generated_test_1"
			-- Name of the feature used in test case class as test entry

end
