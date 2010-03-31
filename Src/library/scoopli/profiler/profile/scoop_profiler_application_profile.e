note
	description: "Application profile."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_APPLICATION_PROFILE

create
	make

feature {NONE} -- Creation

	make
			-- Creation procedure.
		do
			create processors.make (0)
			create classes.make (0)
		ensure
			processors_not_void: processors /= Void
			classes_not_void: classes /= Void
		end

feature -- Timing

	start_time: DATE_TIME
			-- What's the start time?
		do
			create Result.make_now_utc
			from
				processors.start
			until
				processors.after
			loop
				if not processors.item_for_iteration.calls.is_empty then
					Result := Result.min (processors.item_for_iteration.calls.first.start_time)
				end
				processors.forth
			end
		ensure
			result_not_void: Result /= Void
		end

	stop_time: DATE_TIME
			-- What's the stop time?
		do
			create Result.make (0, 1, 1, 0, 0, 0)
			from
				processors.start
			until
				processors.after
			loop
				if not processors.item_for_iteration.calls.is_empty then
					Result := Result.max (processors.item_for_iteration.calls.last.stop_time)
				end
				processors.forth
			end
		ensure
			result_not_void: Result /= Void
		end

feature -- Access

	processors: HASH_TABLE [like new_processor_profile, INTEGER]
			-- References to processor profiles

	classes: HASH_TABLE [like new_class_profile, STRING]
			-- References to class profiles

feature -- Ordering

	ordered_processors: ARRAYED_LIST [like new_processor_profile]
			-- List of processors ordered by starting time
		local
			hpq: HEAP_PRIORITY_QUEUE [like new_processor_profile]
		do
			create hpq.make (processors.count)
			from
				processors.start
			until
				processors.after
			loop
				if not processors.item_for_iteration.calls.is_empty then
					hpq.extend (processors.item_for_iteration)
				end
				processors.forth
			end
			Result := hpq.linear_representation
		ensure
			result_not_void: Result /= Void
		end

feature -- Factory

	new_processor_profile: SCOOP_PROFILER_PROCESSOR_PROFILE
			-- New processor profile
		do
			create Result.make
		ensure
			result_not_void: Result /= Void
		end

	new_class_profile: SCOOP_PROFILER_CLASS_PROFILE
			-- New class profile
		do
			create Result.make
		ensure
			result_not_void: Result /= Void
		end

	new_feature_profile: SCOOP_PROFILER_FEATURE_PROFILE
			-- New feature profile
		do
			create Result.make
		ensure
			result_not_void: Result /= Void
		end

	new_feature_call_application_profile: SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE
			-- New feature call-application profile
		do
			create Result.make
		ensure
			result_not_void: Result /= Void
		end

	new_profiling_profile: SCOOP_PROFILER_PROFILING_PROFILE
			-- New profiling profile
		do
			create Result.make
		ensure
			result_not_void: Result /= Void
		end

invariant
	processors_not_void: processors /= Void
	classes_not_void: classes /= Void
--	times_ok: (start_time /= Void and stop_time /= Void) implies start_time <= stop_time

end
