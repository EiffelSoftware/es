indexing
	description: "Class for uploading a class"
	author: "Ramon Schwammberger, Andrea Zimmermann, Domenic Schroeder"
	date: "$Date$"
	revision: "$Revision$"

class
	CLIENT_CLASS_UPLOAD

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
			a_class_name_not_empty: not a_class_name.is_empty
			
		local
			file_name: FILE_NAME
		do
			project_name := a_project_name
			emu_class_name := a_class_name
			-- to be implemented:
			--    upload specified class!
			create file_name.make_from_string (a_class_name)
			if file_name.is_valid() then
				create file.make (file_name)
			else				
				
			end
			
		ensure
			project_name_set: a_project_name = project_name
			emu_class_name_set: a_class_name = emu_class_name
		end
		
feature -- Attributes

	emu_class_name: STRING
	
	--file_content: STRING 
	
	file: RAW_FILE
	
	number_of_characters: INTEGER
		

end
