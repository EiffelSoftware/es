note
	description: "Example: Show the existing list of known databases."
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Run application
			-- show the existing list of databases.
		local
			l_client: MONGODB_CLIENT
			l_database_names: LIST [STRING]
		do
				-- Initialize and create a new mongobd client instance.
			create l_client.make ("mongodb://127.0.0.1:27017")
			l_database_names := l_client.database_names (Void)
			print ("Databases%N")
			print ("=================%N")
			across
				l_database_names as ic
			loop
				print (ic.item + "%N")
			end
		end
end
