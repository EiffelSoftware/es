indexing
	description	: "System's root class, EMU_ADMIN"
	author		: "Bernhard S. Buss"
	date		: "20.May.2006"


class
	EMU_ADMIN

inherit
	SOCKET_RESOURCES

create
	make

feature -- Initialization

	make (argv: ARRAY [STRING]) is
			-- Creation procedure of emu server-administration client.
			-- takes four arguments: server_adress server_port admin_name admin_password
		do
			if argv.count /= 5 then
				io.error.putstring ("Usage: ")
                io.error.putstring (argv.item (0))
                io.error.putstring (" hostname portnumber admin_name admin_password")
            else
            	server_host := argv.item (1)
            	server_port := argv.item(2).to_integer
            	admin_name := argv.item (3)
            	admin_password := argv.item (4)
            	create socket.make_client_by_port (server_port, server_host)
            	socket.connect
            	socket.independent_store (create {ADMIN_LOGIN}.make (admin_name, admin_password))
            	io.putstring ("connected as admin!%N")
            	io.readline
            	socket.independent_store (create {ADMIN_SHUTDOWN})
            	io.putstring ("initiated system shutdown.%N")
            	io.readline
            	socket.cleanup
			end
		rescue
			io.error.putstring ("Exception in EMU_ADMIN.make")
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
	
	admin_name: STRING
			-- the username of the admin.
	
	admin_password: STRING
			-- admin password for the emu server.
	

end -- class EMU_ADMIN
