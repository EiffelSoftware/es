indexing
	description: "Message for admin to ask the server to unlock a locked class"
	author: "Claudia Kuster"
	date: "21.May.2006"
	revision: "$Revision$"

class
	PROJECT_CLASS_UNLOCK_REQUEST
	
inherit 
	EMU_PROJECT_MSG

create
	make
	
feature --Initialization

	make(a_project_name, a_class_name:STRING) is
			-- initialize message and set attributes
			
		require
			a_project_name_not_void : a_project_name /= void
			a_class_name_not_void: a_class_name /= void
		do
			project_name := a_project_name
			emu_class_name := a_class_name
			
		ensure
			project_name_set: a_project_name = project_name
			emu_class_name_set: a_class_name = emu_class_name
		end
		
feature -- Attributes

	emu_class_name: STRING
		

end


