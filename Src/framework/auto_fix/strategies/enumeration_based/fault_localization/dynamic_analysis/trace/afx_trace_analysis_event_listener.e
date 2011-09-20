note
	description: "Summary description for {AFX_TRACE_ANALYSIS_EVENT_LISTENER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_TRACE_ANALYSIS_EVENT_LISTENER

feature -- Access

	current_trace: AFX_PROGRAM_EXECUTION_TRACE
			-- Trace under analysis.

feature -- Status report

	is_trace_new (a_trace: AFX_PROGRAM_EXECUTION_TRACE): BOOLEAN
			-- Is `a_trace' new?
		require
			trace_attached: a_trace /= Void
		deferred
		end

feature -- Event handler

	on_trace_start (a_trace: AFX_PROGRAM_EXECUTION_TRACE)
			-- Action to take when a new trace starts.
		require
			is_trace_new: is_trace_new (a_trace)
		deferred
		ensure
			current_trace: current_trace = a_trace
		end

	on_new_state (a_trace: AFX_PROGRAM_EXECUTION_TRACE; a_state: AFX_PROGRAM_EXECUTION_STATE)
			-- Action to take on a new state.
		require
			trace_is_current: a_trace /= Void and then a_trace ~ current_trace
			state_attached: a_state /= Void
		deferred
		end

	on_trace_end (a_trace: AFX_PROGRAM_EXECUTION_TRACE)
			-- Action to take when a trace ends.
		deferred
		end

end
