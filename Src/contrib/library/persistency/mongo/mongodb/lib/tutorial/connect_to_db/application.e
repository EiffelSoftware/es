note
	description: "Example: Connect to a MongoDB Database"
	date: "$Date$"
	revision: "$Revision$"
	eis: "name=Connec to DB", "src=https://www.mongodb.com/docs/languages/c/c-driver/current/connect/#std-label-c-connect", "protocol=uri"

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
			l_ping: BSON
			l_reply: BSON
		do
				-- Create client
			create l_client.make ("mongodb://127.0.0.1:27017")
			l_client.set_appname ("connect-example")


				-- Create BSON documents for ping
			create l_ping.make
			l_ping.bson_append_integer_32 ("ping", 1)
			create l_reply.make

				-- Verify connection with ping
			l_client.command_simple ("admin", l_ping, Void, l_reply)

			if l_client.has_error then
				print ("Error: " + l_client.error_string + " %N")
			else
				print ("Pinged your deployment. You successfully connected to MongoDB!%N" + l_reply.bson_as_canonical_extended_json)

					-- Database operations
				l_database := l_client.database ("newDB")
				if l_database.has_collection ("newCollection") then
					print ("Collection newCollection exists%N")
				else
					print ("Collection newCollection does not exists%N")
				end
			end
		end

end
