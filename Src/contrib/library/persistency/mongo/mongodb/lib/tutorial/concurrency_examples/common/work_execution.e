note
	description: "Summary description for {WORK_EXECUTION}."
	date: "$Date$"
	revision: "$Revision$"

class
	WORK_EXECUTION

create
	make

feature {NONE} -- Initialization

	make (a_id: INTEGER_32; a_connection_string: separate READABLE_STRING_8; a_output_stream: separate WORK_OUTPUT_STREAM)
		do
			id := a_id
			output_stream := a_output_stream
			create connection_string.make_from_separate (a_connection_string)
		end

feature -- Access

	id: INTEGER_32

	connection_string: IMMUTABLE_STRING_8

	output_stream: separate WORK_OUTPUT_STREAM

	is_completed: BOOLEAN

feature -- Execution

	output (m: READABLE_STRING_8)
		do
			separate output_stream as s do
				s.output ("[#" + id.out + "] " + m)
			end
		end

	process
		local
			l_database: MONGODB_DATABASE
			l_collection: MONGODB_COLLECTION
			l_document: BSON
			l_bulk: MONGODB_BULK_OPERATION
			l_opts: BSON
			l_cursor: MONGODB_CURSOR
			l_after: BOOLEAN
			l_reply: BSON
			client: MONGODB_CLIENT
			i: INTEGER -- Counter for document numbers
		do
			is_completed := False
			output ("Begin the execution for processor " + id.out + "%N")

				-- Initialize MongoDB
			(create {MONGODB_DRIVER}).initialize

			create client.make (connection_string)
			if client.is_usable then
					-- Get database and collection
				l_database := client.database ("concurrent_test")
				l_collection := l_database.collection ("processor_data")

					-- Concurrent output
				output ("Starting write operations%N")

					-- Insert some documents
				create l_opts.make
				l_bulk := l_collection.create_bulk_operation_with_opts (l_opts)

					-- Insert multiple documents for this processor (thread or scoop processor)
				from
					i := 1
				until
					i > 5
				loop
					output ("Prepare new document #"+ i.out +" from worker " + id.out + "%N")
					create l_document.make
					l_document.bson_append_integer_32 ("processor_id", id)
					l_document.bson_append_integer_32 ("document_number", i)
					l_document.bson_append_utf8 ("message", "Hello from processor " + id.out)
					l_document.bson_append_time ("timestamp", (create {DATE_TIME}.make_now_utc).time_duration.fine_seconds_count.truncated_to_integer_64)

					l_bulk.insert_with_opts (l_document, Void)
					i := i + 1
				end

					-- Execute bulk insert
				create l_reply.make
				l_bulk.execute (l_reply)
				output ("Inserted 5 documents%N")

				output ("Starting read operations%N")

				create l_document.make
				l_document.bson_append_integer_32 ("processor_id", id)

				l_cursor := l_collection.find_with_opts (l_document, Void, Void)

					-- Print documents found
				from
					l_after := False
				until
					l_after
				loop
					if attached l_cursor.next as l_doc then
						output ("Found document: " + l_doc.bson_as_canonical_extended_json + "%N")
					else
						l_after := True
					end
				end

				client.destroy
			else
				output ("Error: Could not create MongoDB client connection%N")
			end

			is_completed := True
			output ("End the execution for processor " + id.out + "%N")
		end

end
