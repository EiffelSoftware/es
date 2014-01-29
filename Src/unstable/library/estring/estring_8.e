note
	description: "{ESTRING_8} is an expanded, immutable unicode string. It defaults to an empty string."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	ESTRING_8

inherit
	ANY
		undefine
			default_create,
			is_equal,
			out
		end

	READABLE_STRING_GENERAL
		rename
			item as item_32
		undefine
			default_create
		redefine
			is_immutable,
			out,
			--is_equal,
			to_string_32,
			to_string_8
		end

	READABLE_INDEXABLE[CHARACTER_8]
		undefine
			default_create,
			is_equal,
			out
		end

create
	default_create,
	make_from_string_general,
	make_from_string_8,
	make_from_string_32,
	make_as_lower,
	make_as_upper,
	make_substring,
	make_from_c,
	make_empty

create {ESTRING_8}
	make

convert
	make_from_string_general ({READABLE_STRING_GENERAL}),
	make_from_string_8 ({STRING_8}),
	make_from_string_32 ({STRING_32}),
	to_string_8: {STRING_8},
	to_string_32: {STRING_32}

feature {NONE} -- Initialization
	default_create
		do
			make_empty
		end

	make_from_separate (a_string: separate READABLE_STRING_GENERAL)
		require
			a_string.is_valid_as_string_8
		local
			i: INTEGER
			l_string: like area
		do
			create l_string.make (a_string.count)
			from
				i := 1
			until
				i > a_string.count
			loop
				l_string.extend (a_string[i].to_character_8)
			end
			separate_area := l_string
		end

	make_from_string_general,
	make_from_string_32 (a_string: READABLE_STRING_GENERAL)
		require
			a_string.is_valid_as_string_8
		local
			i: INTEGER
			l_string: like area
		do
			create l_string.make (a_string.count)
			from
				i := 1
			until
				i > a_string.count
			loop
				l_string.extend (a_string[i].to_character_8)
			end
			separate_area := l_string
		end

	make_from_string_8(a_string: READABLE_STRING_8)
		local
			i: INTEGER
			l_string: like area
		do
			create l_string.make_from_separate(a_string)
			separate_area := l_string
		end

	make_substring (a_string: separate READABLE_STRING_GENERAL; a_lower, a_upper: INTEGER)
		require
			a_lower <= a_upper + 1
			a_lower > 0
			a_upper <= a_string.count
			a_string.is_valid_as_string_8
		local
			i: INTEGER
			l_string: like area
		do
			create l_string.make (a_upper - a_lower + 1)
			separate_area := l_string

			from
				i := a_lower
			until
				i > a_upper
			loop
				l_string.extend (a_string[i].to_character_8)
				i := i + 1
			end
		end

	make (n: INTEGER)
		do
			create {STRING_8}separate_area.make (n)
		end

	make_as_lower (a_string: separate READABLE_STRING_GENERAL)
		require
			a_string.is_valid_as_string_8
		local
			i: INTEGER
			l_string: like area
		do
			create l_string.make (a_string.count)
			separate_area := l_string

			from
				i := 1
			until
				i > a_string.count
			loop
				l_string.extend (a_string[i].as_lower.to_character_8)
				i := i + 1
			end
		end

	make_as_upper (a_string: separate READABLE_STRING_GENERAL)
		require
			a_string.is_valid_as_string_8
		local
			i: INTEGER
			l_string: like area
		do
			create l_string.make (a_string.count)
			separate_area := l_string

			from
				i := 1
			until
				i > a_string.count
			loop
				l_string.extend (a_string[i].as_upper.to_character_8)
				i := i + 1
			end
		end

	make_from_c (a_pointer: POINTER)
		local
			i,n: INTEGER
			l_mp: MANAGED_POINTER
			l_buf: ARRAYED_LIST[CHARACTER_8]
			l_string: like area
		do
			create l_mp.share_from_pointer (a_pointer, 2147483647)
			from
				n := 0
			until
				l_mp.read_natural_8 (n) = 0
			loop
				n := n + 1
			end
			create l_string.make (n)
			from
				i := 0
			until
				i = n
			loop
				l_string.extend (l_mp.read_character (i))
				i := i + 1
			end
			separate_area := l_string
		end

