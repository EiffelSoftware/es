note
	description: "Summary description for {NETWORK_MEDIUM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NETWORK_MEDIUM

inherit
	IO_MEDIUM
		rename
			extendible as is_writable,
			readable as is_readable
		export {NONE}
			handle,
			handle_available,
			read_stream_thread_aware,
			read_line_thread_aware,
			is_plain_text,
			basic_store,
			general_store,
			independent_store,
			is_executable,
			is_open_read,
			is_open_write,
			retrieved,
			support_storable
		end

create
	make_from_socket

feature {NONE} -- Initialization
	make_from_socket (a_socket: PR_TCP_SOCKET)
		do
			socket := a_socket
			create buffer.make (a_socket.send_buffer_size.as_integer_32)
			create read_buffer.make (a_socket.recv_buffer_size.as_integer_32)
			create last_string.make_empty
		end

feature -- Status report

feature -- Status change

feature -- Access

	name: detachable STRING
			-- Medium name
		do
			Result := socket.peer_address.out
		end

feature -- Element change

feature -- Status report

	is_open: BOOLEAN
		do
			Result := not is_closed
		end

	is_readable: BOOLEAN
		do
			Result := socket.can_receive
		end

	is_writable: BOOLEAN
		do
			Result := socket.can_send
		end

	is_closed: BOOLEAN
			-- Is the I/O medium open
		do
			Result := socket.is_closed
		end

	use_crlf: BOOLEAN
			-- Use CRLF instead of LF for newline

	exists: BOOLEAN
			-- Does medium exist?
		do
			Result := not is_closed
		end

feature -- Status setting

	close
			-- Close medium.
		do
			flush
			socket.close
		end

	flush
		do
			from
			until
				buffer_pos = 0 or not is_writable
			loop
				socket.send_from_managed_pointer (buffer, buffer_pos, socket.pr_interval_no_wait)
				buffer_pos := buffer_pos - socket.bytes_sent
			end
		end

feature -- Output

	put_new_line, new_line
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

	put_string, putstring (s: STRING_8)
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


	put_character, putchar (c: CHARACTER_8)
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

	put_real, putreal (r: REAL)
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

	put_integer, putint, put_integer_32 (i: INTEGER)
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

	put_boolean, putbool (b: BOOLEAN)
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

	put_double, putdouble (d: DOUBLE)
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

	put_managed_pointer (p: MANAGED_POINTER; start_pos, nb_bytes: INTEGER)
			-- Put data of length `nb_bytes' pointed by `start_pos' index in `p' at
			-- current position.
		local
			i: INTEGER
		do
			flush
			from
				socket.send_from_pointer (p.item.plus (start_pos), nb_bytes, socket.pr_interval_no_wait)
				i := socket.bytes_sent
			until
				i = nb_bytes or not is_writable
			loop
				socket.send_from_pointer (p.item.plus (start_pos + i), nb_bytes - i, socket.pr_interval_no_wait)
				i := i + socket.bytes_sent
			end
		end

