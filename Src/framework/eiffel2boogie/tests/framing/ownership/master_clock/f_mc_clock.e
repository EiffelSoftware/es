class F_MC_CLOCK

create
	make

feature {NONE} -- Initialization

	make (m: F_MC_MASTER)
			-- Initialize clock with `m'.
		note
			status: creator
		require
			m /= Void
			across m.observers as ic all ic.item.generating_type = {F_MC_CLOCK} end

			modify (Current)
			modify_field ("observers", m)
		do
			master := m
			local_time := master.time

			m.unwrap
			m.set_observers (m.observers + [Current])
			m.wrap

			set_subjects ([m])
		ensure
			master = m
			local_time = m.time
			m.observers = old m.observers + [Current]
		end

feature -- Access

	master: F_MC_MASTER
			-- Master clock.

	local_time: INTEGER
			-- Time of local clock.

	sync
			-- Sync clock to master.
		require
			master.is_wrapped

			modify_field ("local_time", Current)
		do
			local_time := master.time
		ensure
			local_time = master.time
		end

invariant
	attached master
	0 <= local_time
	local_time <= master.time
	subjects = [master]

end
