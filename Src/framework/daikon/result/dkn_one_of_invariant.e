note
	description: "An Daikon ONE OF invariant"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DKN_ONE_OF_INVARIANT

inherit
	DKN_INVARIANT
		redefine
			is_one_of
		end

create
	make

feature{NONE} -- Initialization

	make (a_expr: like expression; a_values: like values)
			-- Initialize.
		local
			i: INTEGER
			c: INTEGER
			l_cursor: DS_HASH_SET_CURSOR [STRING]
		do
			expression := a_expr.twin
			values := a_values

			create text.make (64)
			text.append (expression)
			text.append (once " |one_of| [")
			from
				i := 1
				c := values.count
				l_cursor := values.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				text.append (l_cursor.item)
				if i < c then
					text.append (once ", ")
				end
				i := i + 1
				l_cursor.forth
			end
			text.append_character (']')
		end

feature -- Access

	text: STRING
			-- Text of Current

	expression: STRING
			-- Expression whose values are inferred

	values: DS_HASH_SET [STRING]
			-- Values of `expression'

	hash_code: INTEGER
			-- Hash code
		do
			Result := text.hash_code
		end

	debug_output: STRING
			-- Debug output
		do
			Result := text
		end

feature -- Status report

	is_one_of: BOOLEAN = True
			-- Is current an "one of" invariant?


end
