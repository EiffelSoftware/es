indexing
	description: "Summary description for {SCOOP_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SCOOP_UTILITY

feature {SCOOP_UTILITY}
	sleep (timeout : INTEGER)
		require
			positive_sleep: timeout >= 0
		local
			m : MUTEX
			c : CONDITION_VARIABLE
		do
			create m.make
			create c.make

			m.lock
			c.wait_with_timeout (m, timeout).do_nothing
			m.unlock
		end

end
