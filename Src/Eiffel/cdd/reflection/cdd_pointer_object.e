indexing
	description: "Objects that reflect eiffel object of type POINTER"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_POINTER_OBJECT

inherit
	CDD_OBJECT

feature -- Output

	identifier: STRING is
			-- Identifier for `Current'
		once
			Result := "Current.default_pointer"
		end

end
