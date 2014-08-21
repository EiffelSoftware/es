note
	description: "Shared hint tables."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AT_SHARED_HINT_TABLES

feature -- Hint tables

	Hint_tables: AT_HINT_TABLES
			-- Shared hint tables
		once ("PROCESS")
			create Result
		end

end
