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

	make (a_previous: like previous_state;
				a_last_transition: like last_transition;
				a_last_operands: like last_operands;
				a_heap: DS_HASH_TABLE [DS_HASH_TABLE[AFX_BOOLEAN_STATE, STRING], INTEGER];
				a_confidence: like confidence_of_reachability;
				a_distance: like distance_from_previous)
			-- Initialize.
		require
		    confidence_negative_zero: a_confidence <= 0
		    distance_positive_zero: a_distance >= 0
		do
		    previous_state := a_previous
		    last_transition := a_last_transition
		    last_operands := a_last_operands
			mock_heap := a_heap
			confidence_of_reachability := a_confidence
			distance_from_previous := a_distance

				-- track the steps taken to reach this state
		    if previous_state = Void then
		        steps := 0
		    else
		        steps := previous_state.steps + 1
		    end
		ensure
		    starting_state: is_starting_state implies (previous_state = Void and last_transition = Void and last_operands = Void and confidence_of_reachability = 0 and distance_from_previous = 0)
		    intermediate_state: not is_starting_state implies (previous_state /= Void and last_transition /= Void and last_operands /= Void)
		end

feature -- Access

	previous_state: detachable like Current
			-- Previous behavior state.

	last_transition: detachable AFX_STATE_TRANSITION_SUMMARY
			-- Transition by which the system transited from `previous_state' to current state.

	last_operands: detachable DS_ARRAYED_LIST[STRING]
			-- Operand objects for `last_transition'.

	mock_heap: DS_HASH_TABLE [DS_HASH_TABLE[AFX_BOOLEAN_STATE, STRING], INTEGER]
			-- Mock heap containing available objects on this state.
			-- `class_id' as the first key and variable name as the second.

	steps: INTEGER
			-- Number of steps from starting state.

	confidence_of_reachability: INTEGER
			-- Confidence about the reachability of this state from the starting state via the stored sequence of transition.
			-- 0 if there is no precondition violation in its execution history;
			-- Below 0 if there are some. The absolute value equals to the total number of preconditions violated, according to the forward model.

	distance_from_previous: INTEGER
			-- The distance between this state and the `previous_state'.


feature -- Status report

	is_starting_state: BOOLEAN
			-- Is current state the starting state?
		do
		    Result := previous_state = Void
		end

	is_conforming_to (a_condition: DS_HASH_TABLE [AFX_BOOLEAN_STATE, STRING]; a_guidance_style: INTEGER): BOOLEAN
			-- Are the objects on `mock_heap' satisfactory to the requirements from `a_condition'?
		local
		    l_class: CLASS_C
		    l_var_condition: AFX_BOOLEAN_STATE
		    l_var_name: STRING
		do
		    Result := True

				-- Go through each condition to see if it is satisfied.
		    from a_condition.start
		    until a_condition.after or not Result
		    loop
		        l_var_name := a_condition.key_for_iteration
		        l_var_condition := a_condition.item_for_iteration
		        l_class := l_var_condition.class_

					-- Get the object associated with the condition.
		        if attached mock_heap.value (l_class.class_id) as lt_table and then attached lt_table.value (l_var_name) as lt_boolean_state then
		            Result := lt_boolean_state.is_conforming_to (l_var_condition, a_guidance_style)
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
			-- Execute `a_transition' from current state, using the model in `a_guidance_style'.
			-- Return all possible resulting states from different choices for operand combinations.
			-- If `a_transition' cannot be executed from current state, return empty list.
		local
			l_configurations: DS_ARRAYED_LIST[DS_ARRAYED_LIST[STRING]]
		    l_conf: DS_ARRAYED_LIST[STRING]
		    l_result_state: like Current
		do
    	    Call_generator.generate_feasible_feature_call_configurations (Current, a_transition)
    	    if Call_generator.is_last_feature_call_feasible then
    	        	-- One result for each configuration.
				l_configurations := Call_generator.last_behavior_operand_configurations
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
			    	-- Return empty list.
			    create Result.make (1)
		    end
		end

feature{NONE} -- Implementation: Symbolic execution

	execute_with_configuration (
				a_transition: like last_transition;
				a_conf: DS_ARRAYED_LIST[STRING];
			): like Current
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
		    l_number_of_contradictions: INTEGER
		    l_state_distance: INTEGER
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
		            	-- Number of precondition violations.
				    l_number_of_contradictions := l_number_of_contradictions
				    						+ (lt_src_state.properties_false & l_transition_summary.pre_true).count_of_set_bits
				    						+ (lt_src_state.properties_true & l_transition_summary.pre_false).count_of_set_bits

    					-- Construct the boolean state after transition.
    		        create l_dest.make_for_class (l_class)
    		        l_dest.properties_true := l_transition_summary.post_set_true | (lt_src_state.properties_false & l_transition_summary.post_negated)
    		        				| (lt_src_state.properties_true & l_transition_summary.post_unchanged)
    		        l_dest.properties_false := l_transition_summary.post_set_false | (lt_src_state.properties_true & l_transition_summary.post_negated)
    		        				| (lt_src_state.properties_false & l_transition_summary.post_unchanged)

						-- State distance between the src and dest objects.
					l_state_distance := l_state_distance + lt_src_state.distance_between (l_dest)

    		        	-- Update local heap.
    		        lt_var_table.put (l_dest, l_name)
		        else
		            check False end
		        end

					-- Continue with other operands.
		        a_transition.forth
		        a_conf.forth
		    end

	        create Result.make (Current, a_transition, a_conf, l_heap, confidence_of_reachability - l_number_of_contradictions, distance_from_previous + l_state_distance)
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

invariant
    steps_positive_zero: steps >= 0
    confidence_of_reachability_negative_zero: confidence_of_reachability <= 0
    distance_from_previous_positive_zero: distance_from_previous >= 0

end
