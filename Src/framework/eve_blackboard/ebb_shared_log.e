note
	description: "Summary description for {EBB_SHARED_LOGGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_SHARED_LOG

feature {NONE} -- Access

	log: EBB_LOG
			-- Shared log.
		once
			create Result
		end

end
