note
	description: "{BUFFERED_TCP_INPUT_STREAM} is a buffered input stream that wraps a tcp input stream for convenience."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

class
	BUFFERED_TCP_INPUT_STREAM

inherit
	BUFFERED_INPUT_STREAM

create
	make_from_socket

create {NETWORK_CONNECTION}
	make_from_socket_descriptor

feature {NETWORK_CONNECTION} -- Initialization
	make_from_socket_descriptor (a_socket_descriptor: POINTER; a_address_family: NATURAL_16)
		local
			l_upstream: TCP_INPUT_STREAM
		do
			create l_upstream.make_from_socket_descriptor (a_socket_descriptor, a_address_family)
			make (l_upstream, 1024)
		end

feature -- Initialization
	make_from_socket (a_socket: PR_TCP_SOCKET)
		local
			l_upstream: TCP_INPUT_STREAM
		do
			create l_upstream.make_from_socket (a_socket)
			make (l_upstream, 1024)
		end
end
