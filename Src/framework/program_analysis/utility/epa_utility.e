note
	description: "Summary description for {EPA_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_UTILITY

inherit
	KL_SHARED_STRING_EQUALITY_TESTER

	SHARED_WORKBENCH

	SHARED_EIFFEL_PARSER

	SHARED_SERVER

	REFACTORING_HELPER

	SHARED_TEXT_ITEMS

	EPA_TYPE_UTILITY

	ETR_SHARED_ERROR_HANDLER
		rename
			error_handler as etr_error_handler
		end

feature -- AST

	text_from_ast (a_ast: AST_EIFFEL): STRING
			-- Text from `a_ast'
		require
			a_ast_attached: a_ast /= Void
		do
			ast_printer_output.reset
			ast_printer.print_ast_to_output (a_ast)
			Result := ast_printer_output.string_representation
		end

	ast_printer: ETR_AST_STRUCTURE_PRINTER
			-- AST printer
		local
			l_output: ETR_AST_STRING_OUTPUT
		once
			create Result.make_with_output (ast_printer_output)
		end

	ast_printer_output: ETR_AST_STRING_OUTPUT
			-- Output for `ast_printer'
		once
			create Result.make_with_indentation_string ("%T")
		end

	old_remover_output: ETR_AST_STRING_OUTPUT
			-- Output for `old_remover'
		once
			create Result.make_with_indentation_string ("%T")
		end

	ast_from_statement_text (a_text: STRING): AST_EIFFEL
			-- AST node from `a_text'
			-- `a_text' must a statement AST and must be able to be parsed in to a single AST node.
		local
			l_text: STRING
		do
			l_text := "feature dummy__feature do " + a_text + "%Nend"
			entity_feature_parser.parse_from_utf8_string (l_text, Void)

			if attached {ROUTINE_AS} entity_feature_parser.feature_node.body.as_routine as l_routine then
				if attached {DO_AS} l_routine.routine_body as l_do then
					if l_do.compound.count = 1 then
						Result := l_do.compound.first
					end
				end
			end
			check Result /= Void end
		end

	ast_from_expression_text (a_text: STRING): EXPR_AS
			-- AST node from expression `a_text'
			-- `a_text' must be as an expression.
		do
			expression_parser.parse_from_utf8_string (once "check " + a_text, Void)
			Result := expression_parser.expression_node
		end

	ast_without_old_expression (a_ast: EXPR_AS): EXPR_AS
			-- An AST node the same as `a_ast' expect that all "old"
			-- keywords are removed
		do
			old_remover.output.reset
			old_remover.print_ast_to_output (a_ast)
			Result := ast_from_expression_text (old_remover_output.string_representation)
		end

	old_remover: EPA_AST_OLD_EXPRESSION_REMOVER
			-- Old expression remover
		once
			create Result.make_with_output (old_remover_output)
		end

	ast_in_other_context (a_ast: AST_EIFFEL; a_source_context: ETR_CONTEXT; a_target_context: ETR_CONTEXT): detachable AST_EIFFEL
			-- New AST from `a_ast' (in `a_source_context'), but viewed from `a_target_context'.
			-- Void if context transformation failed.
		local
			l_transformable: ETR_TRANSFORMABLE
			l_retried: BOOLEAN
		do
			if not l_retried then
				etr_error_handler.reset_errors
				create l_transformable.make (a_ast, a_source_context, True)
				Result := l_transformable.as_in_other_context (a_target_context)
				if etr_error_handler.has_errors then
					Result := Void
				end
			end
		rescue
			l_retried := True
			Result := Void
			retry
		end

	ast_in_context_class (a_ast: AST_EIFFEL; a_written_class: CLASS_C; a_written_feature: detachable FEATURE_I; a_context_class: CLASS_C): AST_EIFFEL
           -- AST representing `a_ast', which comes from `a_written_feature' in `a_written_class'.
           -- The resulting AST is viewed from `a_context_class' and with all renaming resolved.
           -- `a_written_class' and `a_context_class' should be in the same inheritance hierarchy.
       local
           l_source_context: ETR_CONTEXT
           l_target_context: ETR_CONTEXT
           l_feat_context: ETR_FEATURE_CONTEXT
           l_class_context: ETR_CLASS_CONTEXT
           l_feat: FEATURE_I
           l_transformable: ETR_TRANSFORMABLE
       do
           if a_written_class /= Void then
                   -- Calculate source context.
