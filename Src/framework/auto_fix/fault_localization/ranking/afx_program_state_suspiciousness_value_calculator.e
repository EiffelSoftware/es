note
	description: "Summary description for {AFX_PROGRAM_STATE_SUSPICIOUSNESS_VALUE_CALCULATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_STATE_SUSPICIOUSNESS_VALUE_CALCULATOR

create
	default_create

feature -- Basic operation

	suspiciousness_value (a_passing_count, a_failing_count: INTEGER_32): REAL_32
			-- Suspiciousness value based on the count of hits in passing and failing executions.
		local
			l_passing_weight, l_failing_weight: REAL_64
		do
			if a_passing_count = 0 then
				l_passing_weight := 0
			else
				l_passing_weight := Scale_factor_passing.to_double * (1 - Common_ratio_passing ^ a_passing_count.to_double) / (1 - Common_ratio_passing).to_double
			end
			if a_failing_count = 0 then
				l_failing_weight := 0
			else
				l_failing_weight := Scale_factor_failing.to_double * (1 - Common_ratio_failing ^ a_failing_count.to_double) / (1 - Common_ratio_failing).to_double
			end
			Result := (l_failing_weight - l_passing_weight).truncated_to_real
		end

feature -- Constant

	Scale_factor_passing: REAL_32 = 0.66666
			-- Weight of the first hit in passing execution.

	Scale_factor_failing: REAL_32 = 1.0
			-- Weight of the first hit in failing execution.

	Common_ratio_passing: REAL_32 = 0.33333
			-- Weight ratio of a subsequent hit to a previous one in passing executions.

	Common_ratio_failing: REAL_32 = 0.33333
			-- Weight ratio of a subsequent hit to a previous one in failing executions.

end
