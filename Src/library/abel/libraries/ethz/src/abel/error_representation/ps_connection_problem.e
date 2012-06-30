note
	description: "Summary description for {PS_CONNECTION_PROBLEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_CONNECTION_PROBLEM

inherit
	PS_ERROR

feature
	description:STRING = "Connection lost"
			-- A human-readable string containing an error description


	accept (a_visitor: PS_ERROR_VISITOR)
			-- `accept' function of the visitor pattern
		do
			a_visitor.visit_connection_problem (Current)
		end


end
