note
	description: "Summary description for {AFX_BEHAVIOR_CONSTRUCTOR_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BEHAVIOR_CONSTRUCTOR_I

inherit
    AFX_SHARED_STATE_TRANSITION_MODEL

create
    default_create

feature -- Access

	config: detachable AFX_BEHAVIOR_CONSTRUCTOR_CONFIG
			-- Configuration of the behavior construction.

	criteria: AFX_BEHAVIOR_FEATURE_SELECTOR_I
			-- Feature selection criteria.
		do
		    Result := internal_criteria.item
		end

	call_sequences: DS_ARRAYED_LIST [AFX_STATE_TRANSITION_FIX]
			-- List of state transition fixes.
		do
		    Result := internal_list_of_fixes
		end

feature -- Constructor interface

	construct_behavior (a_config: attached like config; a_criteria: detachable like criteria; a_is_forward: BOOLEAN)
			-- Construct the state changing behavior.
		require
		    call_sequences_empty: call_sequences.is_empty
		local
			l_starting_state: AFX_BEHAVIOR_STATE
		    l_empty_fix: DS_ARRAYED_LIST [STRING_8]
		    l_fix: AFX_STATE_TRANSITION_FIX
		do
		    config := a_config

		    if attached a_criteria as lt_criteria then
		        internal_criteria.put (lt_criteria)
		    end

			reset_constructor
		    collect_suitable_feature_options (a_is_forward)
		    if not internal_list_of_feature_options.is_empty then
		        create l_starting_state.make (Void, Void, Void, a_config.usable_objects, 0, 0)
		        internal_stack_of_execution_env.put ([0, l_starting_state])
    		    execute_feature_sequences
    		    if not internal_satisfactory_behavior_states.is_empty then
        		    interpretate_satisfactory_behavior_states
    		    end
		    end

				-- Always add the empty call sequence as a special fix candidate.
			create l_empty_fix.make (1)
			create l_fix.make (l_empty_fix)
			internal_list_of_fixes.force_last (l_fix)
		end

