indexing
	description	: "Class X"
	author		: "Volkan Arslan, Yann Mueller, Piotr Nienaltowski."
	date		: "$Date: 28.05.2007$"
	revision	: "1.0.0"


class
	X

create
	make

feature

	make is
			-- Creation
		do
			b := true
			create e
			e.set_i (5)
		end

	b: BOOLEAN

	e: E

	f (i: INTEGER) is
			-- Feature f
		do
			io.put_string ("Feature f of class X. Value of i is: ")
			print (i)
			io.new_line
		end


end
