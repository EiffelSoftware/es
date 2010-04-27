note
	description: "Class to represent a function"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_FUNCTION

inherit
	EPA_UTILITY

	EPA_STRING_UTILITY

	DEBUG_OUTPUT

	EPA_SHARED_EQUALITY_TESTERS

create
	make_from_expression,
	make_from_feature

create{CI_FUNCTION}
	make

feature{NONE} -- Initialization

	make (a_argument_types: like argument_types; a_result_type: like result_type; a_body: like body; a_context: like context)
			-- Initialize Current.
		do
			argument_types := a_argument_types
			result_type := a_result_type
			body := a_body.twin
			context := a_context
		ensure
			argument_types_set: argument_types = a_argument_types
			result_type_set: result_type = a_result_type
			body_set: body ~ a_body
			context_set: context = a_context
		end

	make_from_expression (a_expr: EPA_EXPRESSION; a_context: like context)
			-- Initialize Current function as a constant with `a_expr' in `a_context'.
			-- Current is going to be a constant since `a_expr' does not have any argument.
		require
			a_expr_correct: attached a_expr.type
		do
			create argument_types.make (1, 0)
			result_type := a_expr.type
			context := a_context
			body := a_expr.text.twin
		ensure
			good_result: is_constant
			result_type_correct: is_type_equal (result_type, a_expr.type)
			body_correct: body ~ a_expr.text
			context_set: context = a_context
		end

	make_from_feature (a_feature: FEATURE_I; a_class: CLASS_C; a_context: like context)
			-- Initialize Current function from `a_feature' viewed in `a_class'.
			-- If `a_feature' has n arguments, then Current function will have n+1 arguments
			-- because the first argument in Current function represents the target of the feature call.
		require
			a_feature_is_query: a_feature.has_return_value
		local
			l_arg_count: INTEGER
			l_args: FEAT_ARG
			l_cursor: CURSOR
			i: INTEGER
		do
			context := a_context

				-- Setup `result_type'.
			result_type := a_feature.type

				-- Setup `argument_types'.
			l_arg_count := 1 + a_feature.argument_count
			create argument_types.make (1, l_arg_count)
			argument_types.put (a_class.actual_type, 1)

			if a_feature.argument_count > 0 then
				l_args := a_feature.arguments
				l_cursor := l_args.cursor
				from
					i := 2
					l_args.start
				until
					l_args.after
				loop
					argument_types.put (l_args.item_for_iteration, i)
					i := i + 1
					l_args.forth
				end
				l_args.go_to (l_cursor)
			end

				-- Setup `body'.
			body := body_for_feature (a_feature, a_class, 1)
		end

feature -- Access

	context: EPA_CONTEXT
			-- Context of current function

	argument_types: ARRAY [TYPE_A]
			-- Types of arguments of Current function
			-- The order in the list is important. The first element
			-- is the type of the first argument, and so on.
			-- The index of the array is 1-based. 1 refers to the first argument, and so on.
			-- The argument types may not be resovled.			

	argument_type (i: INTEGER): TYPE_A
			-- Type of argument at `i'-th position
			-- The resulting type is resolved.
		require
			i_valid: is_argument_position_valid (i)
		do
			Result := argument_types.item (i)
		end

	resolved_argument_type  (i: INTEGER): TYPE_A
			-- Type of argument at `i'-th position.
			-- The resulting type is resolved.
		require
			i_valid: is_argument_position_valid (i)
		do
			Result := resolved_type_in_context (argument_types.item (i), context.class_)
		end

	result_type: TYPE_A
			-- Type of the result of current function
			-- The type may not be resovled.

	resolved_result_type: TYPE_A
			-- Type of the result of current function.
			-- The type is resolved.
		do
			Result := resolved_type_in_context (result_type, context.class_)
		end

	arity: INTEGER
			-- Arity of current function
		do
			Result := argument_types.count
		end

	body: STRING
			-- Body of Current function
			-- Arguments are represented with place holders. For example:
			-- "{1}.has ({2})" is a body, {1} and {2} represents the first and
			-- the second argument.

	as_expression: EPA_EXPRESSION
			-- Expression from Current function
		require
			fully_evaluated: arity = 0
		do
			create {EPA_AST_EXPRESSION} Result.make_with_type (context.class_, context.feature_, ast_from_expression_text (body), context.class_, result_type)
		end

	canonical_form: STRING
			-- Canonical form of current function, with type information
		local
			l_replacements: HASH_TABLE [STRING, INTEGER]
			i: INTEGER
			l_context_class: CLASS_C
		do
			l_context_class := context.class_
			create Result.make (64)
			Result.append (body)
			create l_replacements.make (arity)
			from
				i := 1
			until
				i > arity
			loop
				l_replacements.put (curly_brace_surrounded_typed_integer (i, resolved_type_in_context (argument_type (i), l_context_class)), i)
				i := i + 1
			end

			from
				l_replacements.start
			until
				l_replacements.after
			loop
				Result.replace_substring_all (curly_brace_surrounded_integer (l_replacements.key_for_iteration), l_replacements.item_for_iteration)
				l_replacements.forth
			end
			Result.append (once ": ")
			Result.append (resolved_type_in_context (result_type, l_context_class).name)
		end

	types: DS_HASH_SET [TYPE_A]
			-- Set of types from `argument_types' and `result_type'
		do
			if attached types_internal as l_types then
				Result := l_types
			else
				create types_internal.make (arity + 1)
				types_internal.set_equality_tester (type_a_equality_tester)
				argument_types.do_all (agent types_internal.force_last)
				types_internal.force_last (result_type)
				Result := types_internal
			end
		end

