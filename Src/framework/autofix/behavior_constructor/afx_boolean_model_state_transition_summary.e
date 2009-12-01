note
	description: "Summary description for {AFX_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY

inherit
    DS_ARRAYED_LIST[AFX_BOOLEAN_STATE_TRANSITION_SUMMARY]

create
    summarize

feature -- initialize

	summarize (a_transition: AFX_BOOLEAN_MODEL_TRANSITION)
			-- draw a summary from `a_transition'
		local
		    l_class_id, l_feature_id: INTEGER
		    l_index, l_count: INTEGER
		    l_summary: AFX_BOOLEAN_STATE_TRANSITION_SUMMARY
		    l_src, l_dest: AFX_BOOLEAN_MODEL_STATE
		do
    	    class_ := a_transition.class_
    	    feature_ := a_transition.query_model_transition.feature_call.feature_to_call
    	    is_creation := a_transition.is_object_creation

			l_src := a_transition.boolean_source
			l_dest := a_transition.boolean_destination

				-- make space for `l_count' state transition summaries
			l_count := l_src.count
			check l_count = l_dest.count end
			make (l_count)

			from l_index := 1
			until l_index > l_count
			loop
			    create l_summary.make_for_transition_operand (a_transition, l_index)
			    force_last (l_summary)
			    l_index := l_index + 1
			end
		end

feature -- access

	class_: CLASS_C
			-- associated_class

	feature_: FEATURE_I
			-- associated feature

feature -- status report

	is_creation: BOOLEAN
			-- does this transition correspond to a creation

	is_about_same_feature (a_summary: like Current): BOOLEAN
			-- is current summary describing the same feature as `a_summary'?
		do
		    Result := class_.class_id = a_summary.class_.class_id
		    		and then feature_.feature_id = a_summary.feature_.feature_id
		    		and then count = a_summary.count
		end

feature -- update

	update (a_summary: like Current)
			-- update `Current' to reflect also `a_summary'
		require
		    is_about_same_feature: is_about_same_feature (a_summary)
		local
		    l_index, l_count: INTEGER
		    l_summary1, l_summary2: AFX_BOOLEAN_STATE_TRANSITION_SUMMARY
		do
		    from
    		    l_count := count
    		    l_index := 1
		    until
		        l_index > l_count
		    loop
		        l_summary1 := item (l_index)
		        l_summary2 := a_summary.item (l_index)
		        l_summary1.update (l_summary2)

		        l_index := l_index + 1
		    end
		end

end
