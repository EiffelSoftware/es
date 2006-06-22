indexing
	description: "Message that contains the class list of an EMU Project"
	author: "Claudia Kuster"
	date: "21.May.2006"
	revision: "$Revision$"

class
	PROJECT_CLASS_LIST

inherit 
	EMU_PROJECT_MSG

create
	make
	
feature -- Initialization
	make(a_project_name: STRING; a_class_list: LINKED_LIST[STRING]) is
			-- attach user list to the message
			
		require
			a_project_name_not_void: a_project_name /= void
			a_class_list_not_void: a_class_list /= void
			
		do
			project_name := a_project_name
			class_list := a_class_list
		
		ensure
			project_name_set: a_project_name = project_name
			class_list_set: a_class_list = class_list
		end
		
feature -- Attributes

	class_list: LINKED_LIST[STRING]
	
end
