note
	description: "Summary description for {QUERY_VALIDATOR}."
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

class
	QUERY_VALIDATOR [G -> ANY create default_create end]

feature -- Status

feature --	Basic operations

	is_validated (q: QUERY_COMPOSITE [G]): BOOLEAN
			-- Is `q''valid according to the current validation rules?
		do
			Result := True
		end

end
