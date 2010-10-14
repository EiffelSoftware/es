note
	description: "Summary description for {AFX_PROGRAM_STATE_TRACE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_EXECUTION_TRACE

inherit
	LINKED_LIST [AFX_PROGRAM_EXECUTION_STATE]

create
	make_with_id

feature -- Initialization

	make_with_id (a_id: STRING)
			-- Initialize an execution trace with `a_id'.
		do
			make
			id := a_id
		end

feature -- Access

	id: STRING
			-- Execution trace id.

	execution_status: INTEGER
			-- Status of the execution related with current trace.

feature -- Status report

	is_passing: BOOLEAN
			-- Is current trace corresponding to a passing test case?
		do
			Result := execution_status = Execution_passing
		end

	is_failing: BOOLEAN
			-- Is current trace corresponding to a failing test case?
		do
			Result := execution_status = Execution_failing
		end

feature -- Status set

	set_status_as_failing
			-- Set `execution_status' as `Execution_failing'.
		do
			execution_status := Execution_failing
		end

	set_status_as_passing
			-- Set `execution_status' as `Execution_passing'.
		do
			execution_status := Execution_passing
		end

feature -- Constant

	Execution_unknown: INTEGER = 0
	Execution_passing: INTEGER = 1
	Execution_failing: INTEGER = 2

end
