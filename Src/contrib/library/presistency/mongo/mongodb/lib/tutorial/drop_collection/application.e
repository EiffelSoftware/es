note
	description: "Example:dop a collection from a MongoDB Database"
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

				-- Create a new collection.
			l_collection := l_database.create_collection ("newCollection", Void)

				-- Exists collection "newCollection"?
			if l_database.has_collection ("newCollection") then
				print ("Collection newCollection exists%N")
			else
				print ("Collection newCollection does not exists%N")
			end

				-- Drop Collection
			l_collection.drop_with_opts (Void)

				-- Exists collection "newCollection"?
			if l_database.has_collection ("newCollection") then
				print ("Collection newCollection exists%N")
			else
				print ("Collection newCollection does not exists%N")
			end
		end

end
