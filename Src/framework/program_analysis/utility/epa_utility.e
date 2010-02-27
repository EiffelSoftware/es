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

	ast_from_text (a_text: STRING): AST_EIFFEL
			-- AST node from `a_text'
			-- `a_text' must be able to be parsed in to a single AST node.
		local
			l_text: STRING
		do
			l_text := "feature foo do " + a_text + "%Nend"
			entity_feature_parser.parse_from_string (l_text, Void)

			if attached {ROUTINE_AS} entity_feature_parser.feature_node.body.as_routine as l_routine then
				if attached {DO_AS} l_routine.routine_body as l_do then
					if l_do.compound.count = 1 then
						Result := l_do.compound.first
					end
				end
			end
			check Result /= Void end
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
			Result.set_key_equality_tester (case_insensitive_string_equality_tester)

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
			l_classes := universe.classes_with_name (a_class_name)
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

feature -- Contract extraction

	precondition_expressions (a_context_class: CLASS_C; a_feature: FEATURE_I): DS_HASH_SET [EPA_EXPRESSION]
			-- List of precondition assertions of `a_feature' in `a_context_class'
		local
			l_exprs: LINKED_LIST [EPA_EXPRESSION]
			l_expr: EPA_AST_EXPRESSION
		do
			l_exprs := precondition_of_feature (a_feature, a_context_class)

			create Result.make (l_exprs.count)
			Result.set_equality_tester (expression_equality_tester)

			fixme ("Require else assertions are ignored. 30.12.2009 Jasonw")
			extend_expression_in_set (
				l_exprs,
				agent (a_expr: EPA_EXPRESSION): BOOLEAN do Result := not a_expr.is_require_else end,
				Result,
				a_context_class,
				a_feature)
		end

	postconditions_expressions (a_context_class: CLASS_C; a_feature: FEATURE_I): DS_HASH_SET [EPA_EXPRESSION]
			-- List of postcondition assertions of `a_feature' in `a_context_class'
		local
			l_exprs: LINKED_LIST [EPA_EXPRESSION]
		do
			l_exprs := postcondition_of_feature (a_feature, a_context_class)

			create Result.make (l_exprs.count)
			Result.set_equality_tester (expression_equality_tester)

			extend_expression_in_set (
				l_exprs,
				agent (a_expr: EPA_EXPRESSION): BOOLEAN do Result := True end,
				Result,
				a_context_class,
				a_feature)
		end

	invariant_expressions (a_context_class: CLASS_C; a_feature: FEATURE_I): DS_HASH_SET [EPA_EXPRESSION]
			-- List of class invariant assertions in `a_context_class'
		local
			l_exprs: LINKED_LIST [EPA_EXPRESSION]
			l_gen: AFX_POSTCONDITION_AS_INVARIANT_GENERATOR
		do
			l_exprs := invariant_of_class (a_context_class)
			create l_gen
			l_gen.generate (a_context_class)

			create Result.make (l_exprs.count + l_gen.last_invariants.count)
			Result.set_equality_tester (expression_equality_tester)

				-- Include normal class invariants.
			extend_expression_in_set (
				l_exprs,
				agent (a_expr: EPA_EXPRESSION): BOOLEAN do Result := True end,
				Result,
				a_context_class,
				a_feature)

				-- Include some postconditions as class invariants.
			l_gen.last_invariants.do_if (
				agent Result.force_last,
				agent (a_item: EPA_EXPRESSION; a_set: DS_HASH_SET [EPA_EXPRESSION]): BOOLEAN
					do
						Result := not a_set.has (a_item)
					end (?, Result))
		end

	extend_expression_in_set (a_exprs: LINKED_LIST [EPA_EXPRESSION]; a_test: PREDICATE [ANY, TUPLE [EPA_EXPRESSION]]; a_set: DS_HASH_SET [EPA_EXPRESSION]; a_context_class: CLASS_C; a_feature: FEATURE_I)
			-- Append items from `a_exprs' into `a_set' if those items satisfy `a_test'.
			-- `a_context_class' and `a_feature' are used to construct AFX_EXPRESSION.
		local
			l_expr: EPA_AST_EXPRESSION
		do
			from
				a_exprs.start
			until
				a_exprs.after
			loop
				if a_test.item ([a_exprs.item_for_iteration]) then
					create l_expr.make_with_text (a_context_class, a_feature, text_from_ast (a_exprs.item_for_iteration.ast), a_exprs.item_for_iteration.written_class)
					if not a_set.has (l_expr) then
						a_set.force_last (l_expr)
					end
				end
				a_exprs.forth
			end
		end

end
