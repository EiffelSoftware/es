note
	description: "Summary description for {MUTEX_WORKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MUTEX_WORKER

create
	make

feature {NONE}
	make (sh: separate VAR)
		do
			shared := sh
		end

feature
	max_iterations: INTEGER = 20000

	shared: separate VAR

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

	run (a_shared: separate VAR)
    local
      tmp: separate VAR
		do
			a_shared.update_var
      tmp := a_shared.default
		end

end
