note
	description: "Summary description for {MONGODB_WRAPPER_BASE}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	MONGODB_WRAPPER_BASE

inherit
	DISPOSABLE

	MEMORY_STRUCTURE

feature -- Status report

	last_error: detachable MONGODB_ERROR
			-- last error.		

	error_occurred: BOOLEAN
		do
			Result := last_error /= Void
		end

	last_call_succeed: BOOLEAN
		do
			Result := last_error = Void
		end

	last_call_message: STRING_32
			-- Return the last call message, succeed or error message.
		do
			if last_call_succeed then
				Result := {STRING_32}"Succeed"
			else
				if attached {MONGODB_ERROR} last_error as le then
					Result := {STRING_32}"Error: " + le.message
				else
					Result := {STRING_32}"Error: Unknown"
				end
			end
		end

feature -- Status change

	set_last_error (a_message: STRING_32)
			-- Set the last error message with `a_message'
		do
			create last_error.make (a_message)
		end

	set_last_error_with_bson (a_error: BSON_ERROR)
			-- Set the last error message with a_error
		local
			l_message: STRING_32
		do
			l_message := {STRING_32}"[Code:" + a_error.code.out + "]" + {STRING_32}" [Domain:"+ a_error.domain.out + "]" + {STRING_32}" [Message:" + a_error.message + "]"
			set_last_error (l_message)
			if attached last_error as le then
				le.set_code (a_error.code)
				le.set_domain (a_error.domain)
			end
		end

feature -- Cleanup	

	clean_up
			-- Clean up the last error.
		do
			last_error := Void
		end

end
