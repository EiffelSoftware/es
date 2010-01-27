note
	description: "Summary description for {AFX_BEHAVIOR_CONSTRUCTOR_CONFIG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BEHAVIOR_CONSTRUCTOR_CONFIG

inherit

    AFX_SHARED_BOOLEAN_STATE_OUTLINE_MANAGER

create
    make

feature -- Initialization

	make (an_objects: DS_HASH_TABLE[AFX_STATE, STRING];
				a_dest_objects: DS_HASH_TABLE[AFX_STATE, STRING];
				a_context_class: CLASS_C;
				a_guidance_style: like model_guidance_style;
				a_class_set: detachable like class_set)
			-- Initialize.
		require
		    dest_subset_of_objects: -- all names in `a_dest_objects' should also be in `an_objects'
		local
		    l_class, l_outlined_class: CLASS_C
			l_type, l_outlined_type: TYPE_A
		    l_name: STRING
		    l_obj_boolean, l_dest_boolean: AFX_BOOLEAN_STATE
		    l_obj_state, l_dest_state: AFX_STATE
		    l_new_state: AFX_STATE
		    l_class_set: like class_set
		    l_classes: DS_LINEAR[CLASS_C]
		    l_found_conformance: BOOLEAN
		do
		    debug("auto-fix")
		    		-- each dest object name should also appear in `an_objects'
		    	from a_dest_objects.start
		    	until a_dest_objects.after
		    	loop
		    	    if not an_objects.has ( a_dest_objects.key_for_iteration ) then
		    	        check False end
		    	    end
		    	    a_dest_objects.forth
		    	end
		    end

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

		    context_class := a_context_class
		    model_guidance_style := a_guidance_style

			set_maximum_length (default_maximum_length)
		    is_good := True
		end

feature -- Access

	is_good: BOOLEAN
			-- Is configuration good?

	usable_objects: DS_HASH_TABLE [DS_HASH_TABLE[AFX_BOOLEAN_STATE, STRING], INTEGER]
			-- Objects can be used to accomplish the state transition.
			-- First key: class id; second key: variable name.

	destination: DS_HASH_TABLE [AFX_BOOLEAN_STATE, STRING]
			-- State requirements for the objects after transition.

	class_set: DS_HASH_SET [CLASS_C]
			-- Set of classes from which we will select the features.

	context_class: CLASS_C
			-- Context class where the generated feature call sequence would be used.

	maximum_length: INTEGER assign set_maximum_length
			-- Maximum number of feature calls in one fix.

	model_guidance_style: INTEGER assign set_model_guidance_style
			-- Style in which the model would be used to guide the fix generation.
			-- It can only take one of the following three values.

feature -- Constants

	Model_guidance_style_restriced: INTEGER = 1
			-- In restrict style, only feasible feature calls would be generated,
			-- 		where the operand objects have to satisfy the preconditions of the features;

	Model_guidance_style_relaxed: INTEGER = 2
			-- In relaxed style, infeasible feature calls are also possible to be generated,
			--		where the operand objects cannot explictly violate the preconditions of the features;

	Model_guidance_style_free: INTEGER = 3
			-- In free style, all feature call sequences are possible,
			--		since the preconditions of the features are simply ignored.

	default_maximum_length: INTEGER = 3
			-- Default maximum length.

feature{NONE} -- Implementation

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

end
