note
	description: "{ESTRING_32} is an expanded, immutable 32-bit string. It defaults to an empty string."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	ESTRING_32

inherit
	READABLE_STRING_GENERAL
		rename
			true_constant as string_8_true_constant,
			false_constant as string_8_false_constant
		export {NONE}
			make,
			capacity,
			new_string
		redefine
			valid_index,
			hash_code,
			starts_with,
--			split,
			default_create,
			is_immutable,
			out,
			is_equal,
			to_string_32
		end

	READABLE_INDEXABLE[CHARACTER_32]
		redefine
			default_create,
			is_equal,
			out
		end

create
	default_create,
	make_from_string_general,
	make_from_string_32,
	make_from_string_8,
	make_as_lower,
	make_as_upper,
	make_substring,
	make_from_c,
	make_from_area,
	merge

convert
	make_from_string_32 ({STRING_32}),
	make_from_string_8 ({STRING_8}),
	to_string_32: {STRING_32},
	out: {STRING_8},
	to_c_string: {C_STRING}
feature {NONE} -- Initialization
	default_create
		do
		end

	make (n: INTEGER)
		-- Not useful, therefore not implemented
		do
			check false end
		end

	make_from_separate (a_string: separate READABLE_STRING_GENERAL)
		local
			i: INTEGER
			l_area: MANAGED_POINTER
		do
			create l_area.make (a_string.count * 4)
			from
				i := 1
			until
				i > a_string.count
			loop
				l_area.put_integer_32 (a_string[i].to_character_32.code, 4 * (i - 1))
				i := i + 1
			end
			make_from_area (l_area)
		end

	make_from_string_general,
	make_from_string_32 (a_string: READABLE_STRING_GENERAL)
		local
			i: INTEGER
			l_area: MANAGED_POINTER
		do
			create l_area.make (a_string.count * 4)
			from
				i := 1
			until
				i > a_string.count
			loop
				l_area.put_integer_32 (a_string[i].to_character_32.code, 4 * (i - 1))
				i := i + 1
			end
			make_from_area (l_area)
		end

	make_from_string_8 (a_string: STRING_8)
		do
			make_from_string_32 (utf_converter.utf_8_string_8_to_string_32 (a_string))
		end

	make_substring (a_string: like Current; a_lower, a_upper: INTEGER)
		require
			a_lower <= a_upper + 1
			a_lower > 0
			a_upper <= a_string.count
		local
			i: INTEGER
			l_area: MANAGED_POINTER
		do
			create l_area.make (4 * (a_upper - a_lower + 1))
			l_area.item.memory_copy (a_string.area.plus (4*(a_lower - 1)), l_area.count)
			make_from_area (l_area)
		end

	make_as_lower (a_string: like Current)
		local
			i: INTEGER
			l_area: MANAGED_POINTER
		do
			create l_area.make (4 * a_string.count)
			from
				i := 1
			until
				i > count
			loop
				l_area.put_integer_32 (a_string[i].as_lower.code, 4 * (i - 1))
				i := i + 1
			end
			make_from_area (l_area)
		end

	make_as_upper (a_string: like Current)
		local
			i: INTEGER
			l_area: MANAGED_POINTER
		do
			create l_area.make (4 * a_string.count)
			from
				i := 1
			until
				i > count
			loop
				l_area.put_integer_32 (a_string[i].as_upper.code, 4 * (i - 1))
				i := i + 1
			end
			make_from_area (l_area)
		end

	make_from_c (a_pointer: POINTER; a_max_count: INTEGER)
		local
			l_mp: MANAGED_POINTER
			l_buf: STRING_32
		do
			create l_mp.share_from_pointer (a_pointer, a_max_count)
			make_from_string_32 (utf_converter.utf_8_0_pointer_to_escaped_string_32 (l_mp))
		end

	make_from_area (a_area: MANAGED_POINTER)
		require
			a_area.count.divisible (4)
		do
			separate_area := a_area
			area := a_area.item
			count := a_area.count // 4
		end

	merge (a_fragments: LIST[READABLE_STRING_GENERAL]; a_connector: READABLE_STRING_GENERAL)
		local
			l_buffer: MANAGED_POINTER
			l_string: READABLE_STRING_GENERAL
			i, j, k, n: INTEGER
		do
			-- Calculate the size of the string
			across
				a_fragments as iter
			loop
				n := n + iter.item.count * 4
				n := n + a_connector.count * 4
			end
			n := n - a_connector.count * 4 + 4

			if not a_fragments.is_empty then
				create l_buffer.make (n)
				from
					i := 1

					l_string := a_fragments[i]
					from
						j := 1
					until
						j > l_string.count
					loop
						l_buffer.put_integer_32 (l_string[j].code, k)
						k := k + 4
						j := j + 1
					end
					i := i + 1
				until
					i > a_fragments.count
				loop
					from
						j := 1
					until
						j > a_connector.count
					loop
						l_buffer.put_integer_32 (a_connector[j].code, k)
						k := k + 4
						j := j + 1
					end
					l_string := a_fragments[i]
					from
						j := 1
					until
						j > l_string.count
					loop
						l_buffer.put_integer_32 (l_string[j].code, k)
						k := k + 4
						j := j + 1
					end
					i := i + 1
				end
				l_buffer.put_integer_32 (0, k)
				check k = l_buffer.count end
				make_from_area (l_buffer)
			else
				make_empty
			end
		end

