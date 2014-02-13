note
	description: "{BUFFERED_OUTPUT_STREAM} adds a buffer and useful features to an output stream."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

class
	BUFFERED_OUTPUT_STREAM

inherit
	OUTPUT_STREAM
		redefine
			put_managed_pointer
		end

create
	make

feature {NONE} -- Initialization
	make (a_output_stream: OUTPUT_STREAM; a_buffer_size: INTEGER_32)
		require
			a_buffer_size >= 8
		do
			upstream := a_output_stream
			create buffer.make (a_buffer_size)
			buffer_pos := 0
		end

feature -- Access
	upstream: OUTPUT_STREAM

feature -- Status report
	use_crlf: BOOLEAN assign set_crlf
			-- Use CRLF instead of LF for newline

	is_writable: BOOLEAN
		do
			Result := upstream.is_writable
		end

feature -- Status setting
	set_crlf (a_value: BOOLEAN)
		do
			use_crlf := a_value
		end

	close
		do
			flush
			upstream.close
		end

feature -- Output
	flush
			-- Sends the content of the buffer `upstream'
		local
			l_sent_bytes: INTEGER
		do
			if buffer_pos > 0 then
				upstream.put_pointer (buffer.item, buffer_pos - l_sent_bytes)
				buffer_pos := 0
			end
		end

	clear
		-- Clears the buffer without flushing
		do
			buffer_pos := 0
		end

	put_new_line
			-- Write a new line character to medium and flushes buffer
		do
			if use_crlf then
				if buffer_pos + 2 > buffer.count then
					flush
				end
				buffer.put_natural_8 (13, buffer_pos)
				buffer_pos := buffer_pos + 1
				buffer.put_natural_8 (10, buffer_pos)
				buffer_pos := buffer_pos + 1
			else
				if buffer_pos + 1 > buffer.count then
					flush
				end
				buffer.put_natural_8 (10, buffer_pos)
				buffer_pos := buffer_pos + 1
			end
			flush
		end

	put_string (s: STRING_8)
			-- Write `s' to medium.
		local
			l_index: INTEGER
		do
			-- TODO: Use fast memory copying
			from
				l_index := 1
			until
				l_index > s.count
			loop
				buffer.put_character (s[l_index], buffer_pos)
				buffer_pos := buffer_pos + 1
				if buffer.count = buffer_pos then
					flush
				end
				l_index := l_index + 1
			end
		end

	put_estring (s: ESTRING_8)
			-- Write `s' to medium.
		local
			l_index: INTEGER
		do
			-- TODO: Use fast memory copying
			from
				l_index := 1
			until
				l_index > s.count
			loop
				buffer.put_character (s[l_index], buffer_pos)
				buffer_pos := buffer_pos + 1
				if buffer.count = buffer_pos then
					flush
				end
				l_index := l_index + 1
			end
		end


	put_character (c: CHARACTER_8)
			-- Write `c' to medium.
		do
			if buffer_pos + buffer.character_8_bytes > buffer.count then
				flush
			end
			buffer.put_character (c, buffer_pos)
			buffer_pos := buffer_pos + buffer.character_8_bytes
			if buffer.count = buffer_pos then
				flush
			end
		end

	put_real (r: REAL)
			-- Write `r' to medium.
		do
			if buffer_pos + buffer.real_bytes > buffer.count then
				flush
			end
			buffer.put_real_32_be (r, buffer_pos)
			buffer_pos := buffer_pos + buffer.real_bytes
			if buffer.count = buffer_pos then
				flush
			end
		end

	put_integer, put_integer_32 (i: INTEGER)
			-- Write `i' to medium.
		do
			if buffer_pos + buffer.integer_32_bytes > buffer.count then
				flush
			end
			buffer.put_integer_32_be (i, buffer_pos)
			buffer_pos := buffer_pos + buffer.integer_32_bytes
			if buffer.count = buffer_pos then
				flush
			end
		end

	put_integer_8 (i: INTEGER_8)
			-- Write `i' to medium.
		do
			if buffer_pos + buffer.integer_8_bytes > buffer.count then
				flush
			end
			buffer.put_integer_8_be (i, buffer_pos)
			buffer_pos := buffer_pos + buffer.integer_8_bytes
			if buffer.count = buffer_pos then
				flush
			end
		end
	put_integer_16 (i: INTEGER_16)
			-- Write `i' to medium.
		do
			if buffer_pos + buffer.integer_16_bytes > buffer.count then
				flush
			end
			buffer.put_integer_16_be (i, buffer_pos)
			buffer_pos := buffer_pos + buffer.integer_16_bytes
			if buffer.count = buffer_pos then
				flush
			end
		end

	put_integer_64 (i: INTEGER_64)
			-- Write `i' to medium.
		do
			if buffer_pos + buffer.integer_64_bytes > buffer.count then
				flush
			end
			buffer.put_integer_64_be (i, buffer_pos)
			buffer_pos := buffer_pos + buffer.integer_64_bytes
			if buffer.count = buffer_pos then
				flush
			end
		end

	put_natural_8 (i: NATURAL_8)
			-- Write `i' to medium.
		do
			if buffer_pos + buffer.natural_8_bytes > buffer.count then
				flush
			end
			buffer.put_natural_8_be (i, buffer_pos)
			buffer_pos := buffer_pos + buffer.natural_8_bytes
			if buffer.count = buffer_pos then
				flush
			end
		end

	put_natural_16 (i: NATURAL_16)
			-- Write `i' to medium.
		do
			if buffer_pos + buffer.natural_16_bytes > buffer.count then
				flush
			end
			buffer.put_natural_16_be (i, buffer_pos)
			buffer_pos := buffer_pos + buffer.natural_16_bytes
			if buffer.count = buffer_pos then
				flush
			end
		end


	put_natural, put_natural_32 (i: NATURAL_32)
			-- Write `i' to medium.
		do
			if buffer_pos + buffer.natural_32_bytes > buffer.count then
				flush
			end
			buffer.put_natural_32_be (i, buffer_pos)
			buffer_pos := buffer_pos + buffer.natural_32_bytes
			if buffer.count = buffer_pos then
				flush
			end
		end


	put_natural_64 (i: NATURAL_64)
			-- Write `i' to medium.
		do
			if buffer_pos + buffer.natural_64_bytes > buffer.count then
				flush
			end
			buffer.put_natural_64_be (i, buffer_pos)
			buffer_pos := buffer_pos + buffer.natural_64_bytes
			if buffer.count = buffer_pos then
				flush
			end
		end

	put_boolean (b: BOOLEAN)
			-- Write `b' to medium.
		do
			if buffer_pos + buffer.boolean_bytes > buffer.count then
				flush
			end
			buffer.put_boolean (b, buffer_pos)
			buffer_pos := buffer_pos + buffer.boolean_bytes
			if buffer.count = buffer_pos then
				flush
			end
		end

	put_real_64 (d: REAL_64)
			-- Write `d' to medium.
		do
			if buffer_pos + buffer.double_bytes > buffer.count then
				flush
			end
			buffer.put_real_64_be (d, buffer_pos)
			buffer_pos := buffer_pos + buffer.double_bytes
			if buffer.count = buffer_pos then
				flush
			end
		end

	put_pointer (p: POINTER; nb_bytes: INTEGER)
		do
			flush
			upstream.put_pointer (p, nb_bytes)
		end

	put_managed_pointer (p: MANAGED_POINTER; start_pos, nb_bytes: INTEGER)
		do
			flush
			upstream.put_managed_pointer (p, start_pos, nb_bytes)
		end

feature {NONE} -- Implementation		
	buffer: MANAGED_POINTER

	buffer_pos: INTEGER
end
