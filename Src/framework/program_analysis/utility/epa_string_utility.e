note
	description: "Various helper functions to generate strings"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_STRING_UTILITY

inherit
	EPA_TYPE_UTILITY

	EPA_UTILITY

	EPA_SHARED_EQUALITY_TESTERS

	ITP_SHARED_CONSTANTS

feature -- Access

	curly_brace_surrounded_integer (i: INTEGER): STRING
			-- An interger surrounded by curly braces
			-- For example {0}.
		do
			create Result.make (20)
			Result.append_character ('{')
			Result.append (i.out)
			Result.append_character ('}')
		end

	double_square_surrounded_integer (i: INTEGER): STRING
			-- An interger surrounded by double square braces.
			-- For example [[0]].
		do
			create Result.make (20)
			Result.append (once "[[")
			Result.append (i.out)
			Result.append (once "]]")
		end

	curly_brace_surrounded_typed_integer (i: INTEGER; a_type: TYPE_A): STRING
			-- An interger (with type) surrounded by curly braces
			-- For example {LINKED_LIST [ANY] @ 1}
		do
			create Result.make (32)
			Result.append_character ('{')
			Result.append (cleaned_type_name (a_type.name))
			Result.append (once " @ ")
			Result.append (i.out)
			Result.append_character ('}')
		end

	anonymous_variable_name (a_position: INTEGER): STRING
			-- Anonymous name for `a_position'-th variable
			-- Format: {`a_position'}, for example "{0}".
		do
			Result := curly_brace_surrounded_integer (a_position)
		end


	curly_braced_operands_from_operands (a_feature: FEATURE_I; a_class: CLASS_C): HASH_TABLE [STRING, STRING]
			-- A mapping from actual operands from `a_feature' viewed in `a_class' to
			-- the curly-braced integer form of those operands.
			-- For example, if `a_feature' is ARRAY.put, then the result would be:
			-- Current -> {0}, v -> {1}, i -> {2}.
		local
			l_operands: like operands_of_feature
		do
			l_operands := operands_of_feature (a_feature)
			create Result.make (l_operands.count)
			Result.compare_objects
			from
				l_operands.start
			until
				l_operands.after
			loop
				Result.force (curly_brace_surrounded_integer (l_operands.item_for_iteration), l_operands.key_for_iteration)
				l_operands.forth
			end
		end

	operands_from_curly_braced_operands (a_feature: FEATURE_I; a_class: CLASS_C): HASH_TABLE [STRING, STRING]
			-- A mapping from curly-braced operands from `a_feature' viewed in `a_class' to
			-- actual operands of those operands.
			-- For example, if `a_feature' is ARRAY.put, then the result would be:
			-- {0} -> Current, {1} -> v, {2} -> i.
		local
			l_operands: like operands_of_feature
		do
			l_operands := operands_of_feature (a_feature)
			create Result.make (l_operands.count)
			Result.compare_objects
			from
				l_operands.start
			until
				l_operands.after
			loop
				Result.force (l_operands.key_for_iteration, curly_brace_surrounded_integer (l_operands.item_for_iteration))
				l_operands.forth
			end
		end

	class_name_dot_feature_name (a_class: CLASS_C; a_feature: FEATURE_I): STRING
			-- String in form of "CLASS_NAME.feature_name' where
			-- the class name is from `a_class' and feature name is from `a_feature'
		do
			create Result.make (a_class.name.count + a_feature.feature_name.count + 1)
			Result.append (a_class.name_in_upper)
			Result.append_character ('.')
			Result.append (a_feature.feature_name)
		end

	curly_braced_variables_from_expression (a_expression: STRING): HASH_TABLE [INTEGER, STRING]
			-- Variables mentioned in `a_expression'.
			-- Keys are variable names, values are indexes of those variables.
			-- In `a_expression', variables are represented by curly-braced numbers, and
			-- those numbers are the variable indexes.
			-- For example: in the expression "{0}.capacity > {1}.index", {0} is a variable with
			-- index 0, and {1} is a variable with index 1.
		local
			l_possibles: HASH_TABLE [INTEGER, STRING]
		do
			create l_possibles.make (10)
			l_possibles.compare_objects
			across 0 |..| 9 as l_indexes loop
				l_possibles.force (l_indexes.item, "{" + l_indexes.item.out + "}")
			end

			create Result.make (10)
			Result.compare_objects
			across l_possibles as l_vars loop
				if a_expression.has_substring (l_vars.key) then
					Result.force (l_vars.item, l_vars.key)
				end
			end
		end

	expression_with_curly_braced_operands (a_class: CLASS_C; a_feature: FEATURE_I; a_expression: EPA_EXPRESSION): STRING
			-- Expression whose mentioned operands from `a_feature' in `a_class' are replaced
			-- by the corresponding curly-braced integers. For example, if `a_expression' is
			-- "Current.has (v)" in LINKED_LIST.extend, the result is "{0}.has ({1})".
		local
			l_opds: DS_HASH_TABLE_CURSOR [INTEGER, STRING]
			l_replacements: HASH_TABLE [STRING, STRING]
		do
			create l_replacements.make (3)
			l_replacements.compare_objects
			from
				l_opds := operands_of_feature (a_feature).new_cursor
				l_opds.start
			until
				l_opds.after
			loop
				l_replacements.force (curly_brace_surrounded_integer (l_opds.item), l_opds.key)
				l_opds.forth
			end
			Result := expression_rewriter.expression_text (a_expression, l_replacements)
		end

	expression_from_curly_braced_operands (a_class: CLASS_C; a_feature: FEATURE_I; a_expression: STRING): EPA_EXPRESSION
			-- Expression from `a_expression'
			-- `a_expression' is in curly-integer form, and result is in normal Eiffel expression form.
			-- For example, if `a_expression' is "{0}.has ({1})" in LINKED_LIST.extend, the result
			-- is "Current.has (v)".
		local
			l_opds: DS_HASH_TABLE_CURSOR [INTEGER, STRING]
			l_text: STRING
			l_expr: EPA_AST_EXPRESSION
		do
			l_text := a_expression.twin
			across operands_from_curly_braced_operands (a_feature, a_class) as l_replacements loop
				l_text.replace_substring_all (l_replacements.key, l_replacements.item)
			end
			create l_expr.make_with_text (a_class, a_feature, l_text, a_class)
			Result := l_expr
		end

	context_for_feature_operands (a_context_class: CLASS_C; a_feature: FEATURE_I): EPA_CONTEXT
			-- Context for operands of `a_feature' viewed in `a_context_class'
			-- The variables in the resulting context have names such as "v_0" and "v_1", where
			-- 0 and 1 indicates 0-based operand indexes.
		local
			l_operand_types: like operand_types_with_feature
			l_cursor: DS_HASH_TABLE_CURSOR [TYPE_A, INTEGER]
			l_variables: HASH_TABLE [TYPE_A, STRING]
		do
			l_operand_types := resolved_operand_types_with_feature (a_feature, a_context_class, a_context_class.constraint_actual_type)
			create l_variables.make (l_operand_types.count)
			l_variables.compare_objects
			from
				l_cursor := l_operand_types.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_variables.force (l_cursor.item, variable_name_for_id (l_cursor.key))
				l_cursor.forth
			end

			create Result.make_with_class (system.root_type.associated_class, l_variables)
		end

	single_rooted_expressions (a_expression: STRING; a_context_class: CLASS_C; a_feature: FEATURE_I): DS_HASH_TABLE [TUPLE [variable_indexes: DS_HASH_SET [INTEGER]; canonical_form: STRING], EPA_EXPRESSION]
			-- Subexpressions from `a_expression'. Those subexpressions must mention at least one
			-- variable in `a_expression'. `a_context_class' and `a_feature' define the place where `a_expression'
			-- should be evaluated.
			-- Result is a hash-table. Keys are subexpressions, and values the variable indexes that those subexpressions mention.
			-- Note: The expressions in keys may not be type-checked.
			-- `a_expression' is in curly-braced format, for example, "{0}.has ({1})".
		local
			l_var_names: HASH_TABLE [STRING, STRING]
			l_vars: like curly_braced_variables_from_expression
			l_expr_text: STRING
			l_expr: EPA_EXPRESSION
			l_expr_finder: EPA_ALL_EXPRESSION_FINDER
			l_repo: DS_HASH_SET [EPA_EXPRESSION]
			l_has_var: BOOLEAN
			l_indexes: DS_HASH_SET [INTEGER]
			l_var_curly: STRING
			l_context: like context_for_feature_operands
			l_class: CLASS_C
			l_feature: FEATURE_I
		do
			l_context := context_for_feature_operands (a_context_class, a_feature)
			l_class := l_context.class_
			l_feature := l_context.feature_
			l_vars := curly_braced_variables_from_expression (a_expression)
			create l_var_names.make (l_vars.count)
			l_var_names.compare_objects
			across l_vars as l_variables loop
				l_var_names.force ({ITP_SHARED_CONSTANTS}.variable_name_prefix + l_variables.item.out, l_variables.key)
			end

				-- Contruct expression text where curly-braced numbers are replaced with actual variable names.
			create l_expr_text.make_from_string (a_expression)
			across l_var_names as l_variables loop
				l_expr_text.replace_substring_all (l_variables.key, l_variables.item)
			end

				-- Collect subexpressions.
			create {EPA_AST_EXPRESSION} l_expr.make_with_text (l_class, l_feature, l_expr_text, l_class)
			create Result.make (10)
			Result.set_key_equality_tester (expression_equality_tester)

			create l_repo.make (10)
			l_repo.set_equality_tester (expression_equality_tester)
			create l_expr_finder.make (l_class)
			l_expr_finder.search_in_ast (l_repo, l_expr.ast, l_feature)
			l_repo := l_expr_finder.last_found_expressions

			from
				l_repo.start
			until
				l_repo.after
			loop
				l_expr := l_repo.item_for_iteration
				if attached {ACCESS_FEAT_AS} l_expr.ast or else attached {EXPR_CALL_AS} l_expr.ast then
					create l_indexes.make (3)
					from
						l_has_var := False
						l_var_names.start
					until
						l_var_names.after
					loop
						if l_expr.text.has_substring (l_var_names.item_for_iteration) then
							l_var_curly := l_var_names.key_for_iteration
							l_var_curly.remove_head (1)
							l_var_curly.remove_tail (1)
							l_indexes.force_last (l_var_curly.to_integer)
						end
						l_var_names.forth
					end
					if not l_indexes.is_empty then
						Result.force_last ([l_indexes, canonical_form_of_expression (l_expr.text)], l_expr)
					end
				end
				l_repo.forth
			end
		end

	canonical_form_of_expression (a_expression: STRING): STRING
			-- Canonical form of `a_expression', with all variables
			-- replaced with $s. `a_expression' is an expression mentioning
			-- variables, for example: v_1.has (v_2)
		local
			l_possibles: HASH_TABLE [INTEGER, STRING]
		do
			create l_possibles.make (10)
			l_possibles.compare_objects
			across 0 |..| 9 as l_indexes loop
				l_possibles.force (l_indexes.item, once "v_" + l_indexes.item.out)
			end

			Result := a_expression.twin
			across l_possibles as l_vars loop
				Result.replace_substring_all (l_vars.key, once "$")
			end
		end

end