feature{NONE} -- Operation

	reset_constructor
			-- Reset the internal storage.
		do
            internal_list_of_feature_options.wipe_out
            internal_stack_of_execution_env.wipe_out
            internal_satisfactory_behavior_states.wipe_out
            internal_list_of_fixes.wipe_out
		end

	collect_suitable_feature_options (a_is_forward: BOOLEAN)
			-- Collect all the suitable feature options into `internal_list_of_feature_options'.
			-- If it is in forward construction, we use all the non-query features as options.
			-- If in backward construction, we use only the mutators for the corresponding property.
		do
		    if a_is_forward then
		        collect_suitable_feature_options_forward
		    else
		        collect_suitable_feature_options_backward
		    end
		end

	collect_suitable_feature_options_forward
			-- Collect suitable feature options from the model for FORWARD behavior construction.
			-- Only non_query features are used.
		require
		    classes_not_empty: config /= Void and then not config.class_set.is_empty
		local
		    l_transitions: DS_ARRAYED_LIST [AFX_STATE_TRANSITION_SUMMARY]
		    l_config: like config
		    l_model: like state_transition_model
		    l_context_class: CLASS_C
		    l_classes: DS_HASH_SET [CLASS_C]
		    l_class: CLASS_C
		    l_tbl: DS_HASH_TABLE[AFX_STATE_TRANSITION_SUMMARY, INTEGER]
    	    l_feature_table: FEATURE_TABLE
    	    l_next_feature: FEATURE_I
    	    l_index: INTEGER
		do
		    	-- Collect all the suitable features.
		    create l_transitions.make_default
		    l_config := config
		    check l_config /= Void end
		    l_model := state_transition_model
		    l_context_class := l_config.context_class
		    l_classes := l_config.class_set

			from l_classes.start
			until l_classes.after
			loop
			    l_class := l_classes.item_for_iteration
			    if l_model.has (l_class.class_id) then
			        l_tbl := l_model.item (l_class.class_id)

    			    l_feature_table := l_class.feature_table
    			    from l_feature_table.start
    			    until l_feature_table.after
    			    loop
    			        l_next_feature := l_feature_table.item_for_iteration
    			        if l_tbl.has (l_next_feature.feature_id) 	-- With summary information.
    			        		and then not l_tbl.item (l_next_feature.feature_id).is_property_preserving -- Not a query.
    			        		and then criteria.is_suitable (l_class, l_next_feature, l_context_class) then
    			            l_transitions.force_last (l_tbl.item (l_next_feature.feature_id))
    			        end
    			        l_feature_table.forth
    			    end
			    end
			    l_classes.forth
			end

			if not l_transitions.is_empty then
    				-- Repeatedly put the same feature options on each sequence position.
    				-- Don't use internal cursor to iterate through the sub-list.
    			internal_list_of_feature_options.resize (l_config.maximum_length)
    			from l_index := 0
    			until l_index = l_config.maximum_length
    			loop
    			    internal_list_of_feature_options.force_last (l_transitions)
    			    l_index := l_index + 1
    			end
			end
		end

	collect_suitable_feature_options_backward
			-- Collect suitable feature options from the model for BACKWARD behavior construction.
			-- Only non_query mutators are used.
		local
		    l_is_possible: BOOLEAN
		    l_config: like config
		    l_mutators: like internal_list_of_feature_options
		    l_model: like state_transition_model
		    l_tbl: DS_HASH_TABLE[AFX_STATE_TRANSITION_SUMMARY, INTEGER]
		    l_transition: AFX_STATE_TRANSITION_SUMMARY
		    l_options: DS_ARRAYED_LIST[AFX_STATE_TRANSITION_SUMMARY]
--		    l_backward_model: like state_transition_model
--		    l_forward_model: like state_transition_model
		    l_destinations: DS_HASH_TABLE [AFX_BOOLEAN_STATE, STRING]
		    l_boolean_state: AFX_BOOLEAN_STATE
		    l_property_index, l_property_count: INTEGER
		    l_is_interesting, l_value: BOOLEAN
		    l_name: STRING
		    l_class_id: INTEGER
--		    l_size, l_property_index: INTEGER
--		    l_summary_manager: detachable AFX_FORWARD_STATE_TRANSITION_MODEL
--		    l_summary_set: DS_HASH_SET [AFX_STATE_TRANSITION_SUMMARY]
--		    l_summary_list: DS_ARRAYED_LIST[AFX_STATE_TRANSITION_SUMMARY]
--		    l_summary: AFX_STATE_TRANSITION_SUMMARY
		do
		    l_config := config
		    check l_config /= Void end
			l_mutators := internal_list_of_feature_options
			l_model := state_transition_model
--			l_backward_model := get_backward_state_transition_model
--			l_forward_model := get_forward_state_transition_model
			from
    		    l_is_possible := True
    			l_destinations := l_config.destination
				l_destinations.start
			until l_destinations.after or not l_is_possible
			loop
				l_boolean_state := l_destinations.item_for_iteration
				l_name := l_destinations.key_for_iteration

				l_property_count := l_boolean_state.count
				l_class_id := l_boolean_state.class_.class_id

				if l_model.has (l_class_id) then
				    l_tbl := l_model.item (l_class_id)

					from l_property_index := 0
					until l_property_index = l_property_count or not l_is_possible
					loop
					    l_is_interesting := False
					    if l_boolean_state.properties_true.is_bit_set (l_property_index) then
					        l_is_interesting := True
					        l_value := True
					    elseif l_boolean_state.properties_false.is_bit_set (l_property_index) then
					        l_is_interesting := True
					        l_value := False
					    end

					    if l_is_interesting then
					        create l_options.make_default

        				    from l_tbl.start
        				    until l_tbl.after
        				    loop
        				        l_transition := l_tbl.item_for_iteration

								if l_transition.is_mutator_to (l_property_index, l_value) then
								    l_options.force_last (l_transition)
								end

        				        l_tbl.forth
        				    end

        				    if l_options.is_empty then
        				        l_is_possible := False
        				    else
	        				    internal_list_of_feature_options.force_last (l_options)
        				    end
					    end

					    l_property_index := l_property_index + 1
					end

				end
				l_destinations.forth
			end

			if not l_is_possible then
			    internal_list_of_feature_options.wipe_out
			end
		end

--				if attached l_backward_model.value (l_class_id) as lt_table_property then
--					from
--					    l_size := l_boolean_state.size
--					    l_property_index := 0
--					until
--					    l_property_index = l_size
--					loop
--						l_summary_manager := Void
--					    if l_boolean_state.properties_true.is_bit_set (l_property_index) then
--					        if attached lt_table_property.value (l_property_index) as lt_tuple_summary_t then
--					            l_summary_manager := lt_tuple_summary_t.true_summary
--					        else
--					        		-- No summarized feature set the property to true.
--					            l_is_possible := False
--					        end
--					    elseif l_boolean_state.properties_false.is_bit_set (l_property_index) then
--					        if attached lt_table_property.value (l_property_index) as lt_tuple_summary_f then
--					            l_summary_manager := lt_tuple_summary_f.false_summary
--					        else
--					        		-- No summarized feature set the property to false.
--					            l_is_possible := False
--					        end
--					    end

--							-- Filter out unsuitable mutators and queries.
--					    if l_summary_manager /= Void then
--				            l_summary_set := l_summary_manager.to_summary_set
--					        create l_summary_list.make (l_summary_set.count)
--				            from l_summary_set.start
--				            until l_summary_set.after
--				            loop
--				                l_summary := l_summary_set.item_for_iteration

--				                if attached l_forward_model.value (l_class_id) as lt_feature_table
--				                		and then attached lt_feature_table.value (l_summary.feature_.feature_id) as lt_summary
--				                		and then not lt_summary.is_property_preserving 	-- Not query.
--				                		and then criteria.is_suitable (l_summary.class_, l_summary.feature_, l_config.context_class) then
--				                    l_summary_list.force_last (l_summary)
--				                end
--				                l_summary_set.forth
--				            end
--				            internal_list_of_feature_options.force_last (l_summary_list)
--					    end

--					    l_property_index := l_property_index + 1
--					end
--				else
--						-- no summarized feature changes an object of this class
--				    l_is_possible := False
--				end

	execute_feature_sequences
			-- Execute all the possible feature call sequences from the starting state.
			-- During execution, collect the behaviors states "conforming to", according to config.model_guidance_style, the destination state.
			--			and evaluate the behaviors semantically.
		require
		    internal_list_of_feature_options_not_empty: not internal_list_of_feature_options.is_empty
		    internal_stack_of_execution_env_not_empty: not internal_stack_of_execution_env.is_empty
		    internal_satisfactory_behavior_states_empty: internal_satisfactory_behavior_states.is_empty
		local
			l_config: like config
		    l_list_of_feature_options: like internal_list_of_feature_options
		    l_stack: like internal_stack_of_execution_env
		    l_execute_env: TUPLE[sequence_position: INTEGER; behavior_state: AFX_BEHAVIOR_STATE]
		    l_sequence_position: INTEGER
		    l_behavior_state: AFX_BEHAVIOR_STATE
		    l_feature_options: DS_ARRAYED_LIST [AFX_STATE_TRANSITION_SUMMARY]
		    l_transition: AFX_STATE_TRANSITION_SUMMARY
		    l_cur_state, l_next_state: AFX_BEHAVIOR_STATE
		    l_result_states: DS_ARRAYED_LIST [AFX_BEHAVIOR_STATE]
		do
		    l_config := config
		    check l_config /= Void end

		    from
				l_stack := internal_stack_of_execution_env
				l_list_of_feature_options := internal_list_of_feature_options
		    until
		    	l_stack.is_empty
		    loop
		        l_execute_env := l_stack.item
		        l_sequence_position := l_execute_env.sequence_position
		        l_behavior_state := l_execute_env.behavior_state
		    	l_stack.remove

				if l_sequence_position < l_list_of_feature_options.count then
    		    	l_feature_options := l_list_of_feature_options.item (l_sequence_position + 1)

    		    	from l_feature_options.start
    		    	until l_feature_options.after
    		    	loop
    		    	    l_transition := l_feature_options.item_for_iteration

    		    	    l_result_states := l_behavior_state.execute (l_transition)
    	    	        from l_result_states.start
    	    	        until l_result_states.after
    	    	        loop
    	    	            l_next_state := l_result_states.item_for_iteration
       		    	        if l_next_state.is_conforming_to (l_config.destination, l_config.model_guidance_style) then
       		    	            internal_satisfactory_behavior_states.force_last (l_next_state)
       		    	        end
       		    	        if l_next_state.steps < l_list_of_feature_options.count then
       		    	            l_stack.put ([l_sequence_position + 1, l_next_state])
       		    	        end
    	    	            l_result_states.forth
    	    	        end

    		    	    l_feature_options.forth
    		    	end
				end
		    end -- Loop until the stack is empty.
		end

	interpretate_satisfactory_behavior_states
			-- Interpretate the satisfactory behavior states as fixes.
			-- Put the fixes into `internal_list_of_fixes'.
		require
		    internal_satisfactory_behaviors_states_not_empty: not internal_satisfactory_behavior_states.is_empty
		    internal_list_of_fixes_empty: internal_list_of_fixes.is_empty
		local
		    l_fixes: like internal_list_of_fixes
		    l_satisfactory_states: like internal_satisfactory_behavior_states
		    l_state: AFX_BEHAVIOR_STATE
		    l_fix: AFX_STATE_TRANSITION_FIX
		    l_empty_fix: DS_ARRAYED_LIST [STRING_8]
		do
		    l_fixes := internal_list_of_fixes
			l_fixes.resize (internal_satisfactory_behavior_states.count + 1)

		    from
			    l_satisfactory_states := internal_satisfactory_behavior_states
		    	l_satisfactory_states.start
		    until
		    	l_satisfactory_states.after
		    loop
		        l_state := l_satisfactory_states.item_for_iteration

				create l_fix.make (l_state.to_call_sequence)
		        l_fixes.force_last (l_fix)

		        l_satisfactory_states.forth
		    end
		end

