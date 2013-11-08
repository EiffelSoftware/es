note
	explicit: "all"

class F_MC_CLIENT

feature

	test
		local
			m: F_MC_MASTER
			c1, c2: F_MC_CLOCK
		do
			create m
			create c1.make (m)
			create c2.make (m)

			check m.observers = [c1, c2] end

			c1.unwrap ; c2.unwrap -- TODO: unwrap_all ([c1, c2])
			m.tick
			c1.wrap ; c2.wrap -- TODO: wrap_all ([c1, c2])

			c1.sync
			c2.sync

			check c1.local_time = m.time end
			check c2.local_time = m.time end
		end

	test_d
		local
			m: F_MC_MASTER_D
			c1, c2: F_MC_CLOCK_D
		do
			create m
			create c1.make (m)
			create c2.make (m)

			check m.observers = [c1, c2] end

			c1.unwrap ; c2.unwrap -- TODO: unwrap_all ([c1, c2])
			m.tick
			c1.wrap ; c2.wrap -- TODO: wrap_all ([c1, c2])

			c1.sync
			c2.sync

			check c1.local_time = m.time end
			check c2.local_time = m.time end
		end

end
