note
	description: "Queryable query AST visitor (for individual terms)"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_QUERYABLE_QUERY_AST_VISITOR

inherit
	AST_ITERATOR
		redefine
			process_void_as,
			process_bool_as,
			process_integer_as,
			process_string_as,
			process_unary_as,
			process_binary_as,
			process_expr_call_as
		end
	SEM_CONSTANTS
	SEM_FIELD_NAMES

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize data structures and state
		do
			create variable_mapping_table.make (10)
			create feature_call_table.make (10)
			create sql_where_clauses.make
			create sql_from_clauses.make
			create sql_join_statements.make
			create sql_select_clauses.make
			number_of_joins := 1
		end

feature -- Data structures

	sql_select_clauses: LINKED_LIST [STRING]
		-- Clauses appearing in the SELECT statement

	sql_from_clauses: LINKED_LIST [STRING]
		-- Table names in FROM statement

	sql_join_statements: LINKED_LIST [STRING]
		-- Join statements for the current SQL query

	sql_where_clauses: LINKED_LIST [STRING]
		-- Clauses appearing in the WHERE statement

	sql_where_temp_clause: STRING
		-- The WHERE clause that is currently built

	sql_select_temp_clause: STRING
		-- The SELECT clause that is currently built

	variable_mapping_table: HASH_TABLE [TUPLE [join_number, parameter_position: INTEGER], STRING]
		-- Keeps track of variables and at which parameter position they appeared first

	feature_call_table: HASH_TABLE [INTEGER, STRING]
		-- Keeps track of feature calls appeared, to avoid duplicate joins

feature -- State

	number_of_joins: INTEGER
		-- Keep track of number of joins

	number_of_variables: INTEGER
		-- Keep track of number of variables in current term

	current_term_property_kind: INTEGER
		-- The property kind for the current term

	last_appeared_variable: STRING
		-- Name of variable that was visited last

	is_comparing_objects: BOOLEAN
		-- Emit "equal_value" instead of "value" for the current operands?

	is_operator_expression: BOOLEAN
		-- Current expression contains an operator?

	is_next_routine_prefixed_with_old: BOOLEAN
		-- Was there just a 'old' unary operator?

feature -- Prepare and Finish Term

	prepare_term (a_prop_kind: INTEGER)
				-- Reset datastructres and state for next term
		do
			is_operator_expression := False
			number_of_variables := 0
			current_term_property_kind := a_prop_kind
			create sql_where_temp_clause.make_empty
			sql_where_temp_clause.append_character ('(')
			sql_where_temp_clause.append_character ('(')
			sql_select_temp_clause := Void
		end

	add_equality
				-- If TERM.value is given, add equation in SQL expression
				-- duplicate TERM.expression for SELECT clause
		do
			create sql_select_temp_clause.make_from_string (sql_where_temp_clause)
			sql_select_temp_clause.append_character (')')
			sql_select_temp_clause.append_character (')')
			sql_where_temp_clause.append_string (once ") = (")
		end

	finish_term
		do
				-- Finish current term, if TERM.value
				-- is given, add to WHERE
			sql_where_temp_clause.append_character (')')
			sql_where_temp_clause.append_character (')')
			if sql_select_temp_clause = Void then
				sql_select_temp_clause := sql_where_temp_clause
			else
				sql_where_clauses.extend (sql_where_temp_clause)
			end
		end

feature -- Variable Term Helpers

	add_position_clause (a_position: INTEGER)
				-- Add clause for position for a variable
		local
			l_clause: STRING
		do
			create l_clause.make_from_string (last_appeared_variable)
			l_clause.append (once ".`position` = ")
			l_clause.append_integer (a_position)
			sql_where_clauses.extend (l_clause)
		end

	add_type_clause (a_type: STRING)
				-- Add clause for type for a variablee
		local
			l_clause: STRING
		do
			create l_clause.make_from_string (last_appeared_variable)
			l_clause.append (once ".type1 IN (SELECT `type_id` FROM Conformances WHERE `conf_type_id` IN (SELECT `type_id` FROM Types WHERE `type_name` = %"")
			l_clause.append (a_type)
			l_clause.append (once "%"))")
			sql_where_clauses.extend (l_clause)
		end

