note
	description: "Summary description for {AFX_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_UTILITY

inherit
	AUT_CONTRACT_EXTRACTOR

	AFX_SOLVER_FACTORY

	EPA_UTILITY

feature -- Access

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

	test_case_info_from_string (a_string: STRING): AFX_TEST_CASE_INFO
			-- Test case information analyzed from `a_string'
		do
			create Result.make_with_string (a_string)
		end

feature -- Type related

	actual_type_from_formal_type (a_type: TYPE_A; a_context: CLASS_C): TYPE_A
			-- If `a_type' is formal, return its actual type in context of `a_context'
			-- otherwise return `a_type' itself.
		do
			if a_type.is_formal then
				if attached {FORMAL_A} a_type as l_formal then
					Result := l_formal.constrained_type (a_context)
				end
			else
				Result := a_type
			end
			if Result.has_generics then
				Result := Result.associated_class.constraint_actual_type
			end
		ensure
			result_attached: Result /= Void
		end

feature -- Equality tester

	class_with_prefix_equality_tester: AGENT_BASED_EQUALITY_TESTER [AFX_CLASS_WITH_PREFIX] is
			-- Equality test for predicate access pattern
		do
			create Result.make (agent (a, b: AFX_CLASS_WITH_PREFIX): BOOLEAN do Result := a.is_equal (b) end)
		end

	equation_equality_tester: AFX_EQUATION_EQUALITY_TESTER
			-- Equality tester for equations
		once
			create Result
		end

	expression_equality_tester: AFX_EXPRESSION_EQUALITY_TESTER
			-- Equality tester for expressions
		once
			create Result
		end

feature -- Equation transformation

	equation_in_normal_form (a_equation: AFX_EQUATION): AFX_EQUATION
			-- Equation in normal form of `a_equation'.
			-- Transformation only happens if `a_equation'.`expression' is in form of "prefix.ABQ",
			-- otherwise, return `a_equation' itself.
		local
			l_analyzer: AFX_ABQ_STRUCTURE_ANALYZER
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

feature -- AST node

	ast_node_string_representation (a_node: AFX_AST_STRUCTURE_NODE; a_level: INTEGER): STRING
			-- String representation for `a_node' at indentation level `a_level'
		local
			l_cursor: CURSOR
			l_cursor2: CURSOR
			l_nodes: LINKED_LIST [AFX_AST_STRUCTURE_NODE]
		do
			create Result.make (1024)
			Result.append (tab_string (a_level))

				-- Generate break point.
			if a_node.breakpoint_slot = 0 then
				Result.append ("  ")
			else
				if a_node.breakpoint_slot > 10 then
					Result.append (a_node.breakpoint_slot.out)
				else
					Result.append_character (' ')
					Result.append (a_node.breakpoint_slot.out)
				end
			end
			Result.append_character (' ')

				-- Generate node type.
			Result.append (a_node.ast.ast.generating_type)
			Result.append_character ('%N')

				-- Generate children nodes.
			l_cursor := a_node.children.cursor
			from
				a_node.children.start
			until
				a_node.children.after
			loop
				l_nodes := a_node.children.item_for_iteration
				if not l_nodes.is_empty then
					l_cursor2 := l_nodes.cursor
					from
						l_nodes.start
					until
						l_nodes.after
					loop
						Result.append (ast_node_string_representation (l_nodes.item_for_iteration, a_level + 2))
						l_nodes.forth
					end
					Result.append ("------------------------------%N")
					l_nodes.go_to (l_cursor2)
				end
				a_node.children.forth
			end
			a_node.children.go_to (l_cursor)
		end

	tab_string (a_level: INTEGER): STRING
			-- String for `a_level' tabs
		do
			create Result.make_filled (' ', a_level * 2)
		end

feature -- Math operations

	factorial (k: INTEGER): INTEGER
			-- Factorial of `k'
		local
			i: INTEGER
		do
			from
				Result := 1
				i := 1
			until
				i > k
			loop
				Result := Result * i
				i := i + 1
			end
		end

	permute (a_sequence: ARRAY [detachable ANY]; k: INTEGER)
			-- Permute `a_sequence' according to k'.
		require
			k_valid: k >= 0 and k <= factorial (a_sequence.count)
		local
			i, j, t: INTEGER
			l_count: INTEGER
			l_lower: INTEGER
			l_item: detachable ANY
		do
			from
				l_count := a_sequence.count
				l_lower := a_sequence.lower
				j := 2
			until
				j > l_count
			loop
				i := k \\ j + l_lower
				t := j - 1 + l_lower
				l_item := a_sequence.item (i)
				a_sequence.put (a_sequence.item (t), i)
				a_sequence.put (l_item, t)
				j := j + 1
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

feature -- Fix

	formated_feature (a_feature: FEATURE_I): STRING
			-- Pretty printed feature `a_feature'
		local
			l_printer: ETR_AST_STRUCTURE_PRINTER
			l_output: ETR_AST_STRING_OUTPUT
			l_feat_text: STRING
			l_match_list: LEAF_AS_LIST
		do
			l_match_list := match_list_server.item (a_feature.written_class.class_id)
			entity_feature_parser.parse_from_string ("feature " + a_feature.e_feature.ast.original_text (l_match_list), Void)
			create l_output.make_with_indentation_string ("%T")
			create l_printer.make_with_output (l_output)
			l_printer.print_ast_to_output (a_feature.e_feature.ast)
			Result := l_output.string_representation
		end

	formated_fix (a_fix: AFX_FIX): STRING
			-- Pretty printed feature text for `a_fix'
		local
			l_printer: ETR_AST_STRUCTURE_PRINTER
			l_output: ETR_AST_STRING_OUTPUT
			l_feat_text: STRING
			l_parser: like entity_feature_parser
		do
			if a_fix.feature_text.has_substring ("should not happen") then
				Result := a_fix.feature_text.twin
			else
				l_parser := entity_feature_parser
				l_parser.set_syntax_version (l_parser.transitional_64_syntax)
				l_parser.parse_from_string ("feature " + a_fix.feature_text, Void)
				create l_output.make_with_indentation_string ("%T")
				create l_printer.make_with_output (l_output)
				l_printer.print_ast_to_output (l_parser.feature_node)
				Result := l_output.string_representation
			end
		end

feature -- Logging

	store_fix_in_file (a_directory: STRING; a_fix: AFX_FIX; a_validated: BOOLEAN; a_big_file: detachable PLAIN_TEXT_FILE)
			-- Store `a_fix' as the `a_id'-th fix into a file in directory `a_directory'
			-- `a_validated' indicates if `a_fix' has been validated.
			-- Also append the fix in `a_big_file'.
		local
			l_file: PLAIN_TEXT_FILE
			l_file_name: FILE_NAME
			l_lines: LIST [STRING]
			l_formated_fix: STRING
		do
			create l_file_name.make_from_string (a_directory)
			l_file_name.set_file_name (fix_file_name (a_fix, a_validated))
			create l_file.make_create_read_write (l_file_name)

				-- Print patched feature text.
			l_formated_fix := formated_fix (a_fix)
			l_file.put_string (l_formated_fix)
			l_file.put_string (once "%N%N")

			if a_big_file /= Void then
				a_big_file.put_string (fix_signature (a_fix, False, True) + "%N")
				a_big_file.put_string (l_formated_fix)
				a_big_file.put_string (once "%N%N")
			end

				-- Print information about current fix.
			l_lines := a_fix.information.split ('%N')
			from
				l_lines.start
			until
				l_lines.after
			loop
				l_file.put_string (once "-- ")
				l_file.put_string (l_lines.item_for_iteration)
				l_file.put_string (once "%N")
				l_lines.forth
			end
			l_file.close
		end

	fix_signature (a_fix: AFX_FIX; a_validated: BOOLEAN; a_id: BOOLEAN): STRING
			-- Signature of `a_fix'
			-- `a_validated' indicates if `a_fix' has been validated.
			-- `a_id' indicates whether the fix ID is included.
		local
			l_fdouble: FORMAT_DOUBLE
			l_rank: STRING
		do
			create Result.make (64)
			Result.append (once "fix_")
			if a_validated then
				if a_fix.is_valid then
					Result.append (once "S_")
				else
					Result.append (once "F_")
				end
			else
				Result.append (once "U_")
			end
			create l_fdouble.make (6, 3)
			Result.append ("SYN_")
			l_rank := l_fdouble.formatted (a_fix.ranking.syntax_score)
			l_rank.left_adjust
			Result.append (l_rank)
			Result.append (once "__")
			Result.append ("SEM_")
			l_rank := l_fdouble.formatted (a_fix.ranking.impact_on_passing_test_cases)
			l_rank.left_adjust
			Result.append (l_rank)
			Result.append (once "__")

			inspect
				a_fix.skeleton_type
			when {AFX_FIX}.afore_skeleton_type then
				Result.append ("AFOR")
			when {AFX_FIX}.wrapping_skeleton_type then
				Result.append ("WRAP")
			else
				Result.append ("NONE")
			end

			if a_id then
				Result.append ("__" + a_fix.id.out)
			end
		end

	fix_file_name (a_fix: AFX_FIX; a_validated: BOOLEAN): STRING
			-- File name to store `a_fix'.
			-- `a_validated' indicates if `a_fix' has been validated.
		local
			l_fdouble: FORMAT_DOUBLE
			l_rank: STRING
		do
			create Result.make (64)
			Result.append (fix_signature (a_fix, a_validated, True))
			Result.append (".txt")
		end

