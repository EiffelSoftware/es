note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	IV_CONTRACT

feature -- Visitor

	process (a_visitor: IV_CONTRACT_VISITOR)
			-- Process `a_visitor'.
		deferred
		end

end
