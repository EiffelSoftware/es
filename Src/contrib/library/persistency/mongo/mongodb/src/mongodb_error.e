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
		ensure
			message_assigned: message = a_message
		end

feature -- Access

	domain: INTEGER_32
			-- Names the subsystem that generated the error.

	code: INTEGER_32 assign set_code
			-- Domain-specific error type

	message: STRING_32
			-- Current error message
			--| Describes the error
			--| optionally with domain and code.

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
		ensure
			message_assigned: message = a_message
		end

	set_code (v: like code)
			-- Assign `code` with `v`.
		do
			code := v
		ensure
			code_assigned: code = v
		end

	set_domain (v: like domain)
			-- Assign `domain` with `v`.
		do
			domain := v
		ensure
			domain_assigned: domain = v
		end


end
