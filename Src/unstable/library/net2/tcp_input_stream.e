note
	description: "A {TCP_INPUT_STREAM} is the ingoing part of a tcp connection."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

class
	TCP_INPUT_STREAM

inherit
	INPUT_STREAM

create
	make_from_socket

create {NETWORK_CONNECTION, BUFFERED_TCP_INPUT_STREAM}
	make_from_socket_descriptor

feature {NETWORK_CONNECTION} -- Initialization
	make_from_socket_descriptor (a_socket_descriptor: POINTER; a_address_family: NATURAL_16)
		do
			create socket.make_from_fd (a_socket_descriptor, a_address_family)
			bytes_read := 0
		ensure
			socket.pr_fd = a_socket_descriptor
			socket.address_family = a_address_family
		end

	make_from_socket (a_socket: PR_TCP_SOCKET)
		do
			socket := a_socket
			bytes_read := 0
		ensure
			socket = a_socket
		end


feature -- Status report
	is_readable: BOOLEAN
		do
			Result := socket.can_receive
		end

feature -- Status setting
	close
		do
			socket.close
		end

feature -- Input

	read_to_pointer (p: POINTER; nb_bytes: INTEGER)
		do
			socket.receive_to_pointer (p, nb_bytes, socket.pr_interval_no_timeout)
			bytes_read := socket.bytes_received
		end

feature {NONE} -- Implementation		

	socket: PR_TCP_SOCKET
end
