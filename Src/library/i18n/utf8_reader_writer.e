indexing
	description: "Facilities to convert from FILE, POINTER, ARRAY[NATURAL_8], SPECIAL[NATURAL_8] to STRING_32 and vice versa."
	status: "NOTE: This class has NEVER been tested, don't use it in production environments!"
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	UTF8_READER_WRITER

inherit
	UC_IMPORTED_UTF8_ROUTINES


feature -- Reading Wrappers

	file_read_string_32 (a_file: FILE; limit: CHARACTER): STRING_32 is
			-- Read a UTF-8 string32 from current position in a_file'
			-- String end is delemited by limit', which is ? discarded
		local
			l_array: ARRAY[NATURAL_8]
		do
			Result := special_natural_8_to_string_32 (l_array.to_special)
		end

	array_natural_8_to_string_32 (a_array: ARRAY[NATURAL_8]): STRING_32 is
			-- Read from an array of natural8 numbers and return a string32
		do
			Result := special_natural_8_to_string_32(a_array.to_special)
		end


feature -- Reading

	special_natural_8_to_string_32 (a_special: SPECIAL[NATURAL_8]): STRING_32 is
			-- Read from a special of natural8 numbers and return a string32
			-- a_special' should be a sequence of bytes representing an UTF-8 encoded string
		local
			i, ch_len: INTEGER
			l_ch: CHARACTER
			code: NATURAL_32
		do
			create Result.make_empty
			from
				i := a_special.lower
				ch_len := 0 -- this is the number of bytes missing to complete the current character
			variant
				a_special.count - i + 1
			until
				i > a_special.upper
			loop
				l_ch := a_special.item (i).to_character_8
				if ch_len > 0 then
					-- we are in the middle of a multi-byte char
					ch_len := ch_len - 1 -- one byte fewer to decode
					code := code | ( l_ch.natural_32_code.bit_and (63) |<< (6*ch_len) )
					if ch_len <= 0 then
						-- this was last byte
						Result.append_character (code.to_character_32)
						code := 0
					end
				elseif utf8.is_encoded_first_byte (l_ch) then
					ch_len := utf8.encoded_byte_count (l_ch)
					if ch_len = 1 then
						-- this is an ascii character
						Result.append_character (l_ch.to_character_32)
					else
						-- first byte of a multibyte character
						code := l_ch.natural_32_code.bit_and ({NATURAL_8}.max_value.bit_shift_right (ch_len).as_natural_32).bit_shift_left (6*(ch_len-1))
					end
					ch_len := ch_len - 1
				else
					-- something was wrong in the bytes sequence
					-- just discard the character and put a whitespace
					ch_len := 0
					code := 0
				end
				i := i + 1
			end
		end

feature -- Writing

	file_write_string_32 (a_file: FILE; a_string: STRING_32) is
		-- Write a_string' to a_file' using UTF-8 encoding
	local
		ch_len, i: INTEGER
		l_byte: NATURAL_8
		l_code: NATURAL_32
	do
		from
			i := 1
		until
			i > a_string.count
		loop
			l_code := a_string.item (i).natural_32_code
			ch_len := utf8.code_byte_count (l_code.to_integer_32)
			if ch_len = 1 then
				a_file.put_natural_8 (l_code.as_natural_8)
			else
				l_byte := ((0xFC).to_natural_8 |>> (6-ch_len)) |<< (6-ch_len) -- prepare length encoding
				ch_len := ch_len - 1
				l_byte := l_byte | ( l_code |>> (ch_len*6) ).to_natural_8 -- first byte of the character
				a_file.put_natural_8 (l_byte)
				from
				variant
					ch_len+1
				until
					ch_len <= 0
				loop
					-- following bytes
					ch_len := ch_len - 1
					l_byte := (0x80).to_natural_8 | (l_code |>> (ch_len*6) & 0x3F).to_natural_8
					a_file.put_natural_8 (l_byte)
				end
				i := i + 1
			end
		end
	end

end
