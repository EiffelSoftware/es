note
	description: "Summary description for {SEM_SIMPLE_QUERY_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_SIMPLE_QUERY_GENERATOR

inherit
	EPA_SHARED_EQUALITY_TESTERS

	EPA_UTILITY

	EPA_TYPE_UTILITY

feature -- Access

	variables_from_expression (a_expression: STRING): HASH_TABLE [INTEGER, STRING]
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

	variabled_expression (a_expression: STRING): STRING
			-- Expression where curly-barced integer varaibles
			-- are replaced with actual variables such as "v_0".
		do
			create Result.make_from_string (a_expression)
			across variables_from_expression (a_expression) as l_vars loop
				Result.replace_substring_all (l_vars.key, "v_" + l_vars.item.out)
			end
		end

	subexpressions (a_expression: STRING; a_context_class: CLASS_C; a_feature: FEATURE_I): DS_HASH_TABLE [TUPLE [variable_indexes: DS_HASH_SET [INTEGER]; canonical_form: STRING], EPA_EXPRESSION]
			-- Subexpressions from `a_expression'. Those subexpressions must mention at least one
			-- variable in `a_expression'. `a_context_class' and `a_feature' define the place where `a_expression'
			-- should be evaluated.
			-- Result is a hash-table. Keys are subexpressions, and values the variable indexes that those subexpressions mention.
			-- Note: The expressions in keys may not be type-checked.
		local
			l_var_names: HASH_TABLE [STRING, STRING]
			l_vars: like variables_from_expression
			l_expr_text: STRING
			l_expr: EPA_EXPRESSION
			l_expr_finder: EPA_ALL_EXPRESSION_FINDER
			l_repo: DS_HASH_SET [EPA_EXPRESSION]
			l_has_var: BOOLEAN
			l_indexes: DS_HASH_SET [INTEGER]
			l_var_curly: STRING
		do
			l_vars := variables_from_expression (a_expression)
			create l_var_names.make (l_vars.count)
			l_var_names.compare_objects
			across l_vars as l_variables loop
				l_var_names.force ("v_" + l_variables.item.out, l_variables.key)
			end

				-- Contruct expression text where curly-braced numbers are replaced with actual variable names.
			create l_expr_text.make_from_string (a_expression)
			across l_var_names as l_variables loop
				l_expr_text.replace_substring_all (l_variables.key, l_variables.item)
			end

				-- Collect subexpressions.
			create {EPA_AST_EXPRESSION} l_expr.make_with_text (a_context_class, a_feature, l_expr_text, a_context_class)
			create Result.make (10)
			Result.set_key_equality_tester (expression_equality_tester)

			create l_repo.make (10)
			l_repo.set_equality_tester (expression_equality_tester)
			create l_expr_finder.make (a_context_class)
			l_expr_finder.search_in_ast (l_repo, l_expr.ast, a_feature)
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
						Result.force_last ([l_indexes, canonical_form (l_expr.text)], l_expr)
					end
				end
				l_repo.forth
			end
		end

	variable_mapping (a_expression: STRING): HASH_TABLE [STRING, INTEGER]
			-- Varible mapping for `a_expression'
			-- `a_expression' must be a single-root expression with variable names such as v_0, v_1.
			-- For example: v_0.has (v_1).
			-- Result is a hash-table. Keys are 1-based variable indexes, and values
			-- are those curly-brace integers. For the above example, the result would be:
			-- 1 -> v_0
			-- 2 -> v_1
		local
			l_index1: INTEGER
			l_index2: INTEGER
			l_count: INTEGER
			l_var_id: INTEGER
			l_operand: STRING
		do
			create Result.make (3)
			l_count := a_expression.count
			from
				l_var_id := 1
				l_index1 := a_expression.substring_index ("v_", 1)
			until
				l_index1 = 0
			loop
				l_index2 := l_index1 + 2
				l_operand := a_expression.substring (l_index1, l_index2)
				Result.force (l_operand, l_var_id)
				l_var_id := l_var_id + 1
				l_index1 := a_expression.substring_index ("v_", l_index2 + 1)
			end
		end

	canonical_form (a_expression: STRING): STRING
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

	sql_clauses_for_variable (a_name: STRING; a_predicates: HASH_TABLE [STRING, STRING]; a_type: detachable STRING): TUPLE [table: STRING; where_clause: STRING]
			-- SQL clauses for selecting a variable named `a_name' with
			-- properties `a_predicates', keys are predicate names, values are predicate values.
			-- `a_type' is an optional predicate to specify the type of the variable.
			-- `table' is the table clause for that variable. For example: "PropertyBindings1 v_1".
			-- `where_clause' are the predicates in WHERE section of the sql statement. For example:
			-- v_0.qry_id = q.qry_id AND
			-- v_0.prop_kind = 2
		local
			l_table: STRING
			l_where_clause: STRING
			i, c: INTEGER
		do
			create l_table.make (24)
			l_table.append (property_bindings_table_name (1))
			l_table.append_character (' ')
			l_table.append (a_name)

			create l_where_clause.make (64)
			l_where_clause.append (a_name)
			l_where_clause.append (once ".prop_id = (SELECT prop_id FROM Properties WHERE text = %"$%")")
			across a_predicates as l_preds loop
				l_where_clause.append (once " AND%N")
				l_where_clause.append (a_name)
				l_where_clause.append_character ('.')
				l_where_clause.append (l_preds.key)
				l_where_clause.append_character ('=')
				l_where_clause.append (l_preds.item)
			end

			if a_type /= Void then
				l_where_clause.append (once " AND%N")
				l_where_clause.append (a_name)
				l_where_clause.append (once ".type1 = (SELECT type_id FROM Types WHERE type_name =%"" + a_type + "%")")
			end

			l_where_clause.append_character ('%N')

			Result := [l_table, l_where_clause]
		end

	sql_clauses_for_property (a_property_name: STRING; a_text: STRING; a_predicates: HASH_TABLE [STRING, STRING]): TUPLE [table: STRING; where_clause: STRING]
			-- SQL clauses for selecting a property named `a_text'.
			-- `a_property_name' is the name to be mentioned in the SQL statements (Table name alias).
			-- `a_text' is the property expression, for example v_1.has (v_2).
			-- properties `a_predicates', keys are predicate names, values are predicate values.
			-- `table' is the table clause for that variable. For example: "PropertyBindings1 v_1".
			-- `where_clause' are the predicates in WHERE section of the sql statement.
		local
			l_canonical: STRING
			l_mapping: like variable_mapping
			l_var_count: INTEGER
			l_table: STRING
			l_where_clause: STRING
		do
			l_canonical := canonical_form (a_text)
			l_mapping := variable_mapping (a_text)
			l_var_count := l_mapping.count

				-- Setup table name for the property.
			create l_table.make (24)
			l_table.append (property_bindings_table_name (l_var_count))
			l_table.append_character (' ')
			l_table.append (a_property_name)

				-- Setup property name.
			create l_where_clause.make (128)
			l_where_clause.append (a_property_name)
			l_where_clause.append (once ".prop_id = (SELECT prop_id FROM Properties WHERE text = %"" + l_canonical + "%")")

				-- Setup extra predicates.
			across a_predicates as l_preds loop
				l_where_clause.append (once " AND%N")
				l_where_clause.append (a_property_name)
				l_where_clause.append_character ('.')
				l_where_clause.append (l_preds.key)
				l_where_clause.append_character ('=')
				l_where_clause.append (l_preds.item)
			end

				-- Setup property operand mapping.
			across l_mapping as l_maps loop
				l_where_clause.append (once " AND%N")
				l_where_clause.append (a_property_name)
				l_where_clause.append_character ('.')
				l_where_clause.append (once "var" + l_maps.key.out)
				l_where_clause.append_character ('=')
				l_where_clause.append (l_maps.item)
				l_where_clause.append (once ".var1")
			end

			Result := [l_table, l_where_clause]
		end


	property_bindings_table_name (a_variable_count: INTEGER): STRING
			-- Table name for PropertyBindings`a_variable_count'
		do
			Result := "PropertyBindings" + a_variable_count.out
		end

	sql_to_select_objects (a_context_class: CLASS_C; a_feature: FEATURE_I; a_expression: STRING; a_negated: BOOLEAN; a_limit: INTEGER): STRING
			-- SQL statement to select objects satisfying `a_expression'.
			-- `a_negated' indicates if the semantics of `a_expression' should be negated.
			-- `a_expression' must have boolean type.
			-- `a_limit' indicates the maximal number of row to retrieve from database. 0 means unlimited rows.
		local
			l_operands: like variables_from_expression
			l_subexprs: like subexpressions
			l_var_sql: like sql_clauses_for_variable
			l_prop_sql: like sql_clauses_for_property

			l_select: STRING
			l_from: STRING
			l_where: STRING
			l_var_type: STRING
			l_var_name: STRING
			l_var_preds: HASH_TABLE [STRING, STRING]
			l_expr_cursor: DS_HASH_TABLE_CURSOR [TUPLE [variable_indexes: DS_HASH_SET [INTEGER]; canonical_form: STRING], EPA_EXPRESSION]
			l_prop_id: INTEGER
			l_prop_name: STRING
			l_context_type: TYPE_A

			l_replacements: HASH_TABLE [STRING, STRING]
			l_gen: SEM_PROPERTY_PRINTER
			l_expr: STRING
		do
			create l_replacements.make (5)
			l_replacements.compare_objects

			l_context_type := root_class_of_system.actual_type
			create l_select.make (128)
			create l_from.make (128)
			create l_where.make (512)

			l_operands := variables_from_expression (a_expression)
			l_subexprs := subexpressions (a_expression, a_context_class, a_feature)

			create l_var_preds.make (2)
			l_var_preds.compare_objects
			l_var_preds.force ("1", "prop_kind")
			l_var_preds.force ("q.qry_id", "qry_id")

			l_from.append ("FROM Queryables q")
			l_select.append ("SELECT q.qry_id as %"query_id%"")
			l_where.append ("WHERE%N")
			l_where.append ("q.qry_kind=1 AND%N")
			l_where.append ("q.class=%"" + a_context_class.name_in_upper + "%"")
			l_where.append_character ('%N')

				-- Setup variables.
			across l_operands as l_opds loop
				l_var_name := "v_" + l_opds.item.out
				l_select.append (", ")
				l_select.append (l_var_name)
				l_select.append (".var1 as ")
				l_select.append_character ('%"')
				l_select.append (l_opds.key)
				l_select.append_character ('%"')

				if l_opds.item = 0 then
					l_var_type := output_type_name (a_context_class.constraint_actual_type.name)
				else
					l_var_type := Void
				end
				l_var_sql := sql_clauses_for_variable (l_var_name, l_var_preds, l_var_type)
				l_from.append (", ")
				l_from.append (l_var_sql.table)
				l_where.append ("%NAND%N")
				l_where.append (l_var_sql.where_clause)
				l_replacements.force (l_var_name, l_var_name)
			end

				-- Setup properties.				
			from
				l_prop_id := 1
				l_expr_cursor := l_subexprs.new_cursor
				l_expr_cursor.start
			until
				l_expr_cursor.after
			loop
				if l_expr_cursor.item.canonical_form /~ once "$" then
					l_prop_name := "p_" + l_prop_id.out
					l_prop_sql := sql_clauses_for_property (l_prop_name, l_expr_cursor.key.text, l_var_preds)
					l_from.append (", ")
					l_from.append (l_prop_sql.table)
					l_where.append ("%N%NAND%N")
					l_where.append (l_prop_sql.where_clause)
					l_replacements.force (l_prop_name, l_expr_cursor.key.text)
					l_prop_id := l_prop_id + 1
				end
				l_expr_cursor.forth
			end

			create Result.make (512)
			Result.append (l_select)
			Result.append_character ('%N')
			Result.append (l_from)
			Result.append_character ('%N')
			Result.append (l_where)
			Result.append_character ('%N')

			create l_gen.make
			l_expr := variabled_expression (a_expression)
			l_gen.process_property (ast_from_expression_text (l_expr), l_replacements)
			Result.append ("%NAND%N")
			if a_negated then
				Result.append ("NOT (")
			end
			Result.append (l_gen.last_output)
			if a_negated then
				Result.append (")")
			end
			Result.append_character ('%N')

			if a_limit > 0 then
				Result.append ("LIMIT " + a_limit.out + "%N")
			end
		end

end
