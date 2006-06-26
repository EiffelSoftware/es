indexing
	description	: "EMU CLIENT, connects to server, handles communication between user and server"
	author		: "Andrea Zimmermann, Domenic Schroeder, Ramon Schwammberger"
	date		: "$Date$"

class
	EMU_CLIENT

inherit
	THREAD_CONTROL
	
	EXCEPTIONS
		export
			{NONE} all
		end

create
	make

feature -- Initialization

	make (argv: ARRAY [STRING]) is
			-- main entry point of application.
			-- takes four arguments: server_adress server_port user_name password project_name
		local
			rescued: BOOLEAN
		do
			if argv.count /= 6 or else argv.item(2).to_integer > 65535 or else argv.item(2).to_integer < 0 then
				io.error.putstring ("Usage: ")
                io.error.putstring (argv.item (0))
                io.error.putstring (" hostname portnumber user_name password")
            else
            	if not rescued then
            		server_ip := argv.item(1)
            		server_port := argv.item(2).to_integer
            		user_name := argv.item (3)
            		password := argv.item (4)
            		project_name := argv.item(5)
    	        	sleep_time := sleep_time_default
					create socket.make_client_by_port (server_port, server_ip)
				else
					socket.make_client_by_port (server_port, server_ip)
				end
				register_to_server()
				
				-- register default commands. we use agents to be able to replace the features by an admin.
				idle_cmd := agent idle
				process_server_cmd := agent process_server
				idle_cmd.apply	-- start client idle process
			end
		rescue
			if not assertion_violation then
				rescued := True
				clean_up	-- upon an exception clean_up all sockets and restart client.
				retry
			end
		end

feature -- Access	
	
	server_port: INTEGER
			-- the port to which the listen socket is bound. Lies between 0 and 65535.
			
	server_ip: STRING
			-- ip of the server
			
	user_name: STRING
			-- user name
			
	password: STRING
			-- password
	
	project_name: STRING
			-- the project to which the client connects
			
			
feature -- Sockets  -- former {USER_CMD}
		
	socket: NETWORK_STREAM_SOCKET
			-- the client socket that sends data to the server.

feature {USER_CMD} -- Termination

	clean_up is
			-- disconnect and close all sockets.	
		do
			if socket.exists then socket.close end
		ensure
			offline: not is_online
		end

	shutdown is
			-- set the system to initiate a shutdown.
		do
			is_shutdown := True
		ensure
			system_is_shutdown: is_shutdown
		end
		

feature -- Process

    register_to_server () is
    		-- register this client to the server
    	require
    		socket_not_void: socket /= void
    		
    	do
    		socket.connect
    		socket.independent_store (create {USER_LOGIN}.make (user_name, password, project_name))
            io.putstring ("connected as user" + user_name +"!%N")
            io.readline
            socket.cleanup
    	end
    	

	idle is
			-- the idle routine simply waits for something to happen
			-- ie. receives data
		do
			from
			until
				is_shutdown
			loop
				-- check for incoming data
				if socket.readable then
					process_server_cmd.apply	
				end
				sleep (sleep_time)
			end
			clean_up
		rescue
			if not assertion_violation then
				-- 1. the socket has been closed due to an error.
				if not socket.socket_ok or else socket.is_closed then
					socket.make_client_by_port (server_port, server_ip)
					retry
				end
				-- 2. a client connection has failed or disconnected. ??
				retry
			end
		end
	
	
	--commands implementing 'client features', these are LOCK, UNLOCK, UPLOAD, DOWNLOAD
	unlock (a_class_name:STRING) is
			-- unlocking a class, ie. send the unlock request
		require
			socket_not_void: socket /= void
		do
			socket.connect
    		socket.independent_store (create {CLIENT_CLASS_UNLOCK_REQUEST}.make (project_name, a_class_name))
            io.putstring ("requested to unlock class: " + a_class_name +"!%N")
            io.readline
            socket.cleanup
    	end
	
	lock (a_class_name:STRING) is
			-- locking a class, ie. send the lock request
		require
			socket_not_void: socket /= void
		do
			socket.connect
    		socket.independent_store (create {CLIENT_CLASS_LOCK_REQUEST}.make (project_name, a_class_name))
            io.putstring ("requested to lock class: " + a_class_name +"!%N")
            io.readline
            socket.cleanup
    	end	
	
	upload (a_class_name:STRING) is
			-- uploading a class
		require
			socket_not_void: socket /= void
		do
			socket.connect
    		socket.independent_store (create {CLIENT_CLASS_UPLOAD}.make (project_name, a_class_name))
            io.putstring ("uploaded class: " + a_class_name +"!%N")
            io.readline
            socket.cleanup
    	end	
    	
    download () is
			-- downloading ALL classes
			-- might be better to download unly modified classes
		require
			socket_not_void: socket /= void
		do
			socket.connect
    		socket.independent_store (create {CLIENT_CLASS_DOWNLOAD}.make (project_name))
            io.putstring ("downloaded classes for project: " + project_name +"!%N")
            io.readline
            socket.cleanup
    	end	

    	
	--#####################################################################
	-- process_server (a_client:CLIENT_STATE [like socket]) is
	--	client_state is only for testing purposes here!! don't forget to remove!!!
	-- client_state: CLIENT_STATE[like socket]
	--#####################################################################

	
	process_server (a_client: CLIENT_STATE[like socket]) is --##### not yet implemented!

			-- process incoming messages from server
		local
			rescued: BOOLEAN
			a_message: EMU_MESSAGE

			user_cmd: USER_CMD
		do
			if not rescued then
				a_message ?= a_client.get_msg		-- used to check if it is a valid emu_message
				user_cmd ?= a_message
				if user_cmd /= Void then
