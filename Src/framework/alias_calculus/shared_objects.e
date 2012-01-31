note
	description: "Objects of general use for alias calculus."
	author: "Bertrand Meyer"
	usage: "Meant to be used as ancestor by classes needing the shared objects."
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_OBJECTS

feature

	current_object: CURRENT_EXPRESSION
			-- Expression representing current object.
		once
			create Result
		end

end