feature -- Selects

	add_clauses_equation
			-- Adds required SELECT clauses for EQUATION_TERM
		local
			l_clause: STRING
		do
			sql_select_clauses.extend (once "qry.`uuid`")
			if number_of_variables /= 1 or is_operator_expression then
				sql_select_clauses.extend (sql_select_temp_clause)
				sql_select_clauses.extend (once "NULL")
				sql_select_clauses.extend (once "NULL")
				sql_select_clauses.extend (once "NULL")
			else
				create l_clause.make_from_string (last_appeared_variable)
				l_clause.append_character ('.')
				sql_select_clauses.extend (l_clause + once "`value`")
				sql_select_clauses.extend (l_clause + once "`equal_value`")
				sql_select_clauses.extend (l_clause + once "`prop_kind`")
				sql_select_clauses.extend (l_clause + once "`boost`")
			end
		end

	add_clauses_variable
			-- Adds required SELECT clauses for VARIABLE_TERM
		local
			l_clause: STRING
		do
			create l_clause.make_from_string (last_appeared_variable)
			l_clause.append_character ('.')
			sql_select_clauses.extend (once "qry.`uuid`")
			sql_select_clauses.extend (l_clause + once "`var1`")
			sql_select_clauses.extend (l_clause + once "`value`")
			sql_select_clauses.extend (l_clause + once "`equal_value`")
			sql_select_clauses.extend (l_clause + once "`type1`")
			sql_select_clauses.extend (l_clause + once "`position`")
		end

	add_clauses_meta
			-- Adds required SELECT clauses for META_TERM
		do
			sql_select_clauses.extend (sql_select_temp_clause)
		end

feature -- Roundtrip

	process_void_as (l_as: VOID_AS)
		do
			sql_where_temp_clause.append (integer_value_for_void)
		end

	process_bool_as (l_as: BOOL_AS)
		do
			if l_as.value = True then
				sql_where_temp_clause.append_character ('1')
			else
				sql_where_temp_clause.append_character ('0')
			end
		end

	process_integer_as (l_as: INTEGER_AS)
		do
			sql_where_temp_clause.append_integer (l_as.integer_32_value)
		end

	process_string_as (l_as: STRING_AS)
		do
			sql_where_temp_clause.append (l_as.string_value)
		end

	process_unary_as (l_as: UNARY_AS)
		do
			is_operator_expression := True
			if l_as.operator_name.is_equal (once "old") then
				is_next_routine_prefixed_with_old := True
				sql_where_temp_clause.append_character ('(')
				l_as.expr.process (Current)
				sql_where_temp_clause.append_character (')')
			else
				sql_where_temp_clause.append (l_as.operator_name)
				sql_where_temp_clause.append_character (' ')
				sql_where_temp_clause.append_character ('(')
				l_as.expr.process (Current)
				sql_where_temp_clause.append_character (')')
			end
		end

	process_binary_as (l_as: BINARY_AS)
		do
			-- Check for object comparison
			is_operator_expression := True
			if l_as.op_name.string_value_32.ends_with (once "~") then
				is_comparing_objects := True
			end

			-- Left side
			sql_where_temp_clause.append_character ('(')
			if l_as.op_name.string_value_32.same_string (once "implies") then
				sql_where_temp_clause.append (once " NOT (")
			end
			l_as.left.process (Current)
			if l_as.op_name.string_value_32.same_string (once "implies") then
				sql_where_temp_clause.append_character (')')
			end
			sql_where_temp_clause.append_character (')')
			sql_where_temp_clause.append_character (' ')

			-- Operator
			if l_as.op_name.string_value_32.same_string (once "/=") then
				sql_where_temp_clause.append (once "<>")
			elseif l_as.op_name.string_value_32.same_string (once "/~") then
				sql_where_temp_clause.append (once "<>")
			elseif l_as.op_name.string_value_32.same_string (once "^") then
				sql_where_temp_clause.append (once "XOR")
			elseif l_as.op_name.string_value_32.same_string (once "//") then
				sql_where_temp_clause.append (once "/")
			elseif l_as.op_name.string_value_32.same_string (once "\\") then
				sql_where_temp_clause.append (once "MOD")
			elseif l_as.op_name.string_value_32.same_string (once "and then") then
				sql_where_temp_clause.append (once "AND")
			elseif l_as.op_name.string_value_32.same_string (once "or else") then
				sql_where_temp_clause.append (once "OR")
			elseif l_as.op_name.string_value_32.same_string (once "implies") then
				sql_where_temp_clause.append (once "OR")
			else
				sql_where_temp_clause.append (l_as.op_name.string_value_32)
			end

			-- Right side
			sql_where_temp_clause.append_character (' ')
			sql_where_temp_clause.append_character ('(')
			l_as.right.process (Current)
			sql_where_temp_clause.append_character (')')

			-- Finish
			is_comparing_objects := False
		end

	process_expr_call_as (l_as: EXPR_CALL_AS)
		local
			l_join: STRING
			l_from: STRING
			l_where: STRING
			l_clause: STRING
			l_call: STRING
			l_call_anonymous: STRING
			l_call_with_prop_id: STRING
			l_parameter_position: INTEGER
			l_routine_visitor: SEMQ_QUERYABLE_QUERY_ROUTINE_VISITOR
			l_target_and_arguments: LINKED_LIST [STRING]
			l_property_kind: INTEGER
		do
			l_property_kind := current_term_property_kind

			-- Routine call
			create l_routine_visitor.make
			l_as.process (l_routine_visitor)
			l_call := l_routine_visitor.call_as_string
			l_call_anonymous := l_routine_visitor.call_as_string_anonymous

			-- Prefix 'old'?
			if is_next_routine_prefixed_with_old then
