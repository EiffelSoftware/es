indexing
	description:	"Every EMU project is represented by an object of this type."
					"It is defined by its name and has a list of associated users."
	author: "Bernhard S. Buss, Claudia Kuster"
	created: "21.May.2006"
	date: "$Date$"
	revision: "$Revision$"
	discussion:		"Alternatively inherit from LINKED_LIST, but the project 'has' a list of users, and 'is' not."

class
	EMU_PROJECT

inherit
	STORABLE
	EMU_SERVER_CONSTANTS
	ANY
		undefine
			default_create
		end


create
	make

feature {EMU_SERVER} -- creation

	make (a_name, a_pass: STRING) is
			-- create and initialize a new emu project.
		require
			a_name_valid: a_name /= Void and then not a_name.is_empty
			a_pass_valid: a_pass /= Void and then not a_pass.is_empty
		do
			name := a_name
			password := a_pass
			create users.make
			create clusters.make
			create creation_date.make_now
			create creation_time.make_now
			update_persist_storage
		ensure
			name_set: name.is_equal(a_name)
			password_set: password.is_equal(a_pass)
		end


feature {CLIENT_STATE} -- Modification

	add_user (username, pass: STRING) is
			-- create and add an user to the userlist.
		require
			username_valid: username /= Void and then not username.is_empty
			username_does_not_exist: not has_user (username)
			pass_valid: pass /= Void and then not pass.is_empty
		do
			users.extend (create {EMU_USER}.make (username, pass, Current))
			update_persist_storage
		ensure
			new_user_added: users.count = old users.count + 1
		end

	remove_user (username: STRING) is
			-- remove a user with name username from the userlist.
		require
			username_valid: username /= Void and then not username.is_empty
			username_exists: has_user (username)
		do
			-- we require user to exist in the list.
			users.go_i_th (index_of_user (username))
			users.remove
			update_persist_storage
		ensure
			user_removed: not has_user (username)
		end

	add_cluster (a_cluster_path: STRING; a_creator: EMU_USER) is
			-- create a cluster_path. does nothing if cluster exists.
		require
			a_cluster_path_valid: a_cluster_path /= Void and then not a_cluster_path.is_empty
--			cluster_not_existant: get_cluster (a_cluster_path) = Void
		local
			not_existant, head_cluster_found: BOOLEAN
			a_cluster, new_cluster: EMU_PROJECT_CLUSTER
			cluster_names: LIST[STRING]
		do
			from
				cluster_names := a_cluster_path.split ('/')
				cluster_names.start
			until
				cluster_names.after or else not_existant
			loop
				if not cluster_names.item.is_empty then
					if not head_cluster_found then
						-- first find head cluster. inside loop because we want to skip empty names.
						new_cluster := get_head_cluster (cluster_names.item)
						if new_cluster = Void then
							-- create head cluster.
							create new_cluster.make (cluster_names.item, Current, a_creator)
							clusters.extend (new_cluster)
						end
						head_cluster_found := True
					else
						-- search sub-clusters.
						new_cluster := a_cluster.get_cluster (cluster_names.item)
						if new_cluster = Void then
							create new_cluster.make (cluster_names.item, Current, a_creator)
							a_cluster.extend (new_cluster)
						end
					end
					a_cluster := new_cluster
				end
				cluster_names.forth
			end
			update_persist_storage
		end


feature -- Update

	update_persist_storage is
			-- update project file if project has changed
		local
			file: RAW_FILE
			folder: DIRECTORY
		do
			-- create folder for project
			create folder.make (project_folder_name +"/"+name)
			if not folder.exists then
				folder.create_dir
			end
			-- write this project object to a file
			-- delete old file if nessecary
			create file.make(project_folder_name +"/"+name+"/"+name+".emu")
			if file.exists then
				file.delete
			end
			file.open_write
			file.independent_store (current)
			file.close
		end


