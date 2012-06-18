note
	description: "Summary description for {PS_UNRESOLVABLE_TRANSACTION_CONFLICT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_UNRESOLVABLE_TRANSACTION_CONFLICT

inherit
	PS_ERROR

feature

	description:STRING = "Unresolvable transaction conflict"
			-- A human-readable string containing an error description


	accept (a_visitor: PS_ERROR_VISITOR)
			-- `accept' function of the visitor pattern
		do
			a_visitor.visit_unresolvable_transaction_conflict(Current)
		end

end
