class F_MC_MASTER

inherit
	ANY
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
		note
			status: creator
		do
		ensure then
			time = 0 -- default: default_create
			observers.is_empty -- default: default_create
		end

feature

	time: INTEGER
			-- Clock time.

	tick
		note
			explicit: contracts
		require
			is_wrapped
			across observers as o all o.item.is_open end

			modify_field ("time", Current)
		do
			time := time + 1
		ensure
			time > old time
			is_wrapped
		end

invariant
	0 <= time

note
	explicit: observers
end
