note
    description: "[
        Example demonstrating how to use command options with MongoDB.
        Shows usage of:
        - Write commands with write concern
        - Read commands with collation and read concern
    ]"
    date: "$Date$"
    revision: "$Revision$"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

    make
            -- Run the example
        local
        	l_context: MONGODB_CONTEXT
            l_client: MONGODB_CLIENT
            l_uri: MONGODB_URI
            l_cmd, l_opts: BSON
            l_write_concern: MONGODB_WRITE_CONCERN
            l_read_prefs: MONGODB_READ_PREFERENCES
            l_read_concern: MONGODB_READ_CONCERN
            l_reply: BSON
            l_uri_string: STRING
            l_json: STRING
            l_read_mode: MONGODB_READ_MODE_ENUM
        do
        	create l_context
        	l_context.start
        		-- TODO review this code
            	-- Initialize default URI if none provided
            l_uri_string := "mongodb://127.0.0.1/?appname=client-example"

            	-- Create URI and client
            create l_uri.make (l_uri_string)
            if l_uri.last_call_succeed then
                create l_client.make_from_uri (l_uri)

                	-- Set error API version
                l_client.set_error_api (2)

                	-- First command: cloneCollectionAsCapped
                create l_cmd.make_from_json ("{" +
                    "%"cloneCollectionAsCapped%": %"my_collection%"," +
                    "%"toCollection%": %"my_capped_collection%"," +
                    "%"size%": " + (1024 * 1024).out + "}")

                	-- Setup write concern
                create l_write_concern.make
                l_write_concern.set_wmajority (10000) -- 10 second timeout
                create l_opts.make
                l_write_concern.append_to_bson (l_opts)

                	-- Execute write command
                create l_reply.make
                l_client.write_command_with_opts ("test", l_cmd, l_opts, l_reply)
                if l_client.error_occurred then
                    print ({STRING_32}"Error cloneCollectionAsCapped: " + l_client.last_call_message + "%N")
                else
                	l_json := l_reply.bson_as_canonical_extended_json
                    print ("cloneCollectionAsCapped: " + l_json + "%N")
            	 end

                	-- Second command: distinct with collation and read concern
                create l_cmd.make_from_json ("{" +
                    "%"distinct%": %"my_collection%"," +
                    "%"key%": %"x%"," +
                    "%"query%": { %"y%": { %"$gt%": %"one%" } }}")

               		-- Setup read preferences
               	create l_read_mode.make
               	l_read_mode.mark_read_secondary
                create l_read_prefs.make (l_read_mode)

                	-- Setup options with collation
                create l_opts.make_from_json ("{" +
                    "%"collation%": { %"locale%": %"en_US%", %"caseFirst%": %"lower%" }}")

                	-- Add read concern to options
                create l_read_concern.make
                l_read_concern.set_level ({MONGODB_EXTERNALS}.MONGOC_READ_CONCERN_LEVEL_MAJORITY)
                l_read_concern.append_to_bson (l_opts)

                	-- Execute read command
                create l_reply.make
                l_client.read_command_with_opts ("test", l_cmd, l_read_prefs, l_opts, l_reply)
                if l_client.error_occurred then
                	print ({STRING_32}"distinct error: " + l_client.last_call_message + "%N")
                else
                    l_json := l_reply.bson_as_canonical_extended_json
                    print ("distinct: " + l_json + "%N")
                end

            else
                print ({STRING_32}"Failed to parse URI: " + l_uri.last_call_message + "%N")
            end
            l_context.finish
        end

end
