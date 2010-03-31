note
	description: "Feature profile, intended as all the call-applications of this feature definition."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_FEATURE_PROFILE

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

	name: STRING
			-- Feature name

	calls: LINKED_LIST [SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE]
			-- References to single call-application profiles

	class_definition: SCOOP_PROFILER_CLASS_PROFILE
			-- Reference to the class profile

feature -- Settings

	set_class_definition (a_class: like class_definition)
			-- Set `class_definition` to `a_class`.
		require
			class_not_void: a_class /= Void
		do
			class_definition := a_class
		ensure
			class_definition_set: class_definition = a_class
		end

	set_name (a_name: like name)
			-- Set `name` to `a_name`.
		require
			name_not_emplty: a_name /= Void and then not a_name.is_empty
		do
			name := a_name
		ensure
			name_set: name /= Void and then name.is_equal (a_name)
		end

feature -- Counting

	average_wait_condition_tries: DOUBLE
			-- How many wait condition tries in average?
		do
			if not calls.is_empty then
				Result := total_wait_condition_tries / calls.count
			end
		ensure
			result_non_negative: Result >= 0
		end

	total_wait_condition_tries: INTEGER
			-- How many wait condition tries in total?
		do
			from
				calls.start
			until
				calls.after
			loop
				Result := Result + calls.item.wait_conditions.count
				calls.forth
			end
		ensure
			result_non_negative: Result >= 0
		end

feature -- Timing

	stddev_execution_time: INTEGER
			-- What's the standard deviation of the execution times?
		local
			l_average: INTEGER
			l_sum: DOUBLE
		do
			if not calls.is_empty then
				l_average := average_execution_time
				from
					calls.start
				variant
					calls.count - calls.index + 1
				until
					calls.after
				loop
					l_sum := l_sum + ((calls.item.execution_duration.fine_seconds_count * 1_000) - l_average).power (2)
					calls.forth
				end
				Result := (l_sum / calls.count).power (1/2).truncated_to_integer
			end
		ensure
			result_non_negative: Result >= 0
		end

	average_execution_time: INTEGER
			-- What's the average execution time?
		do
			if not calls.is_empty then
				Result := total_execution_time // calls.count
			end
		ensure
			result_non_negative: Result >= 0
		end

	total_execution_time: INTEGER
			-- What's the total execution time?
		local
			d: TIME_DURATION
		do
			if not calls.is_empty then
				create d.make_by_seconds (0)
				from
					calls.start
				variant
					calls.count - calls.index + 1
				until
					calls.after
				loop
					d := d.plus (calls.item.execution_duration)
					calls.forth
				end
				Result := (d.fine_seconds_count * 1_000).truncated_to_integer
			end
		ensure
			result_non_negative: Result >= 0
		end

	stddev_sync_time: INTEGER
			-- What's the standard deviation of synchronization times?
		local
			l_average: INTEGER
			l_sum: DOUBLE
		do
			if not calls.is_empty then
				l_average := average_sync_time
				from
					calls.start
				variant
					calls.count - calls.index + 1
				until
					calls.after
				loop
					l_sum := l_sum + ((calls.item.sync_duration.fine_seconds_count * 1_000) - l_average).power (2)
					calls.forth
				end
				Result := (l_sum / calls.count).power (1/2).truncated_to_integer
			end
		ensure
			result_non_negative: Result >= 0
		end

	average_sync_time: INTEGER
			-- What's the average synchronization time?
		do
			if not calls.is_empty then
				Result := total_sync_time // calls.count
			end
		ensure
			result_non_negative: Result >= 0
		end

	total_sync_time: INTEGER
			-- What's the total synchronization time?
		local
			d: TIME_DURATION
		do
			if not calls.is_empty then
				create d.make_by_seconds (0)
				from
					calls.start
				variant
					calls.count - calls.index + 1
				until
					calls.after
				loop
					d := d.plus (calls.item.sync_duration)
					calls.forth
				end
				Result := (d.fine_seconds_count * 1_000).truncated_to_integer
			end
		ensure
			result_non_negative: Result >= 0
		end

	stddev_queue_time: INTEGER
			-- What's the standard deviation of queue times?
		local
			l_average: INTEGER
			l_sum: DOUBLE
		do
			if not calls.is_empty then
				l_average := average_queue_time
				from
					calls.start
				variant
					calls.count - calls.index + 1
				until
					calls.after
				loop
					l_sum := l_sum + ((calls.item.queue_duration.fine_seconds_count * 1_000) - l_average).power (2)
					calls.forth
				end
				Result := (l_sum / calls.count).power (1/2).truncated_to_integer
			end
		ensure
			result_non_negative: Result >= 0
		end

	average_queue_time: INTEGER
			-- What's the average queue time?
		do
			if not calls.is_empty then
				Result := total_queue_time // calls.count
			end
		ensure
			result_non_negative: Result >= 0
		end

	total_queue_time: INTEGER
			-- What's the total queue time?
		local
			d: TIME_DURATION
		do
			if not calls.is_empty then
				create d.make_by_seconds (0)
				from
					calls.start
				variant
					calls.count - calls.index + 1
				until
					calls.after
				loop
					d := d.plus (calls.item.queue_duration)
					calls.forth
				end
				Result := (d.fine_seconds_count * 1_000).truncated_to_integer
			end
		ensure
			result_non_negative: Result >= 0
		end

	average_wait_time: INTEGER
			-- What's the average wait time?
		do
			if not calls.is_empty then
				Result := total_wait_time // calls.count
			end
		ensure
			result_non_negative: Result >= 0
		end

	total_wait_time: INTEGER
			-- What's the total wait time?
		local
			d: TIME_DURATION
		do
			if not calls.is_empty then
				create d.make_by_seconds (0)
				from
					calls.start
				variant
					calls.count - calls.index + 1
				until
					calls.after
				loop
					d := d.plus (calls.item.wait_duration)
					calls.forth
				end
				Result := (d.fine_seconds_count * 1_000).truncated_to_integer
			end
		ensure
			result_non_negative: Result >= 0
		end

invariant
	calls_not_void: calls /= Void

end
