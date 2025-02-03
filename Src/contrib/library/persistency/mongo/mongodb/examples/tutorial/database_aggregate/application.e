note
	description: "Example: Database Aggregation using $currentOp"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Database Aggregation", "src=https://mongoc.org/libmongoc/current/mongoc_database_aggregate.html", "protocol=uri"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
		local
			client: MONGODB_CLIENT
			database: MONGODB_DATABASE
			uri: MONGODB_URI
			pipeline: BSON
			cursor: MONGODB_CURSOR
			doc: BSON
			driver: MONGODB_DRIVER
		do
				-- Initialize driver
			create driver
			driver.use

				-- Create client
			create uri.make ("mongodb://localhost:27017/?appname=database-aggregate-example")
			create client.make_from_uri (uri)
			client.set_error_api (2)

				-- Get admin database (required for $currentOp)
			database := client.database ("admin")

				-- Create aggregation pipeline for $currentOp
				-- TODO add a new alternative
				-- to build a BSON using JSON library.

				-- Another approach is to build.
				-- the BSON using a JSON visitor
				-- and calling the BSON specific
				-- features to build.
			create pipeline.make_from_json ("[
						{
							"pipeline": [
								{
									"$currentOp": {
									}
								}
							]
						}
					]")

				-- Execute aggregation on database
			cursor := database.aggregate (pipeline, Void, Void)

				-- Iterate and print results
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

