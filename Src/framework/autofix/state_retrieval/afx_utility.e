note
	description: "Summary description for {AFX_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_UTILITY

inherit
	SHARED_WORKBENCH

	SHARED_EIFFEL_PARSER

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
			l_expr: AFX_AST_EXPRESSION
			l_text: STRING
			l_ori_expr: AFX_EXPRESSION
			l_value: AFX_BOOLEAN_VALUE
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
					if attached {AFX_BOOLEAN_VALUE} a_equation.value as l_temp_value then
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


	formated_fix (a_fix: AFX_FIX): STRING
			-- Pretty printed feature text for `a_fix'
		local
			l_printer: ETR_AST_STRUCTURE_PRINTER
			l_output: ETR_AST_STRING_OUTPUT
			l_feat_text: STRING
		do
			if a_fix.feature_text.has_substring ("should not happen") then
				Result := a_fix.feature_text.twin
			else
				entity_feature_parser.parse_from_string ("feature " + a_fix.feature_text, Void)
				create l_output.make_with_indentation_string ("%T")
				create l_printer.make_with_output (l_output)
				l_printer.print_ast_to_output (entity_feature_parser.feature_node)
				Result := l_output.string_representation
			end
		end

feature -- Logging

	store_fix_in_file (a_directory: STRING; a_fix: AFX_FIX; a_validated: BOOLEAN)
			-- Store `a_fix' as the `a_id'-th fix into a file in directory `a_directory'
			-- `a_validated' indicates if `a_fix' has been validated.
		local
			l_file: PLAIN_TEXT_FILE
			l_file_name: FILE_NAME
			l_lines: LIST [STRING]
		do
			create l_file_name.make_from_string (a_directory)
			l_file_name.set_file_name (fix_file_name (a_fix, a_validated))
			create l_file.make_create_read_write (l_file_name)

				-- Print patched feature text.
			l_file.put_string (formated_fix (a_fix))
			l_file.put_string (once "%N%N")

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

	fix_file_name (a_fix: AFX_FIX; a_validated: BOOLEAN): STRING
			-- File name to store `a_fix'.
			-- `a_validated' indicates if `a_fix' has been validated.
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
			Result.append (once "__")
			Result.append (a_fix.id.out)
			Result.append (".txt")
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

end
