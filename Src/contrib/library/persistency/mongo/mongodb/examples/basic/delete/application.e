note
	description: "Tutorial: delete: delete document from a collection"

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
			collection: MONGODB_COLLECTION
			query: BSON
			l_reply: BSON
			driver: MONGODB_DRIVER
		do
				-- Initialize the C driver
			create driver
			driver.use

				-- Initialize client and collection
			create client.make ("mongodb://localhost:27017")
			collection := client.collection ("test", "test")

				-- Create query to find document to delete
			create query.make
			query.bson_append_utf8 ("name", "Test Document")

				-- Delete document
			create l_reply.make
			collection.delete_one (query, Void, l_reply)
			if collection.last_call_succeed then
				print ("Document deleted successfully%N" + l_reply.bson_as_canonical_extended_json)
			else
				print ({STRING_32}"Error: " + if attached {MONGODB_ERROR} client.last_error as le then le.message else {STRING_32}"Unknown" end + "%N")
			end
		end
end

