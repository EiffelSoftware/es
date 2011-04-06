class
	TEST_INVARIANT

inherit
	TEST

create
	make

feature {NONE} -- Initialization

	make
			-- This test has inside knowledge about how generating invariant checks works
		do
			invoke_test ("1", agent
				local
					t: TEST_INV_A
				do
					create {TEST_INV_B}t.make (-0.001)
					assert (t.invariant_from_a_count=4)
					assert (t.invariant_from_b_count=6)
					t.do_something_on_value
					assert (t.invariant_from_a_count=12)
					assert (t.invariant_from_b_count=14)
				end
			)
			invoke_test ("2", agent
				local
					t: TEST_INV_A
				do
					create {TEST_INV_B}t.make (-5)
					assert (t.invariant_from_a_count=4)
					assert (t.invariant_from_b_count=6)
					t.do_something_on_value
					assert (t.invariant_from_a_count=12)
					assert (t.invariant_from_b_count=14)
				end
			)
			invoke_test ("3", agent
				local
					t: TEST_INV_A
				do
					create {TEST_INV_B}t.make (5)
					assert (t.invariant_from_a_count=4)
					assert (t.invariant_from_b_count=6)
					t.do_something_on_value
					assert (t.invariant_from_a_count=12)
					assert (t.invariant_from_b_count=14)
					t.self.do_something_on_value
					assert (t.invariant_from_a_count=22)
					assert (t.invariant_from_b_count=24)
					t.self.self.do_something_on_value
					assert (t.invariant_from_a_count=34)
					assert (t.invariant_from_b_count=36)
				end
			)
			invoke_test ("4", agent
				local
					t: TEST_INV_A
				do
					create t.make (5)
					assert (t.invariant_from_a_count=4)
					assert (t.invariant_from_b_count=0)
					t.do_something_on_value
					assert (t.invariant_from_a_count=12)
					assert (t.invariant_from_b_count=0)
					t.self.do_something_on_value
					assert (t.invariant_from_a_count=22)
					assert (t.invariant_from_b_count=0)
					t.self.self.do_something_on_value
					assert (t.invariant_from_a_count=34)
					assert (t.invariant_from_b_count=0)
				end
			)
		end

end
