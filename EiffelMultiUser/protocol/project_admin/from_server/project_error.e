indexing
	description: "This message is sent if something with a project admin feature went wrong"
				"The type of the error is specified by an error message and an error code"
	author: "Claudia Kuster"
	date: "21.May.2006"
	revision: "$Revision$"

class
	PROJECT_ERROR

inherit
	EMU_PROJECT_MSG

create
	make,
	make_general_error,
	make_project_not_found,
	make_project_already_exists,
	make_user_not_found,
	make_user_already_exists,
	make_admin_password_incorrect,
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

	make_project_not_found (a_project_name: STRING) is
		-- generate a project not found error
		do
			project_name := a_project_name
			error_code := project_not_found
			error_message := project_not_found_msg
		ensure
			project_name_set : a_project_name = project_name
			error_code_set: error_code = project_not_found
			error_message_set: error_message.is_equal(project_not_found_msg)
		end

	make_project_already_exists (a_project_name: STRING) is
		-- generate a project already exists error
		do
			project_name := a_project_name
			error_code := project_already_exists
			error_message := project_already_exists_msg
		ensure
			project_name_set : a_project_name = project_name
			error_code_set: error_code = project_already_exists
			error_message_set: error_message.is_equal(project_already_exists_msg)
		end

	make_user_not_found (a_project_name: STRING) is
		-- generate a user not found error
		do
			project_name := a_project_name
			error_code := user_not_found
			error_message := user_not_found_msg
		ensure
			project_name_set : a_project_name = project_name
			error_code_set: error_code = user_not_found
			error_message_set: error_message.is_equal(user_not_found_msg)
		end

	make_user_already_exists (a_project_name: STRING) is
		-- generate user already exists error
		do
			project_name := a_project_name
			error_code := user_already_exists
			error_message := user_already_exists_msg
		ensure
			project_name_set : a_project_name = project_name
			error_code_set: error_code = user_already_exists
			error_message_set: error_message.is_equal(user_already_exists_msg)
		end

	make_admin_password_incorrect (a_project_name: STRING) is
		-- generate an admin password incorrect error
		do
			project_name := a_project_name
			error_code := admin_password_incorrect
			error_message := admin_password_incorrect_msg
		ensure
			project_name_set : a_project_name = project_name
			error_code_set: error_code = admin_password_incorrect
			error_message_set: error_message.is_equal(admin_password_incorrect_msg)
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

	general_error: INTEGER is 400
			-- unspecified general error

	project_not_found: INTEGER is 401
			-- project admin wants to modify a project that does not exist on the server

	project_already_exists: INTEGER is 402
			-- project admin wants to create a project that already exists

	user_already_exists: INTEGER is 403
			-- project admin wants to create a user that already exists

	user_not_found: INTEGER is 404
			-- project admin wants to modify a user that does not exist

	admin_password_incorrect: INTEGER is 405
			-- project admin wants to modify a project with the wrong admin password

	class_not_found:  INTEGER is 406
			-- project admin wants to unlock a class that does not exist


feature -- Error Messages

	general_error_msg: STRING is
		do
			Result := "An Error occured while modifiying EMU Project " + project_name
		end

	project_not_found_msg: STRING is
		do
			Result := "EMU Project " + project_name + " does not exist"
		end

	project_already_exists_msg: STRING is
		do
			Result := "EMU Project " + project_name + " already exists"
		end

	user_already_exists_msg: STRING is
		do
			Result := "User already exists."
		end

	user_not_found_msg :STRING is
		do
			Result := "User not found"
		end

	admin_password_incorrect_msg: STRING is
		do
			Result := "Admin Password for EMU Project " + project_name + " is incorrect."
		end

	class_not_found_msg: STRING is
		do
			Result := "Class does not exist"
		end



feature -- Attributes

	error_code :INTEGER
			-- holds the error code.

	error_message: STRING
			-- holds the error message.

end
