indexing
	description: "Summary description for {SCOOP_CLIENT_PRECONDITIONS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_PRECONDITIONS

inherit
	SCOOP_CLIENT_ASSERTIONS

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize
		do
			create wait_conditions.make
			create non_separate_preconditions.make
		end

feature -- Access postcondition lists

	wait_conditions: LINKED_LIST[SCOOP_CLIENT_ASSERTION_OBJECT]
		-- preconditions contain at least one separate call.

	non_separate_preconditions: LINKED_LIST[SCOOP_CLIENT_ASSERTION_OBJECT]
		-- precondition contain no separate call.

invariant
	wait_conditions_not_void: wait_conditions /= Void
	non_separate_preconditions_not_void: non_separate_preconditions /= Void

end
