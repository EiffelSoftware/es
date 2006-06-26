indexing
	description: "The state of a client that is connected to the server."
	author: "Bernhard S. Buss, Claudia Kuster"
	date: "20.May.2006"
	revision: "$Revision$"

class
	CLIENT_STATE [G -> SOCKET]


create
	make

feature -- Initialization

	make (a_socket: G; a_system: EMU_SERVER) is
			-- create a new client and set its socket.
		require
			a_socket_valid: a_socket /= Void and then a_socket.exists
			a_system_not_void: a_system /= Void
		do
			socket := a_socket
			system := a_system
			io.putstring ("client connected.%N")
		ensure
			socket_set: socket = a_socket
			system_set: system = a_system
		end


feature -- Termination

	clean_up is
			-- clean up the client and its socket.
		do
			if is_admin then
				system.admin_disconnected
				is_admin := False
			end
			if socket.exists then
				socket.cleanup
			end
		ensure
			socket_closed: socket.is_closed
		end


feature {EMU_SERVER} -- Socket

	socket: G
			-- the client socket.


feature -- Attributes

	username: STRING
			-- the username of the client.

	is_admin: BOOLEAN
			-- is this client a server administrator?

	system: EMU_SERVER
			-- the system that is having the project list.

	received_msg: EMU_MESSAGE
			-- the received emu message.
			
	class_list: LINKED_LIST[EMU_PROJECT_CLASS]
			-- linked list of classes of a project


feature -- Modification

	set_admin is
			-- set admin status of client.
		do
			is_admin := True
		ensure
			admin_set: is_admin
		end

	set_username (a_name: STRING) is
			-- set the username of this client.
		require
			a_name_valid: a_name /= Void and then not a_name.is_empty
		do
			username := a_name
		ensure
			username_set: username = a_name
		end

	set_system (a_system: EMU_SERVER) is
			-- set the system of this client state.
		require
			a_system_not_void: a_system /= Void
		do
			system := a_system
		ensure
			system_is_set: system = a_system
		end


