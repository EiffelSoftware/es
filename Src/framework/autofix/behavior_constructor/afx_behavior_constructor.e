note
	description: "Summary description for {AFX_BEHAVIOR_CONSTRUCTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BEHAVIOR_CONSTRUCTOR

inherit
    AFX_SHARED_STATE_TRANSITION_MODEL

create
    default_create

feature -- Access

	config: detachable AFX_BEHAVIOR_CONSTRUCTOR_CONFIG
			-- Configuration of the behavior construction.

--	criteria: AFX_BEHAVIOR_FEATURE_SELECTOR_I
--			-- Feature selection criteria.
--		do
--		    Result := internal_criteria.item
--		end

	call_sequences: DS_ARRAYED_LIST [AFX_STATE_TRANSITION_FIX]
			-- List of state transition fixes.
		do
		    if internal_list_of_fixes = Void then
		        create internal_list_of_fixes.make_default
		    end
		    Result := internal_list_of_fixes
		end

	state_transition_summary_equality_tester: AFX_STATE_TRANSITION_SUMMARY_EQUALITY_TESTER
			-- State transition summary equality tester.
		once
		    create Result
		end

feature -- Constructor interface

	construct_behavior (a_config: attached like config)
			-- Construct the state changing behavior.
		local
			l_starting_state: AFX_BEHAVIOR_STATE
		    l_empty_fix: DS_ARRAYED_LIST [STRING_8]
		    l_fix: AFX_STATE_TRANSITION_FIX
		    l_feature_options: like internal_list_of_feature_options
		do
		    config := a_config

			if internal_call_sequence_cache.has (a_config) then
			    internal_list_of_fixes := internal_call_sequence_cache.item (a_config)
			else
    			reset_constructor
    		    collect_suitable_feature_options (a_config.is_forward)

    	        l_feature_options := internal_list_of_feature_options
    		    if not l_feature_options.is_empty then
    		        if config.is_using_symbolic_execution then
    		            	-- Symbolically execute the features to construct the behavior sequences.
        		        create l_starting_state.make (Void, Void, Void, a_config.usable_objects, 0, 0)
        		        internal_stack_of_execution_env.put ([0, l_starting_state])
            		    execute_feature_sequences
            		    if not internal_satisfactory_behavior_states.is_empty then
                		    interpretate_satisfactory_behavior_states
            		    end
    		        else
    		            enumerate_feature_call_sequences
    		        end
    		    end

    				-- Always add the empty call sequence as a special fix candidate.
    			create l_empty_fix.make (1)
    			create l_fix.make (l_empty_fix)
    			call_sequences.force_last (l_fix)

					-- Cache the result.
    			internal_call_sequence_cache.force (call_sequences, a_config)
			end
		end

