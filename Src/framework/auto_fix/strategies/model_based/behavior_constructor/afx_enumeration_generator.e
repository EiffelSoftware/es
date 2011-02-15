note
	description: "Summary description for {AFX_ENUMERATION_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_ENUMERATION_GENERATOR [G->HASHABLE]

create
    default_create

feature -- Access

	last_enumeration_list: DS_ARRAYED_LIST[DS_ARRAYED_LIST[G]]
			-- List of all possible enumerations.

feature -- Enumerate

	enumerate_fully (a_possibilities: DS_ARRAYED_LIST[DS_HASH_SET[G]] )
			-- Generate all the enumerations, given a list of positions, and a set of possibilities for each position, i.e. C(n,n).
			-- Save the result in `last_enumeration_list'.
		require
		    possibilities_not_empty: not a_possibilities.is_empty
		    sets_not_empty: a_possibilities.for_all (agent (a_set: DS_HASH_SET[G]): BOOLEAN do Result := not a_set.is_empty end)
		local
		    l_opt_num, l_cur_rep, l_repetition, l_loop, l_loop_index: INTEGER
		    l_size, l_num, l_total_num: INTEGER
		    l_set: DS_HASH_SET[G]
		    l_list: DS_ARRAYED_LIST[G]
		    l_found: BOOLEAN
		    l_enumeration_list: like last_enumeration_list
		    l_item: G
		do
		    	-- Reset the result buffer.
		    	-- Since the reference may be shared with other, we don't `wipe_out', we create a new one instead
		    create last_enumeration_list.make_default
			l_enumeration_list := last_enumeration_list

		    	-- Compute the total number of combinations
		    l_total_num := 1
		    from a_possibilities.start
		    until a_possibilities.after
		    loop
		        l_set := a_possibilities.item_for_iteration
		        check l_set.count /= 0 end
		        l_total_num := l_total_num * l_set.count

		        a_possibilities.forth
		    end

				-- Initialize the 2-D storage for all candidate configurations.
		    l_enumeration_list.resize (l_total_num)
		    	-- Each enumeration contains one value for each position.
		    l_size := a_possibilities.count
		    from l_num := 1
		    until l_num > l_total_num
		    loop
		        create l_list.make (l_size)
		        l_enumeration_list.force_last (l_list)
		        l_num := l_num + 1
		    end

		    -- Generate all possible combinations.

		    	-- Loop through all the positions.
		    from
		        a_possibilities.start
		        l_repetition := 1
		    until
		        a_possibilities.after
		    loop
		        l_set := a_possibilities.item_for_iteration
		        l_opt_num := l_set.count
		        l_loop := l_total_num // (l_opt_num * l_repetition)

					-- Starting from the first combination, we fill the corresponding position in all combinations.
					-- Each possible value appears consecutively in `l_repetition' combinations,
					-- 		the whole set of possible values therefore need to be traversed from the beginning to the end for `l_loop' times.

		        l_enumeration_list.start
					-- The whole operand set need to be iterated for `l_loop' number of times.
		        from l_loop_index := 0
		        until l_loop_index = l_loop
		        loop
		            	-- Iterate through the possibilities for current position.
    		        from l_set.start
    		        until l_set.after
    		        loop
    		            l_item := l_set.item_for_iteration

							-- Consecutive appearance of each object in adjacent combinations.
    		        	from l_cur_rep := 0
    		        	until l_cur_rep = l_repetition
    		        	loop
        		            l_list := l_enumeration_list.item_for_iteration

           		            l_list.force_last (l_item)

        		            l_enumeration_list.forth
        		            l_cur_rep := l_cur_rep + 1
        		        end
    		            l_set.forth
    		        end
    		        l_loop_index := l_loop_index + 1
		        end

				l_repetition := l_repetition * l_opt_num
		        a_possibilities.forth
		    end
		end

	enumerate_all_partial (a_possibilities: DS_ARRAYED_LIST[DS_HASH_SET[G]])
			-- Generate all the m-enumerations for the n-positions,
			-- given a list of n-positions and a set of possibilities for each position, i.e. C(m,n) (1 <= m <= n)
			-- Save the result in `last_enumeration_list'.
		require
		    possibilities_not_empty: not a_possibilities.is_empty
