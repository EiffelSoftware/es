note
	description: "Summary description for {AFX_DELAYED_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_DELAYED_STATE

inherit
	EPA_STATE
		redefine
			is_delayed
		end

create
	make_as_failing_invariants,
	make_as_passing_invariants,
	make_as_passing_substracted_from_failing_invariants

feature{NONE} -- Initialization

	make_as_failing_invariants
			-- Initialize.
		do
			actual_state_function := agent failing_invariants
		end

	make_as_passing_invariants
			-- Initialize.
		do
			actual_state_function := agent passing_invariants
		end

	make_as_passing_substracted_from_failing_invariants
			-- Initialize.
		do
			actual_state_function := agent passing_substracted_from_failing_invariants
		end

feature -- Access

	invariants_in_passing_runs: detachable EPA_STATE
			-- State invariants in passing runs
			-- The break point slot from which this state is retrieved is not specified.

	invariants_in_failing_runs: detachable EPA_STATE
			-- State invariants in failing runs
			-- The break point slot from which this state is retrieved is not specified.

	actual_state: detachable EPA_STATE
			-- Actual state calculated by `actual_state_function' based on `invariants_in_passing_runs' and
			-- `invariants_in_failing_runs'
		do
			Result := actual_state_function.item ([invariants_in_passing_runs, invariants_in_failing_runs])
		end

	actual_state_function: FUNCTION [ANY, TUPLE [a_passing_inv, a_failing_inv: detachable EPA_STATE], detachable EPA_STATE]
			-- Action to return the `actual_state' based on `a_passing_inv' and `a_failing_inv'

feature -- Status report

	is_delayed: BOOLEAN = True
			-- <Precursor>

feature -- Setting

	set_invariants_in_passing_runs (a_state: like invariants_in_passing_runs)
			-- Set `invariants_in_passing_runs' with `a_state'.
		do
			invariants_in_passing_runs := a_state
		ensure
			invariants_in_passing_runs_set: invariants_in_passing_runs = a_state
		end

	set_invariants_in_failing_runs (a_state: like invariants_in_failing_runs)
			-- Set `invariants_in_failing_runs' with `a_state'.
		do
			invariants_in_failing_runs := a_state
		ensure
			invariants_in_failing_runs_set: invariants_in_failing_runs = a_state
		end

feature{NONE} -- Implementation

	failing_invariants (a_passing_inv, a_failing_inv: detachable EPA_STATE): detachable EPA_STATE
			-- Return `a_failing_inv'
		do
			Result := a_failing_inv
			if Result = Void and then a_passing_inv /= Void then
				create Result.make (0, a_passing_inv.class_, a_passing_inv.feature_)
			end
		end

	passing_invariants (a_passing_inv, a_failing_inv: detachable EPA_STATE): detachable EPA_STATE
			-- Return `a_passing_inv'
		do
			Result := a_passing_inv
		ensure
			result_set: Result = a_passing_inv
		end

	passing_substracted_from_failing_invariants (a_passing_inv, a_failing_inv: detachable EPA_STATE): detachable EPA_STATE
			-- Return the substraction: `a_passing_inv' - `a_failing_inv'.
		do
			if a_passing_inv = Void then
				Result := Void
			else
				if a_failing_inv = Void then
					Result := a_passing_inv
				else
					Result := a_passing_inv.subtraction (a_failing_inv)
				end
			end
		end

end
