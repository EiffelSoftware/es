note
	description: "Query executor using Solr"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_SOLR_QUERY_EXECUTOR

inherit
	SEM_QUERY_EXECUTOR

	REFACTORING_HELPER

	SEM_QUERY_VISITOR

feature -- Basic operations

	execute (a_query: SEM_QUERY)
			-- Executor `a_query', make result available in `last_result'.
		do
			execute_with_options (a_query, Void)
		end

	execute_with_options (a_query: SEM_QUERY; a_options: detachable HASH_TABLE [STRING, STRING])
			-- Execute `a_boolean_query' with `a_options'.
			-- `a_options' is a hash-table containing options for the query execution, specified as
			-- name-value pairs. Key is option name, value is option value.
		do
			options := a_options
			a_query.process (Current)
		end

feature -- Process

	process_boolean_query (a_query: SEM_BOOLEAN_QUERY)
			-- Process `a_query'.
		local
			l_executor: SEM_SOLR_BOOLEAN_QUERY_EXECUTOR
		do
			create l_executor.make
			l_executor.execute_with_options (a_query, options)
			last_result := l_executor.last_result
		end

feature{NONE} -- Implementatation

	options: detachable HASH_TABLE [STRING, STRING]
			-- Options to execute the query
			-- Key is option name, value is option value.
end
