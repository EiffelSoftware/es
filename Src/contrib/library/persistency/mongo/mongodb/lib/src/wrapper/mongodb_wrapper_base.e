note
	description: "Summary description for {MONGODB_WRAPPER_BASE}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	MONGODB_WRAPPER_BASE

inherit

	DISPOSABLE

	MEMORY_STRUCTURE


feature -- Error

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

	set_last_error (a_message: STRING_32)
			-- Set the last error message with `a_message'
		local
			l_error: MONGODB_ERROR
		do
			create l_error.make (a_message)
			last_error := l_error
		end

	set_last_error_with_bson (a_error: BSON_ERROR)
			-- Set the last error message with a_error
		local
			l_message: STRING_32
		do
			l_message := {STRING_32}"[Code:" + a_error.code.out + "]" + {STRING_32}" [Domain:"+ a_error.domain.out + "]" + {STRING_32}" [Message:" + a_error.message + "]"
			set_last_error (l_message)
		end

	clean_up
			-- Clean up the last error.
		do
			last_error := Void
		end

end
