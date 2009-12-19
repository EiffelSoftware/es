note
	description: "Summary description for {AFX_FORWARD_BEHAVIOR_CONSTRUCTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FORWARD_BEHAVIOR_CONSTRUCTOR

inherit
    AFX_BEHAVIOR_CONSTRUCTOR_I

create
    make

feature -- Initialization

	make
			-- Initialize.
		do
			create call_sequences.make_default
			create state_transition_model.make_default

			create satisfactory_behaviors.make_default
			create working_stack.make_default
		end

feature -- Access

	config: detachable AFX_BEHAVIOR_CONSTRUCTOR_CONFIG
			-- <Precursor>

	criteria: detachable AFX_BEHAVIOR_FEATURE_SELECTOR_I
			-- <Precursor>

	call_sequences: DS_ARRAYED_LIST [AFX_STATE_TRANSITION_FIX]
			-- <Precursor>

	state_transition_model: AFX_FORWARD_STATE_TRANSITION_MODEL
			-- <Precursor>

feature -- Constructor interface

	reset_constructor (an_objects: DS_HASH_TABLE[AFX_STATE, STRING]; a_dest_objects: DS_HASH_TABLE[AFX_STATE, STRING];
				a_context_class: CLASS_C; a_class_set: detachable DS_HASH_SET [CLASS_C]; a_criteria: detachable AFX_BEHAVIOR_FEATURE_SELECTOR_I)
			-- <Precursor>
		do
		    create config.make (an_objects, a_dest_objects, a_context_class, a_class_set)

		    if attached a_criteria as lt_criteria then
		        criteria := lt_criteria
		    else
		        create {AFX_BEHAVIOR_FEATURE_SELECTOR}criteria
		    end

		    if not call_sequences.is_empty then
		        call_sequences.wipe_out
		    end

		    if not satisfactory_behaviors.is_empty then
		        satisfactory_behaviors.wipe_out
		    end

		    if not working_stack.is_empty then
		        working_stack.wipe_out
		    end
		ensure then
		    config_set: config /= Void and then config.is_good
		    criteria_set: criteria /= Void
		    call_sequences_empty: call_sequences.is_empty
		    satisfactory_behaviors_empty: satisfactory_behaviors.is_empty
		    working_stack_empty: working_stack.is_empty
		end

	construct_behavior
			-- <Precursor>
		local
		    l_starting_state: AFX_BEHAVIOR_STATE
		    l_applicable_transitions: DS_ARRAYED_LIST [AFX_STATE_TRANSITION_SUMMARY]
		    l_sequences: DS_ARRAYED_LIST[DS_ARRAYED_LIST[STRING]]
		do
		    create l_starting_state.make (Void, Void, Void, config.usable_objects)

				-- select applicable transitions
		    l_applicable_transitions := collect_applicable_transitions

				-- construct call sequences from starting state, using selected transitions
			construct_from_starting_state (l_starting_state, l_applicable_transitions)

				-- construct call sequences from satisfactory behaviors
			if not satisfactory_behaviors.is_empty then
    			behaviors_to_call_sequences
			end
		end