--				l_call.prepend (once "old ")
--				l_call_anonymous.prepend (once "old ")
				l_property_kind := property_types.at (once "pre")
				is_next_routine_prefixed_with_old := False
			end

			-- Routine call as a string with prop_id suffix
			create l_call_with_prop_id.make_from_string (l_call)
			l_call_with_prop_id.append_character ('#')
			l_call_with_prop_id.append_integer (l_property_kind)

			-- Is routine call on "qry"?
			if l_routine_visitor.target.same_string (once "qry") then
				sql_where_temp_clause.append (l_call)

			-- Regular routine call
			else
				sql_where_temp_clause.append (once "Prop")

				-- Check if this routine call has already appared, save a join
				if feature_call_table.has (l_call_with_prop_id) then
					sql_where_temp_clause.append_integer (feature_call_table.at (l_call_with_prop_id))
				-- New routine call, add join
				else
					sql_where_temp_clause.append_integer (number_of_joins)
				end

				-- Comparing objects
				if is_comparing_objects then
					sql_where_temp_clause.append (once ".`equal_value`")
				-- Comparing booleans/integers/strings
				else
					sql_where_temp_clause.append (once ".`value`")
				end

				-- Join
				if not feature_call_table.has (l_call) then
					last_appeared_variable := once "Prop" + number_of_joins.out

					create l_from.make_empty
					l_from.append (once "PropertyBindings")
					l_from.append_integer (l_routine_visitor.argument_count)
					l_from.append (once " AS Prop")
					l_from.append_integer (number_of_joins)
					sql_from_clauses.extend (l_from)

					create l_where.make_empty
					l_where.append (once "(qry.`qry_id` = Prop")
					l_where.append_integer (number_of_joins)
					l_where.append (once ".`qry_id` AND Prop")
					l_where.append_integer (number_of_joins)
					l_where.append (once ".`prop_id` = (SELECT `prop_id` FROM Properties WHERE `text` = %"")
					l_where.append (l_call_anonymous)
					l_where.append (once "%") AND Prop")
					l_where.append_integer (number_of_joins)
					l_where.append (once ".`prop_kind` = ")
					l_where.append_integer (l_property_kind)
					l_where.append (once ")")
					sql_where_clauses.extend (l_where)

					create l_join.make_empty
					l_join.append (once "LEFT JOIN PropertyBindings")
					l_join.append_integer (l_routine_visitor.argument_count)
					l_join.append (once " AS Prop")
					l_join.append_integer (number_of_joins)
					l_join.append (once " ON (qry.`qry_id` = Prop")
					l_join.append_integer (number_of_joins)
					l_join.append (once ".`qry_id` AND Prop")
					l_join.append_integer (number_of_joins)
					l_join.append (once ".`prop_id` = (SELECT `prop_id` FROM Properties WHERE `text` = %"")
					l_join.append (l_call_anonymous)
					l_join.append (once "%") AND Prop")
					l_join.append_integer (number_of_joins)
					l_join.append (once ".`prop_kind` = ")
					l_join.append_integer (l_property_kind)
					l_join.append (once ")")
					sql_join_statements.extend (l_join)
					feature_call_table.put (number_of_joins, l_call_with_prop_id)
					number_of_joins := number_of_joins + 1
				end

				-- Target and Arguments
				l_target_and_arguments := l_routine_visitor.target_and_arguments
				from
					l_parameter_position := 1
					l_target_and_arguments.start
				until
					l_target_and_arguments.after
				loop
					-- Already seen variable
					if variable_mapping_table.has (l_target_and_arguments.item) then
						create l_clause.make_empty
						l_clause.append (once "(Prop")
						l_clause.append_integer (number_of_joins - 1)
						l_clause.append (once ".`var")
						l_clause.append_integer (l_parameter_position)
						l_clause.append (once "` = Prop")
						l_clause.append_integer (variable_mapping_table.at (l_target_and_arguments.item).join_number)
						l_clause.append (once ".`var")
						l_clause.append_integer (variable_mapping_table.at (l_target_and_arguments.item).parameter_position)
						l_clause.append (once "`)")
						sql_where_clauses.extend (l_clause)
					-- New variable
					else
						variable_mapping_table.put ([number_of_joins - 1, l_parameter_position], l_target_and_arguments.item)
					end
					l_parameter_position := l_parameter_position + 1
					number_of_variables := number_of_variables + 1
					l_target_and_arguments.forth
				end
			end
		end

end
