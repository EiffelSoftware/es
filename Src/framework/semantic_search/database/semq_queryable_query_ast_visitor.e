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
			process_binary_as,
			process_expr_call_as,
			process_access_feat_as
		end
	SEM_CONSTANTS

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize data structures and state
		do
			create variable_mapping_table.make (10)
			create sql_where_clauses.make
			create sql_join_statements.make
			create sql_select_clauses.make
			number_of_joins := 1
		end

feature -- Data structures

	sql_select_clauses: LINKED_LIST [STRING]
		-- Clauses appearing in the SELECT statement

	sql_join_statements: LINKED_LIST [STRING]
		-- Join statements for the current SQL query

	sql_where_clauses: LINKED_LIST [STRING]
		-- Clauses appearing in the WHERE statement

	sql_where_temp_clause: STRING
		-- The clause that is currently built

	variable_mapping_table: HASH_TABLE [TUPLE [join_number, parameter_position: INTEGER], STRING]
		-- Keeps track of variables and at which parameter position they appeared first

	number_of_joins: INTEGER
		-- Keep track of number of joins

	number_of_variables: INTEGER
		-- Keep track of number of variables in current term


feature -- Parameters

	current_term_property_kind: INTEGER
		-- The property kind for the current term

feature -- State

	last_appeared_variable: STRING
		-- Name of variable that was visited last

	feature_call_replaced: STRING
		-- Feature call with all parameters replaced by '$'

	parameter_count: INTEGER
		-- Mumber of parameters of last visited feature call

	parameter_position: INTEGER
		-- Position of last visited parameter

	is_gathering_feature_info: BOOLEAN
		-- Currently parsing a feature call?

	is_collecting_parameters: BOOLEAN
		-- Currently visiting all parameters?

	is_comparing_objects: BOOLEAN
		-- Emit "equal_value" instead of "value" for the current operands?

	is_qry_feature: BOOLEAN
		-- Current feature call on target 'qry'?

	is_expression_in_select: BOOLEAN
		-- Put current clause into SELECT instead of WHERE?

feature -- Prepare and Finish Equation Term

	set_expression_in_select (a_value: BOOLEAN)
		do
			is_expression_in_select := a_value
		end

	prepare_equation_term (a_prop_kind: INTEGER)
		do
			number_of_variables := 0
			current_term_property_kind := a_prop_kind
			create sql_where_temp_clause.make_empty
			sql_where_temp_clause.append_character ('(')
			sql_where_temp_clause.append_character ('(')
		end

	add_equality
		do
			sql_where_temp_clause.append_string (once ") = (")
		end

	finish_equation_term
		do
			sql_where_temp_clause.append_character (')')
			sql_where_temp_clause.append_character (')')
			if not is_expression_in_select then
				sql_where_clauses.extend (sql_where_temp_clause)
			end
		end

feature -- Prepare and Finish Meta Term

	prepare_meta_term
		do
			number_of_variables := 0
			create sql_where_temp_clause.make_empty
			sql_where_temp_clause.append_character ('(')
		end

	finish_meta_term
		do
			sql_where_temp_clause.append_character (')')
			sql_select_clauses.extend (sql_where_temp_clause)
		end

