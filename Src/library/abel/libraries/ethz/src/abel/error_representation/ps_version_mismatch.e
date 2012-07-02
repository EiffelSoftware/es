note
	description: "Summary description for {PS_VERSION_MISMATCH}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_VERSION_MISMATCH

inherit
	PS_ERROR

feature

	description:STRING = "Version mismatch between stored and current object type"
			-- A human-readable string containing an error description


	accept (a_visitor: PS_ERROR_VISITOR)
			-- `accept' function of the visitor pattern
		do
			a_visitor.visit_version_mismatch (Current)
		end

end
