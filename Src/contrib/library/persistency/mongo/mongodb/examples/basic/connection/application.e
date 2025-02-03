note
	description: "Tutorial: connects to MongoDB and pings the server"
	date: "$Date$"
	revision: "$Revision$"
class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
		local
			client: MONGODB_CLIENT
			uri: MONGODB_URI
			command, reply: BSON
			driver: MONGODB_DRIVER
		do
				-- Initialize the C driver
			create driver
			driver.use
         
				-- Initialize MongoDB client with your connection string
			create uri.make ("mongodb://localhost:27017/?appname=eiffel-example")
			create client.make_from_uri (uri)

				-- Set error API version
			client.set_error_api (2)

				-- Create ping command
			create command.make
			command.bson_append_integer_32 ("ping", 1)

				-- Execute command
			create reply.make
			client.command_simple ("admin", command, Void, reply)

			if client.last_call_succeed then
				print ("Server pinged successfully!%N")
				print ("Reply: " + reply.bson_as_canonical_extended_json_value.representation + "%N")
			else
				print ({STRING_32}"Error: " + if attached {MONGODB_ERROR} client.last_error as le then le.message else {STRING_32}"Unknown" end + "%N")
			end
		end

end

