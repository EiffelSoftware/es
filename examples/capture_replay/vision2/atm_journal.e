indexing
	description: "Objects that represent the log of an ATM"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	ATM_JOURNAL

create
	make

feature -- Initialization
	make is
			-- Initialize an ATM_JOURNAL
		do
			create log.make (0, capacity)
		end


feature -- Access
	time_of_last_entry: DT_TIME is
			-- Timestamp of the last log entry
		do
			Result ?= item @ 1
		end

	item: TUPLE [DT_TIME, STRING]
		-- The last entry of the log

	capacity: INTEGER is 1000
			-- capacity of the Log


feature -- Basic operations
	put (time: DT_TIME; message: STRING) is
		-- Create a log entry with `time' and `message'
		require
			time_not_void: time /= Void
			message_not_void: message /= Void
		do
			count := count + 1
			log [count] := [time, message]
			item := log [count]
		ensure
			entry_added: log [count].is_equal ([time, message])
		end

feature {NONE} -- Implementation

	log: ARRAY[TUPLE [DT_TIME, STRING]]
			-- Log of time stamps and according messages.

	count: INTEGER
			-- Number of log entries.
invariant
	log_not_void: log /= Void
end
