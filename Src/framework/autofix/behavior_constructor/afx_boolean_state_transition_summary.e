note
	description: "Summary description for {AFX_BOOLEAN_STATE_TRANSITION_SUMMARY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BOOLEAN_STATE_TRANSITION_SUMMARY

inherit
    AFX_HASH_CALCULATOR

create
	make_for_transition_operand, make_for_two_states, make_with_outline

feature -- Initialize

	make_for_two_states (a_src, a_dest: AFX_BOOLEAN_STATE)
			-- Initialize.
		require
		    same_boolean_state_outline: a_src.boolean_state_outline = a_dest.boolean_state_outline
    	local
    	    l_start, l_end: AFX_BOOLEAN_STATE
    	    l_size: INTEGER
    	do
    	    l_start := a_src
    	    l_end := a_dest

    	    l_size := a_src.count
    	    boolean_state_outline := a_src.boolean_state_outline
    	    class_ := l_end.class_

    	    if a_src.is_chaos then
    	        is_source_chaos := True

    	        	-- pre-condition: know nothing about pre-state
    	        create pre_true.make (l_size)
    	        create pre_false.make (l_size)

    				-- post-condition: known to be true/false
    			post_set_true := a_dest.properties_true.twin
    			post_set_false := a_dest.properties_false.twin

					-- relation between pre- and post-
				create post_negated.make (l_size)
				create post_unchanged.make (l_size)
    	    else
    	        	-- pre-condition
        	    pre_true := a_src.properties_true.twin
        	    pre_false := a_src.properties_false.twin

    				-- post-condition
    			post_set_true := a_dest.properties_true.twin
    			post_set_false := a_dest.properties_false.twin

					-- relation between pre- and post-
				post_negated := (a_src.properties_false & a_dest.properties_true) | (a_src.properties_true & a_dest.properties_false)
				post_unchanged := (a_src.properties_true & a_dest.properties_true) | (a_src.properties_false & a_dest.properties_false)
    	    end
		end

    make_for_transition_operand (a_transition: AFX_BOOLEAN_MODEL_TRANSITION; an_index: INTEGER)
    		-- Initialize.
    	require
    	    valid_index: 1 <= an_index and an_index <= a_transition.boolean_destination.count
    	local
    	    l_start, l_end: AFX_BOOLEAN_STATE
    	do
    	    l_start := a_transition.boolean_source.item(an_index)
    	    l_end := a_transition.boolean_destination.item(an_index)
    	    make_for_two_states (l_start, l_end)
    	end

    make_with_outline (a_outline: like boolean_state_outline)
    		-- Initialize.
    	do
    	    boolean_state_outline := a_outline
    	    class_ := a_outline.class_
    	    create pre_true.make (a_outline.count)
    	    create pre_false.make (a_outline.count)
    	    create post_set_true.make (a_outline.count)
    	    create post_set_false.make (a_outline.count)
    	    create post_negated.make (a_outline.count)
    	    create post_unchanged.make (a_outline.count)

--			pre_true := a_pre_true
--			pre_false := a_pre_false
--			post_set_true := a_post_set_true
--			post_set_false := a_post_set_false
--			post_negated := a_post_negated
--			post_unchanged := a_post_unchanged
--			is_source_chaos := l_is_source_chaos
    	end

feature -- Access

	class_: CLASS_C
			-- Class.

	boolean_state_outline: AFX_BOOLEAN_STATE_OUTLINE
			-- Boolean state outline related with `class_'.

	is_source_chaos: BOOLEAN assign set_source_chaos
			-- Is the source a chaos state?

feature -- State transition summary

	pre_true: AFX_BIT_VECTOR
			-- Properties ALWAYS `True' before transition.

	pre_false: AFX_BIT_VECTOR
			-- Properties ALWAYS `False' before transition.

	post_set_true: AFX_BIT_VECTOR
			-- Properties ALWAYS `True' after transition.

	post_set_false: AFX_BIT_VECTOR
			-- Properties ALWAYS `False' after transition.

	post_unchanged: AFX_BIT_VECTOR
			-- Properties ALWAYS unchanged.

	post_negated: AFX_BIT_VECTOR
			-- Properties ALWAYS negated.

feature{AFX_STATE_TRANSITION_MODEL_SERIALIZER} -- Setting

	set_source_chaos (a_flag: BOOLEAN)
			-- Set `is_source_chaos' to be `a_flag'.
		do
		    is_source_chaos := a_flag
		end

feature -- Status report

	is_combinable (a_summary: like Current): BOOLEAN
			-- Is `Current' combinable with `a_summary'?
		do
		    	-- same `boolean_state_outline' implies same class and same extractor
		    Result := boolean_state_outline = a_summary.boolean_state_outline
		end

	is_enabled_at (a_boolean_state: AFX_BOOLEAN_STATE): BOOLEAN
			-- Is `Current' enabled at `a_boolean_state'?
			-- Fixme: When model is not precise enough, it is difficult to judge.
		do
		    print ("Fixme: AFX_BOOLEAN_STATE_TRANSITION_SUMMARY.is_enabled_at%N")
		    Result := True
		end

feature -- Update summary

	update (a_summary: like Current)
			-- Update `Current' to reflect also `a_summary'.
		require
		    is_combinable: is_combinable (a_summary)
		do
		    pre_true := pre_true & a_summary.pre_true
		    pre_false := pre_false & a_summary.pre_false

		    post_set_true := post_set_true & a_summary.post_set_true
		    post_set_false := post_set_false & a_summary.post_set_false
		    post_negated := post_negated & a_summary.post_negated
		    post_unchanged := post_unchanged & a_summary.post_unchanged
		end

feature{NONE} -- Implementation

	key_to_hash: DS_LINEAR[INTEGER]
			-- <Precursor>
		local
		    l_list: DS_ARRAYED_LIST [INTEGER]
		do
		    create l_list.make (7)
		    l_list.force_last (class_.hash_code)
		    l_list.force_last (pre_true.hash_code)
		    l_list.force_last (pre_false.hash_code)
		    l_list.force_last (post_set_true.hash_code)
		    l_list.force_last (post_set_false.hash_code)
		    l_list.force_last (post_negated.hash_code)
		    l_list.force_last (post_unchanged.hash_code)

		    Result := l_list
		end
end
