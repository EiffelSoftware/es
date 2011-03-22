note
	description: "Query executor"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_QUERY_EXECUTOR

inherit
	SEMQ_QUERY_VISITOR

	REFACTORING_HELPER

create
	make

feature{NONE} -- Initialization

	make (a_connection: like connection)
			-- Inialize Current.
		do
			connection := a_connection
		end

feature -- Access

	last_results: detachable LINKED_LIST [SEMQ_RESULT]
			-- Last results retrieved by `execute'
			-- The order of the elements is meaningful of one of the
			-- query term has ordering configuration specified.

	connection: MYSQL_CLIENT
			-- Database connection

feature -- Basic operations

	execute (a_query: SEMQ_QUERY)
			-- Execute `a_query', and make result available in `last_results'.
		do
			create last_results.make
			a_query.process (Current)
		end

feature{NONE} -- Process

	process_queryable_query (a_query: SEMQ_QUERYABLE_QUERY)
			-- Process `a_query'.
		local
			l_executor: SEMQ_QUERYABLE_QUERY_EXECUTOR
		do
			create l_executor.make (connection)
			l_executor.execute (a_query)
		end

	process_whole_document_query (a_query: SEMQ_WHOLE_QUERYABLE_QUERY)
			-- Process `a_query'.
		local
			l_executor: SEMQ_WHOLE_QUERYABLE_QUERY_EXECUTOR
		do
			create l_executor.make (connection)
			l_executor.execute (a_query)
			last_results := l_executor.last_results
		end

end
