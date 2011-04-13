class
	TEST_PRECURSOR

inherit
	TEST

create
	make

feature {NONE} -- Initialization

	make
		do
			invoke_test ("1", agent
				local
					obj: TEST_PREC_B
				do
					create obj.make
					assert (obj.make_a_called = true)
					assert (obj.make_b_called = true)
				end
			)
		end

end
