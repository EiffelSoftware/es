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
    make, make_with_rank

feature -- Initialization

	make (a_call_sequence: DS_ARRAYED_LIST[STRING])
			-- Initialize.
		do
		    make_with_rank (a_call_sequence, a_call_sequence.count)
		end

	make_with_rank (a_call_sequence: DS_ARRAYED_LIST[STRING]; a_rank: INTEGER)
			-- Initialize.
		require
		    rank_not_negative: a_rank >= 0
		do
		    call_sequence := a_call_sequence
		    rank := a_rank
		end

feature -- Access

	call_sequence: DS_ARRAYED_LIST[STRING]
			-- Feature call sequence.

	rank: INTEGER
			-- Rank value.

feature -- Status report

	out: STRING
			-- <Precursor>
		local
		    l_str: STRING
		    l_sequence: like call_sequence
		do
		    l_sequence := call_sequence
		    create l_str.make (128)

		    from l_sequence.start
		    until l_sequence.after
		    loop
		        l_str.append (l_sequence.item_for_iteration)
		        l_str.append ("%N")
		        l_sequence.forth
		    end
		    Result := l_str
		end

end
