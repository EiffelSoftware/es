note
	description: "A repository that keeps all values in main memory. Useful for testing."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_IN_MEMORY_REPOSITORY

inherit
	PS_RELATIONAL_REPOSITORY


create
	make_empty

feature {NONE} -- Initialization

	make_empty
			-- Initialization for `Current'.
		local
			in_memory_database: PS_IN_MEMORY_DATABASE
		do
			create in_memory_database.make
			make (in_memory_database)
		end

end
