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
        do
            create client.make ("mongodb://localhost:27017")
            collection := client.collection ("test", "test")

            	-- Create query to find document to delete
            create query.make
            query.bson_append_utf8 ("name", "Test Document")

            	-- Delete document
            create l_reply.make
            collection.delete_one (query, Void, l_reply)
            if not collection.has_error then
                print ("Document deleted successfully%N" + l_reply.bson_as_canonical_extended_json)
            else
                print ("Error: " + collection.error_string+ "%N")
            end
        end
end
