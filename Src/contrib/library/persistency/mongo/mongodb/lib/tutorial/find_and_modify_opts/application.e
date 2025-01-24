note
    description: "Example: MongoDB Find and Modify Options"
    date: "$Date$"
    revision: "$Revision$"
    EIS: "name=find_and_modify_opts_example", "src=https://mongoc.org/libmongoc/current/mongoc_find_and_modify_opts_t.html#example", "protocol=uri"

class
    APPLICATION

create
    make

feature {NONE} -- Initialization

    make
        local
            client: MONGODB_CLIENT
            database: MONGODB_DATABASE
            collection: MONGODB_COLLECTION
            uri: MONGODB_URI
            validator: BSON
        do
            -- Initialize MongoDB client with URI
            create uri.make ("mongodb://localhost:27017/admin?appname=find-and-modify-opts-example")
            create client.make_from_uri (uri)
            client.set_error_api (2)

            	-- Get database
            database := client.database ("databaseName")

           		-- Create collection with validation rules
            create validator.make_from_json (
            "[
                {
                    "validator": {
                        "age": {
                            "$lte": 34
                        }
                    },
                    "validationAction": "error",
                    "validationLevel": "moderate"
                }
            ]"
			)

            collection := database.create_collection ("collectionName", validator)

            if attached collection then
                	-- Demonstrate various find and modify operations
                fam_flags (collection)
                fam_bypass (collection)
                fam_update (collection)
                fam_fields (collection)
                --fam_opts (collection) TODO double check
                -- Got error: "[Code:40415] [Domain:17] [Message:BSON field 'findAndModify.futureOption' is an unknown field.]"
                fam_sort (collection)

                	-- Cleanup
                collection.drop
            end
        end

