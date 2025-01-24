note
	description: "Object representing an error"
	date: "$Date$"
	revision: "$Revision$"

class
	MONGODB_ERROR

create
	make

feature {NONE} -- Initialization

	make (a_message: STRING_32)
		do
			message := a_message
		end

feature -- Access

	message: STRING_32
			-- Current error message

	to_string8: STRING_8
			-- Error message represented as utf8	
		do
			Result := {UTF_CONVERTER}.string_32_to_utf_8_string_8 (message)
		end

feature -- Element Change

	set_message (a_message: STRING_32)
			-- Set message with `a_message'.
		do
			message := a_message
		end

end
