indexing
	description: "User gets this messages, when a process produced an error."
	author: "Ramon Schwammberger, Andrea Zimmermann, Domenic Schroeder"
	date: "$Date$"
	revision: "$Revision$"

class
	CLIENT_ERROR

inherit
	EMU_CLIENT_MESSAGE
	
create 
	make,
	make_general_error,
	make_no_class_list,
	make_lock_not_successful,
	make_unlock_not_successful,
	make_upload_not_successful,
	make_class_not_found
	
feature -- Initialization

	make(a_project_name: STRING; an_error_code:INTEGER; an_error_message:STRING) is
			-- initialize a customized error message
			
		require
			a_project_name_not_void: a_project_name /= void
			an_error_code_valid: an_error_code > 0
			an_error_message_not_void: an_error_message /= void
		
		do
			project_name := a_project_name
			error_code := an_error_code
			error_message := an_error_message
			
		ensure
			project_name_set : a_project_name = project_name
			error_code_set: an_error_code = error_code
			error_message_set: an_error_message = error_message
		end

	make_general_error (a_project_name: STRING) is
			-- generate a general error message.
		do
			project_name := a_project_name
			error_code := general_error
			error_message := general_error_msg
		ensure	
			project_name_set : a_project_name = project_name
			error_code_set: error_code = general_error
			error_message_set: error_message.is_equal(general_error_msg)
		end
		
		
	make_no_class_list (a_project_name: STRING) is
		-- generate an error, if no class_list is found
		do
			project_name := a_project_name
			error_code := no_class_list
			error_message := no_class_list_msg
		ensure	
			project_name_set : a_project_name = project_name
			error_code_set: error_code = no_class_list
			error_message_set: error_message.is_equal(no_class_list_msg)
		end
		
	
	
	make_lock_not_successful (a_project_name, a_class_name: STRING) is
		-- generate a lock not successful error
		do
			project_name := a_project_name
			emu_class_name := a_class_name
			error_code := lock_not_successful
			error_message := lock_not_successful_msg
		ensure	
			project_name_set : a_project_name = project_name
			emu_class_name_set : a_class_name = emu_class_name
			error_code_set: error_code = lock_not_successful
			error_message_set: error_message.is_equal(lock_not_successful_msg)
		end
	
	
	make_unlock_not_successful (a_project_name, a_class_name: STRING) is
		-- generate a unlock not successful message
		do
			project_name := a_project_name
			emu_class_name := a_class_name
			error_code := unlock_not_successful
			error_message := unlock_not_successful_msg
		ensure	
			project_name_set : a_project_name = project_name
			emu_class_name_set : a_class_name = emu_class_name
			error_code_set: error_code = unlock_not_successful
			error_message_set: error_message.is_equal(unlock_not_successful_msg)
		end
		
		
	make_upload_not_successful (a_project_name, a_class_name: STRING) is
		-- generate an upload not successful error
		do
			project_name := a_project_name
			emu_class_name := a_class_name
			error_code := upload_not_successful
			error_message := upload_not_successful_msg
		ensure	
			project_name_set : a_project_name = project_name
			emu_class_name_set : a_class_name = emu_class_name
			error_code_set: error_code = upload_not_successful
			error_message_set: error_message.is_equal(upload_not_successful_msg)
		end
	
	make_class_not_found (a_project_name: STRING) is
		-- generate a class not found error
		do
			project_name := a_project_name
			error_code := class_not_found
			error_message := class_not_found_msg
		ensure	
			project_name_set : a_project_name = project_name
			error_code_set: error_code = class_not_found
			error_message_set: error_message.is_equal(class_not_found_msg)
		end
		
	
			

feature -- Error Codes

	general_error: INTEGER is 500
			-- unspecified general error

	no_class_list: INTEGER is 501
			-- there doesn't exist a class list
	
	lock_not_successful: INTEGER is 502
			-- the locking of a class was not successful
			
	unlock_not_successful: INTEGER is 503
			-- the unlocking of a class was not successful
	
	upload_not_successful: INTEGER is 504
			-- the upload of a class was not successful
		
	class_not_found:  INTEGER is 505
			-- the wanted class does not exist
	
	
feature -- Error Messages

	general_error_msg: STRING is 
		do
			Result := "An Error occured while modifiying EMU Project " + project_name
		end

	no_class_list_msg: STRING is 
		do
			Result := "Class list for EMU Project " + project_name + " does not exist"
		end
	
	lock_not_successful_msg: STRING is	
		do
			Result := "Locking of the class " + emu_class_name + " was not successful."
		end
	
	unlock_not_successful_msg: STRING is 
		do
			Result := "Unlocking of the class " + emu_class_name + " was not successful."
		end
	
	upload_not_successful_msg :STRING is 
		do
			Result := "Uploading of the class " + emu_class_name + " was not successful."
		end
	
	class_not_found_msg: STRING is 
		do
			Result := "Class does not exist."
		end



feature -- Attributes
	
	error_code :INTEGER
	
	error_message: STRING
	
	emu_class_name: STRING

end

