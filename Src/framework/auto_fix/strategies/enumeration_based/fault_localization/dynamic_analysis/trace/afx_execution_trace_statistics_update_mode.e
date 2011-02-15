note
	description: "Summary description for {AFX_EXECUTION_TRACE_STATISTIC_MERGE_MODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_EXECUTION_TRACE_STATISTICS_UPDATE_MODE

inherit
	ANY
		undefine
			is_equal,
			copy
		end

feature -- Status report

	is_valid_update_mode (a_mode: INTEGER): BOOLEAN
			-- Is `a_mode' a valid update mode?
		do
			Result := a_mode = Update_mode_replace or is_valid_merge_mode (a_mode)
		end

	is_valid_merge_mode (a_mode: INTEGER): BOOLEAN
			-- Is `a_mode' a valid merge mode?
		do
			Result := a_mode = Update_mode_merge_presence or else a_mode = Update_mode_merge_occurrence
		end

feature -- Constant

	Update_mode_replace: INTEGER = 1
	Update_mode_merge_presence: INTEGER = 2
	Update_mode_merge_occurrence: INTEGER = 3

end
