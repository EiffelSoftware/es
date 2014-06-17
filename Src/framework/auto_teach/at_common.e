note
	description: "Common ancestor class for AutoTeach classes, with access to shared strings and utility functions."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AT_COMMON

feature -- Shared strings

	at_strings: AT_STRINGS
			-- Localized strings for AutoTeach.
		once
			create Result
		ensure
			valid_result: Result /= Void
		end

feature {AT_COMMON} -- Utility

	is_valid_hint_level (a_level: INTEGER): BOOLEAN
			-- Does `a_level' represent a valid hint level?
		do
				-- 10 is arbitrary. Theoretically any positive number would
				-- be acceptable, in practice it is probably better to have a limit,
				-- so that the program throws an error if absurd hint levels are specified.
			Result := a_level >= 0 and a_level <= 10
		end

	count_leading (a_char: CHARACTER; a_string: STRING): INTEGER
			-- With how many repetitions of `a_char' does `a_string' start? (possibly zero)
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
