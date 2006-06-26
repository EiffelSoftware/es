indexing
	description: "An EMU user is associated with an EMU project."
	author: "Bernhard S. Buss"
	date: "21.May.2006"
	revision: "$Revision$"

class
	EMU_USER

inherit
	STORABLE

	ANY
		undefine
			default_create
		end

create
	make


feature -- Initialization

	make (a_name, a_pass: STRING; a_project: EMU_PROJECT) is
			-- create and initialize an EMU user.
		require
			a_name_valid: a_name /= Void and then not a_name.is_empty
			a_pass_valid: a_pass /= Void and then not a_pass.is_empty
			a_project_valid: a_project /= Void
		do
			name := a_name
			password := a_pass
			project := a_project
			create creation_date.make_now
			create creation_time.make_now
		ensure
			name_set: name.is_equal(a_name)
			password_set: password.is_equal(a_pass)
			project_set: project = a_project
		end


feature -- Queries

	is_password_correct (a_pass: STRING): BOOLEAN is
			-- is the provided password correct?
		require
			a_pass_not_empty: a_pass /= Void and then not a_pass.is_empty
		do
			Result := password.is_equal (a_pass)
		ensure
			result_valid: Result = password.is_equal (a_pass)
		end


feature -- Attributes

	name: STRING
			-- the name of the user.

	project: EMU_PROJECT
			-- the project this user is associated with.

	creation_date: DATE
			-- date of creation (added to project)

	creation_time: TIME
			-- time of creation (added to project)


feature {NONE} -- Private Attributes

	password: STRING
			-- the password of the user.


invariant
	associated_with_project: project /= Void

end
