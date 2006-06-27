indexing
	description	: "EMU CLIENT, connects to server, handles communication between user and server"
	author		: "Andrea Zimmermann, Domenic Schroeder, Ramon Schwammberger"
	date		: "$Date$"
	revision	: "$Revision$"

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

	connect_to_server (ip,u_name,pwd,proj_name:STRING; port:INTEGER):BOOLEAN is
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
				--idle_cmd.apply	-- start client idle process
				result := is_logged_in
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

	unlocked_classes: LINKED_LIST [STRING] is
			-- a list uf unlocked classes
			once
				create Result.make
			end

	ok_message: CLIENT_OK
			-- last recieved client_ok message

	error : CLIENT_ERROR


feature {NONE} -- Implementation

	remove_from_unlocked_list (a_class_name:STRING) is
			-- remove class, if it exists in the list
		require
			class_name_not_void: a_class_name /= Void
			class_name_not_empty: not a_class_name.is_empty
		local
			abort:BOOLEAN
		do
			from
				unlocked_classes.start
			until
				unlocked_classes.after or abort
			loop
				if unlocked_classes.item.is_equal(a_class_name) then
					unlocked_classes.remove
					abort := true  --added abort,because otherwise conflict with only one element in list....
				end
				if (not abort) then
					unlocked_classes.forth
				end
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
			create result.make_empty --added
			result.set(a_path,ind,c)
			result.remove_head (1) --now  "root_class.e" ...but still don't like it--obsolete
		end

	wait_for_ok (ok_code:INTEGER):BOOLEAN is
			-- wait until an ok_message with ok_code arrives
		require
			ok_code_valid: ok_code > 0
		local
			i:INTEGER
			ok:BOOLEAN
			rescued: BOOLEAN
		do
			if not rescued then
				ok := False
				if ok_message /= void then
					if ok_message.ok_code = ok_code then
						ok := True
						ok_message := void
					end
				end
					--sleep(sleep_time_default)	
					-- no sleep, so the system is blocked by this feature
				result:=ok
			end
			rescue
				--to be implemented <==

		end





feature -- Sockets  -- former {USER_CMD}

	socket: NETWORK_STREAM_SOCKET
			-- the client socket that sends data to the server.

feature {NONE} -- Termination

	clean_up is
			-- disconnect and close all sockets.	
		do
			if socket.exists then socket.close end
		ensure
			offline: not is_online
		end

-- discussion: is this feature needed by emu_client?
	shutdown is
			-- set the system to initiate a shutdown.
		do
			is_shutdown := True
		ensure
			system_is_shutdown: is_shutdown
		end


feature -- Process

	downloaded_class: STRING
			-- class downloaded from server

    register_to_server () is
    		-- register this client to the server
    	require
    		socket_not_void: socket /= void

    	do
    		socket.connect
    		socket.independent_store (create {USER_LOGIN}.make (user_name, password, project_name))
            idle	-- start client idle process
            is_logged_in := wait_for_ok (306)
    	end


	idle is
			-- the idle routine simply waits for something to happen
			-- ie. receives data
		local
			is_end:BOOLEAN
			i:INTEGER
		do
			from
				is_end := false
				i := 100
			until
				is_shutdown or is_end or i<0
			loop
				-- check for incoming data
				if socket.readable then
					is_end := true
					process_server
				end
				sleep (sleep_time_default)
				i := i - 1
			end
			--clean_up
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
	unlock (an_absolute_path,a_class_name: STRING): BOOLEAN is
			-- unlocking a class, ie. send the unlock request
			-- result== true means success
		require
			socket_not_void: socket /= void
			path_not_void: an_absolute_path /= Void
		do
    		socket.independent_store (create {CLIENT_CLASS_UNLOCK_REQUEST}.make (project_name, a_class_name))
            unlocked_classes.extend (a_class_name)
            -- what happens, if unlock successful, but ok_message lost???? <==
            idle
            result := wait_for_ok({CLIENT_OK}.class_unlocked)
    	end

	lock (an_absolute_path,a_class_name: STRING): BOOLEAN is
			-- locking a class, ie. send the lock request
			-- result== true means success
		require
			socket_not_void: socket /= void
			path_not_void: an_absolute_path /= Void
		do
    		socket.independent_store (create {CLIENT_CLASS_LOCK_REQUEST}.make (project_name, a_class_name))
            remove_from_unlocked_list (a_class_name)
            -- what happens when ok_message from server got lost??
            idle
            result := wait_for_ok({CLIENT_OK}.class_locked)
    	end

	upload (an_absolute_path,a_class_name:STRING): BOOLEAN is
			-- uploading a class
			-- result== true means success
		require
			socket_not_void: socket /= void
			path_not_void: an_absolute_path /= Void
		do
    		socket.independent_store (create {CLIENT_CLASS_UPLOAD}.make (project_name, an_absolute_path, project_path, a_class_name))
      		-- no problem if ok_message got lost, just redo upload, no harm done
      		idle
      		result := wait_for_ok({CLIENT_OK}.class_uploaded)
    	end

    download (an_absolute_path,a_class_name:STRING): BOOLEAN is
			-- downloading ALL classes
			-- might be better to download unly modified classes
			-- result== true means success
		require
			socket_not_void: socket /= void
		do
			downloaded_class := an_absolute_path
    		socket.independent_store (create {CLIENT_CLASS_DOWNLOAD}.make (project_name,a_class_name))
            -- what happens, if ok_message got lost?
			idle
            result := is_download
    	end

	--#####################################################################
	-- process_server (a_client:CLIENT_STATE [like socket]) is
	--	client_state is only for testing purposes here!! don't forget to remove!!!
	-- client_state: CLIENT_STATE[like socket]
	--#####################################################################
	process_server () is
			-- process incoming messages from server
		local
			rescued: BOOLEAN
			a_message: EMU_MESSAGE
			client_message: EMU_CLIENT_MESSAGE
			user_cmd: USER_CMD
			get_download: GET_DOWNLOAD
			server_closing: SERVER_CLOSING
			ok_msg: CLIENT_OK
		do
			is_download := false
			if not rescued then
				a_message ?= socket.retrieved
				if a_message/=void then
					client_message ?= a_message
					if client_message /= void then
						get_download?=client_message
						if  get_download/= Void then
							is_download := true
							get_download.execute(downloaded_class)
						end
					end
					user_cmd ?= a_message
					if user_cmd /= Void then
						server_closing ?= user_cmd
						if server_closing /= Void then
							server_closing.execute()
						end
					end

					ok_msg ?= a_message
					if ok_msg /= void then
						ok_message:= ok_msg
					end
				end
			end
--				a_message ?= socket.retrieved
--				if a_message/=void then
--					user_cmd ?= a_message
--					if user_cmd /= Void then
--						get_download?=user_cmd
--						if  get_download/= Void then
--							is_download := true
--							get_download.execute(downloaded_class)
--						end
--						server_closing ?= user_cmd
--						if server_closing /= Void then
--							server_closing.execute()
--						end
--					end
--					ok_msg ?= a_message
--					if ok_msg /= void then
--						ok_message:= ok_msg
--					end
--				end
--			end
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
-- not used yet?
	is_online: BOOLEAN is
			-- indicates if the server is online.
		do
			Result := socket /= Void and then socket.exists and then socket.socket_ok and then socket.is_open_read
		end

	is_logged_in:BOOLEAN
			-- is current user logged to server

	is_download: BOOLEAN
			-- is download


feature {NONE} -- Control Attributes
-- not used yet?
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