feature -- Partial evaluation

	partially_evalauted (a_argument: CI_FUNCTION; a_position: INTEGER): CI_FUNCTION
			-- A function that is derived from Current by partially evaluating the
			-- `a_position'-th argument with `a_argument'.
			-- `a_argument' can be a function with arguments, so it is possible that
			-- after partial evaluation, the resulting function has more argument than
			-- the Current function.
			-- For example, if the Current function is "sum_of (x, y)", and the argument is
			-- "product_of (a, b)", after partial evaluation of the first argument, we get
			-- a new function "sum_of (product_of (a, b), y)" which has three arguments: a, b and y.
		require
			a_position_valid: is_argument_position_valid (a_position)
			a_argument_has_valid_type: is_conformant_to (a_argument.result_type, argument_type (a_position))
		local
			l_tbl: HASH_TABLE [CI_FUNCTION, INTEGER]
		do
			create l_tbl.make (1)
			l_tbl.put (a_argument, a_position)
			Result := partially_evaluated_with_arguments (l_tbl)
		end

	partially_evaluated_with_arguments (a_arguments: HASH_TABLE [CI_FUNCTION, INTEGER]): CI_FUNCTION
			-- A function that is derived from Current by partially evaluating the
			-- arguments specified in `a_arguments'.
			-- `a_arguments' is table indicating which arguments in Current function should be replaced
			-- with which other functions. Key of the table is argument position, value is the function which
			-- will replace the argument in that position.
		local
			l_final_arity: INTEGER
			l_cursor: CURSOR
			l_arg_replacements: HASH_TABLE [INTEGER, INTEGER]
			l_position: INTEGER
			l_arg_index: INTEGER
			l_arguments: LINKED_LIST [TYPE_A]
			l_func: CI_FUNCTION
			i: INTEGER
			l_new_args: LINKED_LIST [STRING]
			l_arg_body: STRING

			l_final_args: ARRAY [TYPE_A]
			l_final_body: STRING
		do
				-- Calculate arguments of the final function.
			l_final_arity := arity - a_arguments.count
			l_cursor := a_arguments.cursor
			l_position := 1
			create l_arg_replacements.make (5)
			create l_arguments.make
			create l_new_args.make
			from
				l_arg_index := 1
				l_position := 1
			until
				l_position > arity
			loop
				if a_arguments.has (l_position) then
					l_func := a_arguments.item (l_position)
					l_final_arity := l_final_arity + l_func.arity
					l_arg_replacements.wipe_out
					from
						i := 1
					until
						i > l_func.arity
					loop
						l_arguments.extend (l_func.argument_type (i))
						l_arg_replacements.put (l_arg_index, i)
						l_arg_index := l_arg_index + 1
						i := i + 1
					end

						-- Replace argument position in argument function with corrections.
					l_arg_body := l_func.body.twin
					from
						l_arg_replacements.start
					until
						l_arg_replacements.after
					loop
						l_arg_body.replace_substring_all (curly_brace_surrounded_integer (l_arg_replacements.key_for_iteration), curly_brace_surrounded_integer (l_arg_replacements.item_for_iteration))
						l_arg_replacements.forth
					end
					l_new_args.extend (l_arg_body)
				else
					l_arguments.extend (argument_type (l_position))
					l_new_args.extend (curly_brace_surrounded_integer (l_position))
					l_arg_index := l_arg_index + 1
				end
				l_position := l_position + 1
			end

				-- Fabricate the final function.
			create l_final_args.make (1, l_final_arity)
			from
				i := 1
				l_arguments.start
			until
				l_arguments.after
			loop
				l_final_args.put (l_arguments.item_for_iteration, i)
				i := i + 1
				l_arguments.forth
			end
			l_final_body := body.twin
			from
				i := 1
				l_new_args.start
			until
				l_new_args.after
			loop
				l_final_body.replace_substring_all (curly_brace_surrounded_integer (i), l_new_args.item_for_iteration)
				i := i + 1
				l_new_args.forth
			end
			create Result.make (l_final_args, result_type, l_final_body, context)
		end

feature -- Status report

	is_argument_position_valid (i: INTEGER): BOOLEAN
			-- Is `i' a valid argument position for Current?
		do
			Result := 1 <= i and i <= arity
		ensure
			good_result: Result = (1 <= i and i <= arity)
		end

	is_unary: BOOLEAN
			-- Is Current a unary function?
		do
			Result := arity = 1
		ensure
			good_result: Result = (arity = 1)
		end

	is_nullary, is_constant: BOOLEAN
			-- Is Current a constant (or a nullary function)?
		do
			Result := arity = 0
		ensure
			good_result: Result = (arity = 0)
		end

	is_binary: BOOLEAN
			-- Is Current a binary function?
		do
			Result := arity = 2
		ensure
			good_result: Result = (arity = 2)
		end

	is_conformant_to (a_source_type: TYPE_A; a_target_type: TYPE_A): BOOLEAN
			-- Is `a_source_type' conformant to `a_target_type'?
		local
			l_resolved_source_type: TYPE_A
			l_resolved_target_type: TYPE_A
		do
			l_resolved_source_type := resolved_type_in_context (a_source_type, context.class_)
			l_resolved_target_type := resolved_type_in_context (a_target_type, context.class_)
			Result := l_resolved_source_type.conform_to (context.class_, l_resolved_target_type)
		end

