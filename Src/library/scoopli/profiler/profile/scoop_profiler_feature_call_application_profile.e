note
	description: "Feature call-application profile (feature instance, single call)"
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE

inherit
	SCOOP_PROFILER_ACTION_PROFILE
		rename
			set_start_time as set_sync_time,
			start_time as sync_time,
			set_stop_time as set_return_time,
			stop_time as return_time
		undefine
			is_equal
		end

	COMPARABLE

create {SCOOP_PROFILER_APPLICATION_PROFILE}
	make

feature {NONE} -- Creation

	make
			-- Creation procedure.
		do
			create requested_processors.make
			create call_tree.make
			create wait_conditions.make
		ensure
			requested_processors_not_void: requested_processors /= Void
			call_tree_not_void: call_tree /= Void
			wait_conditions_not_void: wait_conditions /= Void
		end

feature -- Access

	feature_definition: SCOOP_PROFILER_FEATURE_PROFILE
			-- Reference to the feature profile

	caller_processor: SCOOP_PROFILER_PROCESSOR_PROFILE
			-- Reference to caller processor's profile

	requested_processors: LINKED_LIST [SCOOP_PROFILER_PROCESSOR_PROFILE]
			-- References to requested processors' profiles

	call_time, application_time: DATE_TIME
			-- Call and application times

	call_tree: LINKED_LIST [SCOOP_PROFILER_ACTION_PROFILE]
			-- References to internal calls/profilings

	wait_conditions: LINKED_LIST [DATE_TIME]
			-- List of wait condition try times

	synchronous: BOOLEAN
			-- Is this a synchronous call?

feature -- Status report

	is_incomplete: BOOLEAN
			-- Is data complete?

	is_local: BOOLEAN
			-- Is this a local call?
			-- (caller processor = called processor)
		do
			Result := caller_processor = processor
		ensure
			definition: Result = (caller_processor = processor)
		end

	is_external: BOOLEAN
			-- Is this an external call?
			-- (caller processor /= called processor)
		do
			Result := caller_processor /= processor
		ensure
			definition: Result = (caller_processor /= processor)
		end

feature -- Timing

	total_duration: TIME_DURATION
			-- How long is the total duration?
		do
			Result := return_time.duration.minus (call_time.duration).time
		ensure
			result_not_void: Result /= Void
		end

	queue_duration: TIME_DURATION
			-- How long did this feature queue?
		do
			Result := sync_time.duration.minus (call_time.duration).time
		ensure
			result_not_void: Result /= Void
		end

	sync_duration: TIME_DURATION
			-- How long did it take to synchronize?
			-- Aquire locks and test wait conditions.
		do
			Result := application_time.duration.minus (sync_time.duration).time
		ensure
			result_not_void: Result /= Void
		end

	execution_duration: TIME_DURATION
			-- How long was the execution?
		do
			Result := return_time.duration.minus (application_time.duration).time
		ensure
			result_not_void: Result /= Void
		end

	wait_duration: TIME_DURATION
			-- How long did this feature wait?
			-- Wait for internal feature calls and profiling times.
		do
			create Result.make_by_seconds (0)
			from
				call_tree.start
			variant
				call_tree.count - call_tree.index + 1
			until
				call_tree.after
			loop
				if attached {SCOOP_PROFILER_PROFILING_PROFILE} call_tree.item as t_profile then
					-- This is a profiling action.
					Result := Result.plus (t_profile.duration)
				elseif attached {SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE} call_tree.item as t_call then
					-- This is an internal call
					if t_call.is_external and t_call.synchronous then
						-- Synchronous: add entire duration.
						Result := Result.plus (t_call.total_duration)
					elseif t_call.is_local then
						-- Local call: don't add queue time.
						Result := Result.plus (t_call.sync_duration)
					end
				end
				call_tree.forth
			end
		ensure
			result_not_void: Result /= Void
		end

feature -- Settings

	set_synchronous (a_sync: like synchronous)
			-- Set `synchronous` to `a_sync`.
		do
			synchronous := a_sync
		ensure
			synchronous_set: synchronous = a_sync
		end

	set_definition (a_feature: like feature_definition)
			-- Set `feature_definition` to `a_feature`.
		require
			feature_definition_not_void: a_feature /= Void
		do
			feature_definition := a_feature
		ensure
			feature_definition_set: feature_definition = a_feature
		end

	set_caller_processor (a_processor: like caller_processor)
			-- Set `caller_processor` to `a_processor`.
		require
			processor_not_void: a_processor /= Void
		do
			caller_processor := a_processor
		ensure
			caller_processor_set: caller_processor = a_processor
		end

	set_call_time (a_time: like call_time)
			-- Set `call_time` to `a_time`.
		require
			time_not_void: a_time /= Void
		do
			call_time := a_time
		ensure
			call_time_set: call_time = a_time
		end

	set_application_time (a_time: like application_time)
			-- Set `application` to `a_time`.
		require
			time_not_void: a_time /= Void
		do
			application_time := a_time
		ensure
			application_time_set: application_time = a_time
		end

	set_incomplete
			-- Set inclomplete data flag.
		do
			is_incomplete := True
		ensure
			is_incomplete: is_incomplete
		end

feature -- Comparable

	is_less alias "<" (a_other: like Current): BOOLEAN
			-- Is this less than `a_other`?
			-- Less means that this feature starts after other (for use in HEAP_PRIORITY_QUEUE).
		do
			if call_time /= Void and (a_other /= Void and then a_other.call_time /= Void) then
				Result := call_time > a_other.call_time
			end
		end

invariant
	wait_conditions_not_void: wait_conditions /= Void
	requested_processors_not_void: requested_processors /= Void
	call_tree_not_void: call_tree /= Void

	call_before_sync: (call_time /= Void and sync_time /= Void) implies (call_time <= sync_time and queue_duration /= Void)
	wait_before_application: (sync_time /= Void and application_time /= Void) implies (sync_time <= application_time and sync_duration /= Void )
	application_before_return: (application_time /= Void and return_time /= Void) implies (application_time <= return_time and execution_duration /= Void)
	total_duration: (call_time /= Void and return_time /= Void) implies total_duration /= Void

	not_local_and_external: is_local = not is_external

end
