note
	description: "Summary description for {AFX_BACKWARD_STATE_TRANSITION_MODEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BACKWARD_STATE_TRANSITION_MODEL

inherit
	AFX_STATE_TRANSITION_MODEL_I
		undefine is_equal, copy end

	DS_HASH_TABLE [ DS_HASH_TABLE [ TUPLE [true_summary, false_summary: AFX_FORWARD_STATE_TRANSITION_MODEL], INTEGER], INTEGER]
			-- First key: class_id; second_key: property index inside the class.
			-- Each element of the tuple contains the summary of the transitions which would make the property true/false.
		rename
		    make as make_hash_table,
		    make_default as make_default_hash_table
		end

    SHARED_WORKBENCH
    	undefine is_equal, copy end

    EXCEPTIONS
    	undefine is_equal, copy end

create
    make, make_default

feature -- Initialization

	make (n: INTEGER)
			-- Initialize.
		do
		    make_hash_table (n)
		    initialize_boolean_state_outline_manager
		    is_good := True
		end

	make_default
			-- Initialize.
		do
		    make (default_capacity)
		end

feature -- Status report

	is_good: BOOLEAN
			-- <Precursor>

	model_directory: STRING = "backward_model"
			-- <Precursor>

feature -- Operation

	optimize_model
			-- <Precursor>
		do
			remove_property_preserving_features
		end

	summarize_transition (a_transition: AFX_BOOLEAN_MODEL_TRANSITION)
			-- <Precursor>
		local
		    l_class_id: INTEGER
		    l_property_index, l_property_count: INTEGER
		    l_src, l_dest: AFX_BOOLEAN_MODEL_STATE
		    l_dest_boolean_state: AFX_BOOLEAN_STATE
		    l_true_vector, l_false_vector: AFX_BIT_VECTOR
		    l_summary: AFX_FORWARD_STATE_TRANSITION_MODEL

		do
			l_src := a_transition.boolean_source
			l_dest := a_transition.boolean_destination

			from
				l_dest.start
			until
				l_dest.after
			loop
			    l_dest_boolean_state := l_dest.item_for_iteration
			    l_class_id := l_dest_boolean_state.class_.class_id

				l_true_vector := l_dest_boolean_state.properties_true
				l_false_vector := l_dest_boolean_state.properties_false
				l_property_count := l_true_vector.count
				check
					same_size: l_property_count = l_false_vector.count
				end

				from
				    l_property_index := 0
				until
				    l_property_index = l_property_count
				loop
				    if l_true_vector.is_bit_set (l_property_index) then
				        summarize_for_property (l_class_id, l_property_index, a_transition, True)
				    elseif l_false_vector.is_bit_set (l_property_index) then
				        summarize_for_property (l_class_id, l_property_index, a_transition, False)
				    end
				    l_property_index := l_property_index + 1
				end

			    l_dest.forth
			end
		end

	clear_summary
			-- <Precursor>
		do
		    wipe_out
		end

	to_summary_set: DS_HASH_SET [AFX_STATE_TRANSITION_SUMMARY]
			-- <Precursor>
		local
		do
		end

	save_to_file (a_file_name: STRING)
			-- <Precursor>
		local
		    l_file: KL_TEXT_OUTPUT_FILE
		    l_string: STRING
		    l_helper: AFX_STATE_TRANSITION_MODEL_SERIALIZER
		    l_retried: BOOLEAN
		do
		    if not l_retried then
    			create l_file.make (a_file_name)
    			l_file.recursive_open_write
    			if not l_file.is_open_write then
    			    l_string := "Error opening file to write: "
    			    l_string.append (a_file_name)
    			    raise (l_string)
    			end

   			    create l_helper
   				l_helper.save_postcondition_guided_summary_manager (Current, l_file)
   			    l_file.close
		    else
		        print ("Error saving transition summary to disk...%N%T")
		        print (error_message)
		        print ("%N")
		    end
		rescue
		    if l_file.is_closable then
		        l_file.close
		    end

		    l_retried := True
		    error_message := developer_exception_name
		    retry
		end

	load_from_file (a_file_name: STRING)
			-- <Precursor>
		local
		    l_file: KL_TEXT_INPUT_FILE
		    l_tree_pipe: XM_TREE_CALLBACKS_PIPE
		    l_event_parser: XM_EIFFEL_PARSER
		    l_doc: XM_DOCUMENT
		    l_element: XM_ELEMENT
		    l_helper: AFX_STATE_TRANSITION_MODEL_SERIALIZER
		    l_retried: BOOLEAN
		    l_string: STRING
		do
		    if not l_retried then
    			create l_file.make (a_file_name)
    		    l_file.open_read
    		    if not l_file.is_open_read then
    		        l_string := "Error opening file: "
    		        l_string.append (a_file_name)
    			    raise (l_string)
    			end

   				create l_event_parser.make
   				create l_tree_pipe.make
   				l_event_parser.set_callbacks (l_tree_pipe.start)
   				l_event_parser.parse_from_stream (l_file)
   				if l_tree_pipe.error.has_error then
   				    raise (l_tree_pipe.last_error)
   				else
   				    l_doc := l_tree_pipe.document
   				    create l_helper
   				    l_helper.load_postcondition_guided_summary_manager (l_doc, Current)
   				    l_file.close
   				end
		    else
		        print ("Error loading transition summary from disk...%N%T")
		        print (error_message)
		        print ("%N")
		    end
		rescue
		    if l_file.is_closable then
		        l_file.close
		    end

		    error_message := developer_exception_name
		    is_good := False
		    l_retried := True
		    retry
		end

