note
	description: "Base class for events loaders."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SCOOP_PROFILER_LOADER

feature -- Access

	start, stop, min, max: DATE_TIME

feature -- Status setting

	set_min (a_min: like min)
			-- Set `min` to `a_min`.
		require
			min_greater_equal_start: a_min /= Void and then a_min >= start
		do
			min := a_min
		ensure
			min_set: min = a_min
		end

	set_max (a_max: like max)
			-- Set `max` to `a_max`.
		require
			max_less_equal_stop: a_max /= Void and then a_max <= stop
		do
			max := a_max
		ensure
			max_set: max = a_max
		end

	set_progress_action (a_action: like progress_action)
			-- Set `progress_action` to `a_action`.
		do
			progress_action := a_action
		ensure
			progress_action_set: progress_action = a_action
		end

feature -- Loading

	load (a_profile: SCOOP_PROFILER_APPLICATION_PROFILE; a_visitor: SCOOP_PROFILER_EVENT_VISITOR)
			-- Load `a_profile` using `a_visitor`.
		require
			profile_not_void: a_profile /= Void
			visitor_not_void: a_visitor /= Void
		deferred
		end

feature {SCOOP_PROFILER_EVENT_VISITOR} -- Basic operation

	delay (a_id: INTEGER)
			-- Delay events for processor `a_id`.
		require
			id_positive: a_id > 0
		deferred
		end

	resume (a_id: INTEGER)
			-- Resume events for processor `a_id`.
		require
			id_positive: a_id > 0
		deferred
		end

	continue (a_id: INTEGER)
			-- Continue with events for processor `a_id`.
		require
			id_positive: a_id > 0
		deferred
		end

feature {NONE} -- Implementation

	progress_action: PROCEDURE [ANY, TUPLE [DATE_TIME]]
			-- Reference to progress action

invariant
	times_ok: (start /= Void and stop /= Void) implies start <= stop
	limits_ok: (min /= Void and max /= Void) implies min <= max

end
