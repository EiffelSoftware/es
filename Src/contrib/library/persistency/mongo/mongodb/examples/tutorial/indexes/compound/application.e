note
    description: "Example demonstrating how to create a compound index in MongoDB"
    date: "$Date$"
    revision: "$Revision$"
    EIS: "name=Compound Indexes", "src=https://www.mongodb.com/docs/manual/core/index-compound/", "protocol=uri"

class
    APPLICATION

create
    make

feature {NONE} -- Initialization

    make
        local
            client: MONGODB_CLIENT
            collection: MONGODB_COLLECTION
            keys: BSON
            model: MONGODB_INDEX_MODEL
            list: ARRAYED_LIST [MONGODB_INDEX_MODEL]
            reply: BSON
            driver: MONGODB_DRIVER
        do
				-- Initialize driver
            create driver
            driver.use

            	-- Create client
            create client.make ("mongodb://localhost:27017/?appname=index-compound-example")

            	-- Get collection
            collection := client.collection ("test", "zipcodes")

            	-- Create compound index on "city" (ascending) and "state" (descending)
            create keys.make
            keys.bson_append_integer_32 ("city", 1)    -- ascending
            keys.bson_append_integer_32 ("state", -1)    -- descending

	            -- Create index model
            create model.make (keys, Void)  -- No special options needed
            create {ARRAYED_LIST [MONGODB_INDEX_MODEL]} list.make (1)
            list.force (model)

        	    -- Create reply document
            create reply.make

            	-- Create the index
            collection.create_indexes_with_opts (list, Void, reply)
            if collection.error_occurred then
                print ({STRING_32}"Failed to create index: " + if attached {MONGODB_ERROR} collection.last_error as le then le.message else {STRING_32}"Unknown" end + "%N")
            else
                print ("Successfully created compound index on 'title' (asc) and 'year' (desc)%N")
                search (collection)
            end
        end

    search (collection: MONGODB_COLLECTION)
            -- Perform a search using the compound index
        local
            filter: BSON
            cursor: MONGODB_CURSOR
            l_after: BOOLEAN
        do
            create filter.make
            filter.bson_append_utf8 ("city", "CHICAGO")
            filter.bson_append_utf8 ("state", "IL")

            cursor := collection.find_with_opts (filter, Void, Void)

            from
            until
                l_after
            loop
                if attached cursor.next as doc then
                   print (doc.bson_as_canonical_extended_json + "%N")
                else
		           l_after := True
		        end
            end
        end

end
