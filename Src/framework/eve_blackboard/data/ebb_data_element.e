note
	description: "Parent class for different data elements."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EBB_DATA_ELEMENT

feature -- Access

	correctness_confidence: REAL
			-- Confidence that this element is correct.

	last_check_time: detachable DATE_TIME
			-- Time of last check.

	last_check_tool: detachable EBB_TOOL
			-- Tool of last check.

feature -- Status report

	is_stale: BOOLEAN
			-- Is this data stale?

	has_correctness_confidence: BOOLEAN
			-- Does this element have a correctness confidence?
		do
			Result := correctness_confidence >= 0.0
		end

feature -- Status setting

	set_stale
			-- Set this data element to be stale.
		do
			is_stale := True
		ensure
			is_stale: is_stale
		end

	set_fresh
			-- Set this data element to be fresh.
		do
			is_stale := False
		ensure
			fresh: not is_stale
		end

feature -- Element change

	set_last_check_time (a_time: like last_check_time)
			-- Set `last_check_time' to `a_time'.
		do
			last_check_time := a_time
		ensure
			last_check_time_set: last_check_time = a_time
		end

	set_last_check_tool (a_tool: like last_check_tool)
			-- Set `last_check_tool' to `a_tool'.
		do
			last_check_tool := a_tool
		ensure
			last_check_tool_set: last_check_tool = a_tool
		end

feature -- Basic operations

	recalculate_correctness_confidence
			-- Recalculate `correctness_confidence'.
		deferred
		end

end
