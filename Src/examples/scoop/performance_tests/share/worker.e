class
	WORKER

create
	make

feature {NONE}
	make (a: separate ARRAYED_LIST [INTEGER])
		do
			array := a
		end

	array: separate ARRAYED_LIST [INTEGER]

feature
	run
		do
			array_work (array)
		end

	array_work (a: separate ARRAYED_LIST [INTEGER])
		local
			i: INTEGER
			n: INTEGER
		do
			n := a.count

			from i := 1
			until i > n
			loop
				a[i] := a[i] + 1
				i := i + 1
			end
		end

end
