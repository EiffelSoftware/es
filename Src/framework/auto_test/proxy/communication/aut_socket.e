indexing
	description: "Summary description for {AUT_SOCKET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_SOCKET

inherit
	NETWORK_STREAM_SOCKET

create
	make_with_url_and_port

feature

	make_with_url_and_port (a_port: INTEGER; a_url: STRING) is
			--
		require
			valid_port: a_port >= 0
		local
			h_address: HOST_ADDRESS
		do
			make;
			create address.make_from_ip_and_port (a_url, a_port)
			bind
		end

end
