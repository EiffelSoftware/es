note
	description: "Whole queryable query executor"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_WHOLE_QUERYABLE_QUERY_EXECUTOR

inherit
	EPA_TYPE_UTILITY

	SEM_CONSTANTS

	ITP_SHARED_CONSTANTS

	SEMQ_TABLE_CONSTANTS

	EPA_SHARED_EQUALITY_TESTERS

	EQA_TEST_CASE_SERIALIZATION_UTILITY

	SHARED_TYPES

create
	make

feature{NONE} -- Initialization

	make (a_connection: like connection)
			-- Initialize Current.
		do
			connection := a_connection
		end

feature -- Access

	connection: MYSQL_CLIENT
			-- Database connection config

feature -- Access

	last_results: LINKED_LIST [SEMQ_RESULT]
			-- Results retrieved from last `execute'

feature -- Basic operations

	execute (a_query: SEMQ_WHOLE_QUERYABLE_QUERY)
			-- Execute `a_query' and make results available in `last_results'.
		local
			l_qry_stmt: MYSQL_PREPARED_STATEMENT
			i: INTEGER
			l_object: SEM_OBJECTS
			l_is_object: BOOLEAN
			l_result: SEMQ_RESULT
			l_object_data: like objects_from_queryable_data
		do
			create last_results.make
			l_is_object := a_query.queryable_type ~ {SEM_CONSTANTS}.object_field_value
			if l_is_object then
				l_object_data := objects_from_queryable_data (queryable_data_from_uuid (connection, a_query.uuid))
				setup_objects_properties (l_object_data.objects, l_object_data.meta.item (queryables_qry_id).to_integer, connection)
				create l_result.make
				l_result.queryables.extend (l_object_data.objects)
				l_result.meta.force (l_object_data.meta, a_query.uuid)
				last_results.extend (l_result)
			else
				to_implement ("Implement for feature queryable retrieval. 23.2.2011")
			end
		end

	setup_objects_properties (a_objects: SEM_OBJECTS; a_qry_id: INTEGER; a_connection: MYSQL_CLIENT)
			-- Load properties for queryable with `a_qry_id' from data `a_connection' and setup
			-- those properties into `a_objects'.
		local
			l_select: STRING
			l_stmt: MYSQL_PREPARED_STATEMENT
			l_data: HASH_TABLE [STRING, STRING]
			l_state: EPA_STATE
			l_property: EPA_EQUATION
		do
			create l_state.make (100, a_objects.context.class_, a_objects.context.feature_)
			across 1 |..| 9 as l_vars loop
				l_select := select_statement_for_properties (l_vars.item)
				a_connection.prepare_statement (l_select)
				l_stmt := a_connection.last_prepared_statement
				l_stmt.set_integer (1, a_qry_id)
				l_stmt.execute
				if a_connection.last_error_number = 0 then
					from
						l_stmt.start
					until
						l_stmt.after
					loop
						l_data := hash_table_from_row (l_stmt)
						l_property := property_from_data (a_objects, l_data, l_vars.item)
						l_state.force_last (l_property)
						l_stmt.forth
					end
				end
			end
			a_objects.set_properties_unsafe (l_state)
		end

	property_from_data (a_objects: SEM_OBJECTS; a_data: HASH_TABLE [STRING, STRING]; a_variable_count: INTEGER): EPA_EQUATION
			-- Property equation for `a_objects' from `a_data'
			-- `a_data' is a hash-table, keys are column names in semantic database,
			-- values are column values.
			-- `a_variable_count' is the number of variables for the property.
		local
			l_text: STRING
			l_index: INTEGER
			l_expr: EPA_AST_EXPRESSION
			l_value: EPA_EXPRESSION_VALUE
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_value_type_kind: INTEGER
			l_void_value: EPA_VOID_VALUE
			l_ref_value: EPA_REFERENCE_VALUE
			l_int_value: EPA_INTEGER_VALUE
			l_bool_value: EPA_BOOLEAN_VALUE
			l_value_str: STRING
			l_any_type: TYPE_A
		do
			l_any_type := workbench.system.any_type
			l_class := a_objects.context.class_
			l_feature := a_objects.context.feature_
			l_text := a_data.item (properties_text)
			across 1 |..| a_variable_count as l_vars loop
				l_index := l_text.index_of ('$', 1)
				l_text := l_text.substring (1, l_index - 1) + variable_name_prefix + a_data.item (properties_var_prefix + l_vars.item.out) + l_text.substring (l_index + 1, l_text.count)
				create l_expr.make_with_text (l_class, l_feature, l_text, l_class)
			end
			l_value_type_kind := a_data.item (properties_value_type_kind).to_integer
			if l_value_type_kind = 1 then
					-- Boolean type
				create l_bool_value.make (a_data.item (properties_value) ~ once "1")
				l_value := l_bool_value
			elseif l_value_type_kind = 2 then
					-- Integer type
				create l_int_value.make (a_data.item (properties_value).to_integer)
				l_value := l_int_value
			elseif l_value_type_kind = 0 then
					-- Reference type
				l_value_str := a_data.item (properties_value)
				if l_value_str ~ once "32768" then
						-- Void reference
					create l_void_value.make
					l_value := l_void_value
				else
						-- Normal reference
					create l_ref_value.make (once "0x" + l_value_str, l_any_type)
					l_ref_value.set_object_equivalent_class_id (a_data.item (properties_equal_value).to_integer)
					l_value := l_ref_value
				end
			end
			create Result.make (l_expr, l_value)
		end

	select_statement_for_properties (a_variable_count: INTEGER): STRING
			-- SQL select statement to retrieve properties for queryable
			-- Those retrieved properties should have `a_variable_count' variables'.
		do
			create Result.make (256)
			Result.append (once "SELECT p.text, b.value_type_kind, b.value, b.equal_value")
			across 1 |..| a_variable_count as l_vars loop
				Result.append (once ", b.var")
				Result.append (l_vars.item.out)
			end
			Result.append (once " FROM Properties p, PropertyBindings" + a_variable_count.out +" b ")
			Result.append (once "WHERE b.qry_id = ? AND p.prop_id = b.prop_id") -- AND p.prop_id != (SELECT prop_id FROM Properties WHERE text = '$')")
		end

	queryable_data_from_uuid (a_connection: MYSQL_CLIENT; a_uuid: STRING): HASH_TABLE [STRING, STRING]
			-- Queryable data with `a_uuid' from database connected through `a_connection'
		local
			l_qry_stmt: MYSQL_PREPARED_STATEMENT
		do
			a_connection.prepare_statement ("SELECT qry_id, qry_kind, class, feature, library, transition_status, hit_breakpoints, timestamp, uuid, is_creation, is_query, argument_count, pre_serialization, pre_serialization_info, post_serialization, post_serialization_info, exception_recipient, exception_class, exception_breakpoint, exception_code, exception_meaning, exception_tag, exception_trace, fault_signature, feature_kind, operand_count, content, test_case_name, breakpoint_number, first_body_breakpoint, pre_bounded_functions, post_bounded_functions FROM Queryables WHERE uuid = ?")
			l_qry_stmt := a_connection.last_prepared_statement
			l_qry_stmt.set_string (1, a_uuid)
			l_qry_stmt.execute
			if a_connection.last_error_number = 0 then
				l_qry_stmt.start
				if not l_qry_stmt.after then
					Result := hash_table_from_row (l_qry_stmt)
				end
			end
			if Result = Void then
				create Result.make (20)
				Result.compare_objects
			end
		end

