class
	TEST_SET

inherit
	TEST

create
	make

feature {NONE} -- Initialization

	make
		do
			invoke_test ("1", agent
				local
					l_set: SET[attached STRING]
				do
					create {LINKED_SET[attached STRING]}l_set.make
					assert (l_set.is_empty)

					l_set.extend ("foo")
					assert (not l_set.is_empty)

					assert (l_set.has ("foo"))
					assert (l_set.count = 1)

					l_set.prune ("foo")
					assert (l_set.is_empty)
					assert (not l_set.has ("foo"))
					assert (l_set.count = 0)
				end
			)
		end
end
