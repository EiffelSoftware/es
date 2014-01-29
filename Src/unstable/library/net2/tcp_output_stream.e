note
	description: "Summary description for {TCP_OUTPUT_STREAM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TCP_OUTPUT_STREAM

create {NETWORK_CONNECTION}
	make_from_socket_descriptor

feature {NONE} -- Initialization
	make_from_socket_descriptor (a_socket_descriptor: POINTER; a_address_family: NATURAL_16)
		do
			create socket.make_from_fd (a_socket_descriptor, a_address_family)
			create buffer.make (socket.send_buffer_size.as_integer_32)
		end

feature -- Status report
	is_writable: BOOLEAN
		do
			Result := socket.can_send
		end

	use_crlf: BOOLEAN
			-- Use CRLF instead of LF for newline

feature -- Output
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

feature {NONE} -- Implementation		
	socket: PR_TCP_SOCKET

	buffer: MANAGED_POINTER

	buffer_pos: INTEGER

end
