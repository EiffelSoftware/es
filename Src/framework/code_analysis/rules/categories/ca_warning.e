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
	is_critical: BOOLEAN
		once
			Result := False
		end

	name: STRING
		once
			Result := "Warning"
		end

end
