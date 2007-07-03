indexing
	description: "Object that simulates an atm_ui to make performance tests"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	PERFORMANCE_TESTER_ATM_UI

inherit
	ATM_UI
	redefine
		run
	end
create
	make

feature -- Basic operations

	run is
			-- make an even distribution of calls, to monitor performance...
		local
			i: INTEGER
			acc_name: STRING
			clock: DT_SYSTEM_CLOCK
			time_before, time_after: DT_TIME
			duration: DT_TIME_DURATION
		do
			print("starting test")
			create clock.make
			time_before := clock.time_now
			acc_name := "test"
			from
				i := 0
			until
				i>10000
			loop
				print(".")
				if atm.account_exists (acc_name) then
					atm.deposit (acc_name, 300)
					atm.withdraw (acc_name, 300)
				end
				i := i+1
			end
			time_after := clock.time_now
			duration := time_after.time_duration (time_before)
			print("duration: " + duration.out)
		end


feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
