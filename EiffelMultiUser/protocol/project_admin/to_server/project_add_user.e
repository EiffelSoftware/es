indexing
	description: "Message to add a user to an EMU project. Every user is associated with a project."
	author: "Claudia Kuster, Bernhard S. Buss"
	date: "21.May.2006"
	revision: "$Revision$"

class
	PROJECT_ADD_USER
	
inherit 
	EMU_PROJECT_MSG	

create 
	make
	
	
feature -- Initialization

	make (a_project_name, a_project_password, a_user_name, a_user_password: STRING) is
			-- set the attributes of an add user message.
		require
			a_project_name_valid: a_project_name /= void and then not a_project_name.is_empty
			a_project_password_valid: a_project_password /= void and then not a_project_password.is_empty
			a_user_name_valid: a_user_name /= void and then not a_user_name.is_empty
			a_user_password_valid: a_user_password /= void and then not a_user_password.is_empty
		do
			project_name := a_project_name
			project_password := a_project_password
			user_name := a_user_name
			user_password := a_user_password
		ensure
			project_name_set: project_name = a_project_name
			project_password_set: project_password = a_project_password
			user_name_set: user_name = a_user_name
			password_set: user_password = a_user_password
		end


feature -- Attributes
	
	user_name: STRING
	
	user_password:STRING



end
