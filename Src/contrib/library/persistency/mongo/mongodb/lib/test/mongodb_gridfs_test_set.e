note
	description: "Test suite for MONGODB_GRIDFS_BUCKET"
	date: "$Date$"
	revision: "$Revision$"

class
	MONGODB_GRIDFS_TEST_SET

inherit
	EQA_TEST_SET

feature -- Test routines

	test_create_gridfs_bucket
			-- Test creation of a GridFS bucket
		local
			l_client: MONGODB_CLIENT
			l_database: MONGODB_DATABASE
			l_bucket: MONGODB_GRIDFS_BUCKET
			l_uri_string: STRING
		do
				-- Setup: Create a client and get database
			l_uri_string := "mongodb://localhost:27017"
			create l_client.make (l_uri_string)
			l_database := l_client.database ("test")

				-- Create GridFS bucket
			create l_bucket.make_from_database (l_database, Void, Void)

				-- Assert bucket was created successfully
			assert ("bucket_created", l_bucket.last_call_succeed)
			assert ("bucket_valid", l_bucket.item /= default_pointer)

				-- Cleanup
			l_bucket.dispose
			l_client.dispose
		end

	test_create_gridfs_bucket_with_invalid_database
			-- Test creation of a GridFS bucket with invalid database
		local
			l_client: MONGODB_CLIENT
			l_database: MONGODB_DATABASE
			l_bucket: MONGODB_GRIDFS_BUCKET
			l_uri_string: STRING
		do
				-- Setup: Create a client with invalid connection
			l_uri_string := "mongodb://invalid-host:27017"
			create l_client.make (l_uri_string)
			l_database := l_client.database ("test")

				-- Attempt to create GridFS bucket
			create l_bucket.make_from_database (l_database, Void, Void)

				-- Assert bucket creation failed
			assert ("bucket_has_error", l_bucket.error_occurred)
			if attached {MONGODB_ERROR}l_bucket.last_error as l_error then
				assert ("correct_error_domain", l_erroR.message.has_substring ({MONGODB_ERROR_CODE}.MONGOC_ERROR_GRIDFS.out))
			end

		end

end
