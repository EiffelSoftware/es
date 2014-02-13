note
	description: "Summary description for {SERVER}."
	author: ""
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

	accept
		require
			not is_closed
			is_listening
		do
			create last_connection.make_endpoint (Current, True)
		ensure
			attached last_connection
			last_connection /= old last_connection
		end

	last_connection: detachable separate NETWORK_CONNECTION

	connected (a_connection: separate NETWORK_CONNECTION)
		do
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

	was_timeout: BOOLEAN
		do
			Result := socket.was_timeout
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
