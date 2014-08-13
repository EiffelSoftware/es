note
	description: "Summary description for {AT_SHARED_HINT_TABLES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AT_SHARED_HINT_TABLES

feature -- Hint tables

	Hint_tables: AT_HINT_TABLES
		once ("PROCESS")
			create Result
		end

end
