indexing
	description: "Summary description for {IF_PARENT}."
	date: "$Date$"
	revision: "$Revision$"

class
	IF_PARENT

create
	make

feature {NONE} -- Initialization

	make
		do
			field1 := 1
			field2 := 2
		ensure
			field1 = 1
			field2 = 2
		end

feature -- Access

	field1: INTEGER

	field2: INTEGER

feature -- Element change

	foo (arg: INTEGER)
		do
			field1 := arg
		ensure
			field1 = arg
		end

end
