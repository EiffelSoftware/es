class
	APPLICATION

create
	make

feature {NONE}
	num_workers: INTEGER = 4

	make
		local
			worker: separate WORKER
			workers: ARRAYED_LIST [separate WORKER]
			i: INTEGER
		do
			create workers.make (10)
			from i := 1
			until i > num_workers
			loop
				create worker
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
