indexing
	description: "Objects that represent an debugged object"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CDD_OBJECT

feature -- Access

	identifier: STRING is
			-- Identifier for this object
		deferred
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end

end
