note
	description: "Class that represents a query config for SQL-implementation"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_QUERYABLE_QUERY

inherit
	SEMQ_QUERY

create
	make

feature{NONE} -- Initialization

	make (a_queryable: like queryable)
			-- Initialize Current.
		do
			set_queryable (a_queryable)
			create terms.make
		end

feature -- Access

	queryable: SEM_QUERYABLE
			-- Queryable wrapped by Current query

	terms: LINKED_LIST [SEMQ_TERM]
			-- List of searched terms

	text: STRING
			-- String representation of Current query
		do
			create Result.make (1024)
			Result.append (once "Terms:%N")
			across terms as l_terms loop
				Result.append_character ('%T')
				Result.append (l_terms.item.text)
				Result.append_character ('%N')
			end
		end

feature{NONE} -- Setting

	set_queryable (a_queryable: like queryable)
			-- Set `queryable' with `a_queryable'.
		do
			queryable := a_queryable
		ensure
			queryable_set: queryable = a_queryable
		end

feature -- Process

	process (a_visitor: SEMQ_QUERY_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_queryable_query (Current)
		end


invariant
	same_queryable: across terms as l_terms all l_terms.item.queryable = queryable end

end
