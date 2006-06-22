indexing
	description: "The server sends this message if a project modification was successful"
	author: "Claudia Kuster"
	date: "21.May.2006"
	revision: "$Revision$"

class
	PROJECT_OK
	
inherit 
	EMU_PROJECT_MSG
	
create
	make,
	make_general_ok,
	make_project_created,
	make_project_deleted,
	make_user_added,
	make_user_removed,
	make_class_unlocked
	
	
	
feature -- Initialization

	make (a_project_name:STRING; an_ok_code:INTEGER; an_ok_message:STRING) is
			-- create a customized ok message
			
		require
			a_project_name_not_void: a_project_name /= void
			an_ok_code_valid: an_ok_code > 0
			an_ok_message_not_void: an_ok_message /= void
		do
			project_name := a_project_name
			ok_code := an_ok_code
			ok_message := an_ok_message
		ensure
			project_name_set : a_project_name = project_name
			ok_code_set: an_ok_code = ok_code
			ok_message_set: an_ok_message = ok_message
		end
		
	make_general_ok (a_project_name: STRING) is
		-- generate a general ok message.
		do
			project_name := a_project_name
			ok_code := general_ok
			ok_message := general_ok_msg
		ensure	
			project_name_set : a_project_name = project_name
			ok_code_set: ok_code = general_ok
			ok_message_set: ok_message.is_equal(general_ok_msg)
		end
		
		
	make_project_created (a_project_name: STRING) is
		-- generate a project created message
		do
			project_name := a_project_name
			ok_code := project_created 
			ok_message := project_created_msg
		ensure	
			project_name_set : a_project_name = project_name
			ok_code_set: ok_code = project_created 
			ok_message_set: ok_message.is_equal(project_created_msg)
		end
		
		
	make_project_deleted (a_project_name: STRING) is
		-- generate a project deleted message
		do
			project_name := a_project_name
			ok_code := project_deleted
			ok_message := project_deleted_msg
		ensure	
			project_name_set : a_project_name = project_name
			ok_code_set: ok_code = project_deleted
			ok_message_set: ok_message.is_equal(project_deleted_msg)
		end
		
	make_user_added (a_project_name: STRING) is
		-- generate a user added message
		do
			project_name := a_project_name
			ok_code := user_added
			ok_message := user_added_msg
		ensure	
			project_name_set : a_project_name = project_name
			ok_code_set: ok_code = user_added
			ok_message_set: ok_message.is_equal(user_added_msg)
		end
		
		
	make_user_removed (a_project_name: STRING) is
		-- generate a user removed message
		do
			project_name := a_project_name
			ok_code := user_removed
			ok_message := user_removed_msg
		ensure	
			project_name_set : a_project_name = project_name
			ok_code_set: ok_code = user_removed
			ok_message_set: ok_message.is_equal(user_removed_msg)
		end
		
		
	make_class_unlocked (a_project_name: STRING) is
		-- generate a class unlocked message
		do
			project_name := a_project_name
			ok_code := class_unlocked
			ok_message := class_unlocked_msg
		ensure	
			project_name_set : a_project_name = project_name
			ok_code_set: ok_code = class_unlocked
			ok_message_set: ok_message.is_equal(class_unlocked_msg)
		end
		
feature -- Ok Codes

	general_ok: INTEGER is 200
			-- unspecified general ok message

	project_created: INTEGER is 201
			-- successfully create a new project
			
	project_deleted: INTEGER is 202
			-- successfully deleted a project
			
	user_added: INTEGER is 203
			-- successfully added a new user
	
	user_removed: INTEGER is 204
			-- successfully removed a user
			
	class_unlocked: INTEGER is 205
			-- successfully unlocked a locked class

feature -- Ok Messages

	general_ok_msg: STRING is 
		do
			Result := "Modifying EMU Project " + project_name + " successful."
		end
	
	project_created_msg: STRING is 
		do
			Result := "Project "+ project_name + " created."
		end
	
	project_deleted_msg: STRING is 
		do
			Result := "Project " + project_name + " deleted."
		end
	
	user_added_msg: STRING is 
		do
			Result := "User added to project " + project_name + "."
		end
	
	user_removed_msg: STRING is 
		do
			Result := "User removed from project " + project_name + "."
		end
	
	class_unlocked_msg: STRING is 
		do
			Result := "Class unlocked."
		end

	
feature -- Attributes
	
	ok_code: INTEGER
			-- holds the ok code.
	
	ok_message: STRING
			-- holds the ok message.

end
