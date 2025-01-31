note
	description: "Tutorial: update: update existing documents"

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
			query, update, subdoc: BSON
			oid: BSON_OID
			l_reply: BSON
            driver: MONGODB_DRIVER
        do
        		-- Initialize the C driver
        	create driver
        	driver.use
				-- Initialize client and collection
			create client.make ("mongodb://localhost:27017/?appname=update-example")
			collection := client.collection ("test", "test")

				-- First create a document to update
			create oid.make (Void)
			create query.make
			query.bson_append_oid ("_id", oid)
			query.bson_append_utf8 ("name", "Original Document")

				-- Insert the document
			create l_reply.make
			collection.insert_one (query, Void, l_reply)
			if collection.last_call_succeed then
				print ("Document inserted successfully%N" + l_reply.bson_as_canonical_extended_json)

					-- Prepare update operation
				create subdoc.make
				subdoc.bson_append_utf8 ("name", "Updated Document")
				subdoc.bson_append_boolean ("updated", True)

				create update.make
				update.bson_append_document ("$set", subdoc)

					-- Update document
				collection.update_one (query, update, Void, l_reply)
				if collection.last_call_succeed then
					print ("%NDocument updated successfully%N" + l_reply.bson_as_canonical_extended_json)
				else
					print ({STRING_32}"Update Error: " + if attached {MONGODB_ERROR} collection.last_error as le then le.message else {STRING_32}"Unknown" end + "%N")
				end
			else
				print ({STRING_32}"Insert Error: " + if attached {MONGODB_ERROR} collection.last_error as le then le.message else {STRING_32}"Unknown" end + "%N")
			end
		end

end
