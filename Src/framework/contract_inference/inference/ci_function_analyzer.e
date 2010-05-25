note
	description: "Analyzer to extract functions from test case state expressions"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_FUNCTION_ANALYZER

inherit
	REFACTORING_HELPER

	EPA_SHARED_EQUALITY_TESTERS

	KL_SHARED_STRING_EQUALITY_TESTER

	EPA_UTILITY

	EPA_STRING_UTILITY

feature -- Access

	valuations: DS_HASH_TABLE [EPA_FUNCTION_VALUATIONS, EPA_FUNCTION]
			-- Valuations of functions
			-- Key is a function, value is the argument(s) to value mapping for that function.

feature -- Basic operations

	analyze (a_state: EPA_STATE; a_context: EPA_CONTEXT; a_operand_map: HASH_TABLE [STRING, INTEGER]; a_class: CLASS_C; a_feature: FEATURE_I; a_context_type: TYPE_A)
			-- Analyze functions in `a_state' and make result avaiable in `valuations'.
			-- `a_state' contains a set of expressions along with their values. Functions and
			-- mappings are extracted from `a_state'.
			-- `a_context' provides the set of variables that can be used as arguments of functions.
			-- That is, only variables in `a_context' are considered as arguments of to-be-extracted functions,
			-- all other literals are considered as part of the function body.
			-- The order of arguments for a particular function is decided by the order of the variable appearance in
			-- parse sense. For example in the expression "v1.has (v2)", the function {1}.has ({2}) will be extracted,
			-- and the first argument is v1 because it is first analyzed when parsing the expressions (target of feature call
			-- is parsed first), and v2 will be the second argument of that function.
			-- The expressions in `a_state' are related to `a_feature' viewed in `a_class'.
			-- `a_operand_map' is a map from 0-based operand index in `a_feature' to locals in `a_context'
			-- Key is operand index, value is the name of local in `a_context'.
			--`a_context_type' is the context type in which types are resolved, if necessary.
		do
			fixme ("This is an easy prototype implementation, take the advantage that the expressions are all qualified calls with at most one argument. 17.5.2010 Jasonw")
			class_ := a_class
			feature_ := a_feature
			context := a_context
			operand_map := a_operand_map
			context_type := a_context_type
			build_data_structure

				-- Iterate through `a_state' and analyze each equation.
			create valuations.make (10)
			valuations.set_key_equality_tester (function_equality_tester)
			a_state.do_all (agent analyze_equation)
		end

feature{NONE} -- Implementation

	class_: CLASS_C
			-- Class where `feature_' is viewed

	feature_: FEATURE_I
			-- Feature whose state are being analyzed

	context: EPA_CONTEXT
			-- Context containing variable information

	operand_map: HASH_TABLE [STRING, INTEGER]
			-- Map from 0-based operand index for `feature_' to variable names in `context'

	context_type: TYPE_A
			-- Context type in which types are resolved

	actual_operands: DS_HASH_TABLE [DS_HASH_SET [INTEGER], STRING]
			-- A map from names of variables that are used as actual operands for `feature_'
			-- to the 0-based operand index of that variable.
			-- Key is variable name, value is the set of operand indexes where the variable is used.
			-- The operand indexes is a set because the same variable can be used as multiple operands
			-- in a feature call.

feature{NONE} -- Implementation

	build_data_structure
			-- Build data structure.
		local
			l_operand_map: like operand_map
			l_cursor: CURSOR
			l_name: STRING
			l_index_set: DS_HASH_SET [INTEGER]
		do
			create actual_operands.make (operand_map.count)
			actual_operands.set_key_equality_tester (string_equality_tester)

			l_operand_map := operand_map
			l_cursor := l_operand_map.cursor
			from
				l_operand_map.start
			until
				l_operand_map.after
			loop
				l_name := l_operand_map.item_for_iteration
				actual_operands.search (l_name)
				if actual_operands.found then
					l_index_set := actual_operands.found_item
				else
					create l_index_set.make (2)
					actual_operands.force_last (l_index_set, l_name)
				end
				l_index_set.force_last (l_operand_map.key_for_iteration)
				l_operand_map.forth
			end
			l_operand_map.go_to (l_cursor)
		end

	analyze_equation (a_equation: EPA_EQUATION)
			-- Analyze `a_equation' and store result in `valuations'.
		local
			l_maps: like function_maps_from_equation
			l_cursor: CURSOR
			l_valuations: like valuations
			l_map: EPA_FUNCTION_VALUATIONS
		do
			fixme ("We assume that the expression is a qualified call with at most one argument. 17.5.2010 Jasonw")
			if is_expression_qualified_call (a_equation.expression) then
				l_valuations := valuations
				l_maps := function_maps_from_equation (a_equation)
				l_cursor := l_maps.cursor
				from
					l_maps.start
				until
					l_maps.after
				loop
					l_map := l_maps.item_for_iteration
					l_valuations.search (l_map.function)
					if l_valuations.found then
						l_valuations.found_item.merge (l_map)
					else
						l_valuations.force_last (l_map.cloned, l_map.function)
					end
					l_maps.forth
				end
				l_maps.go_to (l_cursor)
			end
		end

	is_expression_qualified_call (a_expr: EPA_EXPRESSION): BOOLEAN
			-- Is `a_expr' a qualified call?
		do
			fixme ("Very naive checking, refactoring needed. 17.5.2010 Jasonw")
			Result := a_expr.text.has ('.')
		end

	info_in_expression (a_expr: EPA_EXPRESSION): TUPLE [target_name: STRING; feature_name: STRING; argument_name: detachable STRING]
			-- Information extracted `a_expr'
			-- `a_expr' is assumed to be a qualified feature call with at most one argument.
			-- `target_name' is the name of the target variable of that feature call.
			-- `feature_name' is the name of the feature call.
			-- `argument_name', if attached, is the name of the argument of the feature call.
		local
			l_text: STRING
			l_dot_index: INTEGER
			l_lparan_index: INTEGER
			l_rparan_index: INTEGER

			l_target_variable: STRING
			l_argument_variable: detachable STRING
			l_has_argument: BOOLEAN
			l_feature_name: STRING
		do
			l_text := a_expr.text.twin

				-- Find out the name of the target varaible.
			l_dot_index := l_text.index_of ('.', 1)
			check l_dot_index > 1 end
			l_target_variable := l_text.substring (1, l_dot_index - 1)
			l_target_variable.left_adjust
			l_target_variable.right_adjust

				-- Find out the argument (if any) of the feature call, and
				-- find out the name of the qualified called feature.
			l_lparan_index := l_text.index_of ('(', l_dot_index + 1)
			l_has_argument := l_lparan_index > 0
			if l_has_argument then
				l_rparan_index := l_text.index_of (')', l_lparan_index + 1)
				l_argument_variable := l_text.substring (l_lparan_index + 1, l_rparan_index - 1)
				l_feature_name := l_text.substring (l_dot_index + 1, l_lparan_index - 1)
				l_argument_variable.left_adjust
				l_argument_variable.right_adjust
			else
				l_feature_name := l_text.substring (l_dot_index + 1, l_text.count)
			end
			l_feature_name.left_adjust
			l_feature_name.right_adjust

			Result := [l_target_variable, l_feature_name, l_argument_variable]
		end

	function_maps_from_equation (a_equation: EPA_EQUATION): LINKED_LIST [EPA_FUNCTION_VALUATIONS]
			-- Function maps from `a_equation'
		local
			l_expr: EPA_EXPRESSION
			l_value: EPA_EXPRESSION_VALUE
			l_info: like info_in_expression

			l_target_variable: STRING
			l_argument_variable: detachable STRING
			l_has_argument: BOOLEAN
			l_feature_name: STRING
			l_actual_operands: like actual_operands
			l_feat: FEATURE_I
			l_operands: DS_HASH_SET [INTEGER]
			l_operand_types: like operand_types_with_feature
			l_target_type: TYPE_A
			l_argument_type: detachable TYPE_A
			l_dyna_feat: FEATURE_I
			l_function_types: LINKED_LIST [TUPLE [target_type: TYPE_A; argument_type: detachable TYPE_A; feature_name: STRING; result_type: TYPE_A]]

			l_body: STRING
			l_argument_types: ARRAY [TYPE_A]
			l_argument_domains: ARRAY [EPA_FUNCTION_DOMAIN]
			l_result_domain: EPA_FUNCTION_DOMAIN
			l_function: EPA_FUNCTION
			l_result_type: TYPE_A
			l_map: EPA_FUNCTION_VALUATIONS

			l_actual_args: DS_ARRAYED_LIST [EPA_FUNCTION]
			l_actual_result: EPA_FUNCTION
			l_actual_arg: EPA_FUNCTION
			l_maped_values: DS_HASH_SET [EPA_FUNCTION_ARGUMENT_VALUE_MAP]
		do
			create Result.make

				-- Analyze the structure of the expression.
			l_expr := a_equation.expression
			l_value := a_equation.value
			l_info := info_in_expression (l_expr)
			l_target_variable := l_info.target_name
			l_feature_name := l_info.feature_name
			l_argument_variable := l_info.argument_name
			l_has_argument := l_argument_variable /= Void

				-- Get the feature based on the dynamic type of the target variable.
			l_dyna_feat := context.variables.item (l_target_variable).associated_class.feature_named (l_feature_name.as_lower)

				-- Decide the type information of the expression feature
			l_actual_operands := actual_operands
			create l_function_types.make
			if l_actual_operands.has (l_target_variable) then
					-- The target of the expression feature is an actual operand for `feature_', we use the static type(s) of that
					-- operand for the to-be-extracted function(s).
					-- An operand can have different static types because the same operand can be used as multiple operands.
				l_operands := l_actual_operands.item (l_target_variable)
				l_operand_types := operand_types_with_feature (feature_, class_)
				from
					l_operands.start
				until
					l_operands.after
				loop
					l_target_type := l_operand_types.item (l_operands.item_for_iteration)
					l_target_type := l_target_type.instantiation_in (context_type, context_type.associated_class.class_id)
					l_feat := l_target_type.associated_class.feature_of_rout_id_set (l_dyna_feat.rout_id_set)
					l_result_type := l_feat.type.actual_type.instantiation_in (l_target_type, l_target_type.associated_class.class_id)
					if l_feat.argument_count > 0 then
						l_argument_type := l_feat.arguments.first
