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
			error: BSON_ERROR
			oid: BSON_OID
			l_reply: BSON
		do
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
			if not collection.has_error then
				print ("Document inserted successfully%N" + l_reply.bson_as_canonical_extended_json)

					-- Prepare update operation
				create subdoc.make
				subdoc.bson_append_utf8 ("name", "Updated Document")
				subdoc.bson_append_boolean ("updated", True)

				create update.make
				update.bson_append_document ("$set", subdoc)

					-- Update document
				collection.update_one (query, update, Void, l_reply)
				if not collection.has_error then
					print ("%NDocument updated successfully%N" + l_reply.bson_as_canonical_extended_json)
				else
					print ("Update error: " + collection.error_string + "%N")
				end
			else
				print ("Insert error: " + collection.error_string + "%N")
			end
		end

end
