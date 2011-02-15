note
	description: "The {SLEEPY_WORKER} needs some time until he begins work."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SLEEPY_WORKER

create
	make

feature -- Initialization
	make(l_worker_no, l_sleepiness: INTEGER_64)
		do
			worker_no := l_worker_no
			sleepiness := l_sleepiness
			create env
		end

feature
	sleepiness: INTEGER_64
	worker_no: INTEGER_64
	env: EXECUTION_ENVIRONMENT

	do_your_work()
		do
			print("Worker " + worker_no.out + ": Uh, what?%N")
			env.sleep(sleepiness)
			print("Worker " + worker_no.out + ": Doing my work%N")
		end
end
