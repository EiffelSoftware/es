note
	description: "Tutorial:  insert a document into a collection"
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
			doc: BSON
			reply: BSON
			driver: MONGODB_DRIVER
		do
				-- Initialize the C driver
			create driver
			driver.use
			create client.make ("mongodb://localhost:27017")
			collection := client.collection ("test", "test")

				-- Create document
			create doc.make
			doc.bson_append_utf8 ("name", "Test Document")
			doc.bson_append_integer_32 ("age", 42)

				-- Insert document
			create reply.make
			collection.insert_one (doc, Void, reply)
			if collection.last_call_succeed then
				print ("Document inserted successfully; %N" + reply.bson_as_canonical_extended_json)
			else
				print ({STRING_32}"Error: " + if attached {MONGODB_ERROR} collection.last_error as le then le.message else {STRING_32}"Unknown" end + "%N")
			end
		end
end