feature -- Input

	read_real, readreal
			-- Read a new real.
			-- Make result available in `last_real'.
		do
			retrieve (buffer.real_bytes)
			if read_buffer_count - read_buffer_pos >= buffer.real_bytes then
				last_real := read_buffer.read_real_32_be (read_buffer_pos)
				read_buffer_pos := read_buffer_pos + buffer.real_bytes
			end
		end

	read_double, readdouble
			-- Read a new double.
			-- Make result available in `last_double'.
		do
			retrieve (buffer.double_bytes)
			if read_buffer_count - read_buffer_pos >= buffer.double_bytes then
				last_double := read_buffer.read_real_64_be (read_buffer_pos)
				read_buffer_pos := read_buffer_pos + buffer.double_bytes
			end
		end

	read_character, readchar
			-- Read a new character.
			-- Make result available in `last_character'.
		do
			retrieve (buffer.character_8_bytes)
			if read_buffer_count - read_buffer_pos >= buffer.character_8_bytes then
				last_character := read_buffer.read_character (read_buffer_pos)
				read_buffer_pos := read_buffer_pos + buffer.character_8_bytes
			end
		end

	read_integer, readint, read_integer_32
			-- Read a new 32-bit integer.
			-- Make result available in `last_integer'.
		do
			retrieve (buffer.integer_32_bytes)
			if read_buffer_count - read_buffer_pos >= buffer.integer_32_bytes then
				last_integer := read_buffer.read_integer_32_be (read_buffer_pos)
				read_buffer_pos := read_buffer_pos + buffer.integer_32_bytes
			end
		end

	read_integer_8
			-- Read a new 8-bit integer.
			-- Make result available in `last_integer_8'.
		do
			retrieve (buffer.integer_8_bytes)
			if read_buffer_count - read_buffer_pos >= buffer.integer_8_bytes then
				last_integer_8 := read_buffer.read_integer_8_be (read_buffer_pos)
				read_buffer_pos := read_buffer_pos + buffer.integer_8_bytes
			end
		end

	read_integer_16
			-- Read a new 16-bit integer.
			-- Make result available in `last_integer_16'.
		do
			retrieve (buffer.integer_16_bytes)
			if read_buffer_count - read_buffer_pos >= buffer.integer_16_bytes then
				last_integer_16 := read_buffer.read_integer_16_be (read_buffer_pos)
				read_buffer_pos := read_buffer_pos + buffer.integer_16_bytes
			end
		end


	read_integer_64
			-- Read a new 64-bit integer.
			-- Make result available in `last_integer_64'.
		do
			retrieve (buffer.integer_64_bytes)
			if read_buffer_count - read_buffer_pos >= buffer.integer_64_bytes then
				last_integer_64 := read_buffer.read_integer_64_be (read_buffer_pos)
				read_buffer_pos := read_buffer_pos + buffer.integer_64_bytes
			end
		end


	read_natural_8
			-- Read a new 8-bit natural.
			-- Make result available in `last_natural_8'.
		do
			retrieve (buffer.natural_8_bytes)
			if read_buffer_count - read_buffer_pos >= buffer.natural_8_bytes then
				last_natural_8 := read_buffer.read_natural_8_be (read_buffer_pos)
				read_buffer_pos := read_buffer_pos + buffer.natural_8_bytes
			end
		end

	read_natural_16
			-- Read a new 16-bit natural.
			-- Make result available in `last_natural_16'.
		do
			retrieve (buffer.natural_16_bytes)
			if read_buffer_count - read_buffer_pos >= buffer.natural_16_bytes then
				last_natural_16 := read_buffer.read_natural_16_be (read_buffer_pos)
				read_buffer_pos := read_buffer_pos + buffer.natural_16_bytes
			end
		end

	read_natural, read_natural_32
			-- Read a new 32-bit natural.
			-- Make result available in `last_natural'.
		do
			retrieve (buffer.natural_32_bytes)
			if read_buffer_count - read_buffer_pos >= buffer.natural_32_bytes then
				last_natural := read_buffer.read_natural_32_be (read_buffer_pos)
				read_buffer_pos := read_buffer_pos + buffer.natural_32_bytes
			end
		end

	read_natural_64
			-- Read a new 64-bit natural.
			-- Make result available in `last_natural_64'.
		do
			retrieve (buffer.natural_64_bytes)
			if read_buffer_count - read_buffer_pos >= buffer.natural_64_bytes then
				last_natural_64 := read_buffer.read_natural_64_be (read_buffer_pos)
				read_buffer_pos := read_buffer_pos + buffer.natural_64_bytes
			end
		end

	read_stream, readstream (nb_char: INTEGER)
			-- Read a string of at most `nb_char' bound characters
			-- or until end of medium is encountered.
			-- Make result available in `last_string'.
		local
			i: INTEGER
		do
			create last_string.make (nb_char)
			from
				i := 1
				read_character
			until
				i > nb_char or is_closed
			loop
				last_string.extend (last_character)
				read_character
				i := i + 1
			end
		end

	read_line, readline
			-- Read characters until a new line or
			-- end of medium, or one megabyte.
			-- Make result available in `last_string'.
		local
			i: INTEGER
			l_eol: BOOLEAN
			l_cr: BOOLEAN
			c: CHARACTER_8
		do
			create last_string.make (64)
			from
				i := 1
				read_character
			until
				i > 1024*1024 or is_closed or l_eol
			loop
				c := last_character
				if c = '%R' and use_crlf then
					read_character
					c := last_character
					if c = '%N' or is_closed then
						l_eol := True
					else
						last_string.extend ('%R')
						last_string.extend (c)
					end
				elseif c = '%N' and not use_crlf then
					l_eol := True
				else
					last_string.extend (c)
				end
				read_character
				i := i + 1
			end
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
				read_buffer_count = read_buffer_pos or i = nb_bytes
			loop
				p.put_natural_8 (read_buffer.read_natural_8(read_buffer_pos), i + start_pos)
				read_buffer_pos := read_buffer_pos + 1
				i := i + 1
			end

			if
				i < nb_bytes
			then
				socket.receive_to_pointer (p.item.plus (start_pos + i), nb_bytes - i, socket.pr_interval_no_wait)
				bytes_read := socket.bytes_received
			end
		end

	rewind_read (a_count: like read_buffer_pos)
		require
			a_count > 0
			read_buffer_pos > a_count
		do
			read_buffer_pos := read_buffer_pos - a_count
		end

	read_buffer_pos: INTEGER

	read_buffer_count: INTEGER
feature -- Element change

feature {NONE} -- Implementation		
	socket: PR_TCP_SOCKET

	buffer: MANAGED_POINTER

	buffer_pos: INTEGER

	read_buffer: MANAGED_POINTER



feature {NONE} -- Useless inherited garbage
	handle: INTEGER
			-- Handle to medium
		do
		end

	handle_available: BOOLEAN
			-- Is the handle available after class has been
			-- created?
		do
			Result := False
		end

	retrieve (a_min_bytes: INTEGER)
		local
			i: INTEGER
		do
			if read_buffer_count < a_min_bytes and is_readable then
				from
					i := 0
				until
					read_buffer_count = read_buffer_pos
				loop
					read_buffer.put_natural_8 (read_buffer.read_natural_8 (read_buffer_pos), i)
					read_buffer_pos := read_buffer_pos + 1
					i := i + 1
				end
				socket.receive_to_pointer (read_buffer.item.plus (read_buffer_pos + i), read_buffer.count - i, socket.pr_interval_no_timeout)
				read_buffer_count := socket.bytes_received + i
				read_buffer_pos := 0
			end
		end

	is_open_read: BOOLEAN
			-- Is this medium opened for input
		do
			Result := socket.can_receive
		end

	is_open_write: BOOLEAN
			-- Is this medium opened for output
		do
			Result := socket.can_send
		end

	is_executable: BOOLEAN
			-- Is medium executable?
		do
		end

	retrieved: detachable ANY
			-- Retrieved object structure
			-- To access resulting object under correct type,
			-- use assignment attempt.
			-- Will raise an exception (code `Retrieve_exception')
			-- if content is not a stored Eiffel structure.
		do
		end

	support_storable: BOOLEAN
			-- Can medium be used to store an Eiffel object?
		do
		end

	basic_store (object: ANY)
		do
		end

	general_store (object: ANY)
		do
		end

	independent_store (object: ANY)
		do
		end
end
