note
	description: "A reader that reads the data from a dynamic program analysis from disk using a MYSQL database."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_MYSQL_DATA_READER

inherit
	DPA_DATA_READER

	DPA_MYSQL_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_mysql_client: like mysql_client)
			-- Initialize `mysql_client' with `a_mysql_client'
		require
			a_mysql_client_not_void: a_mysql_client /= Void
		local
			l_analysis_order_pairs_table_existence: BOOLEAN
			l_expression_value_transitions_table_existence: BOOLEAN
		do
			mysql_client := a_mysql_client
			mysql_client.execute_query ("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '" + mysql_client.database + "' AND table_name = '" + analysis_order_pairs_table_name + "';")
			mysql_client.last_result.start
			l_analysis_order_pairs_table_existence := mysql_client.last_result.at (1).to_integer = 1

			mysql_client.execute_query ("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '" + mysql_client.database + "' AND table_name = '" + expression_value_transitions_table_name + "';")
			mysql_client.last_result.start
			l_expression_value_transitions_table_existence := mysql_client.last_result.at (1).to_integer = 1

			check both_tables_exist: l_analysis_order_pairs_table_existence and l_expression_value_transitions_table_existence end

			mysql_client.execute_query ("SELECT COUNT(DISTINCT " + evt_class_attribute_name + "), COUNT(DISTINCT " + evt_feature_attribute_name + ") FROM " + expression_value_transitions_table_name)
			mysql_client.last_result.start
			check database_used_for_one_feature: mysql_client.last_result.at (1).to_integer = 1 and mysql_client.last_result.at (2).to_integer = 1 end

			mysql_client.execute_query ("SELECT DISTINCT " + evt_class_attribute_name + ", " + evt_feature_attribute_name + " FROM " + expression_value_transitions_table_name)
			mysql_client.last_result.start
			class_ := mysql_client.last_result.at (1)
			feature_ := mysql_client.last_result.at (2)
		ensure
			mysql_client_set: mysql_client = a_mysql_client
			class_set: class_ /= Void and class_.count >= 1
			feature_set: feature_ /= Void and feature_.count >= 1
		end

feature -- Access

	class_: STRING
			-- Context class of `feature_'.

	feature_: STRING
			-- Feature that was analyzed.

	analysis_order_pairs: LINKED_LIST [TUPLE [pre_state_bp: INTEGER; post_state_bp: INTEGER]]
			-- List of pre-state / post-state breakpoint pairs in the order they were analyzed.
			-- Note: The analysis order is not the same as the execution order which is complete
			-- whilst the analysis order only contains the hit pre-state / post-state breakpoints.
		local
			l_last_result: MYSQL_RESULT
			l_pre_state_bp, l_post_state_bp: INTEGER
		do
			create Result.make
			mysql_client.execute_query ("SELECT " + aop_pre_state_bp_attribute_name + ", " + aop_post_state_bp_attribute_name + " FROM " + analysis_order_pairs_table_name)
			l_last_result := mysql_client.last_result
			from
				l_last_result.start
			until
				l_last_result.after
			loop
				l_pre_state_bp := l_last_result.at (1).to_integer
				l_post_state_bp := l_last_result.at (2).to_integer
				Result.extend ([l_pre_state_bp, l_post_state_bp])
				l_last_result.forth
			end
		end

	analysis_order_pairs_count: INTEGER
			-- Number of pre-state / post-state breakpoint pairs.
		local
			l_last_result: MYSQL_RESULT
		do
			mysql_client.execute_query ("SELECT COUNT(" + aop_counter_attribute_name + ") FROM " + analysis_order_pairs_table_name)
			l_last_result := mysql_client.last_result
			l_last_result.start
			Result := l_last_result.at (1).to_integer
		end

	limited_analysis_order_pairs (a_lower_bound: INTEGER; a_upper_bound: INTEGER): LINKED_LIST [TUPLE [pre_state_bp: INTEGER; post_state_bp: INTEGER]]
			-- Limited list of pre-state / post-state breakpoint pairs in the order they were analyzed.
			-- Valid values of `a_lower_bound' and `a_upper_bound' are in the interval between 1 and `analysis_order_pairs_count'
			-- Note: The analysis order is not the same as the execution order which is complete
			-- whilst the analysis order only contains the hit pre-state / post-state breakpoints.
		local
			l_last_result: MYSQL_RESULT
			l_pre_state_bp, l_post_state_bp: INTEGER
		do
			create Result.make
			mysql_client.execute_query ("SELECT " + aop_pre_state_bp_attribute_name + ", " + aop_post_state_bp_attribute_name + " FROM " + analysis_order_pairs_table_name + " WHERE " + aop_counter_attribute_name + " >= " + a_lower_bound.out + " AND " + aop_counter_attribute_name + " <= " + a_upper_bound.out)
			l_last_result := mysql_client.last_result
			from
				l_last_result.start
			until
				l_last_result.after
			loop
				l_pre_state_bp := l_last_result.at (1).to_integer
				l_post_state_bp := l_last_result.at (2).to_integer
				Result.extend ([l_pre_state_bp, l_post_state_bp])
				l_last_result.forth
			end
		end

	expressions_and_locations: LINKED_LIST [TUPLE [expression: STRING; location: INTEGER]]
			-- Expressions and locations at which they were evaluted during the analysis.
		local
			l_last_result: MYSQL_RESULT
			l_expression: STRING
			l_pre_state_bp: INTEGER
		do
			create Result.make
			mysql_client.execute_query ("SELECT DISTINCT " + evt_expression_attribute_name + ", " + evt_pre_state_bp_attribute_name + " FROM " + expression_value_transitions_table_name)
			l_last_result := mysql_client.last_result
			from
				l_last_result.start
			until
				l_last_result.after
			loop
				l_expression := l_last_result.at (1)
				l_pre_state_bp := l_last_result.at (2).to_integer
				Result.extend ([l_expression, l_pre_state_bp])
				l_last_result.forth
			end
		end

	expression_value_transitions_count (a_expression: STRING; a_location: INTEGER): INTEGER
			-- Number of value transitions of `a_expression' evaluated at `a_location'.
		local
			l_last_result: MYSQL_RESULT
		do
			mysql_client.execute_query ("SELECT COUNT(" + evt_counter_attribute_name + ") FROM " + expression_value_transitions_table_name + " WHERE " + evt_expression_attribute_name + " = %"" + a_expression + "%" AND " + evt_pre_state_bp_attribute_name + " = " + a_location.out)
			l_last_result := mysql_client.last_result
			l_last_result.start
			Result := l_last_result.at (1).to_integer
		end

	expression_value_transitions (a_expression: STRING; a_location: INTEGER): LINKED_LIST [EPA_VALUE_TRANSITION]
			-- Value transitions of `a_expression' evaluated at `a_location'.
		do
			create Result.make
			mysql_client.execute_query ("SELECT " + evt_pre_state_bp_attribute_name + ", " + evt_pre_state_type_attribute_name + ", " + evt_pre_state_value_attribute_name + ", " + evt_pre_state_type_information_attribute_name + ", " + evt_post_state_bp_attribute_name + ", " + evt_post_state_type_attribute_name + ", " + evt_post_state_value_attribute_name + ", " + evt_post_state_type_information_attribute_name + " FROM " + expression_value_transitions_table_name + " WHERE " + evt_expression_attribute_name + " = %"" + a_expression + "%" AND " + evt_pre_state_bp_attribute_name + " = " + a_location.out)
			Result := expression_value_transitions_from_mysql_results (mysql_client.last_result)
		end

	limited_expression_value_transitions (a_expression: STRING; a_location: INTEGER; a_lower_bound: INTEGER; a_upper_bound: INTEGER): LINKED_LIST [EPA_VALUE_TRANSITION]
			-- Limited value transitions of `a_expression' evaluated at `a_location'.
			-- Valid values of `a_lower_bound' and `a_upper_bound' are in the interval between 1 and `expression_value_transitions_count'
		do
			create Result.make
			mysql_client.execute_query ("SELECT " + evt_pre_state_bp_attribute_name + ", " + evt_pre_state_type_attribute_name + ", " + evt_pre_state_value_attribute_name + ", " + evt_pre_state_type_information_attribute_name + ", " + evt_post_state_bp_attribute_name + ", " + evt_post_state_type_attribute_name + ", " + evt_post_state_value_attribute_name + ", " + evt_post_state_type_information_attribute_name + " FROM " + expression_value_transitions_table_name + " WHERE " + evt_expression_attribute_name + " = %"" + a_expression + "%" AND " + evt_pre_state_bp_attribute_name + " = " + a_location.out + " AND " + evt_counter_attribute_name + " >= " + a_lower_bound.out + " AND " + evt_counter_attribute_name + " <= " + a_upper_bound.out)
			Result := expression_value_transitions_from_mysql_results (mysql_client.last_result)
		end

