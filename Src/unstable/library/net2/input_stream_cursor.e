note
	description: "{INPUT_STREAM_CURSOR} is an {ITERATION_CURSOR} for input streams."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

class
	INPUT_STREAM_CURSOR

inherit
	ITERATION_CURSOR[NATURAL_8]

create
	make

feature {NONE} -- Initialization
	make (a_stream: INPUT_STREAM)
		do
			stream := a_stream
			forth
		ensure
			stream = a_stream
		end

feature -- Access
	item: NATURAL_8

	stream: INPUT_STREAM
			-- The stream to read from

feature -- Status report
	after: BOOLEAN

feature -- Status setting
	forth
		do
			after := stream.is_closed
			if not after then
				stream.read_natural_8
				item := stream.last_natural_8
				after := stream.bytes_read = 0
			end
		end
end

