note
	description: "Class to execute a query using Solr engine"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IR_SOLR_QUERY_EXECUTOR

inherit
	IR_QUERY_EXECUTOR

	IR_QUERY_VISITOR

feature -- Basic operations

	execute (a_query: IR_QUERY)
			-- Execute `a_query'.
		do
			a_query.process (Current)
		end

feature{NONE} -- Implementation

	process_boolean_query (a_query: IR_BOOLEAN_QUERY)
			-- Process `a_query'.
		local
			l_syntax: STRING
		do
			l_syntax := query_syntax_from_query (a_query)
			io.put_string ("------------------%N")
			io.put_string (l_syntax)
		end

	query_syntax_from_query (a_query: IR_BOOLEAN_QUERY): STRING
			-- Query syntax from `a_query'
		local
			l_term_syntax: STRING
			l_cursor: DS_HASH_SET_CURSOR [IR_TERM]
		do
			create Result.make (1024)

				-- Add all searchable terms into the query syntax.
			from
				l_cursor := a_query.terms.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_term_syntax := term_syntax_generator.field_syntax (l_cursor.item)
				Result.append (l_term_syntax)
				Result.append_character ('%N')
				l_cursor.forth
			end
		end

	term_syntax_generator: IR_SOLR_QUERY_FIELD_SYNTAX_GENERATOR
			-- Term query generator
		once
			create Result
		end
end
