note
	description: "Base class for actions profile (feature call-application, profiling)."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SCOOP_PROFILER_ACTION_PROFILE

feature -- Access

	processor: SCOOP_PROFILER_PROCESSOR_PROFILE
			-- Reference to the processor profile

	start_time, stop_time: DATE_TIME
			-- Start and stop times

feature -- Timing

	duration: TIME_DURATION
			-- What's the duration of the action?
		require
			start_time /= Void
			stop_time /= Void
		do
			Result := stop_time.duration.minus (start_time.duration).time
		ensure
			result_not_void: Result /= Void
		end

feature -- Settings

	set_processor (a_processor: like processor)
			-- Set `processor` to `a_processor`.
		require
			processor_not_void: a_processor /= Void
		do
			processor := a_processor
		ensure
			processor_set: processor = a_processor
		end

	set_start_time (a_start: like start_time)
			-- Set `start_time` to `a_start`.
		require
			start_not_void: a_start /= Void
		do
			start_time := a_start
		ensure
			start_time_set: start_time = a_start
		end

	set_stop_time (a_stop: like stop_time)
			-- Set `stop_time` to `a_stop`.
		require
			stop_not_void: a_stop /= Void
		do
			stop_time := a_stop
		ensure
			stop_time_set: stop_time = a_stop
		end

invariant
	times_ok: (start_time /= Void and stop_time /= Void) implies (start_time <= stop_time and duration /= Void)

end