--               create l_class_context.make (a_written_class)
--               create l_feat_context.make (a_written_feature, l_class_context)
--               l_source_context := l_feat_context
               l_source_context := context_from_class_feature (a_written_class, a_written_feature)

                   -- Calculate target context.
               l_feat := a_context_class.feature_of_rout_id_set (a_written_feature.rout_id_set)
--               create l_class_context.make (a_context_class)
--               create l_feat_context.make (l_feat, l_class_context)
--               l_target_context := l_feat_context
               l_target_context := context_from_class_feature (a_context_class, l_feat)
           else
                   -- Calculate source context.
               create l_class_context.make (a_written_class)
               l_source_context := l_class_context

                   -- Calculate target context.
               create l_class_context.make (a_context_class)
               l_target_context := l_class_context
           end

           create l_transformable.make (a_ast, l_source_context, True)
           Result := l_transformable.as_in_other_context (l_target_context).to_ast
       end

	context_from_class_feature (a_class: CLASS_C; a_feature: detachable FEATURE_I): ETR_CONTEXT
			-- Context from `a_class' and possibly `a_feature'
		do
			if a_feature = Void then
				create {ETR_CLASS_CONTEXT} Result.make (a_class)
			else
				create {ETR_FEATURE_CONTEXT} Result.make (a_feature, create {ETR_CLASS_CONTEXT}.make (a_class))
			end
		end

feature -- Contract extractor

	contract_extractor: EPA_CONTRACT_EXTRACTOR
			-- Contract extractor
		once
			create Result
		end

