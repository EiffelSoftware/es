note
	description: "Summary description for {AFX_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY_MANAGER

inherit
    AFX_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY_MANAGER_I
    	undefine is_equal, copy end

    DS_HASH_TABLE[DS_HASH_TABLE[AFX_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY, INTEGER], INTEGER]
    		-- use `class_id' as key, and `feature_id' as sub-key

create
    make, make_default

feature -- operation

	summarize_transition (a_transition: AFX_BOOLEAN_MODEL_TRANSITION)
			-- <Precursor>
		local
		    l_class_id, l_feature_id: INTEGER
		    l_index, l_count: INTEGER
		    l_summary: AFX_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY
		    l_src, l_dest: AFX_BOOLEAN_MODEL_STATE
		    l_tbl: DS_HASH_TABLE[AFX_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY, INTEGER]
		do
			l_class_id := a_transition.class_.class_id
			l_feature_id := a_transition.query_model_transition.feature_call.feature_to_call.feature_id
			check l_class_id /= 0 and l_feature_id /= 0 end

				-- summarize `a_transition' locally
			create l_summary.summarize (a_transition)

				-- update the global summary to reflect the local one, if the global summary is already registered
				-- otherwise, register the local summary as global
			if attached item (l_class_id) as l_table then
				if attached l_table.item (l_feature_id) as ll_summary then
				    ll_summary.update (l_summary)
				else
				    l_table.force (l_summary, l_feature_id)
				end
			else
			    create l_tbl.make_default
			    l_tbl.force (l_summary, l_feature_id)
			    force (l_tbl, l_class_id)
			end
		end

	to_summary_list: DS_ARRAYED_LIST [AFX_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY]
			-- <Precursor>
		local
		    l_tbl_array: ARRAY [DS_HASH_TABLE[AFX_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY, INTEGER]]
		    l_array: DS_ARRAYED_LIST [AFX_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY]
		do
		    create l_array.make (count)
		    l_tbl_array := to_array
		    l_tbl_array.do_all (
		    		agent (a_tbl: DS_HASH_TABLE[AFX_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY, INTEGER];
		    					an_array: DS_ARRAYED_LIST [AFX_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY])
		    			do
		    			    a_tbl.do_all (agent an_array.force_last)
		    			end (?, l_array))
		end


end
