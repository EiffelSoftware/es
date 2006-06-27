indexing
	description	: "System's root class, EMU_SERVER"
	author		: "Bernhard S. Buss, Claudia Kuster"
	date		: "19.May.2006"

class
	EMU_SERVER

inherit
	THREAD_CONTROL

	EXCEPTIONS
		export
			{NONE} all
		end

	EMU_SERVER_CONSTANTS

create
	make

feature -- Initialization

	make (argv: ARRAY [STRING]) is
			-- main entry point of application.
			-- expects 2 args: port admin_pwd
		local
			rescued: BOOLEAN
		do
			if argv.count /= 3 or else argv.item(1).to_integer > 65535 or else argv.item(1).to_integer < 0 then
	            io.error.putstring ("Usage: ")
                io.error.putstring (argv.item (0))
                io.error.putstring (" portnumber admin_password")
            else
            	if not rescued then
	            	server_port := argv.item(1).to_integer
    	        	admin_password := argv.item(2)
    	        	sleep_time := sleep_time_default
					create listen.make_server_by_port (server_port)
					create clients.make
					initialize_projects
				else
					listen.make_server_by_port (server_port)
					--clients.start
				end
				listen.listen (5)
				-- register default commands. we use agents to be able to replace the features by an admin.
				idle_cmd := agent idle
				connect_client_cmd := agent connect_client
				process_client_cmd := agent process_client
				output ("server up and running on port: " + server_port.out)
				idle_cmd.apply	-- start server idle process
			end
		rescue
			if not assertion_violation then
				rescued := True
				clean_up	-- upon an exception clean_up all sockets and restart server.
				retry
			end
		end

	initialize_projects is
			-- create project list and folder for storage
			-- Recover after crash / server restart
		local
			file: RAW_FILE
			project_folder: DIRECTORY
			project :EMU_PROJECT
			project_name:STRING
			project_names:ARRAYED_LIST[STRING]
			retried: BOOLEAN
			delete_tried: BOOLEAN
		do
			if not retried then
			 	-- restore the project list
			 	create project_list.make
			 	-- restore the project folder
			 	create project_folder.make(project_folder_name)
			 	if not project_folder.exists then
			 		project_folder.create_dir
			 	end
			 	project_folder.open_read
				project_names := project_folder.linear_representation
		 		project_folder.close
				project_names.start
				-- remove first two entries in list (. and ..)
				project_names.remove
				project_names.remove
			else
				if not delete_tried and then file.exists then
					-- if file delete causes an exception, it will not be retried.					
					file.close
					delete_tried := True
					file.delete
				end
				delete_tried := False
				project_names.forth
			end
			-- restore project list from files
			from
			until
				project_names.after
			loop
				project_name := project_names.item
				create file.make(project_folder_name+"/"+project_name+"/"+project_name+".emu")
				if file.exists then
					file.open_read
		 			project ?= file.retrieved
		 			file.close
		 			if project /= Void then
			 			project_list.extend(project)
		 			end
				end
				project_names.forth
			end
		rescue
			retried := True
			retry
		end


feature {ADMIN_CMD} -- Termination

	clean_up is
			-- disconnect and close all sockets.	
		do
			if listen.exists then listen.close end
			from
				clients.start
			until
				clients.after
			loop
				clients.item.clean_up
				clients.remove
			end
		ensure
			offline: not is_online
			no_clients: clients.is_empty
		end

	shutdown is
			-- set the system to initiate a shutdown.
		do
			is_shutdown := True
		ensure
			system_is_shutdown: is_shutdown
		end


