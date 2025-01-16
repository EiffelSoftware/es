note
	description: "Factory class for MongoDB operations"
	date: "$Date$"
	revision: "$Revision$"

class
	MONGODB_FACTORY

feature -- Watch Operations

	client_watch (a_client: MONGODB_CLIENT; a_pipeline: BSON; a_opts: detachable BSON): MONGODB_CHANGE_STREAM
			-- Create a change stream for watching changes on the client.
			-- Uses client's read preference and read concern (requires majority read concern).
			-- Automatically handles resumable errors and retryable reads.
			--
			-- `a_client`: The MongoDB client to watch
			-- `a_pipeline`: Aggregation pipeline to append to the change stream (can be empty)
			-- `a_opts`: Optional settings including:
			--           * batchSize: Number of documents per batch
			--           * resumeAfter: Logical starting point
			--           * startAfter: Starting point (works after invalidate)
			--           * maxAwaitTimeMS: Max blocking time
			--           * fullDocument: Document lookup strategy
		note
			eis: "name=", "src=https://mongoc.org/libmongoc/current/mongoc_client_watch.html", "protocol=uri"
		require
			client_exists: a_client.exists
		local
			l_stream: POINTER
			l_opts_ptr: POINTER
		do
			if attached a_opts then
				l_opts_ptr := a_opts.item
			end
			l_stream := c_mongoc_client_watch(a_client.item, a_pipeline.item, l_opts_ptr)
			create Result.make_by_pointer (l_stream)
		end

	database_watch (a_database: MONGODB_DATABASE; a_pipeline: BSON; a_opts: detachable BSON): MONGODB_CHANGE_STREAM
			-- Create a change stream for watching changes on the database.
			-- Uses database's read preference and read concern (requires majority read concern).
			-- Automatically handles resumable errors and retryable reads.
			--
			-- `a_database`: The MongoDB database to watch
			-- `a_pipeline`: Aggregation pipeline to append to the change stream (can be empty)
			-- `a_opts`: Optional settings including:
			--           * batchSize: Number of documents per batch
			--           * resumeAfter: Logical starting point
			--           * startAfter: Starting point (works after invalidate)
			--           * maxAwaitTimeMS: Max blocking time
			--           * fullDocument: Document lookup strategy
		note
			eis: "name=", "src=https://mongoc.org/libmongoc/current/mongoc_database_watch.html", "protocol=uri"
		require
			database_exists: a_database.exists
		local
			l_stream: POINTER
			l_opts_ptr: POINTER
		do
			if attached a_opts  then
				l_opts_ptr := a_opts.item
			end
			l_stream := c_mongoc_database_watch(a_database.item, a_pipeline.item, l_opts_ptr)
			create Result.make_by_pointer (l_stream)
		end

	collection_watch (a_collection: MONGODB_COLLECTION; a_pipeline: BSON; a_opts: detachable BSON): MONGODB_CHANGE_STREAM
			-- Create a change stream for watching changes on the collection.
			-- Uses collection's read preference and read concern (requires majority read concern).
			-- Automatically handles resumable errors and retryable reads.
			--
			-- `a_collection`: The MongoDB collection to watch
			-- `a_pipeline`: Aggregation pipeline to append to the change stream (can be empty)
			-- `a_opts`: Optional settings including:
			--           * batchSize: Number of documents per batch
			--           * resumeAfter: Logical starting point
			--           * startAfter: Starting point (works after invalidate)
			--           * maxAwaitTimeMS: Max blocking time
			--           * fullDocument: Document lookup strategy
		note
			eis: "name=", "src=https://mongoc.org/libmongoc/current/mongoc_collection_watch.html", "protocol=uri"
		require
			collection_exists: a_collection.exists
		local
			l_stream: POINTER
			l_opts_ptr: POINTER
		do
			if attached a_opts then
				l_opts_ptr := a_opts.item
			end
			l_stream := c_mongoc_collection_watch(a_collection.item, a_pipeline.item, l_opts_ptr)
			create Result.make_by_pointer (l_stream)
		end

feature {NONE} -- Externals

	c_mongoc_client_watch (a_client, a_pipeline, a_opts: POINTER): POINTER
			-- External call to mongoc_client_watch
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_watch((mongoc_client_t *)$a_client, (const bson_t *)$a_pipeline, (const bson_t *)$a_opts);"
		end

	c_mongoc_database_watch (a_database, a_pipeline, a_opts: POINTER): POINTER
			-- External call to mongoc_database_watch
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_database_watch((const mongoc_database_t *)$a_database, (const bson_t *)$a_pipeline, (const bson_t *)$a_opts);"
		end

	c_mongoc_collection_watch (a_collection, a_pipeline, a_opts: POINTER): POINTER
			-- External call to mongoc_collection_watch
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_collection_watch((const mongoc_collection_t *)$a_collection, (const bson_t *)$a_pipeline, (const bson_t *)$a_opts);"
		end

end
