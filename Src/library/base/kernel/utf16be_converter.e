indexing
	description: "UTF16BE implementation of UNICODE_CONVERTER"
	author: "Unicode Team"
	date: "$Date:$"
	revision: "$Revision:$"

class UTF16BE_CONVERTER -- BIG ENDIAN without BOM

inherit
	UNICODE_CONVERTER

feature -- character converter

	encoded_to_wide_character (b: ARRAY[NATURAL_8]) : WIDE_CHARACTER is
			-- convert utf16be byte array `b' to a wide_character
		local
			b1, b2, b3, b4: NATURAL_8	-- [b1|b2] or [b1|b2|b3|b4]
			new_code, high_bytes, low_bytes: NATURAL_32
		do
			if b.count = 2 then
				new_code := b.item (b.lower).to_natural_32.bit_shift_left (8) + b.item (b.lower + 1).to_natural_32
			else
				high_bytes := b.item (b.lower).to_natural_32.bit_shift_left (8) + b.item (b.lower + 1).to_natural_32 -- 0..0 | 1101 10ZZ ZZxx xxxx
				low_bytes  := b.item (b.lower + 2).to_natural_32.bit_shift_left (8) + b.item (b.lower + 3).to_natural_32 -- 0..0 | 1101 11yy yyyy yyyy

				high_bytes := high_bytes.bit_and (0x3FF)	-- 0..0 | 0000 00ZZ ZZxx xxxx
				 low_bytes :=  low_bytes.bit_and (0x3FF)	-- 0..0 | 0000 00yy yyyy yyyy

				new_code := high_bytes.bit_shift_left (10) + low_bytes	-- 0..0 0000 ZZZZ | xxxx xxyy yyyy yyyy
				new_code := new_code + 0x10000							-- 0..0 000z zzzz | xxxx xxyy yyyy yyyy
																		-- ZZZZ + 1 = zzzzz
			end
			Result := new_code.to_character_32
		ensure then
			is_valid_code: Result.is_valid_code
		end

	wide_character_to_encoded (c: WIDE_CHARACTER) : ARRAY[NATURAL_8] is
			-- convert wide_character `c' to a utf16be 16bit array
			--
			-- You will notice that the 4 byte encoding scheme for
			-- characters in the range U+010000 to U+10FFFF produces
			-- two 16 bit words, in the range 0xD800 to 0xDFFF.
			-- You might wonder what happens to Unicode characters
			-- in the range U+D800 to U+DFFF? In fact, Unicode doesn't
			-- use this range, it is reserved, precisely to allow UTF-16 to work.
			-- http://www.tenminutetutor.com/index.php?article=utf16
		local
			code, high_bytes, low_bytes: NATURAL_32
			b1,b2,b3,b4: NATURAL_8
		do
			code := c.natural_32_code

			if code > 0xFFFF then		-- 0xFFFF = 1111 1111 1111 1111
				create result.make (1, 4)
				code := code - 0x10000	-- 0x10000=10000 0000 0000 0000

				high_bytes := code.bit_shift_right (10).bit_and (0x3FF).bit_or (high_surrogate)	-- 16 bit High-Surrogate (U+D800 ... U+DBFF)
				low_bytes := code.bit_and (0x3FF).bit_or (low_surrogate)						-- 16 bit  Low-Surrogate (U+DC00 ... U+DFFF)

				b1 := high_bytes.bit_shift_right (8).to_natural_8	-- take the second 8 bits
				b2 := high_bytes.to_natural_8						-- take the first  8 bits

				b3 := low_bytes.bit_shift_right (8).to_natural_8	-- take the second 8 bits
				b4 := low_bytes.to_natural_8						-- take the first 8 bits

				result.put (b1,1)
				result.put (b2,2)
				result.put (b3,3)
				result.put (b4,4)
			else
				create result.make (1,2)
				result.put (code.bit_shift_right (8).as_natural_8, 1)	-- take the second 8 bits
				result.put (code.as_natural_8, 2)						-- take the first 8 bits
			end
		ensure then
			is_valid_encoded: is_valid_encoded_array_as_character (result)
		end

feature -- character helpfeatures

	high_surrogate: NATURAL_32 is 0xD800

	 low_surrogate: NATURAL_32 is 0xDC00


