note
	description: "Summary description for {MONGO_WORKER_THREAD}."
	date: "$Date$"
	revision: "$Revision$"

class
	MONGODB_WORKER_THREAD

inherit
	THREAD
		rename
			make as thread_make
		end

	WORK_OUTPUT_STREAM

create
	make

feature {NONE} -- Initialization

	make (a_id: INTEGER; a_client: STRING; a_mutex: MUTEX)
			-- Initialize thread with ID, client and mutex
		require
			valid_id: a_id > 0
		do
			thread_make
			id := a_id
			connection_string := a_client
			db_mutex := a_mutex
		end

feature -- Access

	id: INTEGER
			-- Thread id.

feature -- Execution

	execute
			-- Perform MongoDB operations in this thread
		local
			w: WORK_EXECUTION
		do
			create w.make (id, connection_string, Current)
--			w.set_context_handled_globally (True)
			w.process
		rescue
			output ("Error occurred during MongoDB operations%N")
		end

feature -- Conversion

	output (message: READABLE_STRING_8)
			-- Print a message with thread identifier
		do
			db_mutex.lock
			print ("Thread " + id.out + ": " + message)
			db_mutex.unlock
		end

feature {NONE} -- Implementation

	connection_string: STRING
			-- MongoDB connection string

	db_mutex: MUTEX
			-- Mutex for synchronizing database operations

	cleanup
			-- Cleanup resources
		do
			if db_mutex /= Void and then db_mutex.is_set then
				db_mutex.unlock
			end
		end

invariant
	valid_id: id > 0

end
