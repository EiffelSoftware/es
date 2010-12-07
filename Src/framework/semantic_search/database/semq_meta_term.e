note
	description: "Class that represents a meta term"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_META_TERM

inherit
	SEMQ_TERM
		redefine
			is_meta
		end

	EPA_UTILITY

create
	make,
	make_with_string

feature{NONE} -- Initialization

	make (a_entity: like entity; a_type: like type; a_queryable: like queryable)
			-- Initialize `entity' with `a_entity', `type' with `a_type' and
			-- `queryable' with `a_queryable'.
		do
			entity := a_entity
			type := a_type
			queryable := a_queryable
			hash_code := text_from_ast (a_entity).hash_code
		end

	make_with_string (a_entity: STRING; a_type: like type; a_queryable: like queryable)
			-- Initialize `entity' with `a_entity', `type' with `a_type' and
			-- `queryable' with `a_queryable'.
		do
			make (ast_from_expression_text (a_entity), a_type, a_queryable)
		end

feature -- Access

	entity: EXPR_AS
			-- Entity inside Current term
			-- This can be an expression described a searched criterion (in this case,
			-- the expression must evaluates to boolean type); or an expression describing
			-- the information to return.

	type: TYPE_A
			-- Type of `entity'

	hash_code: INTEGER
			-- Hash code value

	text: STRING
			-- Text representation of Current term
		do
			create Result.make (128)
			Result.append (once "Meta: ")
			Result.append (text_from_ast (entity))
			Result.append_character (',')
		end

	columns_in_result (a_start_column: INTEGER): INTEGER_INTERVAL
			-- 1-based column ranges in the resulting SQL table starting from `a_start_column'
			-- A to-be-returned meta column occupies one column in the resulting SQL table.
			-- That column stores the the value of the term.
		do
			create Result.make (a_start_column, a_start_column)
		ensure then
			good_result: Result.lower = a_start_column and Result.upper = a_start_column
		end

feature -- Status report

	is_meta: BOOLEAN = True
			-- Is Current is a meta term?	

feature -- Process

	process (a_visitor: SEMQ_TERM_VISITOR)
			-- Visit Current using `a_visitor'.
		do
			a_visitor.process_meta_term (Current)
		end

end
