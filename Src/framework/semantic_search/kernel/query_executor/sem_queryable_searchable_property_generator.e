note
	description: "Class to generate searchable properties for a queryable"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_QUERYABLE_SEARCHABLE_PROPERTY_GENERATOR

inherit
	SEM_UTILITY

	EPA_CONTRACT_EXTRACTOR

	AST_ITERATOR
		redefine
			process_expr_call_as,
			process_bin_eq_as,
			process_bin_ne_as,
			process_bin_lt_as,
			process_bin_le_as,
			process_bin_ge_as,
			process_bin_gt_as,
			process_binary_as,
			process_un_not_as
		end

feature --Basic operations

	objects_from_feature (a_feature: FEATURE_I; a_class: CLASS_C): SEM_OBJECTS
			-- Semantic objects which contains arguments in `a_feature' from `a_class'
		local
			l_context: EPA_CONTEXT
			l_vcursor: CURSOR
			l_var: EPA_EXPRESSION
			i: INTEGER
			l_variables: DS_HASH_TABLE [INTEGER, EPA_EXPRESSION]
		do
				-- Create context.
			l_context := context_from_feature (a_feature, a_class, False)
			l_vcursor := l_context.variables.cursor

				-- Setup variable positions.
			create l_variables.make (10)
			from
				i := 1
				l_context.variables.start
			until
				l_context.variables.after
			loop
				l_var := variable_expression_from_context (l_context.variables.key_for_iteration, l_context)
				l_variables.force_last (i, l_var)
				i := i + 1
				l_context.variables.forth
			end
			l_context.variables.go_to (l_vcursor)

				-- Construct final result.
			create Result.make (l_context, l_variables)
		end

	transition_from_feature (a_feature: FEATURE_I; a_class: CLASS_C): SEM_FEATURE_CALL_TRANSITION
			-- Semantic feature call transition which contains arguments in `a_feature' from `a_class'
		local
			l_context: EPA_CONTEXT
			l_vcursor: CURSOR
			l_var: EPA_EXPRESSION
			i: INTEGER
			l_variables: HASH_TABLE [STRING, INTEGER]
			l_context_type: TYPE_A
		do
				-- Create context.
			l_context := context_from_feature (a_feature, a_class, False)
			l_vcursor := l_context.variables.cursor

				-- Setup variable positions.
			create l_variables.make (10)
			from
				i := 1
				l_context.variables.start
			until
				l_context.variables.after
			loop
				l_variables.force (l_context.variables.key_for_iteration, i)
				i := i + 1
				l_context.variables.forth
			end
			l_context.variables.go_to (l_vcursor)

				-- Construct final result.
			l_context_type := a_class.actual_type
			create Result.make_with_context_type (a_class, a_feature, l_variables, l_context, False, l_context_type)
		end

	queryable_from_feature (a_feature: FEATURE_I; a_class: CLASS_C): SEM_QUERYABLE
			-- Semantic queryable from `a_feature' in `a_class'
			-- If `a_feature' has postcondition, return a transition queryable,
			-- otherwise return an object queryable.
		local
			l_objects: SEM_OBJECTS
			l_feature: SEM_FEATURE_CALL_TRANSITION
		do
			if postcondition_of_feature (a_feature, a_class).is_empty then
				l_objects := objects_from_feature (a_feature, a_class)
				add_properties_in_objects (l_objects, a_feature, a_class, True)
				Result := l_objects
			else
				l_feature := transition_from_feature (a_feature, a_class)
				add_properties_in_feature_transition (l_feature, a_feature, a_class)
				Result := l_feature
			end
		end

	queryable_from_feature_names (a_feature: STRING; a_class: STRING): detachable SEM_QUERYABLE
			-- Semantic queryable from `a_feature' in `a_class'
			-- If `a_feature' has postcondition, return a transition queryable,
			-- otherwise return an object queryable.
		local
			l_objects: SEM_OBJECTS
			l_feature: SEM_FEATURE_CALL_TRANSITION
			l_class_c: CLASS_C
			l_feature_i: FEATURE_I
		do
			l_class_c := first_class_starts_with_name (a_class)
			if l_class_c /= Void then
				l_feature_i := l_class_c.feature_named (a_feature)
				if l_feature_i /= Void then
					Result := queryable_from_feature (l_feature_i, l_class_c)
				end
			end
		end

	query_config_from_queryable (a_queryable: SEM_QUERYABLE): SEM_QUERY_CONFIG
			-- Query config from `a_queryable'
		do
			if a_queryable.is_objects then
				create Result.make_with_primary_type_form (a_queryable, dynamic_type_form)
			else
				create Result.make_with_primary_type_form (a_queryable, static_type_form)
			end
			Result.add_default_searchable_properties (Void, agent (a_term: SEM_TERM): INTEGER do Result := {IR_TERM_OCCURRENCE}.term_occurrence_must end)
		end

