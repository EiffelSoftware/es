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

	EPA_STRING_UTILITY

feature -- Access

	variabled_expression (a_expression: STRING): STRING
			-- Expression where curly-barced integer varaibles
			-- are replaced with actual variables such as "v_0".
		do
			create Result.make_from_string (a_expression)
			across curly_braced_variables_from_expression (a_expression) as l_vars loop
				Result.replace_substring_all (l_vars.key, "v_" + l_vars.item.out)
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
				l_index1 := a_expression.substring_index ({ITP_SHARED_CONSTANTS}.variable_name_prefix, 1)
			until
				l_index1 = 0
			loop
				l_index2 := l_index1 + 2
				l_operand := a_expression.substring (l_index1, l_index2)
				Result.force (l_operand, l_var_id)
				l_var_id := l_var_id + 1
				l_index1 := a_expression.substring_index ({ITP_SHARED_CONSTANTS}.variable_name_prefix, l_index2 + 1)
			end
		end

	sql_clauses_for_variable (a_name: STRING; a_predicates: HASH_TABLE [STRING, STRING]; a_type: detachable STRING; a_position: INTEGER; a_queryable_partition_id: INTEGER): TUPLE [table: STRING; where_clause: STRING]
			-- SQL clauses for selecting a variable named `a_name' with
			-- properties `a_predicates', keys are predicate names, values are predicate values.
			-- `a_queryable_partition_id' is the queryable partition id.
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
				if l_preds.item ~ ti_void then
					l_where_clause.append ({SEM_CONSTANTS}.integer_value_for_void)
				else
					l_where_clause.append (l_preds.item)
				end
				if a_position >= 0 then
					l_where_clause.append ("%NAND " + a_name + ".position = " + a_position.out)
				end
			end

			if a_type /= Void then
				if a_position = 0 then
					l_where_clause.append (once " AND%N")
					l_where_clause.append (a_name)
					l_where_clause.append (once ".type1 = (SELECT type_id FROM Types WHERE type_name =%"" + a_type + "%")")
				else
					if output_type_name (a_type) /~ "ANY" then
						l_where_clause.append (once " AND%N")
						l_where_clause.append (a_name)
						l_where_clause.append (".type1 IN (SELECT c.conf_type_id FROM Conformances c, Types tp WHERE tp.type_id = c.type_id AND tp.type_name = '" + output_type_name (a_type) + "')")
					end
				end

				if a_type ~ "INTEGER_32" then
					l_where_clause.append (once " AND " + a_name + ".position != -1%N")
				end
			end

			l_where_clause.append_character ('%N')

				-- Setup queryable partition id.
			l_where_clause.append ("%NAND " + a_name + ".qry_id=q_" + a_queryable_partition_id.out + ".qry_id%N")

			Result := [l_table, l_where_clause]
		end

	sql_clauses_for_property (a_property_name: STRING; a_text: STRING; a_predicates: HASH_TABLE [STRING, STRING]; a_queryable_partition_id: INTEGER): TUPLE [table: STRING; where_clause: STRING]
			-- SQL clauses for selecting a property named `a_text'.
			-- `a_property_name' is the name to be mentioned in the SQL statements (Table name alias).
			-- `a_text' is the property expression, for example v_1.has (v_2).
			-- `a_queryable_partition_id' is the queryable partition id associated with this property.
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
			l_canonical := canonical_form_of_expression (a_text)
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
				if l_preds.item ~ ti_void then
					l_where_clause.append ({SEM_CONSTANTS}.integer_value_for_void)
				else
					l_where_clause.append (l_preds.item)
				end
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

				-- Setup queryable partition id.
			l_where_clause.append ("%NAND " + a_property_name + ".qry_id=q_" + a_queryable_partition_id.out + ".qry_id%N")

			Result := [l_table, l_where_clause]
		end


	property_bindings_table_name (a_variable_count: INTEGER): STRING
			-- Table name for PropertyBindings`a_variable_count'
		do
			Result := "PropertyBindings" + a_variable_count.out
		end

	sql_to_select_object (a_context_class: detachable CLASS_C; a_feature: detachable FEATURE_I; a_type: TYPE_A; a_count: INTEGER): STRING
			-- SQL statement to select at most `a_count' objects whose type conforms to `a_type'
			-- If `a_context_class' or `a_feature' is not Void, the selection is done only in queryables
			-- related to that class or feature.
		do
			create Result.make (256)
			Result.append ("SELECT DISTINCT q.uuid, v.var1 FROM Queryables q, PropertyBindings1 v WHERE q.qry_kind = 1 %N")
			if a_context_class /= Void then
				Result.append ("AND q.class_name = '" + a_context_class.name_in_upper + "'%N")
			end
			if a_feature /= Void then
				Result.append ("AND q.feature_name = '" + a_feature.feature_name.as_lower + "'%N")
			end
			Result.append ("AND v.qry_id = q.qry_id AND v.prop_id = (SELECT prop_id FROM Properties WHERE text = '$') %N")
			if a_type.name /~ "ANY" then
				Result.append ("AND v.type1 IN (SELECT c.conf_type_id FROM Conformances c, Types tp WHERE tp.type_id = c.type_id AND tp.type_name = '" + output_type_name (a_type.name) + "') %N")
			end
			Result.append ("%NLIMIT " + a_count.out)
		end

	rewritten_precondition (a_expression: EPA_EXPRESSION): EPA_EXPRESSION
			-- Precondition assertion rewritten from `a_expression'		
		local
			l_expr: EPA_AST_EXPRESSION
		do
			fixme ("Here are some hard-coeded rewritten preconditions because we don't have time to do this automatically. Without the hard-coding, we will generated ill-formed SQL select statements. This hard-coding won't affect the effectiveness of the precondition-reduction strategy. 28.03.2011 Jasonw")
			if a_expression.class_.name_in_upper ~ "DS_ARRAYED_LIST" and then a_expression.text ~ "extendible (other.count)" then
				create l_expr.make_with_text (a_expression.class_, a_expression.feature_, "capacity >= count + other.count", a_expression.written_class)
				Result := l_expr
			elseif a_expression.class_.name_in_upper ~ "DS_HASH_SET" and then a_expression.text ~ "extendible (other.count)" then
				create l_expr.make_with_text (a_expression.class_, a_expression.feature_, "capacity >= count + other.count", a_expression.written_class)
				Result := l_expr
			elseif a_expression.class_.name_in_upper ~ "DS_LINKED_QUEUE" and then a_expression.text ~ "extendible (other.count)" then
				Result := Void
			elseif a_expression.class_.name_in_upper ~ "DS_LINKED_LIST" and then a_expression.text ~ "extendible (other.count)" then
				Result := Void
			elseif a_expression.class_.name_in_upper ~ "DS_LINKED_STACK" and then a_expression.text ~ "extendible (other.count)" then
				Result := Void
			else
				Result := a_expression
			end
		end

	sql_to_select_objects (a_context_class: CLASS_C; a_feature: FEATURE_I; a_expression: STRING; a_negated: BOOLEAN; a_limit: INTEGER; a_feature_included: BOOLEAN; a_prop_kind: INTEGER; a_query_kind: INTEGER; a_ignore_qry_ids: detachable DS_HASH_SET [INTEGER]; a_all_in_one_queryable: BOOLEAN; a_consider_precondition: BOOLEAN): TUPLE [sql: STRING; unconstained_operands: HASH_TABLE [TYPE_A, STRING]]
			-- SQL statement to select objects satisfying `a_expression'.
			-- `a_negated' indicates if the semantics of `a_expression' should be negated.
			-- `a_expression' must have boolean type.
			-- `a_expression' is in curly-braced integer form, for example: {0}.has ({1})
			-- `a_limit' indicates the maximal number of row to retrieve from database. 0 means unlimited rows.
			-- In result, `sql' is the select statement to retrieve queryables, `unconstrained_operands' is a
			-- hash table, keys are names of operands (u, v, etc.) that are not mentioned in `a_expression', values are their types.
			-- `a_ignore_qry_ids' (if attached) includes the qry_ids that should be avoided.
			-- `a_consider_precondition' indicates if precoditions of `a_feature' should be considered as satisfied.
		local
			l_operands: like curly_braced_variables_from_expression
			l_subexprs: like single_rooted_expressions
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
			l_contract_extractor: EPA_CONTRACT_EXTRACTOR
			l_pres: LINKED_LIST [EPA_EXPRESSION]
			l_expression: EPA_AST_EXPRESSION
			l_text: STRING
			l_final_expr: STRING
			l_pre_set: DS_HASH_SET [EPA_EXPRESSION]
			l_rep: HASH_TABLE [STRING, STRING]
			l_rep1: HASH_TABLE [STRING, STRING]
			l_qualifier: EPA_EXPRESSION_QUALIFIER
			l_feat_opds: like operands_with_feature
			l_sql: STRING
			l_unconstrained_operands: HASH_TABLE [TYPE_A, STRING]
			l_opd_type: TYPE_A
			l_opd_index: INTEGER
			l_opd_name: STRING
			l_opd_types: like resolved_operand_types_with_feature
			l_pre_text: STRING
			l_qry_id_cursor: DS_HASH_SET_CURSOR [INTEGER]
			l_qry_partitions: like queryable_partitions
			i: INTEGER
			l_queryable_clauses: like clauses_for_queryables
			l_type_of_replacements: HASH_TABLE [TYPE_A, STRING]
			l_type: TYPE_A
			l_constant_collector: EPA_CONSTANT_QUERY_COLLECTOR
			l_constant_queries: HASH_TABLE [STRING, STRING]
		do
			create l_contract_extractor
			l_pres := l_contract_extractor.precondition_of_feature (a_feature, a_context_class).twin
			create l_pre_set.make (l_pres.count)
			l_pre_set.set_equality_tester (expression_equality_tester)
			create l_constant_collector
			l_constant_queries := l_constant_collector.quries (a_context_class)
			from
				l_pres.start
			until
				l_pres.after
			loop
				l_pres.replace (rewritten_precondition (l_pres.item))
				if
					l_pres.item /= Void and then
					not l_pres.item.text.has ('{') and then
