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

create
	make

feature{NONE} -- Initialization

	make (a_expression: like expression; a_values: like values; a_relative: BOOLEAN)
			-- Initialize Current.
		do
			expression := a_expression

			create values.make (a_values.count)
			values.set_equality_tester (expression_equality_tester)
			values.append_last (a_values)

			set_is_relative (a_relative)
			set_relevance (1.0)
		end

feature -- Access

	expression: EPA_EXPRESSION
			-- Expression to which Current change is associated

	values: EPA_EXPRESSION_CHANGE_VALUE_SET
			-- Values by which or to which `expression' changes

	relevance: DOUBLE
			-- Relevance of Current change
			-- Maybe used as a boost value in search engine
			-- Default: 1.0

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

end