feature -- Basic operations

	add_properties_in_objects (a_objects: SEM_OBJECTS; a_feature: FEATURE_I; a_class: CLASS_C; a_use_precondition: BOOLEAN)
			-- Add searchable properties into `a_objects'
			-- If `a_use_precondition' is True, add prconditions from `a_feature' in `a_class' as searchable properties,
			-- otherwise, add postconditions from the same feature.
		do
				-- Initialize.
			is_for_objects := True
			is_for_feature_transition := False
			is_in_precondition := a_use_precondition
			is_in_postcondition := not is_in_precondition
			queryable := a_objects
			context_class := a_class
			context_feature := a_feature

				-- Iterate through all assertions in pre- or post-condition of `a_feature'.
			across contracts_of_feature (a_feature, a_class, a_use_precondition) as l_constraints loop
				last_expression := l_constraints.item
				last_tag := last_expression.tag
				process_expression (last_expression.ast, last_tag)
			end
		end

	add_properties_in_feature_transition (a_feature_transition: SEM_FEATURE_CALL_TRANSITION; a_feature: FEATURE_I; a_class: CLASS_C)
			-- Add searchable properties into `a_feature_transition'
		do
				-- Initialize.
			is_for_objects := False
			is_for_feature_transition := True
			queryable := a_feature_transition
			context_class := a_class
			context_feature := a_feature

				-- Iterate through all assertions in precondition of `a_feature'.
			is_in_precondition := True
			is_in_postcondition := False
			across precondition_of_feature (a_feature, a_class) as l_constraints loop
				last_expression := l_constraints.item
				last_tag := last_expression.tag
				process_expression (last_expression.ast, last_tag)
			end

				-- Iterate through all assertions in postcondition of `a_feature'.
			is_in_precondition := False
			is_in_postcondition := True
			across postcondition_of_feature (a_feature, a_class) as l_constraints loop
				last_expression := l_constraints.item
				last_tag := last_expression.tag
				process_expression (last_expression.ast, last_tag)
			end
		end

feature{NONE} -- Implementation

	queryable: SEM_QUERYABLE
			-- The queryable for which searchable properties are generated

	queryable_as_objects: SEM_OBJECTS
			-- Objects from `queryable'
		require
			queryable_is_objects: queryable.is_objects
		do
			check attached {SEM_OBJECTS} queryable as l_objects then
				Result := l_objects
			end
		end

	queryable_as_feature_transition: SEM_FEATURE_CALL_TRANSITION
			-- Feature transition from `queryable'
		require
			queryable_is_objects: queryable.is_feature_call
		do
			check attached {SEM_FEATURE_CALL_TRANSITION} queryable as l_feature then
				Result := l_feature
			end
		end

	context_from_feature (a_feature: FEATURE_I; a_class: CLASS_C; a_target: BOOLEAN): EPA_CONTEXT
			-- Context containing all arguments in `a_feature' from `a_class'
		do
			create Result.make_with_class_and_feature (a_class, a_feature, True, False, a_target)
		end

	context_class: CLASS_C
			-- Context class

	context_feature: FEATURE_I
			-- Context feature

feature{NONE} -- Implementation

	is_for_objects: BOOLEAN
			-- Is Current process for objects?

	is_for_feature_transition: BOOLEAN
			-- Is Current process for feature transition?

	is_in_precondition: BOOLEAN
			-- Is Current processing precondition?

	is_in_postcondition: BOOLEAN
			-- Is Current processing postcondition?

	last_expression: EPA_EXPRESSION
			-- Last processed expression

	last_tag: detachable STRING
			-- Last processed tag