feature -- string converter

	string_32_to_encoded (s: STRING_32) : ARRAY[NATURAL_8] is
			-- convert string_32 `s' to a utf16be 8bit array
		local
			i,j,my_counter: INTEGER
			utf16_char: ARRAY[NATURAL_8]
		do
			my_counter := 0 -- intern counter for the previous position in 'result'
			from
				i := 1
				create Result.make (1, s.count)
			until
				i > s.count
			loop
				from
					utf16_char := wide_character_to_encoded (s.item (i))
					j:=1
				until
					j > utf16_char.count
				loop
					my_counter := my_counter + 1
					Result.force (utf16_char.item (j), my_counter)
					j := j+1
				end
				i := i + 1
			end
			Result.conservative_resize (1,my_counter) -- evtl. not neccessary
		end


	encoded_to_string_32 (b: ARRAY[NATURAL_8]) : STRING_32 is
			-- convert utf16be byte array `b' to a string_32
		local
			i: INTEGER
			high_bytes, low_bytes, new_code: NATURAL_32
		do
			create Result.make (b.count//2) -- maybe this is better than just taking the whole length
			from
				i:=b.lower
			until
				i > b.upper
			loop
				if b.item (i).bit_and (0xFC) = 0xD8 then		-- This the first byte of 2x16bit UTF16 character
					high_bytes := b.item (i).to_natural_32.bit_shift_left (8) + b.item (i+1).to_natural_32 		-- 0..0 | 1101 10ZZ ZZxx xxxx
					low_bytes  := b.item (i+2).to_natural_32.bit_shift_left (8) + b.item (i+3).to_natural_32 	-- 0..0 | 1101 11yy yyyy yyyy

					high_bytes := high_bytes.bit_and (0x3FF)	-- 0..0 | 0000 00ZZ ZZxx xxxx
					 low_bytes :=  low_bytes.bit_and (0x3FF)	-- 0..0 | 0000 00yy yyyy yyyy

					new_code := high_bytes.bit_shift_left (10) + low_bytes	-- 0..0 0000 ZZZZ | xxxx xxyy yyyy yyyy
					new_code := new_code + 0x10000							-- 0..0 000z zzzz | xxxx xxyy yyyy yyyy
																			-- ZZZZ + 1 = zzzzz
					Result.append_character (new_code.to_character_32)
					i := i + 4
				else
					new_code := b.item (i).to_natural_32.bit_shift_left (8) + b.item (i+1).to_natural_32
					Result.append_character (new_code.to_character_32)
					i := i + 2
				end
			end
		end


feature -- check states

	is_valid_encoded_array_as_character (a: ARRAY[NATURAL_8]): BOOLEAN is
			-- is byte array as utf16be encoded as character?
		local
			code: NATURAL_16
		do
			if a.count = 2 then
				code := (a.item (a.lower).to_natural_16.bit_shift_left (8) + a.item (a.lower + 1).to_natural_16)
				Result := code < 0xD800 or code > 0xDFFF
				-- Unicode doesn't use the range between U+D800 and U+DFFF
				-- It is reserved, precisely to allow UTF-16 to work.
			elseif a.count = 4 then
				 -- a1|a2: 1101 10ZZ | ZZxx xxxx
				 -- a3|a4: 1101 11yy | yyyy yyyy
				Result := (a.item (a.lower).bit_and (0xFC) = 0xD8) and (a.item (a.lower + 2).bit_and (0xFC) = 0xDC)
			else
				Result := False
			end
		end


	is_valid_encoded_array_as_string (a: ARRAY[NATURAL_8]): BOOLEAN is
			-- is byte array as utf16be encoded as a string?
		local
			code,i: INTEGER
			head: NATURAL_8
			failure: BOOLEAN
		do
			if failure = False  then -- catches out of bound error
				from
					i:=a.lower
					Result := True
				until
					i > a.upper or Result = False
				loop
					head := a.item(i)
					if head.bit_and (0xFC) = 0xD8 then -- 2x 16bit character
						Result := Result and a.item (i+2).bit_and (0xFC) = 0xDC --third byte
						i := i+4
					else	-- 1x 16bit character
						code := (a.item (i).to_natural_16.bit_shift_left (8) + a.item (i+1).to_natural_16)
						if (code < 0xD800 or code > 0xDFFF) then
							Result := Result and True
							i := i + 2
						else
							Result := False
						end
					end
				end -- loop end
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

	is_valid_string_to_encode (s: STRING_32): BOOLEAN is
			-- is 's' a valid string to encode
		do
			Result := True
		end




end
