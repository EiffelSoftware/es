indexing
	description:	"Every EMU project is represented by an object of this type."
					"It is defined by its name and has a list of associated users."
	author: "Bernhard S. Buss, Claudia Kuster"
	date: "21.May.2006"
	revision: "$Revision$"
	discussion:		"Alternatively inherit from LINKED_LIST, but the project 'has' a list of users, and 'is' not."
	
class
	EMU_PROJECT

inherit
	STORABLE

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
			create creation_date.make_now
			create creation_time.make_now
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
		ensure
			user_removed: not has_user (username)
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


feature -- Queries

	index_of_user (username: STRING): INTEGER is
			-- returns the index of the user with name username in the userlist.
			-- if he does not exist, returns -1.
		require
			username_valid: username /= Void and then not username.is_empty
		local
			found: BOOLEAN
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
				users.after or found
			loop
				if users.item.name.is_equal(username) then
					found := True
					Result := i
				end
				i := i + 1
				users.forth
			end
		ensure
			result_valid: Result >= -1 or Result < users.count
		end
		

feature -- Attributes

	name: STRING
			-- the project name, used for identification.
			
	users: LINKED_LIST [EMU_USER]
			-- a list of users assigned to this project.
	
	clusters: LINKED_LIST [EMU_PROJECT_CLUSTER]
			-- a list of source clusters used in this project (excluding library clusters).
			-- at the top level it is not allowed to have classes, thats why we don't use EMU_PROJECT_UNIT here.
	
	creation_date: DATE
			-- date of project creation
			
	creation_time: TIME
			-- time of project creation
			

	
feature {NONE} -- Private Attributes

	password: STRING
			-- the project password, used for project administration.


invariant
	project_name_exists: name /= Void and then not name.is_empty
	user_list_exists: users /= Void

end
