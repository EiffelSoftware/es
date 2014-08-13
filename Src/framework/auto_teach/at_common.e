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

feature -- Block types
		-- TODO: better term than "block types"?

		-- 'bt' stands for 'block type'
	bt_routine: STRING = "routine"
	bt_arguments: STRING = "arguments"
	bt_precondition: STRING = "precondition"
	bt_locals: STRING = "locals"
	bt_routine_body: STRING = "body"
	bt_postcondition: STRING = "postcondition"
	bt_class_invariant: STRING = "classinvariant"

	block_types: ARRAY [STRING] -- TODO: can we have readonly array/lists in Eiffel?
			-- List of all supported code block types
		once
			Result := << bt_arguments, bt_precondition, bt_locals, bt_routine_body, bt_postcondition, bt_class_invariant >>
			Result.compare_objects
		end

	is_valid_block_type (a_string: STRING): BOOLEAN
			-- Is `a_string' a valid block type?
		do
			Result := block_types.has (a_string)
		end

feature {AT_COMMON} -- Utility

	string_to_int (a_string: READABLE_STRING_GENERAL): INTEGER
			-- Attempt to convert `a_string' to integer,
			-- stopping at the first non-digit character
			-- and returning 0 by default.
		require
			string_exists: a_string /= Void
		local
			l_char: CHARACTER_32
			l_stop: BOOLEAN
			i: INTEGER
		do
			from
				i := 1
			until
				l_stop or i > a_string.count
			loop
				l_char := a_string [i]
				if '0' <= l_char and l_char <= '9' then
					i := i + 1
				else
					l_stop := True
				end
			end

			if i = 1 then
				Result := 0
			else
				Result := a_string.substring (1, i - 1).to_integer_32
			end
		end

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

end
