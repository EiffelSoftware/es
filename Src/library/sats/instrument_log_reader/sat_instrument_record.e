indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_INSTRUMENT_RECORD

feature{NONE} -- Initialization

	make_with_slot_and_time (a_slot: like slot; a_time: like time) is
			-- Initialize Current.
		do
			set_slot (a_slot)
			set_time (a_time)
		end
		
feature -- Access

	time: INTEGER
			-- Time when Current record is logged.
			-- In seconds from 1970...

	slot: INTEGER
			-- Index of slot of Current record

feature -- Setting

	set_time (a_time: INTEGER) is
			-- Set `time' with `a_time'.
		do
			time := a_time
		ensure
			time_set: time = a_time
		end

	set_slot (a_slot: INTEGER) is
			-- Set `slot' with `a_slot'.
		do
			slot := a_slot
		ensure
			slot_set: slot = a_slot
		end

end
