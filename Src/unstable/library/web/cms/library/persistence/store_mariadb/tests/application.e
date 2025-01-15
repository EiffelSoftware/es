note
	description : "tests application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			storage: CMS_STORAGE
			l_node: CMS_NODE
			p: PATH
			f: PLAIN_TEXT_FILE
			q: STRING_8
			nb: INTEGER
		do
			create connection.login_with_schema ("cms_dev", "foo", "bar")
--			create connection.login_with_schema ("cms_dev", "root", "")

--			(create {CLEAN_DB}).clean_db(connection)

			create {CMS_STORAGE_STORE_MARIADB} storage.make (connection)

			if storage.users_count = 0 then
				if attached {CMS_STORAGE_SQL_I} storage.as_sql_storage as sql then
					sql.reset_error
					create p.make_current
					p := p.extended ("..").extended ("..").extended ("..").extended ("..").extended ("modules").extended ("core").extended ("site").extended ("scripts").extended ("core.sql")
--					create f.make_with_path (p)
					if f /= Void and then f.exists then
						sql.reset_error
						sql.sql_execute_file_script (p, Void)
					else
						q := "[
							CREATE TABLE `users`(
							  `uid` INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
							  `name` VARCHAR(100) NOT NULL,
							  `password` VARCHAR(100) NOT NULL,
							  `salt` VARCHAR(100) NOT NULL,
							  `email` VARCHAR(250) NOT NULL,
							  `status` INTEGER,
							  `created` DATETIME NOT NULL,
							  `signed` DATETIME,
							  `profile_name` VARCHAR(250) NULL,
							  CONSTRAINT `name`
							    UNIQUE(`name`)
							);	
							
							CREATE TABLE `roles`(
							  `rid` INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
							  `name` VARCHAR(100) NOT NULL,
							  CONSTRAINT `name`
							    UNIQUE(`name`)
							);
							
							CREATE TABLE `users_roles`(
							  `uid` INTEGER NOT NULL CHECK(`uid`>=0),
							  `rid` INTEGER NOT NULL CHECK(`rid`>=0)
							);
						]"
						sql.reset_error
						sql.sql_execute_script (q, Void)
--						sql.sql_finalize_query (q)
					end
				end
			end


			storage.new_user (default_user)
			storage.new_user (custom_user ("u2", "p2", "e2"))
			nb := storage.users_count
			if attached storage.user_by_name ("u2") as l_user_2 then
				print ("User u2: " + l_user_2.out + "%N")
			end


			l_node := custom_node ("Content", "Summary", "Title")
			if attached default_user.email as l_email then
				l_node.set_author (storage.user_by_email (l_email))
			end


--			storage.new_node (l_node)
--			if attached {CMS_NODE} storage.node_by_id (1) as ll_node then
--				storage.update_node_title (2,ll_node.id, "New Title")
--				check
--					attached {CMS_NODE} storage.node_by_id (1) as u_node and then not (u_node.title ~ ll_node.title) and then u_node.content ~ ll_node.content and then u_node.summary ~ ll_node.summary
--				end
--			end
		end


feature {NONE} -- Fixture Factory: Users

	default_user: CMS_USER
		do
			Result := custom_user ("test", "password", "test@test.com")
		end

	custom_user (a_name, a_password, a_email: READABLE_STRING_32): CMS_USER
		do
			create Result.make (a_name)
			Result.set_password (a_password)
			Result.set_email (a_email)
		end

feature {NONE} -- Implementation

	connection: DATABASE_CONNECTION_MARIADB

	default_node: CMS_NODE
		do
			Result := custom_node ("Default content", "default summary", "Default")
		end

	custom_node (a_content, a_summary, a_title: READABLE_STRING_32): CMS_PAGE
		do
			create Result.make (a_title)
			Result.set_content (a_content, a_summary, Void)
		end

end
