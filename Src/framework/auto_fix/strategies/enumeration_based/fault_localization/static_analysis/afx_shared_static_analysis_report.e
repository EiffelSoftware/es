note
	description: "Summary description for {AFX_SHARED_STATIC_ANALYSIS_REPORT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_SHARED_STATIC_ANALYSIS_REPORT

inherit
	ANY
		undefine
			is_equal,
			copy
		end

feature -- Access

	control_distance_report: AFX_CONTROL_DISTANCE_REPORT assign set_control_distance_report
			-- Shared control distance report.
		do
			Result := control_distance_report_cell.item
		end

	exception_spot: AFX_EXCEPTION_SPOT assign set_exception_spot
			-- Information about the exception spot.
		do
			Result := exception_spot_cell.item
		end

feature -- Status set

	set_control_distance_report (a_report: like control_distance_report)
			-- Set `control_distance_report'.
		do
			control_distance_report_cell.put (a_report)
		end

	set_exception_spot (a_spot: AFX_EXCEPTION_SPOT)
			-- Set `exception_spot'.
		do
			exception_spot_cell.put (a_spot)
		end

feature{NONE} -- Shared storage

	control_distance_report_cell: CELL [AFX_CONTROL_DISTANCE_REPORT]
			-- Storage for `control_distance_report'.
		once
			create Result.put (Void)
		end

	exception_spot_cell: CELL [AFX_EXCEPTION_SPOT]
			-- Storage for `exception_spot'.
		once
			create Result.put (Void)
		end


end
