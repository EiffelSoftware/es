note
	description: "Summary description for {AFX_SHARED_BEHAVIOR_CONSTRUCTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SHARED_BEHAVIOR_CONSTRUCTOR

create
    default_create

feature -- Query

	state_transitions_from_model (a_objects: DS_HASH_TABLE [AFX_STATE, STRING_8];
					a_dest_objects: DS_HASH_TABLE [AFX_STATE, STRING_8];
					a_context_class: CLASS_C;
					a_class_set: detachable DS_HASH_SET [CLASS_C];
					a_criteria: detachable AFX_BEHAVIOR_FEATURE_SELECTOR_I): DS_ARRAYED_LIST [AFX_STATE_TRANSITION_FIX]
			-- Query the call sequences transit `a_objects' to `a_dest_objects'.
		local
		    l_constructor: AFX_BEHAVIOR_CONSTRUCTOR_I
		do
			l_constructor := prepare_constructor (a_objects, a_dest_objects, a_context_class, a_class_set, a_criteria)
   			l_constructor.construct_behavior
   			Result := l_constructor.call_sequences
		end

feature -- Storage

	constructor_list: DS_ARRAYED_LIST[AFX_BEHAVIOR_CONSTRUCTOR_I]
			-- List of available behavior constructor.
		once
		    create Result.make (2)
		end

feature{NONE} -- Implementation

	prepare_constructor (a_objects: DS_HASH_TABLE [AFX_STATE, STRING_8];
					a_dest_objects: DS_HASH_TABLE [AFX_STATE, STRING_8];
					a_context_class: CLASS_C;
					a_class_set: detachable DS_HASH_SET [CLASS_C];
					a_criteria: detachable AFX_BEHAVIOR_FEATURE_SELECTOR_I): AFX_BEHAVIOR_CONSTRUCTOR_I
			-- Prepare constructors for the construction.
		local
		    l_constructor_list: like constructor_list
			l_constructor: AFX_BEHAVIOR_CONSTRUCTOR_I
			l_loader: AFX_STATE_TRANSITION_MODEL_LOADER
		do
		    l_constructor_list := constructor_list
		    if l_constructor_list.count = 0 then
		        create {AFX_BACKWARD_BEHAVIOR_CONSTRUCTOR}l_constructor.make
		        l_constructor_list.force_last (l_constructor)

    			create l_loader.make
    			l_loader.load_state_transition_model (l_constructor, a_objects, a_dest_objects)
    			if not l_loader.is_successful then
    			    check error_in_model_loading: False end
    			end
		        l_constructor.reset_constructor (a_objects, a_dest_objects, a_context_class, a_class_set, a_criteria)
    		else
    		    l_constructor := l_constructor_list.first
		        l_constructor.reset_constructor (a_objects, a_dest_objects, a_context_class, a_class_set, a_criteria)
		    end
		    Result := l_constructor
		end

---- Model deserialization
--			l_factory: AFX_BEHAVIOR_CONSTRUCTOR_FACTORY
--			l_constructor: AFX_BEHAVIOR_CONSTRUCTOR_I
--			l_loader: AFX_STATE_TRANSITION_MODEL_LOADER
---- Model deserialization
--			create l_factory
--			if l_using_forward_model then
--    			l_constructor := l_factory.create_forward_constructor
--    		else
--    			l_constructor := l_factory.create_backward_constructor
--			end
--			l_constructor.reset_constructor (prepare_available_objects, prepare_destination_requirement, last_list_class, Void, Void)

--			create l_loader.make_with_directory ("F:\state_log")
--			l_loader.load_state_transition_model (l_constructor)
--			if l_loader.is_successful and then l_constructor.state_transition_model.is_good then
--				l_constructor.state_transition_model.save_to_file ("F:\state_log\output.xml")
--    			l_constructor.construct_behavior
--    			if not l_constructor.call_sequences.is_empty then
--    				print (l_constructor.call_sequences_as_string)
--    			end
--    		else
--    		    print ("Error loading the model.")
--			end
--feature -- Experiment

--	prepare_available_objects: DS_HASH_TABLE[AFX_STATE, STRING]
--			-- prepare available objects which can be used for behavior construction
--		local
--		    l_query_name, l_value: STRING
--		    l_query_value_table: HASH_TABLE [STRING, STRING]
--		    l_state: AFX_STATE
--		    l_class: CLASS_C
--		do
--		    create Result.make_default

--		    create l_query_value_table.make (5)
--		    l_query_value_table.force ("False", "before")
--		    l_query_value_table.force ("False", "off")
--		    l_query_value_table.force ("0", "index")
--		    l_query_value_table.force ("False", "is_first")
--		    l_query_value_table.force ("False", "after")
--		    l_query_value_table.force ("False", "is_last")

--			check last_list_class /= Void end
--		    create l_state.make_from_object_state (l_query_value_table, last_list_class, Void)

--		    Result.force (l_state, "l_list")
--		end

--	prepare_destination_requirement: DS_HASH_TABLE[AFX_STATE, STRING]
--			-- prepare the requirement for destination objects
--		local
--		    l_query_name, l_value: STRING
--		    l_query_value_table: HASH_TABLE [STRING, STRING]
--		    l_state: AFX_STATE
--		    l_class: CLASS_C
--		do
--		    create Result.make_default

--		    create l_query_value_table.make (5)
--		    l_query_name := "before"
--		    l_value := "True"
--		    l_query_value_table.force (l_value, l_query_name)

--		    check last_list_class /= Void end
--		    create l_state.make_from_object_state (l_query_value_table, last_list_class, Void)

--		    Result.force (l_state, "l_list")
--		end


end
