note
	description: "Summary description for {AT_COMMON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AT_COMMON

inherit
	AT_SHARED_STRINGS


feature {AT_COMMON} -- Utility

	is_valid_hint_level (a_level: INTEGER): BOOLEAN
		do
			Result := a_level >= 0 and a_level <= 3
		end

	count_leading (a_char: CHARACTER; a_string: STRING): INTEGER
		local
			i: INTEGER
			l_stop: BOOLEAN
		do
			from
				i := 1
			until
				l_stop or i > a_string.count
			loop
				if a_string.at (i) = a_char then
					i := i + 1
				else
					l_stop := true
				end
			end

			Result := i - 1
		end

end
