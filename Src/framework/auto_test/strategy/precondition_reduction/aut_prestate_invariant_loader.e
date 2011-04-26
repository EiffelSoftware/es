note
	description: "Class to load pre-state invariants"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PRESTATE_INVARIANT_LOADER

inherit
	REFACTORING_HELPER

	EPA_UTILITY

	EPA_STRING_UTILITY

	KL_SHARED_FILE_SYSTEM

	SHARED_AST_CONTEXT

	EPA_SHARED_EXPR_TYPE_CHECKER

	AST_ITERATOR
		redefine
			process_nested_as,
			process_binary_as
		end

	AUT_SHARED_EQUALITY_TESTER

feature -- Access

	last_invariants: LINKED_LIST [AUT_STATE_INVARIANT]
			-- Pre-state invariant loaded by last `load'

	last_feature: FEATURE_I
			-- Feature where `last_invariants' appear

	last_class: CLASS_C
			-- Class where `last_feature' is viewed

feature -- Basic operations

	load (a_path: STRING)
			-- Load pre-state invariants from file whose
			-- absolute path is given by `a_path'.
			-- Make results available in `last_invariants',
			-- `last_class' and `last_feature'.
		local
			l_parts: LIST [STRING]
			l_file: PLAIN_TEXT_FILE
			l_file_searcher: EPA_FILE_SEARCHER
			l_files: LINKED_LIST [STRING]
			l_line: STRING
		do
			fixme ("This splitting does not work if some features ends with underscore.")

				-- Collect all invariant files specified by `a_path'.
			create l_files.make
			create l_file.make (a_path)
			if l_file.is_directory then
				create l_file_searcher.make_with_pattern (".+all__noname\.inv$")
				l_file_searcher.set_is_dir_matched (False)
				l_file_searcher.set_is_search_recursive (True)
				l_file_searcher.file_found_actions.extend (
					agent (a_full_path: STRING; a_file_name: STRING; l_list: LINKED_LIST [STRING])
						do
							l_list.extend (a_full_path)
						end (?, ?, l_files))
				l_file_searcher.search (a_path)
			else
				l_files.extend (a_path)
			end

				-- Collect all invariants from files.
			create last_invariants.make
			across l_files as l_inv_files loop
				if l_inv_files.item.has_substring ("implication") then
						-- Inferred implication validation
					create l_file.make_open_read (l_inv_files.item)
					load_implications (l_file)
					l_file.close
				else
					l_parts := string_slices (file_system.basename (l_inv_files.item), "__")
					last_class := first_class_starts_with_name (l_parts.i_th (1).out)
					last_feature := last_class.feature_named (l_parts.i_th (2).out)
					create last_class_creators.make (10)
					last_class_creators.compare_objects
					across last_class.creators as l_creators loop
						last_class_creators.force (True, l_creators.key)
					end

					operands := operands_of_feature (last_feature)
					operand_types := resolved_operand_types_with_feature (last_feature, last_class, last_class.constraint_actual_type)

					if last_feature /= Void then
						create l_file.make_open_read (l_inv_files.item)
						from
							l_file.read_line
						until
							l_file.after
						loop
							l_line := l_file.last_string.twin
							l_line.left_adjust
							l_line.right_adjust
							if not l_line.is_empty then
								if attached invariant_from_string (l_line, Void, Void) as l_inv then
									last_invariants.extend (l_inv)
								end
							end
							l_file.read_line
						end
						l_file.close
					end
				end
			end
		end

	load_implications (a_file: PLAIN_TEXT_FILE)
			-- Load implications from `a_file'.
		local
			l_line: STRING
			l_inv_tbl: HASH_TABLE [LINKED_LIST [AUT_STATE_INVARIANT], STRING]
			l_last_inv: AUT_STATE_INVARIANT
			l_last_key: STRING
			l_premises_expr: EPA_AST_EXPRESSION
			l_consequent_expr: EPA_AST_EXPRESSION
			l_structure_analyzer: AUT_EXPRESSION_STRUCTURE_ANALYZER
			l_premise_str: STRING
			l_consequent_str: STRING
			l_parts: LIST [STRING]
			l_premise: EPA_AST_EXPRESSION
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_tmp_str: STRING
			l_inv: AUT_STATE_INVARIANT
			l_qualifier: EPA_EXPRESSION_QUALIFIER
		do
			create l_qualifier
			create l_inv_tbl.make (50)
			l_inv_tbl.compare_objects
			from
				a_file.read_line
			until
				a_file.after
			loop
				l_line := a_file.last_string.twin
				if not l_line.is_empty then
					if l_line.starts_with (once "%T") then
						l_line.left_adjust
						l_line.right_adjust
						if l_premises_expr.type /= Void and then l_consequent_expr.type /= Void then
							l_inv := invariant_from_string (l_line, l_premises_expr, l_consequent_expr)
							if l_inv /= Void then
								l_inv.set_is_implication (True)
								l_inv_tbl.item (l_last_key).extend (l_inv)
								last_invariants.extend (l_inv)
							end
						end
					else
						l_last_key := l_line.twin
						if not l_inv_tbl.has (l_last_key) then
							l_inv_tbl.force (create {LINKED_LIST [AUT_STATE_INVARIANT]}.make, l_last_key)
							l_parts := l_last_key.split (':')
							l_tmp_str := l_parts.first
							l_tmp_str.left_adjust
							l_tmp_str.right_adjust
							l_parts := l_tmp_str.split ('.')
							l_class := first_class_starts_with_name (l_parts.first)
							l_feature := l_class.feature_named (l_parts.last)
							last_class := l_class
							last_feature := l_feature
							create last_class_creators.make (10)
							last_class_creators.compare_objects
							across last_class.creators as l_creators loop
								last_class_creators.force (True, l_creators.key)
							end

							operands := operands_of_feature (last_feature)
							operand_types := resolved_operand_types_with_feature (last_feature, last_class, last_class.constraint_actual_type)

							l_tmp_str := l_last_key.substring (l_last_key.index_of (':', 1) + 1, l_last_key.count)
							l_tmp_str.left_adjust
							l_tmp_str.right_adjust
							l_parts := string_slices (l_tmp_str, "implies")
							l_premise_str := l_parts.first
							l_premise_str.left_adjust
							l_premise_str.right_adjust
							l_premise_str := text_from_ast (ast_without_old_expression (ast_from_expression_text (l_premise_str)))
							l_consequent_str := l_parts.last
							l_consequent_str.left_adjust
							l_consequent_str.right_adjust
							create l_premises_expr.make_with_text (l_class, l_feature, l_premise_str, l_class)
							l_qualifier.qualify_only_current (l_premises_expr)
							create l_premises_expr.make_with_text (l_class, l_feature, l_qualifier.last_expression, l_class)
							create l_consequent_expr.make_with_text (l_class, l_feature, l_consequent_str, l_class)
							l_qualifier.qualify_only_current (l_consequent_expr)
							create l_consequent_expr.make_with_text (l_class, l_feature, l_qualifier.last_expression, l_class)
						end
					end
				end
				a_file.read_line
			end
		end

