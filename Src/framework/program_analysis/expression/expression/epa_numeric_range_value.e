note
	description: "Class that represents an integer interval"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_NUMERIC_RANGE_VALUE

inherit
	EPA_EXPRESSION_VALUE
		redefine
			type,
			item,
			text,
			out
		end

	EPA_SHARED_EQUALITY_TESTERS
		undefine
			is_equal,
			out
		end

	SHARED_TYPES
		undefine
			is_equal,
			out
		end

create
	make

feature{NONE} -- Initialization

	make (a_lower: INTEGER; a_upper: INTEGER)
			-- Initialize Current.
		do
			type := integer_type
			create item.make (a_lower, a_upper)
		end

feature -- Access

	item: INTEGER_INTERVAL
			-- Item of current value

	type: TYPE_A
			-- Type of current value

	text, out: STRING
			-- New string containing terse printable representation
			-- of current object
		local
			i, c: INTEGER
			l_cursor: like item.new_cursor
		do
			create Result.make (32)
			Result.append_character ('[')
			Result.append_integer (item.lower)
			Result.append_character (',')
			Result.append_integer (item.upper)

			Result.append_character (']')
		end

feature -- Process

	process (a_visitor: EPA_EXPRESSION_VALUE_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_numeric_range_value (Current)
		end

end