feature -- Class/feature related

	arguments_of_feature (a_feature: FEATURE_I): DS_HASH_TABLE [INTEGER, STRING]
			-- Table of formal argument names in `a_feature'
			-- Key is the argument name, value is its index in the feature signature.
			-- The equality tester of the result is case insensitive equality tester.
		local
			i: INTEGER
			l_count: INTEGER
		do
			l_count := a_feature.argument_count
			create Result.make (l_count)
			Result.set_key_equality_tester (string_equality_tester)

			if l_count > 0 then
				from
					i := 1
				until
					i > l_count
				loop
					Result.put (i, a_feature.arguments.item_name (i))
					i := i + 1
				end
			end
		end

	operand_count_of_feature (a_feature: FEATURE_I): INTEGER
			-- Number of operands (target, argument, result) of `a_feature'
		do
			Result := a_feature.argument_count + 1
			if not a_feature.type.is_void then
				Result := Result + 1
			end
		end

	operands_of_feature (a_feature: FEATURE_I): DS_HASH_TABLE [INTEGER, STRING]
			-- Operands and their positions of `a_feature', including target and possible
			-- returned Result. Operand positions are 0-based, with 0 indicates the target.
			-- Key is an operand name, value is the position of that operand.
			-- The result is inversed `operands_with_feature'.
		local
			l_operand_count: INTEGER
			l_arg_cursor: like arguments_of_feature.new_cursor
		do
			l_operand_count := 1 + a_feature.argument_count
			if not a_feature.type.is_void then
				l_operand_count := l_operand_count + 1
			end
			create Result.make (l_operand_count)
			Result.set_key_equality_tester (string_equality_tester)

			Result.force_last (0, ti_current)
			from
				l_arg_cursor := arguments_of_feature (a_feature).new_cursor
				l_arg_cursor.start
			until
				l_arg_cursor.after
			loop
				Result.force_last (l_arg_cursor.item, l_arg_cursor.key)
				l_arg_cursor.forth
			end

			if a_feature.has_return_value then
				Result.force_last (l_operand_count - 1, ti_result)
			end
		end

	operands_with_feature (a_feature: FEATURE_I): DS_HASH_TABLE [STRING, INTEGER]
			-- Operands and their positions of `a_feature', including target and possible
			-- returned Result. Operand positions are 0-based, with 0 indicates the target.
			-- Key is an operand position, value is the operand name.
			-- The result is inversed `operands_of_feature'.
		local
			l_operands: like operands_of_feature
			l_cursor: like operands_of_feature.new_cursor
		do
			l_operands := operands_of_feature (a_feature)
			create Result.make (l_operands.count)
			from
				l_cursor := l_operands.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.force_last (l_cursor.key, l_cursor.item)
				l_cursor.forth
			end
		end

	operand_types_with_feature (a_feature: FEATURE_I; a_context_class: CLASS_C): DS_HASH_TABLE [TYPE_A, INTEGER]
			-- Types of operands of `a_feature' in the context of `a_context_class'.
			-- Result is a table, key is the 0-based operand index, 0 indicates the target,
			-- followed by arguments and result, if any. Value is the type of that operand.
			-- Note: Types in the result is not resolved.
		local
			l_operand_count: INTEGER
			l_args: FEAT_ARG
			l_cursor: CURSOR
			i: INTEGER
		do
			l_operand_count := 1 + a_feature.argument_count
			if a_feature.has_return_value then
				l_operand_count := l_operand_count + 1
			end
			create Result.make (l_operand_count)
			Result.force_last (a_context_class.actual_type, 0)
			if a_feature.has_return_value then
				Result.force_last (a_feature.type, l_operand_count - 1)
			end

			if a_feature.argument_count > 0 then
				l_args := a_feature.arguments
				l_cursor := l_args.cursor
				from
					i := 1
					l_args.start
				until
					l_args.after
				loop
					Result.force_last (l_args.item_for_iteration, i)
					i := i + 1
					l_args.forth
				end
				l_args.go_to (l_cursor)
			end
		end

	resolved_operand_types_with_feature (a_feature: FEATURE_I; a_viewed_class: CLASS_C; a_context_type: TYPE_A): like operand_types_with_feature
			-- Types of operands of `a_feature' in the context of `a_context_class'.
			-- Result is a table, key is the 0-based operand index, 0 indicates the target,
			-- followed by arguments and result, if any. Value is the type of that operand.
			-- Note: Types in the result is solved in `a_context_class'.	
		local
			l_type: TYPE_A
		do
			Result := operand_types_with_feature (a_feature, a_viewed_class)
			from
				Result.start
			until
				Result.after
			loop
				l_type := Result.item_for_iteration.actual_type
				l_type := actual_type_from_formal_type (l_type, a_context_type.associated_class)
				l_type := l_type.actual_type.instantiation_in (a_context_type, a_context_type.associated_class.class_id)
				Result.replace (l_type, Result.key_for_iteration)
				Result.forth
			end
		end

	operand_name_index_with_feature (a_feature: FEATURE_I; a_context_class: CLASS_C): HASH_TABLE [STRING, INTEGER]
			-- Table from 0-based operand (including result, if any) index to the corresponding operand names.
			-- Key is operand index, value is the name of that operand. "Current" for target, "Result" for result.
		local
			l_operand_count: INTEGER
			l_args: FEAT_ARG
		do
			l_operand_count := 1 + a_feature.argument_count
			if a_feature.has_return_value then
				l_operand_count := l_operand_count + 1
			end
			create Result.make (l_operand_count)
			Result.put (ti_current, 0)
			if a_feature.has_return_value then
				Result.put (ti_result, l_operand_count - 1)
			end

			if a_feature.argument_count > 0 then
				l_args := a_feature.arguments
				across 1 |..| a_feature.argument_count as l_arg_indexes loop
					Result.put (l_args.item_name (l_arg_indexes.item), l_arg_indexes.item)
				end
			end
		end

	operand_name_types_with_feature (a_feature: FEATURE_I; a_context_class: CLASS_C): DS_HASH_TABLE [TYPE_A, STRING]
			-- Types of operands of `a_feature' in the context of `a_context_class'.
			-- Result is a table, key is operand name, such as "Current", "Result", and arguments.
			-- Value is the type of that operand.
			-- Note: Types in the result is not resolved.
		local
			l_operand_count: INTEGER
			l_args: FEAT_ARG
			l_cursor: CURSOR
			i: INTEGER
		do
			l_operand_count := 1 + a_feature.argument_count
			if a_feature.has_return_value then
				l_operand_count := l_operand_count + 1
			end
			create Result.make (l_operand_count)
			Result.set_key_equality_tester (string_equality_tester)
			Result.force_last (a_context_class.actual_type, ti_current)
			if a_feature.has_return_value then
				Result.force_last (a_feature.type, ti_result)
			end

			if a_feature.argument_count > 0 then
				l_args := a_feature.arguments
				l_cursor := l_args.cursor
				from
					i := 1
					l_args.start
				until
					l_args.after
				loop
					Result.force_last (l_args.item_for_iteration, l_args.item_name (i))
					i := i + 1
					l_args.forth
				end
				l_args.go_to (l_cursor)
			end
		end

	local_names_of_feature (a_feature: FEATURE_I): DS_HASH_SET [STRING]
			-- Set of local variable names in `a_feature'
			-- The equality tester of the result is case insensitive equality tester.
		do
			create Result.make (10)
			Result.set_equality_tester (case_insensitive_string_equality_tester)

			if attached {ROUTINE_AS} a_feature.body.body.as_routine as l_routine then
				if l_routine.locals /= Void then
					l_routine.locals.do_all (
						agent (a_type_dec: TYPE_DEC_AS; a_result: DS_HASH_SET [STRING])
							local
								i: INTEGER
								c: INTEGER
							do
								from
									c := a_type_dec.id_list.count
									i := 1
								until
									i > c
								loop
									a_result.force_last (a_type_dec.item_name (i))
									i := i + 1
								end
							end (?, Result))
				end
			end
		end

	first_class_starts_with_name (a_class_name: STRING): detachable CLASS_C
			-- First class found in current system with name `a_class_name'
			-- Void if no such class was found.
		local
			l_classes: LIST [CLASS_I]
			l_class_c: CLASS_C
		do
			l_classes := universe.classes_with_name (a_class_name.as_upper)
			if not l_classes.is_empty then
				Result := l_classes.first.compiled_representation
			end
		end

	feature_from_class (a_class_name: STRING; a_feature_name: STRING): detachable FEATURE_I
			-- Feature named `a_feature_name' from class named `a_class_name'
			-- Void if no such feature exists.
		local
			l_class: detachable CLASS_C
		do
			l_class := first_class_starts_with_name (a_class_name)
			if l_class /= Void then
				Result := l_class.feature_named (a_feature_name)
			end
		end

	feature_header_comment (a_feature: FEATURE_I): STRING
			-- Header comment of `a_feature'
		local
			l_comments: EIFFEL_COMMENTS
			l_text: STRING_32
			l_nls: INTEGER
		do
			fixme ("Code copied from EB_FEATURE_FOR_COMPLETION.tooltip_text")
			create Result.make_empty
			l_comments := comment_extractor.feature_comments (a_feature.e_feature)
			if attached l_comments then
				from l_comments.start until l_comments.after loop
					if attached l_comments.item as l_comment_line then
						l_text := l_comment_line.content
						l_text.left_adjust
						l_text.right_adjust

						if not l_text.is_empty then
							Result.append_string_general (l_text)
							Result.append_character (' ')
							l_nls := 0
						else
							if l_nls >= 2 and then not l_comments.islast then
								Result.append ("%N%N")
							end
						end
						l_nls := l_nls + 1
					end
					l_comments.forth
				end
			end
		end

	comment_extractor: EPA_COMMENT_EXTRACTOR
			-- Comment extractor
		once
			create Result
		end

	operand_index_set (a_feature: FEATURE_I; a_include_target: BOOLEAN; a_include_result: BOOLEAN): INTEGER_INTERVAL
			-- Operand index interval for `a_feature'
			-- `a_include_target' indicates if the target operand 0 is included in the result interval.
			-- `a_include_result' indicates if the result (if any) operand is included in the result internal.
		local
			l_lower: INTEGER
			l_upper: INTEGER
		do
			if a_include_target then
				l_lower := 0
			else
				l_lower := 1
			end
			l_upper := a_feature.argument_count
			if a_include_result and then a_feature.has_return_value then
				l_upper := l_upper + 1
			end
			create Result.make (l_lower, l_upper)
		end

