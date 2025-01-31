note
	description: "Tutorial: find: To query documents from a collection"

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
            cursor: MONGODB_CURSOR
            doc: detachable BSON
            driver: MONGODB_DRIVER
        do
                -- Initialize the C driver
            create driver
            driver.use

                -- Initialize client and collection
            create client.make ("mongodb://localhost:27017")
            collection := client.collection ("test", "test")

            	-- Create query
            create query.make

	            -- Find all documents
            cursor := collection.find_with_opts (query, Void, Void)

    	        -- Iterate results
            from
                doc := cursor.next
            until
                doc = Void
            loop
                print (doc.bson_as_canonical_extended_json + "%N")
                doc := cursor.next
            end
        end
end
