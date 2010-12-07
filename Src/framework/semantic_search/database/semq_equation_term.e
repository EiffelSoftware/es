note
	description: "Class that represents an equation term"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_EQUATION_TERM

inherit
	SEMQ_TERM
		redefine
			is_precondition,
			is_postcondition,
			is_human_written,
			is_property,
			is_absolute_change,
			is_relative_change
		end

create
	make

feature{NONE} -- Initialization

	make (a_equation: like equation; a_queryable: like queryable)
			-- Initialize `equation' with `a_equation' and `queryable' with `a_queryable'.
		do
			equation := a_equation
			queryable := a_queryable
			hash_code := equation.hash_code
		end

feature -- Access

	equation: EPA_EQUATION
			-- Equation inside Current term

	entity: EXPR_AS
			-- Entity inside Current term
			-- This can be an expression described a searched criterion (in this case,
			-- the expression must evaluates to boolean type); or an expression describing
			-- the information to return.
		do
			Result := equation.expression.ast
		end

	type: TYPE_A
			-- Type of `entity'
		do
			Result := equation.expression.type
		end

	hash_code: INTEGER
			-- Hash code value

	text: STRING
			-- Text representation of Current term
		do
			create Result.make (128)
			if is_precondition then
				Result.append (once "Precondition: ")
			elseif is_postcondition then
				Result.append (once "Postcondition: ")
			elseif is_property then
				Result.append (once "Property: ")
			end
			Result.append (equation.text)
			Result.append_character (',')
			Result.append_character (' ')
			if is_searched then
				Result.append (once ", searched")
			end
			if is_required then
				Result.append (once ", required")
			end
		end

	columns_in_result (a_start_column: INTEGER): INTEGER_INTERVAL
			-- 1-based column ranges in the resulting SQL table starting from `a_start_column'
			-- An equation term occupies four columns in the resulting SQL table:
			-- 1. value          (from PropertyBindingsX.value)
			-- 2. equal_value    (from PropertyBindingsX.equal_value)
			-- 3. dynamic_type   (derived from PropertyBindingsX.prop_type_kind)
			-- 4. boost          (from PropertyBindingsX.boost)
			-- Note: Column 2-4 only make sense for single-path-expressions, for other expression,
			-- the values for those columns are NULL in the resulting table.
		do
			create Result.make (a_start_column, a_start_column + 3)
		ensure then
			good_result: Result.lower = a_start_column and Result.upper = a_start_column + 3
		end

feature -- Status report

	is_precondition: BOOLEAN
			-- Is current a precondition term?

	is_postcondition: BOOLEAN
			-- Is current a postcondition term?

	is_human_written: BOOLEAN
			-- Is current a contract term and that contract is human-written?

	is_property: BOOLEAN
			-- Is current a property term (for objects)?

	is_absolute_change: BOOLEAN
			-- Is Current an absolute change term?

	is_relative_change: BOOLEAN
			-- Is Current an relative change term?

feature -- Setting

	set_is_precondition (b: BOOLEAN)
			-- Set `is_precondition' with `b'.
			-- Note: specify consistent values according to `is_postcondition', `is_property'.
		do
			is_precondition := b
		ensure
			is_precondition_set: is_precondition = b
		end

	set_is_postcondition (b: BOOLEAN)
			-- Set `is_postcondition' with `b'.
			-- Note: specify consistent values according to `is_pretcondition', `is_property'.
		do
			is_postcondition := b
		ensure
			is_postcondition_set: is_postcondition = b
		end

	set_is_human_written (b: BOOLEAN)
			-- Set `is_human_written' with `b'.
		do
			is_human_written := b
		ensure
			is_human_written_set: is_human_written = b
		end

	set_is_property (b: BOOLEAN)
			-- Set `is_property' with `b'.
			-- Note: specify consistent values according to `is_precondition', `is_postcondition'.
		do
			is_property := b
		ensure
			is_property_set: is_property = b
		end

	set_is_absolute_change (b: BOOLEAN)
			-- Set `is_absolute_change' with `b'.
		do
			is_absolute_change := b
		ensure
			is_absolute_change_set: is_absolute_change = b
		end

	set_is_relative_change (b: BOOLEAN)
			-- Set `is_relative_change' with `b'.
		do
			is_relative_change := b
		ensure
			is_relative_change_set: is_relative_change = b
		end

feature -- Process

	process (a_visitor: SEMQ_TERM_VISITOR)
			-- Visit Current using `a_visitor'.
		do
			a_visitor.process_equation_term (Current)
		end

end

