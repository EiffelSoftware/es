note
	description: "Summary description for {NETWORK_CONNECTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NETWORK_CONNECTION

create {SERVER}
	make_from_socket_pointer

create
	connect,
	connect_with_timeout

feature {NONE} -- Initialization
	make_from_socket_pointer (a_ptr: POINTER; a_address_family: NATURAL_16)
		do
			create socket.make_from_fd (a_ptr, a_address_family)
			create input.make_from_socket_descriptor (a_ptr, a_address_family)
			create output.make_from_socket_descriptor (a_ptr, a_address_family)
		end

	connect (a_host: ESTRING_8; a_port: NATURAL_16)
		-- Try to establish a connection, closing it on a timeout or if the host address is invalid.
		do
			connect_with_timeout (a_host, a_port, 0)
		end

	connect_with_timeout (a_host: ESTRING_8; a_port: NATURAL_16; a_timeout: NATURAL_32)
		-- Try to establish a connection, closing it on a timeout or if the host address is invalid.
		require
			a_timeout > 1000 and a_timeout < 100000 or a_timeout = 0
		local
			l_addr: PR_NET_ADDRESS
			l_hostent: PR_HOST_ENTRY
		do
			create l_hostent.lookup (a_host, a_port)
			if not l_hostent.addresses.is_empty then
				l_addr := l_hostent.addresses.first
			end
			if l_addr.family = l_addr.ipv4 then
				create socket.open_ipv4
			elseif l_addr.family = l_addr.ipv6 then
				create socket.open_ipv6
			else
				check false end
				create socket.make_from_fd (create {POINTER}, l_addr.ipv4)
			end
			socket.connect (l_addr, a_timeout)
			create input.make_from_socket_descriptor (socket.pr_fd, socket.address_family)
			create output.make_from_socket_descriptor (socket.pr_fd, socket.address_family)
		end

feature -- Access
	peer_address: detachable NET_ADDRESS

	socket: PR_TCP_SOCKET

--	medium: NETWORK_MEDIUM

	input: separate TCP_INPUT_STREAM

	output: separate TCP_OUTPUT_STREAM

feature -- Status report
	is_closed: BOOLEAN
			-- Is the network connection open?
		do
			Result := socket.is_closed
		end

feature -- Status setting
	close
			-- Close medium.
		do
			close_wrapper (input, output)
		end

feature {NONE} -- Implementation		

	close_wrapper (a_input: separate TCP_INPUT_STREAM; a_output: separate TCP_OUTPUT_STREAM)
		do
			a_output.flush
			-- Synchronize on both input and output
			if a_output.default_pointer = a_input.default_pointer then
				socket.close
			end
		end
end
