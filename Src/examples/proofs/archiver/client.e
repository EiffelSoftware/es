indexing
	description: "TODO"
	date: "$Date$"
	revision: "$Revision$"

class CLIENT

feature

	log (log_file: PROCEDURE [ANY, TUPLE [ANY]]; s: STRING)
		require
			log_file_not_void: log_file /= Void
			s_not_void: s /= Void
			log_file_valid: log_file.precondition ([s])
		do
			log_file.call ([s])
		ensure
			log_file_called: log_file.postcondition ([s])
		end

end