--		    sets_not_empty: a_possibilities.for_all (agent (a_set: DS_HASH_SET[G]): BOOLEAN do Result := not a_set.is_empty end)
		local
		    l_enumeration_list: like last_enumeration_list
			l_total_count, l_partial_count, l_index: INTEGER
			l_possible_combinations: like possible_combinations
			l_picked_positions: DS_ARRAYED_LIST[DS_HASH_SET[G]]
		    l_possibilities: DS_ARRAYED_LIST [AFX_STATE_TRANSITION_SUMMARY]
		    l_summary: AFX_STATE_TRANSITION_SUMMARY
			l_bit_vector: AFX_BIT_VECTOR
		do
		    create l_enumeration_list.make_default

		    if a_possibilities.for_all (agent (a_set: DS_HASH_SET[G]): BOOLEAN do Result := not a_set.is_empty end) then
				l_total_count := a_possibilities.count

				from l_partial_count := 1
				until l_partial_count = l_total_count + 1
				loop
				    generate_combination (l_partial_count, l_total_count)
				    l_possible_combinations := possible_combinations

				    from l_possible_combinations.start
				    until l_possible_combinations.after
				    loop
				        l_bit_vector := l_possible_combinations.item_for_iteration
				        create l_picked_positions.make (l_bit_vector.count_of_set_bits)

				        from l_index := 0
				        until l_index = l_total_count
				        loop
				            if l_bit_vector.is_bit_set (l_index) then
				                	-- index of bit vector starts from 0, while arrayed list from 1
				                l_picked_positions.force_last (a_possibilities.item (l_index + 1))
				            end
				            l_index := l_index + 1
				        end
				        check l_picked_positions.count = l_partial_count end

							-- generate partial enumeration and save the result into local enumeration list
						enumerate_fully (l_picked_positions)
						l_enumeration_list.append_last (last_enumeration_list)

				        l_possible_combinations.forth
				    end

				    l_partial_count := l_partial_count + 1
				end
		    end

			last_enumeration_list := l_enumeration_list
		end

--	remove_combinations_with_duplicates
--			-- Remove the combinations containing duplicate items (possibly at different positions)
--		local
--		    l_generations: like last_enumeration_list
--		    l_index1, l_index2: INTEGER
--		    l_gen: DS_ARRAYED_LIST [G]
--		    l_val1, l_val2: G
--		    l_found: BOOLEAN
--		do
--			l_generations := last_enumeration_list
--			from l_generations.start
--			until l_generations.after
--			loop
--			    l_gen := l_generations.item_for_iteration

--			    from
--			    	l_index1 := 1
--			    	l_found := False
--			    until l_index1 > l_gen.count
--			    loop
--			        from l_index2 := 1
--			        until l_index2 > l_gen.count
--			        loop
--			            if l_gen.item(l_index1) ~ l_gen.item(l_index2) then
--			                l_found := True
--			            end
--			            l_index2 := l_index2 + 1
--			        end
--			        l_index1 := l_index1 + 1
--			    end

