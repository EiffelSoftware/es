class F_MC_CLOCK

create
	make

feature {NONE} -- Initialization

	make (m: F_MC_MASTER)
			-- Initialize clock with `m'.
		note
			status: creator
		require
			is_open -- default
			m.is_wrapped -- default
			m /= Void

			modify (Current) -- default: creator
			modify_field ("observers", m)
		do
			set_owns ([]) -- default: creator
			set_subjects ([]) -- default: creator
			set_observers ([]) -- default: creator

			master := m
			local_time := master.time

			m.unwrap
			m.set_observers (m.observers + [Current]) -- m.observers.add (Current)
			m.wrap

			set_subjects ([m]) -- default

			wrap -- default
		ensure
			is_wrapped -- default
			m.is_wrapped -- default
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
			is_wrapped -- default
			master.is_wrapped

			modify_field ("local_time", Current)
		do
			unwrap -- default
			local_time := master.time
			wrap -- default
		ensure
			is_wrapped -- default
			local_time = master.time
		end

invariant
	attached master
	0 <= local_time
	local_time <= master.time
	subjects = [master]
	across subjects as s all s.item.observers.has (Current) end -- default
	owns = [] -- default
	observers = [] -- default

end
