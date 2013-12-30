note
	description: "Master clock with reset."

frozen class F_MC_MASTER

create
	make

feature {NONE} -- Initialization

	make
			-- Create a master clock.
		note
			status: creator
		do
		ensure
			time_reset: time = 0
			no_observers: observers.is_empty
		end

feature -- Access

	time: INTEGER
			-- Time.

feature -- Update			

	tick
			-- Increment time.
		require
			modify_field (["time", "closed"], Current)
		do
			-- This update preserves the invariant of slave clocks:
			time := time + 1
		ensure
			time_increased: time > old time
		end

	reset
			-- Reset time to zero.
		note
			explicit: contracts
		require
			wrapped: is_wrapped
			observers_open: across observers as o all o.item.is_open end
			modify_field (["time", "closed"], Current)
		do
			-- This update does not preserve the invariant of slave clocks,
			-- so the method requires that they be open:
			time := 0
		ensure
			wrapped: is_wrapped
			time_reset: time = 0
		end

invariant
	time_non_negative: 0 <= time
	all_observers_are_clocks: across observers as o all attached {F_MC_CLOCK} o.item end

note
	explicit: observers
end
