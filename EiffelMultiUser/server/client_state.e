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
			system.output ("client connected.%N")
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

	project_user: EMU_USER
			-- if not void then client is logged into a project (retrieve project through user).

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
						system.output ("Admin '" + username + "' successfully logged in.%N")
					end
				end
			else
				admin_cmd ?= received_msg
				if admin_cmd /= Void then
					admin_cmd.execute (system)
				end
			end
			-- check for project msg
			project_msg ?= received_msg
			if project_msg /= Void then
				process_project_msg
			else
				-- check for client msg
				client_msg ?= received_msg
				if client_msg /= Void then
					process_client_msg
				end
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
				system.output ("INVALID: add user: " + msg.user_name + ". project not found!%N")
			elseif not project.is_password_correct (msg.project_password) then
				system.output ("INVALID: add user: " + msg.user_name + ". project password incorrect!%N")
				send_msg (create {PROJECT_ERROR}.make_admin_password_incorrect (msg.project_name))
			else
				-- check if the project already has a user with that name
				if project.has_user (msg.user_name) then
					-- if user already exists send an error message to the client
					system.output ("INVALID: add user: " + msg.user_name + ". user already exists!%N")
					send_msg(create {PROJECT_ERROR}.make_user_already_exists(msg.project_name))
				else
					-- create and add user to the project list and send ok message to the client
					system.output ("add user: " + msg.user_name + "%N")
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
				send_msg (create {CLIENT_ERROR}.make_no_class_list (msg.project_name))
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
			if system.has_project (msg.project_name) then
				-- if project already exists send an error message to the client
				system.output ("INVALID: create project: " + msg.project_name + ". project already exists!%N")
				send_msg (create {PROJECT_ERROR}.make_project_already_exists(msg.project_name))
			else
				-- create project, add it to the project list and send ok message to the client
				system.project_list.extend (create {EMU_PROJECT}.make(msg.project_name, msg.project_password))
				system.output ("create project: " + msg.project_name + "%N")
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
			login_msg: USER_LOGIN

			--class_list_request: PROJECT_CLASS_LIST_REQUEST

		do
			login_msg ?= received_msg
			if login_msg /= Void then
				process_client_login (login_msg)
			end
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

	process_client_login (msg: USER_LOGIN) is
			-- authenticate user login.
		require
			msg_not_void: msg /= Void
		local
			project: EMU_PROJECT
			a_user: EMU_USER
		do
			--try to get project
			project := system.get_project (msg.project_name)
			if project = Void then
				-- project does not exist.
				system.output ("INVALID: client login: " + msg.username + ". project does not exist!%N")
				send_msg (create {CLIENT_ERROR}.make (msg.project_name, {CLIENT_ERROR}.general_error, "Project does not exist!%N"))
			else
				-- check if project has this user
				if not project.has_user (msg.username) then
					-- project does not have a user with that name.
					system.output ("INVALID: client login: " + msg.username + ". user not associated with project: " + msg.project_name + "!%N")
					send_msg (create {CLIENT_ERROR}.make (msg.project_name, {CLIENT_ERROR}.general_error, "Unknown username for that project."))
				else
					-- user is known, test password.
					a_user := project.get_user (msg.username)
					if a_user.is_password_correct (msg.password) then
						-- client successfully logged in.
						project_user := a_user
						username := msg.username
						system.output ("client login: " + msg.username + ". user associated with project: " + msg.project_name + ".%N")
						send_msg (create {CLIENT_OK}.make_login_granted (msg.project_name))
					else
						-- wrong password
						system.output ("INVALID: client login: " + msg.username + ". invalid password!%N")
						send_msg (create {CLIENT_ERROR}.make (msg.project_name, {CLIENT_ERROR}.general_error, "Invalid password."))
					end
				end
			end
		end

	process_client_download (msg: CLIENT_CLASS_DOWNLOAD) is
			-- respond to download request.
		local
			project: EMU_PROJECT
			a_class: EMU_PROJECT_CLASS
		do
			-- check if client is logged in as a user.
			if project_user = Void then
				-- client is not logged in as a user of a project.
				-- send error message to client
				system.output ("INVALID: client download: " + msg.emu_class_name + ". user not associated with project: " + msg.project_name + "!%N")
				send_msg (create {CLIENT_ERROR}.make_general_error ("empty"))
			else
				-- start download
				a_class := project_user.project.get_class (msg.emu_class_name)
				if a_class = Void then
					-- class does not exist.
					system.output ("INVALID: client download: " + msg.emu_class_name + ". class does not exist!%N")
					send_msg (create {CLIENT_ERROR}.make_class_not_found (project_user.project.name, msg.emu_class_name))
				else
					-- class found, send message with class content.
					system.output ("client download: " + msg.emu_class_name + " by user: " + username + "%N")
					send_msg (create {GET_DOWNLOAD}.make (project_user.project.name, a_class.get_cluster_path, msg.emu_class_name, a_class.content))
				end
			end
		end

	process_client_lock_request (msg: CLIENT_CLASS_LOCK_REQUEST) is
			-- lock requested class for user, ie. the class is
			-- free again for other users!
		local
			a_class: EMU_PROJECT_CLASS
		do
			-- check if client is logged in as a user to a project.
			if project_user = Void then
				-- client is not logged in as a user of a project.
				-- send error message to client
				system.output ("INVALID: client lock request: " + msg.emu_class_name + ". user not associated with project: " + msg.project_name + "!%N")
				send_msg (create {CLIENT_ERROR}.make_general_error ("empty"))
			else
				-- search the right class
				a_class := project_user.project.get_class (msg.emu_class_name)
				if a_class = Void then
					-- class does not exist.
					system.output ("INVALID: client lock request: " + msg.emu_class_name + ". class does not exist in project: " + msg.project_name + "!%N")
					send_msg (create {CLIENT_ERROR}.make_class_not_found (msg.project_name, msg.emu_class_name))
				else
					-- check if class is unlocked by current user
					if a_class.is_free then
						-- class not unlocked.
						system.output ("INVALID: client lock request: " + msg.emu_class_name + ". class not unlocked!%N")
						send_msg (create {CLIENT_ERROR}.make_lock_not_successful (msg.project_name, msg.emu_class_name))
					elseif a_class.current_user /= project_user then
						-- class unlocked by different user
						io.put_string ("INVALID: client lock request: " + msg.emu_class_name + ". class has been unlocked by other user: " + a_class.current_user.name + "!%N")
						send_msg (create {CLIENT_ERROR}.make_class_already_unlocked (msg.project_name, msg.emu_class_name))
					else
						-- class may be locked for current user.
						system.output ("client lock request: " + msg.emu_class_name + ". locked/freed by user: " + project_user.name + "!%N")
						a_class.set_to_free
						send_msg (create {CLIENT_OK}.make_class_locked (msg.project_name, msg.emu_class_name))
					end
				end
			end
		end

	process_client_unlock_request (msg: CLIENT_CLASS_UNLOCK_REQUEST) is
			-- unlock requested class for user, ie. the class is
			-- not editable for other users!
		local
			a_class: EMU_PROJECT_CLASS
		do
			-- check if client is logged in as a user to a project.
			if project_user = Void then
				-- client is not logged in as a user of a project.
				-- send error message to client
				system.output ("INVALID: client unlock request: " + msg.emu_class_name + ". user not associated with project: " + msg.project_name + "!%N")
				send_msg (create {CLIENT_ERROR}.make_general_error ("empty"))
			else
				-- search the right class
				a_class := project_user.project.get_class (msg.emu_class_name)
				if a_class = Void then
					-- class does not exist.
					system.output ("INVALID: client unlock request: " + msg.emu_class_name + ". class does not exist in project: " + msg.project_name + "!%N")
					send_msg (create {CLIENT_ERROR}.make_class_not_found (msg.project_name, msg.emu_class_name))
				else
					-- check if class is free
					if not a_class.is_free then
						-- class may not be unlocked
						system.output ("INVALID: client unlock request: " + msg.emu_class_name + ". class already unlocked by user: " + a_class.current_user.name + "!%N")
						send_msg (create {CLIENT_ERROR}.make_class_already_unlocked (msg.project_name, msg.emu_class_name))
					else
						-- class may be unlocked for current user.
						system.output ("client unlock request: " + msg.emu_class_name + ". unlocked by user: " + project_user.name + "!%N")
						a_class.set_to_occupied (project_user)
						send_msg (create {CLIENT_OK}.make_class_unlocked (msg.project_name, msg.emu_class_name))
					end
				end
			end
		end

	process_client_upload (msg: CLIENT_CLASS_UPLOAD) is
			-- include uploaded class into class-/clusterlist
		local
			project: EMU_PROJECT
			a_cluster: EMU_PROJECT_CLUSTER
			a_class: EMU_PROJECT_CLASS
		do
			-- check if client is logged in as a user to a project.
			if project_user = Void then
				-- client is not logged in as a user of a project.
				-- send error message to client
				system.output ("INVALID: client upload: " + msg.emu_class_name + ". user not associated with project: " + msg.project_name + "!%N")
				send_msg (create {CLIENT_ERROR}.make_general_error ("empty"))
			else
				project := project_user.project
				-- do upload
				a_cluster := project.get_cluster (msg.cluster_path)
				if a_cluster = Void then
					-- invalid cluster, create.
					project.add_cluster (msg.cluster_path, project_user)
					a_cluster := project.get_cluster (msg.cluster_path)
					system.output ("client upload: " + msg.emu_class_name + ". cluster created: " + msg.cluster_path + "%N")
				end
				if a_cluster.has_class (msg.emu_class_name) then
					-- class already exists, check lock status.
					a_class := a_cluster.get_class (msg.emu_class_name)
					if a_class.current_user = project_user then
						-- user has unlocked class for him and may update it.
						system.output ("client upload: " + msg.emu_class_name + ". cluster: " + msg.cluster_path + ". project: " + msg.project_name + "%N")
						a_class := a_cluster.get_class (msg.emu_class_name)
						a_class.set_content (msg.content)
						system.output ("class content: %N" + a_class.content)
						send_msg (create {CLIENT_OK}.make_class_uploaded (msg.project_name, msg.emu_class_name))
					else
						-- user may not update this class.
						system.output ("INVALID: client upload: " + msg.emu_class_name + ". user " + username + " may not update this class!%N")
						send_msg (create {CLIENT_ERROR}.make_general_error (project.name))
					end
				else
					-- class does not exist, create.
					system.output ("client upload: " + msg.emu_class_name + ". create class in cluster: " +  msg.cluster_path + "%N")
					create a_class.make_with_content (msg.emu_class_name, msg.content, project_user.project, project_user)
					a_cluster.add_class (a_class)
					system.output ("class content: %N" + a_class.content)
					send_msg (create {CLIENT_OK}.make_class_uploaded (msg.project_name, msg.emu_class_name))
				end
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
