note
	description: "Summary description for {MONGODB_CONNECTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MONGODB_CONNECTION


feature -- Access

	mongodb_pool: MONGODB_CLIENT_POOL
		local
			uri: MONGODB_URI
		do
			create uri.make ("mongodb://127.0.0.1:27017/")
			create Result.make_from_uri (uri)

				-- Register the application name so we can track it in the profile logs
				-- on the server. This can also be done from the URI (see other examples).
			Result.set_appname (app_name)
		end

	mongodb_client: MONGODB_CLIENT
		do
			Result := mongodb_pool.pop
		end

	app_name: STRING = "books_restapi"


end