feature{NONE} -- Implementation

	remove_property_preserving_features
			-- Remove property preserving features from the model.
		local
		    l_class_id: INTEGER
		    l_class: CLASS_C
		    l_property_index: INTEGER
		    l_table: DS_HASH_TABLE [ TUPLE [true_summary, false_summary: AFX_FORWARD_STATE_TRANSITION_MODEL], INTEGER]
		    l_true_summary, l_false_summary: AFX_FORWARD_STATE_TRANSITION_MODEL
		do
			from start
			until after
			loop
			    l_class_id := key_for_iteration
			    l_table := item_for_iteration
			    from l_table.start
			    until l_table.after
			    loop
			        l_property_index := l_table.key_for_iteration
			        l_true_summary := l_table.item_for_iteration.true_summary
			        l_false_summary := l_table.item_for_iteration.false_summary

			        remove_property_preserving_feature_from_summary (l_true_summary, l_class_id, l_property_index)
			        remove_property_preserving_feature_from_summary (l_false_summary, l_class_id, l_property_index)

			        l_table.forth
			    end
			    forth
			end
		end

	remove_property_preserving_feature_from_summary (a_summary: AFX_FORWARD_STATE_TRANSITION_MODEL; a_class_id, a_property_index: INTEGER)
			-- Remove property preserving feature from summary.
		local
		    l_class_id, l_feature_id: INTEGER
		    l_feature_id_set: DS_HASH_SET [INTEGER]
		    l_table: DS_HASH_TABLE [AFX_STATE_TRANSITION_SUMMARY, INTEGER_32]
		    l_summary: AFX_STATE_TRANSITION_SUMMARY
		    l_is_property_preserving: BOOLEAN
		    l_state_summary: AFX_BOOLEAN_STATE_TRANSITION_SUMMARY
		do
		    create l_feature_id_set.make_default

		    from a_summary.start
		    until a_summary.after
		    loop
		        l_class_id := a_summary.key_for_iteration
		        l_table := a_summary.item_for_iteration

		        	-- find out the list of all ids of the features that are property preserving, put the
		        	-- ids into `l_feature_id_set'.
		        l_feature_id_set.wipe_out
		        from l_table.start
		        until l_table.after
		        loop
		            l_feature_id := l_table.key_for_iteration
		            l_summary := l_table.item_for_iteration

		            l_is_property_preserving := True
		            from l_summary.start
		            until l_summary.after
		            loop
		                l_state_summary := l_summary.item_for_iteration
		                if l_state_summary.class_.class_id = a_class_id and then not l_state_summary.post_unchanged.is_bit_set (a_property_index) then
		                    l_is_property_preserving := False
		                end
		                l_summary.forth
		            end

		            if l_is_property_preserving = True then
		                l_feature_id_set.force (l_feature_id)
		            end

		            l_table.forth
		        end

		        from l_feature_id_set.start
		        until l_feature_id_set.after
		        loop
		            l_feature_id := l_feature_id_set.item_for_iteration
		            l_table.remove (l_feature_id)
		            l_feature_id_set.forth
		        end

		        a_summary.forth
		    end
		end

	summarize_for_property (a_class_id, a_property_index: INTEGER; a_transition: AFX_BOOLEAN_MODEL_TRANSITION; a_is_true: BOOLEAN)
			-- Summarize the pre- and post- state of `a_transition', depending on its influence on the `a_property_index'-th property of `a_class_id'
		local
		    l_new_table_property: DS_HASH_TABLE [ TUPLE [true_summary, false_summary: AFX_FORWARD_STATE_TRANSITION_MODEL], INTEGER]
		    l_tuple_property: TUPLE [true_summary, false_summary: AFX_FORWARD_STATE_TRANSITION_MODEL]
		    l_summary_manager, l_true_manager, l_false_manager: AFX_FORWARD_STATE_TRANSITION_MODEL
		do
		    if attached value (a_class_id) as l_table_property then
		    	if attached l_table_property.value (a_property_index) as l_tuple_manager then
    		        if a_is_true then
    		            l_summary_manager := l_tuple_manager.true_summary
    		        else
    		            l_summary_manager := l_tuple_manager.false_summary
    		        end
    		    else
    		        create l_true_manager.make_default
    		        create l_false_manager.make_default
    		        l_table_property.force ([l_true_manager, l_false_manager], a_property_index)

    		        if a_is_true then
    		            l_summary_manager := l_true_manager
    		        else
    		            l_summary_manager := l_false_manager
    		        end
    		    end
		    else
		        create l_true_manager.make_default
		        create l_false_manager.make_default
		        create l_new_table_property.make_default
		        l_new_table_property.force ([l_true_manager, l_false_manager], a_property_index)
		        force (l_new_table_property, a_class_id)

		        if a_is_true then
		            l_summary_manager := l_true_manager
		        else
		            l_summary_manager := l_false_manager
		        end
		    end

		    l_summary_manager.summarize_transition (a_transition)
		end

feature{NONE} -- Implementation

	error_message: STRING
			-- Last error message.

end
