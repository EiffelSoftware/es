note
	description: "Class that represents a value which is a set of other values"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXPRESSION_SET_VALUE

inherit
	EPA_EXPRESSION_VALUE
		redefine
			item,
			type,
			out,
			text
		end

	EPA_SHARED_EQUALITY_TESTERS
		undefine
			is_equal,
			out
		end

create
	make

feature{NONE} -- Initialization

	make (a_type: like type)
			-- Initialize Current set value with `a_type'.
		do
			type := a_type
			create item.make (10)
			item.set_equality_tester (expression_value_equality_tester)
		end

feature -- Access

	item: EPA_HASH_SET [EPA_EXPRESSION_VALUE]
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
			Result.append_character ('{')

			from
				i := 1
				c := item.count
				l_cursor := item.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.append (l_cursor.item.out)
				if i < c then
					Result.append_character (',')
					Result.append_character (' ')
				end
				i := i + 1
				l_cursor.forth
			end
			Result.append_character ('}')
		end

feature -- Process

	process (a_visitor: EPA_EXPRESSION_VALUE_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_set_value (Current)
		end

end