feature -- Equality

	is_equivalent (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result :=
				arity = other.arity and then
				is_type_equal (result_type, other.result_type) and then
				body ~ other.body and then
				is_arguments_equal (other)
		end

	is_arguments_equal (other: like Current): BOOLEAN
			-- Does `other' have the same arguments as Current?
		local
			i: INTEGER
			l_upper: INTEGER
		do
			if arity = other.arity then
				Result := True
				from
					i := 1
					l_upper := arity
				until
					i > l_upper or else not Result
				loop
					Result := is_type_equal (argument_type (i), other.argument_type (i))
					i := i + 1
				end
			end
		end

	is_type_equal (a_type: TYPE_A; b_type: TYPE_A): BOOLEAN
			-- Is `a_type' equal to `b_type'?
		local
			l_context_class: CLASS_C
		do
			l_context_class := context.class_
			Result := resolved_type_in_context (a_type, l_context_class).is_equivalent (resolved_type_in_context (b_type, l_context_class))
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := canonical_form
		end

feature{NONE} -- Implementation

	body_for_feature (a_feature: FEATURE_I; a_class: CLASS_C; a_starting_position: INTEGER): STRING
			-- Body for `a_feature' viewed in `a_class'
		local
			l_arg_count: INTEGER
			i: INTEGER
			j: INTEGER
		do
			create Result.make (64)
			Result.append (curly_brace_surrounded_integer (a_starting_position))
			Result.append_character ('.')
			Result.append (a_class.feature_of_rout_id_set (a_feature.rout_id_set).feature_name)

			l_arg_count := a_feature.argument_count
			if l_arg_count > 0 then
				Result.append_character ('(')
				from
					j := a_starting_position + 1
					i := 1
				until
					i > l_arg_count
				loop
					Result.append (curly_brace_surrounded_integer (j))
					if i < l_arg_count then
						Result.append_character (',')
						Result.append_character (' ')
					end
					j := j + 1
					i := i + 1
				end
				Result.append_character (')')
			end
		end

	types_internal: detachable like types
			-- Cache for `types'

invariant
	argument_types_valid: argument_types.lower = 1

end
