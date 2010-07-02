class
	TEST

inherit
	THREAD_CONTROL

creation
	make

feature

	make
		local
			l_count: NATURAL
			first, last, l_prev, l_next: CONDITION_VARIABLE
		do
			create mutex.make

			count := 0

			from
				l_count := 0
				create l_prev.make
				first := l_prev
			until
				l_count = 5
			loop
				create l_next.make
				last := l_next;
				(create {WORKER_THREAD}.make (agent run (l_prev, l_next))).launch
				l_prev := l_next
				l_count := l_count + 1
			end

			from until l_count = count loop do_nothing end

			mutex.lock
			count := 0
			first.signal
			mutex.unlock

			from until l_count = count loop do_nothing end

			mutex.lock
			last.signal
			mutex.unlock

			join_all

			{RT_CAPTURE_REPLAY}.print_string ("done%N")
		end

feature {NONE}

	count: NATURAL

	mutex: MUTEX

	timeout: INTEGER = 1000

	run (a_prev, a_next: CONDITION_VARIABLE)
		do
			mutex.lock;
			(agent print_something).call (["wait%N"])

			count := count + 1
			if a_prev.wait_with_timeout (mutex, timeout) then

				(agent print_something).call ([{RT_CAPTURE_REPLAY}.thread_id.out + " work%N"])

				a_next.signal
				count := count + 1
				if a_next.wait_with_timeout (mutex, timeout) then

					(agent print_something).call ([{RT_CAPTURE_REPLAY}.thread_id.out + " terminate%N"])

					a_prev.signal
				end
			end
			mutex.unlock
		end

	print_something (a_string: STRING)
		do
			{RT_CAPTURE_REPLAY}.print_string (a_string)
		end


end

