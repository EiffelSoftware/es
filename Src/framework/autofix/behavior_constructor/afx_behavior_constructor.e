note
	description: "Summary description for {AFX_BEHAVIOR_CONSTRUCTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BEHAVIOR_CONSTRUCTOR

inherit
    AFX_BEHAVIOR_CONSTRUCTOR_I

    AFX_SHARED_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY_MANAGER

create
    make

feature -- initialize

	make (a_config: like config)
			-- initialize
		require
		    config_good: a_config.is_good
		do
			config := a_config

			create {AFX_BEHAVIOR_FEATURE_SELECTOR}criteria
			create transitions.make_default
			create satisfactory_behaviors.make_default
			create working_stack.make_default
		end

feature -- status report

	config: AFX_BEHAVIOR_CONSTRUCTOR_CONFIG
			-- configuration of constructor

	transitions: DS_ARRAYED_LIST [AFX_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY]
			-- array of all applicable feature call summaries
			-- i.e. feature call with summary information from `config.class_set' classes

	criteria: AFX_BEHAVIOR_FEATURE_SELECTOR_I
			-- feature selection criteria

	satisfactory_behaviors: DS_ARRAYED_LIST [AFX_BEHAVIOR_STATE]
			-- satisfactory behaviors found

feature -- operation

	construct_behavior
			-- construct behavior to make the transition
		local
		    l_starting_state: AFX_BEHAVIOR_STATE
		    l_sequences: DS_ARRAYED_LIST[DS_ARRAYED_LIST[STRING]]
		do
		    collect_satisfactory_features
		    create l_starting_state.make (Void, Void, Void, config.usable_objects)
		    working_stack.put (l_starting_state)

			construct

				-- print satisfactory call sequences
			l_sequences := output_satisfactory_behaviors

			print (behaviors_to_string (l_sequences))
		end

	construct
			-- using depth first search to find out all possible call sequences up to depth of `config.maximum_depth'
		local
		    l_stack: like working_stack
		    l_transitions: like transitions
		    l_transition: AFX_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY
		    l_cur_state, l_next_state: AFX_BEHAVIOR_STATE
		    l_result_states: DS_ARRAYED_LIST [AFX_BEHAVIOR_STATE]
		do
		    from
		    	l_stack := working_stack
		    	l_transitions := transitions
		    until
		    	l_stack.is_empty
		    loop
		    	l_cur_state := l_stack.item
		    	l_stack.remove

		    	from l_transitions.start
		    	until l_transitions.after
		    	loop
		    	    l_transition := l_transitions.item_for_iteration
		    	    l_cur_state.find_possible_configurations (l_transition)
		    	    if l_cur_state.is_executable (l_transition) then
		    	        l_result_states := l_cur_state.execute (l_transition)
		    	        from l_result_states.start
		    	        until l_result_states.after
		    	        loop
		    	            l_next_state := l_result_states.item_for_iteration
    		    	        if l_next_state.is_conforming_to (config.destination) then
    		    	            satisfactory_behaviors.force_last (l_next_state)
    		    	        elseif l_next_state.steps < config.maximum_length then
    		    	            l_stack.put (l_next_state)
    		    	        else
   		    	            	-- do nothing. Skip this branch since no satisfactory state found in `maximum_length' steps
    		    	        end
		    	            l_result_states.forth
		    	        end
		    	    end
		    	    l_transitions.forth
		    	end	-- loop for all transitions
		    end -- loop for all reachable states within `maximum_length' steps
		end

	collect_satisfactory_features
			-- collect satisfactory features according to `config' and `satisfactory_criteria'
			-- only features with summary information would be considered.
		require
		    classes_not_empty: not config.class_set.is_empty
		local
		    l_manager: like state_transition_summary_manager
		    l_classes: DS_HASH_SET [CLASS_C]
		    l_class: CLASS_C
		    l_context_class: CLASS_C
		    l_tbl: DS_HASH_TABLE[AFX_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY, INTEGER]
		    l_summary: AFX_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY
    	    l_feature_table: FEATURE_TABLE
    	    l_next_feature: FEATURE_I
		do
		    l_manager := state_transition_summary_manager
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
    			        if l_tbl.has (l_next_feature.feature_id) and then criteria.is_satisfactory (l_class, l_next_feature, l_context_class) then
    			            transitions.force_last (l_tbl.item (l_next_feature.feature_id))
    			        end
    			        l_feature_table.forth
    			    end
			    end
			    l_classes.forth
			end
		end

feature{NONE} -- implementation

	output_satisfactory_behaviors: DS_ARRAYED_LIST[DS_ARRAYED_LIST[STRING]]
			-- output the `satisfactory_behaviors' as arrays of strings
		require
		    satisfactory_behaviors_not_empty: not satisfactory_behaviors.is_empty
		local
		    l_state: AFX_BEHAVIOR_STATE
		    l_sequence: DS_ARRAYED_LIST[STRING]
		do
		    create Result.make (satisfactory_behaviors.count)
		    from satisfactory_behaviors.start
		    until satisfactory_behaviors.after
		    loop
		        l_state := satisfactory_behaviors.item_for_iteration

    		    l_sequence := l_state.to_call_sequence
		        Result.force_last (l_sequence)

		        satisfactory_behaviors.forth
		    end
		end

	behaviors_to_string (a_behaviors: DS_ARRAYED_LIST[DS_ARRAYED_LIST[STRING]]): STRING
			-- from list of sequences to a single string
		local
		    l_list: DS_ARRAYED_LIST[STRING]
		    l_str: STRING
		    l_index: INTEGER
		do
		    create l_str.make (1024)
		    from
		    	l_index := 1
		    	a_behaviors.start
		    until
		        a_behaviors.after
		    loop
		        l_list := a_behaviors.item_for_iteration

		        l_str.append ("  --- Sequence #")
		        l_str.append (l_index.out)
		        l_str.append (" ---%N")

		        from l_list.start
		        until l_list.after
		        loop
		            l_str.append (l_list.item_for_iteration)
		            l_str.append_character ('%N')
		            l_list.forth
		        end

				l_str.append_character ('%N')
		        l_index := l_index + 1
		        a_behaviors.forth
		    end
		end

	working_stack: DS_LINKED_STACK [AFX_BEHAVIOR_STATE]
			-- working stack for constructing the behavior sequences


end
