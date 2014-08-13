note
	description: "Common ancestor class for AutoTeach classes, with access to shared strings and utility functions."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AT_COMMON

inherit {NONE}
	AT_TRI_STATE_BOOLEAN_CONSTANTS

	AT_SHARED_HINT_TABLES


feature {NONE} -- Shared strings

	at_strings: AT_STRINGS
			-- Localized strings for AutoTeach.
		once
			create Result
		ensure
			valid_result: Result /= Void
		end

feature -- Block types

	enum_block_type: AT_ENUM_BLOCK_TYPE
		once
			create Result
		end

--		-- 'bt' stands for 'block type'
--	bt_feature: STRING = "feature"
--	bt_arguments: STRING = "arguments"
--	bt_precondition: STRING = "precondition"
--	bt_locals: STRING = "locals"
--	bt_routine_body: STRING = "body"
--	bt_postcondition: STRING = "postcondition"
--	bt_class_invariant: STRING = "classinvariant"

--	content_block_types: ARRAY [STRING] -- TODO: get rid of this?
--			-- List of all supported block types with content
--		once
--			Result := << bt_feature >>
--			Result.compare_objects
--		end

feature -- For use with contracts

	is_valid_content_block_type (a_string: STRING): BOOLEAN -- TODO: get rid of this?
			-- Is `a_string' a valid block type?
		do
			Result := enum_block_type.is_valid_value_name (a_string)
		end


	is_valid_hint_level (a_level: INTEGER): BOOLEAN
			-- Does `a_level' represent a valid hint level?
		do
				-- 10 is arbitrary. Theoretically any positive number would
				-- be acceptable, in practice it is probably better to have a limit,
				-- so that the program throws an error if absurd hint levels are specified.
			Result := a_level >= 0 and a_level <= 10
		end

feature {NONE} -- Utility

		-- TODO: unused
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

	on_off_to_tristate (a_string: STRING): AT_TRI_STATE_BOOLEAN
			-- Translates "on" to tri_true, "off" to tri_false and any other string to tri_undefined.
			-- Case insensitive.
		local
			l_string: STRING
		do
			l_string := a_string.as_lower
			if l_string.same_string ("on") then
				Result := Tri_true
			elseif l_string.same_string ("off") then
				Result := Tri_false
			else
				Result := Tri_undefined
			end
		end

end