feature -- Process Messages

	process_msg is
			-- process the received message.
			-- determine the parent type of the message.
		require
			system_not_void: system /= Void
		local
			admin_login: ADMIN_LOGIN; admin_cmd: ADMIN_CMD
			project_msg: EMU_PROJECT_MSG
			client_msg: EMU_CLIENT_MESSAGE
		do
			received_msg := get_msg
			admin_login ?= received_msg
			if admin_login /= Void then
				if admin_login.password.is_equal(system.admin_password) then
					-- admin successfully authenticated.
					if system.admin_online then
						-- only one admin allowed
						--|TODO: tell client which admin is online.
					else
						set_admin
						set_username (admin_login.username)
						system.admin_connected
						io.putstring ("Admin '" + username + "' successfully logged in.%N")
					end
				end
			else
				admin_cmd ?= received_msg
				if admin_cmd /= Void then
					admin_cmd.execute (system)
				end
			end
			project_msg ?= received_msg
			if project_msg /= Void then
				process_project_msg
			end
			client_msg ?= received_msg
			if client_msg /= Void then
				process_client_msg
			end
		end


	process_project_msg is
			-- process a project message.
			-- determine the type of the project message.
		require
			system_not_void: system /= Void
		local
			add_user: PROJECT_ADD_USER
			class_list_request: PROJECT_CLASS_LIST_REQUEST
			project_create: PROJECT_CREATE
			project_delete: PROJECT_DELETE
			remove_user: PROJECT_REMOVE_USER
			user_list_request: PROJECT_USER_LIST_REQUEST
			project_msg: EMU_PROJECT_MSG
		do
			project_msg ?= received_msg	-- requires msg to be of the correct type (caller process msg).
			-- check message for invalid attributes.
			if project_msg.project_name = Void or else project_msg.project_name.is_empty then
				send_msg (create {PROJECT_ERROR}.make ("empty", {PROJECT_ERROR}.general_error, "INVALID: empty project name provided."))
			elseif project_msg.project_password = Void or else project_msg.project_password.is_empty then
				send_msg (create {PROJECT_ERROR}.make (project_msg.project_name, {PROJECT_ERROR}.general_error, "INVALID: empty project password provided."))
			else
				add_user ?= received_msg
				if add_user /= Void then
					process_project_add_user (add_user)
				end
				class_list_request ?= received_msg
				if class_list_request /= Void then
					process_project_class_list_request (class_list_request)
				end
				project_create ?= received_msg
				if project_create /= Void then
					process_project_create (project_create)
				end
				project_delete ?= received_msg
				if project_delete /= Void then
					process_project_delete (project_delete)
				end
				remove_user ?= received_msg
				if remove_user /= Void then
					process_project_remove_user (remove_user)
				end
				user_list_request ?= received_msg
				if user_list_request /= Void then
					process_project_user_list_request (user_list_request)
				end
			end
		end

	process_project_add_user (msg: PROJECT_ADD_USER) is
			-- process the add user message.
		local
			project: EMU_PROJECT
		do
			-- try to get project from server
			project := system.get_project(msg.project_name)
			if project = Void then
				-- project does not exist
				-- send error message to client
				send_msg (create {PROJECT_ERROR}.make_project_not_found(msg.project_name))
			elseif not project.is_password_correct (msg.project_password) then
				send_msg (create {PROJECT_ERROR}.make_admin_password_incorrect (msg.project_name))
			else
				-- check if the project already has a user with that name
				if project.has_user (msg.user_name) then
					-- if user already exists send an error message to the client
					send_msg(create {PROJECT_ERROR}.make_user_already_exists(msg.project_name))
				else
					-- create and add user to the project list and send ok message to the client	
					project.add_user (msg.user_name, msg.user_password)
					send_msg (create {PROJECT_OK}.make_user_added(msg.project_name))
				end
			end
		end

	process_project_class_list_request (msg: PROJECT_CLASS_LIST_REQUEST) is
			-- process the class list request message.
		local
			project: EMU_PROJECT
			project_class: EMU_PROJECT_CLASS
			project_cluster: EMU_PROJECT_CLUSTER
		do
			-- send a message containing the class list to the client
			project := system.get_project(msg.project_name)
			if project = Void then
				-- send an error message
				-- to be implemented
			else
				create class_list.make
				from
					project.clusters.start
				until
					project.clusters.after
				loop
					project_class ?= project.clusters.item
					if project_class /= Void then
						class_list.extend (project_class)
					end
					project_cluster ?= project.clusters.item
					if project_cluster /= Void then
						find_classes_of_cluster(project_cluster)
					end
				end
			end
		end

	process_project_create (msg: PROJECT_CREATE) is
			-- process the project create message.
		do
			-- check if a project with that name allready exists
			io.put_string ("create project: " + msg.project_name + "%N")
			if system.has_project (msg.project_name) then
				-- if project already exists send an error message to the client
				send_msg (create {PROJECT_ERROR}.make_project_already_exists(msg.project_name))
			else
				-- create project, add it to the project list and send ok message to the client
				system.project_list.extend (create {EMU_PROJECT}.make(msg.project_name, msg.project_password))
				send_msg (create {PROJECT_OK}.make_project_created(msg.project_name))
			end

		end

	process_project_delete (msg: PROJECT_DELETE) is
			-- process the project delete message.
		local
			rescued: BOOLEAN
			project: EMU_PROJECT
		do
			if not rescued then
				-- try to get project from system.
				project := system.get_project (msg.project_name)
				if project = Void then
					-- if project does not exist send an error message to the client
					send_msg(create {PROJECT_ERROR}.make_project_not_found(msg.project_name))
				elseif not project.is_password_correct (msg.project_password) then
					send_msg (create {PROJECT_ERROR}.make_admin_password_incorrect (msg.project_name))
				else
					-- remove project and send ok message to the client
					system.remove_project (msg.project_name) -- may cause an exception.
					send_msg(create {PROJECT_OK}.make_project_deleted(msg.project_name))
				end
			else
				send_msg(create {PROJECT_ERROR}.make (msg.project_name, {PROJECT_ERROR}.general_error, "EXCEPTION: Project deletion failed!"))
			end
		rescue
			rescued := True
			retry
		end

	process_project_remove_user (msg: PROJECT_REMOVE_USER) is
			-- process the project remove user message.
		local
			project: EMU_PROJECT
		do
			-- try to get project from server
			project := system.get_project (msg.project_name)
			if project = Void then
				-- project does not exist
				-- send error message to client
				send_msg (create {PROJECT_ERROR}.make_project_not_found(msg.project_name))
			elseif not project.is_password_correct (msg.project_password) then
				send_msg (create {PROJECT_ERROR}.make_admin_password_incorrect (msg.project_name))
			else
				-- check if the project has a user with that name
				if not project.has_user(msg.user_name) then
					-- if there is no such user for this project send error message to client
					send_msg(create {PROJECT_ERROR}.make_user_not_found(msg.project_name))
				else
					-- remove user from the project list and send ok message to the client	
					project.remove_user (msg.user_name)
					send_msg (create {PROJECT_OK}.make_user_removed(msg.project_name))
				end
			end
		end

	process_project_user_list_request (msg: PROJECT_USER_LIST_REQUEST) is
			-- process the project user list request message.
		local
			project: EMU_PROJECT
		do
			-- try to get project from server
			project := system.get_project (msg.project_name)
			if project = Void then
				-- project does not exist
				-- send error message to client
				send_msg (create {PROJECT_ERROR}.make_project_not_found(msg.project_name))
			elseif not project.is_password_correct (msg.project_password) then
				send_msg (create {PROJECT_ERROR}.make_admin_password_incorrect (msg.project_name))
			else
				-- send a message to the client containing the user list of this project.
				send_msg(create {PROJECT_USER_LIST}.make(msg.project_name, system.get_project(msg.project_name).get_list_of_users))
			end
		end

	process_client_msg is
			-- process a client message.
			-- determine the type of the client message.
		require
			system_not_void: system /= Void
		local
			download: CLIENT_CLASS_DOWNLOAD
			list_request: CLIENT_CLASS_LIST_REQUEST -- not yet used
			lock_request: CLIENT_CLASS_LOCK_REQUEST
			unlock_request: CLIENT_CLASS_UNLOCK_REQUEST
			upload: CLIENT_CLASS_UPLOAD

			--class_list_request: PROJECT_CLASS_LIST_REQUEST

		do
			download ?= received_msg
			if download /= Void then
				process_client_download (download)
			end
			list_request ?= received_msg
			if list_request /= Void then
				--process_client_list_request (class_list_request)
				-- not yet used nor implemented
			end
			lock_request ?= received_msg
			if lock_request /= Void then
				process_client_lock_request (lock_request)
			end
			unlock_request ?= received_msg
			if unlock_request /= Void then
				process_client_unlock_request (unlock_request)
			end
			upload ?= received_msg
			if upload /= Void then
				process_client_upload (upload)
			end
