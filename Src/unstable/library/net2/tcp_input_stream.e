note
	description: "Summary description for {TCP_INPUT_STREAM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TCP_INPUT_STREAM

create {NETWORK_CONNECTION}
	make_from_socket_descriptor

feature {NONE} -- Initialization
	make_from_socket_descriptor (a_socket_descriptor: POINTER; a_address_family: NATURAL_16)
		do
			create socket.make_from_fd (a_socket_descriptor, a_address_family)
			create buffer.make (socket.recv_buffer_size.as_integer_32)
			create last_string.make_empty
		end
feature -- Status report
	is_readable: BOOLEAN
		do
			Result := socket.can_receive
		end

	use_crlf: BOOLEAN
			-- Use CRLF instead of LF for newline

	buffer_pos: INTEGER

	buffer_count: INTEGER

feature -- Status setting

	rewind (i: INTEGER)
		require
			i > 0
			i <= buffer_pos
		do
			buffer_pos := buffer_pos - i
		ensure
			buffer_pos = old buffer_pos - i
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

	read_to_managed_pointer (p: MANAGED_POINTER; start_pos, nb_bytes: INTEGER)
			-- Read at most `nb_bytes' bound bytes and make result
			-- available in `p' at position `start_pos'.
		local
			i: INTEGER
		do
			from
				i := 0
			until
				buffer_count = buffer_pos or i = nb_bytes
			loop
				p.put_natural_8 (buffer.read_natural_8(buffer_pos), i + start_pos)
				buffer_pos := buffer_pos + 1
				i := i + 1
			end

			if
				i < nb_bytes
			then
				socket.receive_to_pointer (p.item.plus (start_pos + i), nb_bytes - i, socket.pr_interval_no_wait)
				bytes_read := socket.bytes_received
			end
		end

	bytes_read: INTEGER

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


feature {NONE} -- Implementation		

	socket: PR_TCP_SOCKET

	buffer: MANAGED_POINTER

	retrieve (a_min_bytes: INTEGER)
		local
			i: INTEGER
		do
			if buffer_count - buffer_pos < a_min_bytes and is_readable then
				from
					i := 0
				until
					buffer_count = buffer_pos
				loop
					buffer.put_natural_8 (buffer.read_natural_8 (buffer_pos), i)
					buffer_pos := buffer_pos + 1
					i := i + 1
				end
				socket.receive_to_pointer (buffer.item.plus (i), buffer.count - i, socket.pr_interval_no_timeout)
				buffer_count := socket.bytes_received + i
				buffer_pos := 0
			end
		end
end
