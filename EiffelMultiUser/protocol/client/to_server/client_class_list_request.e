indexing
	description: "Message to ask for a list of classes"
	author: "Ramon Schwammberger, Andrea Zimmermann, Domenic Schroeder"
	date: "$Date$"
	revision: "$Revision$"
	
class
	CLIENT_CLASS_LIST_REQUEST

inherit 
	EMU_CLIENT_MESSAGE
	
create
	make
	
-- as long as all classes are downloaded in CLIENT_CLASS_DOWNLOAD this class is not used
	
feature -- Initialization 

	make (a_project_name, user_password:STRING) is
			-- initialize message and set attributes
			
			require
				a_project_name_not_void: a_project_name /= void
				user_password_not_void: user_password /= void
			do
				project_name := a_project_name
				password := user_password
				
			ensure
				project_name_set : a_project_name = project_name
				password_set: user_password = password
			end
			
feature -- Attributes

	password: STRING

	

end
