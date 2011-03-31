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

feature -- Basic operations

	execute (a_query: SEMQ_QUERYABLE_QUERY)
			-- Execute `a_query' and make results available in `last_results'.
		local
			l_term_visitor: SEMQ_QUERYABLE_QUERY_TERM_VISITOR
			l_ast_visitor: SEMQ_QUERYABLE_QUERY_AST_VISITOR
			l_query_string: STRING
			l_result_array: ARRAY [STRING]
			l_column_ith: INTEGER
		do
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
					l_query_string.append_string (once ".position")
					l_ast_visitor.variable_mapping_table.forth
				end
			end

			-- Debug
			io.put_string (l_query_string)
			io.put_character ('%N')
			io.put_character ('%N')

			-- Execute query and store results
			create last_results.make
			connection.execute_query (l_query_string)
			from
				connection.last_result.start
			until
				connection.last_result.after
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

end
