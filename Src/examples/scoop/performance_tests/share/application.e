note
	description : "share application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	num_workers: INTEGER
	array_size: INTEGER

	make
		local
			worker: separate WORKER
			workers: ARRAYED_LIST [separate WORKER]
			array: separate ARRAYED_LIST [INTEGER]
			i: INTEGER
		do
      array_size := argument(1).to_integer_32
      num_workers := argument (2).to_integer_32
      
			create workers.make (10)
			create array.make_filled (array_size)

			from i := 1
			until i > num_workers
			loop
				create worker.make (array)
				workers.extend (worker)
				i := i + 1
			end

			run_workers (workers)

			across
				workers as wc
			loop
				wait (wc.item)
			end
		end

	run_workers (workers: ARRAYED_LIST [separate WORKER])
		local
			i: INTEGER
		do
			from i := 1
			until i > num_workers
			loop
				run (workers [i])
				i := i + 1
			end
		end

	run (w: separate WORKER)
		do
			w.run
		end

	wait (w: separate WORKER)
		require
			w.default = w.default
		do
		end
end
