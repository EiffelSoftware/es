indexing
	description: "Message to delete a project from the EMU server"
	author: "Claudia Kuster"
	date: "21.May.2006"
	revision: "$Revision$"

class
	PROJECT_DELETE

inherit
	EMU_PROJECT_MSG

create
	make

feature -- Initialization

	make (a_project_name, an_admin_password:STRING) is
			-- initialize the message to delete a project
			
		require
			project_name_not_void: a_project_name /= void
			an_admin_passowrd_not_void: an_admin_password /= void
			
		do
			project_name := a_project_name
			admin_password := an_admin_password
			
		ensure
			project_name_set : a_project_name = project_name
			
		end

		
feature -- Attributes
	
		admin_password: STRING
		

end
