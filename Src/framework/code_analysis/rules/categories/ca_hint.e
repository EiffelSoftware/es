note
	description: "Summary description for {CA_HINT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_HINT

inherit
	CA_RULE_SEVERITY

feature {NONE} -- Initialization
	is_critical: BOOLEAN = False

	name: STRING = "Hint"

end
