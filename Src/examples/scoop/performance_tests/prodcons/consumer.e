note
	description: "Summary description for {MUTEX_WORKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
  CONSUMER

create
	make

feature {NONE}
	make (sh: separate SHARED_QUEUE [INTEGER])
		do
			shared := sh
		end

feature
	max_iterations: INTEGER = 20000

	shared: separate SHARED_QUEUE [INTEGER]

	live
		local
			i: INTEGER
		do
			from i := 1
			until i > max_iterations
			loop
				run (shared)
				i := i + 1
			end
		end

  run (a_shared: separate SHARED_QUEUE [INTEGER])
    require
      not a_shared.is_empty
    local
      tmp: INTEGER 
		do
      tmp := a_shared.dequeue
		end

end
