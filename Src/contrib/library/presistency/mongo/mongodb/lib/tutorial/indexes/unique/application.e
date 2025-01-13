note
	description: "Example demonstrating how to create a unique index in MongoDB"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Unique Indexes", "src=https://www.mongodb.com/docs/manual/core/index-unique/", "protocol=uri"

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
			opts: BSON
			model: MONGODB_INDEX_MODEL
			list: ARRAYED_LIST [MONGODB_INDEX_MODEL]
			reply: BSON
		do
				-- Create client
			create client.make ("mongodb://localhost:27017/?appname=index-unique-example")

				-- Get collection
			collection := client.collection ("store", "books")

				-- Create unique index on "email" field
			create keys.make
			keys.bson_append_integer_32 ("name", 1) -- ascending

				-- Set unique option
			create opts.make
			opts.bson_append_boolean ("unique", True)

				-- Create index model with unique constraint
			create model.make (keys, opts)
			create {ARRAYED_LIST [MONGODB_INDEX_MODEL]} list.make (1)
			list.force (model)

				-- Create reply document
			create reply.make

				-- Create the index
			collection.create_indexes_with_opts (list, Void, reply)
			if collection.has_error then
				print ("Failed to create index: " + collection.error_string + "%N")
			else
				print ("Successfully created unique index on 'name' field%N")
				search (collection)
			end
		end

	search (collection: MONGODB_COLLECTION)
			-- Perform a search using the unique index
		local
			filter: BSON
			cursor: MONGODB_CURSOR
			l_after: BOOLEAN
		do
			create filter.make
			filter.bson_append_utf8 ("name", "Touch of Class")

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
