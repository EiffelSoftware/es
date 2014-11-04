note
	description: "{OUTPUT_STREAM} is a stream of outgoing bytes."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	OUTPUT_STREAM

feature -- Status report
	bytes_written: INTEGER
		-- The number of bytes written

	is_closed: BOOLEAN
		-- Whether the stream is closed. False does not imply that data will be written
		deferred
		end

	network_byte_order: BOOLEAN assign set_network_byte_order
		attribute
			Result := True
		ensure
			Result
		end

	charset: CHARSET assign set_charset

	cr_lf: BOOLEAN assign set_cr_lf
			-- Send CRLF instead of just LF with put_new_line

	error: IO_ERROR

feature -- Status setting
	set_network_byte_order (a_value: BOOLEAN)
		do
			network_byte_order := a_value
		ensure
			network_byte_order = a_value
		end

	set_charset (a_charset: CHARSET)
		do
			charset := a_charset
		ensure
			charset = a_charset
		end

	set_cr_lf (a_value: BOOLEAN)
		do
			cr_lf := a_value
		ensure
			cr_lf = a_value
		end

feature -- Output
	put_natural_8 (a_byte: NATURAL_8)
		do
			error := error.no_error
			put_pointer ($a_byte, 1)
		ensure
			no_more_than_a_byte: bytes_written <= 1
			bytes_written < 1 implies is_closed or not error.is_no_error
		end

	put_natural_16 (a_value: NATURAL_16)
		local
			l_value: like a_value
		do
			error := error.no_error
			if network_byte_order = platform.is_little_endian then

			   	l_value := a_value.bit_and (0x00FF).bit_shift_left (8)
			   			+  a_value.bit_and (0xFF00).bit_shift_right (8)
			else
				l_value := a_value
			end
			put_pointer ($l_value, 2)
		ensure
			no_more_than_two_bytes: bytes_written <= 2
			bytes_written < 2 implies is_closed or not error.is_no_error
		end

	put_natural_32 (a_value: NATURAL_32)
		local
			l_value: like a_value
		do
			error := error.no_error
			if network_byte_order = platform.is_little_endian then

			   	l_value := a_value.bit_and (0xFF000000).bit_shift_right (24)
			   			+  a_value.bit_and (0x00FF0000).bit_shift_right (8)
			   			+  a_value.bit_and (0x0000FF00).bit_shift_left (8)
			   			+  a_value.bit_and (0x000000FF).bit_shift_left (24)
			else
				l_value := a_value
			end
			put_pointer ($l_value, 4)
		ensure
			no_more_than_four_bytes: bytes_written <= 4
			bytes_written < 4 implies is_closed or not error.is_no_error
		end

	put_natural_64 (a_value: NATURAL_64)
		local
			l_value: like a_value
		do
			error := error.no_error
			if network_byte_order = platform.is_little_endian then

			   	l_value := a_value.bit_and (0xFF00000000000000).bit_shift_right (56)
			   			+  a_value.bit_and (0x00FF000000000000).bit_shift_right (40)
			   			+  a_value.bit_and (0x0000FF0000000000).bit_shift_right (24)
			   			+  a_value.bit_and (0x000000FF00000000).bit_shift_right (8)
			   			+  a_value.bit_and (0x00000000FF000000).bit_shift_left (8)
			   			+  a_value.bit_and (0x0000000000FF0000).bit_shift_left (24)
			   			+  a_value.bit_and (0x000000000000FF00).bit_shift_left (40)
			   			+  a_value.bit_and (0x00000000000000FF).bit_shift_left (56)
			else
				l_value := a_value
			end
			put_pointer ($l_value, 8)
		ensure
			no_more_than_eight_bytes: bytes_written <= 8
			bytes_written < 8 implies is_closed or not error.is_no_error
		end

	put_integer_8 (a_value: INTEGER_8)
		do
			error := error.no_error
			put_pointer ($a_value, 1)
		ensure
			no_more_than_a_byte: bytes_written <= 1
			bytes_written < 1 implies is_closed or not error.is_no_error
		end

	put_integer_16 (a_value: INTEGER_16)
		local
			l_value: like a_value
		do
			error := error.no_error
			if network_byte_order = platform.is_little_endian then

			   	l_value := a_value.bit_and (0x00FF).bit_shift_left (8)
			   			+  a_value.bit_and (0xFF00).bit_shift_right (8)
			else
				l_value := a_value
			end
			put_pointer ($l_value, 2)
		ensure
			no_more_than_two_bytes: bytes_written <= 2
			bytes_written < 2 implies is_closed or not error.is_no_error
		end

	put_integer_32 (a_value: INTEGER_32)
		local
			l_value: like a_value
		do
			error := error.no_error
			if network_byte_order = platform.is_little_endian then
			   	l_value := a_value.bit_and (0xFF000000).bit_shift_right (24)
			   			+  a_value.bit_and (0x00FF0000).bit_shift_right (8)
			   			+  a_value.bit_and (0x0000FF00).bit_shift_left (8)
			   			+  a_value.bit_and (0x000000FF).bit_shift_left (24)
			else
				l_value := a_value
			end
			put_pointer ($l_value, 4)
		ensure
			no_more_than_four_bytes: bytes_written <= 4
			bytes_written < 4 implies is_closed or not error.is_no_error
		end

	put_integer_64 (a_value: INTEGER_64)
		local
			l_value: like a_value
		do
			error := error.no_error
			if network_byte_order = platform.is_little_endian then
			   	l_value := a_value.bit_and (0xFF00000000000000).bit_shift_right (56)
			   			+  a_value.bit_and (0x00FF000000000000).bit_shift_right (40)
			   			+  a_value.bit_and (0x0000FF0000000000).bit_shift_right (24)
			   			+  a_value.bit_and (0x000000FF00000000).bit_shift_right (8)
			   			+  a_value.bit_and (0x00000000FF000000).bit_shift_left (8)
			   			+  a_value.bit_and (0x0000000000FF0000).bit_shift_left (24)
			   			+  a_value.bit_and (0x000000000000FF00).bit_shift_left (40)
			   			+  a_value.bit_and (0x00000000000000FF).bit_shift_left (56)
			else
				l_value := a_value
			end
			put_pointer ($l_value, 8)
		ensure
			no_more_than_eight_bytes: bytes_written <= 8
			bytes_written < 8 implies is_closed or not error.is_no_error
		end

	put_character_8 (a_character: CHARACTER_8)
		do
			error := error.no_error
			put_natural_8 (a_character.code.as_natural_8)
		ensure
			no_more_than_a_byte: bytes_written <= 1
			bytes_written < 1 implies is_closed or not error.is_no_error
		end

	put_character_32 (a_character: CHARACTER_32)
			-- Puts a {CHARACTER_32} according to the charset into the stream
		require
			charset.is_unknown implies a_character.is_character_8
		local
			c: NATURAL_32
			l_bytes_written: like bytes_written
		do
			error := error.no_error
			c := a_character.code.to_natural_32
			if charset.is_unknown then
				put_character_8 (a_character.to_character_8)
			elseif charset.is_utf_8 then
				if c <= 0x7F then
						-- 0xxxxxxx
					put_character_8 (c.to_character_8)
					l_bytes_written := l_bytes_written + bytes_written
				elseif c <= 0x7FF then
						-- 110xxxxx 10xxxxxx
					put_character_8 (((c |>> 6) | 0xC0).to_character_8)
					l_bytes_written := l_bytes_written + bytes_written
					put_character_8 (((c & 0x3F) | 0x80).to_character_8)
					l_bytes_written := l_bytes_written + bytes_written
				elseif c <= 0xFFFF then
						-- 1110xxxx 10xxxxxx 10xxxxxx
					put_character_8 (((c |>> 12) | 0xE0).to_character_8)
					l_bytes_written := l_bytes_written + bytes_written
					put_character_8 ((((c |>> 6) & 0x3F) | 0x80).to_character_8)
					l_bytes_written := l_bytes_written + bytes_written
					put_character_8 (((c & 0x3F) | 0x80).to_character_8)
					l_bytes_written := l_bytes_written + bytes_written
				else
						-- c <= 1FFFFF - there are no higher code points
						-- 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
					put_character_8 (((c |>> 18) | 0xF0).to_character_8)
					l_bytes_written := l_bytes_written + bytes_written
					put_character_8 ((((c |>> 12) & 0x3F) | 0x80).to_character_8)
					l_bytes_written := l_bytes_written + bytes_written
					put_character_8 ((((c |>> 6) & 0x3F) | 0x80).to_character_8)
					l_bytes_written := l_bytes_written + bytes_written
					put_character_8 (((c & 0x3F) | 0x80).to_character_8)
					l_bytes_written := l_bytes_written + bytes_written
				end
				bytes_written := l_bytes_written
			elseif charset.is_utf_16 then
				if c <= 0xFFFF then
						-- Codepoint from Basic Multilingual Plane: one 16-bit code unit.
					put_natural_16 (c.to_natural_16)
				else
						-- Supplementary Planes: surrogate pair with lead and trail surrogates.
					put_natural_16 ((0xD7C0 + (c |>> 10)).to_natural_16)
					l_bytes_written := bytes_written
					put_natural_16 ((0xDC00 + (c & 0x3FF)).to_natural_16)
					bytes_written := bytes_written + l_bytes_written
				end
			elseif charset.is_utf_32 then
				put_natural_32 (c)
			else
				-- Unsupported Charset
				check false end
			end
		ensure
			no_more_than_four_bytes: bytes_written <= 4
		end

	put_estring_32 (a_string: ESTRING_32)
		require
			charset.is_unknown implies a_string.is_valid_as_string_8
		local
			l_finished: BOOLEAN
			l_cell: CELL [INTEGER]
			i: INTEGER
			l_mp: MANAGED_POINTER
		do
			error := error.no_error
			if not is_closed then
				if charset.is_unknown then
					create l_mp.make (a_string.count)
					from
						i := 1
					until
						i > a_string.count or is_closed
					loop
						l_mp.put_character (a_string[i].to_character_8, i - 1)
						i := i + 1
					end
					put_managed_pointer (l_mp, 0, l_mp.count)
				elseif charset.is_utf_8 then
					create l_mp.make (a_string.count * 2)
					create l_cell.put (0)
					utf_converter.utf_32_string_into_utf_8_0_pointer (a_string, l_mp, 0, l_cell)
					put_managed_pointer (l_mp, 0, l_cell.item - 1)
				elseif charset.is_utf_16 then
					create l_mp.make (a_string.count * 3)
					create l_cell.put (0)
					utf_converter.utf_32_substring_into_utf_16_pointer (a_string, 1, a_string.count, l_mp, 0, l_cell)
					if platform.is_little_endian then
						from
							i := 0
						until
							i = l_cell.item
						loop
							l_mp.put_natural_16_be (l_mp.read_natural_16 (2*i), 2*i)
							i := i + 1
						end
					end
					put_managed_pointer (l_mp, 0, l_cell.item - 1)
				elseif charset.is_utf_32 then
					create l_mp.make(a_string.count * 4)
					from
						i := 0
					until
						i > a_string.count
					loop
						l_mp.put_integer_32_be (a_string[i].code, 4*i)
						i := i + 1
					end
					put_managed_pointer (l_mp, 0, l_mp.count)
				else
					-- Unsupported Charset
					check false end
				end
			end
		ensure
			no_more_than_max: bytes_written <= a_string.count * 4
		end

	put_new_line
		do
			error := error.no_error
			if charset.is_unknown or charset.is_utf_8 then
				if cr_lf then
					put_character_8 ('%R')
				end
				put_character_8 ('%N')
			elseif charset.is_utf_16 then
				if cr_lf then
					put_natural_16 (('%R').code.as_natural_16)
				end
				put_natural_16 (('%N').code.as_natural_16)
			elseif charset.is_utf_32 then
				if cr_lf then
					put_character_32 ('%R')
				end
				put_character_32 ('%N')
			end
		ensure
			no_more_than_eight_bytes: bytes_written <= 8
		end

	put_estring_8 (a_string: ESTRING_8)
		require
			charset.is_unknown implies a_string.is_valid_as_string_8
		local
			i: INTEGER
			l_mp: MANAGED_POINTER
		do
			error := error.no_error
			if not is_closed then
				create l_mp.make (a_string.count)
				from
					i := 1
				until
					i > a_string.count or is_closed
				loop
					l_mp.put_character (a_string[i], i - 1)
					i := i + 1
				end
				put_managed_pointer (l_mp, 0, l_mp.count)
			end
		ensure
			no_more_than_length_bytes: bytes_written <= a_string.count
			bytes_written < a_string.count implies is_closed or not error.is_no_error
		end

--	put_special (a_area: SPECIAL[NATURAL_8]; a_start_pos, a_end_pos: INTEGER)
--		require
--			a_area.count >= a_start_pos + a_end_pos - 1
--		deferred
--		ensure
--			bytes_send <= a_end_pos - a_start_pos + 1
--		end

	put_managed_pointer (p: MANAGED_POINTER; start_pos, nb_bytes: INTEGER)
			-- Put data of length `nb_bytes' pointed by `start_pos' index in `p' at
			-- current position.
		require
			nb_bytes > 0
			p.count >= start_pos + nb_bytes
		do
			error := error.no_error
			put_pointer (p.item + start_pos, nb_bytes)
		ensure
			bytes_written <= nb_bytes
			bytes_written < nb_bytes implies is_closed or not error.is_no_error
		end

	put_pointer (p: POINTER; nb_bytes: INTEGER)
			-- Put data of length `nb_bytes' pointed by `start_pos' index in `p' at
			-- current position.
		deferred
		ensure
			bytes_written <= nb_bytes
			bytes_written < nb_bytes implies is_closed or not error.is_no_error
		end

feature {NONE}
	platform: PLATFORM
		attribute
			create Result
		end

	utf_converter: UTF_CONVERTER

end