feature{NONE} -- Implementation

	satisfactory_behaviors: DS_ARRAYED_LIST [AFX_BEHAVIOR_STATE]
			-- Satisfactory states reached during search.

	working_stack: DS_LINKED_STACK [AFX_BEHAVIOR_STATE]
			-- Working stack for constructing the behavior sequences.

	collect_applicable_transitions: DS_ARRAYED_LIST [AFX_STATE_TRANSITION_SUMMARY]
			-- Collect applicable transitions according to `config' and applicability `criteria'.
			-- Only features with summary information would be considered.
		require
		    classes_not_empty: not config.class_set.is_empty
		local
		    l_transitions: DS_ARRAYED_LIST [AFX_STATE_TRANSITION_SUMMARY]
		    l_manager: like state_transition_model
		    l_classes: DS_HASH_SET [CLASS_C]
		    l_class: CLASS_C
		    l_context_class: CLASS_C
		    l_tbl: DS_HASH_TABLE[AFX_STATE_TRANSITION_SUMMARY, INTEGER]
		    l_summary: AFX_STATE_TRANSITION_SUMMARY
    	    l_feature_table: FEATURE_TABLE
    	    l_next_feature: FEATURE_I
		do
		    create l_transitions.make_default

		    l_manager := state_transition_model
		    l_context_class := config.context_class
		    l_classes := config.class_set

			from l_classes.start
			until l_classes.after
			loop
			    l_class := l_classes.item_for_iteration
			    if l_manager.has (l_class.class_id) then
			        l_tbl := l_manager.item (l_class.class_id)

    			    l_feature_table := l_class.feature_table
    			    from l_feature_table.start
    			    until l_feature_table.after
    			    loop
    			        l_next_feature := l_feature_table.item_for_iteration
    			        	-- fixme: find out the proper context class for argument
    			        if l_tbl.has (l_next_feature.feature_id) and then criteria.is_suitable (l_class, l_next_feature, l_context_class) then
    			            l_transitions.force_last (l_tbl.item (l_next_feature.feature_id))
    			        end
    			        l_feature_table.forth
    			    end
			    end
			    l_classes.forth
			end

			Result := l_transitions
		end

	construct_from_starting_state (a_starting_state: AFX_BEHAVIOR_STATE; a_transitions: DS_ARRAYED_LIST [AFX_STATE_TRANSITION_SUMMARY])
			-- Use depth first search to construct all possible call sequences up to length `config.maximun_depth'
			-- The results are put into `satisfactory_behaviors'.
		local
		    l_call_generator: AFX_FEATURE_CALL_GENERATOR
		    l_stack: like working_stack
		    l_transition: AFX_STATE_TRANSITION_SUMMARY
		    l_cur_state, l_next_state: AFX_BEHAVIOR_STATE
		    l_result_states: DS_ARRAYED_LIST [AFX_BEHAVIOR_STATE]
		do
		    create l_call_generator
		    satisfactory_behaviors.wipe_out

			l_stack := working_stack
		    l_stack.wipe_out
		    from
			    l_stack.put (a_starting_state)
		    until
		    	l_stack.is_empty
		    loop
		    	l_cur_state := l_stack.item
		    	l_stack.remove

					-- try each suitable transition from this state, to see what other states we can get
		    	from a_transitions.start
		    	until a_transitions.after
		    	loop
		    	    l_transition := a_transitions.item_for_iteration
	    	        l_result_states := l_cur_state.execute (l_transition)
	    	        from l_result_states.start
	    	        until l_result_states.after
	    	        loop
	    	            l_next_state := l_result_states.item_for_iteration
   		    	        if l_next_state.is_conforming_to (config.destination) then
   		    	            	-- `is_conforming_to' is a strong condition,
   		    	            	-- with which we are "sure" these behaviors actually satisfy the conditoin (according to the summary)
   		    	            	-- Or, we can be more permissive, select the behaviors that won't cause any conflict.
   		    	            	-- TODO: allow both approaches
   		    	            satisfactory_behaviors.force_last (l_next_state)
   		    	        elseif l_next_state.steps < config.maximum_length then
   		    	            l_stack.put (l_next_state)
   		    	        else
	    	            	-- do nothing. Skip this branch since no satisfactory state found in `maximum_length' steps
   		    	        end
	    	            l_result_states.forth
	    	        end
		    	    a_transitions.forth
		    	end	-- loop for all transitions
		    end -- loop for all reachable states within `maximum_length' steps
		end

	behaviors_to_call_sequences
			-- Output the `satisfactory_behaviors' as arrays of fixes.
			-- The result is saved in `call_sequences'.
		require
		    satisfactory_behaviors_not_empty: not satisfactory_behaviors.is_empty
		    call_sequences_not_void: call_sequences /= Void
		local
		    l_sequences: like call_sequences
		    l_state: AFX_BEHAVIOR_STATE
		    l_fix: AFX_STATE_TRANSITION_FIX
		    l_empty_fix: DS_ARRAYED_LIST [STRING_8]
		do
		    l_sequences := call_sequences
		    l_sequences.wipe_out
			l_sequences.resize (satisfactory_behaviors.count + 1)

				-- add the empty call sequence as a special fix candidate
			create l_empty_fix.make (1)
			create l_fix.make (l_empty_fix)
			l_sequences.force_last (l_fix)

		    from satisfactory_behaviors.start
		    until satisfactory_behaviors.after
		    loop
		        l_state := satisfactory_behaviors.item_for_iteration

				create l_fix.make (l_state.to_call_sequence)
		        l_sequences.force_last (l_fix)

		        satisfactory_behaviors.forth
		    end
		end

end
