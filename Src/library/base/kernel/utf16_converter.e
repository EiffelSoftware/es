indexing
	description: "UTF16 implementation of UNICODE_CONVERTER"
	author: "Unicode Team"
	date: "$Date:$"
	revision: "$Revision:$"

class UTF16_CONVERTER -- BOM decides weather LITTLE ENDIAN or BIG ENDIAN UTF16 encoded is used

inherit
	UNICODE_CONVERTER
	IMPORTED_UNICODE_ROUTINES

feature -- character converter

	encoded_to_wide_character (b: ARRAY[NATURAL_8]) : WIDE_CHARACTER is
			-- convert array of bytes `b' to a wide_character
			-- every byte array character has a BOM!
		local
			bom1,bom2: NATURAL_8 -- [bom1|bom2|b1|b2]
			bbomless: ARRAY[NATURAL_8]
		do
			--remove BOM
			if b.count =4 then
				create bbomless.make (1,2)
				bbomless.subcopy (b,b.lower+2,b.lower+3,1)
			else
				create bbomless.make (1,4)
				bbomless.subcopy (b,b.lower+2,b.lower+5,1)
			end

			if b.item (b.lower) = 0xFF and b.item (b.lower+1) = 0xFE then -- little endian BOM = Byte Order Mark
				Result := utf16le.encoded_to_wide_character (bbomless)
			elseif b.item (b.lower) = 0xFE and b.item (b.lower+1) = 0xFF then -- BIG ENDIAN BOM = Byte Order Mark
				Result := utf16be.encoded_to_wide_character (bbomless)
			end
		end

	wide_character_to_encoded (c: WIDE_CHARACTER) : ARRAY[NATURAL_8] is
			-- convert wide_character `c' to a utf16le 8bit or 2x8bit array with little endian BOM
		do
			Result := wide_character_to_encoded_le (c)
		end


	wide_character_to_encoded_le (c: WIDE_CHARACTER) : ARRAY[NATURAL_8] is
			-- convert wide_character `c' to a utf16le 8bit or 2x8bit array with little endian BOM
		local
			bomless: ARRAY[NATURAL_8]
		do
			create Result.make (1,4)
			Result.put (0xFF,1)
			Result.put (0xFE,2)
			bomless := utf16le.wide_character_to_encoded (c)
			if bomless.count = 2 then
				Result.put (bomless.item (1),4)
				Result.put (bomless.item (2),3)
			else
				Result.force (bomless.item (3),6)
				Result.force (bomless.item (4),5)
			end
		ensure then
			is_valid_encoded: is_valid_encoded_array_as_character (result)
		end

	wide_character_to_encoded_be (c: WIDE_CHARACTER) : ARRAY[NATURAL_8] is
			-- convert wide_character `c' to a utf16be 2x8bit or 4x8bit array with BIG endian BOM
		local
			bomless: ARRAY[NATURAL_8]
		do
			create Result.make (1,4)
			Result.put (0xFE,1)
			Result.put (0xFF,2)
			bomless := utf16be.wide_character_to_encoded (c)
			if bomless.count = 2 then
				Result.put (bomless.item (1),3)
				Result.put (bomless.item (2),4)
			else
				Result.force (bomless.item (3),5)
				Result.force (bomless.item (4),6)
			end
		ensure then
			is_valid_encoded: is_valid_encoded_array_as_character (result)
		end



feature -- string converter

	string_32_to_encoded (s: STRING_32) : ARRAY[NATURAL_8] is
			-- convert string_32 `s' to a utf16 with little endian BOM
		do
			Result := string_32_to_encoded_le (s)
		end


	string_32_to_encoded_le (s: STRING_32) : ARRAY[NATURAL_8] is
			-- convert string_32 `s' to a utf16 with little endian BOM
		do
			s.prepend_character ((0xFEFF).to_character_32)
			Result := utf16le.string_32_to_encoded (s)
		ensure then
			Result_not_void: Result /= void
		end

	string_32_to_encoded_be (s: STRING_32) : ARRAY[NATURAL_8] is
			-- convert string_32 `s' to a utf16 with big endian BOM
		do
			s.prepend_character ((0xFEFF).to_character_32)
			Result := utf16be.string_32_to_encoded (s)
		ensure then
			Result_not_void: Result /= void
		end


	encoded_to_string_32 (b: ARRAY[NATURAL_8]) : STRING_32 is
			-- convert byte array of utf16 (little or big endian) `b' to a string_32
			-- removes BOM
		do
			if b.item (b.lower) = 0xFF and b.item (b.lower+1) = 0xFE then -- little endian BOM = Byte Order Mark
				Result := utf16le.encoded_to_string_32 (b.subarray (3, b.upper))
			elseif b.item (b.lower) = 0xFE and b.item (b.lower+1) = 0xFF then -- BIG ENDIAN BOM = Byte Order Mark
				Result := utf16be.encoded_to_string_32 (b.subarray (3,b.upper))
			end
		end


feature -- check states for character

	is_valid_encoded_array_as_character (a: ARRAY[NATURAL_8]): BOOLEAN is
			-- is the array as utf16 with little endian BOM encoded?
		local
			failure: BOOLEAN
		do
			if failure = False  then -- catches out of bound error
				if a.item (a.lower) = 0xFF and a.item (a.lower + 1) = 0xFE then -- little endian BOM = Byte Order Mark
					Result := True
				elseif a.item (a.lower) = 0xFE and a.item (a.lower + 1) = 0xFF then -- BIG ENDIAN BOM = Byte Order Mark
					Result := True
				else
					Result := False
				end
			else
				Result := False
			end
		rescue
			failure := True
			retry
		end

	is_valid_char_to_encode (c: WIDE_CHARACTER): BOOLEAN is
			-- is 's' a valid string to encode
		do
			Result := c.code < 0x100000 -- UTF16 allows just 20bits to be encoded
		end

feature -- check states for strings

	is_valid_encoded_array_as_string (a: ARRAY[NATURAL_8]): BOOLEAN is
			-- is byte array 'a' right encoded as utf16 with valid BOM?
		local
			failure: BOOLEAN
		do
			if failure = False then
				if a.item (a.lower) = 0xFF and a.item (a.lower + 1) = 0xFE then -- little endian BOM = Byte Order Mark
					Result := True
				elseif a.item (a.lower) = 0xFE and a.item (a.lower + 1) = 0xFF then -- BIG ENDIAN BOM = Byte Order Mark
					Result := True
				else
					Result := False
				end
			else
				Result := False
			end
		rescue
			failure := True
			retry
		end

	is_valid_string_to_encode (s: STRING_32): BOOLEAN is
			-- is 's' a valid string
		do
			Result := True
		end
end
