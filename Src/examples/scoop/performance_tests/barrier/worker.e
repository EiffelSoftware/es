class
	WORKER

create
	make

feature
	N: INTEGER = 2000

	total_players: INTEGER
	var: separate VAR

	make (v: separate VAR;  a_total: INTEGER)
		do
			var := v
			total_players := a_total
		end

	run
		local
			i: INTEGER
		do
			from i := 1
			until i > N
			loop
				add_to_barrier (var)
				wait_on_barrier (var)
				i := i + 1
			end
		end

	add_to_barrier (v: separate VAR)
		require
			not v.is_full
		do
			v.inc
		end

	wait_on_barrier (v: separate VAR)
		require
			v.is_full
		do
			v.set_done
		end
end
