note
	description: "Example:create a collection from a MongoDB Database"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_client: MONGODB_CLIENT
			l_database: MONGODB_DATABASE
			l_collection: MONGODB_COLLECTION
		do
				-- Initialize and create a new mongobd client instance.
			create l_client.make ("mongodb://127.0.0.1:27017")
			print ("Connected to the database successfully%N")

				-- Accessing a database
			l_database := l_client.database ("newDB")

				-- display the current collections
			across l_database.collection_names (Void) as ic loop print (ic.item + "%N")  end

				-- Create a new collection.
			l_collection := l_database.create_collection ("newCollection", Void)

				-- display the current collections
			across l_database.collection_names (Void) as ic loop print (ic.item + "%N")  end
		end

end
