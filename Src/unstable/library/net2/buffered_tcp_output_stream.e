note
	description: "Summary description for {BUFFERED_TCP_OUTPUT_STREAM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BUFFERED_TCP_OUTPUT_STREAM

inherit
	BUFFERED_OUTPUT_STREAM

create
	make_from_socket

feature -- Initialization
	make_from_socket (a_socket: PR_TCP_SOCKET)
		local
			l_upstream: TCP_OUTPUT_STREAM
		do
			create l_upstream.make_from_socket (a_socket)
			make (l_upstream, 1024)
		end

end
