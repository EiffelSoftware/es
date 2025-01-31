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
			i: INTEGER
			l_thread: MONGODB_WORKER_THREAD
			l_connection_string: STRING
		do
				-- Create connection string and mutex
			l_connection_string := "mongodb://localhost:27017"
			create db_mutex.make

			print ("Starting concurrent MongoDB operations with " + Number_of_processors.out + " threads%N")

				-- Launch multiple worker threads
			from
				i := 1
			until
				i > Number_of_processors
			loop
				create l_thread.make (i, l_connection_string, db_mutex)
				l_thread.launch
				i := i + 1
			end

				-- Wait for all threads to complete
			join_all

			print ("All threads completed%N")

		end

feature {NONE} -- Implementation

	db_mutex: MUTEX
			-- Mutex for synchronizing database operations

	Number_of_processors: INTEGER
			-- Number of concurrent scoop processor to run
		do
			Result := {WORK_CONFIG}.Number_of_processors
		end

end
