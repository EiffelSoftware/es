note
	description: "Summary description for {AFX_STATE_TRANSITION_FIX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_STATE_TRANSITION_FIX

inherit

    ANY
    	redefine
    	    out
    	end

create
    make, make_with_rank, make_from_behavior_state

feature -- Initialization

	make (a_call_sequence: DS_ARRAYED_LIST[STRING])
			-- Initialize.
		do
		    make_with_rank (a_call_sequence, 0, 0)
		end

	make_with_rank (a_call_sequence: DS_ARRAYED_LIST[STRING]; a_confidence, a_impact: INTEGER)
			-- Initialize.
		do
		    call_sequence := a_call_sequence
		    confidence_of_executability := a_confidence
		    impact_on_states := a_impact
		end

	make_from_behavior_state (a_state: AFX_BEHAVIOR_STATE)
			-- Initialize.
		do
		    call_sequence := a_state.to_call_sequence
		    confidence_of_executability := a_state.confidence_of_reachability
		    impact_on_states := a_state.distance_from_previous
		end

feature -- Access

	call_sequence: DS_ARRAYED_LIST[STRING]
			-- Feature call sequence.

feature	-- Ranking

	rank: INTEGER
			-- Rank value.
		do
		    Result := semantic_rank + syntactic_rank
		end

	syntactic_rank: INTEGER
			-- Rank value based on the syntactic changes this fix would introduce to the program.
		do
		    Result := - call_sequence.count
		end

	semantic_rank: INTEGER
			-- Rank value based on the semantics of the fix.
			-- We consider two aspects here:
			-- 	1. the confidence about the fix being executable. Ref.: `confidence_of_executability'
			--  2. the object difference between the states before and after the fix, i.e. the number of predicates whose evaluation are changed.
		do
		    Result := confidence_of_executability - impact_on_states
		end

	confidence_of_executability: INTEGER
			-- The confidence about there being no precondition violation for the features in the fix, according to the model.

	impact_on_states: INTEGER
			-- The impact of the fix on the object states, i.e. the differences between the states before and after the fix.

feature -- Status report

	out: STRING
			-- <Precursor>
		local
		    l_str: STRING
		    l_sequence: like call_sequence
		do
		    create l_str.make (128)
		    l_str.append ("%N    -- Rank: ")
		    l_str.append_integer (rank)
		    l_str.append ("%N")

		    from
			    l_sequence := call_sequence
		    	l_sequence.start
		    until
		    	l_sequence.after
		    loop
		        l_str.append (l_sequence.item_for_iteration)
		        l_str.append ("%N")
		        l_sequence.forth
		    end

		    Result := l_str
		end

end