feature -- Prepare and Finish Variable Term

	prepare_variable_term (a_prop_kind: INTEGER)
		do
			number_of_variables := 0
			current_term_property_kind := a_prop_kind
			create sql_where_temp_clause.make_empty
			sql_where_temp_clause.append_character ('(')
		end

	add_position_clause (a_position: INTEGER)
		local
			l_clause: STRING
		do
			create l_clause.make_from_string (last_appeared_variable)
			l_clause.append (once ".position = ")
			l_clause.append_integer (a_position)
			sql_where_clauses.extend (l_clause)
		end

	add_type_clause (a_type: STRING)
		local
			l_clause: STRING
		do
			create l_clause.make_from_string (last_appeared_variable)
			l_clause.append_character ('.')
			l_clause.append (once ".type1 = (SELECT prop_id FROM Properties WHERE `text` = %"")
			l_clause.append (a_type)
			l_clause.append (once "%")")
			sql_where_clauses.extend (l_clause)
		end

	finish_variable_term
		do
			sql_where_temp_clause.append_character (')')
--			sql_select_clauses.extend (sql_where_temp_clause)
		end

feature -- Selects

	add_select_clauses_for_variable_term
		local
			l_clause: STRING
		do
			create l_clause.make_from_string (last_appeared_variable)
			l_clause.append_character ('.')
			sql_select_clauses.extend (once "qry.uuid")
			sql_select_clauses.extend (l_clause + once "var1")
			sql_select_clauses.extend (l_clause + once "value")
			sql_select_clauses.extend (l_clause + once "equal_value")
			sql_select_clauses.extend (l_clause + once "type1")
			sql_select_clauses.extend (l_clause + once "position")
		end

	add_select_clauses_for_equation_term
		local
			l_clause: STRING
		do
			sql_select_clauses.extend (once "qry.uuid")
			if number_of_variables = 0 or number_of_variables > 1 then
				if is_expression_in_select then
					sql_select_clauses.extend (sql_where_temp_clause)
				else
					sql_select_clauses.extend (once "NULL")
				end
				sql_select_clauses.extend (once "NULL")
				sql_select_clauses.extend (once "NULL")
				sql_select_clauses.extend (once "NULL")
			else
				create l_clause.make_from_string (last_appeared_variable)
				l_clause.append_character ('.')
				if is_expression_in_select then
					sql_select_clauses.extend (sql_where_temp_clause)
				else
					sql_select_clauses.extend (l_clause + once "value")
				end
				sql_select_clauses.extend (l_clause + once "equal_value")
				sql_select_clauses.extend (l_clause + once "prop_kind")
				sql_select_clauses.extend (l_clause + once "boost")
			end
		end

feature

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

	process_binary_as (l_as: BINARY_AS)
		do
			if l_as.op_name.string_value_32.ends_with (once "~") then
				is_comparing_objects := True
			end
			l_as.left.process (Current)
			sql_where_temp_clause.append_character (' ')
			if l_as.op_name.string_value_32.same_string (once "/=") then
				sql_where_temp_clause.append (once "<>")
			elseif l_as.op_name.string_value_32.same_string (once "/~") then
				sql_where_temp_clause.append (once "<>")
			else
				sql_where_temp_clause.append (l_as.op_name.string_value_32)
			end
			sql_where_temp_clause.append_character (' ')
			l_as.right.process (Current)
			is_comparing_objects := False
		end

	process_expr_call_as (l_as: EXPR_CALL_AS)
		local
			l_s: STRING
		do
			if not is_gathering_feature_info and not is_collecting_parameters then
				is_gathering_feature_info := True
				create feature_call_replaced.make_empty
				parameter_count := 1
				parameter_position := 1
				Precursor (l_as)
				if is_qry_feature then
					sql_where_temp_clause.append (once "qry.")
					is_gathering_feature_info := False
					is_collecting_parameters := True
					Precursor (l_as)
					is_qry_feature := False
				else
					sql_where_temp_clause.append (once "Prop")
					sql_where_temp_clause.append_integer (number_of_joins)
					if is_comparing_objects then
						sql_where_temp_clause.append (once ".equal_value")
					else
						sql_where_temp_clause.append (once ".value")
					end
					-- Joins
					create l_s.make_empty
					l_s.append (once "LEFT JOIN PropertyBindings")
					l_s.append_integer (parameter_count)
					l_s.append (once " AS Prop")
					l_s.append_integer (number_of_joins)
					l_s.append (once " ON (qry.qry_id = Prop")
					l_s.append_integer (number_of_joins)
					l_s.append (once ".qry_id AND Prop")
					l_s.append_integer (number_of_joins)
					l_s.append (once ".prop_id = (SELECT prop_id FROM Properties WHERE text = %"")
					l_s.append (feature_call_replaced)
					l_s.append (once "%") AND Prop")
					l_s.append_integer (number_of_joins)
					l_s.append (once ".prop_kind = ")
					l_s.append_integer (current_term_property_kind)
					l_s.append (once ")")
					sql_join_statements.extend (l_s)
					is_gathering_feature_info := False
					is_collecting_parameters := True
					parameter_position := 1
					Precursor (l_as)
					number_of_joins := number_of_joins + 1
				end
				is_collecting_parameters := False
			else
				Precursor (l_as)
			end
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		local
			l_s: STRING
		do
			-- First phase: Create replaced feature call, and count parameters
			if is_gathering_feature_info then
				-- Check for 'qry'
				if l_as.access_name.same_string (once "qry") then
					is_qry_feature := True
				-- Call gives us parameter count
				elseif l_as.is_qualified then
					parameter_count := l_as.parameter_count + 1
					feature_call_replaced.append_character ('.')
					feature_call_replaced.append (l_as.access_name)
				-- Others are features
				else
					if parameter_position = 2 then
						feature_call_replaced.append_character (' ')
						feature_call_replaced.append_character ('(')
					end
					if parameter_position > 2 then
						feature_call_replaced.append_character (',')
						feature_call_replaced.append_character (' ')
					end
					feature_call_replaced.append_character ('$')
					if parameter_count > 1 and parameter_position = parameter_count then
						feature_call_replaced.append_character (')')
					end
					parameter_position := parameter_position + 1
				end
			end

			-- Second phase creates variable mappings
			if is_collecting_parameters then
				-- Check for 'qry'
				if is_qry_feature and l_as.is_qualified then
					sql_where_temp_clause.append (l_as.access_name)
				-- Regular feature call
				elseif not is_qry_feature then
					if not l_as.is_qualified then
						last_appeared_variable := once "Prop" + number_of_joins.out
						number_of_variables := number_of_variables + 1
						-- Lookup variable
						if variable_mapping_table.has (l_as.access_name) then
							create l_s.make_empty
							l_s.append (once "(Prop")
							l_s.append_integer (number_of_joins)
							l_s.append (once ".var")
							l_s.append_integer (parameter_position)
							l_s.append (once " = Prop")
							l_s.append_integer (variable_mapping_table.at (l_as.access_name).join_number)
							l_s.append (once ".var")
							l_s.append_integer (variable_mapping_table.at (l_as.access_name).parameter_position)
							l_s.append (once ")")
							sql_where_clauses.extend (l_s)
						else
							variable_mapping_table.put ([number_of_joins, parameter_position], l_as.access_name)
						end
						parameter_position := parameter_position + 1
					end
				end
			end
			Precursor (l_as)
		end

end
