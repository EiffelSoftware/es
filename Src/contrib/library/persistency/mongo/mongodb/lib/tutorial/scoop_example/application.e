note
	description: "MongoDB SCOOP example application"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize and run concurrent MongoDB operations
		local
			l_context: MONGODB_CONTEXT
			i: INTEGER
			l_worker: separate MONGODB_WORKER
			l_workers: ARRAYED_LIST [separate MONGODB_WORKER]
		do
				-- Initialize MongoDB context
			create l_context
			l_context.start

				-- Create shared client and console manager
			create client.make ("mongodb://localhost:27017")
			create console

			print ("Starting concurrent MongoDB operations with " + Number_of_processors.out + " processors%N")

				-- Create list to keep track of workers
			create l_workers.make (Number_of_processors)

				-- Launch multiple worker processors
			from
				i := 1
			until
				i > Number_of_processors
			loop
				create l_worker.make (i, client, console)
				l_workers.extend (l_worker)
				launch_worker (l_worker)
				i := i + 1
			end

			print ("All processors launched%N")

				-- Wait for all workers to complete
			across l_workers as worker loop
				wait_for_worker (worker)
			end

			print ("%NAll processors completed%N")


				-- Cleanup
--			client.dispose
--         	l_context.finish
		end

feature {NONE} -- Implementation

	launch_worker (a_worker: separate MONGODB_WORKER)
			-- Launch a worker processor
		do
			a_worker.execute
		end

	wait_for_worker (a_worker: separate MONGODB_WORKER)
			-- Wait for worker to complete
		require
			a_worker.is_done
		do
				-- SCOOP automatically waits for separate call to complete
			print("%NDONE: " +  a_worker.id.out)
		end

	client: separate MONGODB_CLIENT
			-- Shared MongoDB client

	console: separate CONSOLE_MANAGER
			-- Shared console manager

	Number_of_processors: INTEGER = 5
			-- Number of concurrent processors to run

end
