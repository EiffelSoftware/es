note
	description: "Summary description for {AFX_BEHAVIOR_CONSTRUCTOR_CONFIG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BEHAVIOR_CONSTRUCTOR_CONFIG

create
    make

feature -- initialize

	make (an_objects: DS_HASH_TABLE[AFX_STATE, STRING]; a_dest_objects: DS_HASH_TABLE[AFX_BOOLEAN_STATE, STRING];
				a_class_set: detachable like class_set; a_context_class: CLASS_C)
			-- initialize
		require
		    dest_subset_of_objects: -- all names in `a_dest_objects' should also be in `an_objects'
		local
		    l_class: CLASS_C
		    l_name: STRING
		    l_obj_boolean, l_dest_boolean: AFX_BOOLEAN_STATE
		    l_obj_state, l_dest_state: AFX_STATE
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

		    destination := a_dest_objects

				-- classes from which we will select the features
		    if a_class_set /= Void then
		        class_set := a_class_set
		    else
		        class_set := get_relevant_classes
		    end

		    context_class := a_context_class

			set_maximum_length (default_maximum_length)
		    is_good := True
		end

feature -- access

	is_good: BOOLEAN
			-- is configuration good?

	usable_objects: DS_HASH_TABLE [DS_HASH_TABLE[AFX_BOOLEAN_STATE, STRING], INTEGER]
			-- objects can be used to accomplish the work
			-- first key: class id; second key: variable name

	destination: DS_HASH_TABLE [AFX_BOOLEAN_STATE, STRING]
			-- boolean requirement for destination objects

	class_set: DS_HASH_SET [CLASS_C]
			-- set of classes from which we will select the features

	context_class: CLASS_C
			-- context class where the generated feature call sequence would be used

	maximum_length: INTEGER assign set_maximum_length
			-- maximum length of feature call sequences

feature{NONE} -- implementation

	add_usable_object (a_state: AFX_BOOLEAN_STATE; a_name: STRING)
			-- add an usable object to `usable_objects'
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

	get_relevant_classes: DS_HASH_SET [CLASS_C]
			-- get the set of relevant classes according to `destination' requirement
		require
		    destination_not_empty: destination /= Void and then not destination.is_empty
		local
		    l_set: DS_HASH_SET [CLASS_C]
		    l_class: CLASS_C
		    l_state: AFX_BOOLEAN_STATE
		do
		    create l_set.make (destination.count)
		    from destination.start
		    until destination.after
		    loop
		        l_state := destination.item_for_iteration
		        l_class := l_state.class_
		        l_set.force (l_class)

		        destination.forth
		    end
		    Result := l_set
		end

	set_maximum_length (a_maximum: INTEGER)
			-- set the maximum length of feature call sequences
		require
		    maximum_gt_0: a_maximum > 0
		do
		    maximum_length := a_maximum
		end

	default_maximum_length: INTEGER is 3
			-- default maximum length of feature call sequences



--	source: DS_ARRAYED_LIST[AFX_BOOLEAN_STATE]
--			-- source states

--	make (a_src, a_dest: DS_ARRAYED_LIST [AFX_STATE]; an_obj_list: DS_ARRAYED_LIST [TUPLE[state: AFX_STATE; name: STRING]];
--				a_class_set: detachable like class_set; a_context_class: CLASS_C)
--			-- initialized
--		require
--		    src_dest_same_count: a_src.count = a_dest.count
--		    obj_list_longer: a_src.count < an_obj_list.count
--		    obj_list_start_with_src: 	-- `an_obj_list' starts with `a_src'
--		local
--		    l_class: CLASS_C
--		    l_name: STRING
--		    l_src_boolean, l_dest_boolean: AFX_BOOLEAN_STATE
--		    l_src_state, l_dest_state: AFX_STATE
--		do
--		    create source.make (a_src.count)
--		    create destination.make (a_dest.count)
--		    create usable_objects.make (an_obj_list.count)

--		    	-- interpretate src's and dest's into boolean states
--		    from
--		    	a_src.start
--		    	a_dest.start
--		    	an_obj_list.start
--		    until
--		        a_src.after
--		    loop
--		        l_src_state := an_obj_list.item_for_iteration.state
--		        l_name := an_obj_list.item_for_iteration.name
--		        check l_src_state = a_src.item_for_iteration end
--		        l_dest_state := a_dest.item_for_iteration
--		        check l_src_state.class_.class_id = l_dest_state.class_.class_id end

--		        l_class := l_src_state.class_
--		        create l_src_boolean.make_for_class (l_class)
--		        l_src_boolean.interpretate (l_src_state)
--		        create l_dest_boolean.make_for_class (l_class)
--		        l_dest_boolean.interpretate (l_dest_state)

--		        source.force_last (l_src_boolean)
--		        destination.force_last (l_dest_boolean)
--		        add_usable_object (l_src_boolean, l_name)

--		        a_src.forth
--		        a_dest.forth
--		        an_obj_list.forth
--		    end

--		    	-- interpretate other usable objects into boolean states
--		    from
--		    until
--		        an_obj_list.after
--		    loop
--		        l_src_state := an_obj_list.item_for_iteration.state
--		        l_name := an_obj_list.item_for_iteration.name
--		        l_class := l_src_state.class_
--		        create l_src_boolean.make_for_class (l_class)
--		        l_src_boolean.interpretate (l_src_state)
--		        add_usable_object (l_src_boolean, l_name)
--		        an_obj_list.forth
--		    end

--				-- classes from which we will select the features
--		    if a_class_set /= Void then
--		        class_set := a_class_set
--		    else
--		        class_set := get_relevant_classes
--		    end

--		    context_class := a_context_class

--			set_maximum_length (default_maximum_length)
--		    is_good := True
--		end
invariant
end