feature{NONE} -- Process

	process_expression (a_expr: EXPR_AS; a_tag: detachable STRING)
			-- Process `a_expr'.
		do
			a_expr.process (Current)
		end

	process_expr_call_as (l_as: EXPR_CALL_AS)
		do
			put_expression_equal_to_true (l_as)
		end

	process_bin_eq_as (l_as: BIN_EQ_AS)
		local
			l_left: EXPR_AS
			l_right: EXPR_AS
		do
			l_left := ast_with_paran_removed (l_as.left)
			l_right := ast_with_paran_removed (l_as.right)
			if attached {INTEGER_AS} l_right as l_integer then
					-- expr = int
				put_expression_equal_to_integer (l_left, l_integer)
			elseif attached {BOOL_AS} l_right as l_bool then
					-- expr = boolean
				put_expression_equal_to_boolean (l_left, l_bool.value)
			else
				if attached {UN_OLD_AS} l_right as l_old then
						-- expr1 = old expr2
					l_right := ast_with_paran_removed (l_old.expr)
					if text_from_ast (l_left) ~ text_from_ast (l_right) then
							-- expr = old expr
						put_expression_equal_to_old (l_left)
					else
						put_expression_equal_to_true (l_as)
					end
				else
					if attached {BIN_PLUS_AS} l_right as l_plus and then attached {INTEGER_AS} l_plus.right as l_int then
							-- expr1 = expr2 + int
						l_right := ast_with_paran_removed (l_plus.left)
						if attached {UN_OLD_AS} l_right as l_old then
								-- expr1 = old expr2 + int
							l_right := ast_with_paran_removed (l_old.expr)
							if text_from_ast (l_right) ~ text_from_ast (l_left) then
									-- expr = old expr + int								
								put_integer_expression_increased (l_left, l_int.integer_32_value, l_int.integer_32_value)
							else
									-- expr = expr
								put_expression_equal_to_true (l_as)
							end
						else
								-- expr = expr
							put_expression_equal_to_true (l_as)
						end
					elseif attached {BIN_MINUS_AS} l_right as l_minus and then attached {INTEGER_AS} l_minus.right as l_int  then
							-- expr1 = expr2 - int
						l_right := ast_with_paran_removed (l_minus.left)
						if attached {UN_OLD_AS} l_right as l_old then
								-- expr1 = old expr2 - int
							l_right := ast_with_paran_removed (l_old.expr)
							if text_from_ast (l_right) ~ text_from_ast (l_left) then
									-- expr = old expr - int								
								put_integer_expression_decreased (l_left, l_int.integer_32_value, l_int.integer_32_value)
							else
									-- expr = expr
								put_expression_equal_to_true (l_as)
							end
						else
								-- expr = expr
							put_expression_equal_to_true (l_as)
						end
					else
							-- expr = expr
						put_expression_equal_to_true (l_as)
					end
				end
			end
		end

	process_bin_ne_as (l_as: BIN_NE_AS)
		local
			l_left: EXPR_AS
			l_right: EXPR_AS
			l_expression: EPA_AST_EXPRESSION
		do
			l_left := ast_with_paran_removed (l_as.left)
			l_right := ast_with_paran_removed (l_as.right)
			if attached {UN_OLD_AS} l_right as l_old then
				l_right := ast_with_paran_removed (l_old.expr)
				if text_from_ast (l_left) ~ text_from_ast (l_right) then
						-- expr /= old expr
					check is_in_postcondition end
					check is_for_feature_transition end
					create l_expression.make_with_text (context_class, context_feature, text_from_ast (l_left), context_class)
					queryable_as_feature_transition.changes.force_last (value_any_change (l_expression, False), l_expression)
				else
					put_expression_equal_to_true (l_as)
				end
			elseif attached {INTEGER_AS} l_right as l_integer then
					-- expr /= int
				put_expression_equal_to_integer_exclusion (l_left, l_integer)
			else
				put_expression_equal_to_true (l_as)
			end
		end

	process_bin_ge_as (l_as: BIN_GE_AS)
		local
			l_left: EXPR_AS
			l_right: EXPR_AS
			l_left2, l_right2: EXPR_AS
		do
			l_left := ast_with_paran_removed (l_as.left)
			l_right := ast_with_paran_removed (l_as.right)
			if attached {INTEGER_AS} l_right as l_integer then
					-- expr >= int
				put_expression_larger_than_integer (l_left, l_integer.integer_32_value, False)
			else
				if attached {UN_OLD_AS} l_right as l_old then
						-- expr1 >= old expr2
					l_right := ast_with_paran_removed (l_old.expr)
					if text_from_ast (l_left) ~ text_from_ast (l_right) then
							-- expr >= old expr
						put_integer_expression_increased (l_left, 0, 100)
					else
						put_expression_equal_to_true (l_as)
					end
				elseif attached {BIN_PLUS_AS} l_right as l_plus then
					l_left2 := ast_with_paran_removed (l_plus.left)
					l_right2 := ast_with_paran_removed (l_plus.right)
					if
						attached {UN_OLD_AS} l_left2 as l_old and then
						text_from_ast (ast_with_paran_removed (l_old.expr)) ~ text_from_ast (l_left) and then
						attached {INTEGER_AS} l_right2 as l_int
					then
							-- expr >= old expr + int
						put_integer_expression_increased (l_left, l_int.integer_32_value, l_int.integer_32_value + 100)
					else
						put_expression_equal_to_true (l_as)
					end
				elseif attached {BIN_MINUS_AS} l_right as l_plus then
					l_left2 := ast_with_paran_removed (l_plus.left)
					l_right2 := ast_with_paran_removed (l_plus.right)
					if
						attached {UN_OLD_AS} l_left2 as l_old and then
						text_from_ast (ast_with_paran_removed (l_old.expr)) ~ text_from_ast (l_left) and then
						attached {INTEGER_AS} l_right2 as l_int
					then
							-- expr >= old expr - int
						put_integer_expression_increased (l_left, - l_int.integer_32_value, - l_int.integer_32_value + 100)
					else
						put_expression_equal_to_true (l_as)
					end
				else
					put_expression_equal_to_true (l_as)
				end
			end
		end

	process_bin_gt_as (l_as: BIN_GT_AS)
		local
			l_left: EXPR_AS
			l_right: EXPR_AS
			l_left2, l_right2: EXPR_AS
		do
			l_left := ast_with_paran_removed (l_as.left)
			l_right := ast_with_paran_removed (l_as.right)
			if attached {INTEGER_AS} l_right as l_integer then
					-- expr > int
				put_expression_larger_than_integer (l_left, l_integer.integer_32_value, True)
			else
				if attached {UN_OLD_AS} l_right as l_old then
						-- expr1 > old expr2
					l_right := ast_with_paran_removed (l_old.expr)
					if text_from_ast (l_left) ~ text_from_ast (l_right) then
							-- expr > old expr
						put_integer_expression_increased (l_left, 1, 100)
					else
						put_expression_equal_to_true (l_as)
					end
				elseif attached {BIN_PLUS_AS} l_right as l_plus then
					l_left2 := ast_with_paran_removed (l_plus.left)
					l_right2 := ast_with_paran_removed (l_plus.right)
					if
						attached {UN_OLD_AS} l_left2 as l_old and then
						text_from_ast (ast_with_paran_removed (l_old.expr)) ~ text_from_ast (l_left) and then
						attached {INTEGER_AS} l_right2 as l_int
					then
							-- expr > old expr + int
						put_integer_expression_increased (l_left, l_int.integer_32_value + 1, l_int.integer_32_value + 100)
					else
						put_expression_equal_to_true (l_as)
					end
				elseif attached {BIN_MINUS_AS} l_right as l_plus then
					l_left2 := ast_with_paran_removed (l_plus.left)
					l_right2 := ast_with_paran_removed (l_plus.right)
					if
						attached {UN_OLD_AS} l_left2 as l_old and then
						text_from_ast (ast_with_paran_removed (l_old.expr)) ~ text_from_ast (l_left) and then
						attached {INTEGER_AS} l_right2 as l_int
					then
							-- expr > old expr - int
						put_integer_expression_increased (l_left, - l_int.integer_32_value + 1, - l_int.integer_32_value + 100)
					else
						put_expression_equal_to_true (l_as)
					end
				else
					put_expression_equal_to_true (l_as)
				end
			end
		end

	process_bin_le_as (l_as: BIN_LE_AS)
		local
			l_left: EXPR_AS
			l_right: EXPR_AS
			l_left2, l_right2: EXPR_AS
		do
			l_left := ast_with_paran_removed (l_as.left)
			l_right := ast_with_paran_removed (l_as.right)
			if attached {INTEGER_AS} l_right as l_integer then
					-- expr > int
				put_expression_less_than_integer (l_left, l_integer.integer_32_value, False)
			else
				if attached {UN_OLD_AS} l_right as l_old then
						-- expr1 < old expr2
					l_right := ast_with_paran_removed (l_old.expr)
					if text_from_ast (l_left) ~ text_from_ast (l_right) then
							-- expr < old expr
						put_integer_expression_decreased (l_left, -100, 0)
					else
						put_expression_equal_to_true (l_as)
					end
				elseif attached {BIN_PLUS_AS} l_right as l_plus then
					l_left2 := ast_with_paran_removed (l_plus.left)
					l_right2 := ast_with_paran_removed (l_plus.right)
					if
						attached {UN_OLD_AS} l_left2 as l_old and then
						text_from_ast (ast_with_paran_removed (l_old.expr)) ~ text_from_ast (l_left) and then
						attached {INTEGER_AS} l_right2 as l_int
					then
							-- expr <= old expr + int
						put_integer_expression_decreased (l_left, l_int.integer_32_value - 100, l_int.integer_32_value)
					else
						put_expression_equal_to_true (l_as)
					end
				elseif attached {BIN_MINUS_AS} l_right as l_plus then
					l_left2 := ast_with_paran_removed (l_plus.left)
					l_right2 := ast_with_paran_removed (l_plus.right)
					if
						attached {UN_OLD_AS} l_left2 as l_old and then
						text_from_ast (ast_with_paran_removed (l_old.expr)) ~ text_from_ast (l_left) and then
						attached {INTEGER_AS} l_right2 as l_int
					then
							-- expr <= old expr - int
						put_integer_expression_decreased (l_left, - l_int.integer_32_value - 100, - l_int.integer_32_value)
					else
						put_expression_equal_to_true (l_as)
					end
				else
					put_expression_equal_to_true (l_as)
				end
			end
		end

	process_bin_lt_as (l_as: BIN_LT_AS)
		local
			l_left: EXPR_AS
			l_right: EXPR_AS
			l_left2, l_right2: EXPR_AS
		do
			l_left := ast_with_paran_removed (l_as.left)
			l_right := ast_with_paran_removed (l_as.right)
			if attached {INTEGER_AS} l_right as l_integer then
					-- expr > int
				put_expression_less_than_integer (l_left, l_integer.integer_32_value, True)
			else
				if attached {UN_OLD_AS} l_right as l_old then
						-- expr1 < old expr2
					l_right := ast_with_paran_removed (l_old.expr)
					if text_from_ast (l_left) ~ text_from_ast (l_right) then
							-- expr < old expr
						put_integer_expression_decreased (l_left, -100, -1)
					else
						put_expression_equal_to_true (l_as)
					end
				elseif attached {BIN_PLUS_AS} l_right as l_plus then
					l_left2 := ast_with_paran_removed (l_plus.left)
					l_right2 := ast_with_paran_removed (l_plus.right)
					if
						attached {UN_OLD_AS} l_left2 as l_old and then
						text_from_ast (ast_with_paran_removed (l_old.expr)) ~ text_from_ast (l_left) and then
						attached {INTEGER_AS} l_right2 as l_int
					then
							-- expr < old expr + int
						put_integer_expression_decreased (l_left, l_int.integer_32_value - 100, l_int.integer_32_value - 1)
					else
						put_expression_equal_to_true (l_as)
					end
				elseif attached {BIN_MINUS_AS} l_right as l_plus then
					l_left2 := ast_with_paran_removed (l_plus.left)
					l_right2 := ast_with_paran_removed (l_plus.right)
					if
						attached {UN_OLD_AS} l_left2 as l_old and then
						text_from_ast (ast_with_paran_removed (l_old.expr)) ~ text_from_ast (l_left) and then
						attached {INTEGER_AS} l_right2 as l_int
					then
							-- expr <= old expr - int
						put_integer_expression_decreased (l_left, - l_int.integer_32_value - 100, - l_int.integer_32_value - 1)
					else
						put_expression_equal_to_true (l_as)
					end
				else
					put_expression_equal_to_true (l_as)
				end
			end
		end

	process_binary_as (l_as: BINARY_AS)
		do
			put_expression_equal_to_true (l_as)
		end

	process_un_not_as (l_as: UN_NOT_AS)
			-- Process `l_as'.
		local
			l_expr: EXPR_AS
		do
			l_expr := ast_with_paran_removed (l_as.expr)
			put_expression_equal_to_boolean (l_expr, False)
		end

