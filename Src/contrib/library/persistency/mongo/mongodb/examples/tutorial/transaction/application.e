note
	description: "Example demonstrating MongoDB transactions"
	date: "$Date$"
	revision: "$Revision$"
	eis: "name=example-transaction", "src=https://mongoc.org/libmongoc/current/mongoc_client_session_start_transaction.html#example", "protocol=uri"
class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
		local
			uri_string: STRING
			uri: MONGODB_URI
			client: MONGODB_CLIENT
			database: MONGODB_DATABASE
			collection: MONGODB_COLLECTION
			session: MONGODB_CLIENT_SESSION
			session_opts: MONGODB_SESSION_OPTIONS
			default_txn_opts: MONGODB_TRANSACTION_OPTIONS
			txn_opts: MONGODB_TRANSACTION_OPTIONS
			read_concern: MONGODB_READ_CONCERN
			write_concern: MONGODB_WRITE_CONCERN
			insert_opts: BSON
			l_error: BSON_ERROR
			driver: MONGODB_DRIVER
		do      
				-- Initialize driver
			create driver
			driver.use

				-- Initialize default URI
			uri_string := "mongodb://127.0.0.1/?appname=transaction-example"

				-- Create URI and client
			create uri.make (uri_string)
			create client.make_from_uri (uri)

				-- Set error API version
			client.set_error_api (2)

				-- Get database
			database := client.database ("example-transaction")

				-- Try to create collection (may already exist)
			create l_error.make
			collection := database.create_collection ("collection", Void)
			if collection = Void then
				if attached database.last_error as err and then err.code = 48 then
						-- Collection already exists, get it
					collection := database.collection ("collection")
				else
					print ({STRING_32}"Failed to create collection: " + database.last_call_message + "%N")

					-- Exit with failure
					{EXCEPTIONS}.die (1)
				end
			end

				-- Set up transaction options with read concern
			create default_txn_opts.make
			create read_concern.make
			read_concern.set_level ("snapshot")
			default_txn_opts.set_read_concern (read_concern)

				-- Set up session options with default transaction options
			create session_opts.make
			session_opts.set_default_transaction_opts (default_txn_opts)

				-- Start session
			session := client.start_session (session_opts)
			if session = Void then
				print ({STRING_32}"Failed to start session: " + client.last_call_message + "%N")

				{EXCEPTIONS}.die (1)
			end

				-- Set up transaction options with write concern
			create txn_opts.make
			create write_concern.make
			write_concern.set_wmajority (1000) -- wtimeout in milliseconds
			txn_opts.set_write_concern (write_concern)

				-- Create insert options with session
			create insert_opts.make
			session.append (insert_opts)

			from
				-- Retry transaction loop
			until
				execute_transaction (session, txn_opts, collection, insert_opts)
			loop
				-- Transaction will be retried if it returns False
			end
		end

feature {NONE} -- Implementation

	execute_transaction (session: MONGODB_CLIENT_SESSION;
						txn_opts: MONGODB_TRANSACTION_OPTIONS;
						collection: MONGODB_COLLECTION;
						insert_opts: BSON): BOOLEAN
			-- Execute transaction. Returns True if successful, False if should retry
		local
			i: INTEGER
			doc: BSON
			reply: BSON
			l_stopwatch: DT_STOPWATCH
		do
				-- Start transaction
			session.start_transaction (txn_opts)
			if session.error_occurred  then
				print ({STRING_32}"Failed to start transaction: " + session.last_call_message + "%N")

				Result := True -- Don't retry
				{EXCEPTIONS}.die (1)
			else
					-- Insert two documents
				from
					i := 0
				until
					i >= 2 or Result
				loop
					create doc.make
					doc.bson_append_integer_32 ("_id", i)
					create reply.make
					collection.insert_one (doc, insert_opts, reply)
					if collection.error_occurred then
						print ({STRING_32}"Insert failed: " + collection.last_call_message + "%N")

						session.abort_transaction

						-- Check for transient error

						if attached {MONGODB_ERROR} collection.last_error as le and then
							le.message.has_substring ("TransientTransactionError") then
								-- Retry transaction
							Result := False
						else
								-- Don't retry
							Result := True
							{EXCEPTIONS}.die (1)
						end
					else
						print (reply.bson_as_canonical_extended_json + "%N")
					end

					i := i + 1
				end

				if not Result then
						-- Try to commit for up to 5 seconds
					create l_stopwatch.make
					from
						l_stopwatch.start
					until
						Result or (l_stopwatch.elapsed_time.time_duration.millisecond_count > 5000)
					loop
						create reply.make
						session.commit_transaction (reply)
						if session.last_call_succeed then
							Result := True -- Success
						else
							print ({STRING_32}"Warning commit failed: " + session.last_call_message + "%N")

							if attached {MONGODB_ERROR} session.last_error as le and then le.message.has_substring ("TransientTransactionError") then
								Result := False -- Retry entire transaction
							elseif attached {MONGODB_ERROR} session.last_error as le and then le.message.has_substring ("UnknownTransactionCommitResult") then
									-- Try commit again
								Result := False
							else
									-- Unrecoverable error
								Result := True
								{EXCEPTIONS}.die (1)
							end
						end
					end
				end
			end
		end

end

