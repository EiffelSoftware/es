note
	description: "Example: demonstrate different URI options getters"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			uri_options_example
		end

	uri_options_example
		local
			uri: MONGODB_URI
			options: detachable BSON
			app_name: detachable READABLE_STRING_8
			max_pool_size: INTEGER
			max_staleness: INTEGER_64
			retry_writes: BOOLEAN
		do
			{MONGODB_EXTERNALS}.c_mongoc_init

				-- Create a URI with various options
			  -- Create a URI with various options
            create uri.make ("mongodb://localhost:27017")

				-- Get all options as BSON document
			options := uri.options
			if attached options as l_options then
				print ("All options as JSON:%N")
				print (l_options.bson_as_canonical_extended_json + "%N%N")
			else
				print ("No options found in URI.%N%N")
			end

				-- Get individual options using type-specific getters
			print ("Individual options:%N")

				-- Get string option (UTF8)
			app_name := uri.option_as_utf8 ("appname", "DefaultApp")
			print ("Application name: " + if attached app_name as l_app then l_app else "" end + "%N")

				-- Get integer (32-bit) option
			max_pool_size := uri.option_as_int32 ("maxPoolSize", 10)
			print ("Max pool size: " + max_pool_size.out + "%N")

				-- Get integer (64-bit) option
			max_staleness := uri.option_as_int64 ("maxStalenessSeconds", 60)
			print ("Max staleness seconds: " + max_staleness.out + "%N")

				-- Get boolean option
			retry_writes := uri.option_as_bool ("retryWrites", False)
			print ("Retry writes: " + retry_writes.out + "%N")

				-- Try getting a non-existent option (should return fallback value)
			print ("%NTesting fallback values:%N")
			print ("Non-existent option (string): " +
				if attached uri.option_as_utf8 ("nonexistent", "fallback") as l_res then l_res else "" end + "%N")
			print ("Non-existent option (int32): " +
				uri.option_as_int32 ("nonexistent", -1).out + "%N")
			print ("Non-existent option (int64): " +
				uri.option_as_int64 ("nonexistent", -1).out + "%N")
			print ("Non-existent option (bool): " +
				uri.option_as_bool ("nonexistent", True).out + "%N")

			{MONGODB_EXTERNALS}.c_mongo_cleanup
		end

end
