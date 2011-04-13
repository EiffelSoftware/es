note
	description: "Summary description for {TEST_PREC_B}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_PREC_B

inherit
	TEST_PREC_A
		redefine make end

create
	make

feature {NONE} -- Initialization

	make
		do
			check make_a_called = false end
			check make_b_called = false end
			Precursor
			check make_a_called = true end
			check make_b_called = false end
			make_b_called := true
		end

feature -- Access

	make_b_called: BOOLEAN

end
