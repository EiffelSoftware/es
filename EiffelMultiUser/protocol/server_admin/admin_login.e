indexing
	description: "The message used for an admin login."
	date		: "19.May.2006"
	author		: "Bernhard S. Buss"
	revision: "$Revision$"

class
	ADMIN_LOGIN
	
inherit
	EMU_MESSAGE

create
	make
	

feature -- Initialization

	make (a_name, a_pass: STRING) is
			-- initialize the login message and set its attributes.
		require
			a_name_valid: a_name /= Void and then not a_name.is_empty
			a_pass_valid: a_pass /= Void and then not a_pass.is_empty
		do
			username := a_name
			password := a_pass
		ensure
			username_set: username = a_name
			password_set: password = a_pass
		end
		


feature -- Attributes

	username: STRING
	
	password: STRING

end
