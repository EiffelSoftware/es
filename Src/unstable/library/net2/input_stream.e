note
	description: "{INPUT_STREAM} is a generic incoming byte stream."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	INPUT_STREAM

inherit
	ITERABLE[NATURAL_8]

feature -- Status report
	is_closed: BOOLEAN
			-- Nothing can be read from a closed stream.
		deferred
		end

	network_byte_order: BOOLEAN assign set_network_byte_order
			-- Whether the data of this channel is coming in network byte order (big endian)
		attribute
			Result := True
		ensure
			Result
		end

	charset: CHARSET assign set_charset
			-- The charset to use when reading 32 bit characters and strings

	bytes_read: INTEGER
			-- The number of bytes read by the last operation. May be positive even if `is_closed' is True.

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

feature -- Access
	item: NATURAL_8

	last_character_8: CHARACTER_8

	last_character_32: CHARACTER_32

	last_character_incomplete: BOOLEAN

	last_natural_8: NATURAL_8

	last_natural_16: NATURAL_16

	last_natural_32: NATURAL_32

	last_natural_64: NATURAL_64

	last_integer_8: INTEGER_8

	last_integer_16: INTEGER_16

	last_integer_32: INTEGER_32

	last_integer_64: INTEGER_64

	last_estring_8: ESTRING_8

	last_estring_32: ESTRING_32

feature -- Input
	read_natural_8
		local
			l_item: NATURAL_8
		do
			read_to_pointer ($l_item, 1)
			last_natural_8 := l_item
		ensure
			bytes_read = 0 implies is_closed
			bytes_read <= 1
		end

	read_natural_16
		local
			l_value: NATURAL_16
		do
			read_to_pointer ($l_value, 2)
			if network_byte_order = platform.is_little_endian then
			   	l_value := l_value.bit_and (0x00FF).bit_shift_left (8)
			   			+  l_value.bit_and (0xFF00).bit_shift_right (8)
			end
			last_natural_16 := l_value
		ensure
			bytes_read = 0 implies is_closed
			bytes_read <= 2
		end

	read_natural_32
		local
			l_value: NATURAL_32
		do
			read_to_pointer ($l_value, 4)
			if network_byte_order = platform.is_little_endian then
			   	l_value := l_value.bit_and (0xFF000000).bit_shift_right (24)
			   			+  l_value.bit_and (0x00FF0000).bit_shift_right (8)
			   			+  l_value.bit_and (0x0000FF00).bit_shift_left (8)
			   			+  l_value.bit_and (0x000000FF).bit_shift_left (24)
			end
			last_natural_32 := l_value
		ensure
			bytes_read = 0 implies is_closed
			bytes_read <= 4
		end

	read_natural_64
		local
			l_value: NATURAL_64
		do
			read_to_pointer ($l_value, 8)
			if network_byte_order = platform.is_little_endian then
			   	l_value := l_value.bit_and (0xFF000000).bit_shift_right (24)
			   			+  l_value.bit_and (0x00FF0000).bit_shift_right (8)
			   			+  l_value.bit_and (0x0000FF00).bit_shift_left (8)
			   			+  l_value.bit_and (0x000000FF).bit_shift_left (24)
			end
			last_natural_64 := l_value
		ensure
			bytes_read < 8 implies is_closed
			bytes_read <= 8
		end

	read_character_8
		do
			read_natural_8
			last_character_8 := last_natural_8.to_character_8
		end

	read_character_32
			-- Reads a character_32 into `last_character_32' according to the charset.
			-- If the stream ended prematurely, `last_character_32' is set to NUL
		local
			l_item: natural
			c1, c2, c3, c4: NATURAL_8
			l_buf16: NATURAL_16
			l_bytes_read: INTEGER
		do
			if charset.is_unknown then
				read_natural_8
				last_character_32 := last_natural_8.to_character_32
			elseif charset.is_utf_8 then
				read_natural_8
				c1 := last_natural_8
				l_bytes_read := bytes_read
				if bytes_read > 0 then
					if c1 <= 0x7F then
							-- 0xxxxxxx
						last_character_32 := c1.to_character_32
					elseif c1 <= 0xDF then
							-- 110xxxxx 10xxxxxx
						read_natural_8
						l_bytes_read := l_bytes_read + bytes_read
						if bytes_read > 0 then
							c2 := last_natural_8
							last_character_32 := (
								((c1 & 0x1F) |<< 6) |
								(c2 & 0x3F)
							).to_character_32
						else
							last_character_32 := '%U'
							last_character_incomplete := True
						end
					elseif c1 <= 0xEF then
							-- 1110xxxx 10xxxxxx 10xxxxxx
						read_natural_8
						c2 := last_natural_8
						l_bytes_read := l_bytes_read + bytes_read
						read_natural_8
						c3 := last_natural_8
						l_bytes_read := l_bytes_read + bytes_read
						if bytes_read > 0 then
							last_character_32 := (
								((c1 & 0xF) |<< 12) |
								((c2 & 0x3F) |<< 6) |
								(c3 & 0x3F)
							).to_character_32
						else
							last_character_32 := '%U'
							last_character_incomplete := True
						end
					elseif c1 <= 0xF7 then
							-- 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
						read_natural_8
						l_bytes_read := l_bytes_read + bytes_read
						c2 := last_natural_8
						read_natural_8
						l_bytes_read := l_bytes_read + bytes_read
						c3 := last_natural_8
						read_natural_8
						l_bytes_read := l_bytes_read + bytes_read
						c4 := last_natural_8
						if bytes_read > 0 then
							last_character_32 := (
								((c1 & 0x7) |<< 18) |
								((c2 & 0x3F) |<< 12) |
								((c3 & 0x3F) |<< 6) |
								(c4 & 0x3F)
							).to_character_32
						else
							last_character_32 := '%U'
							last_character_incomplete := True
						end
					end
				else
					last_character_32 := '%U'
					last_character_incomplete := True
				end
				bytes_read := l_bytes_read
			elseif charset.is_utf_16 then
				read_natural_16
				l_buf16 := last_natural_16
				if bytes_read = 2 then
					if l_buf16 < 0xD800 or l_buf16 >= 0xE000 then
							-- Codepoint from Basic Multilingual Plane: one 16-bit code unit.
						last_character_32 := l_buf16.to_character_32
					else
						read_natural_16
							-- Supplementary Planes: surrogate pair with lead and trail surrogates.
						if bytes_read = 2 then
							last_character_32 := ((l_buf16.as_natural_32 |<< 10) + last_natural_16 - 0x35FDC00).to_character_32
						else
							last_character_32 := '%U'
							last_character_incomplete := True
						end
						bytes_read := bytes_read + 2
					end
				else
					last_character_32 := '%U'
					last_character_incomplete := True
				end
			elseif charset.is_utf_32 then
				read_natural_32
				if bytes_read = 4 then
					last_character_32 := last_natural_32.to_character_32
				else
					last_character_32 := '%U'
					last_character_incomplete := True
				end
			else
				check false end
			end
		ensure
			bytes_read <= 4
		end


	read_estring_32 (a_max_count: INTEGER)
		local
			l_buffer: STRING_32
			i: INTEGER
		do
			create l_buffer.make (a_max_count)
			from
				i := 1
			until
				is_closed or i > a_max_count
			loop
				read_character_32
				if not last_character_incomplete then
					l_buffer.extend (last_character_32)
				end
				i := i + 1
			end
			last_estring_32 := l_buffer
		ensure
			bytes_read = 0 implies is_closed
			charset.is_unknown implies bytes_read = last_estring_32.count
			charset.is_utf_8 implies bytes_read >= last_estring_32.count
			charset.is_utf_16 implies bytes_read >= last_estring_32.count * 2
			charset.is_utf_32 implies bytes_read = last_estring_32.count * 4 or
				bytes_read <= last_estring_32.count * 4 + 3 and
				bytes_read > last_estring_32.count * 4 and is_closed
		end

	read_estring_8 (a_max_count: INTEGER)
		local
			l_buffer: STRING_8
			i: INTEGER
		do
			create l_buffer.make (a_max_count)
			from
				i := 1
			until
				is_closed or i > a_max_count
			loop
				read_character_8
				if bytes_read > 0 then
					l_buffer.extend (last_character_8)
				end
				i := i + 1
			end
			last_estring_8 := l_buffer
			bytes_read := last_estring_8.count
		ensure
			bytes_read = 0 implies is_closed
			bytes_read = last_estring_8.count
		end

	read_into_special (a_area: SPECIAL[NATURAL_8]; a_start_pos, a_end_pos: INTEGER)
		require
			a_area.capacity > a_start_pos + a_end_pos - 1
			a_area.count >= a_start_pos - 1
			a_end_pos >= a_start_pos
		local
			i: INTEGER
			l_bytes_read: INTEGER
		do
			from
				i := a_start_pos
			until
				i > a_end_pos or is_closed
			loop
				read_natural_8
				if bytes_read > 0 then
					a_area[i] := last_natural_8
					l_bytes_read := l_bytes_read + 1
				end
				i := i + 1
			end
			bytes_read := l_bytes_read
		ensure
			bytes_read <= a_end_pos - a_start_pos + 1
			a_area.count >= a_start_pos + bytes_read - 1
		end

	read_to_pointer (p: POINTER; nb_bytes: INTEGER)
		require
			nb_bytes > 0
			-- Read at most `nb_bytes' bytes and make result
			-- available in `p'.
			-- The number of bytes read is available from `bytes_read'
		deferred
		ensure
			bytes_read = 0 implies is_closed
			bytes_read <= nb_bytes
		end

	read_to_managed_pointer (p: MANAGED_POINTER; start_pos, nb_bytes: INTEGER)
			-- Read at most `nb_bytes' bytes and make result
			-- available in `p' at position `start_pos'.
			-- The number of bytes read is available from `bytes_read'
		require
			nb_bytes > 0
			p.count >= start_pos + nb_bytes
		do
			read_to_pointer (p.item.plus (start_pos), nb_bytes)
		ensure
			bytes_read = 0 implies is_closed
			bytes_read <= nb_bytes
		end

	new_reader_32: INPUT_STREAM_READER
		-- Creates a new reader for this input stream on the same processor.
		do
			create Result.make (Current)
		end

	new_reader_8: INPUT_STREAM_READER_8
		-- Creates a new reader for this input stream on the same processor.
		do
			create Result.make_line_by_line (Current)
		end

	new_cursor: INPUT_STREAM_CURSOR
		do
			create Result.make (Current)
		end

feature {NONE}
	platform: PLATFORM
		attribute
			create Result
		end

	utf_converter: UTF_CONVERTER

invariant
	bytes_read >= 0

end
