note
	description: "Summary description for {AFX_PROGRAM_STATE_SUSPICIOUSNESS_VALUE_CALCULATOR_HEURISTICIII_NEW}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_STATE_SUSPICIOUSNESS_VALUE_CALCULATOR_HEURISTICIII_NEW

inherit
	AFX_PROGRAM_STATE_SUSPICIOUSNESS_VALUE_CALCULATOR

feature -- Basic operation

	calculate_suspiciousness_value
			-- <Precursor>
		local
			l_passing_weight, l_failing_weight: REAL_64
		do
			if passing_count = 0 then
				l_passing_weight := 0
			else
				l_passing_weight := Scale_factor_passing * (1 - Common_ratio_passing ^ passing_count) / (1 - Common_ratio_passing)
			end
			if failing_count = 0 then
				l_failing_weight := 0
			else
				l_failing_weight := Scale_factor_failing * (1 - Common_ratio_failing ^ failing_count) / (1 - Common_ratio_failing)
			end
			last_suspiciousness_value := (l_failing_weight - l_passing_weight).truncated_to_real
		end

feature -- Access

	passing_count: INTEGER
			-- Number of passing test cases where a program state has been observed.

	failing_count: INTEGER
			-- Number of failing test cases where a program state has been observed.

feature -- Status set

	set_passing_count (a_count: INTEGER)
			-- Set `passing_count'.
		do
			passing_count := a_count
		end

	set_failing_count (a_count: INTEGER)
			-- Set `failing_count'.
		do
			failing_count := a_count
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
