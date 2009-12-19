note
	description: "Summary description for {AFX_BEHAVIOR_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BEHAVIOR_STATE

create
    make

feature -- Initialize

	make (a_previous: like previous_state; a_last_transition: like last_transition; a_last_operands: like last_operands;
					a_heap: DS_HASH_TABLE [DS_HASH_TABLE[AFX_BOOLEAN_STATE, STRING], INTEGER])
			-- Initialize.
		do
		    previous_state := a_previous
		    last_transition := a_last_transition
		    last_operands := a_last_operands
			mock_heap := a_heap

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

feature -- Access

	previous_state: detachable like Current
			-- Previous behavior state.

	last_transition: detachable AFX_STATE_TRANSITION_SUMMARY
			-- Transition by which the system transited from `previous_state' to current state.

	last_operands: detachable DS_ARRAYED_LIST[STRING]
			-- Operands for `last_transition'.

	mock_heap: DS_HASH_TABLE [DS_HASH_TABLE[AFX_BOOLEAN_STATE, STRING], INTEGER]
			-- Mock heap containing available objects on this state.
			-- `class_id' as first key and variable name as second.

	steps: INTEGER
			-- Number of steps from starting state.

feature -- Status report

	is_starting_state: BOOLEAN
			-- Is current state the starting state?
		do
		    Result := previous_state = Void
		end

	is_conforming_to (a_condition: DS_HASH_TABLE [AFX_BOOLEAN_STATE, STRING]): BOOLEAN
			-- Are the objects on `mock_heap' satisfy the boolean conditions specified by `a_condition'?
		local
		    l_class: CLASS_C
		    l_var_condition: AFX_BOOLEAN_STATE
		    l_var_name: STRING
		do
		    Result := True

				-- check each condition clause in `a_condition' to see if it is satisfied
		    from a_condition.start
		    until a_condition.after or not Result
		    loop
		        l_var_name := a_condition.key_for_iteration
		        l_var_condition := a_condition.item_for_iteration
		        l_class := l_var_condition.class_
		        if attached mock_heap.value (l_class.class_id) as lt_table and then attached lt_table.value (l_var_name) as lt_boolean_state then
		        	Result := lt_boolean_state.is_satisfactory_to (l_var_condition)
		        else
		            check False end
		        end
		        a_condition.forth
		    end
		end

feature -- Call sequence reporting

	to_call_sequence: DS_ARRAYED_LIST[STRING]
			-- Output the call sequence leading to `Current' as an array of string, one string for each feature call.
			-- Empty list for starting state.
		local
		    l_pre_sequence: DS_ARRAYED_LIST[STRING]
		    l_feature_call: STRING
		do
		    if is_starting_state then
		        create Result.make_default
		    else
		        check previous_state /= Void and then last_transition /= Void and then last_operands /= Void end
		        l_pre_sequence := previous_state.to_call_sequence
		        l_feature_call := Call_generator.construct_feature_call (last_transition, last_operands)
		        l_pre_sequence.force_last (l_feature_call)
		        Result := l_pre_sequence
		    end
		end

feature -- Symbolic execution

	execute (a_transition: like last_transition): DS_ARRAYED_LIST [like Current]
			-- Execute a transition from current state.
			-- Return all possible resulting states from different choices for operand combinations.
			-- If `a_transition' cannot be executed from current state, return empty list.
		local
			l_configurations: DS_ARRAYED_LIST[DS_ARRAYED_LIST[STRING]]
		    l_conf: DS_ARRAYED_LIST[STRING]
		    l_result_state: like Current
		do
    	    Call_generator.generate_feasible_feature_call_configurations (Current, a_transition)
    	    if Call_generator.is_last_feature_call_feasible then
    	        	-- one result for each configuration
				l_configurations := Call_generator.last_feasible_configurations

				create Result.make (l_configurations.count)
    			from l_configurations.start
    			until l_configurations.after
    			loop
    			    l_conf := l_configurations.item_for_iteration
    			    l_result_state := execute_with_configuration (a_transition, l_conf)
    			    Result.force_last (l_result_state)

    			    l_configurations.forth
    			end
			else
			    	-- empty list
			    create Result.make (1)
		    end
		end

feature{NONE} -- Implementation: Symbolic execution

	execute_with_configuration (a_transition: like last_transition; a_conf: DS_ARRAYED_LIST[STRING]): like Current
			-- Execute `a_transition' from current state with operand configuration `a_conf', return the result state.
		require
		    same_size: a_transition.count = a_conf.count
		local
		    l_heap: like mock_heap
		    l_transition_summary: AFX_BOOLEAN_STATE_TRANSITION_SUMMARY
		    l_name: STRING
		    l_class: CLASS_C
		    l_dest: AFX_BOOLEAN_STATE
		    l_properties_true, l_properties_false: AFX_BIT_VECTOR
		do
		    l_heap := mock_heap.twin

		    from
		        a_transition.start
		        a_conf.start
		    until
		        a_conf.after
		    loop
		        l_transition_summary := a_transition.item_for_iteration

		        l_class := l_transition_summary.class_
		        l_name := a_conf.item_for_iteration
		        if attached l_heap.value (l_class.class_id) as lt_var_table and then attached lt_var_table.value (l_name) as lt_src_state then

    					-- construct boolean state of object `l_name' after transition
    		        create l_dest.make_for_class (l_class)

    		        	-- all possible true properties
    		        l_properties_true := l_transition_summary.post_set_true | (lt_src_state.properties_false & l_transition_summary.post_negated)
    		        				| (lt_src_state.properties_true & l_transition_summary.post_unchanged)

    		        	-- all possible false properties
    		        l_properties_false := l_transition_summary.post_set_false | (lt_src_state.properties_true & l_transition_summary.post_negated)
    		        				| (lt_src_state.properties_false & l_transition_summary.post_unchanged)

    		        	-- optimistic way of computing the next state
    		        l_dest.properties_true := l_properties_true
    		        l_dest.properties_false := l_properties_false

    		        	-- update local heap
    		        lt_var_table.put (l_dest, l_name)
		        else
		            check False end
		        end

					-- continue with other operands
		        a_transition.forth
		        a_conf.forth
		    end

	        create Result.make (Current, a_transition, a_conf, l_heap)
		end

feature{NONE} -- Implementation

	Enumeration_generator: AFX_ENUMERATION_GENERATOR [STRING]
			-- Enumeration generator to generate all possible combinations of operand configurations.
		once
		    create Result
		end

	Call_generator: AFX_FEATURE_CALL_GENERATOR
			-- Feature call generator.
		once
		    create Result
		end

end
