note
	description: "Writer using a MYSQL database to write analysis results."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_MYSQL_WRITER

inherit
	DPA_WRITER

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

	make (a_class: like class_; a_feature: like feature_; a_mysql_client: like mysql_client)
			-- Initialize MYSQL writer.
		require
			a_class_not_void: a_class /= Void
			a_feature_not_void: a_feature /= Void
			a_mysql_client_not_void: a_mysql_client /= Void
		local
			l_last_mysql_result: MYSQL_RESULT
			l_localized_expression: STRING
			l_program_location: STRING
			l_expression: STRING
		do
			class_ := a_class
			feature_ := a_feature
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

			create localized_expression_occurrences.make_default
			localized_expression_occurrences.set_key_equality_tester (string_equality_tester)

			-- Create table for transitions if table does not already exist. Otherwise validate
			-- class and feature from already existing analysis results with `class_' and
			-- `feature_'.
			mysql_client.execute_query (
				"SELECT COUNT(*) FROM information_schema.tables WHERE %
				%table_schema = '" + mysql_client.database + "' AND %
				%table_name = '" + Mysql_transitions_table_name + "';"
			)

			l_last_mysql_result := mysql_client.last_result
			l_last_mysql_result.start

			if
				l_last_mysql_result.at (1).to_integer = 0
			then
				mysql_client.execute_query (
					"CREATE TABLE " + Mysql_transitions_table_name + " (" +
					Mysql_counter_name + " INT AUTO_INCREMENT, " +
					Mysql_class_name + " TEXT, " +
					Mysql_feature_name + " TEXT, " +
					Mysql_expression_name + " TEXT, " +
					Mysql_localized_expression_occurrences_name + " INT, " +
					Mysql_pre_state_breakpoint_name + " INT, " +
					Mysql_pre_state_type_name + " TEXT, " +
					Mysql_pre_state_type_information_name + " TEXT, " +
					Mysql_pre_state_value_name + " TEXT, " +
					Mysql_post_state_breakpoint_name + " INT, " +
					Mysql_post_state_type_name + " TEXT, " +
					Mysql_post_state_type_information_name + " TEXT, " +
					Mysql_post_state_value_name + " TEXT, %
					%PRIMARY KEY (" + Mysql_counter_name + ")" +
					")"
				)
			else
				mysql_client.execute_query (
					"SELECT DISTINCT " + mysql_class_name + ", " +
					mysql_feature_name + " FROM " +
					Mysql_transitions_table_name
				)

				l_last_mysql_result := mysql_client.last_result
				l_last_mysql_result.start

				check
					same_class_and_feature:
						l_last_mysql_result.at (1).is_equal (class_.name) and then
						l_last_mysql_result.at (2).is_equal (feature_.feature_name_32) and then
						l_last_mysql_result.row_count = 1
				end

				--	Restore `localized_expression_occurrences' from previous analysis results.
				mysql_client.execute_query (
					"SELECT " + Mysql_expression_name + ", " +
					Mysql_pre_state_breakpoint_name + ", %
					%COUNT(" + Mysql_pre_state_breakpoint_name + ") FROM " +
					Mysql_transitions_table_name + " GROUP BY " +
					Mysql_pre_state_breakpoint_name + ", " +
					Mysql_expression_name
				)

				l_last_mysql_result := mysql_client.last_result

				from
					l_last_mysql_result.start
				until
					l_last_mysql_result.after
				loop
					l_expression := l_last_mysql_result.at (1)
					l_program_location := l_last_mysql_result.at (2)

					create l_localized_expression.make (
						l_expression.count + l_program_location.count + 1
					)
					l_localized_expression.append (l_expression)
					l_localized_expression.append_character (';')
					l_localized_expression.append (l_program_location)

					localized_expression_occurrences.force_last (
						l_last_mysql_result.at (3).to_integer,
						l_localized_expression
					)

					l_last_mysql_result.forth
				end
			end

			create transitions.make
		ensure
			class_set: class_ = a_class
			feature_set: feature_ = a_feature
			mysql_client_set: mysql_client = a_mysql_client
			localized_expression_occurrences_not_void: localized_expression_occurrences /= Void
			transitions_not_void: transitions /= Void
		end

feature -- Access

	mysql_client: MYSQL_CLIENT
			-- MYSQL client used to read and write analysis results.

feature -- Basic operations

	try_write
			-- Try to write analysis results.
			-- Analysis results are only written if the number of
			-- transitions is greater than `Transitions_size_limit'.
		do
			if
				transitions.count > Transitions_size_limit
			then
				write
			end
		end

	write
			-- Write analysis results.
		local
			l_prepared_statement: MYSQL_PREPARED_STATEMENT
			l_transition: EPA_EXPRESSION_VALUE_TRANSITION
			l_pre_state_breakpoint, l_expression: STRING
			l_localized_expression: STRING
			l_expression_value_type_finder: EPA_EXPRESSION_VALUE_TYPE_FINDER
			l_localized_expression_occurrence: INTEGER
		do
			-- Start a transaction to speed up the insertion of the transitions.
			mysql_client.execute_query ("START TRANSACTION")

			-- Insert transitions into MYSQL database.
			mysql_client.prepare_statement (
				"INSERT INTO " + Mysql_transitions_table_name +
				" VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)"
			)

			l_prepared_statement := mysql_client.last_prepared_statement
			l_prepared_statement.set_string (Mysql_class_column, class_.name)
			l_prepared_statement.set_string (Mysql_feature_column, feature_.feature_name_32)

			create l_expression_value_type_finder

			from
				transitions.start
			until
				transitions.after
			loop
				l_transition := transitions.item_for_iteration

				l_pre_state_breakpoint := l_transition.pre_state_breakpoint.out
				l_expression := l_transition.expression.text

				create l_localized_expression.make (
					l_expression.count + l_pre_state_breakpoint.count + 1
				)
				l_localized_expression.append (l_expression)
				l_localized_expression.append_character (';')
				l_localized_expression.append (l_pre_state_breakpoint)

				if
					localized_expression_occurrences.has (l_localized_expression)
				then
					l_localized_expression_occurrence :=
						localized_expression_occurrences.item (l_localized_expression) + 1
					localized_expression_occurrences.force_last (
						l_localized_expression_occurrence, l_localized_expression
					)
					l_prepared_statement.set_integer (
						Mysql_localized_expression_occurrences_column,
						l_localized_expression_occurrence
					)
				else
					localized_expression_occurrences.force_last (1, l_localized_expression)
					l_prepared_statement.set_integer (
						Mysql_localized_expression_occurrences_column,
						1
					)
				end

				l_prepared_statement.set_string (Mysql_expression_column, l_expression)

				-- Pre-state value
				l_expression_value_type_finder.set_value (l_transition.pre_state_value)
				l_expression_value_type_finder.find

				l_prepared_statement.set_integer (
					Mysql_pre_state_breakpoint_column, l_transition.pre_state_breakpoint
				)
				l_prepared_statement.set_string (
					Mysql_pre_state_type_column, l_expression_value_type_finder.type
				)
				l_prepared_statement.set_string (
					Mysql_pre_state_value_column, l_transition.pre_state_value.text
				)
				l_prepared_statement.set_null (Mysql_pre_state_type_information_column)

				if
					l_expression_value_type_finder.type.is_equal (Reference_value) and then
					attached {CL_TYPE_A} l_transition.pre_state_value.type as l_type
				then
					l_prepared_statement.set_string (
						Mysql_pre_state_type_information_column, l_type.class_id.out
					)
				end

				if
					l_expression_value_type_finder.type.is_equal (String_value)
				then
					l_prepared_statement.set_string (
						Mysql_pre_state_type_information_column,
						l_transition.pre_state_value.item.out
					)
				end

				-- Post-state value
				l_expression_value_type_finder.set_value (l_transition.post_state_value)
				l_expression_value_type_finder.find

				l_prepared_statement.set_integer (
					Mysql_post_state_breakpoint_column, l_transition.post_state_breakpoint
				)
				l_prepared_statement.set_string (
					Mysql_post_state_type_column, l_expression_value_type_finder.type
				)
				l_prepared_statement.set_string (
					Mysql_post_state_value_column, l_transition.post_state_value.text
				)
				l_prepared_statement.set_null (Mysql_post_state_type_information_column)

				if
					l_expression_value_type_finder.type.is_equal (Reference_value) and then
					attached {CL_TYPE_A} l_transition.post_state_value.type as l_type
				then
					l_prepared_statement.set_string (
						Mysql_post_state_type_information_column, l_type.class_id.out
					)
				end

				if
					l_expression_value_type_finder.type.is_equal (String_value)
				then
					l_prepared_statement.set_string (
						Mysql_post_state_type_information_column,
						l_transition.post_state_value.item.out
					)
				end

				l_prepared_statement.execute

				check
					transition_inserted: l_prepared_statement.is_executed
				end

				transitions.forth
			end

			-- Commit the transction to conclude the insertion of the transitions.
			mysql_client.execute_query ("COMMIT")

			-- Empty `transitions' since all of them were written to MYSQL database.
			create transitions.make
		end

feature {NONE} -- Implementation

	Transitions_size_limit: INTEGER = 5000
			-- Size limit of `transitions'.

feature {NONE} -- Implementation

	localized_expression_occurrences: DS_HASH_TABLE [INTEGER, STRING]
			-- Occurrences of localized expressions.
			-- Keys are localized expressions of the form 'expression:program location'.
			-- Values are occurrences of localized expressions.

end