feature -- Access
	item alias "[]" (i: INTEGER): CHARACTER_32
		do
			($Result).memory_copy (area + 4 * (i - 1), 4)
		end

	code (i: INTEGER): NATURAL_32
		do
			Result := item (i).code.as_natural_32
		end

	true_constant: ESTRING_32
		once
			Result := string_8_true_constant
		end

	false_constant: ESTRING_32
		once
			Result := string_8_false_constant
		end

feature -- Status report

	is_immutable: BOOLEAN
			-- Can the character sequence of `Current' be not changed?
		do
			Result := True
		end

	valid_code (v: NATURAL_32): BOOLEAN
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
		do
			from
				i := 1
				Result := True
			until
				i > count or not Result
			loop
				if item(i).code >= 256 then
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
		local
			l: like as_lower
		do
			l := as_lower
			Result := (l.is_equal(true_constant.as_string_32) or
				l.is_equal(false_constant.as_string_32))
		end

	valid_index (i: INTEGER): BOOLEAN
			-- Is `i' a valid index?
		do
			Result := i > 0 and i <= count
		end

feature -- Measurement

	count: INTEGER

	capacity: INTEGER
		do
			Result := count
		end

	index_set: INTEGER_INTERVAL
			-- Range of acceptable indexes
		do
			create Result.make (1, count)
		end

	hash_code: INTEGER
		do
			Result := calculate_hash (area, count)
		end

feature -- Comparison

	substring_index_in_bounds (other: READABLE_STRING_GENERAL; start_pos, end_pos: INTEGER): INTEGER
			-- Position of first occurrence of `other' at or after `start_pos'
			-- and to or before `end_pos';
			-- 0 if none.
		local
			l_pos, l_other_pos, l_other_count: INTEGER
		do
			l_other_count := other.count
			from
				l_pos := start_pos
				Result := 0
				l_other_pos := 1
			until
				l_pos > end_pos or l_other_pos > l_other_count
			loop
				if item(l_pos) = other[l_other_pos] then
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

	is_less alias "<" (a_other: like Current): BOOLEAN
		local
			i: INTEGER
			c1, c2: CHARACTER_32
			break: BOOLEAN
		do
			from
				i := 1
			until
				i > count or else i > a_other.count or else
					item (i) /= a_other.item (i)
			loop
				i := i + 1
			end

			if count = 0 and a_other.count = 0 then
				Result := False
			elseif i > count and i > a_other.count then
				Result := item (i - 1) < a_other.item (i - 1)
			elseif i > count then
				Result := True
			elseif i > a_other.count then
				Result := False
			else
				Result := item (i) < a_other.item (i)
			end
		end

	is_equal (a_other: like Current): BOOLEAN
		local
			l_count: INTEGER
			l_other_area, l_area: like area
		do
			l_count := count
			Result := a_other.count = l_count
			if Result then
				Result := area.memory_compare (a_other.area, 4 * count)
			end
		end

	starts_with (a_other: READABLE_STRING_GENERAL): BOOLEAN
		local
			i: INTEGER
		do
			Result := a_other.count <= count
			from
				i := 1
			until
				i > a_other.count or i > count or not Result
			loop
				Result := a_other[i] = item(i)
				i := i + 1
			end
		end

	fuzzy_index (other: READABLE_STRING_GENERAL; start: INTEGER; fuzz: INTEGER): INTEGER
			-- Position of first occurrence of `other' at or after `start'
			-- with 0..`fuzz' mismatches between the string and `other'.
			-- 0 if there are no fuzzy matches
		local
			l_outer_pos, l_pos, l_other_pos, l_count, l_fuzz_count, l_other_count: INTEGER
		do
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
					if item(l_pos) = other[l_other_pos] then
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

	to_string_32: STRING_32
		local
			i: INTEGER
		do
			create Result.make (count)
			from
				i := 1
			until
				i > count
			loop
				Result.extend (item (i))
				i := i + 1
			end
		end

	to_c_string: C_STRING
		do
			create Result.make_by_pointer_and_count (area, count)
		end

