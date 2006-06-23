indexing
	description: "This class is inherit by all the application"
	author: "Bernhard S. Buss"
	date: "$Date$"
	revision: "$Revision$"

class
	WIZARD_PROJECT_SHARED

feature -- Shared variables

	server_host: STRING
			-- the hostname of the server.
			
	server_port: INTEGER
			-- the remote port of the server.
	
	project_name: STRING
			-- the name of the project.
	
	project_password: STRING
			-- the password of the project.

	user_name: STRING
			-- the name of the user to create.
	
	user_pass: STRING
			-- the password of the user to create.
			
	
feature -- Set Variables

	set_server_host (a_host: STRING) is
			-- set the hostname of the emu server.
		require
			a_host_valid: a_host /= Void and then not a_host.is_empty
		do
			server_host := a_host
		ensure
			server_host_set: server_host.is_equal(a_host)
		end

	set_server_port (a_port: INTEGER) is
			-- set the hostname of the emu server.
		require
			a_port_is_valid: a_port >= 0 and then a_port <= 65535
		do
			server_port := a_port
		ensure
			server_port_set: server_port = a_port
		end
		
	set_project_name (a_name: STRING) is
			-- set the name of the project.
		require
			a_name_valid: a_name /= Void and then not a_name.is_empty
		do
			project_name := a_name
		ensure
			project_name_set: project_name.is_equal(a_name)
		end

	set_project_password (a_pass: STRING) is
			-- set the password of the project.
		require
			a_pass_valid: a_pass /= Void and then not a_pass.is_empty
		do
			project_password := a_pass
		ensure
			project_pass_set: project_password.is_equal(a_pass)
		end

	set_user_name (a_name: STRING) is
			-- set the name of the user to be created.
		require
			a_name_valid: a_name /= Void and then not a_name.is_empty
		do
			user_name := a_name
		ensure
			user_name_set: user_name.is_equal(a_name)
		end

	set_user_pass (a_pass: STRING) is
			-- set the password of the project to be created.
		require
			a_pass_valid: a_pass /= Void and then not a_pass.is_empty
		do
			user_pass := a_pass
		ensure
			user_pass_set: user_pass.is_equal(a_pass)
		end

feature -- Set defaults

	set_default_port is
			-- set the default port of the server.
		do
			server_port := 51022
		end
		

end -- class PROJECT_WIZARD_SHARED
