note
	description: "A {BUFFERED_INPUT_STREAM} wraps an input stream to provide a buffer and useful features to read it."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

class
	BUFFERED_INPUT_STREAM

inherit
	INPUT_STREAM

create
	make

feature {NONE} -- Initialization
	make (a_stream: INPUT_STREAM; a_buffer_size: INTEGER)
		require
			a_buffer_size >= 8
		do
			upstream := a_stream
			create buffer.make (a_buffer_size)
		ensure
			upstream = a_stream
		end

feature -- Status report
	buffer_pos: INTEGER

	use_crlf: BOOLEAN assign set_crlf
			-- Use CRLF instead of LF for newline

	is_readable: BOOLEAN
		do
			Result := upstream.is_readable or buffer_pos < buffer_count
		end

feature -- Status setting
	rewind (i: INTEGER)
		-- Rewind inside the buffer, if the buffer is big enough
		require
			i > 0
			i <= buffer_pos
		do
			buffer_pos := buffer_pos - i
		ensure
			buffer_pos = old buffer_pos - i
		end

	set_crlf (a_value: BOOLEAN)
		do
			use_crlf := a_value
		end

	close
		do
			upstream.close
		end

feature -- Input
	read_real
			-- Read a new real.
			-- Make result available in `last_real'.
		do
			retrieve (buffer.real_bytes)
			if buffer_count - buffer_pos >= buffer.real_bytes then
				last_real := buffer.read_real_32_be (buffer_pos)
				buffer_pos := buffer_pos + buffer.real_bytes
			end
		end

	read_double
			-- Read a new double.
			-- Make result available in `last_double'.
		do
			retrieve (buffer.double_bytes)
			if buffer_count - buffer_pos >= buffer.double_bytes then
				last_real_64 := buffer.read_real_64_be (buffer_pos)
				buffer_pos := buffer_pos + buffer.double_bytes
			end
		end

	read_character
			-- Read a new character.
			-- Make result available in `last_character'.
		do
			retrieve (buffer.character_8_bytes)
			if buffer_count - buffer_pos >= buffer.character_8_bytes then
				last_character := buffer.read_character (buffer_pos)
				buffer_pos := buffer_pos + buffer.character_8_bytes
			end
		end

	read_integer, read_integer_32
			-- Read a new 32-bit integer.
			-- Make result available in `last_integer'.
		do
			retrieve (buffer.integer_32_bytes)
			if buffer_count - buffer_pos >= buffer.integer_32_bytes then
				last_integer := buffer.read_integer_32_be (buffer_pos)
				buffer_pos := buffer_pos + buffer.integer_32_bytes
			end
		end

	read_integer_8
			-- Read a new 8-bit integer.
			-- Make result available in `last_integer_8'.
		do
			retrieve (buffer.integer_8_bytes)
			if buffer_count - buffer_pos >= buffer.integer_8_bytes then
				last_integer_8 := buffer.read_integer_8_be (buffer_pos)
				buffer_pos := buffer_pos + buffer.integer_8_bytes
			end
		end

	read_integer_16
			-- Read a new 16-bit integer.
			-- Make result available in `last_integer_16'.
		do
			retrieve (buffer.integer_16_bytes)
			if buffer_count - buffer_pos >= buffer.integer_16_bytes then
				last_integer_16 := buffer.read_integer_16_be (buffer_pos)
				buffer_pos := buffer_pos + buffer.integer_16_bytes
			end
		end


	read_integer_64
			-- Read a new 64-bit integer.
			-- Make result available in `last_integer_64'.
		do
			retrieve (buffer.integer_64_bytes)
			if buffer_count - buffer_pos >= buffer.integer_64_bytes then
				last_integer_64 := buffer.read_integer_64_be (buffer_pos)
				buffer_pos := buffer_pos + buffer.integer_64_bytes
			end
		end


	read_natural_8
			-- Read a new 8-bit natural.
			-- Make result available in `last_natural_8'.
		do
			retrieve (buffer.natural_8_bytes)
			if buffer_count - buffer_pos >= buffer.natural_8_bytes then
				last_natural_8 := buffer.read_natural_8_be (buffer_pos)
				buffer_pos := buffer_pos + buffer.natural_8_bytes
			end
		end

	read_natural_16
			-- Read a new 16-bit natural.
			-- Make result available in `last_natural_16'.
		do
			retrieve (buffer.natural_16_bytes)
			if buffer_count - buffer_pos >= buffer.natural_16_bytes then
				last_natural_16 := buffer.read_natural_16_be (buffer_pos)
				buffer_pos := buffer_pos + buffer.natural_16_bytes
			end
		end

	read_natural, read_natural_32
			-- Read a new 32-bit natural.
			-- Make result available in `last_natural'.
		do
			retrieve (buffer.natural_32_bytes)
			if buffer_count - buffer_pos >= buffer.natural_32_bytes then
				last_natural := buffer.read_natural_32_be (buffer_pos)
				buffer_pos := buffer_pos + buffer.natural_32_bytes
			end
		end

	read_natural_64
			-- Read a new 64-bit natural.
			-- Make result available in `last_natural_64'.
		do
			retrieve (buffer.natural_64_bytes)
			if buffer_count - buffer_pos >= buffer.natural_64_bytes then
				last_natural_64 := buffer.read_natural_64_be (buffer_pos)
				buffer_pos := buffer_pos + buffer.natural_64_bytes
			end
		end

	read_stream (nb_char: INTEGER)
			-- Read a string of at most `nb_char' bound characters
			-- or until end of medium is encountered.
			-- Make result available in `last_string'.
		local
			i: INTEGER
			l_string: STRING_8
		do
			create l_string.make (nb_char)
			from
				i := 1
				read_character
			until
				i > nb_char or not is_readable
			loop
				l_string.extend (last_character)
				read_character
				i := i + 1
			end
			last_string := l_string
		end

	read_line
			-- Read characters until a new line or
			-- end of medium, or one megabyte.
			-- Make result available in `last_string'.
		local
			i: INTEGER
			l_eol: BOOLEAN
			l_cr: BOOLEAN
			c: CHARACTER_8
			l_string: STRING_8
		do
			create l_string.make (64)
			from
				i := 1
				read_character
			until
				i > 1024*1024 or not is_readable or l_eol
			loop
				c := last_character
				if c = '%R' and use_crlf then
					read_character
					c := last_character
					if c = '%N' or not is_readable then
						l_eol := True
					else
						l_string.extend ('%R')
						l_string.extend (c)
					end
				elseif c = '%N' and not use_crlf then
					l_eol := True
				else
					l_string.extend (c)
				end
				read_character
				i := i + 1
			end
			last_string := l_string
		end

	read_to_pointer (p: POINTER; nb_bytes: INTEGER)
		local
			i, j: INTEGER
			mp: MANAGED_POINTER
		do
			i := (buffer_count - buffer_pos).min(nb_bytes)
			p.memory_move (buffer.item + buffer_pos, i)

			if
				i < nb_bytes
			then
				upstream.read_to_pointer (p + i, nb_bytes - i)
				bytes_read := upstream.bytes_read + i
			end
		end

feature -- Access

	last_string: ESTRING_8

	last_character: CHARACTER_8

	last_natural_8: NATURAL_8

	last_natural_16: NATURAL_16

	last_natural: NATURAL_32

	last_natural_64: NATURAL_64

	last_integer_8: INTEGER_8

	last_integer_16: INTEGER_16

	last_integer: INTEGER_32

	last_integer_64: INTEGER_64

	last_real: REAL

	last_real_64: REAL_64

feature -- Element change
	clear
		-- Clears the buffer
		do
			buffer_count := 0
			buffer_pos := 0
		end

feature {NONE} -- Implementation		

	upstream: INPUT_STREAM

	buffer: MANAGED_POINTER

	buffer_count: INTEGER

	retrieve (a_min_bytes: INTEGER)
		require
			a_min_bytes <= buffer.count
		local
			i: INTEGER
		do
			if buffer_count - buffer_pos < a_min_bytes and is_readable then
				i := buffer_count - buffer_pos
				if i > 0 then
					buffer.item.memory_move (buffer.item + buffer_pos, i)
				end
				upstream.read_to_managed_pointer (buffer, i, buffer.count - i)
				buffer_count := upstream.bytes_read + i
				buffer_pos := 0
			end
		end
end
