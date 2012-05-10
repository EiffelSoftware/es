note
	description: "Access to shared Boogie universe instance."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_SHARED_BOOGIE_UNIVERSE

feature {NONE} -- Access

	boogie_universe: IV_UNIVERSE
			-- Shared boogie universe.
		do
			Result := boogie_universe_cell.item
		end

feature {NONE} -- Implementation

	boogie_universe_cell: CELL [IV_UNIVERSE]
			-- Once cell holding shared boogie universe instance.
		once
			create Result.put (Void)
		end

end
