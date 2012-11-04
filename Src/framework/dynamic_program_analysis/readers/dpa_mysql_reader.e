note
	description: "Reader using a MYSQL database to read analysis results."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_MYSQL_READER

inherit
	DPA_READER

	DPA_MYSQL_CONSTANTS
		export
			{NONE} all
		end

	KL_SHARED_STRING_EQUALITY_TESTER
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (a_mysql_client: like mysql_client)
			-- Initialize MYSQL reader.
		require
			a_mysql_client_not_void: a_mysql_client /= Void
		local
			l_last_mysql_result: MYSQL_RESULT
		do
			mysql_client := a_mysql_client

			-- Connect MYSQL client to database if the MYSQL client is not connected.
			if
				not mysql_client.is_connected
			then
				mysql_client.connect
			end

			check
				mysql_client_connected: mysql_client.is_connected
			end

			-- Check existence of transitions table.
			mysql_client.execute_query (
				"SELECT COUNT(*) FROM information_schema.tables WHERE %
				%table_schema = '" + mysql_client.database + "' AND %
				%table_name = '" + Mysql_transitions_table_name + "';"
			)
			l_last_mysql_result := mysql_client.last_result
			l_last_mysql_result.start

			check
				transitions_table_exists: l_last_mysql_result.at (1).to_integer = 1
			end

			-- Check that transitions table was used to store analysis results of exactly one
			-- feature.
			mysql_client.execute_query (
				"SELECT COUNT(DISTINCT " + Mysql_class_name + "), %
				%COUNT(DISTINCT " + Mysql_feature_name + ") FROM " +
				Mysql_transitions_table_name
			)
			l_last_mysql_result := mysql_client.last_result
			l_last_mysql_result.start

			check
				database_used_for_analysis_one_feature:
					mysql_client.last_result.at (1).to_integer = 1 and then
					mysql_client.last_result.at (2).to_integer = 1
			end

			-- Initialize `class_' and `feature_'.
			mysql_client.execute_query (
				"SELECT DISTINCT " + Mysql_class_name + ", " + Mysql_feature_name + " FROM " +
				Mysql_transitions_table_name
			)
			l_last_mysql_result := mysql_client.last_result
			l_last_mysql_result.start
			class_ := l_last_mysql_result.at (1)
			feature_ := l_last_mysql_result.at (2)

			expression_evaluation_plan := expression_evaluation_plan_from_mysql
		ensure
			mysql_client_set: mysql_client = a_mysql_client
			class_set: class_ /= Void and then class_.count >= 1
			feature_set: feature_ /= Void and then feature_.count >= 1
			expression_evaluation_plan_not_void: expression_evaluation_plan /= Void
		end

