note
	description: "{ESTRING_32} is an expanded, immutable unicode string. It defaults to an empty string."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	ESTRING_32

inherit
	ANY
		undefine
			default_create,
			is_equal,
			out
		end

	READABLE_STRING_GENERAL
		undefine
			default_create
		redefine
			is_immutable,
			out,
			to_string_32
		end

	READABLE_INDEXABLE[CHARACTER_32]
		undefine
			default_create,
			is_equal,
			out
		end

create
	default_create,
	make_from_string,
	make_as_lower,
	make_as_upper,
	make_substring,
	make_empty

create {ESTRING_32}
	make_from_special,
	make

convert
	make_from_string ({STRING, STRING_32}),
	to_string_8: {STRING_8},
	to_string_32: {STRING_32}

feature {NONE} -- Initialization
	default_create
		do
			make_empty
		end

	make_from_string (a_string: separate READABLE_STRING_GENERAL)
		local
			i: INTEGER
			l_area: SPECIAL[CHARACTER_32]
		do
			create l_area.make_empty (a_string.count)
			separate_area := l_area

			from
				i := 0
			until
				i = a_string.count
			loop
				l_area.extend (a_string[i + 1])
				i := i + 1
			end
		end

	make_substring (a_string: separate READABLE_STRING_GENERAL; a_lower, a_upper: INTEGER)
		require
			a_lower <= a_upper + 1
			a_lower > 0
			a_upper <= a_string.count
		local
			i: INTEGER
			l_area: SPECIAL[CHARACTER_32]
		do
			create l_area.make_empty (a_upper - a_lower + 1)
			separate_area := l_area

			from
				i := a_lower
			until
				i > a_upper
			loop
				l_area.extend (a_string[i])
				i := i + 1
			end
		end

	make_from_special (a_area: like area)
		do
			separate_area := a_area
		end

	make (n: INTEGER)
		do
			create {SPECIAL[CHARACTER_32]}separate_area.make_empty (n)
		end

	make_as_lower (a_string: separate READABLE_STRING_GENERAL)
		local
			i: INTEGER
			l_area: SPECIAL[CHARACTER_32]
		do
			create l_area.make_empty (a_string.count)
			separate_area := l_area

			from
				i := 1
			until
				i > a_string.count
			loop
				l_area.extend (a_string[i].as_lower)
				i := i + 1
			end
		end

	make_as_upper (a_string: separate READABLE_STRING_GENERAL)
		local
			i: INTEGER
			l_area: SPECIAL[CHARACTER_32]
		do
			create l_area.make_empty (a_string.count)
			separate_area := l_area

			from
				i := 1
			until
				i > a_string.count
			loop
				l_area.extend (a_string[i].as_upper)
				i := i + 1
			end
		end

feature -- Access

	code (i: INTEGER): NATURAL_32
		do
			Result := Current[i].code.to_natural_32
		end

	item alias "[]" (i: INTEGER): CHARACTER_32
		do
			Result := area[i-1]
		end

feature -- Status report

	is_immutable: BOOLEAN
			-- Can the character sequence of `Current' be not changed?
		do
			Result := True
		end

	valid_code (v: like code): BOOLEAN
			-- Is `v' a valid code for Current?
		do
			Result := True
		end

	is_string_8: BOOLEAN
			-- Is `Current' a sequence of CHARACTER_8?
		do
			Result := False
		end

	is_string_32: BOOLEAN
			-- Is `Current' a sequence of CHARACTER_32?
		do
			Result := True
		end

	is_valid_as_string_8: BOOLEAN
			-- Is `Current' convertible to a sequence of CHARACTER_8 without information loss?
		local
			i: INTEGER
			l_area: SPECIAL[CHARACTER_32]
		do
			from
				l_area := area
				i := 0
				Result := True
			until
				i = l_area.count or not Result
			loop
				if l_area[i].code >= 256 then
					Result := False
				end
				i := i + 1
			end
		end

	is_empty: BOOLEAN
			-- Is structure empty?
		do
			Result := count = 0
		end

	is_boolean: BOOLEAN
			-- Does `Current' represent a BOOLEAN?
		do
			Result := (true_constant.same_string_general (as_lower) or
				false_constant.same_string_general (as_lower))
		end

feature -- Measurement

	count: INTEGER
			-- Number of characters in Current
		do
			Result := area.count
		end

	capacity: INTEGER
			-- Number of characters allocated in Current
		do
			Result := area.capacity
		end

feature -- Measurement

	index_set: INTEGER_INTERVAL
			-- Range of acceptable indexes
		do
			create Result.make (1, count)
		end
