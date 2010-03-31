note
	description: "Processor profile."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_PROCESSOR_PROFILE

inherit
	SCOOP_PROFILER_HELPER
		export
			{NONE} all
		undefine
			default_create,
			copy,
			is_equal
		end

	COMPARABLE

create {SCOOP_PROFILER_APPLICATION_PROFILE}
	make

feature {NONE} -- Creation

	make
			-- Creation procedure.
		do
			create calls.make
		ensure
			calls_not_void: calls /= Void
		end

feature -- Access

	id: INTEGER
			-- Processor id

	calls: LINKED_LIST [SCOOP_PROFILER_ACTION_PROFILE]
			-- References to the calls and profiling actions

	start_time, stop_time: DATE_TIME
			-- Start and stop times

	application: SCOOP_PROFILER_APPLICATION_PROFILE
			-- Reference to the application profile

feature -- Timing

	profile_time: INTEGER
			-- How much time has been spent on profiling?
		local
			d: DATE_TIME_DURATION
		do
			create d.make_by_date_time (create {DATE_DURATION}.make_by_days (0), create {TIME_DURATION}.make_by_seconds (0))
			d.set_origin_date_time (epoch)
			from
				calls.start
			until
				calls.after
			loop
				if not attached {SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE} calls.item then
					d := d.plus (calls.item.stop_time.duration.minus (calls.item.start_time.duration))
				end
				calls.forth
			variant
				calls.count - calls.index + 1
			end
			Result := duration_to_milliseconds (d)
		ensure
			result_non_negative: Result >= 0
		end

	wait_time: INTEGER
			-- How much time has been spent waiting?
		local
			d: DATE_TIME_DURATION
		do
			create d.make_by_date_time (create {DATE_DURATION}.make_by_days (0), create {TIME_DURATION}.make_by_seconds (0))
			d.set_origin_date_time (epoch)
			from
				calls.start
			until
				calls.after
			loop
				if attached {SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE} calls.item as item then
					d := d.plus (item.application_time.duration.minus (item.sync_time.duration))
				end
				calls.forth
			variant
				calls.count - calls.index + 1
			end
			Result := duration_to_milliseconds (d)
		ensure
			result_non_negative: Result >= 0
		end

	execution_time: INTEGER
			-- How much time has been spent executing?
		local
			d: DATE_TIME_DURATION
		do
			create d.make_by_date_time (create {DATE_DURATION}.make_by_days (0), create {TIME_DURATION}.make_by_seconds (0))
			d.set_origin_date_time (epoch)
			from
				calls.start
			until
				calls.after
			loop
				if attached {SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE} calls.item as item then
					d := d.plus (item.return_time.duration.minus (item.application_time.duration))
				end
				calls.forth
			variant
				calls.count - calls.index + 1
			end
			Result := duration_to_milliseconds (d)
		ensure
			result_non_negative: Result >= 0
		end

feature -- Settings

	set_id (a_id: like id)
			-- Set `id` to `a_id`.
		require
			id_positive: a_id > 0
		do
			id := a_id
		ensure
			id_set: id = a_id
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

	set_application (a_application: like application)
			-- Set `application` to `a_application`.
		require
			application_not_void: a_application /= Void
		do
			application := a_application
		ensure
			application_set: application = a_application
		end

feature -- Comparison

	is_less alias "<" (a_other: like Current): BOOLEAN
			-- Is this less than `a_other`?
			-- Less means that this starts later than `a_other`, for use in HEAP_PRIORITY_QUEUE.
		do
			if start_time /= Void and (a_other /= Void and then a_other.start_time /= Void) then
				Result := start_time > a_other.start_time
			elseif not calls.is_empty and not a_other.calls.is_empty then
				Result := calls.first.start_time > a_other.calls.first.start_time
			end
		end

invariant
	calls_set: calls /= Void

	times_ok: (start_time /= Void and stop_time /= Void) implies start_time <= stop_time

end
