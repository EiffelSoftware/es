note
	description: "Summary description for {CA_RULE_OPTION}."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CA_RULE_OPTION

inherit
	HASHABLE

feature -- Hash Code
	hash_code: INTEGER
		deferred
		end

end
