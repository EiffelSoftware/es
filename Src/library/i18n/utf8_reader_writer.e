indexing
	description: "Facilities to convert from FILE, POINTER, ARRAY[NATURAL_8], SPECIAL[NATURAL_8] to STRING_32 and viceversa."
	status: "NOTE: This class has NEVER been tested, don't use it in production environments!"
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	UTF8_READER_WRITER

feature -- Transformation (from pointer)
	file_to_string_32(a_file: FILE): STRING_32 is
			-- Read from a file and return a string32
		do
			Result := pointer_to_string_32(a_file.file_pointer, a_file.count)
		end

	pointer_to_string_32(a_pointer: POINTER; a_size: INTEGER): STRING_32 is
			-- Read from a file and return a string32
		local
			l_ptr: MANAGED_POINTER
			l_nat8: NATURAL_8
			l_code: NATURAL_32
			i, nb: INTEGER
		do
			from
				i := 0
				nb := a_size
				create l_ptr.make_from_pointer (a_pointer, nb)
				create Result.make_empty
			invariant
				i >= 0
				i <= nb
			variant
				nb - i
			until
				i > nb - 1
			loop
				l_nat8 := l_ptr.read_natural_8 (i)
				if l_nat8 <= 127 then
						-- Form 0xxxxxxx.
					Result.extend (l_nat8.to_character_8)
				elseif (l_nat8 & 0xE0) = 0xC0 then
						-- Form 110xxxxx 10xxxxxx.
					l_code := (l_nat8 & 0x1F).to_natural_32 |<< 6
					i := i + 1
					l_nat8 := l_ptr.read_natural_8 (i)
					l_code := l_code | (l_nat8 & 0x3F).to_natural_32
					Result.extend (l_code.to_character_32)
				elseif (l_nat8 & 0xF0) = 0xE0 then
					-- Form 1110xxxx 10xxxxxx 10xxxxxx.
					l_code := (l_nat8 & 0x0F).to_natural_32 |<< 12
					l_nat8 := l_ptr.read_natural_8 (i+1)
					l_code := l_code | ((l_nat8 & 0x3F).to_natural_32 |<< 6)
					l_nat8 := l_ptr.read_natural_8 (i+2)
					l_code := l_code | (l_nat8 & 0x3F).to_natural_32
					Result.extend (l_code.to_character_32)
					i := i + 2
				elseif (l_nat8 & 0xF8) = 0xF0 then
					-- Form 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx.
					l_code := (l_nat8 & 0x07).to_natural_32 |<< 18
					l_nat8 := l_ptr.read_natural_8 (i+1)
					l_code := l_code | ((l_nat8 & 0x3F).to_natural_32 |<< 12)
					l_nat8 := l_ptr.read_natural_8 (i+2)
					l_code := l_code | ((l_nat8 & 0x3F).to_natural_32 |<< 6)
					l_nat8 := l_ptr.read_natural_8 (i+3)
					l_code := l_code | (l_nat8 & 0x3F).to_natural_32
					Result.extend (l_code.to_character_32)
					i := i + 3
				elseif (l_nat8 & 0xFC) = 0xF8 then
					-- Starts with 111110xx
					-- This seems to be a 5 bytes character,
					-- but UTF-8 is restricted to 4, then substitute with a space
					Result.extend (' ')
					i := i + 4
				else
					-- Starts with 1111110x
					-- This seems to be a 6 bytes character,
					-- but UTF-8 is restricted to 4, then substitute with a space
					Result.extend (' ')
					i := i + 5
				end
				i := i + 1
			end
				-- Reset shared pointer.
			l_ptr.set_from_pointer (default_pointer, 0)
		end

feature -- Transformation (from special)
	array_natural_8_to_string_32(a_array: ARRAY[NATURAL_8]): STRING_32 is
			-- Read from an array of natural8 numbers and return a string32
		do
			Result := special_natural_8_to_string_32(a_array.to_special)
		end

	special_natural_8_to_string_32(a_special: SPECIAL[NATURAL_8]): STRING_32 is
			-- Read from a special of natural8 numbers and return a string32
		local
			l_nat8: NATURAL_8
			l_code: NATURAL_32
			i: INTEGER
		do
			from
				i := 1
				create Result.make_empty
			until
				i > a_special.count
			loop
				l_nat8 := a_special.item(i)
				if l_nat8 <= 127 then
						-- Form 0xxxxxxx.
					Result.extend (l_nat8.to_character_8)
				elseif (l_nat8 & 0xE0) = 0xC0 then
						-- Form 110xxxxx 10xxxxxx.
					l_code := (l_nat8 & 0x1F).to_natural_32 |<< 6
					i := i + 1
					l_nat8 := a_special.item(i)
					l_code := l_code | (l_nat8 & 0x3F).to_natural_32
					Result.extend (l_code.to_character_32)
				elseif (l_nat8 & 0xF0) = 0xE0 then
					-- Form 1110xxxx 10xxxxxx 10xxxxxx.
					l_code := (l_nat8 & 0x0F).to_natural_32 |<< 12
					l_nat8 := a_special.item(i+1)
					l_code := l_code | ((l_nat8 & 0x3F).to_natural_32 |<< 6)
					l_nat8 := a_special.item(i+2)
					l_code := l_code | (l_nat8 & 0x3F).to_natural_32
					Result.extend (l_code.to_character_32)
					i := i + 2
				elseif (l_nat8 & 0xF8) = 0xF0 then
					-- Form 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx.
					l_code := (l_nat8 & 0x07).to_natural_32 |<< 18
					l_nat8 := a_special.item(i+1)
					l_code := l_code | ((l_nat8 & 0x3F).to_natural_32 |<< 12)
					l_nat8 := a_special.item(i+2)
					l_code := l_code | ((l_nat8 & 0x3F).to_natural_32 |<< 6)
					l_nat8 := a_special.item(i+3)
					l_code := l_code | (l_nat8 & 0x3F).to_natural_32
					Result.extend (l_code.to_character_32)
					i := i + 3
				elseif (l_nat8 & 0xFC) = 0xF8 then
					-- Starts with 111110xx
					-- This seems to be a 5 bytes character,
					-- but UTF-8 is restricted to 4, then substitute with a space
					Result.extend (' ')
					i := i + 4
				else
					-- Starts with 1111110x
					-- This seems to be a 6 bytes character,
					-- but UTF-8 is restricted to 4, then substitute with a space
					Result.extend (' ')
					i := i + 5
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
