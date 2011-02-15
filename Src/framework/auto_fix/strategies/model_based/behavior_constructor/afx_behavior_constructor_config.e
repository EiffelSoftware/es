note
	description: "Summary description for {AFX_BEHAVIOR_CONSTRUCTOR_CONFIG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BEHAVIOR_CONSTRUCTOR_CONFIG

inherit
	EPA_HASH_CALCULATOR
    	redefine is_equal end

	AFX_SHARED_BEHAVIOR_FEATURE_SELECTOR_FACTORY
    	redefine is_equal end

    AFX_SHARED_BOOLEAN_STATE_OUTLINE_MANAGER
    	redefine is_equal end

create
    make

feature -- Initialization

	make (an_objects: DS_HASH_TABLE[EPA_STATE, STRING];
				a_dest_objects: DS_HASH_TABLE[EPA_STATE, STRING];
				a_context_class: CLASS_C;
				a_class_set: detachable like class_set;
				a_criteria: detachable AFX_BEHAVIOR_FEATURE_SELECTOR_I;
				a_is_forward: BOOLEAN)
			-- Initialize.
		require
		    dest_subset_of_objects: -- all names in `a_dest_objects' should also be in `an_objects'
		local
		    l_class, l_outlined_class: CLASS_C
			l_type, l_outlined_type: TYPE_A
		    l_name: STRING
		    l_obj_boolean, l_dest_boolean: AFX_BOOLEAN_STATE
		    l_obj_state, l_dest_state: EPA_STATE
		    l_new_state: EPA_STATE
		    l_class_set: like class_set
		    l_classes: DS_LINEAR[CLASS_C]
		    l_found_conformance: BOOLEAN
		do
		    	-- interpretate usable objects into boolean states
		    create usable_objects.make (an_objects.count)
		    from an_objects.start
		    until an_objects.after
		    loop
		        l_obj_state := an_objects.item_for_iteration
		        l_name := an_objects.key_for_iteration

		        l_class := l_obj_state.class_
		        l_type := l_class.actual_type.actual_type
		        if boolean_state_outline_manager.boolean_class_outline (l_class) /= Void then
		            	-- Only objects with summary information would be used in fixing.
			        create l_obj_boolean.make_for_class (l_class)
    		        l_obj_boolean.interpretate (l_obj_state)
    		        add_usable_object (l_obj_boolean, l_name)
    		    else
-- object-model conformance testing
--					l_found_conformance := False
--    		        l_classes := boolean_state_outline_manager.registered_classes
--    		        from l_classes.start
--    		        until l_classes.after or l_found_conformance
--    		        loop
--    		            l_outlined_class := l_classes.item_for_iteration
--    		            l_outlined_type := l_outlined_class.actual_type.actual_type
--    		            if l_outlined_type.is_conformant_to (l_class, l_type) then
--							create l_new_state.make_from_state (l_obj_state, l_outlined_type)
--        			        create l_obj_boolean.make_for_class (l_outlined_class)
--            		        l_obj_boolean.interpretate (l_new_state)
--            		        add_usable_object (l_obj_boolean, l_name)
--            		        l_found_conformance := True
--    		            end
--    		            l_classes.forth
--    		        end
-- object-model conformance testing
		        end

		        an_objects.forth
		    end

				-- interprete destination objects into boolean states
		    create l_class_set.make (a_dest_objects.count)
		    create destination.make (a_dest_objects.count)
		    from a_dest_objects.start
		    until a_dest_objects.after
		    loop
		        l_dest_state := a_dest_objects.item_for_iteration

		        	-- {AFX_STATE} to {AFX_BOOLEAN_STATE}
		        l_class := l_dest_state.class_
		        if boolean_state_outline_manager.boolean_class_outline (l_class) /= Void then
			        create l_dest_boolean.make_for_class (l_class)
			        l_dest_boolean.interpretate (l_dest_state)
			        destination.force (l_dest_boolean, a_dest_objects.key_for_iteration)
    		        l_class_set.force (l_class)
    		    else
