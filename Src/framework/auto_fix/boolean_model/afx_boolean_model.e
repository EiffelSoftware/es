note
	description: "Summary description for {AFX_BOOLEAN_MODEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BOOLEAN_MODEL

inherit
    DS_HASH_TABLE [DS_HASH_TABLE[DS_HASH_SET[AFX_BOOLEAN_MODEL_TRANSITION], AFX_BOOLEAN_MODEL_STATE], AFX_BOOLEAN_MODEL_STATE]
    	redefine
    		make,
    		make_default
    	end

create
    make, make_default, make_from_query_model

feature -- Initialization

	make (a_size: INTEGER)
			-- <Precursor>
		do
			Precursor (a_size)
			set_key_equality_tester (boolean_model_state_equality_tester)
		end

	make_default
			-- <Precursor>
		do
		    Precursor
			set_key_equality_tester (boolean_model_state_equality_tester)
		end

	make_from_query_model (a_query_model: AFX_QUERY_MODEL)
			-- initialize
		local
		    l_trans_list: DS_LINEAR [AFX_QUERY_MODEL_TRANSITION]
		do
		    make (a_query_model.count)
		    l_trans_list := a_query_model.to_transition_list
		    l_trans_list.do_all (
		    		agent (a_trans: AFX_QUERY_MODEL_TRANSITION; a_boolean_model: AFX_BOOLEAN_MODEL)
		    			local
		    			    l_boolean_trans: AFX_BOOLEAN_MODEL_TRANSITION
		    			do
		    			    create l_boolean_trans.make (a_trans)
		    			    a_boolean_model.add_transition (l_boolean_trans)
		    			end (?, Current))
		end

feature -- Operations

	add_transition (a_transition: AFX_BOOLEAN_MODEL_TRANSITION)
			-- Add a new transition to the model.
		local
		    l_src, l_des: AFX_BOOLEAN_MODEL_STATE
		    h_table: DS_HASH_TABLE[DS_HASH_SET[AFX_BOOLEAN_MODEL_TRANSITION], AFX_BOOLEAN_MODEL_STATE]
		    h_set: DS_HASH_SET[AFX_BOOLEAN_MODEL_TRANSITION]
		do
		    l_src := a_transition.boolean_source
		    l_des := a_transition.boolean_destination

		    if attached value(l_src) as lt_table then
		        if attached lt_table.value (l_des) as lt_set then
			        lt_set.force (a_transition)
		        else
		            	-- add transition
		            create h_set.make_default
		            h_set.set_equality_tester (boolean_model_transition_equality_tester)
		            h_set.force (a_transition)
		            lt_table.force (h_set, l_des)
		        end
		    else
		        	-- add transition
		        create h_set.make_default
		        h_set.set_equality_tester (boolean_model_transition_equality_tester)
		        h_set.force (a_transition)

		        create h_table.make_default
		        h_table.set_key_equality_tester (boolean_model_state_equality_tester)
		        h_table.force (h_set, l_des)

		        force (h_table, l_src)
		    end
		end

	to_transition_list: DS_LINEAR [AFX_BOOLEAN_MODEL_TRANSITION]
			-- Return the list of all transitions.
		local
		    l_tbl_array: ARRAY [DS_HASH_TABLE [DS_HASH_SET [AFX_BOOLEAN_MODEL_TRANSITION], AFX_BOOLEAN_MODEL_STATE]]
		    l_set_list: DS_ARRAYED_LIST [DS_HASH_SET[AFX_BOOLEAN_MODEL_TRANSITION]]
		    l_trans_list: DS_ARRAYED_LIST[AFX_BOOLEAN_MODEL_TRANSITION]
		do
		    l_tbl_array := to_array
		    create l_set_list.make (l_tbl_array.count)

		    l_tbl_array.do_all (
		    		agent (a_tbl: DS_HASH_TABLE[DS_HASH_SET[AFX_BOOLEAN_MODEL_TRANSITION], AFX_BOOLEAN_MODEL_STATE];
		    				a_set_list: DS_ARRAYED_LIST [DS_HASH_SET[AFX_BOOLEAN_MODEL_TRANSITION]])
		    			local
		    			    ll_set_array: ARRAY [DS_HASH_SET[AFX_BOOLEAN_MODEL_TRANSITION]]
		    			do
		    				ll_set_array := a_tbl.to_array
		    				ll_set_array.do_all (agent a_set_list.force_last)
		    			end (?, l_set_list))

		    create l_trans_list.make (l_set_list.count)
		    l_set_list.do_all (
		    		agent (a_trans_set: DS_HASH_SET[AFX_BOOLEAN_MODEL_TRANSITION];
		    				a_trans_list: DS_ARRAYED_LIST[AFX_BOOLEAN_MODEL_TRANSITION])
		    			do
		    			    a_trans_set.do_all (
		    			    		agent (aa_trans: AFX_BOOLEAN_MODEL_TRANSITION;
		    			    				aa_trans_list: DS_ARRAYED_LIST[AFX_BOOLEAN_MODEL_TRANSITION])
		    			    			do aa_trans_list.force_last (aa_trans) end (?, a_trans_list))
		    			end (?, l_trans_list))

		    Result := l_trans_list
		end

feature{NONE} -- Implementation

	boolean_model_state_equality_tester: AFX_BOOLEAN_MODEL_STATE_EQUALITY_TESTER
			-- Shared boolean model state equality tester.
		once
		    create Result
		end

	boolean_model_transition_equality_tester: AFX_BOOLEAN_MODEL_TRANSITION_EQUALITY_TESTER
			-- Shared boolean model transition equality tester
		once
		    create Result
		end

end