feature{NONE} -- Implementation

	invariant_from_string (a_text: STRING; a_pre_inv: detachable EPA_EXPRESSION; a_post_inv: detachable EPA_EXPRESSION): detachable AUT_STATE_INVARIANT
			-- Invariant in `a_text', in form of curly-braced integers.
			-- For example, "{0}.has ({1}).
			-- If `a_text' is a supported invariant, put it in `last_invariants'.
		local
			l_done: BOOLEAN
			l_opd_index: INTEGER
			l_operands: like operands_with_feature
			l_text: STRING
			l_expr: EPA_AST_EXPRESSION
			l_index: INTEGER
			l_sub_text: STRING
			l_left, l_right: EPA_AST_EXPRESSION
			l_parts: LIST [STRING]
			l_status: BOOLEAN
			l_pre_status: BOOLEAN
			l_ori_expr: EPA_AST_EXPRESSION
			l_values: LINKED_LIST [EPA_EXPRESSION]
			l_value: EPA_AST_EXPRESSION
			l_str: STRING
			l_inv: AUT_STATE_INVARIANT
			l_structure: STRING
		do
				-- Replace Daikon style "==" with Eiffel style "=".			
			l_text := a_text.twin
			l_text.replace_substring_all ("or else", "or")
			l_text.replace_substring_all ("and then", "and")

			l_index := l_text.substring_index (" == ", 1)

			if l_index > 0 then
				l_sub_text := l_text.substring (1, l_index - 1)
			end

			if l_text.has_substring (" == ") then
				l_text.replace_substring_all (" == ", ") = ")
				l_text.prepend ("(")
			end

				-- Ignore invariant stating that "Current /= Void", because
				-- it is a tautology.
			if l_text ~ once "{0} /= Void" then
				l_done := True
			end

				-- Ignore this invariant because it is tautology and
				-- it appears many many times.
			if l_text.has_substring ("same_equality_tester") then
				l_done := True
			end

				-- Ignore invariants mentioning implication operator.			
			if l_text.has_substring ("implies") then
				l_done := True
			end

				-- Ignore invariants mentioning "Void" because they are usually
				-- not very interesting.
			if l_text.has_substring ("Void")  then
				if
					l_text ~ "{1} = Void" or else
					l_text ~ "{1} /= Void" or else
					l_text ~ "{2} = Void" or else
					l_text ~ "{2} /= Void" or else
					l_text ~ "{3} = Void" or else
					l_text ~ "{3} /= Void" or else
					l_text ~ "{4} = Void" or else
					l_text ~ "{4} /= Void" or else
					l_text ~ "{5} = Void" or else
					l_text ~ "{5} /= Void" or else
					l_text ~ "{6} = Void" or else
					l_text ~ "{6} /= Void"
				then
				else
					l_done := True
				end
			end


			if l_text.has_substring ("{0}.item_for_iteration ~ {1}") then
				l_done := True
			end

				-- Ignore invariants related to type mismatch.
			if l_text.has_substring ("mismatch") then
				l_done := True
			end

				-- Ingore expressions which contain more than 1 nested level, for example, a.b.c,
				-- because the theory generator cannot support such expressions.
			if not l_done then
				l_parts := l_text.split (' ')
				from
					l_parts.start
				until
					l_parts.after or else l_done
				loop
					l_done := l_parts.item_for_iteration.occurrences ('.') > 1
					l_parts.forth
				end
			end

				-- Ignore Daikon "has only one value" invariant.
			if not l_done and then l_text.has_substring (once "has only one value") then
				l_done := True
			end

				-- Ignore pre-state invariants mentioning Result.
			if not l_done then
				if last_feature.has_return_value then
					if l_text.has_substring (curly_brace_surrounded_integer (operand_count_of_feature (last_feature))) then
						l_done := True
					end
				end
			end

			if not l_done then
				l_operands := operands_with_feature (last_feature)
				from
					l_opd_index := 0
				until
					l_opd_index > 9
				loop
					l_text.replace_substring_all (curly_brace_surrounded_integer (l_opd_index), l_operands.item (l_opd_index))
					if l_sub_text /= Void then
						l_sub_text.replace_substring_all (curly_brace_surrounded_integer (l_opd_index), l_operands.item (l_opd_index))
					end
					l_opd_index := l_opd_index + 1
				end

				if l_text.has_substring (once "Result") then
					l_done := True
				end

				if l_sub_text /= Void and then attached {BIN_EQ_AS} ast_from_expression_text (l_sub_text) as l_eq then
						-- Remove expressions "exp1 = exp2" where exp1 and exp2 have different type categories.
						-- For example, exp1 is of type ANY, and exp2 is of type INTEGER.
						-- If we don't remove those expressions, the last generated Boogie program will be incorrect.
						-- 27.2.2011 Jasonw
					create l_left.make_with_feature (last_class, last_feature, l_eq.left, last_class)
					create l_right.make_with_feature (last_class, last_feature, l_eq.right, last_class)
					if l_left.type /= Void and then l_right.type /= Void then
						if
							(l_left.type.is_integer xor l_right.type.is_integer) or
							(l_left.type.is_boolean xor l_right.type.is_boolean)
						then
							l_done := True
						end
					end
				end

				if not l_done then
					if l_text.has_substring ("|one_of|") then
						l_parts := string_slices (l_text, "|one_of|")
						l_str := l_parts.first
						l_str.left_adjust
						l_str.right_adjust
						create l_ori_expr.make_with_text (last_class, last_feature, l_str, last_class)
						if l_ori_expr.type /= Void then
							l_str := l_parts.last
							l_str.left_adjust
							l_str.right_adjust
							l_str.remove_head (1)
							l_str.remove_tail (1)
							create l_values.make
							across l_str.split (',') as l_strs loop
								l_str := l_strs.item
								l_str.left_adjust
								l_str.right_adjust
								create l_value.make_with_text (last_class, last_feature, l_str, last_class)
								l_values.extend (l_value)
							end
							create l_inv.make_as_one_of (l_ori_expr, l_values, last_class, last_feature, a_pre_inv, a_post_inv)
							set_last_expression_structure ({AUT_STATE_INVARIANT}.structure_INT)
							l_inv.set_structure (last_expression_structure)
							if is_expression_exported (l_inv.expression) then
								Result := l_inv
							end
						end
					else
							-- NOTE: We ignore these cases because they will cause Boogie theory
							-- generation to fail and they are not interesting invariants, which
							-- means that even if we take care of them, it is very easy to violate
							-- them. But since this is a bug in our algorithm, we need to fix the
							-- Boogie generation problem in the future. 18.03.2011 Jasonw.
						fixme ("Take care of this case in the future. 18.03.2011 Jasonw")
						if
							l_text.has_substring (once "v = i") or else
							l_text.has_substring (once "v ~ i") or else
							l_text.has_substring (once "i = v") or else
							l_text.has_substring (once "i ~ v")
						then
							-- Ingore
						else
							l_status := context.is_ignoring_export
							l_pre_status := expression_type_checker.is_checking_precondition
							context.set_is_ignoring_export (False)
							expression_type_checker.set_is_checking_precondition (True)

							create l_expr.make_with_feature (last_class, last_feature, final_invariant_ast (l_text), last_class)
							if
								l_expr.type /= Void and then
								is_expression_exported (l_expr) and then
								not is_non_conformant_comparison (l_expr) and then
								not is_current_mentioned_in_creator (l_expr) and then
								not has_qualified_object_comparison (l_expr)
							then
								if a_pre_inv /= Void then
									create l_expr.make_with_text (last_class, last_feature, a_pre_inv.text + " and (" + l_expr.text + ")", last_class)
								end
								create Result.make (l_expr, last_class, last_feature)
								Result.set_structure (last_expression_structure)
							end
							context.set_is_ignoring_export (l_status)
							expression_type_checker.set_is_checking_precondition (l_pre_status)
						end
					end
				end
			end
			if Result /= Void then
				if a_pre_inv /= Void then
					Result.set_pre_state_context_expression (a_pre_inv)
				end
				if a_post_inv /= Void then
					Result.set_post_state_context_expression (a_post_inv)
				end
			end
		end

	final_invariant_ast (a_text: STRING): EXPR_AS
			-- Final AST for `a_text'
			-- Translate `a_text' in form of "expr = False"
		local
			l_str: STRING
			l_text: STRING
		do
			l_str := a_text.twin
			check attached {EXPR_AS} ast_from_expression_text (l_str) as l_ast then
				if attached {BINARY_AS} l_ast as l_bin then
					if attached {VOID_AS} l_bin.right and then l_bin.op_name.name ~ "/=" then
						Result := ast_from_expression_text (text_from_ast (ast_without_surrounding_paranthesis (l_bin.left)) + " = Void")
						set_last_expression_structure ({AUT_STATE_INVARIANT}.structure_VOD)
					elseif attached {VOID_AS} l_bin.right and then l_bin.op_name.name ~ "=" then
						Result := ast_from_expression_text (text_from_ast (ast_without_surrounding_paranthesis (l_bin.left)) + " /= Void")
						set_last_expression_structure ({AUT_STATE_INVARIANT}.structure_VOD)
					elseif attached {BOOL_AS} l_bin.right as l_right then
						l_str := text_from_ast (ast_without_surrounding_paranthesis (l_bin.left))
						if a_text.has_substring (" and ") then
							set_last_expression_structure ({AUT_STATE_INVARIANT}.structure_CPX)
							if l_right.value then
								create l_text.make (256)
								across string_slices (l_str, " and ") as l_parts loop
									if not l_text.is_empty then
										l_text.append (" or ")
									end
									l_parts.item.left_adjust
									l_parts.item.right_adjust
									l_text.append ("not (")
									l_text.append (l_parts.item)
									l_text.append (")")
								end
								Result := ast_from_expression_text (l_text)
							else
								Result := ast_from_expression_text (l_str)
							end
						elseif a_text.has_substring (" or ") then
							if l_right.value then
								Result := ast_from_expression_text (l_str)
							else
								create l_text.make (256)
								across string_slices (l_str, " or ") as l_parts loop
									if not l_text.is_empty then
										l_text.append (" and ")
									end
									l_parts.item.left_adjust
									l_parts.item.right_adjust
									l_text.append ("not (")
									l_text.append (l_parts.item)
									l_text.append (")")
								end
								Result := ast_from_expression_text (l_str)
							end
							set_last_expression_structure ({AUT_STATE_INVARIANT}.structure_CPX)
						else
							if l_right.value then
								Result := ast_from_expression_text ("not (" + l_str + ")")
							else
								Result := ast_from_expression_text (l_str)
							end
							if attached {BINARY_AS} ast_from_expression_text (l_str) as l_bin2 then
								if attached {INTEGER_AS} l_bin2.right as l_right2 then
									set_last_expression_structure ({AUT_STATE_INVARIANT}.structure_INT)
								elseif l_bin2.op_name.name.has ('=') then
									set_last_expression_structure ({AUT_STATE_INVARIANT}.structure_REC)
								elseif l_bin2.op_name.name.has ('~') then
									set_last_expression_structure ({AUT_STATE_INVARIANT}.structure_OEC)
								else
									set_last_expression_structure ({AUT_STATE_INVARIANT}.structure_CPX)
								end
							else
								if l_str.has ('~') then
									set_last_expression_structure ({AUT_STATE_INVARIANT}.structure_OEC)
								elseif l_str.has ('=') then
									set_last_expression_structure ({AUT_STATE_INVARIANT}.structure_REC)
								elseif l_str.has ('.') then
									if l_str.has ('(') then
										set_last_expression_structure ({AUT_STATE_INVARIANT}.structure_BQY)
									else
										set_last_expression_structure ({AUT_STATE_INVARIANT}.structure_ABQ)
									end
								else
									set_last_expression_structure ({AUT_STATE_INVARIANT}.structure_CPX)
								end
							end
						end
					else
						l_str := text_from_ast (ast_without_surrounding_paranthesis (l_bin))
						Result := ast_from_expression_text ("not (" + l_str + ")")
						if l_str.has_substring (once " and ") or else l_str.has_substring (once " or ") then
							set_last_expression_structure ({AUT_STATE_INVARIANT}.structure_CPX)
						elseif attached {INTEGER_AS} l_bin.right as l_int then
							set_last_expression_structure ({AUT_STATE_INVARIANT}.structure_INT)
						elseif l_bin.op_name.name ~ "=" or l_bin.op_name.name ~ "/=" then
							set_last_expression_structure ({AUT_STATE_INVARIANT}.structure_REC)
						elseif l_bin.op_name.name ~ "~" or l_bin.op_name.name ~ "/~"   then
							set_last_expression_structure ({AUT_STATE_INVARIANT}.structure_OEC)
						else
							set_last_expression_structure ({AUT_STATE_INVARIANT}.structure_CPX)
						end
					end
				else
					Result := ast_from_expression_text ("not (" + l_str + ")")
					set_last_expression_structure ({AUT_STATE_INVARIANT}.structure_CPX)
				end
			end
		end

	is_expression_exported (a_expression: EPA_EXPRESSION): BOOLEAN
			-- Are all components of `a_expression' exported to {ANY}?
		do
			is_expression_exported_internal := True
			safe_process (a_expression.ast)
			Result := is_expression_exported_internal
		end

	has_qualified_object_comparison (a_expression: EPA_EXPRESSION): BOOLEAN
			-- Is there any object/reference comparison between qualified expression?
		do
			has_qualified_object_comparison_internal := False
			last_expression := a_expression
			is_checking_has_qualified_object_comparison := True
			safe_process (a_expression.ast)
			is_checking_has_qualified_object_comparison := False
			Result := has_qualified_object_comparison_internal
		end

	last_expression: EPA_EXPRESSION

	is_checking_has_qualified_object_comparison: BOOLEAN

	has_qualified_object_comparison_internal: BOOLEAN
			-- Cache of `has_qualified_object_comparison'

	is_non_conformant_comparison (a_expression: EPA_EXPRESSION): BOOLEAN
			-- Is `a_expression' a object/reference equality comparison between two non-conformant expression?
		local
			l_left, l_right: EXPR_AS
			l_is_comp: BOOLEAN
			l_left_expr, l_right_expr: EPA_AST_EXPRESSION
			l_left_type: TYPE_A
			l_right_type: TYPE_A
			l_ast: EXPR_AS
		do
			l_ast := a_expression.ast
			if attached {BIN_EQ_AS} l_ast as l_eq then
				if attached {BOOL_AS} l_eq.right then
					l_ast := l_eq.left
				end
			elseif attached {BIN_NE_AS} l_ast as l_eq then
				if attached {BOOL_AS} l_eq.right then
					l_ast := l_eq.left
				end
			end

			if attached {PARAN_AS} l_ast as l_paran then
				l_ast := l_paran.expr
			end
			if attached {PARAN_AS} l_ast as l_paran then
				l_ast := l_paran.expr
			end
			if attached {PARAN_AS} l_ast as l_paran then
				l_ast := l_paran.expr
			end

			if attached {BIN_EQ_AS} l_ast as l_eq then
				l_is_comp := True
				l_left := l_eq.left
				l_right := l_eq.right
			elseif attached {BIN_NE_AS} l_ast as l_ne then
				l_is_comp := True
				l_left := l_ne.left
				l_right := l_ne.right
			elseif attached {BIN_TILDE_AS} l_ast as l_tilde then
				l_is_comp := True
				l_left := l_tilde.left
				l_right := l_tilde.right
			elseif attached {BIN_NOT_TILDE_AS} l_ast as l_not_tilde then
				l_is_comp := True
				l_left := l_not_tilde.left
				l_right := l_not_tilde.right
			end
			if l_is_comp then
				create l_left_expr.make_with_feature (last_class, last_feature, l_left, last_class)
				create l_right_expr.make_with_feature (last_class, last_feature, l_right, last_class)
				if l_left_expr.type /= Void and then l_right_expr.type /= Void then
					l_left_type := l_left_expr.type.actual_type
					l_left_type := actual_type_from_formal_type (l_left_type, last_class)
					l_left_Type := l_left_type.actual_type.instantiation_in (last_class.constraint_actual_type, last_class.class_id)

					l_right_type := l_right_expr.type.actual_type
					l_right_type := actual_type_from_formal_type (l_right_type, last_class)
					l_right_Type := l_right_type.actual_type.instantiation_in (last_class.constraint_actual_type, last_class.class_id)
					if
						not l_left_type.conform_to (last_class, l_right_type) and then
						not l_right_type.conform_to (last_class, l_left_type)
					then
						Result := True
					end
				end
			end
		end

	is_expression_exported_internal: BOOLEAN
			-- Cache for `is_expression_exported'

	is_current_mentioned_in_creator (a_expression: EPA_EXPRESSION): BOOLEAN
			-- Is "Current" mentioned in `a_expression' and `last_feature' happen to be a creator?
		do
			if a_expression.text.has_substring (ti_current) and then last_class_creators.has (last_feature.feature_name.as_lower) then
				Result := True
			end
		end

	process_nested_as (l_as: NESTED_AS)
		local
			l_target: STRING
			l_call: STRING
			l_target_type: TYPE_A
			l_target_class: CLASS_C
			l_feat: FEATURE_I
		do
			if is_expression_exported_internal then
				l_target := text_from_ast (l_as.target)
				l_call := text_from_ast (l_as.message)
				if operands.has (l_target) then
					if l_call.has ('(') then
						l_call.keep_head (l_call.index_of ('(', 1) - 1)
					end
					l_call.left_adjust
					l_call.right_adjust
					l_target_type := operand_types.item (operands.item (l_target))
					l_target_class := l_target_type.associated_class
					if l_target_class /= Void then
						l_feat := l_target_class.feature_named (l_call)
						if l_feat /= Void then
							is_expression_exported_internal := l_feat.is_exported_for (workbench.system.any_class.compiled_representation)
						end
					end
				end
				if is_expression_exported_internal then
					Precursor (l_as)
				end
			end
		end

	process_binary_as (l_as: BINARY_AS)
			-- (export status {NONE})
		local
			l_operator: STRING
			l_left_expr: EPA_AST_EXPRESSION
			l_right_expr: EPA_AST_EXPRESSION
		do
			Precursor (l_as)

			if is_checking_has_qualified_object_comparison then
				l_operator := l_as.op_name.name
				if l_operator ~ "=" or l_operator ~ "/=" or l_operator ~ "~" or l_operator ~ "/~" then
					create l_left_expr.make_with_feature (last_expression.class_, last_expression.feature_, l_as.left, last_expression.written_class)
					if l_left_expr.type /= Void and then not (l_left_expr.type.is_boolean or l_left_expr.type.is_integer) then
						create l_right_expr.make_with_feature (last_expression.class_, last_expression.feature_, l_as.right, last_expression.written_class)
						if l_right_expr.type /= Void and then not (l_right_expr.type.is_boolean or l_right_expr.type.is_integer) then
							if has_qualified_object_comparison_internal = False then
								has_qualified_object_comparison_internal :=
									text_from_ast (l_as.left).has ('.') or else
									text_from_ast (l_as.right).has ('.')
							end
						end
					end

					l_as.left.process (Current)
					l_as.right.process (Current)
				end
			end
		end

	operand_types: like resolved_operand_types_with_feature

	operands: like operands_of_feature

	last_class_creators: HASH_TABLE [BOOLEAN, STRING]
			-- Names of the creation procedures of `last_class'
			-- Keys are creator names, values are dummy values

	last_expression_structure: STRING
			-- Structure of the last processed expression

	set_last_expression_structure (a_structure: STRING)
			-- Set `last_expression_structure' with `a_structure'.
		do
			last_expression_structure := a_structure.twin
		ensure
			last_expression_structure_set: last_expression_structure = a_structure
		end

;note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