feature{NONE} -- Implementation

	internal_list_of_feature_options: DS_ARRAYED_LIST [DS_ARRAYED_LIST [AFX_STATE_TRANSITION_SUMMARY]]
			-- List of suitable feature options.
			-- The length of the list is equal to the maximum length of the constructed call sequences.
			-- 		In forward construction, this equals to the maximum length of fix;
			--		In backward construction, this equals to the number of properties need to changed in the destination state.
			-- Each sub-list contains the options for the i-th call in the sequence.
		once
		    create Result.make_default
		end

	internal_stack_of_execution_env: DS_LINKED_STACK[TUPLE[INTEGER, AFX_BEHAVIOR_STATE]]
			-- Internal stack of execution environment.
		once
		    create Result.make_default
		end

	internal_satisfactory_behavior_states: DS_ARRAYED_LIST [AFX_BEHAVIOR_STATE]
			-- Satisfactory states reached during search.
		once
		    create Result.make_default
		end

	internal_list_of_fixes: DS_ARRAYED_LIST [AFX_STATE_TRANSITION_FIX]
			-- Internal storage for the fixes generated.
		once
		    create Result.make_default
		end

	internal_criteria: CELL[AFX_BEHAVIOR_FEATURE_SELECTOR_I]
			-- Internal storage for the criteria.
		once
		    create Result.put (create {AFX_BEHAVIOR_FEATURE_SELECTOR})
		end

