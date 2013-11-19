note
	description: "Summary description for {CA_WARNING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_WARNING

inherit
	CA_RULE_SEVERITY

feature -- Properties
	is_critical: BOOLEAN = False

	name: STRING_32 = "Warning"

end