feature -- Comparison

	substring_index_in_bounds (other: READABLE_STRING_GENERAL; start_pos, end_pos: INTEGER): INTEGER
			-- Position of first occurrence of `other' at or after `start_pos'
			-- and to or before `end_pos';
			-- 0 if none.
		local
			l_area: like area
			l_pos, l_other_pos, l_other_count: INTEGER

		do
			l_area := area
			l_other_count := other.count
			from
				l_pos := start_pos
				Result := 0
				l_other_pos := 1
			until
				l_pos > end_pos or l_other_pos > l_other_count
			loop
				if l_area[l_pos - 1] = other[l_other_pos] then
					if Result = 0 then
						Result := l_pos
					end
					l_other_pos := l_other_pos + 1
				else
					Result := 0
					l_other_pos := 1
				end
				l_pos := l_pos + 1
			end
			if l_other_pos <= l_other_count then
				Result := 0
			end
		end

	substring_index (other: READABLE_STRING_GENERAL; start_index: INTEGER): INTEGER
			-- Index of first occurrence of other at or after start_index;
			-- 0 if none
		do
			Result := substring_index_in_bounds (other, start_index, count)
		end

	fuzzy_index (other: READABLE_STRING_GENERAL; start: INTEGER; fuzz: INTEGER): INTEGER
			-- Position of first occurrence of `other' at or after `start'
			-- with 0..`fuzz' mismatches between the string and `other'.
			-- 0 if there are no fuzzy matches
		local
			l_area: like area
			l_outer_pos, l_pos, l_other_pos, l_count, l_fuzz_count, l_other_count: INTEGER
		do
			l_area := area
			l_other_count := other.count
			l_count := count

			from
				l_outer_pos := start
			until
				l_outer_pos > l_count + l_other_count or Result > 0
			loop
				from
					l_pos := l_outer_pos
					Result := l_pos
					l_other_pos := 1
					l_fuzz_count := 0
				until
					l_pos > l_count or l_other_pos > l_other_count or Result = 0
				loop
					if l_area[l_pos - 1] = other[l_other_pos] then
						l_other_pos := l_other_pos + 1
					else
						l_fuzz_count := l_fuzz_count + 1
						if l_fuzz_count > fuzz then
							Result := 0
						end
					end
					l_pos := l_pos + 1
				end

				if l_other_pos <= l_other_count then
					Result := 0
				end
				l_outer_pos := l_outer_pos + 1
			end
		end

	is_less alias "<" (a_other: like Current): BOOLEAN
		local
			i: INTEGER
			finished: BOOLEAN
		do
			from
				i := 1
			until
				i > count or i > a_other.count or finished
			loop
				Result := item (i) < a_other.item (i)
				finished := item (i) /= a_other.item (i)
				i := i + 1
			end
		end

feature -- Conversion

	as_lower: like Current
			-- New object with all letters in lower case.
		do
			create Result.make_as_lower (Current)
		end

	as_upper: like Current
			-- New object with all letters in upper case
		do
			create Result.make_as_upper (Current)
		end

	out: STRING_8
		-- Converts into an UTF-8 string.
		local
			l_area: SPECIAL[CHARACTER_32]
			i: like {ESTRING_32}.count
			n, m: like {ESTRING_32}.count

			c: NATURAL_32
		do
			l_area := area
			n := l_area.count
			from
				i := 0
			until
				i >= n
			loop
				c := l_area[i].code.as_natural_32
				if c <= 0x7F then
					m := m + 1
				elseif c <= 0x7FF then
					m := m + 2
				elseif c <= 0xFFFF then
					m := m + 3
				else
					m := m + 4
				end
				i := i + 1
			end

			from
				i := 0
				create Result.make (m)
			until
				i >= n
			loop
				c := l_area[i].code.as_natural_32
				if c <= 0x7F then
						-- 0xxxxxxx
					Result.extend (c.to_character_8)
				elseif c <= 0x7FF then
						-- 110xxxxx 10xxxxxx
					Result.extend (((c |>> 6) | 0xC0).to_character_8)
					Result.extend (((c & 0x3F) | 0x80).to_character_8)
				elseif c <= 0xFFFF then
						-- 1110xxxx 10xxxxxx 10xxxxxx
					Result.extend (((c |>> 12) | 0xE0).to_character_8)
					Result.extend ((((c |>> 6) & 0x3F) | 0x80).to_character_8)
					Result.extend (((c & 0x3F) | 0x80).to_character_8)
				else
						-- c <= 1FFFFF - there are no higher code points
						-- 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
					Result.extend (((c |>> 18) | 0xF0).to_character_8)
					Result.extend ((((c |>> 12) & 0x3F) | 0x80).to_character_8)
					Result.extend ((((c |>> 6) & 0x3F) | 0x80).to_character_8)
					Result.extend (((c & 0x3F) | 0x80).to_character_8)
				end
				i := i + 1
			end
		end

	to_string_32: STRING_32
		local
			i: INTEGER
			l_area: SPECIAL[CHARACTER_32]
		do
			create Result.make (count)
			l_area := area
			from
				i := 0
			until
				i = count
			loop
				Result.extend(l_area[i])
				i := i + 1
			end
		end


feature -- Element change

	plus alias "+" (s: READABLE_STRING_GENERAL): like Current
		local
			l_area: like area
			l_count1, l_count2: INTEGER
			i: INTEGER
		do
			l_count1 := count;
			l_count2 := s.count;
			create l_area.make_empty (l_count1 + l_count2)
			l_area.copy_data (area, 0, 0, l_count1)
			if attached {ESTRING_32} s as es then
				l_area.copy_data (es.area, 0, l_count1, l_count2)
			end
			from
				i := l_count1
			until
				i = l_count2
			loop
				l_area[i-l_count1] := s.item(i)
				i := i + 1
			end
			create Result.make_from_special (l_area)
		end

feature -- Duplication

	substring (start_index, end_index: INTEGER): like Current
			-- Copy of substring containing all characters at indices
			-- between `start_index' and `end_index'
		do
			create Result.make_substring(Current, start_index, end_index)
		end

feature {NONE} -- Implementation

	new_string (n: INTEGER): like Current
			-- New instance of current with space for at least `n' characters.
		do
			create Result.make(n)
		end

	string_searcher: ESTRING_32_SEARCHER
			-- Facilities to search string in another string.
		do
			create Result.make
		end

feature {ESTRING_32, ESTRING_32_SEARCHER} -- Implementation
	wrapper (a: detachable separate SPECIAL[CHARACTER_32]): SPECIAL[CHARACTER_32]
		external
			"C inline"
		alias
			"return eif_access($a);"
		end

	separate_area: separate SPECIAL[CHARACTER_32]
		attribute
			Result := create {SPECIAL[CHARACTER_32]}.make_empty (0)
		end

	area: SPECIAL[CHARACTER_32]
		do
			Result := wrapper (separate_area)
		end
end
