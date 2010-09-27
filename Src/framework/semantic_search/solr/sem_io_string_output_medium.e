note
	description: "Summary description for {SEM_IO_STRING_OUTPUT_MEDIUM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_IO_STRING_OUTPUT_MEDIUM

inherit
	IO_MEDIUM
		redefine
			handle_available,
			is_plain_text,
			read_stream_thread_aware,
			read_line_thread_aware,
			lastchar,
			laststring,
			lastint,
			lastreal,
			lastdouble
		end

create
	make

feature{NONE} -- Initialization

	make (a_size: INTEGER)
			-- Initielize `content' with `a_size' byte of capacity.
		do
			create content.make (a_size)
		end

feature -- Basic operations

	wipe_out
			-- Clear `content'.
		do
			content.wipe_out
		end
		
feature -- Access

	name: detachable STRING
			-- Medium name
		once
			Result := "string output medium"
		end

	retrieved: ANY
			-- Retrieved object structure
			-- To access resulting object under correct type,
			-- use assignment attempt.
			-- Will raise an exception (code `Retrieve_exception')
			-- if content is not a stored Eiffel structure.
		do
		end

feature -- Element change

	basic_store (object: ANY)
		do
			check not_supported: False end
		end

	general_store (object: ANY)
		do
			check not_supported: False end
		end

	independent_store (object: ANY)
		do
			check not_supported: False end
		end

feature -- Status report

	handle: INTEGER
			-- Handle to medium
		do
			check not_supported: False end
		end

	handle_available: BOOLEAN = True
			-- Is the handle available after class has been
			-- created?

	is_plain_text: BOOLEAN = True
			-- Is file reserved for text (character sequences)?

	exists: BOOLEAN
			-- Does medium exist?
		do
			Result := True
		end

	is_open_read: BOOLEAN
			-- Is this medium opened for input
		do
			Result := False
		end

	is_open_write: BOOLEAN
			-- Is this medium opened for output
		do
			Result := True
		end

	is_readable: BOOLEAN
			-- Is medium readable?
		do
			Result := False
		end

	is_executable: BOOLEAN
			-- Is medium executable?
		do
			Result := False
		end

	is_writable: BOOLEAN
			-- Is medium writable?
		do
			Result := True
		end

	readable: BOOLEAN
			-- Is there a current item that may be read?
		do
			Result := False
		end

	extendible: BOOLEAN
			-- May new items be added?
		do
			Result := True
		end

	is_closed: BOOLEAN
			-- Is the I/O medium open
		do
			Result := False
		end

	support_storable: BOOLEAN
			-- Can medium be used to store an Eiffel object?
		do
			Result := False
		end

feature -- Status setting

	close
			-- Close medium.
		do
		end

feature -- Access

	content: STRING
			-- Content string

