note
	description: "An invariant detected by Daikon"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DKN_INVARIANT

inherit
	HASHABLE

	DEBUG_OUTPUT

feature -- Access

	text: STRING
			-- Text of current invariant
		deferred
		end
		
feature -- Status report

	is_expression: BOOLEAN
			-- Is current invariant an expression?
		do
		end

	is_one_of: BOOLEAN
			-- Is current an "one of" invariant?
		do
		end

end
