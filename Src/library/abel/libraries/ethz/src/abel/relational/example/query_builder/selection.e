note
	description: "Summary description for {SELECTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SELECTION [G]

inherit

	QUERY_PART

create
	make

feature -- Initialization

	make (att_name: STRING; op: QUERY_PART; att_val: G)
		do
			name := att_name
			operator := op
			value := att_val
		end

feature -- Access

	name: STRING

	operator: QUERY_PART

	value: G

feature -- Basic operations

	output: STRING
			-- String representation of `Current'.
		do
			create Result.make_empty
			Result.append (name)
			Result.append_character (' ')
			Result.append (operator.output)
			Result.append_character (' ')
			if value.generator.is_equal ("STRING_8") or value.generator.is_equal ("STRING_32") then
				Result.append_character ('"')
				Result.append (value.out)
				Result.append_character ('"')
			else
				Result.append (value.out)
			end
		end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
