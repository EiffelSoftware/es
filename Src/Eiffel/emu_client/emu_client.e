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
	default_create

feature -- Initialization

	connect_to_server (ip,u_name,pwd,proj_name:STRING; port:INTEGER) is
			-- main entry point of application.
			-- takes four arguments: server_adress server_port user_name password project_name
		local
			rescued: BOOLEAN
		do
           	if not rescued then
           		server_ip := ip
           		server_port := port
           		user_name := u_name
            	password := pwd
            	project_name := proj_name
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
		rescue
			if not assertion_violation then
				rescued := True
				clean_up	-- upon an exception clean_up all sockets and restart client.
				retry
			end
		end

feature -- Access	

	set_project_path (a_path:STRING) is
			-- sets project path
		require
			a_path_not_void: a_path /= void
		do
			project_path:=a_path
		ensure
			path_set: project_path.is_equal(a_path)
		end

	is_class_unlocked (a_class_name:STRING): BOOLEAN is
			-- returns true if class is unlocked
		require
			class_name_not_void: a_class_name /= Void
			class_name_not_empty: not a_class_name.is_empty
		do
			result:=False
			from
				unlocked_classes.start
			until
				unlocked_classes.after
			loop
				if unlocked_classes.item.is_equal(a_class_name) then
					result := True
				end
				unlocked_classes.forth
			end
		end



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

	project_path: STRING
			-- path on the local machine to the project location

	unlocked_classes: LINKED_LIST [STRING]
			-- a list uf unlocked classes

feature {NONE} -- Implementation

	remove_from_unlocked_list (a_class_name:STRING) is
			-- remove class, if it exists in the list
			require
			class_name_not_void: a_class_name /= Void
			class_name_not_empty: not a_class_name.is_empty
		do
			from
				unlocked_classes.start
			until
				unlocked_classes.after
			loop
				if unlocked_classes.item.is_equal(a_class_name) then
					unlocked_classes.remove
				end
				unlocked_classes.forth
			end
		end

	parse_class_name (a_path:STRING): STRING is
			-- parse class name from a path and returns this name
		require
			a_path_not_void: a_path /= Void
			a_path_not_empty: not a_path.is_empty
		local
			a,b,c,ind:INTEGER
		do
			ind:=0
			a:=0
			b:=0
			c:=a_path.count
			a := a_path.last_index_of('/',c)
			b := a_path.last_index_of('\',c)
			if a /= 0 then
				ind:=a
			elseif b /= 0 then
				ind:=b
			else
				ind:=1
			end
			result.set(a_path,ind,c)
		end


feature -- Sockets  -- former {USER_CMD}

	socket: NETWORK_STREAM_SOCKET
			-- the client socket that sends data to the server.

feature {USER_CMD} -- Termination
-- discussion: are these features needed by emu_client?

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
	unlock (a_relative_class_path: STRING): BOOLEAN is
			-- unlocking a class, ie. send the unlock request
			-- result== true means success
		require
			socket_not_void: socket /= void
			path_not_void: a_relative_class_path /= Void
		do
			socket.connect
    		socket.independent_store (create {CLIENT_CLASS_UNLOCK_REQUEST}.make (project_name, a_relative_class_path))
            --io.putstring ("requested to unlock class: " + a_relative_class_path +"!%N")
            --io.readline
            socket.cleanup
            unlocked_classes.extend (parse_class_name(a_relative_class_path))
            -- check for ok message before set result to true !!!
            -- not done yet
            result:=True
    	end

	lock (a_relative_class_path: STRING): BOOLEAN is
			-- locking a class, ie. send the lock request
			-- result== true means success
		require
			socket_not_void: socket /= void
			path_not_void: a_relative_class_path /= Void
		do
			socket.connect
    		socket.independent_store (create {CLIENT_CLASS_LOCK_REQUEST}.make (project_name, a_relative_class_path))
            --io.putstring ("requested to lock class: " + a_relative_class_path +"!%N")
            --io.readline
            socket.cleanup
            remove_from_unlocked_list (parse_class_name(a_relative_class_path))
            -- check for ok message before set result to true !!!
            -- not done yet
            result:=True
    	end

	upload (a_relative_class_path:STRING): BOOLEAN is
			-- uploading a class
			-- result== true means success
		require
			socket_not_void: socket /= void
		do
			socket.connect
    		socket.independent_store (create {CLIENT_CLASS_UPLOAD}.make (project_name, a_relative_class_path))
            --io.putstring ("uploaded class: " + a_relative_class_path +"!%N")
            --io.readline
            socket.cleanup
      		-- check for ok message before set result to true !!!
            -- not done yet
            result:=True
    	end

    download (): BOOLEAN is
			-- downloading ALL classes
			-- might be better to download unly modified classes
			-- result== true means success
		require
			socket_not_void: socket /= void
		do
			socket.connect
    		socket.independent_store (create {CLIENT_CLASS_DOWNLOAD}.make (project_name))
            --io.putstring ("downloaded classes for project: " + project_name +"!%N")
            --io.readline
            socket.cleanup
            -- check for ok message before set result to true !!!
            -- download is completed, after get_download.execute()
            -- not done yet
            result:=True
    	end

	--#####################################################################
	-- process_server (a_client:CLIENT_STATE [like socket]) is
	--	client_state is only for testing purposes here!! don't forget to remove!!!
	--#####################################################################
	process_server () is
			-- process incoming messages from server
		local
			rescued: BOOLEAN
			a_message: EMU_MESSAGE
			user_cmd: USER_CMD
			get_download: GET_DOWNLOAD
			server_closing: SERVER_CLOSING
		do
			if not rescued then
				user_cmd ?= a_message
				if user_cmd /= Void then
					get_download?=user_cmd
					if  get_download/= Void then
						get_download.execute()
					end
					server_closing ?= user_cmd
					if server_closing /= Void then
						server_closing.execute()
					end
				end
			end
		-- TO DO
		-- rescue clause:
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
-- not used yet
	is_online: BOOLEAN is
			-- indicates if the server is online.
		do
			Result := socket /= Void and then socket.exists and then socket.socket_ok and then socket.is_open_read
		end


feature {USER_CMD} -- Control Attributes
-- not used yet
	is_shutdown: BOOLEAN
			-- if set to true, the server has to shutdown.

	sleep_time: INTEGER_64
			-- amount of nanoseconds to sleep when idle.

feature {NONE} -- Defaults

	sleep_time_default: INTEGER_64 is 200000000
			-- the default sleep time is 0.2 seconds (= 200'000'000 nanoseconds)


invariant
	server_port_valid: server_port >= 0 and server_port <= 65535
	sleep_time_positive: sleep_time >= 0

end -- class ROOT_CLASS