--					not l_pres.item.text.has ('.') and then
--					not l_pres.item.text.has ('(') and then
					not l_pres.item.text.has_substring (once "attached") and then
					not l_pres.item.text.has_substring ("same_type (") and then
					l_pres.item.type /= Void and then
					not l_constant_queries.has (l_pres.item.text)
				then
					l_pre_set.force_last (l_pres.item)
				end
				l_pres.forth
			end

			if a_consider_precondition and then (l_pre_set.count > 0 and l_pre_set.count <= 6) then
					-- We don't allow too many precondition predicates,
					-- because otherwise, the query will take a long long time.
				create l_qualifier
				create l_rep1.make (1)
				l_rep1.compare_objects
				l_rep1.force (ti_current + ".", "")

				create l_text.make (128)
				if a_negated then
					l_text.append ("not ")
				end
				l_text.append_character ('(')
				l_text.append (a_expression)
				l_text.append (once ") ")

				create l_pre_text.make (128)
				from
					l_pre_set.start
				until
					l_pre_set.after
				loop
					if not l_pre_set.item_for_iteration.text.has_substring (once " (1)") then
						if not l_pre_text.is_empty then
							l_pre_text.append (" and ")
						end
						l_pre_text.append_character ('(')
						l_rep := curly_braced_operands_from_operands (a_feature, a_context_class)
						l_qualifier.qualify (l_pre_set.item_for_iteration, l_rep1)
						l_pre_text.append (expression_rewriter.ast_text (ast_from_expression_text (l_qualifier.last_expression), l_rep))
						l_pre_text.append_character (')')
					end
					l_pre_set.forth
				end

				if not l_pre_text.is_empty then
					l_text.append (" and (")
					l_text.append (l_pre_text)
					l_text.append (")")
				end
				l_final_expr := l_text
			else
				if a_negated then
					l_final_expr := "NOT (" + a_expression + ")"
				else
					l_final_expr := a_expression
				end

			end

			create l_replacements.make (5)
			l_replacements.compare_objects
			create l_type_of_replacements.make (5)
			l_type_of_replacements.compare_objects

			l_context_type := root_class_of_system.actual_type
			create l_select.make (128)
			create l_from.make (128)
			create l_where.make (512)

			l_operands := curly_braced_variables_from_expression (l_final_expr)
			l_operands.force (0, curly_brace_surrounded_integer (0)) -- Make sure that target is always included.
			l_subexprs := single_rooted_expressions (l_final_expr, a_context_class, a_feature)
			l_feat_opds := operands_with_feature (a_feature).cloned_object

				-- Get the set of queryable partition ids.
			l_qry_partitions := queryable_partitions (a_feature, a_context_class, l_operands, l_subexprs, a_all_in_one_queryable)

				-- Remove "Result", if any.
			if a_feature.has_return_value then
				l_feat_opds.remove (a_feature.argument_count + 1)
			end
				-- Remove all mentioned operands.
			across l_operands as l_mentioned_opds loop
				l_opd_index := l_mentioned_opds.item
				if l_feat_opds.has (l_opd_index) then
					l_feat_opds.remove (l_opd_index)
				end
			end

				-- Process operands that are not mentioned in the expression.
			create l_unconstrained_operands.make (l_feat_opds.count)
			l_unconstrained_operands.compare_objects
			from
				l_feat_opds.start
			until
				l_feat_opds.after
			loop
				l_opd_type := a_feature.arguments.i_th (l_feat_opds.key_for_iteration).actual_type
				l_opd_type := actual_type_from_formal_type (l_opd_type, a_context_class)
				l_opd_type := l_opd_type.instantiation_in (a_context_class.actual_type, a_context_class.class_id)
				l_unconstrained_operands.force (l_opd_type, l_feat_opds.item_for_iteration)
				l_feat_opds.forth
			end

			create l_var_preds.make (2)
			l_var_preds.compare_objects
			l_var_preds.force (a_prop_kind.out, "prop_kind")