--	split (a_splitter: CHARACTER_32): LIST[ESTRING_32]
--		local
--			i, n, l, j: INTEGER
--		do
--			from
--				i := 1
--				n := 1
--			until
--				i > count
--			loop
--				if item (i) = a_splitter then
--					n := n + 1
--				end
--				i := i + 1
--			end
--			create {ARRAYED_LIST[ESTRING_32]}Result.make (n)
--			from
--				i := 1
--				l := 1
--				j := 1
--			until
--				i > count
--			loop
--				if item (i) = a_splitter then
--					Result[j] := substring (l, i-1)
--					l := i + 1
--					j := j + 1
--				end
--				i := i + 1
--			end
--			Result[j] := substring (l, i-1)
--		end

	out: STRING_8
		-- Converts into an UTF-8 string.
		local
			i: like count
			n, m: like count

			c: NATURAL_32
		do
			from
				i := 1
				m := 0
			until
				i > count
			loop
				c := item(i).code.as_natural_32
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
				i := 1
				create Result.make (m)
			until
				i > n
			loop
				c := item(i).code.as_natural_32
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


feature -- Element change

	trim: ESTRING_32
		-- Returns a substring where all the leading and trailing whitespace is removed
		local
			s, e: INTEGER
			c: CHARACTER_32
		do
			if count = 0 then
				Result := Current
			elseif count = 1 then
				c := item (1)
				if not (c = ' ' or c = '%T' or c = '%N') then
					Result := Current
				end
			else
				c := item (1)
				if not (c = ' ' or c = '%T' or c = '%N' or c = '%R') then
					c := item (count)
					if not (c = ' ' or c = '%T' or c = '%N') then
						Result := Current
					end
				else
					from
						s := 1
						c := item (s)
					until
						s = count or not (c = ' ' or c = '%T' or c = '%N' or c = '%R')
					loop
						s := s + 1
						c := item (s)
					end
					from
						e := count
						c := item (e)
					until
						e = 1 or not (c = ' ' or c = '%T' or c = '%N' or c = '%R')
					loop
						e := e - 1
						c := item (e)
					end
					if e >= s then
						Result := substring (s, e)
					end
				end

			end
		end

	replace (a_char, a_replacement: CHARACTER_32): ESTRING_32
			-- Replace every occurence of a_char with a_replacement
		local
			i: INTEGER
			l_area: MANAGED_POINTER
			c: CHARACTER_32
		do
			if has (a_char) then
				from
					i := 1
					create l_area.make (4*count)
				until
					i > count
				loop
					c := item (i)
					if c = a_char then
						l_area.put_integer_32 (a_replacement.code, 4*(i - 1))
					else
						l_area.put_integer_32 (c.code, 4*(i - 1))
					end
				end
				create Result.make_from_area (l_area)
			else
				Result := Current
			end
		end

	plus alias "+" (s: like Current): like Current
		local
			l_area: MANAGED_POINTER
			l_count1, l_count2: INTEGER
			i: INTEGER
		do
			create l_area.make (count + s.count)
			l_area.item.memory_copy (area, count)
			l_area.item.plus (count).memory_copy (s.area, s.count)
			create Result.make_from_area (l_area)
		end

feature -- Duplication

	substring (start_index, end_index: INTEGER): like Current
			-- Copy of substring containing all characters at indices
			-- between `start_index' and `end_index'
		do
			create Result.make_substring(Current, start_index.max (1), end_index.min (count))
		end

feature {ESTRING_32} -- Implementation

	utf_converter: UTF_CONVERTER

	new_string (n: INTEGER): like Current
			-- Not useful, not implemented
		do
		end

	string_searcher: ESTRING_SEARCHER
			-- Facilities to search string in another string.
		do
			create Result.make
		end

	separate_area: detachable separate MANAGED_POINTER

	area: POINTER

	item_32 (i: INTEGER): CHARACTER_32
		do
			Result := item (i).to_character_32
		end

	calculate_hash (a_str: POINTER; a_count: INTEGER): INTEGER
		external
			"C inline use <math.h>"
		alias
			"{
		    	unsigned char *str = $a_str;
		        EIF_INTEGER hash = 5381;
		        int c;
		        int i;

		        for (i = 0; i < $a_count; i++)
		            hash = ((hash << 5) + hash) + c;

		        return abs(hash);
			}"
		end

end
