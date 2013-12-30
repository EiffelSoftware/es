note
	description: "Master clock with reset."
	explicit: "all"

frozen class F_MC_MASTER_D

create
	make

feature {NONE} -- Initialization

	make
			-- Create a master clock.
		note
			status: creator
		require
			modify (Current)
		do
			wrap
		ensure
			time_reset: time = 0
			no_observers: observers.is_empty
			default_wrapped: is_wrapped
		end

feature -- Access

	time: INTEGER
			-- Time.

feature -- Update			

	tick
			-- Increment time.
		require
			default_wrapped: is_wrapped
			default_observers_wrapped: across observers as o all o.item.is_wrapped end
			modify_field (["time", "closed"], Current)
		do
			unwrap
			-- This update preserves the invariant of slave clocks:
			time := time + 1
			wrap
		ensure
			time_increased: time > old time
			default_wrapped: is_wrapped
		end

	reset
			-- Reset time to zero.
		require
			wrapped: is_wrapped
			observers_open: across observers as o all o.item.is_open end
			modify_field (["time", "closed"], Current)
		do
			unwrap
			-- This update does not preserve the invariant of slave clocks,
			-- so the method requires that they be open:
			time := 0
			wrap
		ensure
			wrapped: is_wrapped
			time_reset: time = 0
		end

invariant
	time_non_negative: 0 <= time
	all_observers_are_clocks: across observers as o all attached {F_MC_CLOCK_D} o.item end
	default_owns: owns = []
	default_subjects: subjects = []

end