--			l_var_preds.force ("q.qry_id", "qry_id")

			l_queryable_clauses := clauses_for_queryables (l_qry_partitions, a_context_class, Void, a_query_kind)
			l_from.append ("FROM ")
			l_select.append ("SELECT ")
			l_where.append ("WHERE%N")
			l_from.append (l_queryable_clauses.from_clause)
			l_where.append (l_queryable_clauses.where_clause)

			if a_ignore_qry_ids /= Void and then not a_ignore_qry_ids.is_empty then
				l_where.append ("AND q_0.qry_id NOT IN (")
				from
					l_qry_id_cursor := a_ignore_qry_ids.new_cursor
					l_qry_id_cursor.start
				until
					l_qry_id_cursor.after
				loop
					l_where.append (l_qry_id_cursor.item.out)
					if not l_qry_id_cursor.is_last then
						l_where.append_character (',')
					end
					l_qry_id_cursor.forth
				end
				l_where.append (") %N")
			end


--			l_where.append ("q.qry_kind=" + a_query_kind.out + " AND%N")
--			l_where.append ("q.class=%"" + a_context_class.name_in_upper + "%"")
--			if a_feature_included then
--				l_where.append ("%NAND q.feature=%"" + a_feature.feature_name.as_lower + "%"")
--			end
			l_where.append_character ('%N')

				-- Setup variables.
			l_opd_types := resolved_operand_types_with_feature (a_feature, a_context_class, a_context_class.constraint_actual_type)
			i := 0
			across l_operands as l_opds loop
				l_var_name := "v_" + l_opds.item.out
				if i > 0 then
					l_select.append (", ")
				end
				l_select.append (l_var_name)
				l_select.append (".var1 as ")
				l_select.append_character ('%"')
				l_select.append (l_opds.key)
				l_select.append_character ('%"')

				l_select.append_character (',')
				l_select.append ("q_" + l_qry_partitions.variables.item (l_opds.item).out)
				l_select.append (".uuid as %"")
				l_select.append (l_opds.key)
				l_select.append (".uuid")
				l_select.append ("%"")
				l_select.append_character (',')
				l_select.append ("q_" + l_qry_partitions.variables.item (l_opds.item).out)
				l_select.append (".qry_id as %"")
				l_select.append (l_opds.key)
				l_select.append (".qry_id")
				l_select.append ("%"")

				i := i + 1
				if l_opds.item = 0 then
					l_type := a_context_class.constraint_actual_type
				else
					l_type := l_opd_types.item (l_opds.item)
				end
				l_var_type := output_type_name (l_type.name)
				if a_feature_included then
					l_var_sql := sql_clauses_for_variable (l_var_name, l_var_preds, l_var_type, l_opds.item, l_qry_partitions.variables.item (l_opds.item))
				else
					l_var_sql := sql_clauses_for_variable (l_var_name, l_var_preds, l_var_type, -1, l_qry_partitions.variables.item (l_opds.item))
				end

				l_from.append (", ")
				l_from.append (l_var_sql.table)
				l_where.append ("%NAND%N")
				l_where.append (l_var_sql.where_clause)
				l_replacements.force (l_var_name, l_var_name)
				l_type_of_replacements.force (l_type, l_var_name)
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
					l_prop_sql := sql_clauses_for_property (l_prop_name, l_expr_cursor.key.text, l_var_preds, l_qry_partitions.properties.item (l_expr_cursor.key))
					l_from.append (", ")
					l_from.append (l_prop_sql.table)
					l_where.append ("%N%NAND%N")
					l_where.append (l_prop_sql.where_clause)
					l_replacements.force (l_prop_name, l_expr_cursor.key.text)
					l_type_of_replacements.force (l_expr_cursor.key.type, l_expr_cursor.key.text)
					l_prop_id := l_prop_id + 1
				end
				l_expr_cursor.forth
			end

			create l_sql.make (512)
			l_sql.append (l_select)
			l_sql.append_character ('%N')
			l_sql.append (l_from)
			l_sql.append_character ('%N')
			l_sql.append (l_where)
			l_sql.append_character ('%N')

			create l_gen.make
			l_expr := variabled_expression (l_final_expr)
			l_gen.process_property (ast_from_expression_text (l_expr), l_replacements, l_type_of_replacements, l_qry_partitions, a_context_class, a_feature)
			l_sql.append ("%NAND%N")
			l_sql.append (l_gen.last_output)
			l_sql.append_character ('%N')

--			if a_ignore_qry_ids /= Void and then not a_ignore_qry_ids.is_empty then
--				l_sql.append ("GROUP BY q.qry_id%N")
--			end
			if a_limit > 0 then
				l_sql.append ("LIMIT " + a_limit.out + "%N")
			end
			Result := [l_sql, l_unconstrained_operands]
		end

	queryable_partitions (a_feature: FEATURE_I; a_class: CLASS_C; a_operands: HASH_TABLE [INTEGER_32, STRING_8]; a_subexprs: like single_rooted_expressions; a_all_in_one: BOOLEAN): TUPLE [variables: HASH_TABLE [INTEGER, INTEGER]; properties: DS_HASH_TABLE [INTEGER, EPA_EXPRESSION]]
			-- Queryable partitions from `a_operands' and `a_subexprs'
			-- `a_operands' are a hash-table from curly-integer operand indexes to operand indexes, for example {0} -> 0; {1} -> 1.
			-- `a_subexprs' are single-rooted expression mentioning `a_operands'.
			-- If `a_all_in_one' is True, all variables and properties are constrained to come from the same queryable.
			-- Result:
			-- `variables' is a hash-table, keys are 0-based operand indexes, values are 0-based queryable partition id.
			-- A queryable partition with id 0 means the queryable for the target operand.
			-- `properties' is a hash-table, keys are property expressions, and values are the queryable partition ids
			-- where those properties should come from.
		local
			l_var_parts: HASH_TABLE [INTEGER, INTEGER]
			l_prop_parts: DS_HASH_TABLE [INTEGER, EPA_EXPRESSION]
			l_cursor: DS_HASH_TABLE_CURSOR [TUPLE [variable_indexes: DS_HASH_SET [INTEGER_32]; canonical_form: STRING_8], EPA_EXPRESSION]
			l_mentioned_opds: DS_HASH_SET [INTEGER_32]
			l_qry_partition_id: INTEGER
			l_vcur: DS_HASH_SET_CURSOR [INTEGER]
			l_type_cursor: DS_HASH_TABLE_CURSOR [TYPE_A, INTEGER]
		do
			create l_var_parts.make (a_operands.count)
			create l_prop_parts.make (a_subexprs.count)
			l_prop_parts.set_key_equality_tester (expression_equality_tester)

			if a_all_in_one then
					-- If everything should come from the same queryable, we require
					-- they come from the same queryable as the target operand, which is partition 0.
				across a_operands as l_opds loop
					l_var_parts.force (0, l_opds.item)
				end
				from
					l_cursor := a_subexprs.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					l_prop_parts.force_last (0, l_cursor.key)
					l_cursor.forth
				end
				Result := [l_var_parts, l_prop_parts]
			else
					-- First, we assume that every operand is in a different partition.
				across a_operands as l_opds loop
					l_var_parts.force (l_opds.item, l_opds.item)
				end

					-- Then, we merge partitions of different operands into one partition
					-- if those operands are mentioned in the same expression.
				l_type_cursor := resolved_operand_types_with_feature (a_feature, a_class, a_class.constraint_actual_type).new_cursor
				from
					l_cursor := a_subexprs.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
						-- An operand of type integer or boolean can be in any queryable.
						-- So those operands are always in their own queryable partition.
					l_mentioned_opds := l_cursor.item.variable_indexes.cloned_object
					from
						l_type_cursor.start
					until
						l_type_cursor.after
					loop
						if l_type_cursor.item.is_integer or else l_type_cursor.item.is_boolean then
							l_mentioned_opds.remove (l_type_cursor.key)
						end
						l_type_cursor.forth
					end

					l_qry_partition_id := minimal_partition_id (l_var_parts, l_mentioned_opds)
					l_prop_parts.force_last (l_qry_partition_id, l_cursor.key)
					from
						l_vcur := l_mentioned_opds.new_cursor
						l_vcur.start
					until
						l_vcur.after
					loop
						l_var_parts.force (l_qry_partition_id, l_vcur.item)
						l_vcur.forth
					end
					l_cursor.forth
				end
				Result := [l_var_parts, l_prop_parts]
			end
		end

	minimal_partition_id (a_operand_partitions: HASH_TABLE [INTEGER, INTEGER]; a_operands_in_same_partition: DS_HASH_SET [INTEGER]): INTEGER
			-- The minimal partition id from `a_operand_partition's.
			-- `a_operands_in_same_partition' is a set of operand 0-based indexes.
			-- `a_operand_partitions' are a hash-table, keys are 0-based operand indexes,
			-- values are queryable partition ids.
		local
			l_cursor: DS_HASH_SET_CURSOR [INTEGER]
			l_result_set: BOOLEAN
		do
			from
				l_cursor := a_operands_in_same_partition.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				if l_result_set then
					if a_operand_partitions.item (l_cursor.item) < Result then
						Result := a_operand_partitions.item (l_cursor.item)
					end
				else
					l_result_set := True
					Result := a_operand_partitions.item (l_cursor.item)
				end
				l_cursor.forth
			end
		end

	clauses_for_queryables (a_partitions: like queryable_partitions; a_class: CLASS_C; a_feature: detachable FEATURE_I; a_query_kind: INTEGER): TUPLE [from_clause: STRING; where_clause: STRING]
			-- Text for queryable selection SQL clauses
		local
			l_processed: DS_HASH_SET [INTEGER]
			l_from: STRING
			l_where: STRING
		do
			create l_from.make (256)
			create l_where.make (256)
			create l_processed.make (5)
			across a_partitions.variables as l_var_partitions loop
				if not l_processed.has (l_var_partitions.item) then
					l_processed.force_last (l_var_partitions.item)
					if not l_from.is_empty then
						l_from.append_character (',')
						l_from.append_character (' ')
					end
					l_from.append ("Queryables q_" + l_var_partitions.item.out)
					if not l_where.is_empty then
						l_where.append (" AND ")
					end
					if l_var_partitions.item = 0 then
						l_where.append ("%Nq_" + l_var_partitions.item.out + ".class_name='")
						l_where.append (a_class.name_in_upper)
						l_where.append_character ('%'')
						l_where.append (" AND q_" + l_var_partitions.item.out + ".qry_kind=" + a_query_kind.out + "%N")
					else
						l_where.append ("%Nq_" + l_var_partitions.item.out + ".qry_kind=" + a_query_kind.out + "%N")
					end
				end
			end
			l_from.append_character ('%N')
			l_where.append_character ('%N')
			Result := [l_from, l_where]
		end

end