-- object-model conformance testing
--					l_found_conformance := False
--    		        l_classes := boolean_state_outline_manager.registered_classes
--    		        from l_classes.start
--    		        until l_classes.after or l_found_conformance
--    		        loop
--    		            l_outlined_class := l_classes.item_for_iteration
--    		            l_outlined_type := l_outlined_class.actual_type.actual_type
--    		            if l_outlined_type.is_conformant_to (l_class, l_type) then
--							create l_new_state.make_from_state (l_dest_state, l_outlined_type)
--        			        create l_dest_boolean.make_for_class (l_outlined_class)
--            		        l_dest_boolean.interpretate (l_new_state)
--            		        destination.force (l_dest_boolean, a_dest_objects.key_for_iteration)
--            		        l_found_conformance := True
--    		            end
--    		            l_classes.forth
--    		        end
-- object-model conformance testing
			    end

		        a_dest_objects.forth
		    end

				-- Set of classes from which we will select the features.
		    if a_class_set /= Void then
		        class_set := a_class_set
		    else
		        class_set := l_class_set
		    end

			if attached a_criteria as lt_criteria then
				criteria := a_criteria
			else
			    criteria := behavior_feature_selector
			end
			is_forward := a_is_forward
		    context_class := a_context_class

			set_maximum_length (default_maximum_length)

			is_using_symbolic_execution := False
		    is_good := True
		end

feature -- Access

	is_good: BOOLEAN
			-- Is configuration good?

	is_using_symbolic_execution: BOOLEAN
			-- Is the behavior constructor using the symbolic execution?
			-- If False, we just enumerate all possible combinations of all the mutators.

	usable_objects: DS_HASH_TABLE [DS_HASH_TABLE[AFX_BOOLEAN_STATE, STRING], INTEGER]
			-- Objects can be used to accomplish the state transition.
			-- First key: class id; second key: variable name.

	destination: DS_HASH_TABLE [AFX_BOOLEAN_STATE, STRING]
			-- State requirements for the objects after transition.

	class_set: DS_HASH_SET [CLASS_C]
			-- Set of classes from which we will select the features.

	context_class: CLASS_C
			-- Context class where the generated feature call sequence would be used.

	criteria: AFX_BEHAVIOR_FEATURE_SELECTOR_I
			-- Criteria used to select the features from the classes.

	is_forward: BOOLEAN
			-- Is the construction forward?

	maximum_length: INTEGER assign set_maximum_length
			-- Maximum number of feature calls in one fix.

	model_guidance_style: INTEGER assign set_model_guidance_style
			-- Style in which the model would be used to guide the fix generation.
			-- It can only take one of the following three values.

	post_state_guided_construction_style: INTEGER assign set_post_state_guided_construction_style
			-- Style in which the behavior sequences are generated using post state guided construction.
			-- It can only take one of the following three values.

feature -- Status report

	is_equal (a_config: like Current): BOOLEAN
			-- <Precursor>
		local
		    l_class_id: INTEGER
		    l_tbl1, l_tbl2: DS_HASH_TABLE[AFX_BOOLEAN_STATE, STRING]
		do
		    Result := True
		    if is_forward /= a_config.is_forward
		    		or else is_good /= a_config.is_good
		    		or else a_config.is_using_symbolic_execution /= is_using_symbolic_execution then
		        Result := False
		    elseif maximum_length /= a_config.maximum_length
		    		or else model_guidance_style /= a_config.model_guidance_style
		    		or else post_state_guided_construction_style /= a_config.post_state_guided_construction_style then
		        Result := False
		    elseif criteria /= a_config.criteria
		    		or else context_class /= a_config.context_class then
		        Result := False
			elseif class_set /~ a_config.class_set then
			    Result := False
			elseif not is_same_object_table (a_config.destination, destination) then
				Result := False
			else
			    from usable_objects.start
			    until usable_objects.after or else not Result
			    loop
			        l_class_id := usable_objects.key_for_iteration
			        l_tbl1 := usable_objects.item_for_iteration

			        if not a_config.usable_objects.has (l_class_id) then
			            Result := False
			        else
			            l_tbl2 := a_config.usable_objects.item (l_class_id)
			            Result := is_same_object_table (l_tbl1, l_tbl2)
			        end
			        usable_objects.forth
			    end
		    end
		end

