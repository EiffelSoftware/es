note
	description: "Summary description for {EXAMPLE_CLIENT}."
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=example-client", "src=https://github.com/mongodb/mongo-c-driver/blob/master/examples/example-client.c", "protocol=uri"

class
	EXAMPLE_CLIENT

create
	make

feature -- Initialization

	make
		local
			l_client: MONGODB_CLIENT
			l_bson: BSON
		do
			create l_client.make ("mongodb://127.0.0.1/?appname=client-example")
			l_client.set_error_api ({MONGODB_EXTERNALS}.mongoc_error_api_version_2)
			create l_bson.make
			l_bson.bson_append_utf8 ("hello", "world")
		end

end
