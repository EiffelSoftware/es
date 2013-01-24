note
	description : "mutex application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization
	max_workers: INTEGER = 50

	make
		local
			worker: separate MUTEX_WORKER
			workers: LINKED_LIST [separate MUTEX_WORKER]
			shared: separate VAR
			i: INTEGER
		do
			create shared
      create workers.make
			from i := 1
			until i > max_workers
			loop
				create worker.make (shared)
				workers.extend (worker)
				i := i + 1
			end

			run_workers (workers)
      wait_workers (workers)
      print_res (shared)
		end

  print_res (shared: separate VAR)
    do
      print (shared.i)
    end

	run_workers (workers: LIST[separate MUTEX_WORKER])
		do
			across
				workers as wc
			loop
				run (wc.item)
			end
		end

	run (worker: separate MUTEX_WORKER)
		do
			worker.live
		end

	wait_workers (workers: LIST[separate MUTEX_WORKER])
		do
			across
				workers as wc
      loop
				wait (wc.item)
			end
		end

	wait (worker: separate MUTEX_WORKER)
		require
			worker.max_iterations >= 0
		do

		end

end
