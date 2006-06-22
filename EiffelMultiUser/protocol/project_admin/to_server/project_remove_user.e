indexing
	description: "Message to remove a user to an EMU project"
	author: "Claudia Kuster"
	date: "20.May.2006"
	revision: "$Revision$"

class
	PROJECT_REMOVE_USER
	
inherit 
	EMU_PROJECT_MSG	

create
	make
	

feature -- Initialization

	make (a_project_name,an_admin_password, a_user_name:STRING) is
			-- set the attributes of a remove user message
		
		require
			a_project_name_not_void: a_project_name /= void
			an_admin_password_not_void: an_admin_password /= void
			a_user_name_not_void: a_user_name /= void

			
		do
			project_name := a_project_name
			user_name := a_user_name
			admin_password := an_admin_password
			
		ensure
			project_name_set: project_name = a_project_name
			admin_password_set: admin_password = an_admin_password
			user_name_set: user_name = a_user_name

			
		end
		
	
feature -- Attributes
	
	user_name: STRING
	
	admin_password:STRING


end