feature -- State

	state_shrinker: AFX_STATE_SHRINKER
			-- State shrinker
		once
			create Result
		end

feature -- Contract extraction

	precondition_expressions (a_context_class: CLASS_C; a_feature: FEATURE_I): DS_HASH_SET [EPA_EXPRESSION]
			-- List of precondition assertions of `a_feature' in `a_context_class'
		local
			l_exprs: LINKED_LIST [AUT_EXPRESSION]
			l_expr: EPA_AST_EXPRESSION
		do
			l_exprs := precondition_of_feature (a_feature, a_context_class)

			create Result.make (l_exprs.count)
			Result.set_equality_tester (expression_equality_tester)

			fixme ("Require else assertions are ignored. 30.12.2009 Jasonw")
			extend_expression_in_set (
				l_exprs,
				agent (a_expr: AUT_EXPRESSION): BOOLEAN do Result := not a_expr.is_require_else end,
				Result,
				a_context_class,
				a_feature)
		end

	postconditions_expressions (a_context_class: CLASS_C; a_feature: FEATURE_I): DS_HASH_SET [EPA_EXPRESSION]
			-- List of postcondition assertions of `a_feature' in `a_context_class'
		local
			l_exprs: LINKED_LIST [AUT_EXPRESSION]
		do
			l_exprs := postcondition_of_feature (a_feature, a_context_class)

			create Result.make (l_exprs.count)
			Result.set_equality_tester (expression_equality_tester)

			extend_expression_in_set (
				l_exprs,
				agent (a_expr: AUT_EXPRESSION): BOOLEAN do Result := True end,
				Result,
				a_context_class,
				a_feature)
		end

	invariant_expressions (a_context_class: CLASS_C; a_feature: FEATURE_I): DS_HASH_SET [EPA_EXPRESSION]
			-- List of class invariant assertions in `a_context_class'
		local
			l_exprs: LINKED_LIST [AUT_EXPRESSION]
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
				agent (a_expr: AUT_EXPRESSION): BOOLEAN do Result := True end,
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

	extend_expression_in_set (a_exprs: LINKED_LIST [AUT_EXPRESSION]; a_test: PREDICATE [ANY, TUPLE [AUT_EXPRESSION]]; a_set: DS_HASH_SET [EPA_EXPRESSION]; a_context_class: CLASS_C; a_feature: FEATURE_I)
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

feature -- Process

	output_from_program (a_command: STRING; a_working_directory: detachable STRING): STRING
			-- Output from the execution of `a_command' in (possibly) `a_working_directory'.
			-- Note: You may need to prune the final new line character.
		do
			Result := output_from_program_with_input_file (a_command, a_working_directory, Void)
		end

	output_from_program_with_input_file (a_command: STRING; a_working_directory: detachable STRING; a_input_file: detachable STRING): STRING
			-- Output from the execution of `a_command' in (possibly) `a_working_directory'.
			-- Note: You may need to prune the final new line character.
			-- If `a_input_file' is attached, redirect input to that file.
		local
			l_prc_factory: PROCESS_FACTORY
			l_prc: PROCESS
			l_buffer: STRING
		do
			create l_prc_factory
			l_prc := l_prc_factory.process_launcher_with_command_line (a_command, a_working_directory)
			create Result.make (1024)
			l_prc.redirect_output_to_agent (agent Result.append ({STRING}?))
			if a_input_file /= Void then
				l_prc.redirect_input_to_file (a_input_file)
			end
			l_prc.launch
			if l_prc.launched then
				l_prc.wait_for_exit
			end
		end

feature -- Access

	solver_expression (a_expr: EPA_EXPRESSION): AFX_SOLVER_EXPR
			-- Solver expression from `a_expr'
		local
			l_resolved: TUPLE [resolved_str: STRING; mentioned_classes: DS_HASH_SET [AFX_CLASS_WITH_PREFIX]]
			l_shared_theory: AFX_SHARED_CLASS_THEORY
			l_raw_text: STRING
		do
			create l_shared_theory
			l_shared_theory.solver_expression_generator.initialize_for_generation
			l_shared_theory.solver_expression_generator.generate_expression (a_expr.ast, a_expr.class_, a_expr.written_class, a_expr.feature_)
			l_raw_text := l_shared_theory.solver_expression_generator.last_statements.first
			l_resolved := l_shared_theory.resolved_smt_statement (l_raw_text, create {AFX_CLASS_WITH_PREFIX}.make (a_expr.class_, ""))
			Result := new_solver_expression_from_string (l_resolved.resolved_str)
		end

	expression_as_state_skeleton (a_expr: EPA_EXPRESSION): AFX_STATE_SKELETON
			-- State skeleton including `a_expr'
		require
			a_expr_is_predicate: a_expr.is_predicate
		local
			l_exprs: LINKED_LIST [EPA_EXPRESSION]
		do
			create l_exprs.make
			l_exprs.extend (a_expr)

			create Result.make_with_expressions (a_expr.class_, a_expr.feature_, l_exprs)
		end

	equation_as_state (a_equation: AFX_EQUATION): AFX_STATE
			-- State representing `a_equation'.
			-- The returned state only contains Current as the only predicate.
		do
			create Result.make (1, a_equation.class_, a_equation.feature_)
			Result.force_last (a_equation)
		end

	equation_with_value (a_expr: EPA_EXPRESSION; a_value: EPA_EXPRESSION_VALUE): AFX_EQUATION
			-- Equation with current as expression and `a_value' as value.
		do
			create Result.make (a_expr, a_value)
		end

	equation_with_random_value (a_expr: EPA_EXPRESSION): AFX_EQUATION
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

end
