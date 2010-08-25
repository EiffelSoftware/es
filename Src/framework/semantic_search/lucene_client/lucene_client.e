note
	description: "Summary description for {LUCENE_CLIENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LUCENE_CLIENT
	create
		make


feature -- Access
	make
			--
		local
			l_listener:NETWORK_STREAM_SOCKET
			l_address_factory:INET_ADDRESS_FACTORY
			msg : MESSAGE

		do
			create l_address_factory

			create l_listener.make_client_by_address_and_port (l_address_factory.create_localhost,10000)
			l_listener.connect
			if (l_listener.is_connected) then
				create msg.make_with_header ("numberOfLines=4;requestId=10;")
				msg.add_line_body ("body=line2;")
				msg.add_line_body ("body=line3;")
				msg.add_line_body ("body=line4;")
				msg.add_line_body ("body=line5;")

				msg.send_message (l_listener)


			else
				io.putstring ("Could not connect")

			end

			l_listener.cleanup
			l_listener.close



		end




feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
