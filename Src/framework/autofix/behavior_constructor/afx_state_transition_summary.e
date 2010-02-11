note
	description: "Summary description for {AFX_STATE_TRANSITION_SUMMARY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_STATE_TRANSITION_SUMMARY

inherit
    DS_ARRAYED_LIST[AFX_BOOLEAN_STATE_TRANSITION_SUMMARY]
    	redefine is_equal end

    AFX_HASH_CALCULATOR
    	undefine is_equal, copy end

create
    make_default, summarize

feature -- Initialize

	summarize (a_transition: AFX_BOOLEAN_MODEL_TRANSITION)
			-- Summarize `a_transition'.
		local
		    l_class_id, l_feature_id: INTEGER
		    l_index, l_count: INTEGER
		    l_summary: AFX_BOOLEAN_STATE_TRANSITION_SUMMARY
		    l_src, l_dest: AFX_BOOLEAN_MODEL_STATE
		do
    	    class_ := a_transition.class_
    	    feature_ := a_transition.query_model_transition.feature_call.feature_to_call

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

feature -- Access

	class_: detachable CLASS_C assign set_class
			-- Associated_class.

	feature_: detachable FEATURE_I assign set_feature
			-- Associated feature.

feature -- Setting

	set_class (a_class: CLASS_C)
			-- Set `class_' to be `a_class'.
		do
		    class_ := a_class
		end

	set_feature (a_feature: FEATURE_I)
			-- Set `feature_' to be `a_feature'.
		do
		    feature_ := a_feature
		end

feature -- Status report

	is_about_same_feature (a_summary: like Current): BOOLEAN
			-- Is current summary describing the same feature as `a_summary'?
		do
		    Result := class_.class_id = a_summary.class_.class_id
		    		and then feature_.feature_id = a_summary.feature_.feature_id
		    		and then count = a_summary.count
		end

	is_property_preserving: BOOLEAN
			-- Is the transition property preserving, i.e. is the feature a query?
		local
		    l_yes: BOOLEAN
		do
		    l_yes := True

		    from start
		    until after or not l_yes
		    loop
		        l_yes := item_for_iteration.is_property_preserving
		        forth
		    end

		    Result := l_yes
		end

	is_mutator_to (a_index: INTEGER; a_value: BOOLEAN): BOOLEAN
			-- Is the transition a mutator to the target object?
			-- To be more specific, does the transition mutate the `a_index'-th property of the target to be `a_value'?
		local
		    l_target: AFX_BOOLEAN_STATE_TRANSITION_SUMMARY
		do
		    l_target := first
		    if l_target.post_unchanged.is_bit_set (a_index) then
		        Result := False
		    elseif a_value and then l_target.post_set_false.is_bit_set (a_index)
		    		or not a_value and then l_target.post_set_true.is_bit_set (a_index)then
		        Result := False
		    else
		    	Result := True
		    end
		end

	is_equal (a_summary: like Current): BOOLEAN
			-- <Precursor>
		do
			Result := is_about_same_feature (a_summary)
		end

feature -- Update

	update (a_summary: like Current)
			-- Update `Current' to reflect also `a_summary'.
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

feature{NONE} -- Implementation

	state_transition_summary_equality_tester: AFX_STATE_TRANSITION_SUMMARY_EQUALITY_TESTER
			-- Equality tester.
		once
		    create Result
		end

feature{NONE} -- Hashable interface

	key_to_hash: DS_LINEAR[INTEGER]
			-- <Precursor>
		local
		    l_list: DS_ARRAYED_LIST[INTEGER]
		do
		    create l_list.make (count)
		    do_all (
		    	agent (a_summary: AFX_BOOLEAN_STATE_TRANSITION_SUMMARY; a_list: DS_ARRAYED_LIST[INTEGER])
		    		do a_list.force_last (a_summary.hash_code) end (?, l_list))

		    Result := l_list
		end

end