feature -- Access

	mysql_client: MYSQL_CLIENT
			-- MYSQL client used to access the MYSQL database.

	class_: STRING
			-- Context class of `feature_'.

	feature_: STRING
			-- Feature which was analyzed.

	expression_evaluation_plan: DS_HASH_TABLE [DS_HASH_SET [INTEGER], STRING]
			-- Expression evaluation plan specifying the program locations at which an expression
			-- is evaluated before and after the execution of a program location.
			-- Keys are expressions.
			-- Values are program locations.

	number_of_transitions (a_expression: STRING; a_program_location: INTEGER): INTEGER
			-- Number of transitions for `a_expression' evaluated before and after
			-- the execution of `a_program_location'.
		local
			l_last_mysql_result: MYSQL_RESULT
		do
			mysql_client.execute_query (
				"SELECT COUNT(" + Mysql_counter_name + ") FROM " +
				Mysql_transitions_table_name + " WHERE " +
				Mysql_expression_name + " = %"" + a_expression + "%" AND " +
				Mysql_pre_state_breakpoint_name + " = " + a_program_location.out
			)
			l_last_mysql_result := mysql_client.last_result
			l_last_mysql_result.start
			Result := l_last_mysql_result.at (1).to_integer
		end

	transitions (a_expression: STRING; a_program_location: INTEGER):
		ARRAYED_LIST [EPA_VALUE_TRANSITION]
			-- Transitions for `a_expression' evaluated before and after the exeuction of
			-- `a_program_location'.
		do
			mysql_client.execute_query (
				"SELECT " + Mysql_pre_state_breakpoint_name + ", " +
				Mysql_pre_state_type_name + ", " + Mysql_pre_state_value_name + ", " +
				Mysql_pre_state_type_information_name + ", " +
				Mysql_post_state_breakpoint_name + ", " +
				Mysql_post_state_type_name + ", " + Mysql_post_state_value_name + ", " +
				Mysql_post_state_type_information_name + " FROM " + Mysql_transitions_table_name +
				" WHERE " + Mysql_expression_name + " = %"" + a_expression + "%" AND " +
				Mysql_pre_state_breakpoint_name + " = " + a_program_location.out
			)
			Result := transitions_from_mysql_result (mysql_client.last_result)
		end

	subset_of_transitions (
		a_expression: STRING;
		a_program_location: INTEGER;
		a_lower_bound: INTEGER;
		a_upper_bound: INTEGER
	): ARRAYED_LIST [EPA_VALUE_TRANSITION]
			-- Subset of transitions for `a_expression' evaluated before and after
			-- the execution of `a_program_location'.
			-- Valid values of `a_lower_bound' and `a_upper_bound' are in the interval between 1
			-- and `number_of_transitions'.
		do
			mysql_client.execute_query (
				"SELECT " + Mysql_pre_state_breakpoint_name + ", " +
				Mysql_pre_state_type_name + ", " + Mysql_pre_state_value_name + ", " +
				Mysql_pre_state_type_information_name + ", " +
				Mysql_post_state_breakpoint_name + ", " +
				Mysql_post_state_type_name + ", " + Mysql_post_state_value_name + ", " +
				Mysql_post_state_type_information_name + " FROM " +
				Mysql_transitions_table_name + " WHERE " +
				Mysql_expression_name + " = %"" + a_expression + "%" AND " +
				Mysql_pre_state_breakpoint_name + " = " + a_program_location.out + " AND " +
				Mysql_counter_name + " >= " + a_lower_bound.out + " AND " +
				Mysql_counter_name + " <= " + a_upper_bound.out
			)
			Result := transitions_from_mysql_result (mysql_client.last_result)
		end

feature {NONE} -- Implementation

	transitions_from_mysql_result (a_mysql_result: MYSQL_RESULT):
		ARRAYED_LIST [EPA_VALUE_TRANSITION]
			-- Extract transitions from `a_mysql_result'.
			-- Columns of `a_mysql_result' are:
			-- 1: pre-state breakpoint.
			-- 2: pre-state expression type.
			-- 3: pre-state expression value.
			-- 4: pre-state additional expression type information.
			-- 5: post-state breakpoint.
			-- 6: post-state expression type.
			-- 7: post-state expression value.
			-- 8: post-state additional expression type information.
		require
			a_mysql_result_not_void: a_mysql_result /= Void
		local
			l_pre_state_breakpoint, l_post_state_breakpoint: INTEGER
			l_value: STRING
			l_pre_state_value, l_post_state_value: EPA_EXPRESSION_VALUE
			l_type, l_address, l_class_id: STRING
			l_transition: EPA_VALUE_TRANSITION
		do
			create Result.make (a_mysql_result.row_count)

			-- Iterate over tuples (transitions) retrieved from the MYSQL database.
			from
				a_mysql_result.start
			until
				a_mysql_result.after
			loop
				-- Extract pre-state values.
				l_pre_state_breakpoint := a_mysql_result.at (1).to_integer
				l_type := a_mysql_result.at (2)
				l_value := a_mysql_result.at (3)

				if
					l_type.is_equal (Reference_value)
				then
					l_class_id := a_mysql_result.at (4)
					l_pre_state_value := new_reference_value (l_value, l_class_id)
				elseif
					l_type.is_equal (String_value)
				then
					l_address := a_mysql_result.at (4)
					l_pre_state_value := new_string_value (l_value, l_address)
				else
					l_pre_state_value := new_expression_value (l_value, l_type)
				end

				-- Extract post-state values.
				l_post_state_breakpoint := a_mysql_result.at (5).to_integer
				l_type := a_mysql_result.at (6)
				l_value := a_mysql_result.at (7)

				if
					l_type.is_equal (Reference_value)
				then
					l_class_id := a_mysql_result.at (8)
					l_post_state_value := new_reference_value (l_value, l_class_id)
				elseif
					l_type.is_equal (String_value)
				then
					l_address := a_mysql_result.at (8)
					l_post_state_value := new_string_value (l_value, l_address)
				else
					l_post_state_value := new_expression_value (l_value, l_type)
				end

				create l_transition.make (
					l_pre_state_breakpoint,
					l_pre_state_value,
					l_post_state_breakpoint,
					l_post_state_value
				)

				Result.extend (l_transition)

				a_mysql_result.forth
			end
		ensure
			Result_not_void: Result /= Void
		end

	expression_evaluation_plan_from_mysql: DS_HASH_TABLE [DS_HASH_SET [INTEGER], STRING]
			-- Expression evaluation plan from MYSQL database specifying the program
			-- locations at which an expression is evaluated before and after the execution of a
			-- program location.
			-- Keys are expressions.
			-- Values are program locations.
		local
			l_last_mysql_result: MYSQL_RESULT
			l_expression: STRING
			l_program_location: INTEGER
			l_program_locations: DS_HASH_SET [INTEGER]
		do
			-- Retrieve expression and program location pairs from MYSQLdatabase.
			mysql_client.execute_query (
				"SELECT DISTINCT " + Mysql_expression_name + ", " +
				Mysql_pre_state_breakpoint_name + " FROM " + Mysql_transitions_table_name
			)
			l_last_mysql_result := mysql_client.last_result

			create Result.make_default
			Result.set_key_equality_tester (string_equality_tester)

			-- Iterate over retrieved pairs of expressions and program locations.
			from
				l_last_mysql_result.start
			until
				l_last_mysql_result.after
			loop
				l_expression := l_last_mysql_result.at (1)
				l_program_location := l_last_mysql_result.at (2).to_integer

				if
					Result.has (l_expression)
				then
					Result.item (l_expression).force_last (l_program_location)
				else
					create l_program_locations.make_default
					l_program_locations.force_last (l_program_location)
					Result.force_last (l_program_locations, l_expression)
				end

				l_last_mysql_result.forth
			end
		end

end
