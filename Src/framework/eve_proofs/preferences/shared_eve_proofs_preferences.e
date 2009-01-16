indexing
	description: "User preferences used in the interface."
	date: "$Date$"
	revision: "$Revision$"

class SHARED_EVE_PROOFS_PREFERENCES

feature -- Access

	preferences: EVE_PROOFS_PREFERENCES is
			-- All preferences for `EVE Proofs'.
		do
			Result := preferences_cell.item
		ensure
			preferences_not_void: Result /= Void
		end

feature -- Settings

	set_preferences (p: like preferences) is
			-- Set `preferences' to `p'.
		require
			c_not_void: p /= Void
		do
			preferences_cell.put (p)
		ensure
			preferences_set: preferences = p
		end

feature {NONE} -- Implementation

	preferences_cell: CELL [EVE_PROOFS_PREFERENCES] is
			-- Once cell.
		once
			create Result.put (create {EVE_PROOFS_PREFERENCES}.make (create {PREFERENCES}.make))
		ensure
			preferences_cell_not_void: Result /= Void
		end

end
