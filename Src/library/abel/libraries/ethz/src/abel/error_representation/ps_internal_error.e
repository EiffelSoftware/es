note
	description: "Summary description for {PS_INTERNAL_ERROR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_INTERNAL_ERROR

inherit
	PS_ERROR

feature


	description:STRING = "Internal error"
			-- A human-readable string containing an error description


	accept (a_visitor: PS_ERROR_VISITOR)
			-- `accept' function of the visitor pattern
		do
			a_visitor.visit_internal_error (Current)
		end

end
