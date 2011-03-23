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
	make_with_string,
	make_without_type

feature{NONE} -- Initialization

	make (a_expression: like expression; a_value: like value; a_type: like type)
			-- Initialize `expression' with `a_expression', `value' with `a_value', `type' with `a_type'.
		do
			expression := a_expression
			value := a_value
			type := a_type
			hash_code := text_from_ast (a_expression).hash_code
		end

	make_with_string (a_expression: STRING; a_value: STRING; a_type: like type)
			-- Initialize `expression' with `a_expression', `value' with `a_value', `type' with `a_type'.
		do
			make (ast_from_expression_text (a_expression), ast_from_expression_text (a_value), a_type)
		end

	make_without_type (a_expression: like expression; a_value: like value)
			-- Initialize `expression' with `a_expression', `value' with `a_value'
		do
			expression := a_expression
			value := a_value
		end

feature -- Access

	expression: EXPR_AS
			-- Expression inside Current term:
			-- This can be an expression describing a search criterion;
			-- or an expression describing the information to return.

	value: EXPR_AS
			-- Value inside Current term:
			-- This can be Void (to simply specify information to return from
			-- `expression' or a boolean value to compare `expression' to.

	type: TYPE_A
			-- Type of `expression'

	hash_code: INTEGER
			-- Hash code value

	text: STRING
			-- Text representation of Current term
		do
			create Result.make (128)
			Result.append (once "Meta: ")
			Result.append (text_from_ast (expression))
			Result.append_character (',')
		end

	columns_in_result (a_start_column: INTEGER): INTEGER_INTERVAL
			-- 1-based column ranges in the resulting SQL table starting from `a_start_column'
			-- A to-be-returned meta column occupies one column in the resulting SQL table.
			-- That column stores the the value of the term.
			-- A meta term only occupies one column:
			-- 1. value    (from Queryables)
		do
			create Result.make (a_start_column, a_start_column)
		ensure then
			good_result: Result.lower = a_start_column and Result.upper = a_start_column
		end

	column_types_in_result (a_start_column: INTEGER): HASH_TABLE [INTEGER, INTEGER]
			-- <Precursor>
		local
			l_columns: like columns_in_result
		do
			l_columns := columns_in_result (a_start_column)
			create Result.make (1)
			if type.is_boolean then
				Result.force (mysql_boolean_type, l_columns.item (1))
			elseif type.is_integer then
				Result.force (mysql_integer_type, l_columns.item (1))
			elseif type.has_associated_class and then type.associated_class.class_id = first_class_starts_with_name (once "STRING_8").class_id then
				Result.force (mysql_string_type, l_columns.item (1))
			else
				check should_not_be_here: False end
			end
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
