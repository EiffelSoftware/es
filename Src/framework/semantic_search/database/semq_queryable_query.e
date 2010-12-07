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

	next_term_return_config: SEMQ_TERM_RETURN_CONFIG
			-- Configuration determining the position of a to-be-returned term
		do
			create Result.make (next_term_return_position)
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

feature{NONE} -- Implementation

	next_term_return_position: INTEGER
			-- The next available position for a term that is to be returned
		do
			Result := 1
			across terms as l_terms loop
				if attached {SEMQ_TERM_RETURN_CONFIG} l_terms.item.return_config as l_return_config then
					if l_return_config.position > Result then
						Result := l_return_config.position + 1
					end
				end
			end
		end

feature{NONE} -- SQL processing only

	column_count_in_result: INTEGER
			-- Number of columns in the resulting SQL table
		local
			l_term: SEMQ_TERM
		do
			across terms as l_terms loop
				l_term := l_terms.item
				if l_term.is_required then
					Result := Result + l_term.column_count_in_result
				end
			end
		end

	columns_in_result: HASH_TABLE [TUPLE [term: SEMQ_TERM; term_data_index: INTEGER], INTEGER]
			-- The table from 1-based column indexes to its associated terms
			-- Keys are 1-based integers indicating the column index in the resulting SQL table
			-- Values are tuples. `term' is the term to which the SQL table column associated with.
			-- `term_data_index' is the index of the data item within a term (`term_data_index' is needed
			-- because a to-be-returned term may occupy multiple columns in the resulting SQL table, see
			-- {SEMQ_TERM}.`columns_in_result'.)
		local
			l_index_tbl: HASH_TABLE [SEMQ_TERM, INTEGER]
			l_sorted_indexes: SORTED_TWO_WAY_LIST [INTEGER]
			l_column: INTEGER
			l_position: INTEGER
			l_term: SEMQ_TERM
			l_total_column_count: INTEGER
			l_term_column_count: INTEGER
		do
				-- Collect position information for all returned terms.
			create l_index_tbl.make (terms.count)
			create l_sorted_indexes.make
			across terms as l_terms loop
				l_term := l_terms.item
				if l_term.is_required then
					l_position := l_term.return_config.position
					l_sorted_indexes.extend (l_position)
					l_index_tbl.force (l_term, l_position)
					l_total_column_count := l_total_column_count + l_term.column_count_in_result
				end
			end

				-- Calculate term positions.			
			create Result.make (l_total_column_count)
			l_column := 1
			across l_sorted_indexes as l_indexes loop
				l_term := l_index_tbl.item (l_indexes.item)
				l_term_column_count := l_term.column_count_in_result
				across l_column |..| (l_column + l_term_column_count - 1) as l_cols loop
					Result.extend ([l_term, l_cols.item - l_column + 1], l_cols.item)
				end
				l_column := l_column + l_term_column_count
			end
		end

invariant
	same_queryable: across terms as l_terms all l_terms.item.queryable = queryable end

end
