note
	description: "Example of using MongoDB change streams"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Run the change stream example
		local
			uri_string: STRING
			uri: MONGODB_URI
			client: MONGODB_CLIENT
			collection: MONGODB_COLLECTION
			stream: MONGODB_CHANGE_STREAM
			empty_pipeline: BSON
			document_to_insert: BSON
			write_concern: MONGODB_WRITE_CONCERN
			options: BSON
			doc: BSON
			json: STRING
			mg_factory: MONGODB_FACTORY
			reply: BSON
			driver: MONGODB_DRIVER
        do
               -- Initialize driver
            create driver
            driver.use

				-- Setup connection URI
			uri_string := "mongodb://localhost:27017,localhost:27018,localhost:27019/db?replicaSet=rs0"
			create uri.make (uri_string)
			if uri.error_occurred then
				print ("Failed to parse URI: " + uri_string + "%N")
				print ({STRING_32}"Error: " + if attached {MONGODB_ERROR} uri.last_error as le then le.message else {STRING_32}"Unknown" end + "%N")
				{EXCEPTIONS}.die (1)
			end

				-- Create client and get collection
			create client.make_from_uri (uri)
			if client.error_occurred then
				{EXCEPTIONS}.die (1)
			end

			collection := client.collection ("db", "coll")
			create mg_factory

				-- Create empty pipeline for watch
			create empty_pipeline.make

				-- Setup watch stream
			stream := mg_factory.collection_watch (collection, empty_pipeline, Void)

				-- Setup write concern and insert document
			create write_concern.make
			write_concern.set_wmajority (10000)

			create options.make
			write_concern.append_to_bson (options)

			create document_to_insert.make
			document_to_insert.bson_append_integer_32 ("x", 1)
			collection.insert_one (document_to_insert, options, Void)

			if collection.error_occurred then
				print ({STRING_32}"Error: " + if attached {MONGODB_ERROR} collection.last_error as le then le.message else {STRING_32}"Unknown" end + "%N")
				{EXCEPTIONS}.die (1)
			end

				-- Watch for changes
			from
				create doc.make
			until
				not stream.next (doc)
			loop
				create reply.make
				if stream.error_document (reply) then
					print ("Server Error: " + reply.bson_as_relaxed_extended_json + "%N")
					{EXCEPTIONS}.die (1)
				else
					json := doc.bson_as_relaxed_extended_json
					print ("Got document: " + json + "%N")
				end
			end
		end

end