feature{NONE} -- Implementation

	put_expression_equal_to_old (a_expr: EXPR_AS)
			-- Add "a_expr = old a_expr" into `queryable'.
		local
			l_expr: EPA_AST_EXPRESSION
		do
			check is_in_postcondition end
			check is_for_feature_transition end
			create l_expr.make_with_text (context_class, context_feature, text_from_ast (a_expr), context_class)
			queryable_as_feature_transition.changes.force_last (value_any_change (l_expr, True), l_expr)
		end

	put_integer_expression_increased (a_expr: EXPR_AS; a_lower: INTEGER; a_upper: INTEGER)
			-- Add "a_expr > old expr" if `a_strict' is True; otherwise "a_expr >= old expr" into `queryable'.
		local
			l_expression: EPA_AST_EXPRESSION
		do
			check is_in_postcondition end
			check is_for_feature_transition end

			create l_expression.make_with_text (context_class, context_feature, text_from_ast (a_expr), context_class)
			queryable_as_feature_transition.changes.force_last (value_range_change (l_expression, a_lower, a_upper, True), l_expression)
		end

	put_integer_expression_decreased (a_expr: EXPR_AS; a_lower: INTEGER; a_upper: INTEGER)
			-- Add "a_expr > old expr" if `a_strict' is True; otherwise "a_expr <= old expr" into `queryable'.
		local
			l_expression: EPA_AST_EXPRESSION
		do
			check is_in_postcondition end
			check is_for_feature_transition end

			create l_expression.make_with_text (context_class, context_feature, text_from_ast (a_expr), context_class)
			queryable_as_feature_transition.changes.force_last (value_range_change (l_expression, a_lower, a_upper, True), l_expression)
		end

	put_expression_larger_than_integer (a_expr: EXPR_AS; a_integer: INTEGER; a_strict: BOOLEAN)
			-- Add "a_expr > a_integer" if `a_strict' is True; otherwise "a_expr >= a_integer" into `queryable'.
		local
			l_expression: EPA_AST_EXPRESSION
			l_value: EPA_NUMERIC_RANGE_VALUE
			l_equation: EPA_EQUATION
			l_lower: INTEGER
			l_upper: INTEGER
		do
			create l_expression.make_with_text (context_class, context_feature, text_from_ast (a_expr), context_class)
			if a_strict then
				l_lower := a_integer
			else
				l_lower := a_integer + 1
			end
			l_upper := l_lower + 100
			create l_value.make (l_lower, l_upper)
			put_expression_equality (l_expression, l_value, False)
		end

	put_expression_less_than_integer (a_expr: EXPR_AS; a_integer: INTEGER; a_strict: BOOLEAN)
			-- Add "a_expr < a_integer" if `a_strict' is True; otherwise "a_expr <= a_integer" into `queryable'.
		local
			l_expression: EPA_AST_EXPRESSION
			l_value: EPA_NUMERIC_RANGE_VALUE
			l_equation: EPA_EQUATION
			l_lower: INTEGER
			l_upper: INTEGER
		do
			create l_expression.make_with_text (context_class, context_feature, text_from_ast (a_expr), context_class)
			if a_strict then
				l_upper := a_integer - 1
			else
				l_upper := a_integer
			end
			l_lower := l_upper - 100
			create l_value.make (l_lower, l_upper)
			put_expression_equality (l_expression, l_value, False)
		end

	put_expression_equal_to_true (a_expr: EXPR_AS)
			-- Add "a_expr = True" into `queryable'.
		local
			l_expression: EPA_AST_EXPRESSION
			l_value: EPA_BOOLEAN_VALUE
			l_equation: EPA_EQUATION
		do
			create l_expression.make_with_text (context_class, context_feature, text_from_ast (a_expr), context_class)
			create l_value.make (True)
			put_expression_equality (l_expression, l_value, False)
		end

	put_expression_equal_to_integer (a_expr: EXPR_AS; a_integer: INTEGER_AS)
			-- Add a searchable property "a_expr = a_integer' into `queryable'.
		local
			l_expression: EPA_AST_EXPRESSION
			l_value: EPA_INTEGER_VALUE
		do
			create l_expression.make_with_feature (context_class, context_feature, a_expr, context_class)
			create l_value.make (a_integer.integer_32_value)
			put_expression_equality (l_expression, l_value, False)
		end

	put_expression_equal_to_integer_exclusion (a_expr: EXPR_AS; a_integer: INTEGER_AS)
			-- Add a searchable property "a_expr /= a_integer' into `queryable'.
		local
			l_expression: EPA_AST_EXPRESSION
			l_value: EPA_INTEGER_VALUE
		do
			create l_expression.make_with_feature (context_class, context_feature, a_expr, context_class)
			create l_value.make (a_integer.integer_32_value)
			put_expression_equality (l_expression, l_value, True)
		end

	put_expression_equal_to_boolean (a_expr: EXPR_AS; a_boolean: BOOLEAN)
			-- Add a searchable property "a_expr = a_boolean' into `queryable'.
		local
			l_expression: EPA_AST_EXPRESSION
			l_value: EPA_BOOLEAN_VALUE
		do
			create l_expression.make_with_feature (context_class, context_feature, a_expr, context_class)
			create l_value.make (a_boolean)
			put_expression_equality (l_expression, l_value, False)
		end

	put_expression_equality (a_expression: EPA_EXPRESSION; a_value: EPA_EXPRESSION_VALUE; a_negated: BOOLEAN)
			-- Put "a_expression = a_value" into `queryable'.
		local
			l_equation: EPA_EQUATION
		do
			if is_for_objects then
					-- Add current property as a property of objects.
				create l_equation.make (a_expression, a_value)
				l_equation.set_is_negated (a_negated)
				queryable_as_objects.properties.force_last (l_equation)
			elseif is_for_feature_transition then
				if is_in_precondition then
						-- Add current property as a precondition of a feature transition.
					create l_equation.make (a_expression, a_value)
					l_equation.set_is_negated (a_negated)
					queryable_as_feature_transition.preconditions.force_last (l_equation)
				elseif is_in_postcondition then
						-- Add current property as a absolute change of a feature transition.					
					queryable_as_feature_transition.changes.force_last (value_change (a_expression, create {EPA_AST_EXPRESSION}.make_with_text (context_class, context_feature, a_value.item.out, context_class), False, a_negated), a_expression)
				end
			end
		end

	value_range_change (a_expression: EPA_EXPRESSION; a_lower: INTEGER; a_upper: INTEGER; a_relative: BOOLEAN): LINKED_LIST [EPA_EXPRESSION_CHANGE]
			-- Value range change.
		local
			l_change_set: EPA_INTEGER_RANGE
			l_change: EPA_EXPRESSION_CHANGE
		do
			create l_change_set.make (context_class, a_lower, a_upper)
			create Result.make
			create l_change.make (a_expression, l_change_set, a_relative)
			Result.extend (l_change)
		end

	value_change (a_expression: EPA_EXPRESSION; a_value: EPA_EXPRESSION; a_relative: BOOLEAN; a_negated: BOOLEAN): LINKED_LIST [EPA_EXPRESSION_CHANGE]
			-- Value change.
		local
			l_change_set: EPA_EXPRESSION_ENUMERATION_CHANGE_SET
			l_change: EPA_EXPRESSION_CHANGE
		do
			create l_change_set.make (1)
			l_change_set.force_last (a_value)
			create Result.make
			create l_change.make (a_expression, l_change_set, a_relative)
			l_change.set_is_negated (a_negated)
			Result.extend (l_change)
		end

	value_any_change (a_expression: EPA_EXPRESSION; a_negated: BOOLEAN): LINKED_LIST [EPA_EXPRESSION_CHANGE]
			-- Any change set.
		local
			l_change_set: EPA_EXPRESSION_ENUMERATION_CHANGE_SET
			l_change: EPA_EXPRESSION_CHANGE
			l_value: EPA_ANY_VALUE
			l_expr: EPA_AST_EXPRESSION
		do
			create l_expr.make_with_text (context_class, context_feature, any_value, context_class)
			create l_change_set.make (1)
			l_change_set.force_last (l_expr)

			create Result.make
			create l_change.make (a_expression, l_change_set, True)
			l_change.set_is_negated (a_negated)
			Result.extend (l_change)
		end

	ast_with_paran_removed (a_expr: EXPR_AS): EXPR_AS
			-- Expression AST from `a_expr' with the outer parentheis removed
		local
			l_done: BOOLEAN
		do
			from
				Result := a_expr
			until
				l_done
			loop
				if attached {PARAN_AS} Result as l_paran then
					Result := l_paran.expr
				else
					l_done := True
				end
			end
		end

end
