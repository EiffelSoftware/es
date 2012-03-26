note
	description: "Instances of this class indicate that no error has occured"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_NO_ERROR
inherit
	PS_ERROR

feature

	description:STRING = "No error occured"

	accept (a_visitor:PS_ERROR_VISITOR)
		do
			a_visitor.visit_no_error(Current)
		end

end
