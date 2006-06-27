indexing
	description: "UTF8 implementation of UNICODE_CONVERTER"
	author: "Unicode Team"
	date: "$Date$"
	revision: "$Revision$"


class UTF8_CONVERTER

inherit
	UNICODE_CONVERTER

feature -- character converter

	encoded_to_wide_character (b: ARRAY[NATURAL_8]) : WIDE_CHARACTER is
			-- convert utf8 byte array `b' to a wide_character
		local
			b1, b2, b3, b4, b5, b6: NATURAL_32	-- [b1|b2|b3|b4|b5|b6]
			new_code: NATURAL_32				-- decoded unicode number
		do
			if b.count = 1 then	-- ASCII character -- nothing to transform
				new_code := b.item (b.lower).to_natural_32
			elseif b.count = 2 then
				b1 := b.item (b.lower).to_natural_32.bit_and (0x1F) -- take first 5 bits
				b2 := b.item (b.lower + 1).to_natural_32.bit_and (0x3F) -- take first 6 bits
				new_code := b1.bit_shift_left (6) + b2
			elseif b.count = 3 then
				b1 := b.item (b.lower).to_natural_32.bit_and (0x0F) -- take first 4 bits
				b2 := b.item (b.lower + 1).to_natural_32.bit_and (0x3F) -- take first 6 bits
				b3 := b.item (b.lower + 2).to_natural_32.bit_and (0x3F) -- take first 6 bits
				new_code := b1.bit_shift_left (12) + b2.bit_shift_left (6) + b3
			elseif b.count = 4 then
				b1 := b.item (b.lower).to_natural_32.bit_and (0x7) -- take first 3 bits
				b2 := b.item (b.lower + 1).to_natural_32.bit_and (0x3F) -- take first 6 bits
				b3 := b.item (b.lower + 2).to_natural_32.bit_and (0x3F) -- take first 6 bits
				b4 := b.item (b.lower + 3).to_natural_32.bit_and (0x3F) -- take first 6 bits
				new_code := b1.bit_shift_left (18) + b2.bit_shift_left (12) + b3.bit_shift_left (6) + b4
			elseif b.count = 5 then
				b1 := b.item (b.lower).to_natural_32.bit_and (0x3) -- take first 2 bits
				b2 := b.item (b.lower + 1).to_natural_32.bit_and (0x3F) -- take first 6 bits
				b3 := b.item (b.lower + 2).to_natural_32.bit_and (0x3F) -- take first 6 bits
				b4 := b.item (b.lower + 3).to_natural_32.bit_and (0x3F) -- take first 6 bits
				b5 := b.item (b.lower + 4).to_natural_32.bit_and (0x3F) -- take first 6 bits
				new_code := b1.bit_shift_left(24) + b2.bit_shift_left (18) + b3.bit_shift_left (12) + b4.bit_shift_left (6) + b5
			elseif b.count = 6 then
				b1 := b.item (b.lower).to_natural_32.bit_and (0x1) -- take first 1 bit
				b2 := b.item (b.lower + 1).to_natural_32.bit_and (0x3F) -- take first 6 bits
				b3 := b.item (b.lower + 2).to_natural_32.bit_and (0x3F) -- take first 6 bits
				b4 := b.item (b.lower + 3).to_natural_32.bit_and (0x3F) -- take first 6 bits
				b5 := b.item (b.lower + 4).to_natural_32.bit_and (0x3F) -- take first 6 bits
				b6 := b.item (b.lower + 5).to_natural_32.bit_and (0x3F) -- take first 6 bits
				new_code := b1.bit_shift_left (30) +  b2.bit_shift_left(24) + b3.bit_shift_left (18) + b4.bit_shift_left (12) + b5.bit_shift_left (6) + b6
			end
			Result :=  new_code.to_character_32	-- convert the computed number into a wide_character
		ensure then
			is_valid_code: Result.is_valid_code
		end


	wide_character_to_encoded (c: WIDE_CHARACTER) : ARRAY[NATURAL_8] is
			-- convert wide_character `c' to an utf8 byte array character
		local
			b1, b2, b3, b4, b5, b6: NATURAL_8
			code: INTEGER	-- number code of the character
		do
			code := c.code
			inspect code_byte_count (c)
			when 1 then
					-- 0xxx xxxx ascii character
				create result.make (1,1)
				Result.put (code.as_natural_8,1)
			when 2 then
				b1 := code.bit_shift_right (6).bit_and (0x1F).bit_or (0xC0).to_natural_8 	-- take first 5 bits and add 1100 0000
				b2 := code.bit_and (0x3F).bit_or (0x80).to_natural_8						-- take next 6 bits and add 1000 0000
				-- 0x3F = 0011 1111
				-- 0x1F = 0001 1111
				create result.make (1,2)
				result.put (b1,1)
				result.put (b2,2)
			when 3 then
				b1 := code.bit_shift_right (12).bit_and (0xF).bit_or (0xE0).to_natural_8	-- take first 4bits (after 12bits) and add 1110 0000
				b2 := code.bit_shift_right (6).bit_and (0x3F).bit_or (0x80).to_natural_8	-- take next 6bits (after 6bits) and add 1000 0000
				b3 := code.bit_and (0x3F).bit_or (0x80).to_natural_8						-- take next 6bits and add 1000 0000
				-- 0x3F = 0011 1111
				-- 0x1F = 0001 1111
				-- 0xF  = 0000 1111

				create result.make (1,3)
				result.put(b1,1)
				result.put(b2,2)
				result.put(b3,3)
			when 4 then
				b1 := code.bit_shift_right (18).bit_and (0x7).bit_or (0xF0).to_natural_8	-- take first 3bits (after 18bits) and add 1111 0000
				b2 := code.bit_shift_right (12).bit_and (0x3F).bit_or (0x80).to_natural_8	-- take next 6bits (after 12bits) and add 1000 0000
				b3 := code.bit_shift_right ( 6).bit_and (0x3F).bit_or (0x80).to_natural_8	-- take next 6bits (after 6bits)  and add 1000 0000
				b4 := code.bit_and (0x3F).bit_or (0x80).to_natural_8						-- take last 6bits and add 1000 0000

				-- 0x3F = 0011 1111
				-- 0x1F = 0001 1111
				-- 0xF  = 0000 1111
				-- 0x7	= 0000 0111

				create result.make (1,4)
				result.put (b1,1)
				result.put (b2,2)
				result.put (b3,3)
				result.put (b4,4)
			when 5 then
				b1 := code.bit_shift_right (24).bit_and (0x3).bit_or (0xF8).to_natural_8	-- take first 2bits (after 24bits) and add 1111 1000
				b2 := code.bit_shift_right (18).bit_and (0x3F).bit_or (0x80).to_natural_8	-- take next 6bits (after 18bits) and add 1000 0000
				b3 := code.bit_shift_right (12).bit_and (0x3F).bit_or (0x80).to_natural_8	-- take next 6bits (after 12bits) and add 1000 0000
				b4 := code.bit_shift_right ( 6).bit_and (0x3F).bit_or (0x80).to_natural_8	-- take next 6bits (after 6bits)  and add 1000 0000
				b5 := code.bit_and (0x3F).bit_or (0x80).to_natural_8						-- take first 6bits and add 1000 0000

				-- 0x3F = 0011 1111
				-- 0x1F = 0001 1111
				-- 0xF  = 0000 1111
				-- 0x7	= 0000 0111
				-- 0x3  = 0000 0011

				create result.make (1,5)
				result.put (b1,1)
				result.put (b2,2)
				result.put (b3,3)
				result.put (b4,4)
				result.put (b5,5)
			when 6 then
				b1 := code.bit_shift_right (30).bit_and (0x1).bit_or (0xFC).to_natural_8	-- take first 1bit  (after 30bits) and add 1111 1100
				b2 := code.bit_shift_right (24).bit_and (0x3F).bit_or (0x80).to_natural_8	-- take next 6bits (after 24bits) and add 1000 0000
				b3 := code.bit_shift_right (18).bit_and (0x3F).bit_or (0x80).to_natural_8	-- take next 6bits (after 18bits) and add 1000 0000
				b4 := code.bit_shift_right (12).bit_and (0x3F).bit_or (0x80).to_natural_8	-- take next 6bits (after 12bits) and add 1000 0000
				b5 := code.bit_shift_right (6).bit_and (0x3F).bit_or (0x80).to_natural_8	-- take next 6bits (after 6bits)  and add 1000 0000
				b6 := code.bit_and (0x3F).bit_or (0x80).to_natural_8						-- take first 6bits and add 1000 0000

				-- 0x3F = 0011 1111
				-- 0x1F = 0001 1111
				-- 0xF  = 0000 1111
				-- 0x7	= 0000 0111
				-- 0x3  = 0000 0011
				-- 0x1  = 0000 0001

				create result.make (1,6)
				result.put (b1,1)
				result.put (b2,2)
				result.put (b3,3)
				result.put (b4,4)
				result.put (b5,5)
				result.put (b6,6)
			else
				-- utf8 encoding has only 6 bytes
			end
		ensure then
			is_valid_utf8: is_valid_encoded_array_as_character (Result)
		end