--						l_argument_type := l_argument_type.instantiation_in (l_target_type, l_target_type.associated_class.class_id)
					else
						l_argument_type := Void
					end
					l_function_types.extend ([l_target_type, l_argument_type, l_feat.feature_name, l_result_type])
					l_operands.forth
				end
			else
					-- The target of the expression is not an actual operand for `feature_', we can only use dynamic type of that target.
				l_target_type := context.variables.item (l_target_variable)
				if l_has_argument then
					l_argument_type := l_dyna_feat.arguments.first
					l_argument_type := l_argument_type.instantiation_in (l_target_type, l_target_type.associated_class.class_id)
				else
					l_argument_type := Void
				end
				l_result_type := l_feat.type.actual_type.instantiation_in (l_target_type, l_target_type.associated_class.class_id)
				l_function_types.extend ([l_target_type, l_argument_type, l_dyna_feat.feature_name, l_result_type])
			end

				-- Construct function maps.
			from
				l_function_types.start
			until
				l_function_types.after
			loop
				l_target_type := l_function_types.item_for_iteration.target_type
				l_argument_type := l_function_types.item_for_iteration.argument_type
				l_feature_name := l_function_types.item_for_iteration.feature_name
				l_result_type := l_function_types.item_for_iteration.result_type

					-- Create function.
				l_body := function_body (l_feature_name, l_has_argument)

				create l_actual_args.make (2)
				l_actual_args.set_equality_tester (function_equality_tester)
					-- Create function argument for target.
				l_actual_args.force_last (
					create {EPA_FUNCTION}.make_from_expression (
						create {EPA_AST_EXPRESSION}.make_with_text_and_type (
							context.class_,
							context.feature_,
							l_target_variable,
							context.class_,
							context.variables.item (l_target_variable))))

				if l_has_argument then
					create l_argument_types.make (1, 2)
					l_argument_types.put (l_target_type, 1)
					l_argument_types.put (l_argument_type, 2)
					create l_argument_domains.make (1, 2)
					l_argument_domains.put (create {EPA_UNSPECIFIED_DOMAIN}, 1)
					l_argument_domains.put (create {EPA_UNSPECIFIED_DOMAIN}, 2)

						-- Create function argument for argument.
					l_actual_args.force_last (
						create {EPA_FUNCTION}.make_from_expression (
							create {EPA_AST_EXPRESSION}.make_with_text (
								context.class_,
								context.feature_,
								l_argument_variable,
								context.class_)))
				else
					create l_argument_types.make (1, 1)
					l_argument_types.put (l_target_type, 1)
					create l_argument_domains.make (1, 1)
					l_argument_domains.put (create {EPA_UNSPECIFIED_DOMAIN}, 1)
				end
				create l_function.make (l_argument_types, l_argument_domains, l_result_type, l_body)

					-- Create value map for function.
				create l_actual_result.make_from_expression_value (l_value)
				create l_map.make (l_function)

				create l_maped_values.make (2)
				l_maped_values.set_equality_tester (function_argument_value_map_equality_tester)
				l_maped_values.force_last (create {EPA_FUNCTION_ARGUMENT_VALUE_MAP}.make (l_actual_args, l_actual_result, l_function))
				l_map.set_map (l_maped_values)

				Result.extend (l_map)
				l_function_types.forth
			end
		end

	function_body (a_feature_name: STRING; a_has_argument: BOOLEAN): STRING
			-- Function body for feature named `a_feature_name'
			-- Format: {1}.feature_name ({2}).
		do
			create Result.make (a_feature_name.count + 10)
			Result.append (curly_brace_surrounded_integer (1))
			Result.append_character ('.')
			Result.append (a_feature_name)
			if a_has_argument then
				Result.append_character ('(')
				Result.append (curly_brace_surrounded_integer (2))
				Result.append_character (')')
			end
		end

feature -- Access

	dumped_result: STRING
			-- String representation of `valuations'
		local
			l_cursor: DS_HASH_TABLE_CURSOR [EPA_FUNCTION_VALUATIONS, EPA_FUNCTION]
		do
			create Result.make (2048)
			from
				l_cursor := valuations.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.append (once "---------------------------------------------%N")
				Result.append (l_cursor.item.debug_output)
				Result.append_character ('%N')
				l_cursor.forth
			end
		end

end
