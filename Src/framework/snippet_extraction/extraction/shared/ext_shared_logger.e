note
	description: "Summary description for {EXT_SHARED_LOGGER}."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_SHARED_LOGGER

feature -- Access

	log: ELOG_LOG_MANAGER
			-- Log manager configuration to be used across snippet extraction project.
		once
			create Result.make_with_logger_array (
				<<
					create {ELOG_CONSOLE_LOGGER}
				>>)
		end

end
