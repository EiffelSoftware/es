note
	description: "Summary description for {AFX_PROGRAM_STATE_SUSPICIOUSNESS_VALUE_CALCULATOR_HEURISTICIII_OLD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_STATE_SUSPICIOUSNESS_VALUE_CALCULATOR_HEURISTICIII_OLD

inherit
	AFX_PROGRAM_STATE_SUSPICIOUSNESS_VALUE_CALCULATOR

feature -- Basic operation

	calculate_suspiciousness_value
			-- <Precursor>
		do
			last_suspiciousness_value := (w_f_1 * n_f_1 + w_f_2 * n_f_2 + w_f_3 * n_f_3) -
						(w_s_1 * n_s_1 + w_s_2 * n_s_2 + w_s_3 * n_s_3)
		end

feature{NONE} -- Access

	n_total_failing_test_cases: INTEGER
			-- Total number of failing test cases.

	n_total_successful_test_cases: INTEGER
			-- Total number of successful test cases.

	n_f_total: INTEGER
			-- Total number of failing test cases, where a program state has been observed.

	n_s_total: INTEGER
			-- Total number of successful test cases, where a program state has been observed.

	alpha: REAL
			-- Alpha value.

	n_f_1: INTEGER
			-- Actual number of test cases in the first group of failing.
		do
			if n_f_total > n_f_1_max then
				Result := n_f_1_max
			else
				Result := n_f_total
			end
		end

	n_f_2: INTEGER
			-- Actual number of test cases in the second group of failing.
		local
			l_n1: INTEGER
			l_rest: INTEGER
		do
			l_n1 := n_f_1
			l_rest := n_f_total - l_n1
			if l_rest > n_f_2_max then
				Result := n_f_2_max
			else
				Result := l_rest
			end
		end

	n_f_3: INTEGER
			-- Actual number of test cases in the third group of failing.
		do
			Result := n_f_total - n_f_1 - n_f_2
		end

	n_s_1: INTEGER
			-- Actual number of test cases in the first group of successful.
		do
			if n_s_total > n_s_1_max then
				Result := n_s_1_max
			else
				Result := n_s_total
			end
		end

	n_s_2: INTEGER
			-- Actual number of test cases in the second group of successful.
		local
			l_ns1: INTEGER
			l_rest: INTEGER
		do
			l_ns1 := n_s_1
			l_rest := n_s_total - l_ns1
			if l_rest > n_s_2_max then
				Result := n_s_2_max
			else
				Result := l_rest
			end
		end

	n_s_3: INTEGER
			-- Actual number of test cases in the third group of successful.
		do
			Result := n_s_total - n_s_1 - n_s_2
		end

	w_s_3: REAL
			-- Weight of each test case in the third group of successful.
		do
			if n_s_total /= 0 then
				Result := (alpha * (n_f_total / n_s_total)).truncated_to_real
			else
				Result := (alpha * n_f_total * 2)  -- as if `n_s_total' = 0.5
			end
		end

feature -- Status set

	set_test_case_numbers (a_total_succ, a_total_fail: INTEGER)
			-- Set the total number of successful/failing test cases.
		do
			n_total_successful_test_cases := a_total_succ
			n_total_failing_test_cases := a_total_fail
		end

	set_state_specific_numbers (a_succ, a_fail: INTEGER)
			-- Set the number of state-specific successful/failing test cases.
		do
			n_s_total := a_succ
			n_f_total := a_fail
		end

	set_alpha (a_alpha: REAL)
			-- Set `alpha'.
		do
			alpha := a_alpha
		end

feature -- Constants for failing

	w_f_1: REAL = 1.0
			-- Weight of each test case in the first group of failing.

	w_f_2: REAL = 0.1
			-- Weight of each test case in the second group of failing.

	w_f_3: REAL = 0.01
			-- Weight of each test case in the third group of failing.

	n_f_1_max: INTEGER = 2
			-- Maximal number of test cases in the first group of failing.

	n_f_2_max: INTEGER = 4
			-- Maximal number of test cases in the second group of failing.

feature -- Constants for passing

	w_s_1: REAL = 1.0
			-- Weight of each test case in the first group of successful.

	w_s_2: REAL = 0.1
			-- Weight of each test case in the second group of successful.

	n_s_1_max: INTEGER = 1
			-- Maximal number of test cases in the first group of successful.

	n_s_2_max: INTEGER = 4
			-- Maximal number of test cases in the second group of successful.

end
