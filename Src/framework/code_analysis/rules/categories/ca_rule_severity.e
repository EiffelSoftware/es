note
	description: "Summary description for {CA_RULE_CATEGORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CA_RULE_SEVERITY

feature -- Properties
	is_critical: BOOLEAN
		deferred
		end

	name: STRING_32
			-- What the severity is called; what is shown to the user.
		deferred
		end

end
