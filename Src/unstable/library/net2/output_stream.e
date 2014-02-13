note
	description: "{OUTPUT_STREAM} is a stream of outgoing bytes."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	OUTPUT_STREAM

inherit
	STREAM_STATE

feature -- Status report
	is_writable: BOOLEAN
			-- Is this stream writable, i. e. not closed?
		deferred
		end

	is_open: BOOLEAN
		do
			Result := is_writable
		ensure then
			Result implies is_writable
		end

feature -- Output
	put_managed_pointer (p: MANAGED_POINTER; start_pos, nb_bytes: INTEGER)
			-- Put data of length `nb_bytes' pointed by `start_pos' index in `p' at
			-- current position.
		do
			put_pointer (p.item + start_pos, nb_bytes)
		end

	put_pointer (p: POINTER; nb_bytes: INTEGER)
			-- Put data of length `nb_bytes' pointed by `start_pos' index in `p' at
			-- current position.
		deferred
		end
end
