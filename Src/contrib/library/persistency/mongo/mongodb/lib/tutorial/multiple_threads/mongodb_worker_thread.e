note
	description: "Summary description for {MONGO_WORKER_THREAD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MONGODB_WORKER_THREAD

inherit
	THREAD
		rename
			make as thread_make
		end

create
	make

feature {NONE} -- Initialization

	make (a_id: INTEGER; a_client: MONGODB_CLIENT; a_mutex: MUTEX)
			-- Initialize thread with ID, client and mutex
		require
			valid_id: a_id > 0
		do
			thread_make
			id := a_id
			client := a_client
			db_mutex := a_mutex
		end

feature -- Access

	id: INTEGER
			-- Thread id.

feature -- Execution

	execute
			-- Perform MongoDB operations in this thread
		local
			l_database: MONGODB_DATABASE
			l_collection: MONGODB_COLLECTION
			l_document: BSON
			l_bulk: MONGODB_BULK_OPERATION
			l_opts: BSON
			l_cursor: MONGODB_CURSOR
			l_after: BOOLEAN
			l_reply: BSON
		do
				-- Get database and collection
			l_database := client.database ("concurrent_test")
			l_collection := l_database.collection ("thread_data")

				-- Lock mutex for write operations
			db_mutex.lock
			thread_print ("Starting write operations%N")

				-- Insert some documents
			create l_opts.make
			l_bulk := l_collection.create_bulk_operation_with_opts (l_opts)

				-- Insert multiple documents for this thread
			from
				i := 1
			until
				i > 5
			loop
				create l_document.make
				l_document.bson_append_integer_32 ("thread_id", id)
				l_document.bson_append_integer_32 ("document_number", i)
				l_document.bson_append_utf8 ("message", "Hello from thread " + id.out)
				l_document.bson_append_time ("timestamp", (create {DATE_TIME}.make_now_utc).time_duration.fine_seconds_count.truncated_to_integer_64)

				l_bulk.insert_with_opts (l_document, Void)
				i := i + 1
			end

				-- Execute bulk insert
			create l_reply.make
			l_bulk.execute (l_reply)
			thread_print ("Inserted 5 documents%N")

				-- Unlock mutex after write operations
			db_mutex.unlock

				-- Read operations (no mutex needed for reads as they're thread-safe)
			thread_print ("Starting read operations%N")
			create l_document.make
			l_document.bson_append_integer_32 ("thread_id", id)

			l_cursor := l_collection.find_with_opts (l_document, Void, Void)

				-- Print documents found
			from
				l_after := False
			until
				l_after
			loop
				if attached l_cursor.next as l_doc then
					thread_print ("Found document: " + l_doc.bson_as_canonical_extended_json + "%N")
				else
					l_after := True
				end
			end
		end

feature {NONE} -- Implementation

	client: MONGODB_CLIENT
			-- Shared MongoDB client

	db_mutex: MUTEX
			-- Mutex for synchronizing database operations

	i: INTEGER
			-- Counter for document numbers

	thread_print (message: STRING)
			-- Print a message with thread identifier
		do
			db_mutex.lock
			print ("Thread " + id.out + ": " + message)
			db_mutex.unlock
		end

invariant
	valid_id: id > 0

end
