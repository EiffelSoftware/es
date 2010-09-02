note
	description: "Separate call feature with a list of locked processors."
	author: "Andrey Nikonov, Andrey Rusakov"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_REPLAY_DIAGRAM_FEATURE

inherit
	LINKED_LIST [ SCOOP_PROCESSOR ]

feature

	set_id (a_global_id: INTEGER)
			-- Set global id.
		do
			global_id := a_global_id
		end

	set_local_id (a_lid: INTEGER)
			--	Set local id.
		do
		 	local_id := a_lid
		end

	set_pid (a_pid: INTEGER)
			-- Set caller id.
		do
			pid := a_pid
		end

	set_routine (a_routine : ROUTINE [ SCOOP_SEPARATE_TYPE, TUPLE ])
			-- Set routine.
		do
			routine := a_routine
		end

		set_executed
			-- Set is_executed value.
		do
			is_executed := true
		end





feature -- Implementation

	pid: INTEGER
		-- Caller processor id.

	routine: ROUTINE [ SCOOP_SEPARATE_TYPE, TUPLE ]
		-- Seprate call routine

	global_id: INTEGER
		-- Number in a whole list of separate calls.

	local_id: INTEGER
		-- Number in a list of processor's separate call list.

	is_executed: BOOLEAN
		-- True if routine is already have called.
		-- Flase if not called or try to be executed.

end
