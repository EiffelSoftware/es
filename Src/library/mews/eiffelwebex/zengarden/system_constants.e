indexing
	description: "Object that defines application constants."
	author: "Peizhu Li"
	date: "$Date$"
	revision: "$0.3.1$"

class
	SYSTEM_CONSTANTS

feature -- Access

	app_working_folder: STRING is ".\"

	app_db_folder: STRING is ".\db\"
	users_file_name: STRING is "user_list.db"

	-- user roles
	ROLE_GUEST: INTEGER is 0
	ROLE_NORMAL_USER: INTEGER is 1
	ROLE_ADMINISTRATOR: INTEGER is 2


invariant
	invariant_clause: True -- Your invariant here

end
