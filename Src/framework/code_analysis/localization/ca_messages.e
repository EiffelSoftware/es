note
	description: "Summary description for {CA_MESSAGES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_MESSAGES

inherit {NONE}
	SHARED_LOCALE

feature -- Code Analyzer

	analyzing_class (a_class_name: READABLE_STRING_GENERAL): STRING_32
		do Result := locale.formatted_string (locale.translation ("Analyzing class $1 ...%N"), [a_class_name]) end

	

end
