note
	description: "Objects that represent changes to the value of an expression"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXPRESSION_CHANGE

inherit
	REFACTORING_HELPER

	EPA_SHARED_EQUALITY_TESTERS

	DEBUG_OUTPUT

	HASHABLE

create
	make

feature{NONE} -- Initialization

	make (a_expression: like expression; a_values: like values; a_relative: BOOLEAN)
			-- Initialize Current.
		local
			l_hash_str: STRING
		do
			expression := a_expression

			values := a_values
			set_is_relative (a_relative)
			set_relevance (1.0)

			create l_hash_str.make (64)
			l_hash_str.append (is_relative.out)
			l_hash_str.append_character (',')
			l_hash_str.append (expression.text)
			hash_code := l_hash_str.hash_code
		end

feature -- Access

	expression: EPA_EXPRESSION
			-- Expression to which Current change is associated

	type: TYPE_A
			-- Type of `expression'
		do
			Result := expression.type
		end

	values: EPA_EXPRESSION_CHANGE_VALUE_SET
			-- Values by which or to which `expression' changes

	relevance: DOUBLE
			-- Relevance of Current change
			-- Maybe used as a boost value in search engine
			-- Default: 1.0

	hash_code: INTEGER
			-- Hash code value

feature -- Status report	

	is_relative: BOOLEAN
			-- Is Current a relative change?
			-- For example, "index" is increased by 1, then "by 1" is relative.

	is_absolute: BOOLEAN
			-- Is Current an absolute change?
			-- For example, "index" is set to 1, then "to 1" is absolute.
		do
			Result := not is_relative
		end

	is_no_change: BOOLEAN
			-- Does current represent if there is no change to `expression'?
		do
			Result := attached {EPA_EXPRESSION_NO_CHANGE_SET} values
		end

feature -- Setting

	set_is_relative (b: BOOLEAN)
			-- Set `is_relative' with `b'.
		do
			is_relative := b
		ensure
			is_relative_set: is_relative = b
		end

	set_is_absolute (b: BOOLEAN)
			-- Set `is_absolute' with `b'.
		do
			is_relative := not b
		ensure
			is_absolute_set: is_absolute = b
		end

	set_relevance (v: DOUBLE)
			-- Set `relevance' with `v'.
		do
			relevance := v
		ensure
			relevance_set: relevance = v
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			create Result.make (128)
			if is_relative then
				Result.append (once "by::")
			else
				Result.append (once "to::")
			end
			Result.append (expression.text)
			Result.append (once " == ")
			Result.append (values.debug_output)
			Result.append (once ", ")
			Result.append (relevance.out)
		end

end
