indexing
	description: "User gets this messages, when a process was successful."
	author: "Ramon Schwammberger, Andrea Zimmermann, Domenic Schroeder"
	date: "$Date$"
	revision: "$Revision$"

class
	CLIENT_OK

inherit
	EMU_CLIENT_MESSAGE

create
	make,
	make_general_ok,
	make_login_granted,
	make_class_locked,
	make_class_unlocked,
	make_class_uploaded,
	make_class_downloaded



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

	make_login_granted (a_project_name: STRING) is
			-- generate an login successful message.
		require
			a_project_name_valid: a_project_name /= Void and then not a_project_name.is_empty
		do
			project_name := a_project_name
			ok_code := login_granted
			ok_message := login_granted_msg
		ensure
			project_name_set: a_project_name = project_name
		end

	make_class_locked (a_project_name, a_class_name: STRING) is
		-- generate a class locked message
		do
			project_name := a_project_name
			emu_class_name := a_class_name
			ok_code := class_locked
			ok_message := class_locked_msg
		ensure
			project_name_set : a_project_name = project_name
			class_name_set : a_class_name = emu_class_name
			ok_code_set: ok_code = class_locked
			ok_message_set: ok_message.is_equal(class_locked_msg)
		end

	make_class_unlocked (a_project_name, a_class_name: STRING) is
		-- generate a class unlocked message
		do
			project_name := a_project_name
			emu_class_name := a_class_name
			ok_code := class_unlocked
			ok_message := class_unlocked_msg
		ensure
			project_name_set : a_project_name = project_name
			class_name_set : a_class_name = emu_class_name
			ok_code_set: ok_code = class_unlocked
			ok_message_set: ok_message.is_equal(class_unlocked_msg)
		end


	make_class_uploaded (a_project_name, a_class_name: STRING) is
		-- generate a class uploaded message
		do
			project_name := a_project_name
			emu_class_name := a_class_name
			ok_code := class_uploaded
			ok_message := class_uploaded_msg
		ensure
			project_name_set : a_project_name = project_name
			class_name_set : a_class_name = emu_class_name
			ok_code_set: ok_code = class_uploaded
			ok_message_set: ok_message.is_equal(class_uploaded_msg)
		end


	make_class_downloaded (a_project_name: STRING) is
		-- generate a class downloaded message
		do
			project_name := a_project_name
			ok_code := class_downloaded
			ok_message := class_downloaded_msg
		ensure
			project_name_set : a_project_name = project_name
			ok_code_set: ok_code = class_downloaded
			ok_message_set: ok_message.is_equal(class_downloaded_msg)
		end

feature -- Ok Codes

	general_ok: INTEGER is 300
			-- unspecified general ok message

	showed_class_list: INTEGER is 301
			-- successfully create a new project

	class_locked: INTEGER is 302
			-- successfully deleted a project

	class_unlocked: INTEGER is 303
			-- successfully added a new user

	class_uploaded: INTEGER is 304
			-- successfully removed a user

	class_downloaded: INTEGER is 305
			-- successfully unlocked a locked class

	login_granted: INTEGER is 306
			-- login has been granted by server.


feature -- Ok Messages

	general_ok_msg: STRING is
		do
			Result := "Modifying EMU Project " + project_name + " successful."
		end

	login_granted_msg: STRING is
		do
			Result := "Login into emu project " + project_name + " successful."
		end


	class_locked_msg: STRING is
		do
			Result := "Class " + emu_class_name + " of project " + project_name + " is locked."
		end

	class_unlocked_msg: STRING is
		do
			Result := "Class " + emu_class_name + " of project " + project_name + " is unlocked."
		end

	class_uploaded_msg: STRING is
		do
			Result := "Class " + emu_class_name + " of project " + project_name + " is uploaded."
		end

	class_downloaded_msg: STRING is
		do
			Result := "Classes are downloaded."
		end


feature -- Attributes

	ok_code :INTEGER

	ok_message: STRING

	emu_class_name: STRING




end
