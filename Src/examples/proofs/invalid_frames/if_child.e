indexing
	description: "Summary description for {IF_CHILD}."
	date: "$Date$"
	revision: "$Revision$"

class
	IF_CHILD

inherit
	IF_PARENT
		redefine
			foo
		end

create
	make

feature

	foo (arg: INTEGER)
		do
			field1 := arg
			field2 := arg + 1
		ensure then
			field2 = arg + 1
		end

end