feature -- Output

	put_new_line, new_line
			-- Write a new line character to medium
		do
			content.append_character ('%N')
		end

	put_string, putstring (s: STRING)
			-- Write `s' to medium.
		do
			content.append (s)
		end

	put_character, putchar (c: CHARACTER)
			-- Write `c' to medium.
		do
			content.append_character (c)
		end

	put_real, putreal (r: REAL)
			-- Write `r' to medium.
		do
			content.append_real (r)
		end

	put_integer, putint, put_integer_32 (i: INTEGER)
			-- Write `i' to medium.
		do
			content.append_integer (i)
		end

	put_integer_8 (i: INTEGER_8)
			-- Write `i' to medium.
		do
			content.append_integer_8 (i)
		end

	put_integer_16 (i: INTEGER_16)
			-- Write `i' to medium.
		do
			content.append_integer_16 (i)
		end

	put_integer_64 (i: INTEGER_64)
			-- Write `i' to medium.
		do
			content.append_integer_64 (i)
		end

	put_natural_8 (i: NATURAL_8)
			-- Write `i' to medium.
		do
			content.append_natural_8 (i)
		end

	put_natural_16 (i: NATURAL_16)
			-- Write `i' to medium.
		do
			content.append_natural_16 (i)
		end

	put_natural, put_natural_32 (i: NATURAL_32)
			-- Write `i' to medium.
		do
			content.append_natural_32 (i)
		end

	put_natural_64 (i: NATURAL_64)
			-- Write `i' to medium.
		do
			content.append_natural_64 (i)
		end

	put_boolean, putbool (b: BOOLEAN)
			-- Write `b' to medium.
		do
			content.append_boolean (b)
		end

	put_double, putdouble (d: DOUBLE)
			-- Write `d' to medium.
		do
			content.append_double (d)
		end

	put_managed_pointer (p: MANAGED_POINTER; start_pos, nb_bytes: INTEGER)
			-- Put data of length `nb_bytes' pointed by `start_pos' index in `p' at
			-- current position.
		do
			check not_supported: False end
		end


feature -- Input

	read_real, readreal
			-- Read a new real.
			-- Make result available in `last_real'.
		do
			check not_supported: False end
		end

	read_double, readdouble
			-- Read a new double.
			-- Make result available in `last_double'.
		do
			check not_supported: False end
		end

	read_character, readchar
			-- Read a new character.
			-- Make result available in `last_character'.
		do
			check not_supported: False end
		end

	read_integer, readint, read_integer_32
			-- Read a new 32-bit integer.
			-- Make result available in `last_integer'.
		do
			check not_supported: False end
		end

	read_integer_8
			-- Read a new 8-bit integer.
			-- Make result available in `last_integer_8'.
		do
			check not_supported: False end
		end

	read_integer_16
			-- Read a new 16-bit integer.
			-- Make result available in `last_integer_16'.
		do
			check not_supported: False end
		end

	read_integer_64
			-- Read a new 64-bit integer.
			-- Make result available in `last_integer_64'.
		do
			check not_supported: False end
		end

	read_natural_8
			-- Read a new 8-bit natural.
			-- Make result available in `last_natural_8'.
		do
			check not_supported: False end
		end

	read_natural_16
			-- Read a new 16-bit natural.
			-- Make result available in `last_natural_16'.
		do
			check not_supported: False end
		end

	read_natural, read_natural_32
			-- Read a new 32-bit natural.
			-- Make result available in `last_natural'.
		do
			check not_supported: False end
		end

	read_natural_64
			-- Read a new 64-bit natural.
			-- Make result available in `last_natural_64'.
		do
			check not_supported: False end
		end

	read_stream, readstream (nb_char: INTEGER)
			-- Read a string of at most `nb_char' bound characters
			-- or until end of medium is encountered.
			-- Make result available in `last_string'.
		do
			check not_supported: False end
		end

	read_stream_thread_aware (nb_char: INTEGER)
			-- Read a string of at most `nb_char' bound characters
			-- or until end of medium is encountered.
			-- Make result available in `last_string'.
			-- Functionally identical to `read_stream' but
			-- won't prevent garbage collection from occurring
			-- while blocked waiting for data, though data must
			-- be copied an extra time.			
		do
			check not_supported: False end
		end

	read_line, readline
			-- Read characters until a new line or
			-- end of medium.
			-- Make result available in `last_string'.
		do
			check not_supported: False end
		end

	read_line_thread_aware
			-- Read characters until a new line or
			-- end of medium.
			-- Make result available in `last_string'.
			-- Functionally identical to `read_line' but
			-- won't prevent garbage collection from occurring
			-- while blocked waiting for data, though data must
			-- be copied an extra time.			
		do
			check not_supported: False end
		end

	read_to_managed_pointer (p: MANAGED_POINTER; start_pos, nb_bytes: INTEGER)
			-- Read at most `nb_bytes' bound bytes and make result
			-- available in `p' at position `start_pos'.
		do
			check not_supported: False end
		end

feature -- Obsolete

	lastchar: CHARACTER
			-- Last character read by `read_character'
		do
			check not_supported: False end
		end

	laststring: like last_string
			-- Last string read
		do
			check not_supported: False end
		end

	lastint: INTEGER
			-- Last integer read by `read_integer'
		do
			check not_supported: False end
		end

	lastreal: REAL
			-- Last real read by `read_real'
		do
			check not_supported: False end
		end

	lastdouble: DOUBLE
			-- Last double read by `read_double'
		do
			check not_supported: False end
		end

end