feature -- Process

	idle is
			-- the idle routine simply waits for something to happen.
		do
			from
			until
				is_shutdown
			loop
				-- check for connection requests
				if listen.readable then
					connect_client_cmd.apply
				end
				-- check for clients communication
				from
					clients.start
				until
					clients.after
				loop
					-- check if client connection terminated (due to error or remotely).
					if not clients.item.socket.exists or else not clients.item.socket.socket_ok or else clients.item.socket.is_closed then
						if clients.item.is_admin then
							admin_online := False
							output ("Admin '" + clients.item.username + "' disconnected.%N")
						else
							if clients.item.username /= Void then
								output ("User '" + clients.item.username + "' disconnected.%N")
							else
								output ("client disconnected.%N")
							end
						end
						clients.remove
					else
						-- check for incoming message
						if clients.item.socket.readable then
							process_client_cmd.call ([clients.item])
						end
						clients.forth
					end
				end
				-- give cpu time for other processes
				sleep (sleep_time)
			end
			clean_up
		rescue
			if not assertion_violation then
				-- 1. the listen socket has been closed due to an error.
				if not listen.socket_ok or else listen.is_closed then
					listen.make_server_by_port (server_port)
					retry
				end
				-- 2. a client connection has failed or disconnected.
				retry
			end
		end

	connect_client is
			-- upon a client connection request this routine will accept the request
			-- and create a new socket that will handle the connection.
		local
			rescued: BOOLEAN
		do
			if not rescued then
				listen.accept
				if listen.accepted /= Void then
					clients.extend (create {CLIENT_STATE[like listen]}.make(listen.accepted, Current))
				end
			end
		rescue
			if not assertion_violation then
				-- 1. can't create any sockets anymore (too many clients).
				--|TODO: find out exception code of 'socket_table_full'
				-- 2. the listen socket has been closed due to an error.
				if not listen.socket_ok or else listen.is_closed then
					listen.make_server_by_port (server_port)
					rescued := True
					retry
				end
			end
		end

	process_client (a_client: CLIENT_STATE[like listen]) is
			-- process a client's incoming communication.
		local
			rescued: BOOLEAN
			a_message: EMU_MESSAGE
			project_msg: EMU_PROJECT_MSG
		do
			if not rescued then
				a_client.process_msg
				project_msg ?= a_message
				if project_msg /= Void then
					a_client.process_msg
				end
			end
		rescue
			if not assertion_violation then
				-- 1. received message is not an Eiffel Storable Object of type EMU_MESSAGE
				if exception = 27 then
					-- client may have disconnected, or an error occurred.
					a_client.clean_up
					rescued := True
					retry
				end
				if tag_name.is_equal ("Retrieve_exception") then
					--if a_message = Void then
						rescued := True
						retry
					--end
				end
			end
			output ("EXCEPTION in process_client! errorcode: " + exception.out + "%N")
			a_client.clean_up
			rescued := True
			retry
		end


feature -- Commands

	idle_cmd: PROCEDURE [ANY, TUPLE]
			-- the idle command that will be executed by the server.

	connect_client_cmd: PROCEDURE [ANY, TUPLE]
			-- the connect client command that will be executed to connect clients.

	process_client_cmd: PROCEDURE [ANY, TUPLE]
			-- the process client command that will be executed to process clients.


feature -- Output

	output (a_text: STRING) is
			-- output a text on the console. print a new_line.
		require
			a_text_valid: a_text /= Void and then not a_text.is_empty
		local
			a_time: TIME
		do
			create a_time.make_now
			io.put_string(a_time.out + " | " + a_text)
			io.put_new_line
		end


feature {CLIENT_STATE} -- Modification

	add_project (a_project_name, an_admin_password: STRING) is
			-- create and add a project to the project list.
		require
			project_name_valid: a_project_name /= Void and then not a_project_name.is_empty
			project_name_does_not_exist: not has_project (a_project_name)
			amdin_password_valid: an_admin_password /= Void and then not an_admin_password.is_empty
		do
			project_list.extend (create {EMU_PROJECT}.make (a_project_name, an_admin_password))
		ensure
			new_user_added: project_list.count = old project_list.count + 1
		end

	remove_project (a_project_name: STRING) is
			-- remove a project with name a_project_name from the project list.
			-- delete the persist storage on disk aswell.
		require
			project_name_valid: a_project_name /= Void and then not a_project_name.is_empty
			project_name_exists: has_project (a_project_name)
		local
			folder: DIRECTORY
		do
			-- we require project to exist in the list.
			project_list.go_i_th (index_of_project (a_project_name))
			project_list.remove
			--delete project folder.
			create folder.make(project_folder_name +"/"+a_project_name)
			if folder.exists then
				folder.recursive_delete	-- may raise an exception.
			end
		ensure
			project_removed: not has_project (a_project_name)
		end



