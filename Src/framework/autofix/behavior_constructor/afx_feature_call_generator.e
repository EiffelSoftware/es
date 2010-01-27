note
	description:
		"[
			Given a set of available objects, i.e. name-type pair, and a feature call, 
			the generator generates all possible operand compositions applicable to that feature call, based on static type checking.
			
			Note that it's the client's responsibility to make sure the feature is exported to the context class
			where the generated feature calls will be used.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FEATURE_CALL_GENERATOR

inherit
	KL_SHARED_STRING_EQUALITY_TESTER

    SHARED_TYPES

create
    default_create

feature -- Generator interface

	generate_feasible_feature_call_configurations (
				a_state: AFX_BEHAVIOR_STATE;
				a_transition: AFX_STATE_TRANSITION_SUMMARY)
			-- Generate feasible feature call configurations for `a_transition', using the objects available at `a_state',
			-- `last_feasible_configurations' contains all the feasible configurations.
			-- If no feasible configuration can be found, `last_feasible_configurations' is set to Void.
		local
		    l_options: DS_ARRAYED_LIST[DS_HASH_SET[STRING]]
		    l_enumeration_generator: like Enumeration_generator
		    l_conf_enumeration: DS_ARRAYED_LIST[DS_ARRAYED_LIST[STRING]]
		    l_conf: DS_ARRAYED_LIST[STRING]
		    l_conf_list: like last_behavior_operand_configurations
		do
		    heap := a_state.mock_heap
			transition := a_transition

		    l_options := find_suitable_objects_for_operands

		    if not l_options.is_empty and then l_options.count = a_transition.count then
		    	l_enumeration_generator := Enumeration_generator
		    	l_enumeration_generator.enumerate_fully (l_options)
		    	internal_behavior_operand_configurations := l_enumeration_generator.last_enumeration_list
		    else
		        internal_behavior_operand_configurations := Void
		    end
		end

	configurations_to_feature_calls: DS_ARRAYED_LIST [STRING]
			-- Generate feature call sequences from operand configurations, one call for each configuration.
			-- The feature should be called after `generate_feasible_feature_call_configurations'.
		require
		    is_configured: is_configured
		    last_feature_call_feasible: is_last_feature_call_feasible
		local
		    l_configurations: like last_behavior_operand_configurations
		do
		    l_configurations := last_behavior_operand_configurations
		    create Result.make (l_configurations.count)

			from l_configurations.start
			until l_configurations.after
			loop
			    Result.force_last ( construct_feature_call ( transition, l_configurations.item_for_iteration ))
			    l_configurations.forth
			end
		ensure
		    same_size: last_behavior_operand_configurations.count = Result.count
		end

	construct_feature_call (a_transition: like transition; a_config: DS_ARRAYED_LIST[STRING]): STRING
			-- Construct a call to `transition' using operands from `a_config'.
		require
		    is_configured: is_configured
		local
		    l_str: STRING
		    l_name: STRING
		    l_feature: FEATURE_I
		do
		    l_feature := a_transition.feature_
		    check l_feature.type = void_type end

		    	-- target object
		    a_config.start
		    l_str := a_config.item_for_iteration.twin
		    if not l_str.is_empty then
    		    l_str.append_character ('.')
		    end
		    a_config.forth
		    l_str.append (l_feature.feature_name)

		    if l_feature.argument_count /= 0 then
    		    check not a_config.after end

    		    l_str.append (" (")
    		    l_str.append (a_config.item_for_iteration.twin)

    		    from a_config.forth
    		    until a_config.after
    		    loop
    		    	l_str.append (", ")
    		    	l_str.append (a_config.item_for_iteration)
    		    	a_config.forth
    		    end

    		    l_str.append_character (')')
    		end

   		    check a_config.after end

		    Result := l_str
		end

feature -- Access

--	last_feasible_configurations: detachable DS_ARRAYED_LIST[DS_ARRAYED_LIST[STRING]]
--			-- Feasible operand configurations for `transition'.

	last_behavior_operand_configurations: DS_ARRAYED_LIST[DS_ARRAYED_LIST[STRING]]
			-- Possible feature operand configurations.
		do
		    if internal_behavior_operand_configurations = Void then
		        create internal_behavior_operand_configurations.make_default
		    end

		    Result := internal_behavior_operand_configurations
		end

	internal_behavior_operand_configurations: detachable DS_ARRAYED_LIST[DS_ARRAYED_LIST[STRING]]
			-- Internal storage for `last_behavior_operand_configurations'.

feature -- Status report

	is_last_feature_call_feasible: BOOLEAN
			-- Is there a feasible configuration for the last transition and state?
		do
		    Result := internal_behavior_operand_configurations /= Void and then not internal_behavior_operand_configurations.is_empty
		end

	is_configured: BOOLEAN
			-- Is the generator properly configured?
		do
		    Result := heap /= Void and then transition /= Void
		end

feature{NONE} -- Implementation

	heap: detachable DS_HASH_TABLE [DS_HASH_TABLE[AFX_BOOLEAN_STATE, STRING], INTEGER]
			-- Heap containing all the available objects for feature call operands.

	transition: detachable AFX_STATE_TRANSITION_SUMMARY
			-- Transition to be constructed.
			-- The most important information here is just the name of the feature,
			-- heanwhile, other information could be used to do more checking

	Enumeration_generator: AFX_ENUMERATION_GENERATOR [STRING]
			-- Shared enumeration generator.
		once
		    create Result
		end

	find_suitable_objects_for_operands: DS_ARRAYED_LIST[DS_HASH_SET[STRING]]
			-- Find all suitable operand combinations for the `transition'.
			-- Each hash set contains all candidates for one operand position.
			-- When there is no valid combination, an empty list will be returned.
		require
		    is_configured: is_configured
		local
		    l_transition: like transition
		    l_options: DS_ARRAYED_LIST[DS_HASH_SET[STRING]]
		    l_is_feasible: BOOLEAN
		    l_state_summary: AFX_BOOLEAN_STATE_TRANSITION_SUMMARY
		    l_class: CLASS_C
		    l_var_set: DS_HASH_SET[STRING]
		    l_name: STRING
		do
		    l_transition := transition
		    l_is_feasible := True

				-- One set of suitable operands for each operand position.
		    create l_options.make (l_transition.count)
		    from l_transition.start
		    until l_transition.after or not l_is_feasible
		    loop
		        l_state_summary := l_transition.item_for_iteration
		        l_class := l_state_summary.class_

		        create l_var_set.make_default
		        l_var_set.set_equality_tester (string_equality_tester)

		        if attached heap.value (l_class.class_id) as lt_tbl then
		            from lt_tbl.start
		            until lt_tbl.after
		            loop
		                l_name := lt_tbl.key_for_iteration

		                	-- At current stage, we collect all the objects of proper type.
		                	-- Whether they make the feature call sequence feasible is going to be checked during ranking.
						l_var_set.put (l_name)

		                lt_tbl.forth
		            end
		        end

		        if l_var_set.is_empty then
		            l_is_feasible := False
		        else
		            l_options.force_last (l_var_set)
		        end

		        l_transition.forth
		    end

		    if not l_is_feasible then
		        l_options.wipe_out
		    end

		    Result := l_options
		end

	interpretated_operand_name (a_name: STRING): STRING
			-- Operand name interpretated, i.e. "" --> "Current".
		do
		    if a_name.is_empty then
		        Result := once "Current"
		    end
		end

end
