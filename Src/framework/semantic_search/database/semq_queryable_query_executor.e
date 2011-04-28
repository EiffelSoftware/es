note
	description: "Queryable query executor"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_QUERYABLE_QUERY_EXECUTOR

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

	last_results: LINKED_LIST [ARRAY [STRING]]
			-- Results retrieved from last `execute'

	log_manager: detachable ELOG_LOG_MANAGER
			-- Log manager

feature -- Setting

	set_log_manager (a_manager: like log_manager)
			-- Set `log_manager' with `a_manager'.
		do
			log_manager := a_manager
		ensure
			log_manager_set: log_manager = a_manager
		end

feature -- Basic operations

	execute (a_query: SEMQ_QUERYABLE_QUERY)
			-- Execute `a_query' and make results available in `last_results'.
		local
			l_term_visitor: SEMQ_QUERYABLE_QUERY_TERM_VISITOR
			l_ast_visitor: SEMQ_QUERYABLE_QUERY_AST_VISITOR
			l_query_string: STRING
			l_result_array: ARRAY [STRING]
			l_column_ith: INTEGER
			l_retried: BOOLEAN
		do
			if not l_retried then
				-- Visitors
				create l_ast_visitor.make
				create l_term_visitor.make (l_ast_visitor)
				from
					a_query.terms.start
				until
					a_query.terms.off
				loop
					a_query.terms.item.process (l_term_visitor)
					a_query.terms.forth
				end

				-- Construct query
				create l_query_string.make_empty

				-- SELECT
				l_query_string.append (once "SELECT %N")
				from
					l_ast_visitor.sql_select_clauses.start
				until
					l_ast_visitor.sql_select_clauses.after
				loop
					l_query_string.append_character ('%T')
					l_query_string.append (l_ast_visitor.sql_select_clauses.item)
					l_ast_visitor.sql_select_clauses.forth
					if not l_ast_visitor.sql_select_clauses.after then
						l_query_string.append_character (',')
					end
					l_query_string.append_character ('%N')
				end

				-- FROM
				l_query_string.append (once "FROM Queryables AS qry")
				from
					l_ast_visitor.sql_from_clauses.start
				until
					l_ast_visitor.sql_from_clauses.after
				loop
					l_query_string.append_character (',')
					l_query_string.append_character (' ')
					l_query_string.append (l_ast_visitor.sql_from_clauses.item)
					l_ast_visitor.sql_from_clauses.forth
				end

				-- JOIN
	--			from
	--				l_ast_visitor.sql_join_statements.start
	--			until
	--				l_ast_visitor.sql_join_statements.after
	--			loop
	--				l_query_string.append (l_ast_visitor.sql_join_statements.item)
	--				l_query_string.append_character ('%N')
	--				l_ast_visitor.sql_join_statements.forth
	--			end

				-- WHERE
				l_query_string.append (once "%NWHERE %N")
				from
					l_ast_visitor.sql_where_clauses.start
				until
					l_ast_visitor.sql_where_clauses.after
				loop
					l_query_string.append (l_ast_visitor.sql_where_clauses.item)
					l_ast_visitor.sql_where_clauses.forth
					if not l_ast_visitor.sql_where_clauses.after then
						l_query_string.append_string (once " AND %N")
					end
				end

				-- GROUP BY
				if a_query.is_group_by_feature_and_positions then
					l_query_string.append (once "%NGROUP BY qry.feature_name")
					from
						l_ast_visitor.variable_mapping_table.start
					until
						l_ast_visitor.variable_mapping_table.after
					loop
						l_query_string.append_string (once ", Prop")
						l_query_string.append_integer (l_ast_visitor.variable_mapping_table.item_for_iteration.join_number)
						l_query_string.append_string (once ".`position`")
						l_ast_visitor.variable_mapping_table.forth
					end
				end

				-- Debug
	--			io.put_string (l_query_string)
	--			io.put_character ('%N')
	--			io.put_character ('%N')

				-- Execute query and store results
				if log_manager /= Void then
					check attached {STRING} l_query_string.twin as l_temp_str then
						l_temp_str.replace_substring_all ("%N", " ")
						log_manager.put_string_with_time ("Start query: " + l_temp_str)
					end
				end
				create last_results.make
				connection.execute_query (l_query_string)
				from
					connection.last_result.start
				until
						-- FIXME: The "last_results.count > 100" condition is used
						-- to get out of an infinite loop, caused by some problems
						-- when we iterating through `connection.last_result'.
					connection.last_result.after or last_results.count > 100
				loop
					create l_result_array.make_filled (Void, 1, connection.last_result.column_count)
					from
						l_column_ith := 1
					until
						l_column_ith > connection.last_result.column_count
					loop
						l_result_array.put (connection.last_result.at (l_column_ith), l_column_ith)
						l_column_ith := l_column_ith + 1
					end
					last_results.extend (l_result_array)
					connection.last_result.forth
				end
			end
		rescue
			if connection.is_connected then
				connection.close
				connection.reinitialize
			end
			l_retried := True
			create last_results.make
			retry
		end

end
