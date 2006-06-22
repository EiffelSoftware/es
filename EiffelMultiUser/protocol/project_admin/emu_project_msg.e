indexing
	description: "All project admin messages inherit from this class"
	author: "Claudia Kuster, Bernhard S. Buss"
	date: "21.May.2006$"
	revision: "$Revision$"

class
	EMU_PROJECT_MSG
	
inherit
	EMU_MESSAGE
	
create


feature -- Attributes
	
	project_name: STRING
			-- Each message is associated with a project

	project_password: STRING
			-- every project message needs the password of the project.


invariant
	project_name_not_void: project_name /= void
	project_name_not_empty: not project_name.is_empty
	password_valid: project_password /= Void and then not project_password.is_empty
end