feature {NONE} -- Implementation

	mysql_client: MYSQL_CLIENT
			-- MYSQL client used to access the MYSQL database

feature {NONE} -- Implementation

	expression_value_transitions_from_mysql_results (a_mysql_results: MYSQL_RESULT): LINKED_LIST [EPA_VALUE_TRANSITION]
			-- Extract expression value transitions from `a_mysql_results'.
			-- Columns of `a_mysql_results' are:
			-- 1: pre-state breakpoint
			-- 2: pre-state type
			-- 3: pre-state value
			-- 4: pre-state additional type information
			-- 5: post-state breakpoint
			-- 6: post-state type
			-- 7: post-state value
			-- 8: post-state additional type information
		require
			a_mysql_results_not_void: a_mysql_results /= Void
		local
			l_pre_state_bp, l_post_state_bp: INTEGER
			l_value: STRING
			l_pre_state_value, l_post_state_value: EPA_EXPRESSION_VALUE
			l_type, l_address, l_class_id: STRING
			l_value_transition: EPA_VALUE_TRANSITION
		do
			create Result.make
			from
				a_mysql_results.start
			until
				a_mysql_results.after
			loop
				-- Pre-state
				l_pre_state_bp := a_mysql_results.at (1).to_integer
				l_type := a_mysql_results.at (2)
				l_value := a_mysql_results.at (3)
				if l_type.is_equal (reference_value) then
					l_class_id := a_mysql_results.at (4)
					l_pre_state_value := ref_value_from_data (l_value, l_class_id)
				elseif l_type.is_equal (string_value) then
					l_address := a_mysql_results.at (4)
					l_pre_state_value := string_value_from_data (l_value, l_address)
				else
					l_pre_state_value := value_from_data (l_value, l_type)
				end

				-- Post-state
				l_post_state_bp := a_mysql_results.at (5).to_integer
				l_type := a_mysql_results.at (6)
				l_value := a_mysql_results.at (7)
				if l_type.is_equal (reference_value) then
					l_class_id := a_mysql_results.at (8)
					l_post_state_value := ref_value_from_data (l_value, l_class_id)
				elseif l_type.is_equal (string_value) then
					l_address := a_mysql_results.at (8)
					l_post_state_value := string_value_from_data (l_value, l_address)
				else
					l_post_state_value := value_from_data (l_value, l_type)
				end

				create l_value_transition.make (l_pre_state_bp, l_pre_state_value, l_post_state_bp, l_post_state_value)

				Result.extend (l_value_transition)

				a_mysql_results.forth
			end
		ensure
			Result_not_void: Result /= Void
		end

end
