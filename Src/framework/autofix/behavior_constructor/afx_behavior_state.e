note
	description: "Summary description for {AFX_BEHAVIOR_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BEHAVIOR_STATE

inherit

    SHARED_TYPES

create
    make

feature -- initialize

	make (a_previous: like previous_state; a_last_transition: like last_transition; a_last_operands: like last_operands;
					a_heap: DS_HASH_TABLE [DS_HASH_TABLE[AFX_BOOLEAN_STATE, STRING], INTEGER])
			-- initialize
		do
		    previous_state := a_previous
		    last_transition := a_last_transition
		    last_operands := a_last_operands

			mock_heap := a_heap
			create candidate_configurations.make_default

				-- track the steps taken to reach this state
		    if previous_state = Void then
		        steps := 0
		    else
		        steps := previous_state.steps + 1
		    end
		ensure
		    starting_state_or_complete_information:
		    		is_starting_state implies (previous_state = Void and last_transition = Void and last_operands = Void)
		    		and not is_starting_state implies (previous_state /= Void and last_transition /= Void and last_operands /= Void)
		end

feature -- access

	previous_state: detachable like Current
			-- previous behavior state

	last_transition: detachable AFX_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY
			-- the transition by which the system transited from `previous_state' to current state

	last_operands: detachable DS_ARRAYED_LIST[STRING]
			-- the operands for `last_transition'

	mock_heap: DS_HASH_TABLE [DS_HASH_TABLE[AFX_BOOLEAN_STATE, STRING], INTEGER]
			-- mock heap.
			-- `class_id' as first key and variable name as second.

	steps: INTEGER
			-- how many step did it take to reach this state?

feature -- status report

	is_starting_state: BOOLEAN
			-- is current state the starting state?
		do
		    Result := previous_state = Void
		end

	is_conforming_to (a_dest_condition: DS_HASH_TABLE [AFX_BOOLEAN_STATE, STRING]): BOOLEAN
			-- is current state conforming to the boolean condition `a_dest_condition'?
		local
		    l_class: CLASS_C
		    l_state: AFX_BOOLEAN_STATE
		    l_name: STRING
		do
		    Result := True

				-- check each condition clause in `a_dest_condition' to see if it is satisfied
		    from a_dest_condition.start
		    until a_dest_condition.after or not Result
		    loop
		        l_state := a_dest_condition.item_for_iteration
		        l_class := l_state.class_
		        l_name := a_dest_condition.key_for_iteration
		        if attached mock_heap.item (l_class.class_id) as l_table and then attached l_table.item (l_name) as l_boolean_state then
		        	Result := l_boolean_state.is_conforming_to (l_state)
		        else
		            Result := False
		        end
		        a_dest_condition.forth
		    end
		end

feature -- call sequence synthesis

	find_possible_configurations (a_feature_call: like last_transition)
			-- find all possible operand configurations for `a_feature_call' in `Current' behavior state
			-- put all possibilities into `candidate_configurations'
			--
			-- pay attention to the "return values"
		require
		    feature_not_void: a_feature_call /= Void
		local
		    l_options: DS_ARRAYED_LIST[DS_HASH_SET[STRING]]
		do
		    candidate_configurations.wipe_out
		    candidate_feature_call := a_feature_call

		    l_options := find_suitable_objects_for_each_operand (a_feature_call)

		    	-- generate all possible combinations for the operands
		    if not l_options.is_empty and then l_options.count = a_feature_call.count then
				candidate_configurations_from_possibilities (l_options)
		    end

		end

	is_executable (a_transition: like last_transition): BOOLEAN
			-- is `a_transition' executable?
			-- the test should happen AFTER `find_possible_configurations' is called
		do
		    Result := candidate_feature_call = a_transition
		    		and then not candidate_configurations.is_empty
		end

	execute (a_transition: like last_transition): DS_ARRAYED_LIST [like Current]
			-- execute a transition from current state
			-- return all possible resulting states, since there might be different choices for operand combinations
		require
		    transition_executable: is_executable (a_transition)
		local
		    l_configs: like candidate_configurations
		    l_conf: DS_ARRAYED_LIST[STRING]
		    l_result_state: like Current
		do
		    l_configs := candidate_configurations
			create Result.make (l_configs.count)

			from l_configs.start
			until l_configs.after
			loop
			    l_conf := l_configs.item_for_iteration
			    l_result_state := execute_with_configuration (a_transition, l_conf)
			    Result.force_last (l_result_state)

			    l_configs.forth
			end
		end

	to_call_sequence: DS_ARRAYED_LIST[STRING]
			-- represent in array of strings the call sequence leading to `Current' state
		local
		    l_pre_sequence: DS_ARRAYED_LIST[STRING]
		    l_feature_call: STRING
		do
		    if is_starting_state then
		        create Result.make_default
		    else
		        check previous_state /= Void and then last_transition /= Void and then last_operands /= Void end
		        l_pre_sequence := previous_state.to_call_sequence
		        l_feature_call := to_feature_call
		        l_pre_sequence.force_last (l_feature_call)
		        Result := l_pre_sequence
		    end
		end