--			    l_generations.forth
--			end
--		end

	is_same_combination (a_com1, a_com2: DS_ARRAYED_LIST[G]): BOOLEAN
			-- Is `a_com1' the same as `a_com2'?
		local
		do
		    if a_com1.count /= a_com2.count then
		        Result := False
		    else
		        Result := True
		        from
		            a_com1.start
		            a_com2.start
		        until
		            a_com1.after or not Result
		        loop
		            if a_com1.item_for_iteration /~ a_com2.item_for_iteration then
		                Result := False
		            end
		            a_com1.forth
		            a_com2.forth
		        end
		    end
		end

	is_combination_with_duplication (a_combination: DS_ARRAYED_LIST[G]): BOOLEAN
			-- Is `a_combination' containing duplication?
		require
		    combination_not_empty: not a_combination.is_empty
		local
		    l_index1, l_index2: INTEGER
		    l_val1, l_val2: G
		    l_found: BOOLEAN
		    l_count: INTEGER
		do
		    from
		    	l_index1 := 1
		    	l_count := a_combination.count
		    	l_found := False
		    until l_index1 > l_count
		    loop
		        from l_index2 := l_index1 + 1
		        until l_index2 > l_count
		        loop
		            if a_combination.item(l_index1) ~ a_combination.item(l_index2) then
		                l_found := True
		            end
		            l_index2 := l_index2 + 1
		        end
		        l_index1 := l_index1 + 1
		    end
		    Result := l_found
		end

	remove_duplications
			-- Remove duplications.
		local
		    l_com1, l_com2: DS_ARRAYED_LIST [G]
		    l_found: BOOLEAN
		    l_result, l_list: like last_enumeration_list
		do
			l_list := last_enumeration_list
			create l_result.make (l_list.count)

			from l_list.start
			until l_list.after
			loop
			    l_com1 := l_list.item_for_iteration
			    if not is_combination_with_duplication (l_com1) then
			        l_found := False
			        from l_result.start
			        until l_result.after or l_found
			        loop
			            if is_same_combination (l_com1, l_result.item_for_iteration) then
			                l_found := True
			            end
			            l_result.forth
			        end

			        if not l_found then
			            l_result.force_last (l_com1)
			        end
			    end
			    l_list.forth
			end

			last_enumeration_list := l_result
		end

feature{NONE} -- Implementation

	possible_combinations: DS_ARRAYED_LIST [AFX_BIT_VECTOR]
			-- Storage for all combinations.

	generate_combination (m, n: INTEGER)
			-- Generate all the `m'-combinations from `n' elements, put the result into `possible_combinations'.
			-- Algorithm: use an array of length `n' to represent `n' elements, 1 for selected and 0 for not.
			-- 1. starting with all `m' elements selected from left, i.e. `m' 1s on the left of array,
			-- 2. repeatedly change an '10' to '01'. each change results in a new combination.
			-- 3. when no '10' can be found, we have found all the combinations
		require
		    m_not_greater_than_n: m <= n
		local
		    l_array: ARRAY[INTEGER]
		    l_index: INTEGER
		    l_have_more: BOOLEAN
		    l_bit_vector: AFX_BIT_VECTOR
		    l_possible_combinations: like possible_combinations
		do
			if possible_combinations /= Void then
		    	possible_combinations.wipe_out
		    else
		        create possible_combinations.make_default
			end
		    l_possible_combinations := possible_combinations

		    create l_array.make (0, n-1)

		    	-- step 1
		    from l_index := 0
		    until l_index = m
		    loop
		        l_array[l_index] := 1
		        l_index := l_index + 1
		    end

				-- save initial combination
		    l_bit_vector := bit_vector_from_array (l_array)
		    l_possible_combinations.force_last (l_bit_vector)

		    	-- repeat until we find no '10' in the array
		    from l_have_more := True
		    until not l_have_more
		    loop
		    	l_have_more := False
				from l_index := 0
				until l_index = n - 1 or l_have_more
				loop
				    if l_array [l_index] = 1 and then l_array[l_index + 1] = 0 then
				        	-- change '10' to '01' and we have a new combination
				        l_array[l_index] := 0
				        l_array[l_index + 1] := 1
				        l_have_more := True
				    end
				    l_index := l_index + 1
				end

				if l_have_more then
				    	-- save this combination
        		    l_bit_vector := bit_vector_from_array (l_array)
        		    l_possible_combinations.force_last (l_bit_vector)
				end
		    end
		end

	bit_vector_from_array (an_array: ARRAY[INTEGER]): AFX_BIT_VECTOR
			-- Generate a bit vector from `an_array' of 0/1.
		local
		    l_index, l_count, l_index_lower: INTEGER
		do
		    l_count := an_array.count
		    create Result.make (l_count)

		    from
		    	l_index := 0
		    	l_index_lower := an_array.index_set.lower
		    until
		    	l_index = l_count
		    loop
		        if an_array[l_index_lower + l_index] = 1 then
		            Result.set_bit (l_index)
		        end
		        l_index := l_index + 1
		    end
		end



end
