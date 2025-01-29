note
	description: "MongoDB worker processor for concurrent operations"
	date: "$Date$"
	revision: "$Revision$"

class
	MONGODB_WORKER

create
	make

feature {NONE} -- Initialization

	make (a_id: INTEGER; a_client: separate MONGODB_CLIENT; a_console: separate CONSOLE_MANAGER)
			-- Initialize worker with ID and shared client
		require
			valid_id: a_id > 0
		do
			id := a_id
			client := a_client
			console := a_console
			done := False
		end

feature -- Access

	id: INTEGER
			-- Worker ID

	is_done: BOOLEAN
			-- Has this worker completed its execution?
		do
			Result := done
		end

feature -- Operations

	execute
			-- Perform MongoDB operations in this processor
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
			l_database := client.database ("concurrent_soop_test")
			l_collection := l_database.collection ("processor_data")

				-- Print start message
			separate console as c do
				c.print_message ("Processor " + id.out + ": Starting write operations%N")
			end

				-- Insert documents
			create l_opts.make
			l_bulk := l_collection.create_bulk_operation_with_opts (l_opts)

			from
				i := 1
			until
				i > 5
			loop
				create l_document.make
				l_document.bson_append_integer_32 ("processor_id", id)
				l_document.bson_append_integer_32 ("document_number", i)
				l_document.bson_append_utf8 ("message", "Hello from processor " + id.out)
				l_document.bson_append_time ("timestamp", (create {DATE_TIME}.make_now_utc).time_duration.fine_seconds_count.truncated_to_integer_64)

				l_bulk.insert_with_opts (l_document, Void)
				i := i + 1
			end

			create l_reply.make
			l_bulk.execute (l_reply)

			separate console as c do
				c.print_message ("Processor " + id.out + ": Inserted 5 documents%N")
			end

				-- Read operations
			separate console as c do
				c.print_message ("Processor " + id.out + ": Starting read operations%N")
			end

			create l_document.make
			l_document.bson_append_integer_32 ("processor_id", id)

			l_cursor := l_collection.find_with_opts (l_document, Void, Void)

			from
				l_after := False
			until
				l_after
			loop
				if attached l_cursor.next as l_doc then
					separate console as c do
						c.print_message ("Processor " + id.out + ": Found document: " + l_doc.bson_as_canonical_extended_json + "%N")
					end
				else
					l_after := True
				end
			end

				-- Mark as done
			done := True
		end

feature {NONE} -- Implementation

	client: separate MONGODB_CLIENT
			-- Shared MongoDB client

	console: separate CONSOLE_MANAGER
			-- Console manager for synchronized output

	i: INTEGER
			-- Counter for document numbers

	done: BOOLEAN
			-- Has this worker completed its execution?

invariant
	valid_id: id > 0

end
