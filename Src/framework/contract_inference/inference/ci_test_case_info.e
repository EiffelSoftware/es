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

	SEM_UTILITY

create
	make,
	make_empty,
	make_with_data,
	make_with_transition

feature{NONE} -- Initialization

	make (a_info_state: EPA_STATE)
			-- Initialize current with `a_inf_state', which contains information of a test case.
		local
			l_test_case_class: CLASS_C
			l_class_under_test: CLASS_C
		do

			l_test_case_class := first_class_starts_with_name (a_info_state.item_with_expression_text (txt_tci_class_name).value.out)
			l_class_under_test := first_class_starts_with_name (a_info_state.item_with_expression_text (txt_tci_class_under_test).value.out)
			make_with_data (
				l_test_case_class,
				l_test_case_class.feature_named ("generated_test_1"),
				l_class_under_test,
				l_class_under_test.feature_named (a_info_state.item_with_expression_text (txt_tci_feature_under_test).value.out),
				a_info_state.item_with_expression_text (txt_tci_is_query).value.out.to_boolean,
				a_info_state.item_with_expression_text (txt_tci_is_creation).value.out.to_boolean,
				a_info_state.item_with_expression_text (txt_tci_operand_variable_indexes).value.out,
				a_info_state.item_with_expression_text (txt_tci_is_passing).value.out.to_boolean)
		end

	make_empty
			-- Initialize Current, but don't populate test case related attributes
		do
			hash_code := 0
		end

	make_with_data (a_test_case_class: CLASS_C; a_test_feature: FEATURE_I; a_class_under_test: CLASS_C; a_feature_under_test: FEATURE_I; a_is_query: BOOLEAN; a_is_creation: BOOLEAN; a_operand_variable_indexes: STRING; a_passing: BOOLEAN)
			-- Initialize Current with data.
		local
			l_parts: LIST [STRING]
		do
			test_case_class := a_test_case_class
			class_under_test := a_class_under_test
			feature_under_test := a_feature_under_test
			test_feature := a_test_feature
			is_feature_under_test_query := a_is_query
			is_feature_under_test_creation := a_is_creation
			is_passing := a_passing

			calculate_break_point_position
			operand_variable_indexes := a_operand_variable_indexes.twin
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

	make_with_transition (a_test_case_class: CLASS_C; a_test_case_feature: FEATURE_I; a_transition: SEM_FEATURE_CALL_TRANSITION)
			-- Initialize Current with data.
		local
			l_parts: LIST [STRING]
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_var_name: STRING
			l_prefix_count: INTEGER
		do
			test_case_class := a_test_case_class
			class_under_test := a_transition.class_
			feature_under_test := a_transition.feature_
			test_feature := a_test_case_feature
			is_feature_under_test_query := a_transition.is_query
			is_feature_under_test_creation := a_transition.is_creation
			is_passing := a_transition.is_passing

			create operand_variable_indexes.make (64)
			l_prefix_count := variable_name_prefix.count
			across 0 |..| operand_count_of_feature (feature_under_test) as l_indexes loop
				if not operand_variable_indexes.is_empty then
					operand_variable_indexes.append_character (',')
				end
				operand_variable_indexes.append_integer (l_indexes.item)
				operand_variable_indexes.append_character (',')
				l_var_name := a_transition.reversed_variable_position.item (l_indexes.item).text
				l_var_name.remove_head (l_prefix_count)
				operand_variable_indexes.append_integer (l_var_name.to_integer)
			end

			setup_operand_map (operand_variable_indexes)

				-- Setup variables.
			create variables.make (20)
			variables.compare_objects
			from
				l_cursor := a_transition.variables.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				variables.force (l_cursor.item.type, l_cursor.item.text)
				l_cursor.forth
			end

			hash_code := test_case_class.name_in_upper.hash_code

				-- Setup UUID.
			if a_transition.uuid = Void then
				uuid := ""
			else
				uuid := a_transition.uuid
			end
		end

feature -- Access

	test_case_class: CLASS_C
			-- Test case class

	class_under_test: CLASS_C
			-- Class under test

	feature_under_test: FEATURE_I
			-- Feature under test

	test_feature: FEATURE_I
			-- Wrapping feature which executes `feature_under_test'

	before_test_break_point_slot: INTEGER
			-- Break point slot before the execution of `feature_under_test'

	after_test_break_point_slot: INTEGER
			-- Break point slot after the execution of `feature_under_test'

	finish_post_state_calculation_slot: INTEGER
			-- Break point slot after post state calculation finished

	finish_pre_state_calculation_slot: INTEGER
			-- Break point slot before pre-state calculation finished

	right_before_test_slot: INTEGER
			-- Break point slot right before the execution of the feature under test

	right_after_test_slot: INTEGER
			-- Break point slot right after the execution of the feature under test

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
			-- Format: comma separated numbers, for each pair of numbers,
			-- the first is the 0-based operand index, the second is the object id of that operand.

	recipient: detachable STRING
			-- The recipient feature if the transition to be written represents a failing test case

	recipient_class: detachable STRING
			-- The class of `recipient'  if the transition to be written represents a failing test case

	exception_break_point_slot: detachable STRING
			-- The break point slot of the exception if the transition to be written represents a failing test case

	exception_code: detachable STRING
			-- The error code of the exception if the transition to be written represents a failing test case

	exception_meaning: detachable STRING
			-- The error meaning of the exception if the transition to be written represents a failing test case

	exception_trace: detachable STRING
			-- Trace of the exception if the transition to be written represents a failing test case

	fault_id: detachable STRING
			-- Fault identifier if the transition to be written represents a failing test case

	exception_tag: detachable STRING
			-- Tag of the failing assertion  if the transition to be written represents a failing test case

feature -- Status report

	is_feature_under_test_query: BOOLEAN
			-- Is `feature_under_test' a query?

	is_feature_under_test_creation: BOOLEAN
			-- Is `feature_under_test' a creation?

	is_passing: BOOLEAN
			-- Is Current test case a passing test case?

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

			create l_expr.make_with_text (l_class, l_feature, txt_tci_is_passing, l_class)
			Result.force_last (l_expr)
		end

	txt_tci_class_name: STRING = "tci_class_name"
	txt_tci_class_under_test: STRING = "tci_class_under_test"
	txt_tci_feature_under_test: STRING = "tci_feature_under_test"
	txt_tci_operand_variable_indexes: STRING = "tci_operand_variable_indexes"
	txt_tci_is_creation: STRING = "tci_is_creation"
	txt_tci_is_query: STRING = "tci_is_query"
	txt_tci_is_passing: STRING = "tci_is_passing"

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

	feat_right_before_test: FEATURE_I
			-- Feature `right_before_test'
		do
			Result := test_set_class.feature_named ("right_before_test")
		end

	feat_right_after_test: FEATURE_I
			-- Feature `right_after_test'
		do
			Result := test_set_class.feature_named ("right_after_test")
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
			finish_pre_state_calculation_slot := l_bp_finder.finish_pre_state_calculation_slot
			right_before_test_slot := l_bp_finder.right_before_test_slot
			right_after_test_slot := l_bp_finder.right_after_test_slot
		end

	setup_operand_map (a_operands: STRING)
			-- Setup `opreand_map'.
			-- `a_operands' is a comma sparated list of integers. For each integer pair,
			-- the first number is the 0-based operand index, the second number is the object id of that operand.
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
				l_indexes.forth
				l_tbl.put (variable_name_with_default_prefix (l_indexes.item_for_iteration.to_integer), i)
				i := i + 1
				l_indexes.forth
			end
			operand_map := l_tbl
		end

	setup_variables (a_test_case_class: CLASS_C)
			-- Setup `variables' by analyzing the `generated_test_1' feature in `a_test_case_class'.
		local
			l_feature_context: ETR_FEATURE_CONTEXT
			l_locals: HASH_TABLE [ETR_TYPED_VAR, STRING]
			l_cursor: CURSOR
			l_variables: like variables
			l_class_ctxt: ETR_CLASS_CONTEXT
			l_typed_var: ETR_TYPED_VAR
			l_feat_tbl: FEATURE_TABLE
			l_fcursor: CURSOR
			l_var_prefix: STRING
			l_type: TYPE_A
		do
			l_var_prefix := variable_name_prefix
			l_feat_tbl := a_test_case_class.feature_table

			create l_locals.make (20)
			l_locals.compare_objects
			l_fcursor := l_feat_tbl.cursor
			from
				l_feat_tbl.start
			until
				l_feat_tbl.after
			loop
				if l_feat_tbl.item_for_iteration.feature_name.starts_with (l_var_prefix) then
					l_type := l_feat_tbl.item_for_iteration.type
					create l_typed_var.make (l_feat_tbl.item_for_iteration.feature_name, l_type, l_type)
					l_locals.force (l_typed_var, l_typed_var.name)
				end
				l_feat_tbl.forth
			end
			l_feat_tbl.go_to (l_fcursor)

			create l_class_ctxt.make (a_test_case_class)
			create l_feature_context.make (a_test_case_class.feature_named (test_feature_name), l_class_ctxt)
--			l_locals := l_feature_context.local_by_name

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

feature -- Setting

	set_recipient (a_data: like recipient)
			-- Set `recipient' with `a_data'.
		do
			recipient := a_data
		ensure
			recipient_set: recipient = a_data
		end

	set_recipient_class (a_data: like recipient_class)
			-- Set `recipient_class' with `a_data'.
		do
			recipient_class := a_data
		ensure
			recipient_class_set: recipient_class = a_data
		end

	set_exception_break_point_slot (a_data: like exception_break_point_slot)
			-- Set `exception_break_point_slot' with `a_data'.
		do
			exception_break_point_slot := a_data
		ensure
			exception_break_point_slot_set: exception_break_point_slot = a_data
		end

	set_exception_code (a_data: like exception_code)
			-- Set `exception_code' with `a_data'.
		do
			exception_code := a_data
		ensure
			exception_code_set: exception_code = a_data
		end

	set_exception_meaning (a_data: like exception_meaning)
			-- Set `exception_meaning' with `a_data'.
		do
			exception_meaning := a_data
		ensure
			exception_meaning_set: exception_meaning = a_data
		end

	set_exception_trace (a_data: like exception_trace)
			-- Set `exception_trace' with `a_data'.
		do
			exception_trace := a_data
		ensure
			exception_trace_set: exception_trace = a_data
		end

	set_fault_id (a_data: like fault_id)
			-- Set `fault_id' with `a_data'.
		do
			fault_id := a_data
		ensure
			fault_id_set: fault_id = a_data
		end

	set_exception_tag (a_data: like exception_tag)
			-- Set `exception_tag' with `a_data'.
		do
			exception_tag := a_data
		ensure
			exception_tag_set: exception_tag = a_data
		end

	calculate_fault_id
			-- Calculate `fault_id' based on already set exception related information.
		local
			l_id: STRING
		do
			create l_id.make (64)
			if recipient_class /= Void then
				l_id.append (recipient_class)

			end
			if recipient /= Void then
				if not l_id.is_empty then
					l_id.append_character ('.')
				end
				l_id.append (recipient)
			end
			if exception_code /= Void then
				if not l_id.is_empty then
					l_id.append_character ('.')
				end
				l_id.append_character ('c')
				l_id.append (exception_code)
			end
			if exception_break_point_slot /= Void then
				if not l_id.is_empty then
					l_id.append_character ('.')
				end
				l_id.append_character ('b')
				l_id.append (exception_break_point_slot)
			end

			set_fault_id (l_id)
		end

end
