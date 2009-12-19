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
		    l_enumeration_list: like last_enumeration_list
		    l_item: G
		do
		    	-- Reset the result buffer.
		    	-- since the reference may be shared with other, we don't `wipe_out', we create a new one instead
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

				-- initialize the 2-D storage for all candidate configurations
		    l_enumeration_list.resize (l_total_num)
		    	-- each enumeration contains one value for each position
		    l_size := a_possibilities.count
		    from l_num := 1
		    until l_num > l_total_num
		    loop
		        create l_list.make (l_size)
		        l_enumeration_list.force_last (l_list)
		        l_num := l_num + 1
		    end

		    -- generating all possible combinations
		    	-- loop through each feature operand
		    from
		        a_possibilities.start
		        l_repetition := 1
		    until
		        a_possibilities.after
		    loop
		        l_set := a_possibilities.item_for_iteration
		        l_opt_num := l_set.count
		        l_loop := l_total_num // (l_opt_num * l_repetition)

					-- starting from the first combination, we fill the corresponding position in all combinations.
					-- each possible value appears consecutively in `l_repetition' combinations,
					-- the whole set of possible values therefore need to be traversed from the beginning to the end for `l_loop' times.

		        l_enumeration_list.start
					-- the whole operand set need to be iterated for `l_loop' number of times
		        from l_loop_index := 0
		        until l_loop_index = l_loop
		        loop
		            	-- iterate through the possibilities for current position
    		        from l_set.start
    		        until l_set.after
    		        loop
    		            l_item := l_set.item_for_iteration

							-- consecutive appearance of each object in adjacent combinations
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
		    sets_not_empty: a_possibilities.for_all (agent (a_set: DS_HASH_SET[G]): BOOLEAN do Result := not a_set.is_empty end)
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

			last_enumeration_list := l_enumeration_list
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
