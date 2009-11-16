indexing
	description: "Summary description for {SCOOP_CLIENT_POSTCONDITIONS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_POSTCONDITIONS

inherit
	SCOOP_CLIENT_ASSERTIONS

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize
		do
			create immediate_postconditions.make
			create non_separate_postconditions.make
			create separate_postconditions.make
		end

feature -- Access postcondition lists

	immediate_postconditions: LINKED_LIST[SCOOP_CLIENT_ASSERTION_OBJECT]
		-- postconditions contain reference to 'old' or 'Result'

	non_separate_postconditions: LINKED_LIST[SCOOP_CLIENT_ASSERTION_OBJECT]
		-- postcondition contains at least one non separate call
		-- and no reference to 'old' or 'Result'

	separate_postconditions: LINKED_LIST[SCOOP_CLIENT_ASSERTION_OBJECT]
		-- postcondition contain no non-separate calls
		-- and no reference to 'old' or 'Result'

invariant
	immediate_postconditions_not_void: immediate_postconditions /= Void
	non_separate_postconditions_not_void: non_separate_postconditions /= Void
	separate_postconditions_not_void: separate_postconditions /= Void

end