feature -- character helpfeatures

	code_byte_count (c: WIDE_CHARACTER): INTEGER is
		-- Number of bytes needed to encode unicode character
		-- with the utf-8 encoding
		local
			code: INTEGER
		do
			code := c.code
			if code < 128 then
					-- 2^7
					-- 0xxxxxxx
				Result := 1
			elseif code < 2048 then
					-- 2^11
					-- 110xxxxx 10xxxxxx
				Result := 2
			elseif code < 65536 then
					-- 2^16
					-- 1110xxxx 10xxxxxx 10xxxxxx
				Result := 3
			elseif code < 2097152 then
					-- 2^21
					-- 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
				Result := 4
			elseif code < 67108864 then
					-- 2^26
					-- 111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
				Result := 5
			else
					-- 2^31
					-- 1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
				Result := 6
			end
		ensure
			code_byte_count_large_enough: Result >= 1
			code_byte_count_small_enough: Result <= 6
		end




feature -- string converter

	string_32_to_encoded (s: STRING_32) : ARRAY[NATURAL_8] is
			-- convert string_32 `s' to a utf8 byte array string
		local
			i,j,my_counter: INTEGER
			utf8_char: ARRAY[NATURAL_8]
		do
			my_counter := 0 -- my intern counter for the previous position in 'result'
			from
				i := 1
				create Result.make (1, s.count)
			until
				i > s.count
			loop
				from
					utf8_char := wide_character_to_encoded (s.item (i))
					j:=1
				until
					j > utf8_char.count
				loop
					my_counter := my_counter + 1
					Result.force (utf8_char.item (j), my_counter)
					j := j+1
				end
				i := i + 1
			end
			Result.conservative_resize (1,my_counter)
		end

	encoded_to_string_32 (b: ARRAY[NATURAL_8]) : STRING_32 is
			-- convert utf8 byte array `b' to a string_32
		local
			i: INTEGER
			b1, b2, b3, b4, b5, b6: NATURAL_32
		do
			create Result.make (b.count//2) -- maybe this is better than just taking the whole length
			from
				i:=b.lower
			until
				i > b.upper
			loop
				if b.item (i) <= 0x7F then		-- 0xxx xxxx ASCII case: 0x7F = 0111 1111
					Result.append_character (b.item (i).to_character_32)
					i := i + 1
				elseif b.item (i) <= 0xDF then 	-- 110x xxxx two byte character: 0xDF = 1101 1111
					b1 := b.item (i).to_natural_32.bit_and (0x1F) -- take first 5 bits
					b2 := b.item (i+1).to_natural_32.bit_and (0x3F) -- take first 6 bits
					Result.append_character ((b1.bit_shift_left (6) + b2).to_character_32)
					i := i + 2
				elseif b.item (i) <= 0xEF then 	-- 1110 xxxx three byte character: 0xEF = 1110 1111
					b1 := b.item (i).to_natural_32.bit_and (0x0F) -- take first 4 bits
					b2 := b.item (i+1).to_natural_32.bit_and (0x3F) -- take first 6 bits
					b3 := b.item (i+2).to_natural_32.bit_and (0x3F) -- take first 6 bits
					Result.append_character ((b1.bit_shift_left (12) + b2.bit_shift_left (6) + b3).to_character_32)
					i := i + 3
				elseif b.item (i) <= 0xF7 then	-- 1111 0xxx four byte character: 0xF7 = 1111 0111
					b1 := b.item (i).to_natural_32.bit_and (0x7) -- take first 3 bits
					b2 := b.item (i+1).to_natural_32.bit_and (0x3F) -- take first 6 bits
					b3 := b.item (i+2).to_natural_32.bit_and (0x3F) -- take first 6 bits
					b4 := b.item (i+3).to_natural_32.bit_and (0x3F) -- take first 6 bits
					Result.append_character ((b1.bit_shift_left (18) + b2.bit_shift_left (12) + b3.bit_shift_left (6) + b4).to_character_32)
					i := i + 4
				elseif b.item (i) <= 0xFB then	-- 1111 10xx five byte character: 0xFB = 1111 1011
					b1 := b.item (i).to_natural_32.bit_and (0x3) -- take first 2 bits
					b2 := b.item (i+1).to_natural_32.bit_and (0x3F) -- take first 6 bits
					b3 := b.item (i+2).to_natural_32.bit_and (0x3F) -- take first 6 bits
					b3 := b.item (i+3).to_natural_32.bit_and (0x3F) -- take first 6 bits
					b4 := b.item (i+4).to_natural_32.bit_and (0x3F) -- take first 6 bits
					Result.append_character ((b1.bit_shift_left(24) + b2.bit_shift_left (18) + b3.bit_shift_left (12) + b4.bit_shift_left (6) + b5).to_character_32)
					i := i + 5
				elseif b.item (i) <= 0xFD then	-- 1111 110x six byte character: 0xFD = 1111 1101
					b1 := b.item (i).to_natural_32.bit_and (0x1) -- take first 1 bit
					b2 := b.item (i+1).to_natural_32.bit_and (0x3F) -- take first 6 bits
					b3 := b.item (i+2).to_natural_32.bit_and (0x3F) -- take first 6 bits
					b4 := b.item (i+3).to_natural_32.bit_and (0x3F) -- take first 6 bits
					b5 := b.item (i+4).to_natural_32.bit_and (0x3F) -- take first 6 bits
					b6 := b.item (i+5).to_natural_32.bit_and (0x3F) -- take first 6 bits
					Result.append_character ((b1.bit_shift_left (30) +  b2.bit_shift_left(24) + b3.bit_shift_left (18) + b4.bit_shift_left (12) + b5.bit_shift_left (6) + b6).to_character_32)
					i := i + 6
				end
			end
		end



feature -- check states


	is_valid_encoded_array_as_character (a: ARRAY[NATURAL_8]): BOOLEAN is
			-- is the array as utf8 character encoded?
		do
			inspect a.count
			when 1 then
				Result := a.item (a.lower) <= 0x7F
			when 2 then
				Result := a.item (a.lower).bit_and (0xE0) = 0xC0
				Result := Result and a.item (a.lower + 1).bit_and (0xC0) = 0x80
			when 3 then
				Result := a.item (a.lower).bit_and (0xF0) = 0xE0
				Result := Result and a.item (a.lower + 1).bit_and (0xC0) = 0x80
				Result := Result and a.item (a.lower + 2).bit_and (0xC0) = 0x80
			when 4 then
				Result := a.item (a.lower).bit_and (0xF8) = 0xF0
				Result := Result and a.item (a.lower + 1).bit_and (0xC0) = 0x80
				Result := Result and a.item (a.lower + 2).bit_and (0xC0) = 0x80
				Result := Result and a.item (a.lower + 3).bit_and (0xC0) = 0x80
			when 5 then
				Result := a.item (a.lower).bit_and (0xFC) = 0xF8
				Result := Result and a.item (a.lower + 1).bit_and (0xC0) = 0x80
				Result := Result and a.item (a.lower + 2).bit_and (0xC0) = 0x80
				Result := Result and a.item (a.lower + 3).bit_and (0xC0) = 0x80
				Result := Result and a.item (a.lower + 4).bit_and (0xC0) = 0x80
			when 6 then
				Result := a.item (a.lower).bit_and (0xFE) = 0xFC
				Result := Result and a.item (a.lower + 1).bit_and (0xC0) = 0x80
				Result := Result and a.item (a.lower + 2).bit_and (0xC0) = 0x80
				Result := Result and a.item (a.lower + 3).bit_and (0xC0) = 0x80
				Result := Result and a.item (a.lower + 4).bit_and (0xC0) = 0x80
				Result := Result and a.item (a.lower + 5).bit_and (0xC0) = 0x80
			end
		end


	is_valid_encoded_array_as_string (a: ARRAY[NATURAL_8]): BOOLEAN is
			-- is the array as utf8 string encoded?
		local
			i: INTEGER
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
					if head <=0x7F then
						Result := Result and True
						i := i+1
					elseif head.bit_and (0xC0) = 0x80 then -- 0x80 = 1000 0000
						Result := False
					elseif head.bit_and (0xE0) = 0xC0 then -- 0xC0 = 1100 0000
						Result := Result and a.item (i+1).bit_and (0xC0) = 0x80
						i := i+2
					elseif head.bit_and (0xF0) = 0xE0 then -- 0xE0 = 1110 0000
						Result := Result and a.item (i+1).bit_and (0xC0) = 0x80
						Result := Result and a.item (i+2).bit_and (0xC0) = 0x80
						i := i+3
					elseif head.bit_and (0xF8) = 0xF0 then -- 0xF0 = 1111 0000
						Result := Result and a.item (i+1).bit_and (0xC0) = 0x80
						Result := Result and a.item (i+2).bit_and (0xC0) = 0x80
						Result := Result and a.item (i+3).bit_and (0xC0) = 0x80
						i := i+4
					elseif head.bit_and (0xFC) = 0xF8 then -- 0xF8 = 1111 1000
						Result := Result and a.item (i+1).bit_and (0xC0) = 0x80
						Result := Result and a.item (i+2).bit_and (0xC0) = 0x80
						Result := Result and a.item (i+3).bit_and (0xC0) = 0x80
						Result := Result and a.item (i+4).bit_and (0xC0) = 0x80
						i := i+5
					elseif head.bit_and (0xFE) = 0xFC then -- 0xFC = 1111 1100
						Result := Result and a.item (i+1).bit_and (0xC0) = 0x80
						Result := Result and a.item (i+2).bit_and (0xC0) = 0x80
						Result := Result and a.item (i+3).bit_and (0xC0) = 0x80
						Result := Result and a.item (i+4).bit_and (0xC0) = 0x80
						Result := Result and a.item (i+5).bit_and (0xC0) = 0x80
						i := i+6
					else
						Result := False
					end
				end -- loop end
			else
				Result := False
			end
		rescue
			failure := True
			retry
		end -- do end


	is_valid_char_to_encode (c: WIDE_CHARACTER): BOOLEAN is
			-- is 's' a valid string to encode
		do
			Result := True	-- no restrictions
		end

	is_valid_string_to_encode (s: STRING_32): BOOLEAN is
			-- is 's' a valid string to encode
		do
			Result := True -- no restrictions
		end

end
