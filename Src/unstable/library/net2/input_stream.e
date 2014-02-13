note
	description: "{INPUT_STREAM} is a generic incoming byte stream."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	INPUT_STREAM

inherit
	STREAM_STATE

feature -- Status report
	is_readable: BOOLEAN
			-- Is the stream readable, i. e. not closed?
		deferred
		end

	is_open: BOOLEAN
		do
			Result := is_readable
		ensure then
			Result implies is_readable
		end

feature -- Input
	read_to_pointer (p: POINTER; nb_bytes: INTEGER)
			-- Read at most `nb_bytes' bytes and make result
			-- available in `p'.
			-- The number of bytes read is available from `bytes_read'
		deferred
		end

	read_to_managed_pointer (p: MANAGED_POINTER; start_pos, nb_bytes: INTEGER)
			-- Read at most `nb_bytes' bytes and make result
			-- available in `p' at position `start_pos'.
			-- The number of bytes read is available from `bytes_read'
		do
			read_to_pointer (p.item.plus (start_pos), nb_bytes)
		end

	bytes_read: INTEGER
end
