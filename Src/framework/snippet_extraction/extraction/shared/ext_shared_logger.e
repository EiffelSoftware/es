note
	description: "Summary description for {EXT_SHARED_LOGGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_SHARED_LOGGER

feature -- Access

	log_path: STRING = "/var/log/snippet_extraction.log"

	log: ELOG_LOG_MANAGER
			-- Log manager configuration to be used across snippet extraction project.
		once
			create Result.make_with_logger_array (
				<<
					create {ELOG_CONSOLE_LOGGER},
					create {ELOG_FILE_LOGGER}.make_with_path (log_path)
				>>)
		end

end
