indexing
	description: "Message to create a new EMU Project on the EMU server"
	author: "Claudia Kuster"
	date: "21.Maiy.2006"
	revision: "$Revision$"

class
	PROJECT_CREATE

inherit
	EMU_PROJECT_MSG

create
	make


feature -- Initialiation

	make (a_project_name, an_admin_password: STRING) is
			-- set the attributes of a create project message

		require
			a_project_name_not_void: a_project_name /= void
			an_admin_password_not_void: an_admin_password /= void
		do
			project_name := a_project_name
			project_password := an_admin_password
		ensure
			project_name_set: a_project_name = project_name
			project_password_set: an_admin_password = project_password
		end


end
