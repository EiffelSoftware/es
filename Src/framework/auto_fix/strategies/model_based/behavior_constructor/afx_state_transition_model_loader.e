note
	description: "Summary description for {AFX_STATE_TRANSITION_MODEL_LOADER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_STATE_TRANSITION_MODEL_LOADER

inherit
    AFX_SHARED_STATE_TRANSITION_MODEL

    EXCEPTIONS

    AFX_SHARED_SESSION

    KL_SHARED_STRING_EQUALITY_TESTER

    AFX_UTILITY

create
    make, make_with_directory

feature -- Initialization.

	make
			-- Initialize.
		do
		    set_default_model_repository_directory
		    is_successful := False
		end

	make_with_directory (a_directory: STRING)
			-- Initialize.
		do
		    create model_repository_directory.make_from_string (a_directory)
		    is_successful := False
		end

feature -- Access

	model_repository_directory: DIRECTORY_NAME assign set_model_repository_directory
			-- Directory where all models are stored.

feature -- Status report

	is_successful: BOOLEAN
			-- Is the model loaded successfully?

	is_model_repository_directory_default: BOOLEAN
			-- Is model repository directory default?

feature -- Setting

	set_model_repository_directory (a_directory: DIRECTORY_NAME)
			-- Set `model_repository_directory' to be 'a_directory'
		do
		    model_repository_directory := a_directory
		    is_model_repository_directory_default := False
		end

	set_default_model_repository_directory
			-- Set `model_repository_directory' to be default.
		do
		    create model_repository_directory.make_from_string (config.model_directory)
--			create model_repository_directory.make_from_string ("F:\EiffelStudio\ModelBased\Project\EIFGENs\project\AutoFix\model")
		    is_model_repository_directory_default := True
		end

feature -- Operation

	load_state_transition_model (
				a_objects: DS_HASH_TABLE [EPA_STATE, STRING_8];
				a_dest_objects: DS_HASH_TABLE [EPA_STATE, STRING_8])
			-- Load the state transition model.
			-- Fixme: find all relevant models from the repository and merge them
		local
		    l_model: AFX_STATE_TRANSITION_MODEL_I
		    l_name_set: DS_HASH_SET[STRING]
		    l_class_name: detachable STRING
		    l_file_name: FILE_NAME
		do
			if not is_successful then
    		    l_model := state_transition_model
    		    l_model.clear_summary

    		    	-- get class name set from destination object states
    		    create l_name_set.make (a_objects.count + a_dest_objects.count)
    		    l_name_set.set_equality_tester (string_equality_tester)
    		    class_name_from_objects (a_dest_objects, l_name_set)
    		    class_name_from_objects (a_objects, l_name_set)

    			l_class_name := first_class_with_model_available (l_model, l_name_set)
    			if l_class_name = Void then
    			    is_successful := False
    			else
        			l_file_name := file_name_from_class_name (l_model, l_class_name)
        			l_model.load_from_file (l_file_name)
        			is_successful := l_model.is_good
    			end
			end
		end

feature{NONE} -- Implementation

	class_name_from_objects (a_objects: DS_HASH_TABLE [EPA_STATE, STRING_8]; a_name_set: DS_HASH_SET[STRING])
		local
		do
		    from a_objects.start
		    until a_objects.after
		    loop
		        a_name_set.force (a_objects.item_for_iteration.class_.name)
		        a_objects.forth
		    end
		end

	first_class_with_model_available (a_model: AFX_STATE_TRANSITION_MODEL_I; a_name_list: DS_LINEAR[STRING]): detachable STRING
			-- First class name in `a_name_list' which stands for a model usable for `a_model'.
		local
		    l_repository_name: DIRECTORY_NAME
		    l_repository: DIRECTORY
		    l_model_name: STRING
		    l_model_set: DS_HASH_SET[STRING]
		do
		    l_repository_name := model_repository_directory.twin
--		    l_repository_name.extend (a_model.model_directory)

		    create l_repository.make (l_repository_name)
		    if l_repository.exists then
    		    	-- Collect the set of all models.
    		    l_repository.open_read
    		    create l_model_set.make_default
    		    l_model_set.set_equality_tester (string_equality_tester)
    			from
    				l_repository.readentry
    			until
    				l_repository.lastentry = Void
    			loop
    				l_model_name := l_repository.lastentry.twin
    				if l_model_name.ends_with (once ".xml") then
    					l_model_name.remove_tail (4)
    					l_model_set.force (l_model_name)
    				end
    				l_repository.readentry
    			end

    				-- First model in the directory
    			from a_name_list.start
    			until a_name_list.after or Result /= Void
    			loop
    			    l_model_name := a_name_list.item_for_iteration
    			    if l_model_set.has (l_model_name) then
    			        Result := l_model_name
    			    end
    			    a_name_list.forth
    			end

				if Result = Void then
    					-- Name matching failed, resort to conformance testing.
    				Result := first_conformance_model (l_model_set, a_name_list)
				end
    		end
		end

	first_conformance_model (a_model_set: DS_HASH_SET[STRING]; a_name_list: DS_LINEAR[STRING]): detachable STRING
			-- First model conformance to a class in `a_name_list'.
		local
		    l_model_types, l_class_types: DS_LINKED_LIST[TYPE_A]
		    l_model_type, l_class_type: TYPE_A
		    l_name: STRING
		do
		    create l_model_types.make
		    from a_model_set.start
		    until a_model_set.after
		    loop
		        l_name := a_model_set.item_for_iteration
		        if attached first_class_starts_with_name (l_name) as lt_class then
		            l_model_types.force_last (lt_class.actual_type.actual_type)
		        end
		        a_model_set.forth
		    end

		    create l_class_types.make
		    from a_name_list.start
		    until a_name_list.after
		    loop
		        l_name := a_name_list.item_for_iteration
		        if attached first_class_starts_with_name (l_name) as lt_class then
		            l_class_types.force_last (lt_class.actual_type.actual_type)
		        end
		        a_name_list.forth
		    end

		    from l_class_types.start
		    until l_class_types.after or Result /= Void
		    loop
		        l_class_type := l_class_types.item_for_iteration
		        from l_model_types.start
		        until l_model_types.after or Result /= Void
		        loop
		            l_model_type := l_model_types.item_for_iteration
--		            if l_model_type.is_conformant_to (l_model_type.associated_class, l_class_type) then
					if l_class_type.is_conformant_to (l_class_type.associated_class, l_model_type) then
					    	-- If the object class is conforming to the model, ...
		                Result := l_model_type.associated_class.name
		            end
		            l_model_types.forth
		        end
		        l_class_types.forth
		    end
		end

	file_name_from_class_name (a_model: AFX_STATE_TRANSITION_MODEL_I; a_class_name: STRING): FILE_NAME
			-- File name from class with `a_class_name'.
		local
		    l_dir_name: DIRECTORY_NAME
		    l_file_name: FILE_NAME
		do
		    l_dir_name := model_repository_directory.twin
--		    l_dir_name.extend (a_model.model_directory)

		    create l_file_name.make_from_string (l_dir_name)
		    l_file_name.set_file_name (a_class_name)
		    l_file_name.add_extension ("xml")
		    Result := l_file_name
		end

end