--					if admin_login.password.is_equal(admin_password) then
--						-- admin successfully authenticated.
--						if admin_online then
--							-- only one admin allowed
--							--|TODO: tell client which admin is online.
--						else
--							a_client.set_admin
--							a_client.set_username (admin_login.username)
--							admin_online := True
--							io.putstring ("Admin '" + a_client.username + "' successfully logged in.%N")
--						end
--					end
				else
--					admin_cmd ?= a_message
--					if admin_cmd /= Void then
--						admin_cmd.execute (Current)
--					end
				end
			end
--		rescue
--			if not assertion_violation then
--				-- 1. received message is not an Eiffel Storable Object of type EMU_MESSAGE
--				if exception = 27 then
--					-- client may have disconnected, or an error occurred.
--					a_client.socket.cleanup
--					rescued := True
--					retry
--				end
--				if tag_name.is_equal ("Retrieve_exception") then
--					--if a_message = Void then
--						rescued := True
--						retry
--					--end
--				end
--			end
--			io.error.putstring ("EXCEPTION in process_client! errorcode: " + exception.out + "%N")
--			a_client.socket.cleanup
--			rescued := True
--			retry
		end


feature -- Commands

	idle_cmd: PROCEDURE [ANY, TUPLE]
			-- the idle command that will be executed by the server.
			
	process_server_cmd: PROCEDURE [ANY, TUPLE]
			-- the process client command that will be executed to process clients.
		

feature -- Status

	is_online: BOOLEAN is
			-- indicates if the server is online.
		do
			Result := socket /= Void and then socket.exists and then socket.socket_ok and then socket.is_open_read
		end


feature {USER_CMD} -- Control Attributes

	is_shutdown: BOOLEAN
			-- if set to true, the server has to shutdown.

	sleep_time: INTEGER_64
			-- amount of nanoseconds to sleep when idle.

feature {NONE} -- Defaults

	sleep_time_default: INTEGER_64 is 200000000
			-- the default sleep time is 0.2 seconds (= 200'000'000 nanoseconds)

			
--feature -- Queries
--	--UNUSED
--	has_project (a_project_name: STRING): BOOLEAN is
--			-- checks if a project named "a_project_name" is in the project list.
--			require
--				a_project_name_valid: a_project_name /= void and then not a_project_name.is_empty
--			do
--				Result := (index_of_project (a_project_name) >= 0)
--			ensure
--				result_reasonable: project_list.is_empty implies (Result = False)
--			end
--			
--	project_count: INTEGER is
--			-- returns the number of projects in the project list.
--			do
--				result := project_list.count
--			ensure
--				result_correct: Result = project_list.count
--			end
--			
--	index_of_project (project_name: STRING): INTEGER is
--			-- returns the index of a project in the project list.
--			-- returns -1 if a project does not exist.
--		require
--			project_name_valid: project_name /= Void and then not project_name.is_empty
--		local
--			found: BOOLEAN
--			i: INTEGER
--		do
--			from
--				project_list.start
--				Result := -1
--				i := 0
--			invariant
--				project_list.index < project_list.count
--			variant
--				project_list.count - i + 1
--			until
--				project_list.after or found
--			loop
--				if project_list.item.name.is_equal(project_name) then
--					found := True
--					Result := i
--				end
--				i := i + 1
--				project_list.forth
--			end
--		ensure
--			result_valid: Result >= -1 or Result < project_list.count
--		end
--		
--	get_project (a_project_name: STRING): EMU_PROJECT is
--			-- returns the project called "a_project_name".
--			-- returns Void if the project does not exist.
--		require
--			project_name_valid: a_project_name /= Void and then not a_project_name.is_empty
--		local
--			index: INTEGER
--		do
--			index := index_of_project (a_project_name)
--			if index >= 0 then
--				-- return project
--				Result := project_list.i_th(index)
--			end
--		end


invariant
	server_port_valid: server_port >= 0 and server_port <= 65535
	sleep_time_positive: sleep_time >= 0
	
end -- class ROOT_CLASS
