note
	description: "Summary description for {AFX_FIX_TO_FAULT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_FIX_TO_FAULT

inherit
	AFX_FIX_ID_SERVER

feature{NONE}

	make_general
			--
		do
			id := next_fix_id
		end

feature -- Access

	id: INTEGER
			-- ID of the fix.

	is_valid: BOOLEAN assign set_valid
			-- Is the fix valid?

	ranking: REAL assign set_ranking
			-- Ranking of the fix.

	signature: STRING
			-- Signature of the fix.
		deferred
		end

	formatted_output: STRING
			-- 
		deferred
		end

feature -- Set

	set_valid (a_flag: BOOLEAN)
		do
			is_valid := a_flag
		end

	set_ranking (a_ranking: REAL)
		do
			ranking := a_ranking
		end


end
