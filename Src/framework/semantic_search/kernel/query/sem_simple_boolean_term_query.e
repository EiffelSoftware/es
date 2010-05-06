note
	description: "Simple boolean term queries which only accept {TERM_QUERY}s as its components"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_SIMPLE_BOOLEAN_TERM_QUERY

inherit
	SEM_QUERY

	SEM_SHARED_BOOST_VALUES

	SEM_BOOLEAN_CLAUSE_OCCUR

	SEM_SHARED_EQUALITY_TESTER

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
			boost := default_boost_value
			create term_queries.make (5)
			term_queries.set_key_equality_tester (term_query_equality_tester)
		end

feature -- Access

	boost: DOUBLE
			-- Boost value of current query
			-- Default: 1.0

	term_queries: DS_HASH_TABLE [INTEGER, SEM_TERM_QUERY]
			-- Table of term queries in current boolean query
			-- Key is term query, value is the occurrence criterion of that term query
			-- check {SEM_BOOLEAN_CLAUSE_OCCUR} for details about valid occurrence criteria

feature -- Basic operations

	put_term_query (a_term_query: SEM_TERM_QUERY; a_occur: INTEGER)
			-- Extend `a_term_query' with occurrence criterion `a_occur' into `term_queries'.
		require
			a_term_query_not_exists: not term_queries.has (a_term_query)
			a_occur_valid: is_occur_criterion_valid (a_occur)
		do
			term_queries.force_last (a_occur, a_term_query)
		ensure
			a_term_query_added: term_queries.has (a_term_query) and then term_queries.item (a_term_query) = a_occur
		end
end
