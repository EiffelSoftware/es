note
	description: "{TCP_OUTPUT_STREAM} is the output portion of a tcp connection."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

class
	TCP_OUTPUT_STREAM

inherit
	OUTPUT_STREAM

create
	make_from_socket

feature {NETWORK_CONNECTION} -- Initialization
	make_from_socket (a_socket: PR_TCP_SOCKET)
		do
			socket := a_socket
		ensure
			socket = a_socket
		end

feature -- Status report
	is_writable: BOOLEAN
		do
			Result := socket.can_send
		end

feature -- Status setting
	close
		do
			socket.close
		end

feature -- Output
	put_pointer (p: POINTER; nb_bytes: INTEGER)
			-- Put data of length `nb_bytes' pointed by `start_pos' index in `p' at
			-- current position.
		local
			i: INTEGER
		do
			from
				socket.send_from_pointer (p.item, nb_bytes, socket.pr_interval_no_timeout)
				i := socket.bytes_sent
			until
				i = nb_bytes or not is_writable
			loop
				socket.send_from_pointer (p.item + i, nb_bytes - i, socket.pr_interval_no_timeout)
				i := i + socket.bytes_sent
			end
		end

feature {NONE} -- Implementation		
	socket: PR_TCP_SOCKET
end
