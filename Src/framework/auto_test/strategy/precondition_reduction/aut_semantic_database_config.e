note
	description: "Database connection setup for semantic database"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_SEMANTIC_DATABASE_CONFIG

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
			host := "localhost"
			schema := "semantic_search"
			user := "root"
			password := ""
			port := 3306
		end

feature -- Access

	host: STRING
			-- Host name of the database server

	schema: STRING
			-- Schema name

	user: STRING
			-- User name

	password: STRING
			-- Password to connect to the database

	port: INTEGER
			-- Port to connect to the database

feature -- Access

	connection: MYSQL_CLIENT
			-- Connection object for data operations
		do
			create Result.make
			Result.set_host (host)
			Result.set_username (user)
			Result.set_password (password)
			Result.set_database (schema)
			Result.set_port (port)
		end

feature -- Setting

	set_host (a_host: STRING)
			-- Set `host' with `a_host'.
		do
			host := a_host.twin
		ensure
			host_set: host ~ a_host
		end

	set_schema (a_schema: STRING)
			-- Set `schema' with `a_schema'.
		do
			schema := a_schema.twin
		ensure
			schema_set: schema ~ a_schema
		end

	set_user (a_user: STRING)
			-- Set `user' with `a_user'.
		do
			user := a_user.twin
		ensure
			user_set: user ~ a_user
		end

	set_password (a_password: STRING)
			-- Set `password' with `a_password'.
		do
			password := a_password.twin
		ensure
			password_set: password ~ a_password
		end

	set_port (a_port: INTEGER)
			-- Set `port' with `a_port'.
		do
			port := a_port
		ensure
			port_set: port = a_port
		end

;note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