--	state_transition_model: AFX_STATE_TRANSITION_MODEL_I
--			-- The model to be used in construction.
--		deferred
--		end
--
--	internal_working_stack: DS_LINKED_STACK [AFX_BEHAVIOR_STATE]
--			-- Working stack for constructing the behavior sequences.
--		once
--		    create Result.make_default
--		end

--	reset_constructor (an_objects: DS_HASH_TABLE[AFX_STATE, STRING];
--					a_dest_objects: DS_HASH_TABLE[AFX_STATE, STRING];
--					a_context_class: CLASS_C;
--					a_class_set: detachable DS_HASH_SET [CLASS_C];
--					a_criteria: detachable AFX_BEHAVIOR_FEATURE_SELECTOR_I)
--			-- Reset the constructor and get it ready for a new construction.
--			-- Note: `state_transition_model' is NOT reset.
--			-- 		Use `transition_summary_manager.clear_summary' to do that.
--		deferred
--		ensure
--		    config_set: config /= Void
--		    criteria_set: criteria /= Void
--		    call_sequences_empty: call_sequences.is_empty
--		end

--	construct_behavior
--			-- Construct behaviors to make the transition.
--			-- Constructed fixes are stored in `fix_sequences'.
--		require
--		    state_transition_model_good: state_transition_model.is_good
--		    config_good: config.is_good
--		    criteria_set: criteria /= Void
--		    call_sequences_empty: call_sequences.is_empty
--		deferred
--		end

--feature -- Output

--	call_sequences_as_string: STRING
--			-- Represent the whole call sequences using a single string.
--		require
--		    fix_candidates_not_empty: call_sequences /= Void and then not call_sequences.is_empty
--		local
--		    l_fixes: like call_sequences
--		    l_str: STRING
--		    l_index: INTEGER
--		do
--		    l_fixes := call_sequences
--		    create l_str.make (1024)
--		    from
--		    	l_index := 1
--		    	l_fixes.start
--		    until
--		        l_fixes.after
--		    loop
--		        l_str.append ("  --- Sequence #")
--		        l_str.append (l_index.out)
--		        l_str.append (" ---%N")
--		        l_str.append (l_fixes.item_for_iteration.out)
--				l_str.append_character ('%N')

--		        l_index := l_index + 1
--		        l_fixes.forth
--		    end
--		    Result := l_str
--		end


end