feature -- Access

	code (i: INTEGER): NATURAL_32
		do
			Result := Current[i].code.to_natural_8
		end

	item alias "[]" (i: INTEGER): CHARACTER_8
		do
			Result := area[i]
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
			Result := v < 256
		end

	is_string_32: BOOLEAN
			-- Is `Current' a sequence of CHARACTER_32?
		do
			Result := False
		end

	is_string_8: BOOLEAN
			-- Is `Current' a sequence of CHARACTER_8?
		do
			Result := True
		end

	is_valid_as_string_8: BOOLEAN
			-- Is `Current' convertible to a sequence of CHARACTER_8 without information loss?
		local
			i: INTEGER
			l_area: STRING_8
		do
			Result := True
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
			l_string: like area
		do
			l_string := area
			Result := l_string.substring_index_in_bounds (other, start_pos, end_pos)
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
			l_string: like area
		do
			l_string := area
			Result := l_string.fuzzy_index (other, start, fuzz)
		end

	is_less alias "<" (a_other: like Current): BOOLEAN
		local
			l_string1, l_string2: like area
		do
			l_string1 := area
			l_string2 := a_other.area
			Result := l_string1 < l_string2
		end

--	is_equal (a_other: like Current): BOOLEAN
--		local
--			l_count: INTEGER
--			l_other_area, l_area: STRING_8
--		do
--			l_count := count
--			Result := a_other.count = l_count
--			if Result then
--				l_area := area
--				l_other_area := a_other.area
--				Result := l_other_area.same_items (l_area, 0, 0, l_count)
--			end

--		end

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
			l_area: like area
		do
			create Result.make (count)
			l_area := area
			from
				i := 1
			until
				i = count
			loop
				Result.extend(l_area[i].to_character_32)
				i := i + 1
			end
		end

	to_string_8: STRING_8
		local
			i: INTEGER
		do
			create Result.make_from_string (area)
		end

	out: STRING_8
		local
			i: INTEGER
			l_area: like area
		do
			create Result.make (count)
			l_area := area
			from
				i := 1
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
			create Result.make_from_string_8 (area + s)
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

	string_searcher: ESTRING_8_SEARCHER
			-- Facilities to search string in another string.
		do
			create Result.make
		end

feature {ESTRING_8, ESTRING_8_SEARCHER} -- Implementation
	wrapper (a: detachable separate STRING_8): STRING_8
		external
			"C inline"
		alias
			"return eif_access($a);"
		end

	fast_copy_separate (a: detachable separate STRING_8; b: SPECIAL[CHARACTER_8]; n: INTEGER)
		external
			"C inline use <string.h>"
		alias
			"{
		        EIF_PROCEDURE ep;
		        EIF_TYPE_ID tid;

		        tid = eif_type_id ("SPECIAL[CHARACTER_8]");
		        ep = eif_procedure ("copy_data", tid);
		        (ep) (eif_access($b),eif_access($a),0,0,$n);
			}"
		end

--				EIF_OBJECT area = eif_protect (eif_attribute ($a, "area", EIF_REFERENCE, 0));
--        		EIF_POINTER addr1 = eif_attribute (eif_access (area), "base_address", EIF_POINTER, 0);
--				EIF_POINTER addr2 = eif_attribute (eif_access ($b), "base_address", EIF_POINTER, 0);
--				memcpy (addr2, addr1, $n);
--				eif_wean (area);


	separate_area: separate like area
		attribute
			Result := ""
		end

	area: STRING_8
		local
			c: CHARACTER_8
			l_string: STRING_8
			i: INTEGER
		do
			if attached {STRING_8} separate_area as a then
				Result := a
			else
				l_string := wrapper(separate_area)

				create Result.make (l_string.count)
				from
					i := 1
				until
					i > l_string.count
				loop
					Result.extend (l_string[i])
					i := i + 1
				end
				--fast_copy_separate (separate_area, Result.area, count)
			end
		end

	item_32 (i: INTEGER): CHARACTER_32
		do
			Result := area[i].to_character_32
		end

end
