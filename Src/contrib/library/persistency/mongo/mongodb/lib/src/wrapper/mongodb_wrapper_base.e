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

	error: detachable BSON_ERROR
			-- last error.

	has_error: BOOLEAN
			-- last_error
			-- Indicates that there was an error during the last operation
		do
			Result := attached error
		end

	error_string: STRING
			-- Output a related error message.
		require
			was_error: has_error
		do
			if attached {BSON_ERROR} error as l_error then
				Result := "[Code:" + l_error.code.out + "]" + " [Domain:"+ l_error.domain.out + "]" + " [Message:" + l_error.message.out + "]"
			else
				Result := "Unknown Error"
			end
		end

	clean_up
			-- Clean up the last error.
		do
			error := Void
		end

end
