note
	description: "Summary description for {MESSAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MESSAGE
	create
		make_with_header

Feature--Create
make_with_header(a_header:STRING) is
		--
	do
		create body.make
		header := a_header

	end


 add_line_body (line :STRING) is
 		--
 	do
 		body.put_left (line)

 	end

send_message ( socket:NETWORK_STREAM_SOCKET)is
	require
		socket /= void
		socket.is_connected
	do

		socket.put_string (header)
		socket.new_line
		from
			body.start
		until
			body.after

		loop
			socket.put_string (body.item_for_iteration)
			socket.new_line
			body.forth
		end
	end




feature {none}-- Attributes

 header :STRING
	-- Header of the message

 body : LINKED_LIST [STRING]
 	-- Body of the message

end
