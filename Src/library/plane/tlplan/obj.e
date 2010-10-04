note
	description: "Summary description for {OBJ}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	OBJ

inherit
	PRINTABLE

create
	make

feature
	make (a_name: STRING; a_type : STRING)
		do
			name := a_name
			type := a_type
		end

	name : STRING
	type : STRING

	to_printer (p : PRINTER)
		do
			p.add (name + " - " + type)
		end

end
