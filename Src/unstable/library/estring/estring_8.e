note
	description: "{ESTRING_8} is an expanded, immutable 8-bit string. It defaults to an empty string."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	ESTRING_8

inherit

--	READABLE_STRING_GENERAL
--		rename
--			item as item_32
--		undefine
--			default_create
--		redefine
--			is_immutable,
--			out,
--			--is_equal,
--			to_string_32,
--			to_string_8
--		end

	READABLE_INDEXABLE[CHARACTER_8]
		undefine
			default_create,
			is_equal,
			out,
			copy
		end

	HASHABLE
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
	make_from_area

convert
--	make_from_string_general ({READABLE_STRING_GENERAL}),
	make_from_string_8 ({STRING_8}),
	make_from_string_32 ({STRING_32}),
	to_string_8: {STRING_8},
	to_string_32: {STRING_32},
	to_c_string: {C_STRING}
feature {NONE} -- Initialization
	default_create
		do
		end

	make_from_separate (a_string: separate READABLE_STRING_GENERAL)
		require
			a_string.is_valid_as_string_8
		local
			i: INTEGER
			l_string: MANAGED_POINTER
		do
			create l_string.make (a_string.count)
			from
				i := 1
			until
				i > a_string.count
			loop
				l_string.put_character (a_string[i].to_character_8, i - 1)
				i := i + 1
			end
			separate_area := l_string
			area := l_string.item
			count := l_string.count
		end

	make_from_string_general,
	make_from_string_8,
	make_from_string_32 (a_string: READABLE_STRING_GENERAL)
		require
			a_string.is_valid_as_string_8
		local
			i: INTEGER
			l_string: MANAGED_POINTER
		do
			create l_string.make (a_string.count)
			from
				i := 1
			until
				i > a_string.count
			loop
				l_string.put_character (a_string[i].to_character_8, i - 1)
				i := i + 1
			end
			separate_area := l_string
			area := l_string.item
			count := l_string.count
		end

	make_substring (a_string: like Current; a_lower, a_upper: INTEGER)
		require
			a_lower <= a_upper + 1
			a_lower > 0
			a_upper <= a_string.count
			a_string.is_valid_as_string_8
		local
			i: INTEGER
			l_string: MANAGED_POINTER
		do
			create l_string.make (a_upper - a_lower + 1)
			separate_area := l_string
			area := l_string.item

			from
				i := a_lower
			until
				i > a_upper
			loop
				l_string.put_character (a_string[i].to_character_8, i - a_lower)
				i := i + 1
			end
			count := l_string.count
		end

	make_as_lower (a_string: like Current)
		local
			i: INTEGER
			l_string: MANAGED_POINTER
		do
			create l_string.make (a_string.count)
			separate_area := l_string
			area := l_string.item

			count := a_string.count
			from
				i := 1
			until
				i > count
			loop
				l_string.put_character (a_string[i].as_lower.to_character_8, i - 1)
				i := i + 1
			end
		end

	make_as_upper (a_string: like Current)
		local
			i: INTEGER
			l_string: MANAGED_POINTER
		do
			create l_string.make (a_string.count)
			separate_area := l_string
			area := l_string.item

			count := a_string.count
			from
				i := 1
			until
				i > count
			loop
				l_string.put_character (a_string[i].as_upper.to_character_8, i - 1)
				i := i + 1
			end
		end

	make_from_c (a_pointer: POINTER)
		local
			l_mp: MANAGED_POINTER
		do
			create l_mp.share_from_pointer (a_pointer, 2147483647)
			from
				count := 0
			until
				l_mp.read_natural_8 (count) = 0
			loop
				count := count + 1
			end
			create l_mp.make_from_pointer (a_pointer, count)
			separate_area := l_mp
			area := l_mp.item
		end

	make_from_area (a_area: MANAGED_POINTER)
		do
			separate_area := a_area
			area := a_area.item
			count := a_area.count
		end