--			user_list_request ?= received_msg
--			if user_list_request /= Void then
--				process_project_user_list_request (user_list_request)
--			end
		end

	process_client_download (msg: CLIENT_CLASS_DOWNLOAD) is
			-- respond to download request.
		local
			project: EMU_PROJECT
		do
			-- try go get project from server
			project := system.get_project(msg.project_name)
			if project = Void then
				-- project does not exist
				-- send error message to client
				-- adapt error message! :
				-- send_msg (create {PROJECT_ERROR}.make_project_not_found(msg.project_name))
			else
				-- start download
				-- TO BE IMPLEMENTED
			end
		end


	process_client_lock_request (msg: CLIENT_CLASS_LOCK_REQUEST) is
			-- lock requested class for user, ie. the class is
			-- free again for other users!
		local
			project: EMU_PROJECT
			found: BOOLEAN
			locked_class: EMU_PROJECT_CLASS
		do
			-- try go get project from server
			project := system.get_project(msg.project_name)
			if project = Void then
				-- project does not exist
				-- send error message to client
				send_msg (create {CLIENT_ERROR}.make_lock_not_successful (msg.project_name, msg.emu_class_name))
			else	
				-- search the right class
				from
					project.clusters.start
					found:= False
				until
					project.clusters.after or found=True
				loop
					if project.clusters.item.has_class (msg.emu_class_name) then
						-- do lock of class
						locked_class:= project.clusters.item.get_class (msg.emu_class_name)
						found:= True
						if locked_class.is_free and then locked_class.current_user.is_equal (username) then
							locked_class.set_to_free
						else
							send_msg (create {CLIENT_ERROR}.make_lock_not_successful (msg.project_name, msg.emu_class_name))
							-- error, class isn't used by this user
						end		
					end
					project.clusters.forth
				end
				if found = False then
					send_msg (create {CLIENT_ERROR}.make_class_not_found (msg.project_name, msg.emu_class_name))
					-- error, class doesn't exist
				end
			end
		end

	process_client_unlock_request (msg: CLIENT_CLASS_UNLOCK_REQUEST) is
			-- unlock requested class for user, ie. the class is
			-- not editable for other users!
		local
			project: EMU_PROJECT
			found: BOOLEAN
			unlocked_class: EMU_PROJECT_CLASS
		do
			-- try go get project from server
			project := system.get_project(msg.project_name)
			if project = Void then
				-- project does not exist
				-- send error message to client
				send_msg (create {CLIENT_ERROR}.make_unlock_not_successful (msg.project_name, msg.emu_class_name))
			else	
					-- search the right class
				from
					project.clusters.start
					found:= False
				until
					project.clusters.after or found=True
				loop
					if project.clusters.item.has_class (msg.emu_class_name) then
						-- do unlock of class
						unlocked_class:= project.clusters.item.get_class (msg.emu_class_name)
						found:= True
						if unlocked_class.is_free then
							unlocked_class.set_to_occupied (username)
						else
							send_msg (create {CLIENT_ERROR}.make_class_already_unlocked (msg.project_name, msg.emu_class_name))
							-- error, class is not free
						end		
					end
					project.clusters.forth
				end
				if found = False then
					send_msg (create {CLIENT_ERROR}.make_class_not_found (msg.project_name, msg.emu_class_name))
					-- error, class doesn't exist
				end
			end
		end

	process_client_upload (msg: CLIENT_CLASS_UPLOAD) is
			-- include uploaded class into class-/clusterlist
		local
			project: EMU_PROJECT
		do
			-- try go get project from server
			project := system.get_project(msg.project_name)
			if project = Void then
				-- project does not exist
				-- send error message to client
				-- adapt error message! :
				-- send_msg (create {PROJECT_ERROR}.make_project_not_found(msg.project_name))
			else
				-- do upload
				-- TO BE IMPLEMENTED
			end
		end


feature -- Commands

	send_msg(emu_message: EMU_MESSAGE) is
			-- send a message to the client

		require
			emu_message_not_void: emu_message /= Void
		do
			socket.independent_store (emu_message)
		end

	get_msg: EMU_MESSAGE is
			-- get a recieved message
			-- returns void if the messgae is not of type EMU_MESSAGE
			-- causes an exception if there is no message to retrieve
			-- the caller has to handle this exception

		do
			Result ?= socket.retrieved
		end
		
feature {NONE} -- Recursive Feature

	find_classes_of_cluster (a_cluster: EMU_PROJECT_CLUSTER) is
			-- find the classes in a cluster, put them in a linked list
			-- recursive feature
		local
			project_class: EMU_PROJECT_CLASS
			project_cluster: EMU_PROJECT_CLUSTER
		do
			from
				a_cluster.start
			until
				a_cluster.after
			loop
				project_class ?= a_cluster.item
				if project_class /= Void then
					class_list.extend (project_class)
				end
				project_cluster ?= a_cluster.item
				if project_cluster /= Void then
					find_classes_of_cluster (project_cluster)
				end
				a_cluster.forth
			end
		end
		


invariant
	system_is_set: system /= Void

end
