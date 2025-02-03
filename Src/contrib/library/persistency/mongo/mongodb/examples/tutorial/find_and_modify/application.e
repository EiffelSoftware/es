note
	description: "Example: Find and Modify Example"
	date: "$Date$"
	revision: "$Revision$"
	eis: "name=Find and Modify", "src=https://mongoc.org/libmongoc/current/mongoc_collection_find_and_modify.html#example", "protocol=uri"

class
	APPLICATION

create
	make

feature -- Initialization

	make
		local
			client: MONGODB_CLIENT
			collection: MONGODB_COLLECTION
			uri: MONGODB_URI
			query: BSON
			update: BSON
			subdoc: BSON
			reply: BSON
			doc : BSON
			driver: MONGODB_DRIVER
		do
				-- Initialize driver
			create driver
			driver.use

				-- Create client
			create uri.make ("mongodb://127.0.0.1:27017/?appname=find-and-modify-example")
			create client.make_from_uri (uri)

				-- Get collection
			collection := client.collection ("test", "test")


				-- First create a document with {"cmpxchg": 1}
			create doc.make
			doc.bson_append_integer_32 ("cmpxchg", 1)
			collection.insert_one (doc, Void, Void)

				-- Build query {"cmpxchg": 1}
			create query.make
			query.bson_append_integer_32 ("cmpxchg", 1)

				-- Build update {"$set": {"cmpxchg": 2}}
			create update.make
			subdoc := update.bson_append_document_begin ("$set")
			subdoc.bson_append_integer_32 ("cmpxchg", 2)
			update.bson_append_document_end (subdoc)

				-- Create reply document
			create reply.make

				-- Submit the findAndModify
			collection.find_and_modify (
				query,      -- query
				Void,       -- sort (null)
				update,     -- update
				Void,       -- fields (null)
				False,      -- remove
				False,      -- upsert
				True,       -- new
				reply       -- reply
			)

				-- Check for errors
			if collection.error_occurred then
				print ({STRING_32}"find_and_modify() failure: " + if attached {MONGODB_ERROR} collection.last_error as le then le.message else {STRING_32}"Unknown" end + "%N")
			else
				-- Print the result as JSON
				print (reply.bson_as_canonical_extended_json + "%N")
			end

		end

end

