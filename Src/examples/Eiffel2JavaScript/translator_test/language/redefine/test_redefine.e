class
	TEST_REDEFINE

inherit
	TEST

create
	make

feature {NONE} -- Initialization

	make
		do
			invoke_test ("1", agent
				local
					b: TEST_RED_B
					a: TEST_RED_A
					r: STRING
				do
					create b.make
					a := b
					r := b.f
					r := r + "," + a.f

					assert (r.is_equal("B.f,B.f"))

					assert (a.g = 2)
					assert (b.g = 2)
				end
			)
		end
end
