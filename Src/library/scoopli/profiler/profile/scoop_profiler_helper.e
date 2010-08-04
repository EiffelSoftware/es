note
	description: "Helper for operations on durations."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SCOOP_PROFILER_HELPER

feature -- Access

	epoch: DATE_TIME
			-- Epoch
		once
			create Result.make_from_epoch (0)
		ensure
			result_not_void: Result /= Void
		end

feature -- Measurement

	duration_to_milliseconds (a_duration: DATE_TIME_DURATION): INTEGER
			-- What's the duration of `a_duration` in milliseconds?
		require
			duration_not_void: a_duration /= Void
		do
			a_duration.set_origin_date_time (epoch)
			Result := (a_duration.fine_seconds_count * 1_000).truncated_to_integer
		ensure
			result_non_negative: Result >= 0
		end

	integer_percentage (a_part, a_tot: INTEGER): INTEGER
			-- What percentage of `a_tot` is `a_part`?
		require
			part_non_negative: a_part >= 0
			tot_non_negative: a_tot >= 0
			part_of_tot: a_part <= a_tot
		do
			if a_tot > 0 and a_part > 0 then
				Result := ((a_part / a_tot) * 100).truncated_to_integer
			end
		ensure
			result_max: Result <= 100
			result_min: Result >= 0
		end

	duration_percentage (a_part, a_tot: DATE_TIME_DURATION): INTEGER
			-- What percentage of `a_tot` is `a_part`?
		require
			part_not_void: a_part /= Void
			tot_not_void: a_tot /= Void
			part_of_tot: a_part <= a_tot
		do
			a_part.set_origin_date_time (epoch)
			a_tot.set_origin_date_time (epoch)
			Result := integer_percentage ((a_part.fine_seconds_count * 1_000).truncated_to_integer, (a_tot.fine_seconds_count * 1_000).truncated_to_integer)
		ensure
			result_max: Result <= 100
			result_min: Result >= 0
		end

end
