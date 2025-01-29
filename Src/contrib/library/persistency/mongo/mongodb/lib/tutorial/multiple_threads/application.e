note
	description: "MongoDB multi-threaded example application"
	date: "$Date$"
	revision: "$Revision$"

class APPLICATION

inherit
	THREAD_CONTROL

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize and run concurrent MongoDB operations
		local
			l_context: MONGODB_CONTEXT
			i: INTEGER
			l_thread: MONGODB_WORKER_THREAD
			l_connection_string: STRING
		do
				-- Initialize MongoDB context
			create l_context
			l_context.start

				-- Create connection string and mutex
			l_connection_string := "mongodb://localhost:27017"
			create db_mutex.make

			print ("Starting concurrent MongoDB operations with " + Number_of_threads.out + " threads%N")

				-- Launch multiple worker threads
			from
				i := 1
			until
				i > Number_of_threads
			loop
				create l_thread.make (i, l_connection_string, db_mutex)
				l_thread.launch
				i := i + 1
			end

				-- Wait for all threads to complete
			join_all

			print ("All threads completed%N")

				-- Cleanup
			--l_context.finish
		end

feature {NONE} -- Implementation

	db_mutex: MUTEX
			-- Mutex for synchronizing database operations

	Number_of_threads: INTEGER = 5
			-- Number of concurrent threads to run

end
