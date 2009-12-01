note
	description: "Summary description for {AFX_BOOLEAN_STATE_TRANSITION_SUMMARY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BOOLEAN_STATE_TRANSITION_SUMMARY

create
	make_for_transition_operand, make_for_two_states

feature -- initialize

	make_for_two_states (a_src, a_dest: AFX_BOOLEAN_STATE)
			-- initialize
		require
		    states_from_same_boolean_state_outline: a_src.boolean_state_outline = a_dest.boolean_state_outline
    	local
    	    l_start, l_end: AFX_BOOLEAN_STATE
    	    l_size: INTEGER
    	do
    	    l_start := a_src
    	    l_end := a_dest

    	    l_size := a_src.count
    	    boolean_state_outline := a_src.boolean_state_outline

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

--				post_negated_true := a_src.properties_false & a_dest.properties_true
--				post_negated_false := a_src.properties_true & a_dest.properties_false
--				post_unchanged_true := a_src.properties_true & a_dest.properties_true
--				post_unchanged_false := a_src.properties_false & a_dest.properties_false
--				create post_negated_true.make (l_size)
--				create post_negated_false.make (l_size)
--				create post_unchanged_true.make (l_size)
--				create post_unchanged_false.make (l_size)
--			post_unknown := a_dest.properties_random.twin
		end

    make_for_transition_operand (a_transition: AFX_BOOLEAN_MODEL_TRANSITION; an_index: INTEGER)
    		-- initialize
    	require
    	    valid_index: 1 <= an_index and an_index <= a_transition.boolean_destination.count
    	local
    	    l_start, l_end: AFX_BOOLEAN_STATE
    	do
    	    l_start := a_transition.boolean_source.item(an_index)
    	    l_end := a_transition.boolean_destination.item(an_index)
    	    make_for_two_states (l_start, l_end)
    	end

feature -- access

	class_: CLASS_C
			-- associated_class

	boolean_state_outline: AFX_BOOLEAN_STATE_OUTLINE
			-- boolean outline related with this state transition summary

	is_source_chaos: BOOLEAN
			-- is the source state a chaos?

feature -- state transition summary

	pre_true: AFX_BIT_VECTOR
			-- predicates ALWAYS evaluated `True' before feature call

	pre_false: AFX_BIT_VECTOR
			-- predicates ALWAYS evaluated `False' before feature call

	post_set_true: AFX_BIT_VECTOR
			-- predicates ALWAYS set `True' after feature call

	post_set_false: AFX_BIT_VECTOR
			-- predicates ALWAYS set `False' after feature call

	post_negated: AFX_BIT_VECTOR
			-- predicates ALWAYS negated

	post_unchanged: AFX_BIT_VECTOR
			-- predicates ALWAYS unchanged

--	post_negated_true: AFX_BIT_VECTOR
--			-- predicates ALWAYS negated to be `True' after feature call

--	post_negated_false: AFX_BIT_VECTOR
--			-- predicates ALWAYS negated to be `False' after feature call

--	post_unchanged_true: AFX_BIT_VECTOR
--			-- predicates ALWAYS remain `True' after feature call

--	post_unchanged_false: AFX_BIT_VECTOR
--			-- predicates ALWAYS remain `False' after feature call

--	post_unknown: AFX_BIT_VECTOR
--			-- predicates MAY/MAY NOT be changed

feature -- status report

	is_combinable (a_summary: like Current): BOOLEAN
			-- is current summary combinable with `a_summary'?
		do
		    	-- same `boolean_state_outline' implies same class and same extractor
		    Result := boolean_state_outline = a_summary.boolean_state_outline
		end

feature -- update summary

	update (a_summary: like Current)
			-- update current summary to reflect also `a_summary'
		require
		    is_combinable: is_combinable (a_summary)
--		local
--		    l_pre_true, l_pre_false, l_post_set_true, l_post_set_false, l_post_negated_true, l_post_negated_false: like post_negated_true
--		    l_post_unchanged_true, l_post_unchanged_false, l_post_unknown: like post_negated_true
--		    l_pre_set, l_pre_cleared, l_negated, l_unchanged, l_unknown, l_set, l_clear: like post_negated_true
		do
		    pre_true := pre_true & a_summary.pre_true
		    pre_false := pre_false & a_summary.pre_false

		    post_set_true := post_set_true & a_summary.post_set_true
		    post_set_false := post_set_false & a_summary.post_set_false
		    post_negated := post_negated & a_summary.post_negated
		    post_unchanged := post_unchanged & a_summary.post_unchanged

--		    post_negated_true := post_negated_true & a_summary.post_negated_true
--		    post_negated_false := post_negated_false & a_summary.post_negated_false
--		    post_unchanged_true := post_unchanged_true & a_summary.post_unchanged_true
--		    post_unchanged_false := post_unchanged_false & a_summary.post_unchanged_false
--		    post_unknown := post_unknown | a_summary.post_unknown
		end

--		    	-- intersection of the two `pre_true's
--		    l_pre_set := pre_true & a_summary.pre_true

--		    	-- intersection of the two `pre_false's
--		    l_pre_cleared := pre_false & a_summary.pre_false

--		    	-- intersection of the two `post_negated_true's
--		    l_negated := post_negated_true & a_summary.post_negated_true

--		    	-- intersection of the two `post_unchanged_false's
--		    l_unchanged := post_unchanged_false & a_summary.post_unchanged_false

--				-- union of the two `unknown's
--		    l_unknown := (l_negated | l_unchanged).bit_not

--				-- intersection of the two `post_set_true's
--			l_set := post_set_true & a_summary.post_set_true

--				-- intersection of the two `post_set_false's
--			l_clear := post_set_false & a_summary.post_set_false

--				-- no intersection between `post_set_true' and `post_set_false'
--			check (l_set & l_clear).count_of_set_bits = 0 end
--				-- no intersection between `post_negated_true' and `post_unchanged_false'
--		    check (l_negated & l_unchanged).count_of_set_bits = 0 end
--		    	-- `old unknown' and `a_summary.unknown' are subsets of `unknown'
--		    check ((unknown | a_summary.unknown).set_minus(l_unknown)).count_of_set_bits = 0 end

--			pre_true := l_pre_set
--			pre_false := l_pre_cleared
--		    post_negated_true := l_negated
--		    post_unchanged_false := l_unchanged
--		    unknown := l_unknown
--		    post_set_true := l_set
--		    post_set_false := l_clear

--	feature_: FEATURE_I
--			-- associated feature

--	boolean_state_outline: AFX_BOOLEAN_STATE_OUTLINE
--			-- boolean state outline

end
