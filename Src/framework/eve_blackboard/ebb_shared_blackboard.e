note
	description: "Access to shared instance of the EVE blackboard."
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_SHARED_BLACKBOARD

feature {NONE} -- Access

	blackboard: EBB_BLACKBOARD
			-- Shared blackboard.
		once
			create Result.make
		end

end
