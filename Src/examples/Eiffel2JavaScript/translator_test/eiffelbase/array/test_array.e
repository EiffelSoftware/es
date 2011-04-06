class
	TEST_ARRAY

inherit
	TEST

create
	make

feature {NONE} -- Initialization

	make
		do
			invoke_test ("1", agent
				local
					l_array: ARRAY[INTEGER]
				do
					l_array := << 4, 5, 6, 7, 8 >>
					assert (l_array.count = 5)
					assert (l_array.lower = 1)
					assert (l_array.upper = 5)
					assert (l_array.at (1) = 4)
					assert (l_array.at (2) = 5)
					assert (l_array.at (3) = 6)
					assert (l_array.at (4) = 7)
					assert (l_array.at (5) = 8)
					assert (l_array.has (4))
					assert (l_array.has (5))
					assert (l_array.has (6))
					assert (l_array.has (7))
					assert (l_array.has (8))
					assert (not l_array.has (0))
					assert (not l_array.has (1))
					assert (not l_array.has (2))
					assert (not l_array.has (3))
					assert (not l_array.has (9))
					assert (not l_array.has (10))
					assert (l_array.item (1) = 4)
					assert (l_array.item (2) = 5)
					assert (l_array.item (3) = 6)
					assert (l_array.item (4) = 7)
					assert (l_array.item (5) = 8)
					assert (l_array[1] = 4)
					assert (l_array[2] = 5)
					assert (l_array[3] = 6)
					assert (l_array[4] = 7)
					assert (l_array[5] = 8)
					assert (l_array.is_empty = false)
				end
			)
			invoke_test ("keep_head", agent
				local
					l_array: ARRAY[INTEGER]
				do
					l_array := << 4, 5, 6, 7, 8 >>
					l_array.keep_head (3)
					assert_arrays_equal( l_array, << 4, 5, 6 >>)
				end
			)
			invoke_test ("remove_head", agent
				local
					l_array: ARRAY[INTEGER]
				do
					l_array := << 4, 5, 6, 7, 8 >>
					l_array.remove_head (3)
					assert_arrays_equal( l_array, rebase(<< 7, 8 >>, 4))
				end
			)
			invoke_test ("keep_tail", agent
				local
					l_array: ARRAY[INTEGER]
				do
					l_array := << 4, 5, 6, 7, 8, 9 >>
					l_array.keep_tail (3)
					assert_arrays_equal( l_array, rebase(<< 7, 8, 9 >>, 4))
				end
			)
			invoke_test ("remove_tail", agent
				local
					l_array: ARRAY[INTEGER]
				do
					l_array := << 4, 5, 6, 7, 8, 9 >>
					l_array.remove_tail (3)
					assert_arrays_equal( l_array, rebase(<< 4, 5, 6 >>, 1))
				end
			)
			invoke_test ("subarray1", agent
				local
					l_array: ARRAY[INTEGER]
				do
					l_array := << 4, 5, 6, 7, 8, 9 >>
					l_array := l_array.subarray (3, 5)
					assert_arrays_equal( l_array, rebase(<< 6, 7, 8 >>, 3))
				end
			)
			invoke_test ("subarray2", agent
				local
					l_array: ARRAY[INTEGER]
				do
					l_array :=  rebase(<< 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 >>, 11)
					l_array := l_array.subarray (14, 20)
					assert_arrays_equal( l_array, rebase(<< 7, 8, 9, 10, 11, 12, 13 >>, 14))
				end
			)
			invoke_test ("empty", agent
				local
					l_array: ARRAY[INTEGER]
				do
					create l_array.make_empty
					assert (l_array.is_empty)
					l_array.force (9, 2)
					l_array.force (7, 1)
					assert_arrays_equal( l_array, rebase(<< 7, 9 >>, 1))
				end
			)
			invoke_test ("there_exists", agent
				local
					l_array: ARRAY[INTEGER]
					l_result: BOOLEAN
				do
					l_array := << 3, 8, 9, 1, -10, 10>>
					l_result := l_array.there_exists (agent (item: INTEGER):BOOLEAN do Result := item >= 10 end)
					assert (l_result = true)
					l_result := l_array.there_exists (agent (item: INTEGER):BOOLEAN do Result := item >= 11 end)
					assert (l_result = false)
				end
			)
			invoke_test ("do_all", agent
				local
					l_array: ARRAY[INTEGER]
				do
					l_array := << 3, 8, 9, 1, -10, 10, -138>>
					acc := 0
					l_array.do_all (agent add_to_acc1)
					assert (acc = -117)
				end
			)
			invoke_test ("do_if", agent
				local
					l_array: ARRAY[INTEGER]
				do
					l_array := << 3, 8, 9, 1, -10, 10, -138>>
					acc := 0
					l_array.do_if (agent add_to_acc1, agent (item:INTEGER):BOOLEAN do Result := item > 0 end)
					assert (acc = 31)
				end
			)
			invoke_test ("do_all_with_index", agent
				local
					l_array: ARRAY[INTEGER]
				do
					l_array := << 3, 8, 9, 1, -10, 10, -138>>
					acc := 0
					l_array.do_all_with_index (agent add_to_acc2)
					assert (acc = -89)
				end
			)
			invoke_test ("do_if_with_index", agent
				local
					l_array: ARRAY[INTEGER]
				do
					l_array := << 3, 8, 9, 1, -10, 10, -138>>
					acc := 0
					l_array.do_if_with_index (agent add_to_acc2, agent (item,index:INTEGER):BOOLEAN do Result := index \\ 2 = 0 end)
					-- 8 + 1 + 10 + 2 + 4 + 6
					assert (acc = 31)
				end
			)
		end

feature {NONE} -- Implementation

	acc: INTEGER

	add_to_acc1 (a_n: INTEGER)
		do
			acc := acc + a_n
		end

	add_to_acc2 (a_n,a_index: INTEGER)
		do
			acc := acc + a_n + a_index
		end

	rebase (arr: attached ARRAY[INTEGER]; new_lower: INTEGER): attached ARRAY[INTEGER]
		do
			arr.rebase (new_lower)
			Result := arr
		end

	assert_arrays_equal(arr1, arr2: attached ARRAY[INTEGER])
		local
			i: INTEGER
		do
			assert (arr1.lower = arr2.lower)
			assert (arr1.upper = arr2.upper)
			from i:=arr1.lower until i>arr1.upper loop
				assert (arr1[i] = arr2[i])
				i := i + 1
			end
		end

end
