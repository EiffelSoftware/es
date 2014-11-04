note
	description: "{SERVER} represents a server sockets."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

class
	SERVER

create
	make

feature {NONE} -- Initialization
	make (a_address: NET_ADDRESS)
		require
			a_address.is_valid
		do
			if a_address.is_ipv4 then
				create socket.open_ipv4
			elseif a_address.is_ipv6 then
				create socket.open_ipv6
			else
				check false end
				create socket.open_ipv6
			end
			socket.bind (a_address.internal)
		end

feature -- Access
	socket: PR_TCP_SOCKET

feature -- Listening
	listen (a_backlog: INTEGER_32)
		require
			not is_closed
			not is_listening
		do
			socket.listen (a_backlog)
		ensure
			is_listening
		end

feature -- Status query
	is_listening: BOOLEAN
		do
			Result := socket.is_listening
		end

	is_closed: BOOLEAN
		do
			Result := socket.is_closed
		end

feature -- Status change
	close
		require
			not is_closed
		do
			socket.close
		end


feature {NONE} -- Implementation

end
