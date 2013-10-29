note
	description: "Summary description for {CA_NAMES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

frozen class
	CA_NAMES

inherit {NONE}
	SHARED_LOCALE

feature -- Rules

	self_assignment_title: STRING_32
		do Result := locale.translation ("Self-assignment") end

end
