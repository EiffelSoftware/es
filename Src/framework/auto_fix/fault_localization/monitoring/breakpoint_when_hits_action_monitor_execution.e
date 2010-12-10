note
	description: "Summary description for {BREAKPOINT_WHEN_HITS_ACTION_MONITOR_EXECUTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BREAKPOINT_WHEN_HITS_ACTION_MONITOR_EXECUTION

inherit
	BREAKPOINT_WHEN_HITS_ACTION_I

create
	make

feature {NONE} -- Initialization

	make (a_status: BOOLEAN; a_beacon: CELL[BOOLEAN])
			-- Initialization.
		require
			beacon_attached: a_beacon /= Void
		do
			set_status (a_status)
			set_beacon (a_beacon)
		end

feature -- Access

	beacon: CELL [BOOLEAN] assign set_beacon
			-- Beacon from which the status of monitoring could be queried.

	status: BOOLEAN assign set_status
			-- True  -> start monitoring
			-- False -> stop monitoring

feature -- Status report

	is_persistent: BOOLEAN
			-- Does the system also save this object, when it stores breakpoint?
		do
			Result := False
		end

feature -- Change

	set_beacon (a_beacon: like beacon)
			-- Set `beacon'.
		require
			beacon_attached: a_beacon /= Void
		do
			beacon := a_beacon
		end

	set_status (a_status: BOOLEAN)
			-- Set status with `a_status'
		do
			status := a_status
		end

feature -- Execute

	execute (a_bp: BREAKPOINT; a_dm: DEBUGGER_MANAGER)
		do
			if beacon.item /= status then
				beacon.put (status)
			end
--			a_dm.application.set_execution_mode ({EXEC_MODES}.Step_into)
		end


end