feature{NONE} -- call sequence synthesis implementation

	candidate_feature_call: attached like last_transition
			-- the feature call that would be tried on current state

	candidate_configurations: DS_ARRAYED_LIST[DS_ARRAYED_LIST[STRING]]
			-- possible operand configurations for `candidate_feature_call'

	find_suitable_objects_for_each_operand (a_feature_call: like last_transition): DS_ARRAYED_LIST[DS_HASH_SET[STRING]]
			-- find all suitable objects for each operand of `a_feature_call'
		require
		    feature_not_void: a_feature_call /= Void
		local
		    l_options: DS_ARRAYED_LIST[DS_HASH_SET[STRING]]
		    l_is_feasible: BOOLEAN
		    l_state_summary: AFX_BOOLEAN_STATE_TRANSITION_SUMMARY
		    l_tbl: DS_HASH_TABLE[AFX_BOOLEAN_STATE, STRING]
		    l_state: AFX_BOOLEAN_STATE
		    l_name: STRING
		    l_class: CLASS_C
		    l_var_set: DS_HASH_SET[STRING]
		do
		    create l_options.make (a_feature_call.count)
		    l_is_feasible := True

		    from a_feature_call.start
		    until a_feature_call.after or not l_is_feasible
		    loop
		        l_state_summary := a_feature_call.item_for_iteration
		        l_class := l_state_summary.class_

		        	-- collect satisfactory objects into a set
		        create l_var_set.make_default
		        if mock_heap.has (l_class.class_id) then
		            l_tbl := mock_heap.item (l_class.class_id)
		            check l_tbl /= Void end
		            from l_tbl.start
		            until l_tbl.after
		            loop
		                l_state := l_tbl.item_for_iteration
		                l_name := l_tbl.key_for_iteration
						if l_state.is_suitable_as_source (l_state_summary) then
						    	-- if `l_state' can be used as input to `a_feature_call', whose requirement is available in `l_state_summary'
							l_var_set.force (l_name)
						end

		                l_tbl.forth
		            end
		        end

		        if l_var_set.is_empty then
		            	-- no conforming operands
		            l_is_feasible := False
		        else
		            l_options.force_last (l_var_set)
		        end

		        a_feature_call.forth
		    end

		    if not l_is_feasible then
		        	-- return empty list while not feasible
		        l_options.wipe_out
		    end

		    Result := l_options
		end

	candidate_configurations_from_possibilities (a_possibilities: DS_ARRAYED_LIST[DS_HASH_SET[STRING]])
			-- generate all possible combinations for operands, put them into `candidate_configurations'
		require
		    candidate_feature_call_attached: candidate_feature_call /= Void
		    candidate_configurations_empty: candidate_configurations.is_empty
		local
		    l_opt_num, l_cur_rep, l_repetition, l_loop, l_loop_index: INTEGER
		    l_size, l_num, l_total_num: INTEGER
		    l_set: DS_HASH_SET[STRING]
		    l_list: DS_ARRAYED_LIST[STRING]
		    l_conf: like candidate_configurations
		    l_name: STRING
		do
		    	-- compute the total number of combinations
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
			l_conf := candidate_configurations
		    l_conf.resize (l_total_num)
		    l_size := a_possibilities.count
		    from l_num := 1
		    until l_num > l_total_num
		    loop
		        create l_list.make (l_size)
		        l_conf.force_last (l_list)
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

					-- starting from the first combination, we fill the corresponding position of this operand in all combinations.
					-- each possible value appears consecutively in `l_repetition' combinations,
					-- the whole set of possible values therefore need to be traversed from the beginning to the end for `l_loop' times.

		        l_conf.start
					-- the whole operand set need to be iterated for `l_loop' number of times
		        from l_loop_index := 0
		        until l_loop_index = l_loop
		        loop
		            	-- iterate through the possibilities for current feature operand
    		        from l_set.start
    		        until l_set.after
    		        loop
    		            l_name := l_set.item_for_iteration

							-- consecutive appearance of each object in adjacent combinations
    		        	from l_cur_rep := 0
    		        	until l_cur_rep = l_repetition
    		        	loop
        		            l_list := l_conf.item_for_iteration
        		            l_list.force_last (l_name)
        		            l_conf.forth
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

