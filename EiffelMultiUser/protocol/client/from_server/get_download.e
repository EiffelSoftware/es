indexing
	description: "implements execute to receive files from server"
	author: "Ramon Schwammberger, Andrea Zimmermann, Domenic Schroeder"
	date: "$Date$"
	revision: "$Revision$"

class
	GET_DOWNLOAD
	
inherit 
	EMU_CLIENT_MESSAGE
	
create
	make
	
feature -- Initialization

	make(a_project_name, a_cluster_name, an_emu_class_name, emu_class:STRING) is
			-- initialize message and set attributes
			-- emu_class is file of class as string
		require
			a_project_name_not_void : a_project_name /= void
			a_cluster_name_not_void: a_cluster_name /= void
			emu_class_not_void: emu_class /= Void
			an_emu_class_name_not_void: an_emu_class_name /= Void
		do
			project_name := a_project_name
			emu_class_name := an_emu_class_name
			content := emu_class
			cluster_name := a_cluster_name
		ensure
			project_name_set: a_project_name = project_name
			content_not_void: content /= void
			emu_class_name_not_void: emu_class_name /= void
			cluster_name_not_void: cluster_name /= Void
		end
		

feature -- Execution

	execute () is
			-- command that will be executed by the client upon receival of the message.
		do
			
		end
		
feature -- Access
	
	emu_class_name : STRING
	
	content: STRING 
	
	cluster_name: STRING

invariant
	invariant_clause: True -- Your invariant here

end
