note
	description: "Summary description for {AFX_QUERY_MODEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_QUERY_MODEL

inherit
    DS_HASH_TABLE [DS_HASH_TABLE[DS_HASH_SET[AFX_QUERY_MODEL_TRANSITION], AFX_QUERY_MODEL_STATE], AFX_QUERY_MODEL_STATE]
    	redefine
    		make_default
    	end

    AFX_SHARED_QUERY_STATE_OUTLINE_MANAGER
    	undefine
    		is_equal,
    		copy
    	end

create
    make_default

feature -- Initialization

	make_default
			-- <Precursor>
		local
		    l_manager: AFX_QUERY_STATE_OUTLINE_MANAGER
		do
		    make (512)
			set_key_equality_tester (model_state_equality_tester)

			create l_manager.make_default
			set_state_manager (l_manager)
		end

feature -- Operations

	add_transition (a_transition: AFX_QUERY_MODEL_TRANSITION)
			-- Add a new transition to the model.
		local
		    l_src, l_des: AFX_QUERY_MODEL_STATE
		    l_manager: AFX_QUERY_STATE_OUTLINE_MANAGER
		    l_table: DS_HASH_TABLE[DS_HASH_SET[AFX_QUERY_MODEL_TRANSITION], AFX_QUERY_MODEL_STATE]
		    l_set: DS_HASH_SET[AFX_QUERY_MODEL_TRANSITION]
		do
			if transition_selector.is_suitable (a_transition) then
    		    l_src := a_transition.source
    		    l_des := a_transition.destination

    		    l_manager := state_outline_manager
    		    l_manager.register (l_src)
    		    l_manager.register (l_des)


    		    if attached value (l_src) as lt_table then
    		        if attached lt_table.value (l_des) as lt_set then
    			        lt_set.force (a_transition)
    		        else
    		            	-- add transition
    		            create l_set.make_default
    		            l_set.set_equality_tester (model_transition_equality_tester)
    		            l_set.force (a_transition)
    		            lt_table.force (l_set, l_des)
    		        end
    		    else
    		        	-- add transition
    		        create l_set.make_default
    		        l_set.set_equality_tester (model_transition_equality_tester)
    		        l_set.force (a_transition)

    		        create l_table.make_default
    		        l_table.set_key_equality_tester (model_state_equality_tester)
    		        l_table.force (l_set, l_des)

    		        force (l_table, l_src)
    		    end
			end
		end

	to_transition_list: DS_LINEAR [AFX_QUERY_MODEL_TRANSITION]
			-- Return a list of all transitions.
		local
		    l_tbl_array: ARRAY [DS_HASH_TABLE [DS_HASH_SET [AFX_QUERY_MODEL_TRANSITION], AFX_QUERY_MODEL_STATE]]
		    l_set_list: DS_ARRAYED_LIST [DS_HASH_SET[AFX_QUERY_MODEL_TRANSITION]]
		    l_trans_list: DS_ARRAYED_LIST[AFX_QUERY_MODEL_TRANSITION]
		do
		    l_tbl_array := to_array
		    create l_set_list.make (l_tbl_array.count)

		    l_tbl_array.do_all (
		    		agent (a_tbl: DS_HASH_TABLE[DS_HASH_SET[AFX_QUERY_MODEL_TRANSITION], AFX_QUERY_MODEL_STATE];
		    				a_set_list: DS_ARRAYED_LIST [DS_HASH_SET[AFX_QUERY_MODEL_TRANSITION]])
		    			local
		    			    ll_set_array: ARRAY [DS_HASH_SET[AFX_QUERY_MODEL_TRANSITION]]
		    			do
		    				ll_set_array := a_tbl.to_array
		    				ll_set_array.do_all (agent a_set_list.force_last)
		    			end (?, l_set_list))

		    create l_trans_list.make (l_set_list.count)
		    l_set_list.do_all (
		    		agent (a_trans_set: DS_HASH_SET[AFX_QUERY_MODEL_TRANSITION];
		    				a_trans_list: DS_ARRAYED_LIST[AFX_QUERY_MODEL_TRANSITION])
		    			do
		    			    a_trans_set.do_all (
		    			    		agent (aa_trans: AFX_QUERY_MODEL_TRANSITION;
		    			    				aa_trans_list: DS_ARRAYED_LIST[AFX_QUERY_MODEL_TRANSITION])
		    			    			do aa_trans_list.force_last (aa_trans) end (?, a_trans_list))
		    			end (?, l_trans_list))

		    Result := l_trans_list
		end


feature{NONE} -- Implementation

	transition_selector: AFX_QUERY_MODEL_TRANSITION_SELECTOR_I
			-- Transition selector decides which transitions to be included in the model.
		once
		    create {AFX_QUERY_MODEL_TRANSITION_SELECTOR} Result
		end

	model_state_equality_tester: AFX_QUERY_MODEL_STATE_EQUALITY_TESTER
			-- Shared model state equality tester.
		once
		    create Result
		end

	model_transition_equality_tester: AFX_QUERY_MODEL_TRANSITION_EQUALITY_TESTER
			-- Shared model transition equality tester.
		once
		    create Result
		end

end
