note
	description: "Summary description for {CA_ERROR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_ERROR

inherit
	CA_RULE_SEVERITY

feature -- Properties
	is_critical: BOOLEAN
		once
			Result := True
		end

	name: STRING
		once
			Result := "Error"
		end

end
