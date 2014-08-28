note
	description: "Common ancestor class for AutoTeach classes, with access to shared strings and utility functions."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AT_COMMON

inherit
	AT_TRI_STATE_BOOLEAN_CONSTANTS

	AT_SHARED_HINT_TABLES


feature {NONE} -- Shared strings

	at_strings: AT_STRINGS
			-- Localized strings for AutoTeach.
		once ("PROCESS")
			create Result
		ensure
			valid_result: Result /= Void
		end

feature -- Enums

	enum_block_type: AT_ENUM_BLOCK_TYPE
		once ("PROCESS")
			create Result
		end

	enum_placeholder: AT_ENUM_PLACEHOLDER
		once ("PROCESS")
			create Result
		end

	enum_policy_strength: AT_ENUM_POLICY_STRENGTH
		once ("PROCESS")
			create Result
		end

	enum_mode: AT_ENUM_MODE
		once ("PROCESS")
			create Result
		end

feature -- For use with contracts

	is_valid_hint_level (a_level: NATURAL): BOOLEAN
			-- Does `a_level' represent a valid hint level?
		do
				-- 20 is arbitrary. Theoretically any positive number would
				-- be acceptable, in practice it is probably better to have a limit,
				-- so that the program throws an error if absurd hint levels are specified.
			Result := a_level >= 0 and a_level <= 20
		ensure
			Result implies a_level < {INTEGER}.max_value.as_natural_32
		end


feature {NONE} -- Utility

		-- Taken from the eweasel source code.
	is_white (a_char: CHARACTER): BOOLEAN
			-- Is `a_char' a white space character?
		do
			Result := a_char = ' ' or a_char = '%T' or a_char = '%R' or a_char = '%N';
		end;

		-- Taken from the eweasel source code.
	broken_into_words (a_line: STRING): DYNAMIC_LIST [STRING]
			-- Result of breaking `line' into words, where each
			-- word is terminated by white space
		local
			l_pos, l_first, l_last: INTEGER;
			l_word: STRING;
			l_in_word, l_is_white_char: BOOLEAN;
		do
			from
				create {ARRAYED_LIST [STRING]} Result.make (4)
				l_pos := 1;
			until
				l_pos > a_line.count
			loop
				l_is_white_char := is_white (a_line.item (l_pos));
				if l_in_word then
					if l_is_white_char then
						l_in_word := False;
						l_last := l_pos - 1;
						create l_word.make (l_last - l_first + 1);
						l_word.set (a_line, l_first, l_last);
						Result.extend (l_word);
					end
				else
					if not l_is_white_char then
						l_in_word := True;
						l_first := l_pos;
					end
				end;
				l_pos := l_pos + 1;
			end;
			if l_in_word then
				l_last := l_pos - 1;
				create l_word.make (l_last - l_first + 1);
				l_word.set (a_line, l_first, l_last);
				Result.extend (l_word);
			end
		end;

	capitalized (a_string: READABLE_STRING_GENERAL): READABLE_STRING_GENERAL
			-- `a_string', where the first character is converted to upper case.
		do
			if a_string.count < 1 then
				Result := a_string.twin
			else
				Result := a_string.substring (1, 1).as_upper + a_string.substring (2, a_string.count)
			end
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

	tab_string (a_tab_count: INTEGER): STRING
			-- A string made of `a_tab_count' tabs.
		require
			non_negative: a_tab_count >= 0
		do
			if a_tab_count = 0 then
					-- We need a special case, as {STRING}.multiply does not accept zero as an argument.
				Result := ""
			else
				Result := "%T"
				Result.multiply (a_tab_count)
			end
		end

	string_is_bool (a_string: STRING): BOOLEAN
			-- Can `a_string' be parsed to a boolean, also accepting "on" and "off" as input.
		local
			l_lower_string: STRING
		do
			l_lower_string := a_string.as_lower
			Result := l_lower_string.is_boolean or else l_lower_string.same_string ("on") or else l_lower_string.same_string ("off")
		end

	string_to_bool (a_string: STRING): BOOLEAN
			-- Convert `a_string' to a boolean value, also accepting "on" and "off" as input.
		require
			is_bool: string_is_bool (a_string)
		local
			l_lower_string: STRING
		do
			l_lower_string := a_string.as_lower
			if l_lower_string.is_boolean then
				Result := l_lower_string.to_boolean
			elseif l_lower_string.same_string ("on") then
				Result := True
			elseif l_lower_string.same_string ("off") then
				Result := False
			else
				check valid_input: False end
			end
		end

	parse_natural_range_string (a_string: READABLE_STRING_GENERAL): TUPLE [min, max: NATURAL]
			-- Parses a range string with format "3-8".
			-- The returned numbers are guaranteed to be nonnegative.
			-- One or both numbers can be empty (e.g. "3-", "-9", "-")
			-- In this case, respectively the minimum and/or the maximum
			-- values for NATURAL are returned
			-- Void is returned if parsing fails.
		local
			l_first_string, l_second_string: READABLE_STRING_GENERAL
			l_strings: LIST [READABLE_STRING_GENERAL]
			l_error: BOOLEAN
		do
			l_strings := a_string.split ('-')
			if l_strings.count = 2 then
				create Result

				if l_strings.first.is_empty then
					Result.min := {NATURAL}.min_value
				elseif l_strings.first.is_natural_32 then
					Result.min := l_strings.first.to_natural_32
				else
					l_error := True
				end

				if l_strings.last.is_empty then
					Result.max := {NATURAL}.max_value
				elseif l_strings.last.is_natural_32 then
					Result.max := l_strings.last.to_natural_32
				else
					l_error := True
				end
				if l_error then
					Result := Void
				end
			else
				Result := Void
			end
		end

end
