indexing
	description: "Message for user to ask the server to lock a unlocked class"
	author: "Ramon Schwammberger, Andrea Zimmermann, Domenic Schroeder"
	date: "$Date$"
	revision: "$Revision$"

class
	CLIENT_CLASS_LOCK_REQUEST

	
inherit 
	EMU_CLIENT_MESSAGE

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


