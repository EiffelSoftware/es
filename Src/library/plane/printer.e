note
	description: "Summary description for {PRINTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PRINTER

create
	make

feature
	make
		do
			create context.make_empty
			level := 0
		end

	indent
		do
			level := level + 2
		end

	unindent
		do
			level := level - 2
		end

	add_nl (s: STRING)
		do
			add (s)
			newline
		end

	add (s: STRING)
		do
			context := context + s
		end

	newline
		do
			add ("%N")
			add_indent
		end

	space
		do
			add (" ")
		end

feature
	add_indent
		local
			spaces : STRING
		do
			create spaces.make_filled (' ', level)
			context := context + spaces
		end

	level: INTEGER
	context: STRING

end
