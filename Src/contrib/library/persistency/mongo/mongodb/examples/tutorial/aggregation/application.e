note
	description: "Example: Connect to a MongoDB Database"
	date: "$Date$"
	revision: "$Revision$"
	eis: "name=Aggregation", "src=https://github.com/mongodb/mongo-c-driver/blob/master/src/libmongoc/examples/aggregation/aggregation1.c", "protocol=uri"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
		local
			client: MONGODB_CLIENT
			collection: MONGODB_COLLECTION
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
			create uri.make ("mongodb://localhost:27017/?appname=aggregation-example")
			create client.make_from_uri (uri)
			client.set_error_api (2)

				-- Get collection
			collection := client.collection ("test", "zipcodes")

						-- Insert sample data
			create doc.make_from_json ("[
				{
					"_id": "10001",
					"city": "NEW YORK",
					"state": "NY",
					"pop": 18819000,
					"loc": [-73.9967, 40.7484]
				}   
			]")
			collection.insert_one (doc, Void, Void)

			create doc.make_from_json ("[
				{
					"_id": "90001",
					"city": "LOS ANGELES",
					"state": "CA",
					"pop": 39538223,
					"loc": [-118.2437, 34.0522]
				}
			]")
			collection.insert_one (doc, Void, Void)

			create doc.make_from_json ("[
				{
					"_id": "60601",
					"city": "CHICAGO",
					"state": "IL",
					"pop": 12801539,
					"loc": [-87.6298, 41.8781]
				}
			]")
			collection.insert_one (doc, Void, Void)



				-- Create aggregation pipeline
			create pipeline.make_from_json ("[
				{
					"pipeline": [
						{
							"$group": {
								"_id": "$state",
								"total_pop": {"$sum": "$pop"}
							}
						},
						{
							"$match": {
								"total_pop": {"$gte": 10000000}
							}
						}
					]
				}
			]")

				-- Execute aggregation
			cursor := collection.aggregate (pipeline, Void, Void)

				-- Iterate results
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