feature -- Configuration

	repeatition_per_class (a_num_of_change: INTEGER): INTEGER
			-- Num of repeatitions for a class, the object of which has `a_num_of_change' properties need to be changed.
		do
		    if post_state_guided_construction_style = Post_state_guided_construction_style_repeatition_maximum then
		        if a_num_of_change > maximum_length then
    		        Result := maximum_length
		        else
		            Result := a_num_of_change
		        end
		    elseif post_state_guided_construction_style = Post_state_guided_construction_style_repeatition_once then
		        Result := 1
		    elseif post_state_guided_construction_style = Post_state_guided_construction_style_repeatition_necessary then
		        Result := a_num_of_change
		    else
		        check False end
		    end
		end

feature -- Constants

	Model_guidance_style_relaxed: INTEGER = 0
			-- In relaxed style, infeasible feature calls are also possible to be generated,
			--		where the operand objects cannot explictly violate the preconditions of the features;

	Model_guidance_style_restriced: INTEGER = 1
			-- In restrict style, only feasible feature calls would be generated,
			-- 		where the operand objects have to satisfy the preconditions of the features;

	Model_guidance_style_free: INTEGER = 2
			-- In free style, all feature call sequences are possible,
			--		since the preconditions of the features are simply ignored.

	Post_state_guided_construction_style_repeatition_maximum: INTEGER = 0
			-- The mutators can be repeated at most for `max_num_of_repeatition_per_class' times.

	Post_state_guided_construction_style_repeatition_once: INTEGER = 1
			-- The mutators can only be used once for each class.

	Post_state_guided_construction_style_repeatition_necessary: INTEGER = 2
			-- The mutators can be repeated for as many times as necessary, i.e. at most
			-- 		one time for each property difference.

	default_maximum_length: INTEGER = 2
			-- Default maximum length.

feature -- Status set

	set_maximum_length (a_maximum: INTEGER)
			-- Set the `maximum_length' to be `a_maximum'.
		require
		    maximum_gt_0: a_maximum > 0
		do
		    maximum_length := a_maximum
		end

	set_model_guidance_style (a_guidance_style: INTEGER)
			-- Set the model guidance style.
		require
		    valid_guidance_style: a_guidance_style = Model_guidance_style_restriced |
		    					a_guidance_style = Model_guidance_style_relaxed |
		    					a_guidance_style = Model_guidance_style_free
		do
		    model_guidance_style := a_guidance_style
		end

	set_post_state_guided_construction_style (a_style: INTEGER)
			-- Set the post state guided construction style.
		require
		    style_valid: a_style = Post_state_guided_construction_style_repeatition_maximum or
		    				a_style = Post_state_guided_construction_style_repeatition_once or
		    				a_style = Post_state_guided_construction_style_repeatition_necessary
		do
		    post_state_guided_construction_style := a_style
		end

feature{NONE} -- Implementation

	is_same_object_table (a_table1, a_table2: DS_HASH_TABLE[AFX_BOOLEAN_STATE, STRING]): BOOLEAN
			-- Is the first object table same as the second?
		local
		    l_obj_name1, l_obj_name2: STRING
		    l_state1, l_state2: AFX_BOOLEAN_STATE
		do
		    if a_table1.count /= a_table2.count then
		        Result := False
		    else
		        Result := True
		        from a_table1.start
		        until a_table1.after or not Result
		        loop
		            l_obj_name1 := a_table1.key_for_iteration
		            l_state1 := a_table1.item_for_iteration

		            if a_table2.has (l_obj_name1) then
		                l_state2 := a_table2.item (l_obj_name1)

		                		-- Note: We need real object comparison here
		                if not boolean_state_equality_tester.test (l_state1, l_state2) then
		                    Result := False
		                end
		            else
		                Result := False
		            end

		            a_table1.forth
		        end
		    end
		end

	boolean_state_equality_tester: AFX_BOOLEAN_STATE_EQUALITY_TESTER
			-- Shared boolean state equality tester.
		once
		    create Result
		end

	key_to_hash: DS_LINEAR[INTEGER]
			-- <Precursor>
		local
		    l_list: DS_ARRAYED_LIST[INTEGER]
		do
		    create l_list.make (2 * destination.count)

		    	-- Hash the configuration according only to the destination objects.
		    from destination.start
		    until destination.after
		    loop
		        l_list.force_last (destination.key_for_iteration.hash_code)
		        l_list.force_last (destination.item_for_iteration.hash_code)
		        destination.forth
		    end
		    Result := l_list
		end

	add_usable_object (a_state: AFX_BOOLEAN_STATE; a_name: STRING)
			-- Add an object `a_name' with its state `a_state' to `usable_objects'.
		local
		    l_table: like usable_objects
		    l_tbl: DS_HASH_TABLE[AFX_BOOLEAN_STATE, STRING]
		    l_class: CLASS_C
		do
		    l_table := usable_objects
		    l_class := a_state.class_
		    if l_table.has (l_class.class_id) then
		        l_tbl := l_table.item (l_class.class_id)
		        check not l_tbl.has (a_name) end
		        l_tbl.force (a_state, a_name)
		    else
		        create l_tbl.make_default
		        l_tbl.put (a_state, a_name)
		        l_table.force (l_tbl, l_class.class_id)
		    end
		end

end