feature -- Status

	is_online: BOOLEAN is
			-- indicates if the server is online.
		do
			Result := listen /= Void and then listen.exists and then listen.socket_ok and then listen.is_open_read
		end

feature -- Attributes

	server_port: INTEGER
			-- the port to which the listen socket is bound.

	project_list: LINKED_LIST[EMU_PROJECT]
			-- a list of all emu projects on this server


feature {ADMIN_CMD} -- Control Attributes

	is_shutdown: BOOLEAN
			-- if set to true, the server has to shutdown.

	sleep_time: INTEGER_64
			-- amount of nanoseconds to sleep when idle.


feature {NONE} -- Defaults

	sleep_time_default: INTEGER_64 is 200000000
			-- the default sleep time is 0.2 seconds (= 200'000'000 nanoseconds)


feature {ADMIN_CMD, CLIENT_STATE} -- Administration

	admin_connected is
			-- an admin connected via a client authorization.
		do
			admin_online := True
		end

	admin_disconnected is
			-- an admin disconnected.
		do
			admin_online := False
		end

	admin_password: STRING
			-- admin password needed to administrate the server.
			-- set using a program argument at startup.

	admin_online: BOOLEAN
			-- indicates if an admin is connected.


feature {ADMIN_CMD} -- Sockets

	listen: NETWORK_STREAM_SOCKET
			-- the server socket that listens for new connection requests.

	clients: LINKED_LIST [CLIENT_STATE[like listen]]
			-- a list of sockets that are used to communicate with the clients.

feature -- Queries

	has_project (a_project_name: STRING): BOOLEAN is
			-- checks if a project named "a_project_name" is in the project list.
			require
				a_project_name_valid: a_project_name /= void and then not a_project_name.is_empty
			do
				Result := (index_of_project (a_project_name) >= 0)
			ensure
				result_reasonable: project_list.is_empty implies (Result = False)
			end

	project_count: INTEGER is
			-- returns the number of projects in the project list.
			do
				result := project_list.count
			ensure
				result_correct: Result = project_list.count
			end

	index_of_project (project_name: STRING): INTEGER is
			-- returns the index of a project in the project list.
			-- returns -1 if a project does not exist.
		require
			project_name_valid: project_name /= Void and then not project_name.is_empty
		local
			found: BOOLEAN
			i: INTEGER
		do
			from
				project_list.start
				Result := -1
				i := 0
			invariant
				project_list.index < project_list.count
			variant
				project_list.count - i + 1
			until
				project_list.after or found
			loop
				if project_list.item.name.is_equal(project_name) then
					found := True
					Result := i
				end
				i := i + 1
				project_list.forth
			end
		ensure
			result_valid: Result >= -1 or Result < project_list.count
		end

	get_project (a_project_name: STRING): EMU_PROJECT is
			-- returns the project called "a_project_name".
			-- returns Void if the project does not exist.
		require
			project_name_valid: a_project_name /= Void and then not a_project_name.is_empty
		local
			index: INTEGER
		do
			index := index_of_project (a_project_name)
			if index >= 0 then
				-- return project
				Result := project_list.i_th(index)
			end
		end


invariant
	server_port_valid: server_port >= 0 and server_port <= 65535
	sleep_time_positive: sleep_time >= 0
	project_list_exists: project_list /= void
	clients_exist: clients /= void


end -- class ROOT_CLASS
