note
	description: "Summary description for {AT_COMMON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AT_COMMON

inherit
	AT_SHARED_STRINGS


feature {AT_COMMON} -- Utility

	is_valid_hint_level (a_level: INTEGER): BOOLEAN
		do
			Result := a_level >= 0 and a_level <= 3
		end

end
