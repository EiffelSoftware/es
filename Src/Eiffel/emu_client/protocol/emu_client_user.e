indexing
	description: "EMU_Client Root class"
	author: "Ramon Schwammberger, Andrea Zimmermann, Domenic Schroeder"
	date: "$Date$"
	revision: "$Revision$"

class
	EMU_CLIENT_USER


inherit
	SOCKET_RESOURCES

create
	make

feature -- Initialization

	make (argv: ARRAY [STRING]) is --### NOT USED, FEATURES IMPLEMENTED BY EMU_CLIENT ####
			-- Creation procedure of emu user client.
			-- takes four arguments: server_adress server_port user_name password
		do
			if argv.count /= 5 then
				io.error.putstring ("Usage: ")
                io.error.putstring (argv.item (0))
                io.error.putstring (" hostname portnumber user_name password")
            else
            	server_host := argv.item (1)
            	server_port := argv.item(2).to_integer
            	user_name := argv.item (3)
            	password := argv.item (4)
            	create socket.make_client_by_port (server_port, server_host)
            	socket.connect
            	socket.independent_store (create {USER_LOGIN}.make (user_name, password))
            	io.putstring ("connected as user" + user_name +"!%N")
            	io.readline
            	socket.cleanup
			end
		rescue
			io.error.putstring ("Exception in EMU_CLIENT_USER.make")
			if socket.exists then
				socket.cleanup
			end
		end


feature -- Socket

	socket: NETWORK_STREAM_SOCKET
			-- the socket used to connect to the server.


feature {NONE} -- Private Attributes

	server_host: STRING
			-- hostname of the emu server.

	server_port: INTEGER
			-- portnumber of the emu server.

	user_name: STRING
			-- the username of the admin.

	password: STRING
			-- admin password for the emu server.


end -- class EMU_CLIENT_USER
