note
	description: "Base class for visiting profiling events."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SCOOP_PROFILER_EVENT_VISITOR

feature {NONE} -- Access

	loader: SCOOP_PROFILER_LOADER
			-- Actual loader, this reads the events from a source

feature -- Status setting

	set_loader (a_loader: like loader)
			-- Set `loader` to `a_loader`.
		require
			loader_not_void: a_loader /= Void
		do
			loader := a_loader
		ensure
			loader_set: loader = a_loader
		end

feature {SCOOP_PROFILER_LOADER} -- Basic operation

	cleanup
			-- Cleanup.
		do
		end

feature {SCOOP_PROFILER_EVENT} -- Visitor

	visit_processor_start (a_event: SCOOP_PROFILER_PROCESSOR_START_EVENT)
			-- Visit processor start event.
		require
			event_not_void: a_event /= Void
		do
		end

	visit_processor_end (a_event: SCOOP_PROFILER_PROCESSOR_END_EVENT)
			-- Visit processor end event.
		require
			event_not_void: a_event /= Void
		do
		end

	visit_profiling_start (a_event: SCOOP_PROFILER_PROFILING_START_EVENT)
			-- Visit profiling start event.
		require
			event_not_void: a_event /= Void
		do
		end

	visit_profiling_end (a_event: SCOOP_PROFILER_PROFILING_END_EVENT)
			-- Visit profiling end event.
		require
			event_not_void: a_event /= Void
		do
		end

	visit_feature_external_call (a_event: SCOOP_PROFILER_FEATURE_EXTERNAL_CALL_EVENT)
			-- Visit external call event.
			-- (separate call, generated on caller processor)
		require
			event_not_void: a_event /= Void
		do
		end

	visit_feature_call (a_event: SCOOP_PROFILER_FEATURE_CALL_EVENT)
			-- Visit feature call event.
			-- (separate call, generated on called processor)
		require
			event_not_void: a_event /= Void
		do
		end

	visit_feature_wait (a_event: SCOOP_PROFILER_FEATURE_WAIT_EVENT)
			-- Visit feature sync event.
		require
			event_not_void: a_event /= Void
		do
		end

	visit_feature_application (a_event: SCOOP_PROFILER_FEATURE_APPLICATION_EVENT)
			-- Visit feature application event.
		require
			event_not_void: a_event /= Void
		do
		end

	visit_feature_return (a_event: SCOOP_PROFILER_FEATURE_RETURN_EVENT)
			-- Visit feature return event.
		require
			event_not_void: a_event /= Void
		do
		end

	visit_feature_wait_condition (a_event: SCOOP_PROFILER_FEATURE_WAIT_CONDITION_EVENT)
			-- Visit wait condition try event.
		require
			event_not_void: a_event /= Void
		do
		end

end
