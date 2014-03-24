note
	description: "{INPUT_STREAM_READER_8} reads strings out of an input stream."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

class
	INPUT_STREAM_READER_8

inherit
	ITERATION_CURSOR[ESTRING_8]
		rename
			forth as read
		end

create
	make,
	make_line_by_line

feature {NONE} -- Initialization
	make (a_stream: INPUT_STREAM; a_delimiter: CHARACTER_8; a_drop_cr: BOOLEAN)
			-- Creates a new reader from the given stream.
		do
			stream := a_stream
			drop_cr := a_drop_cr
			create delimiters.make (4)
			delimiters.extend (a_delimiter)
			item := "error"
		ensure
			stream = a_stream
			delimiters.has (a_delimiter)
			delimiters.count = 1
		end


	make_line_by_line (a_stream: INPUT_STREAM)
			-- Shorthand for creating a line reader.
		do
			make (a_stream, '%N', True)
		ensure
			stream = a_stream
			delimiters.has ('%N')
			drop_cr
			delimiters.count = 1
		end
feature -- Access
	item: ESTRING_8
			-- The item last read

feature -- Status report
	after: BOOLEAN
			-- Whether there are still items available

	buffer_size: INTEGER
			-- The initial size of the buffer allocated for each element. The buffer grows as needed.
		attribute
			Result := 64
		end

	delimiters: ARRAYED_SET[CHARACTER_8]
			-- The delimiting symbols.

	last_delimiter: CHARACTER_8
			-- The character that delimited the last item

	drop_cr: BOOLEAN
			-- Remove a CR symbol preceding LF if LF is in `delimiters'

	is_started: BOOLEAN

feature -- Status setting
	read
			-- Read the next item
		local
			l_buf: STRING_8
			c: CHARACTER_8
		do
			after := stream.is_closed
			from
				create l_buf.make (buffer_size)
				if not stream.is_closed then
					stream.read_character_8
					after := stream.bytes_read = 0
					c := stream.last_character_8
				end
			until
				stream.is_closed or delimiters.has(c)
			loop
				l_buf.extend (c)
				stream.read_character_8
				c := stream.last_character_8
			end
			if not after then
				last_delimiter := c
				if last_delimiter = '%N' and drop_cr and l_buf.count > 0 and then l_buf[l_buf.count] = '%R' then
					l_buf.remove_tail (1)
				end
			end
			item := l_buf
		end

	stream: INPUT_STREAM

feature {NONE} -- Implementation


end