feature -- String manipulation

	string_slices (a_string: STRING; a_separater: STRING): LIST [STRING]
			-- Split `a_string' on `a_separater', return slices.
		local
			l_index1, l_index2: INTEGER
			l_part: STRING
			l_done: BOOLEAN
			l_spe_count: INTEGER
		do
			create {LINKED_LIST [STRING]} Result.make
			from
				l_spe_count := a_separater.count
			until
				l_done
			loop
				l_index2 := a_string.substring_index (a_separater, l_index1 + 1)
				if l_index2 = 0 then
					l_index2 := a_string.count + 1
					l_done := True
				end
				l_part := a_string.substring (l_index1 + 1, l_index2 - 1)
				Result.extend (l_part)
				l_index1 := l_index2 + l_spe_count - 1
			end
		end

feature -- Equation

	equation_with_value (a_expr: EPA_EXPRESSION; a_value: EPA_EXPRESSION_VALUE): EPA_EQUATION
			-- Equation with current as expression and `a_value' as value.
		do
			create Result.make (a_expr, a_value)
		end

	equation_with_random_value (a_expr: EPA_EXPRESSION): EPA_EQUATION
			-- Equation with current as expression, with a randomly
			-- assigned value.
		local
			l_value: EPA_EXPRESSION_VALUE
		do
			if a_expr.type.is_boolean then
				create {EPA_RANDOM_BOOLEAN_VALUE} l_value.make
			elseif a_expr.type.is_integer then
				create {EPA_RANDOM_INTEGER_VALUE} l_value.make
			else
				check not_supported_yet: False end
				to_implement ("Implement random value for other types.")
			end

			Result := equation_with_value (a_expr, l_value)
		ensure
			value_is_random: Result.value.is_random
		end

feature -- Equation transformation

	equation_in_normal_form (a_equation: EPA_EQUATION): EPA_EQUATION
			-- Equation in normal form of `a_equation'.
			-- Transformation only happens if `a_equation'.`expression' is in form of "prefix.ABQ",
			-- otherwise, return `a_equation' itself.
		local
			l_analyzer: EPA_ABQ_STRUCTURE_ANALYZER
			l_expr: EPA_AST_EXPRESSION
			l_text: STRING
			l_ori_expr: EPA_EXPRESSION
			l_value: EPA_BOOLEAN_VALUE
		do
			l_ori_expr := a_equation.expression
			if l_ori_expr.is_predicate then
				create l_analyzer
				l_analyzer.analyze (l_ori_expr)
				if l_analyzer.is_matched then
					create l_text.make (l_ori_expr.text.count)
					if attached l_analyzer.prefix_expression as l_prefix then
						l_text.append (l_prefix.text)
						l_text.append_character ('.')
					end
					l_text.append (l_analyzer.argumentless_boolean_query.text)
					create l_expr.make_with_text (l_ori_expr.class_, l_ori_expr.feature_, l_text, l_ori_expr.written_class)
					if attached {EPA_BOOLEAN_VALUE} a_equation.value as l_temp_value then
						if l_temp_value.is_deterministic and then l_analyzer.negation_count \\ 2 = 1 then
							create l_value.make (not l_temp_value.item)
						else
							l_value := l_temp_value
						end
					else
						check should_not_happen: False end
					end
					create Result.make (l_expr, l_value)
				else
					Result := a_equation
				end
			else
				Result := a_equation
			end
		end

feature -- Expressions/Types

	variable_to_type_replacements (a_variables: EPA_HASH_SET [EPA_EXPRESSION]; a_context_type: detachable TYPE_A): HASH_TABLE [STRING, STRING]
			-- Table to lookup the type of variables in `a_variables'
			-- Key is variable name, value is the type of that variable.
		do
			create Result.make (a_variables.count)
			Result.compare_objects
			a_variables.do_all (
				agent (a_expr: EPA_EXPRESSION; a_tbl: HASH_TABLE [STRING, STRING]; a_ctxt_type: detachable TYPE_A)
					local
						l_type: STRING
					do
						l_type := cleaned_type_name (a_expr.resolved_type (a_ctxt_type).name)
						l_type.prepend_character ('{')
						l_type.append_character ('}')
						a_tbl.put (l_type, a_expr.text.as_lower)
					end (?, Result, a_context_type))
		end

feature -- Expressions

	expression_rewriter: EPA_TRANSITION_EXPRESSION_REWRITER
			-- Expression rewriter to rewrite `variables' in anonymous format.
		once
			create Result.make
		end

	expression_text_with_replacement (a_expression: EPA_EXPRESSION; a_replacements: HASH_TABLE [STRING, STRING]): STRING
			-- Text of `a_expression' with all accesses to variables replaced by anonymoue names
			-- `a_replacements' defines the replacements. Key is the original variable name in `a_expressions',
			-- value is the new text for that variable in the resulting string.
			-- For example, "has (v)" will be: "{0}.has ({1})", given those variable positions.			
		do
			Result := expression_rewriter.expression_text (a_expression, a_replacements)
		end

end
