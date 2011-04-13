note
	description: "Summary description for {TEST_PREC_A}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_PREC_A

create
	make

feature {NONE} -- Initialization

	make
		do
			check make_a_called = false end
			make_a_called := true
		end


feature -- Access

	make_a_called: BOOLEAN

end