feature{NONE} -- Operation

	enumerate_feature_call_sequences
			-- Generate all possible feature call sequences by enumeration from the feature options.
		require
		    internal_list_of_feature_options_not_empty: not internal_list_of_feature_options.is_empty
		local
		    l_feature_options: like internal_list_of_feature_options
		    l_generator: like Transition_enumeration_generator
		    l_feature_options_in_set: DS_ARRAYED_LIST[DS_HASH_SET[AFX_STATE_TRANSITION_SUMMARY]]
		    l_set_of_options: DS_HASH_SET[AFX_STATE_TRANSITION_SUMMARY]
		    l_list_of_options: DS_ARRAYED_LIST [AFX_STATE_TRANSITION_SUMMARY]
   		    l_feature_call_sequences: DS_ARRAYED_LIST[DS_ARRAYED_LIST[AFX_STATE_TRANSITION_SUMMARY]]
		    l_partial_call_sequences: DS_ARRAYED_LIST[DS_ARRAYED_LIST[STRING]]
		    l_starting_state: AFX_BEHAVIOR_STATE
		    l_call_sequences: like call_sequences
		    l_fix: AFX_STATE_TRANSITION_FIX
		do
	        l_feature_options := internal_list_of_feature_options

				-- Convert `internal_list_of_feature_options' into the input format of the generator.
			create l_feature_options_in_set.make (l_feature_options.count)
			from l_feature_options.start
			until l_feature_options.after
			loop
			    l_list_of_options := l_feature_options.item_for_iteration

				create l_set_of_options.make (l_list_of_options.count)
				l_set_of_options.set_equality_tester (state_transition_summary_equality_tester)
				l_list_of_options.do_all (agent l_set_of_options.force)
				l_feature_options_in_set.force_last (l_set_of_options)

			    l_feature_options.forth
			end

            	-- Enumerate possible feature call sequences.
			l_generator := Transition_enumeration_generator
			l_generator.enumerate_all_partial (l_feature_options_in_set)
			l_generator.remove_duplications
			l_feature_call_sequences := l_generator.last_enumeration_list
			check not l_feature_call_sequences.is_empty end

				-- Feature call sequences to fix snippets.
		    l_call_sequences := call_sequences
		    create l_starting_state.make (Void, Void, Void, config.usable_objects, 0, 0)
			from l_feature_call_sequences.start
			until l_feature_call_sequences.after
			loop
			    l_partial_call_sequences := mutator_sequence_to_call_sequences (l_starting_state, l_feature_call_sequences.item_for_iteration)

			    	-- construct a fix from each call sequence, and put the fix into `call_sequences'
			    from l_partial_call_sequences.start
			    until l_partial_call_sequences.after
			    loop
			        create l_fix.make (l_partial_call_sequences.item_for_iteration)
			        l_call_sequences.force_last (l_fix)
			        l_partial_call_sequences.forth
			    end

			    l_feature_call_sequences.forth
			end
		end

	mutator_sequence_to_call_sequences (a_starting_state: AFX_BEHAVIOR_STATE; a_mutator_sequence: DS_ARRAYED_LIST[AFX_STATE_TRANSITION_SUMMARY])
										: DS_ARRAYED_LIST[DS_ARRAYED_LIST[STRING]]
			-- Construct a list of feature call sequences from a given mutator sequence.
		local
		    l_mutator: AFX_STATE_TRANSITION_SUMMARY
		    l_feature_call_generator: like Feature_call_generator
		    l_call_sequences: like call_sequences
		    l_call: DS_ARRAYED_LIST [STRING]
		    l_call_set: DS_HASH_SET [STRING]
		    l_option_list: DS_ARRAYED_LIST[DS_HASH_SET[STRING]]
		    l_generator: like Feature_call_enumeration_generator
		do
		    l_feature_call_generator := Feature_call_generator
		    create l_option_list.make_default
		    l_generator := Feature_call_enumeration_generator

		    from a_mutator_sequence.start
		    until a_mutator_sequence.after
		    loop
		        l_mutator := a_mutator_sequence.item_for_iteration

		        	-- Each mutator can be executed using different operand-configurations, which constitutes a set.
		        	-- We turn a mutator sequence into a list of set of concrete feature calls.
		        l_feature_call_generator.generate_feasible_feature_call_configurations (a_starting_state, l_mutator)
		        if attached l_feature_call_generator.last_behavior_operand_configurations as lt_configurations and then not lt_configurations.is_empty then
		            l_call := l_feature_call_generator.configurations_to_feature_calls
		            create l_call_set.make (l_call.count)
		            l_call.do_all (agent l_call_set.put )
		            l_option_list.force_last (l_call_set)
		        else
		            check False end
		        end

		        a_mutator_sequence.forth
		    end

			l_generator.enumerate_fully (l_option_list)
			Result := l_generator.last_enumeration_list
		end



	reset_constructor
			-- Reset the internal storage.
		do
            internal_list_of_feature_options.wipe_out
            internal_stack_of_execution_env.wipe_out
            internal_satisfactory_behavior_states.wipe_out

            	-- Since we cache the result, the list of fixes should not be wiped out.
            internal_list_of_fixes := Void
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
    			        		and then config.criteria.is_suitable (l_class, l_next_feature, l_context_class) then
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
		    l_mutator_table: DS_HASH_TABLE[AFX_STATE_TRANSITION_SUMMARY, INTEGER]
		    l_options: DS_ARRAYED_LIST[AFX_STATE_TRANSITION_SUMMARY]
		    l_destinations: DS_HASH_TABLE [AFX_BOOLEAN_STATE, STRING]
		    l_num_of_property_change, l_num_of_mutator_repeatition, i: INTEGER
		    l_boolean_state: AFX_BOOLEAN_STATE
		    l_property_index, l_property_count: INTEGER
		    l_is_interesting, l_value: BOOLEAN
		    l_name: STRING
		    l_class_id: INTEGER
		do
		    l_config := config
		    check l_config /= Void end
			l_mutators := internal_list_of_feature_options
			l_model := state_transition_model
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

				if not l_model.has (l_class_id) then
					l_is_possible := False
				else
				    l_tbl := l_model.item (l_class_id)
					create l_mutator_table.make (l_tbl.count)

						-- Collect the set of all mutators regarding the operand into a hash_table.
					from
						l_property_index := 0
						l_num_of_property_change := 0
					until
						l_property_index = l_property_count or not l_is_possible
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
					        l_num_of_property_change := l_num_of_property_change + 1
        				    from l_tbl.start
        				    until l_tbl.after
        				    loop
        				        l_transition := l_tbl.item_for_iteration

								if l_transition.count = 1 and then l_transition.is_mutator_to (l_property_index, l_value) then
								    l_mutator_table.force (l_transition, l_tbl.key_for_iteration)
								end

        				        l_tbl.forth
        				    end
					    end

					    l_property_index := l_property_index + 1
					end

						-- Mutators from hash_table to arrayed_list.
					if l_mutator_table.is_empty then
					    l_is_possible := False
					else
							-- Convert hash table into arrayed list.
    					create l_options.make (l_mutator_table.count)
    					l_mutator_table.do_all (agent l_options.force_last)

       						-- Repeat the mutators for a certain times, according to the config.
       					l_num_of_mutator_repeatition := config.repeatition_per_class (l_num_of_property_change)
					    internal_list_of_feature_options.resize (l_num_of_mutator_repeatition)
       					from i := 1
       					until i > l_num_of_mutator_repeatition
       					loop
           					internal_list_of_feature_options.force_last (l_options)
           					i := i + 1
       					end
					end
				end
				l_destinations.forth
			end

			if not l_is_possible then
			    internal_list_of_feature_options.wipe_out
			end
		end

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
		    call_sequences_empty: call_sequences.is_empty
		local
		    l_fixes: like call_sequences
		    l_satisfactory_states: like internal_satisfactory_behavior_states
		    l_state: AFX_BEHAVIOR_STATE
		    l_fix: AFX_STATE_TRANSITION_FIX
		    l_empty_fix: DS_ARRAYED_LIST [STRING_8]
		do
		    l_fixes := call_sequences
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

	Configuration_equality_tester: AFX_BEHAVIOR_CONSTRUCTOR_CONFIG_EQUALITY_TESTER
			-- Equality tester for configurations.
		once
		    create Result
		end

	Transition_enumeration_generator: AFX_ENUMERATION_GENERATOR [AFX_STATE_TRANSITION_SUMMARY]
			-- Generator to generate all transition enumerations.
		once
		    create Result
		end

	Feature_call_enumeration_generator: AFX_ENUMERATION_GENERATOR [STRING]
			-- Generator to generate all feature call (as STRING) enumerations.
		once
		    create Result
		end

	Feature_call_generator: AFX_FEATURE_CALL_GENERATOR
			-- Feature call generator.
		once
		    create Result
		end

	internal_call_sequence_cache: DS_HASH_TABLE [DS_ARRAYED_LIST [AFX_STATE_TRANSITION_FIX], AFX_BEHAVIOR_CONSTRUCTOR_CONFIG]
			-- Internal cache for the generated call sequences.
		once
		    create Result.make_default
		    Result.set_key_equality_tester (Configuration_equality_tester)
		end

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

	internal_list_of_fixes: detachable DS_ARRAYED_LIST [AFX_STATE_TRANSITION_FIX]
			-- Internal storage for the fixes generated.

--	internal_criteria: CELL[AFX_BEHAVIOR_FEATURE_SELECTOR_I]
--			-- Internal storage for the criteria.
--		once
--		    create Result.put (create {AFX_BEHAVIOR_FEATURE_SELECTOR})
--		end

end
