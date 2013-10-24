note
	description: "Summary description for {CA_SUGGESTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_SUGGESTION

inherit
	CA_RULE_SEVERITY

feature {NONE} -- Initialization
	is_critical: BOOLEAN
		once
			Result := False
		end

	name: STRING
		once
			Result := "Suggestion"
		end

end
