note
	description: "https://www.mongodb.com/docs/languages/c/c-driver/current/indexes/#single-field-index"
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
			reply: BSON
			keys: BSON
			model: MONGODB_INDEX_MODEL
			list: LIST [MONGODB_INDEX_MODEL]
			driver: MONGODB_DRIVER
		do
				-- Initialize driver
            create driver
            driver.use

				-- Create client
			create client.make ("mongodb://localhost:27017/?appname=index-single-field-example")

				-- Get collection
			collection := client.collection ("test", "zipcodes")

			create keys.make
			keys.bson_append_integer_32 ("city", 1) -- 1 for ascending, -1 for descending

			create model.make (keys, Void) -- No special options needed
			create {ARRAYED_LIST [MONGODB_INDEX_MODEL]} list.make (1)
			list.force (model)
			create reply.make

			collection.create_indexes_with_opts (list, Void, reply)
			if collection.error_occurred then
				print ({STRING_32}"Failed to create index: " + if attached {MONGODB_ERROR} collection.last_error as le then le.message else {STRING_32}"Unknown" end + "%N")

			else
				print ("Succesfully created index %N")
				search (collection)
			end

		end


	search (collection: MONGODB_COLLECTION)
		local
    		filter: BSON
    		l_cursor: MONGODB_CURSOR
    		l_after: BOOLEAN
		do
			create filter.make
			filter.bson_append_utf8 ("city", "CHICAGO")

    		l_cursor := collection.find_with_opts (filter, Void, Void)

		    from
		    until
		        l_after
		    loop
		        if attached l_cursor.next as l_bson then
		            print (l_bson.bson_as_canonical_extended_json + "%N")
		        else
		        	l_after := True
		        end
		    end
		end
end