feature -- Access
	item alias "[]" (i: INTEGER): CHARACTER_8
		do
			($Result).memory_copy (area + (i - 1), 1)
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
		local
			l: like to_lower
		do
			l := to_lower
			Result := (l.is_equal("true") or
				l.is_equal("false"))
		end

	valid_index (i: INTEGER): BOOLEAN
			-- Is `i' a valid index?
		do
			Result := i > 0 and i <= count
		end

feature -- Measurement

	count: INTEGER

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

--	is_less alias "<" (a_other: like Current): BOOLEAN
--		local
--			l_string1, l_string2: like area
--		do
--			l_string1 := area
--			l_string2 := a_other.area
--			Result := l_string1 < l_string2
--		end

	is_equal (a_other: like Current): BOOLEAN
		local
			l_count: INTEGER
			l_other_area, l_area: like area
		do
			l_count := count
			Result := a_other.count = l_count
			if Result then
				Result := area.memory_compare (a_other.area, count)
			end
		end

feature -- Conversion

	to_lower: like Current
			-- New object with all letters in lower case.
		do
			create Result.make_as_lower (Current)
		end

	to_upper: like Current
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
				Result.extend (item_32 (i))
				i := i + 1
			end
		end

	to_string_8: STRING_8
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

	split (a_splitter: CHARACTER_8): ARRAY[ESTRING_8]
		local
			i, n, l, j: INTEGER
		do
			from
				i := 1
				n := 1
			until
				i > count
			loop
				if item (i) = a_splitter then
					n := n + 1
				end
				i := i + 1
			end
			create Result.make_filled (create {ESTRING_8}, 1, n)
			from
				i := 1
				l := 1
				j := 1
			until
				i > count
			loop
				if item (i) = a_splitter then
					Result[j] := substring (l, i-1)
					l := i + 1
					j := j + 1
				end
				i := i + 1
			end
			Result[j] := substring (l, i-1)
		end

	out: STRING_8
		do
			Result := to_string_8
		end


feature -- Element change

	plus alias "+" (s: like Current): like Current
		local
			l_area: MANAGED_POINTER
			l_count1, l_count2: INTEGER
			i: INTEGER
		do
			-- Todo less copying
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
			create Result.make_substring(Current, start_index, end_index)
		end

--	copy (a_other: like Current)
--		do
--			count := a_other.count
--			separate_area := a_other.separate_area
--			area := a_other.area
--		end

feature {ESTRING_8} -- Implementation
	wrapper (a: detachable separate STRING_8): STRING_8
		external
			"C inline"
		alias
			"return eif_access($a);"
		end

--	fast_copy (a: like Current): STRING_8
--		external
--			"C inline use <string.h>"
--		alias
--			"{
--				EIF_OBJECT separate_area = eif_protect (eif_attribute (eif_access($a), "separate_area", EIF_REFERENCE, 0));
--				EIF_INTEGER count = eif_attribute (eif_access($a), "count", EIF_REFERENCE, 0));
--				EIF_OBJECT area = eif_protect (eif_attribute (eif_access(separate_area), "area", EIF_REFERENCE, 0));
--        		EIF_POINTER addr1 = eif_attribute (eif_access (area), "base_address", EIF_POINTER, 0);
--				EIF_POINTER addr2 = eif_attribute (eif_access ($b), "base_address", EIF_POINTER, 0);
--				memcpy (addr2, addr1, $n);
--				EIF_OBJECT str = eif_protect (eif_string())
--				eif_wean (area);
--				eif_wean (separate_area);
--				return eif_string;
--			}"
--		end


	fast_copy (a: like Current; b: SPECIAL[CHARACTER_8]; n: INTEGER)
		external
			"C inline use <string.h>, <stdio.h>"
		alias
			"{
				EIF_REFERENCE separate_area_ref = eif_attribute (eif_access($a), "separate_area", EIF_REFERENCE, 0);
				EIF_OBJECT separate_area = eif_protect (separate_area_ref);
				memcpy (eif_access($b), eif_access(separate_area), $n);
				RT_SPECIAL_COUNT(eif_access($b)) = RT_SPECIAL_COUNT(eif_access($a));
				eif_wean (separate_area);
			}"
		end



--	fast_copy (a: detachable separate SPECIAL[CHARACTER_8]; b: SPECIAL[CHARACTER_8]; n: INTEGER)
--		external
--			"C inline use <string.h>, <stdio.h>"
--		alias
--			"{
--				memcpy (eif_access($b), eif_access($a), $n);
--				RT_SPECIAL_COUNT(eif_access($b)) = RT_SPECIAL_COUNT(eif_access($a));
--			}"
--		end

--				EIF_OBJECT area = eif_protect (eif_attribute ($a, "area", EIF_REFERENCE, 0));
--        		EIF_POINTER addr1 = eif_attribute (eif_access (area), "base_address", EIF_POINTER, 0);
--				EIF_POINTER addr2 = eif_attribute (eif_access ($b), "base_address", EIF_POINTER, 0);
--				memcpy (addr2, addr1, $n);
--				eif_wean (area);


	separate_area: detachable separate MANAGED_POINTER

	area: POINTER

	item_32 (i: INTEGER): CHARACTER_32
		do
			Result := item (i).to_character_32
		end

	calculate_hash (a_str: POINTER; a_count: INTEGER): INTEGER
		external
			"C inline"
		alias
			"{
		    	unsigned char *str = $a_str;
		        EIF_INTEGER hash = 5381;
		        int c;
		        int i;

		        for (i = 0; i < $a_count; i++)
		            hash = ((hash << 5) + hash) + c;

		        return hash;
			}"
		end

end
