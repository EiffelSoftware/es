indexing
	description: "Message that contains the user list of an EMU Project"
	author: "Claudia Kuster"
	date: "21.May.2006"
	revision: "$Revision$"

class
	PROJECT_USER_LIST
	
inherit 
	EMU_PROJECT_MSG

create
	make
	
feature -- Initialization
	make(a_project_name: STRING; a_user_list: LINKED_LIST[EMU_USER]) is
			-- attach user list to the message
			
		require
			a_project_name_not_void: a_project_name /= void
			a_user_list_not_void: a_user_list /= void
			
		do
			project_name := a_project_name
			user_list := a_user_list
		
		ensure
			project_name_set: a_project_name = project_name
			user_list_set: a_user_list = user_list
		end
		
feature -- Attributes

	user_list: LINKED_LIST[EMU_USER]

end
