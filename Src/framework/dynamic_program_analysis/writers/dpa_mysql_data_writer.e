note
	description: "A writer that writes the data from a dynamic program analysis to disk using a MYSQL database."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_MYSQL_DATA_WRITER

inherit
	DPA_DATA_WRITER

	DPA_MYSQL_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_class: like class_; a_feature: like feature_; a_mysql_client: like mysql_client)
			--
		require
			a_class_not_void: a_class /= Void
			a_feature_not_void: a_feature /= Void
			a_mysql_client_not_void: a_mysql_client /= Void
		local
			l_mysql_result: MYSQL_RESULT
			l_loc_expr: STRING
			l_loc: STRING
			l_expr: STRING
		do
			class_ := a_class
			feature_ := a_feature
			mysql_client := a_mysql_client

			if not mysql_client.is_connected then
				mysql_client.connect
			end
			check MYSQL_Client_connected_to_database: mysql_client.is_connected end

			mysql_client.execute_query ("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '" + mysql_client.database + "' AND table_name = '" + analysis_order_pairs_table_name + "';")
			mysql_client.last_result.start
			if mysql_client.last_result.at (1).to_integer = 0 then
				mysql_client.execute_query ("CREATE TABLE " + analysis_order_pairs_table_name + " (" + aop_counter_attribute_name + " INT AUTO_INCREMENT, " + aop_pre_state_bp_attribute_name + " INT, " + aop_post_state_bp_attribute_name + " INT, PRIMARY KEY (" + aop_counter_attribute_name + "))")
			end

			create expression_evaluation_count.make_default

			mysql_client.execute_query ("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '" + mysql_client.database + "' AND table_name = '" + expression_value_transitions_table_name + "';")
			mysql_client.last_result.start
			if mysql_client.last_result.at (1).to_integer = 0 then
				mysql_client.execute_query ("CREATE TABLE " + expression_value_transitions_table_name + " (" + evt_counter_attribute_name + " INT AUTO_INCREMENT, " + evt_class_attribute_name + " TEXT, " + evt_feature_attribute_name + " TEXT, " + evt_expression_attribute_name + " TEXT, " + evt_location_expression_occurrence_attribute_name + " INT, " + evt_pre_state_bp_attribute_name + " INT, " + evt_pre_state_type_attribute_name + " TEXT, " + evt_pre_state_type_information_attribute_name + " TEXT, " + evt_pre_state_value_attribute_name + " TEXT, " + evt_post_state_bp_attribute_name + " INT, " + evt_post_state_type_attribute_name + " TEXT, " + evt_post_state_type_information_attribute_name + " TEXT, " + evt_post_state_value_attribute_name + " TEXT, PRIMARY KEY (" + evt_counter_attribute_name + "))")
			else
				mysql_client.execute_query ("SELECT DISTINCT " + evt_class_attribute_name + ", " + evt_feature_attribute_name + " FROM " + expression_value_transitions_table_name)
				l_mysql_result := mysql_client.last_result
				l_mysql_result.start
				check same_class_and_feature: l_mysql_result.at (1).is_equal (class_.name) and l_mysql_result.at (2).is_equal (feature_.feature_name_32) end

				mysql_client.execute_query ("SELECT " + evt_pre_state_bp_attribute_name + ", " + evt_expression_attribute_name + ", COUNT(" + evt_pre_state_bp_attribute_name + ") FROM " + expression_value_transitions_table_name + " GROUP BY " + evt_pre_state_bp_attribute_name + ", " + evt_expression_attribute_name)
				l_mysql_result := mysql_client.last_result
				from
					l_mysql_result.start
				until
					l_mysql_result.after
				loop
					l_loc := l_mysql_result.at (1)
					l_expr := l_mysql_result.at (2)
					create l_loc_expr.make (l_loc.count + l_expr.count + 1)
					l_loc_expr.append (l_loc)
					l_loc_expr.append_character (';')
					l_loc_expr.append (l_expr)
					expression_evaluation_count.force_last (l_mysql_result.at (3).to_integer, l_loc_expr)
					l_mysql_result.forth
				end
			end

			create analysis_order_pairs.make
			create expression_value_transitions.make
		ensure
			class_set: class_ = a_class
			feature_set: feature_ = a_feature
			mysql_client_set: mysql_client = a_mysql_client
		end

feature -- Access

	mysql_client: MYSQL_CLIENT
			--

