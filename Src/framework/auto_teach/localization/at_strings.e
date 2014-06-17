note
	description: "Localized strings for AutoTeach."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

frozen class
	AT_STRINGS

inherit
	SHARED_LOCALE

feature -- General

	auto_teach: STRING_32
		do Result := locale.translation ("AutoTeach.") end

feature -- Messages

	command_line_help: STRING_32
		do Result := locale.translation ("This should be a help message.") end

	class_not_found (a_class_name: STRING): STRING_32
		do Result := locale.translation ("Could not find class " + a_class_name + ". Skipping.") end

	class_not_compiled (a_class_name: STRING): STRING_32
		do Result := locale.translation ("Class " + a_class_name + " has not been compiled. Skipping.") end

end
