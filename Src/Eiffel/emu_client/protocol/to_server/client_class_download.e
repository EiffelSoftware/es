indexing
	description: "Message to trigger download of ALL classes of the specified project"
	author: "Ramon Schwammberger, Andrea Zimmermann, Domenic Schroeder"
	date: "$Date$"
	revision: "$Revision$"

class
	CLIENT_CLASS_DOWNLOAD

inherit
	EMU_CLIENT_MESSAGE

create
	make

-- * comment: it might be better to only donwload modified classes
-- *          for now ALL classes are downloaded


feature -- Initialization

	make (a_project_name, a_class_name:STRING) is
			-- initialize message and set attributes

			require
				a_project_name_not_void: a_project_name /= void
				a_class_name_not_void: a_class_name /= Void
				--user_password_not_void: user_password /= void
			do
				project_name := a_project_name
				emu_class_name := a_class_name
				--password := user_password

			ensure
				project_name_set : a_project_name = project_name
				emu_class_name_set : a_class_name = emu_class_name
				--password_set: user_password = password
			end

feature -- Attributes

	emu_class_name:STRING



end