feature -- Writing

	try_write
			-- Try to write the content of `analysis_order_pairs' and `expression_value_transitions'.
			-- Succeeds if the sum of analysis order pairs and expression value transitions exceeds 5000.
		do
			if analysis_order_pairs.count + expression_value_transitions.count > 5000 then
				write
			end
		end

	write
			-- Write `analysis_order_pairs' and `expression_value_transitions' to `mysql_client.database'
		local
			l_prepared_statement: MYSQL_PREPARED_STATEMENT
			l_transition: EPA_EXPRESSION_VALUE_TRANSITION
			l_pre_state_bp, l_expr: STRING
			l_loc_expr: STRING
			l_type_finder: EPA_EXPRESSION_VALUE_TYPE_FINDER
			l_bp_slots: TUPLE [pre_state_bp_slot: INTEGER; post_state_bp_slot: INTEGER]
			l_evt_key_occurrence: INTEGER
		do
			mysql_client.prepare_statement ("INSERT INTO " + analysis_order_pairs_table_name + " VALUES (?,?,?)")
			l_prepared_statement := mysql_client.last_prepared_statement

			from
				analysis_order_pairs.start
			until
				analysis_order_pairs.after
			loop
				l_bp_slots := analysis_order_pairs.item

				l_prepared_statement.set_integer (aop_pre_state_bp_attribute_column_number, l_bp_slots.pre_state_bp_slot)
				l_prepared_statement.set_integer (aop_post_state_bp_attribute_column_number, l_bp_slots.post_state_bp_slot)
				l_prepared_statement.execute
				Check analysis_order_pair_inserted: l_prepared_statement.is_executed end

				analysis_order_pairs.forth
			end

			mysql_client.prepare_statement ("INSERT INTO " + expression_value_transitions_table_name + " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)")
			l_prepared_statement := mysql_client.last_prepared_statement
			l_prepared_statement.set_string (evt_class_attribute_column_number, class_.name)
			l_prepared_statement.set_string (evt_feature_attribute_column_number, feature_.feature_name_32)

			create l_type_finder

			from
				expression_value_transitions.start
			until
				expression_value_transitions.after
			loop
				l_transition := expression_value_transitions.item_for_iteration

				l_pre_state_bp := l_transition.pre_state_bp.out
				l_expr := l_transition.expression.text
				create l_loc_expr.make (l_pre_state_bp.count + l_expr.count + 1)
				l_loc_expr.append (l_pre_state_bp)
				l_loc_expr.append_character (';')
				l_loc_expr.append (l_expr)

				l_prepared_statement.set_string (evt_expression_attribute_column_number, l_expr)

				if expression_evaluation_count.has (l_loc_expr) then
					l_evt_key_occurrence := expression_evaluation_count.item (l_loc_expr) + 1
					expression_evaluation_count.force_last (l_evt_key_occurrence, l_loc_expr)
					l_prepared_statement.set_integer (evt_location_expression_occurrence_attribute_column_number, l_evt_key_occurrence)
				else
					expression_evaluation_count.force_last (1, l_loc_expr)
					l_prepared_statement.set_integer (evt_location_expression_occurrence_attribute_column_number, 1)
				end

				-- Pre-state value
				l_type_finder.set_value (l_transition.pre_state_value)
				l_type_finder.find

				l_prepared_statement.set_integer (evt_pre_state_bp_attribute_column_number, l_transition.pre_state_bp)
				l_prepared_statement.set_string (evt_pre_state_type_attribute_column_number, l_type_finder.type)
				l_prepared_statement.set_string (evt_pre_state_value_attribute_column_number, l_transition.pre_state_value.text)
				l_prepared_statement.set_null (evt_pre_state_type_information_attribute_column_number)
				if l_type_finder.type.is_equal (reference_value) then
					if attached {CL_TYPE_A} l_transition.pre_state_value.type as l_type then
						l_prepared_statement.set_string (evt_pre_state_type_information_attribute_column_number, l_type.class_id.out)
					end
				end
				if l_type_finder.type.is_equal (string_value) then
					l_prepared_statement.set_string (evt_pre_state_type_information_attribute_column_number, l_transition.pre_state_value.item.out)
				end

				-- Post-state value
				l_type_finder.set_value (l_transition.post_state_value)
				l_type_finder.find

				l_prepared_statement.set_integer (evt_post_state_bp_attribute_column_number, l_transition.post_state_bp)
				l_prepared_statement.set_string (evt_post_state_type_attribute_column_number, l_type_finder.type)
				l_prepared_statement.set_string (evt_post_state_value_attribute_column_number, l_transition.post_state_value.text)
				l_prepared_statement.set_null (evt_post_state_type_information_attribute_column_number)
				if l_type_finder.type.is_equal (reference_value) then
					if attached {CL_TYPE_A} l_transition.post_state_value.type as l_type then
						l_prepared_statement.set_string (evt_post_state_type_information_attribute_column_number, l_type.class_id.out)
					end
				end
				if l_type_finder.type.is_equal (string_value) then
					l_prepared_statement.set_string (evt_post_state_type_information_attribute_column_number, l_transition.post_state_value.item.out)
				end

				l_prepared_statement.execute
				Check expression_value_transition_inserted: l_prepared_statement.is_executed end
				expression_value_transitions.forth
			end
		end

feature {NONE} -- Implementation

	expression_evaluation_count: DS_HASH_TABLE [INTEGER, STRING]
			-- Number of evaluations of an expression at a location.
			-- Keys are the expressions and locations of the form 'loc:expr'.
			-- Values are the number of evaluations of 'loc:expr'.

end
