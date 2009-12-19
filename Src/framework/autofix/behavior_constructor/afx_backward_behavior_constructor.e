note
	description: "Summary description for {AFX_BACKWARD_BEHAVIOR_CONSTRUCTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BACKWARD_BEHAVIOR_CONSTRUCTOR

inherit
	AFX_BEHAVIOR_CONSTRUCTOR_I

create
    make

feature -- Initialize

	make
			-- Initialize.
		do
			create call_sequences.make_default
			create state_transition_model.make_default
			create possible_feature_mutators.make_default
		end

feature -- Access

	config: detachable AFX_BEHAVIOR_CONSTRUCTOR_CONFIG
			-- <Precursor>

	criteria: detachable AFX_BEHAVIOR_FEATURE_SELECTOR_I
			-- <Precursor>

	call_sequences: DS_ARRAYED_LIST [AFX_STATE_TRANSITION_FIX]
			-- <Precursor>

	state_transition_model: AFX_BACKWARD_STATE_TRANSITION_MODEL
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

		    if not possible_feature_mutators.is_empty then
		        possible_feature_mutators.wipe_out
		    end

		ensure then
		    config_set: config /= Void and then config.is_good
		    criteria_set: criteria /= Void
		    call_sequences_empty: call_sequences.is_empty
		    possible_feature_mutators_empty: possible_feature_mutators.is_empty
		end

	construct_behavior
			-- <Precursor>
		local
		    l_call_sequences: like call_sequences
		    l_partial_call_sequences: DS_ARRAYED_LIST[DS_ARRAYED_LIST[STRING]]
		    l_starting_state: AFX_BEHAVIOR_STATE
		    l_mutators: like possible_feature_mutators
		    l_enumeration_generator: AFX_ENUMERATION_GENERATOR[AFX_STATE_TRANSITION_SUMMARY]
		    l_mutator_sequences: DS_ARRAYED_LIST[DS_ARRAYED_LIST[AFX_STATE_TRANSITION_SUMMARY]]
		    l_destinations: DS_HASH_TABLE [AFX_BOOLEAN_STATE, STRING]
		    l_fix: AFX_STATE_TRANSITION_FIX
		    l_empty_fix: DS_ARRAYED_LIST [STRING_8]
		do
		    l_call_sequences := call_sequences

				-- add the empty call sequence as a special fix candidate
			create l_empty_fix.make (1)
			create l_fix.make (l_empty_fix)
			l_call_sequences.force_last (l_fix)

				-- starting state of fix code
		    create l_starting_state.make (Void, Void, Void, config.usable_objects)

				-- collect possible feature mutators in current `config'
		    l_mutators := possible_feature_mutators
		    l_mutators.wipe_out
			collect_possible_property_mutators

			if not l_mutators.is_empty then
			    l_enumeration_generator := Transition_enumeration_generator
				l_enumeration_generator.enumerate_all_partial (l_mutators)
				l_mutator_sequences := l_enumeration_generator.last_enumeration_list

				from l_mutator_sequences.start
				until l_mutator_sequences.after
				loop
				    l_partial_call_sequences := mutator_sequence_to_call_sequences (l_starting_state, l_mutator_sequences.item_for_iteration)

				    	-- construct a fix from each call sequence, and put the fix into `call_sequences'
				    from l_partial_call_sequences.start
				    until l_partial_call_sequences.after
				    loop
				        create l_fix.make (l_partial_call_sequences.item_for_iteration)
				        l_call_sequences.force_last (l_fix)
				        l_partial_call_sequences.forth
				    end

				    l_mutator_sequences.forth
				end
			end
		end

feature{NONE} -- Implementation

	collect_possible_property_mutators
			-- Collect all possible property mutators.
			-- For the destination property values in `config', collect all possible features that, when executed, would
			-- "set" one of those properties to its desirable value.
		local
		    l_destinations: DS_HASH_TABLE [AFX_BOOLEAN_STATE, STRING]
		    l_boolean_state: AFX_BOOLEAN_STATE
		    l_name: STRING
		    l_guided_summary_manager: like state_transition_model
		    l_class_id: INTEGER
		    l_mutators: like possible_feature_mutators
		    l_mutator: AFX_STATE_TRANSITION_SUMMARY
		    l_table_property: DS_HASH_TABLE [ TUPLE [true_summary, false_summary: AFX_FORWARD_STATE_TRANSITION_MODEL], INTEGER]
		    l_tuple_summary: TUPLE [true_summary, false_summary: AFX_FORWARD_STATE_TRANSITION_MODEL]
		    l_summary_manager: detachable AFX_FORWARD_STATE_TRANSITION_MODEL
		    l_is_possible: BOOLEAN
		    l_summary_set, l_summary_filter_set: DS_HASH_SET [AFX_STATE_TRANSITION_SUMMARY]
		    l_summary: AFX_STATE_TRANSITION_SUMMARY
		    l_size, l_property_index: INTEGER
		do
		    l_is_possible := True

			l_mutators := possible_feature_mutators
			l_guided_summary_manager := state_transition_model

			l_destinations := config.destination
			from l_destinations.start
			until l_destinations.after or not l_is_possible
			loop
				l_boolean_state := l_destinations.item_for_iteration
				l_name := l_destinations.key_for_iteration
				l_class_id := l_boolean_state.class_.class_id
				if attached l_guided_summary_manager.value (l_class_id) as lt_table_property then
					from
					    l_size := l_boolean_state.size
					    l_property_index := 0
					until
					    l_property_index = l_size
					loop
						l_summary_manager := Void
					    if l_boolean_state.properties_true.is_bit_set (l_property_index) then
					        if attached lt_table_property.value (l_property_index) as lt_tuple_summary_t then
					            l_summary_manager := lt_tuple_summary_t.true_summary
					        else
					        		-- no summarized feature set the property to true
					            l_is_possible := False
					        end
					    elseif l_boolean_state.properties_false.is_bit_set (l_property_index) then
					        if attached lt_table_property.value (l_property_index) as lt_tuple_summary_f then
					            l_summary_manager := lt_tuple_summary_f.false_summary
					        else
					        		-- no summarized feature set the property to false
					            l_is_possible := False
					        end
					    end

							-- filter out  unsuitable mutators
					    if l_summary_manager /= Void then
				            l_summary_set := l_summary_manager.to_summary_set
					        create l_summary_filter_set.make (l_summary_set.count)
				            from l_summary_set.start
				            until l_summary_set.after
				            loop
				                l_summary := l_summary_set.item_for_iteration
				                if criteria.is_suitable (l_summary.class_, l_summary.feature_, config.context_class) then
				                    l_summary_filter_set.force (l_summary)
				                end
				                l_summary_set.forth
				            end
				            l_mutators.force_last (l_summary_filter_set)
					    end

					    l_property_index := l_property_index + 1
					end
				else
						-- no summarized feature changes an object of this class
				    l_is_possible := False
				end
				l_destinations.forth
			end

			if not l_is_possible then
			    possible_feature_mutators.wipe_out
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

		        	-- each mutator can be executed using different operand-configurations, which constitutes a set
		        	-- we turn a mutator sequence into a list of set of concrete feature calls
		        l_feature_call_generator.generate_feasible_feature_call_configurations (a_starting_state, l_mutator)
		        check l_feature_call_generator.is_last_feature_call_feasible end
		        if attached l_feature_call_generator.last_feasible_configurations as lt_configurations then
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


	possible_feature_mutators: DS_ARRAYED_LIST [DS_HASH_SET [AFX_STATE_TRANSITION_SUMMARY]]
			-- Possible feature mutators, each set of mutators can change one specific property to its destination state.

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

end
