note
	description: "Summary description for {AFX_BEHAVIOR_CONSTRUCTOR_CONFIG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BEHAVIOR_CONSTRUCTOR_CONFIG

create
    make

feature -- Initialization

	make (an_objects: DS_HASH_TABLE[AFX_STATE, STRING]; a_dest_objects: DS_HASH_TABLE[AFX_STATE, STRING]; a_context_class: CLASS_C;
				a_class_set: detachable like class_set)
			-- Initialize.
		require
		    dest_subset_of_objects: -- all names in `a_dest_objects' should also be in `an_objects'
		local
		    l_class: CLASS_C
		    l_name: STRING
		    l_obj_boolean, l_dest_boolean: AFX_BOOLEAN_STATE
		    l_obj_state, l_dest_state: AFX_STATE
		    l_class_set: like class_set
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
		        create l_obj_boolean.make_for_class (l_class)
		        l_obj_boolean.interpretate (l_obj_state)
		        add_usable_object (l_obj_boolean, l_name)

		        an_objects.forth
		    end

				-- interprete destination objects into boolean states
		    create l_class_set.make (a_dest_objects.count)
		    create destination.make (a_dest_objects.count)
		    from a_dest_objects.start
		    until a_dest_objects.after
		    loop
		        l_dest_state := a_dest_objects.item_for_iteration
		        l_class_set.force (l_dest_state.class_)

		        	-- {AFX_STATE} to {AFX_BOOLEAN_STATE}
		        create l_dest_boolean.make_for_class (l_dest_state.class_)
		        l_dest_boolean.interpretate (l_dest_state)
		        destination.force (l_dest_boolean, a_dest_objects.key_for_iteration)

		        a_dest_objects.forth
		    end

				-- classes from which we will select the features
		    if a_class_set /= Void then
		        class_set := a_class_set
		    else
		        class_set := l_class_set
		    end

		    context_class := a_context_class

			set_maximum_length (default_maximum_length)
		    is_good := True
		end

feature -- Access

	is_good: BOOLEAN
			-- Is configuration good?

	usable_objects: DS_HASH_TABLE [DS_HASH_TABLE[AFX_BOOLEAN_STATE, STRING], INTEGER]
			-- Objects can be used to accomplish the work.
			-- First key: class id; second key: variable name.

	destination: DS_HASH_TABLE [AFX_BOOLEAN_STATE, STRING]
			-- Boolean requirement for destination objects.

	class_set: DS_HASH_SET [CLASS_C]
			-- Set of classes from which we will select the features.

	context_class: CLASS_C
			-- Context class where the generated feature call sequence would be used.

	maximum_length: INTEGER assign set_maximum_length
			-- Maximum number of feature calls in one fix.

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

	default_maximum_length: INTEGER = 3
			-- Default maximum length.

end
