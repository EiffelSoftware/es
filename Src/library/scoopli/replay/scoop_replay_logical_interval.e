note
	description: "Interval for critical events, that processor dispatches without interleaving."
	author: "Nikonov Andrey, Rusakov Andrey"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_REPLAY_LOGICAL_INTERVAL
	
create
	make

feature

	make ( a_first_critical_event : INTEGER; a_last_critical_event : INTEGER)
			-- init
		do
			first_critical_event := a_first_critical_event
			last_critical_event := a_last_critical_event
		end

	set_last_critical_event( a_last_critical_event : INTEGER )
			-- Replace last critical event with new value
		do
			last_critical_event := a_last_critical_event
		end

	first_critical_event : INTEGER
		-- Number of first critical event for this interval

	last_critical_event : INTEGER
		-- Number of last critical event for this interval
end
