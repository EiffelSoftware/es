note
    description: "Example: demonstrates how to use count_documents with skip option"
    date: "$Date$"
    revision: "$Revision$"
    EIS: "name=count_documents", "src=https://mongoc.org/libmongoc/current/mongoc_collection_count_documents.html#example", "protocol=uri"

class
    APPLICATION

create
    make

feature {NONE} -- Initialization

    make
            -- Run application.
        local
            client: MONGODB_CLIENT
            collection: MONGODB_COLLECTION
            filter: BSON
            opts: BSON
            reply: BSON
            count: INTEGER_64
            driver: MONGODB_DRIVER
        do
               -- Initialize driver
            create driver
            driver.use
            	-- Create client
            create client.make ("mongodb://localhost:27017/?appname=count-documents-example")

          	  -- Get collection
            collection := client.collection ("test", "test")

            	-- Insert some test documents
            insert_test_documents (collection)

           	 -- Create filter (empty to match all documents)
            create filter.make

            	-- Create options with skip
            create opts.make
            opts.bson_append_integer_64 ("skip", 5)

            	-- Create reply document
            create reply.make

            	-- Count documents with skip option
            count := collection.count_documents (filter, opts, Void, reply)

            if count < 0 then
                print ({STRING_32}"Count Error: " + if attached {MONGODB_ERROR} collection.last_error as le then le.message else {STRING_32}"Unknown" end + "%N")

            else
                print (count.out + " documents counted.%N")
                print ("Full reply: " + reply.bson_as_canonical_extended_json + "%N")
            end
        end

    insert_test_documents (collection: MONGODB_COLLECTION)
            -- Insert some test documents into the collection
        local
            doc: BSON
            i: INTEGER
        do
            from
                i := 1
            until
                i > 10
            loop
                create doc.make
                doc.bson_append_integer_32 ("number", i)
                collection.insert_one (doc, Void, Void)
                i := i + 1
            end
        end

end
