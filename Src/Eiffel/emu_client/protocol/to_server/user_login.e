indexing
	description: "The message used for an normal (user) login."
	author: "Ramon Schwammberger, Andrea Zimmermann, Domenic Schroeder"
	date: "$Date$"
	revision: "$Revision$"

class
	USER_LOGIN


inherit
	EMU_CLIENT_MESSAGE

create
	make
	

feature -- Initialization

	make (a_name, a_pass, a_project: STRING) is
			-- initialize the login message and set its attributes.
		require
			a_name_valid: a_name /= Void and then not a_name.is_empty
			a_pass_valid: a_pass /= Void and then not a_pass.is_empty
			a_project_valid: a_project /= void and then not a_project.is_empty
		do
			username := a_name
			password := a_pass
			set_project_name(a_project)
		ensure
			username_set: username = a_name
			password_set: password = a_pass
		end
		


feature -- Attributes

	username: STRING
	
	password: STRING


end