feature {NONE} -- Implementation

    fam_flags (collection: MONGODB_COLLECTION)
            -- Using flags with find_and_modify
        local
            opts: MONGODB_FIND_AND_MODIFY_OPTS
            flags: MONGODB_FIND_AND_MODIFY_FLAGS
            query, update: BSON
            reply: BSON
            goals: INTEGER
        do
        	goals := ((16 + 35 + 23 + 57 + 16 + 14 + 28 + 84) + (1 + 6 + 62)) -- 342
            	-- Create query to find Zlatan Ibrahimovic
            create query.make_from_json (
            	"[
            	{
                	"firstname": "Zlatan",
                	"lastname": "Ibrahimovic",
                	"profession": "Football player",
                	"age": 34,
                	"goals": 342
            	}
				]"
			)

            	-- Create update document to set position
            create update.make_from_json (
            	"[
            		{
            			"$set": {"position": "striker"}
            		}
            	]"
            	)

            	-- Set up find_and_modify options
            create opts.make
            opts.set_update (update)

            	-- Create flags to upsert and return new document
            create flags.make
            flags.mark_upsert
            flags.mark_return_new
            opts.set_flags (flags)

            	-- Perform find_and_modify operation
            create reply.make
            collection.find_and_modify_with_opts (query, opts, reply)

            if collection.last_call_succeed then
                print ("Find and modify with flags result: " + reply.bson_as_canonical_extended_json + "%N")
            else
            	print ({STRING_32}"Error: " + if attached {MONGODB_ERROR} collection.last_error as le then le.message else {STRING_32}"Unknown" end + "%N")
            end
        end

    fam_bypass (collection: MONGODB_COLLECTION)
            -- Bypassing document validation
        local
            opts: MONGODB_FIND_AND_MODIFY_OPTS
            query, update: BSON
            reply: BSON
        do
            	-- Create query to find Zlatan Ibrahimovic
            create query.make_from_json (
            	"[
            		{
                	"firstname": "Zlatan",
                	"lastname": "Ibrahimovic",
                	"profession": "Football player"
            		}
            	]"
			)

            	-- Create update document to increment age
            create update.make_from_json (
            	"[
            		{
            			"$inc": {"age": 1}
            		}
            	]"
			)

            	-- Set up find_and_modify options
            create opts.make
            opts.set_update (update)
            	-- He can still play, even though he is pretty old
            opts.set_bypass_document_validation (True)

            	-- Perform find_and_modify operation
            create reply.make
            collection.find_and_modify_with_opts (query, opts, reply)

            if collection.last_call_succeed then
                print ("Find and modify with bypass validation result: " + reply.bson_as_canonical_extended_json + "%N")
            else
                print ({STRING_32}"Error: " + if attached {MONGODB_ERROR} collection.last_error as le then le.message else {STRING_32}"Unknown" end + "%N")
            end

        end

    fam_update (collection: MONGODB_COLLECTION)
            -- Update operation
        local
            opts: MONGODB_FIND_AND_MODIFY_OPTS
            query, update: BSON
            reply: BSON
        do
            	-- Create query to find Zlatan Ibrahimovic
            create query.make_from_json (
            	"[
            		{
                	"firstname": "Zlatan",
                	"lastname": "Ibrahimovic"
            		}
            	]"
            )

            	-- Create update document to set author flag
            create update.make_from_json (
            	"[
            		{"$set": {"author": true}}
            	]"
            )

            	-- Set up find_and_modify options
            create opts.make
            -- Note: By default, the document returned is the _previous_ version
            -- To fetch the modified new version, use flags:
            -- flags.mark_return_new
            -- opts.set_flags (flags)
            opts.set_update (update)

            	-- Perform find_and_modify operation
            create reply.make
            collection.find_and_modify_with_opts (query, opts, reply)

            if collection.last_call_succeed then
                print ("Find and modify update result: " + reply.bson_as_canonical_extended_json + "%N")
            else
                print ({STRING_32}"Error: " + if attached {MONGODB_ERROR} collection.last_error as le then le.message else {STRING_32}"Unknown" end + "%N")
            end
        end

    fam_fields (collection: MONGODB_COLLECTION)
            -- Field selection
        local
            opts: MONGODB_FIND_AND_MODIFY_OPTS
            query, update, fields: BSON
            flags: MONGODB_FIND_AND_MODIFY_FLAGS
            reply: BSON
        do
            	-- Create query to find Zlatan Ibrahimovic
            create query.make_from_json (
            	"[
            	 {
                  "lastname": "Ibrahimovic",
                  "firstname": "Zlatan"
            	 }
            	]"
            )

            	-- Specify fields to return (only goals)
            create fields.make_from_json (
            	"[
            		{"goals": 1}
            	]"
            	)

            	-- Create update document to increment goals
            create update.make_from_json (
            	"[
            		{
            			"$inc": {"goals": 1}
            		}
            	]"
            )

            	-- Set up find_and_modify options
            create opts.make
            opts.set_update (update)
            opts.set_fields (fields)

            	-- Set flag to return new document
            create flags.make
            flags.mark_return_new
            opts.set_flags (flags)

            	-- Perform find_and_modify operation
            create reply.make
            collection.find_and_modify_with_opts (query, opts, reply)

            if collection.last_call_succeed then
                print ("Find and modify with field selection result: " + reply.bson_as_canonical_extended_json + "%N")
            else
                print ({STRING_32}"Error: " + if attached {MONGODB_ERROR} collection.last_error as le then le.message else {STRING_32}"Unknown" end + "%N")
            end
        end

    fam_opts (collection: MONGODB_COLLECTION)
            -- Additional options
        local
            opts: MONGODB_FIND_AND_MODIFY_OPTS
            query, update, extra: BSON
            reply: BSON
        do
            	-- Create query to find Zlatan Ibrahimovic
            create query.make_from_json (
            	"[
	            	 {
	        	        "firstname": "Zlatan",
	            	    "lastname": "Ibrahimovic",
	                	"profession": "Football player"
	   		         }
				]"
			)

            	-- Create update document to increment age
            create update.make_from_json (
            	"[
            		{
            			"$inc": {"age": 1}
            		}

            	 ]"
            	)

            	-- Set up find_and_modify options
            create opts.make
            opts.set_update (update)

            	-- Set maximum execution time to 100ms
            opts.set_max_time_ms (100)

           		 -- Create extra options with write concern and future option
            create extra.make_from_json (
            	"[
            		{
                 	"writeConcern": {"w": 2},
                 	"futureOption": 42
   		        	}
				]"
				)
            opts.append (extra)

            	-- Perform find_and_modify operation
            create reply.make
            collection.find_and_modify_with_opts (query, opts, reply)

            if collection.last_call_succeed then
                print ("Find and modify with extra options result: " + reply.bson_as_canonical_extended_json + "%N")
            else
            	print ({STRING_32}"Error: " + if attached {MONGODB_ERROR} collection.last_error as le then le.message else {STRING_32}"Unknown" end + "%N")
            end

        end

    fam_sort (collection: MONGODB_COLLECTION)
            -- Sorting with find_and_modify
        local
            opts: MONGODB_FIND_AND_MODIFY_OPTS
            query, update, sort: BSON
            reply: BSON
        do
            	-- Create query to find users with lastname "Ibrahimovic"
            create query.make_from_json (
            	"[
            		{"lastname": "Ibrahimovic"}
            	]"
			)

            	-- Create sort document (sort by age descending)
            create sort.make_from_json (
            	"[
            		{"age": -1}
            	]"
            )

            	-- Create update document to set 'oldest' flag
            create update.make_from_json (
            	"[
            		{"$set": {"oldest": true}}
            	]"
            )

            	-- Set up find_and_modify options
            create opts.make
            opts.set_update (update)
            opts.set_sort (sort)

				-- Create replu
			create reply.make

            	-- Perform find_and_modify operation
            collection.find_and_modify_with_opts (query, opts, reply)

            if collection.error_occurred then
				print ({STRING_32}"Error: " + if attached {MONGODB_ERROR} collection.last_error as le then le.message else {STRING_32}"Unknown" end + "%N")
            else
                print ("Find and modify with sort result: " + reply.bson_as_canonical_extended_json + "%N")
            end

        end

end