feature{NONE} -- execution implementation

	execute_with_configuration (a_transition: like last_transition; a_conf: DS_ARRAYED_LIST[STRING]): like Current
			-- execute `a_transition' from current state with operand configuration `a_conf'
			-- return the result state
		require
		    same_size: a_transition.count = a_conf.count
		local
		    l_heap: like mock_heap
		    l_state_summary: AFX_BOOLEAN_STATE_TRANSITION_SUMMARY
		    l_name: STRING
		    l_class: CLASS_C
		    l_table: detachable DS_HASH_TABLE[AFX_BOOLEAN_STATE, STRING]
		    l_src: detachable AFX_BOOLEAN_STATE
		    l_dest: AFX_BOOLEAN_STATE
		do
		    l_heap := mock_heap.twin

		    from
		        a_transition.start
		        a_conf.start
		    until
		        a_conf.after
		    loop
		        	-- summary-for-operand for iteration
		        l_state_summary := a_transition.item_for_iteration

		        	-- state for iteration
		        l_class := l_state_summary.class_
		        l_name := a_conf.item_for_iteration
		        l_table := l_heap.item (l_class.class_id)
		        check l_table /= Void end
		        l_src := l_table.item (l_name)
		        check l_src /= Void end

					-- construct boolean state of object `l_name' after transition
		        create l_dest.make_for_class (l_class)

		        	-- all true properties
		        l_dest.properties_true := l_state_summary.post_set_true | (l_src.properties_false & l_state_summary.post_negated)
		        				| (l_src.properties_true & l_state_summary.post_unchanged)

		        	-- all false properties
		        l_dest.properties_false := l_state_summary.post_set_false | (l_src.properties_true & l_state_summary.post_negated)
		        				| (l_src.properties_false & l_state_summary.post_unchanged)

				check (l_dest.properties_false & l_dest.properties_true).count_of_set_bits = 0 end
				
		        	-- all other properties remain unknown
		        l_dest.properties_random := l_dest.properties_random.bit_not.set_minus (l_dest.properties_false | l_dest.properties_true)

		        	-- update local heap
		        l_table.put (l_dest, l_name)

					-- continue with other operands
		        a_transition.forth
		        a_conf.forth
		    end

	        create Result.make (Current, a_transition, a_conf, l_heap)
		end

feature{NONE} -- call sequence output implementation

	to_feature_call: STRING
			-- construct the string representation of last feature call, i.e. via `last_transition' and `last_operands'
		local
		    l_str: STRING
		    l_feature: FEATURE_I
		do
		    l_feature := last_transition.feature_
		    check l_feature.type = void_type end

		    	-- target object
		    last_operands.start
		    l_str := last_operands.item_for_iteration.twin
		    last_operands.forth

		    	-- ".feature_name ("
		    l_str.append_character ('.')
		    l_str.append (l_feature.feature_name)

		    if l_feature.argument_count /= 0 then
    		    check not last_operands.after end

    		    l_str.append (" (")
    		    l_str.append (last_operands.item_for_iteration.twin)

    		    from last_operands.forth
    		    until last_operands.after
    		    loop
    		    	l_str.append (", ")
    		    	l_str.append (last_operands.item_for_iteration.twin)
    		    	last_operands.forth
    		    end

    		    l_str.append_character (')')
    		else
    		    check last_operands.count = 1 end
		    end

		    Result := l_str
		end

end
