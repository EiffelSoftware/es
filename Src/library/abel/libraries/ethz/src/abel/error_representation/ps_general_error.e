note
	description: "Summary description for {PS_GENERAL_ERROR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_GENERAL_ERROR

inherit
	PS_ERROR

create make

feature

	description: STRING

	accept (a_visitor: PS_ERROR_VISITOR)
		do
			a_visitor.visit_general_error (Current)
		end

	make (desc: STRING)
		do
			description:= desc
		end

end
