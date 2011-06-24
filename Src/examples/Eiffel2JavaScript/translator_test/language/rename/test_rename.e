class
	TEST_RENAME

inherit
	TEST

create
	make

feature {NONE} -- Initialization

	make
		do
			invoke_test ("1", agent
				local
					a: TEST_REN_A
					b: TEST_REN_B
					c: TEST_REN_C
				do
					create b.make
					a := b

					a.output.wipe_out
					a.foo
					assert_list_is (a.output, << "A.foo", "B.unk" >>)

					a.output.wipe_out
					a.bar
					assert_list_is (a.output, << "A.bar", "B.unk", "B.bar" >>)

					b.output.wipe_out
					b.foo
					assert_list_is (b.output, << "B.foo" >>)

					b.output.wipe_out
					b.foo_a
					assert_list_is (b.output, << "A.foo", "B.unk" >>)

					b.output.wipe_out
					b.bar
					assert_list_is (b.output, << "A.bar", "B.unk", "B.bar" >>)

					--------------------
					create c.make
					b := c
					a := c

					a.output.wipe_out
					a.foo
					assert_list_is (a.output, << "A.foo", "C.unk" >>)

					a.output.wipe_out
					a.bar
					assert_list_is (a.output, << "A.bar", "C.unk", "B.bar", "C.bar" >>)

					b.output.wipe_out
					b.foo
					assert_list_is (b.output, << "B.foo" >>)

					b.output.wipe_out
					b.foo_a
					assert_list_is (b.output, << "A.foo", "C.unk" >>)

					b.output.wipe_out
					b.bar
					assert_list_is (b.output, << "A.bar", "C.unk", "B.bar", "C.bar" >>)

					c.output.wipe_out
					c.foo
					assert_list_is (c.output, << "C.foo" >>)

					c.output.wipe_out
					c.foo_a
					assert_list_is (c.output, << "A.foo", "C.unk" >>)

					c.output.wipe_out
					c.foo_b
					assert_list_is (c.output, << "B.foo" >>)

					c.output.wipe_out
					c.bar
					assert_list_is (c.output, << "A.bar", "C.unk", "B.bar", "C.bar" >>)

				end
			)
			invoke_test ("2", agent
				local
					a: TEST2_REN_A
					b: TEST2_REN_B
					c: TEST2_REN_C
				do
					create c
					assert (c.foo.is_equal("C"))

					b := c
					assert (b.foo.is_equal("C"))

					a := b
					assert (a.bar.is_equal("C"))
				end
			)
			invoke_test ("3", agent
				local
					a: TEST3_REN_A
					b: TEST3_REN_B
					r: STRING
				do
					create b
					a := b
					r := b.f
					r := r + "," + b.af
					r := r + "," + a.f

					assert (r.is_equal("B.f,A.f,A.f"))
				end
			)
		end

feature {NONE} -- Implementation

	assert_list_is (l: attached LIST[attached STRING]; arr: attached ARRAY[attached STRING])
		local
			i: INTEGER
		do
			assert (l.count = arr.count)
			from
				i := 1
			until
				i > l.count
			loop
				assert (l[i].is_equal (arr[i]))
				i := i + 1
			end
		end

end