feature{NONE} -- Implementation

	hash_table_from_row (a_prepared_statement: MYSQL_PREPARED_STATEMENT): HASH_TABLE [STRING, STRING]
			-- Hash-table representing the data in current row of `a_prepared_statement'
			-- Keys of the result table are column names, values are data in those columns.
		local
			i, c: INTEGER
		do
			c := a_prepared_statement.column_count
			create Result.make (c)
			Result.compare_objects
			from
				i := 1
			until
				i > c
			loop
				if a_prepared_statement.is_null_at (i) then
					Result.force (Void, a_prepared_statement.column_name_at (i))
				else
					Result.force (a_prepared_statement.at (i), a_prepared_statement.column_name_at (i))
				end
				i := i + 1
			end
		end

	objects_from_queryable_data (a_data: HASH_TABLE [STRING, STRING]): TUPLE [objects: SEM_OBJECTS; meta: HASH_TABLE [STRING, STRING]]
			-- Objects from `a_data'
			-- Keys of `a_data' are table column names, and values are data at those columns.
		local
			l_context: EPA_CONTEXT
			l_variables: DS_HASH_TABLE [INTEGER, EPA_EXPRESSION]
			l_cursor: DS_HASH_TABLE_CURSOR [TYPE_A, STRING]
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_expr: EPA_AST_EXPRESSION
			l_var_name: STRING
			l_ast: ID_AS
			l_id_str: STRING
			l_meta: HASH_TABLE [STRING, STRING]
			l_objects: SEM_OBJECTS
		do
			l_context := context_from_variables (a_data.item (queryables_post_serialization_info))
			l_class := l_context.class_
			l_feature := l_context.feature_

			create l_variables.make (l_context.variables.count)
			l_variables.set_key_equality_tester (expression_equality_tester)
			across l_context.variables as l_vars loop
				l_var_name := l_vars.key.twin
				create l_ast.initialize (l_var_name)
				create l_expr.make_with_type (l_class, l_feature, l_ast, l_class, l_vars.item)
				l_id_str := l_var_name.substring (3, l_var_name.count)
				l_variables.force_last (l_id_str.to_integer, l_expr)
			end

			create l_objects.make (l_context, l_variables)
			l_objects.set_serialization_internal (array_from_comma_separated_string (a_data.item (queryables_post_serialization)))
			l_objects.set_uuid (a_data.item (queryables_uuid))

			create l_meta.make (10)
			l_meta.compare_objects
			setup_meta (queryables_class, l_meta, a_data)
			setup_meta (queryables_feature, l_meta, a_data)
			setup_meta (queryables_timestamp, l_meta, a_data)
			setup_meta (queryables_test_case_name, l_meta, a_data)
			setup_meta (queryables_qry_id, l_meta, a_data)

			Result := [l_objects, l_meta]
		end

	setup_meta (a_key: STRING; a_meta: HASH_TABLE [STRING, STRING]; a_data: HASH_TABLE [STRING, STRING])
			-- If `a_data' contains `a_key', put that key-value pair into `a_meta'.
		do
			a_data.search (a_key)
			if a_data.found and then a_data.found_item /= Void then
				a_meta.force (a_data.found_item, a_key)
			end
		end

	context_from_variables (a_variables: STRING): EPA_CONTEXT
			-- Context from `a_variables'
			-- `a_variables' is in form of:
			-- NONE;1;BOOLEAN;24;INTEGER_32;29;INTEGER_32;40;ARRAY [ANY];98;INDEXABLE_ITERATION_CURSOR [ANY];99
		local
			l_var_name: STRING_8
			l_var_type: TYPE_A
			l_variables: HASH_TABLE [TYPE_A, STRING]
			l_var_parts: LIST [STRING]
		do
			l_var_parts := a_variables.split (';')
			create l_variables.make (l_var_parts.count // 2)
			from
				l_var_parts.start
			until
				l_var_parts.after
			loop
				l_var_type := type_a_from_string_in_application_context (l_var_parts.item_for_iteration)
				l_var_parts.forth
				l_var_name := Variable_name_prefix + l_var_parts.item_for_iteration
				l_variables.force (l_var_type, l_var_name)
				l_var_parts.forth
			end
			create Result.make (l_variables)
		end

end
