note
	description: "Example: show how to create a vector search index"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Atlas Vector Search Quick Start", "src=https://www.mongodb.com/docs/atlas/atlas-vector-search/tutorials/vector-search-quick-start/?tck=ai_as_web", "protocol=uri"
	EIS: "name=Create a Vector Search Index", "src=https://www.mongodb.com/docs/atlas/atlas-vector-search/tutorials/vector-search-quick-start/?tck=ai_as_web#create-a-vector-search-index", "protocol=uri"

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
			pipeline: BSON
			driver: MONGODB_DRIVER
			connection_string: STRING
			reply: BSON
		do
				-- Initialize driver
			create driver
			driver.use

				-- Read connection string from config file
			connection_string := read_connection_string
			if connection_string.is_empty then
				print ("Error: Unable to get valid connection string from config.json%N")
				{EXCEPTIONS}.die (1)
			end

				-- Create client and get collection from Atlas
			create client.make (connection_string)
			collection := client.collection (database_name, collection_name)

				-- Create search index command
			create cmd.make_from_json ("[
				{
					"createSearchIndexes": "embedded_movies",
					"indexes": [{
						"definition": {
							"fields": [{
								"type": "vector",
								"path": "plot_embedding",
								"numDimensions": 1536,
								"similarity": "dotProduct",
								"quantization": "scalar"
							}]
						},
						"name": "vector_index",
						"type": "vectorSearch"
					}]
				}
			]")

				-- Execute command
			create reply.make
			collection.command_simple (cmd, Void, reply)
			if collection.last_call_succeed then
				print ("New search index named " + index_name + " is building.%N")
			else
				print ({STRING_32}"Failed to run createSearchIndexes: " + if attached {MONGODB_ERROR} collection.last_error as le then le.message else {STRING_32}"Unknown" end + "%N")
				{EXCEPTIONS}.die (1)
			end

				-- Polling for index status
			print ("Polling to check if the index is ready. This may take up to a minute.%N")
			from
				create pipeline.make_from_json ("[
					{
						"pipeline": [{
							"$listSearchIndexes": {}
						}]
					}
				]")
			until
				is_index_queryable (collection, pipeline)
			loop
				{EXECUTION_ENVIRONMENT}.sleep (5_000_000_000) -- Sleep for 5 seconds
			end

			print (index_name + " is ready for querying.%N")
		end

feature {NONE} -- Implementation

	read_connection_string: STRING
			-- Read connection string from config.json file
		local
			file: PLAIN_TEXT_FILE
			json_parser: JSON_PARSER
			json_object: detachable JSON_OBJECT
		do
			create Result.make_empty
			create file.make_with_name ("config.json")

			if not file.exists then
				print ("Error: config.json file not found%N")
			else
				file.open_read
				if file.is_readable then
					file.read_stream (file.count)
					create json_parser.make_with_string (file.last_string)
					json_parser.parse_content
					if json_parser.is_valid and then attached {JSON_OBJECT} json_parser.parsed_json_object as jo then
						json_object := jo
						if attached {JSON_STRING} json_object.item ("connection_string") as cs then
							if not cs.item.is_empty then
								Result := cs.item
							else
								print ("Error: connection_string is empty in config.json%N")
							end
						else
							print ("Error: connection_string not found in config.json%N")
						end
					else
						print ("Error: Invalid JSON format in config.json%N")
					end
				else
					print ("Error: Unable to read config.json%N")
				end
				file.close
			end
		end

	is_index_queryable (collection: MONGODB_COLLECTION; pipeline: BSON): BOOLEAN
			-- Check if the index is queryable
		local
			cursor: MONGODB_CURSOR
			doc:  BSON
		do
			cursor := collection.aggregate (pipeline, Void, Void)
			from
				doc := cursor.next
			until
				Result or doc = Void
			loop
				if attached {JSON_OBJECT} doc.bson_as_canonical_extended_json_value as jo then
					if
						attached {JSON_STRING} jo.item ("name") as l_name and then
						l_name.item.same_string (index_name) and then
						attached {JSON_BOOLEAN} jo.item ("queryable") as l_queryable
					then
						Result := l_queryable.item
					end
				end
				doc := cursor.next
			end
			if not Result then
				print ("Index " + index_name + " not found yet. Retrying...%N")
			end
		end

feature {NONE} -- Constants

	database_name: STRING = "sample_mflix"
			-- Database name

	collection_name: STRING = "embedded_movies"
			-- Collection name

	index_name: STRING = "vector_index"
			-- Index name

end

