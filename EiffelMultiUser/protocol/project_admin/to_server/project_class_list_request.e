indexing
	description: "Message to ask the server for class list of an EMU Project"
	author: "Claudia Kuster"
	date: "21.May.2006$"
	revision: "$Revision$"

class
	PROJECT_CLASS_LIST_REQUEST

inherit 
	EMU_PROJECT_MSG
	
create
	make
	
	
feature -- Initialization 

	make (a_project_name, an_admin_password:STRING) is
			-- initialize message and set attributes
			
			require
				a_project_name_not_void: a_project_name /= void
				an_admin_password_not_void: an_admin_password /= void
			do
				project_name := a_project_name
				admin_password := an_admin_password
				
			ensure
				project_name_set : a_project_name = project_name
				admin_password_set: an_admin_password = admin_password
			end
			
feature -- Attributes

	admin_password: STRING
	

end
