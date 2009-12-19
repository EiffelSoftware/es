note
	description: "Summary description for {AFX_FORWARD_STATE_TRANSITION_MODEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FORWARD_STATE_TRANSITION_MODEL

inherit
    AFX_STATE_TRANSITION_MODEL_I
    	undefine is_equal, copy end

    DS_HASH_TABLE[DS_HASH_TABLE[AFX_STATE_TRANSITION_SUMMARY, INTEGER], INTEGER]
    		-- First key: `class_id'; second key `feature_id'.
    	rename
    	    make as make_hash_table,
    	    make_default as make_default_hash_table
    	end

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

	model_directory: STRING = "forward_model"
			-- <Precursor>

feature -- Operation

	optimize_model
			-- <Precursor>
		do

		end
		
	summarize_transition (a_transition: AFX_BOOLEAN_MODEL_TRANSITION)
			-- <Precursor>
		local
		    l_class_id, l_feature_id: INTEGER
		    l_index, l_count: INTEGER
		    l_summary: AFX_STATE_TRANSITION_SUMMARY
		    l_src, l_dest: AFX_BOOLEAN_MODEL_STATE
		    l_tbl: DS_HASH_TABLE[AFX_STATE_TRANSITION_SUMMARY, INTEGER]
		do
			l_class_id := a_transition.class_.class_id
			l_feature_id := a_transition.query_model_transition.feature_call.feature_to_call.feature_id
			check l_class_id /= 0 and l_feature_id /= 0 end

				-- summarize `a_transition' locally
			create l_summary.summarize (a_transition)

				-- update the global summary to reflect the local one, if the global summary is already registered
				-- otherwise, register the local summary as global
			if attached value (l_class_id) as lt_table then
				if attached lt_table.value (l_feature_id) as ll_summary then
				    ll_summary.update (l_summary)
				else
				    lt_table.force (l_summary, l_feature_id)
				end
			else
			    create l_tbl.make_default
			    l_tbl.force (l_summary, l_feature_id)
			    force (l_tbl, l_class_id)
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
		    l_tbl_array: ARRAY [DS_HASH_TABLE[AFX_STATE_TRANSITION_SUMMARY, INTEGER]]
		    l_set: DS_HASH_SET [AFX_STATE_TRANSITION_SUMMARY]
		do
		    create l_set.make (count)
		    l_tbl_array := to_array
		    l_tbl_array.do_all (
		    		agent (a_tbl: DS_HASH_TABLE[AFX_STATE_TRANSITION_SUMMARY, INTEGER];
		    					a_set: DS_HASH_SET [AFX_STATE_TRANSITION_SUMMARY])
		    			do
		    			    a_tbl.do_all (agent a_set.force)
		    			end (?, l_set))

		    Result := l_set
		end

feature -- Serialization

	save_to_file (a_file_name: STRING)
			-- <Precursor>
		local
		    l_helper: AFX_STATE_TRANSITION_MODEL_SERIALIZER
		    l_file: KL_TEXT_OUTPUT_FILE
		    l_string: STRING
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
   			    l_helper.save_summary_manager (Current, l_file)
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
   				    l_helper.load_summary_manager (l_doc, Current)
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

	error_message: STRING
			-- Last error message.

end
