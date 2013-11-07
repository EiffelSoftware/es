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
		require else
			is_open -- default: creator
			modify (Current) -- default: creator
		do
			wrap -- default: creator
		ensure then
			time = 0 -- default: default_create
			is_wrapped -- default: creator
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
			unwrap -- default
			time := time + 1
			wrap -- default
		ensure
			time > old time
			is_wrapped
		end

invariant
	0 <= time
	owns = [] -- default
	subjects = [] -- default

note
	explicit: observers
end
