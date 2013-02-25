note
	description: "Summary description for {AFX_EXCEPTION_RECIPIENT_FEATURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EXCEPTION_RECIPIENT_FEATURE

inherit
	AFX_FEATURE_TO_MONITOR

create
	make_for_exception

feature{NONE} -- Initialization

	make_for_exception (a_exception: AFX_EXCEPTION_SIGNATURE)
			-- Initialization.
		require
			exception_attached: a_exception /= Void
		do
			exception := a_exception
			make (a_exception.recipient_feature, a_exception.recipient_class)
		end

feature -- Access

	exception: AFX_EXCEPTION_SIGNATURE
			-- Exception for Current.

feature -- Query

	control_distances_to_exception_point (a_breakpoint: INTEGER): INTEGER
			-- Control distance of `a_breakpoint' to the exception point.
			-- If the exception point is not reachable from `a_breakpoint' in the CFG,
			-- return `Control_distance_infinite'.
		local
			l_calculator: EPA_CONTROL_DISTANCE_CALCULATOR
		do
			if control_distance_report_regarding_exception_point = Void then
				create l_calculator.make
				l_calculator.calculate_within_feature (context_class, feature_, exception.recipient_breakpoint)
				control_distance_report_regarding_exception_point := l_calculator.last_report_concerning_bp_indexes
			end

			if control_distance_report_regarding_exception_point.has (a_breakpoint) then
				Result := control_distance_report_regarding_exception_point.item (a_breakpoint)
			else
				Result := Infinite_distance
			end
		end


feature{NONE} -- Access

	control_distance_report_regarding_exception_point: DS_HASH_TABLE [INTEGER, INTEGER]
			-- Control distance report mapping breakpoint indexes to their distances from the exception point.

end
