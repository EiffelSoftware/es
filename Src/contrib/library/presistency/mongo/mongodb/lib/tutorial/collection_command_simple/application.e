note
    description: "Example: demonstrates how to use command_simple to ping a MongoDB collection"
    date: "$Date$"
    revision: "$Revision$"
    EIS: "name=mongoc_collection_command_simple", "src=http://mongoc.org/libmongoc/current/mongoc_collection_command_simple.html", "protocol=uri"

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
            cmd: BSON
            reply: BSON
        do
                -- Create client
            create client.make ("mongodb://localhost:27017/?appname=command-simple-example")

                -- Get collection
            collection := client.collection ("test", "users")

                -- Create ping command
            create cmd.make
            cmd.bson_append_integer_32 ("ping", 1)

                -- Create reply document
            create reply.make

                -- Execute command
            if collection.command_simple (cmd, Void, reply) then
                print ("Got reply: " + reply.bson_as_canonical_extended_json + "%N")
            else
                print ("Got error: " + collection.error_string + "%N")
            end
        end

end
