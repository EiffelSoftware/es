indexing
	description: "Parent class for all client_messages"
	author: "Ramon Schwammberger, Andrea Zimmermann, Domenic Schroeder"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EMU_CLIENT_MESSAGE

inherit
	EMU_MESSAGE


feature -- Attributes

	project_name: STRING
			-- Each message is associated with a project

	--emu_class_name: STRING		-- I don't like that here.
			-- some messages addresses classes

feature -- Set Attributes

	set_project_name (a_name: STRING) is
			-- sets project name
		require
			a_name_not_void: a_name /= void
		do
			project_name := a_name
		ensure
			name_set: project_name.is_equal(a_name)
		end



invariant
	project_name_not_void: project_name /= void
	project_name_not_empty: not project_name.is_empty
end
