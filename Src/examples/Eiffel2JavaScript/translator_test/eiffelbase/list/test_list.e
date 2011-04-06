class
	TEST_LIST

inherit
	TEST

create
	make

feature {NONE} -- Initialization

	make
		do
			invoke_test ("1", agent
				local
					l_list: LIST[INTEGER]
					ll: LINKED_LIST[INTEGER]
				do
					create {LINKED_LIST[INTEGER]}l_list.make
					assert (l_list.count = 0)

					create {ARRAYED_LIST[INTEGER]}l_list.make(0)
					assert (l_list.count = 0)

					create {LINKED_LIST[INTEGER]}l_list.make
					assert (l_list.count = 0)

					l_list.extend (4)
					assert (l_list.count = 1)
					assert (l_list.at (1) = 4)

					l_list[1] := 1
					l_list[2] := 2
					assert_list_is (l_list, << 1, 2 >>)

					l_list[3] := 3
					l_list[4] := 4
					assert_list_is (l_list, << 1, 2, 3, 4 >>)

					l_list.start
					assert (l_list.item = 1)

					l_list.forth
					assert (l_list.item = 2)

					l_list.forth
					assert (l_list.item = 3)

					l_list.forth
					assert (l_list.item = 4)

					l_list.forth
					assert (l_list.after)

					l_list.finish
					assert (l_list.item = 4)

					l_list.back
					assert (l_list.item = 3)

					l_list.back
					assert (l_list.item = 2)

					l_list.forth
					assert (l_list.item = 3)

					l_list.back
					assert (l_list.item = 2)

					l_list.back
					assert (l_list.item = 1)

					l_list.back
					assert (l_list.before)

					assert (l_list[2] = 2)

					l_list.go_i_th (2)
					assert (l_list.item = 2)

					l_list.remove
					assert_list_is (l_list, << 1, 3, 4 >>)

					l_list.go_i_th (2)
					assert (l_list.item = 3)

					ll ?= l_list
					check ll /= Void end
					ll.put_left (2)
					assert_list_is (l_list, << 1, 2, 3, 4 >>)

					ll.go_i_th (2)
					assert (l_list.item = 2)

					ll.put_right (2)
					assert_list_is (l_list, << 1, 2, 2, 3, 4 >>)

					ll.go_i_th (2)
					ll.remove_left
					assert_list_is (l_list, << 2, 2, 3, 4 >>)

					ll.go_i_th (1)
					assert (l_list.item = 2)

					ll[1] := 1
					assert (l_list.item = 1)

					assert_list_is (l_list, << 1, 2, 3, 4 >>)

					assert (l_list.index_of (2, 1) = 2)
					assert (l_list.index_of (2, 2) = 2)
					assert (l_list.index_of (2, 3) = 0)

					l_list.go_i_th (2)
					l_list.replace (5)
					assert_list_is (l_list, << 1, 5, 3, 4 >>)

					ll.put_front (1)
					assert_list_is (l_list, << 1, 1, 5, 3, 4 >>)

					assert (l_list.has (1))
					assert (l_list.has (5))
					assert (l_list.has (3))
					assert (l_list.has (4))
					assert (not l_list.has (2))
					assert (not l_list.has (0))

					assert (l_list.is_empty = false)

					l_list.wipe_out
					assert (l_list.is_empty = true)
					assert_list_is (l_list, <<>>)
				end
			)
		end

feature {NONE} -- Implementation

	assert_list_is (l: attached LIST[INTEGER]; arr: attached ARRAY[INTEGER])
		local
			i: INTEGER
		do
			assert (l.count = arr.count)
			from
				i := 1
			until
				i > l.count
			loop
				assert (l[i] = arr[i])
				i := i + 1
			end
		end

end
