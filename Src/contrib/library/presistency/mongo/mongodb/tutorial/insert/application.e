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
        do
            create client.make ("mongodb://localhost:27017")
            collection := client.collection ("test", "test")

                -- Create document
            create doc.make
            doc.bson_append_utf8 ("name", "Test Document")
            doc.bson_append_integer_32 ("age", 42)

                -- Insert document
            create reply.make
            collection.insert_one (doc, Void, reply)
            if not collection.has_error then
                print ("Document inserted successfully; %N" + reply.bson_as_canonical_extended_json)
            else
                print ("Error: " + collection.error_string + "%N")
            end
        end
end