feature -- Queries

	has_user (username: STRING): BOOLEAN is
			-- has this project a specific user with name username?
		require
			username_valid: username /= Void and then not username.is_empty
		do
			Result := index_of_user(username) >= 0
		ensure
			result_valid: users.is_empty implies (Result = False)
		end

	user_count: INTEGER is
			-- returns the amount of users associated with this project.
		do
			Result := users.count
		ensure
			result_valid: (users.is_empty implies (Result = 0)) or else (Result = users.count)
		end


	index_of_user (username: STRING): INTEGER is
			-- returns the index of the user with name username in the userlist.
			-- if he does not exist, returns -1.
		require
			username_valid: username /= Void and then not username.is_empty
		local
			i: INTEGER
		do
			from
				users.start
				Result := -1
				i := 0
			invariant
				users.index < users.count
			variant
				users.count - i + 1
			until
				users.after or Result /= -1
			loop
				if users.item.name.is_equal(username) then
					Result := i
				end
				i := i + 1
				users.forth
			end
		ensure
			result_valid: Result >= -1 or Result < users.count
		end

	get_list_of_users: LINKED_LIST[EMU_USER] is
			-- return a copy of the user list.
		do
			Result.copy (users)
		end

	get_user (a_username: STRING): EMU_USER is
			-- search and return user with `a_username'. if not found return Void.
		require
			a_username_valid: a_username /= Void and then not a_username.is_empty
		do
			from
				users.start
			until
				users.after or else Result /= Void
			loop
				if users.item.name.is_equal (a_username) then
					Result := users.item
				end
				users.forth
			end
		ensure
			result_correct: Result /= Void implies users.has(Result)
		end

	get_cluster (a_cluster_path: STRING): EMU_PROJECT_CLUSTER is
			-- search cluster with the given path and retrieve it. Void if not exists.
		require
			a_cluster_path_valid: a_cluster_path /= Void and then not a_cluster_path.is_empty
		local
			cluster_names: LIST[STRING]
			a_cluster: EMU_PROJECT_CLUSTER
			head_cluster_found: BOOLEAN
			not_existant: BOOLEAN
		do
			from
				cluster_names := a_cluster_path.split ('/')
				cluster_names.start
			until
				cluster_names.after or else not_existant
			loop
				if not cluster_names.item.is_empty then
					if not head_cluster_found then
						-- first find head cluster. inside loop because we want to skip empty names.
						a_cluster := get_head_cluster (cluster_names.item)
						head_cluster_found := True
					else
						-- search sub-clusters.
						a_cluster := a_cluster.get_cluster (cluster_names.item)
					end
					not_existant := a_cluster = Void
				end
				cluster_names.forth
			end
			if not not_existant then
				Result := a_cluster
			end
		end

	get_head_cluster (a_cluster_name: STRING): EMU_PROJECT_CLUSTER is
			-- retrieve a head cluster (of the clusters list). return void if not found.
		require
			a_cluster_name_valid: a_cluster_name /= Void and then not a_cluster_name.is_empty
		do
			from
				clusters.start
			until
				Result /= Void or else clusters.after
			loop
				if clusters.item.name.is_equal (a_cluster_name) then
					Result := clusters.item
				end
				clusters.forth
			end
		ensure
			cluster_is_in_list: Result /= Void implies clusters.has (Result)
		end

	get_class (a_class_name: STRING): EMU_PROJECT_CLASS is
			-- retrieve a class by its name. returns void if not exist.
		require
			a_class_name_valid: a_class_name /= Void and then not a_class_name.is_empty
		local

		do
			-- search the right class
			from
				clusters.start
			until
				Result /= Void or else clusters.after
			loop
				Result := clusters.item.get_class_recursive (a_class_name)
				clusters.forth
			end
		end

	is_password_correct (a_pass: STRING): BOOLEAN is
			-- checks if provided password is correct.
		require
			a_pass_not_empty: a_pass /= Void and then not a_pass.is_empty
		do
			Result := password.is_equal (a_pass)
		ensure
			result_correct: a_pass.is_equal (password)
		end


feature -- Attributes

	name: STRING
			-- the project name, used for identification.


feature {CLIENT_STATE} -- Cluster list


	clusters: LINKED_LIST [EMU_PROJECT_CLUSTER]
			-- a list of source clusters used in this project (excluding library clusters).
			-- at the top level it is not allowed to have classes, thats why we don't use EMU_PROJECT_UNIT here.


feature {NONE} -- Private Attributes

	password: STRING
			-- the project password, used for project administration.

	creation_date: DATE
			-- date of project creation

	creation_time: TIME
			-- time of project creation

	users: LINKED_LIST [EMU_USER]
			-- a list of users assigned to this project.


invariant
	project_name_exists: name /= Void and then not name.is_empty
	user_list_exists: users /= Void
	cluster_list_exists: clusters /= Void
end
