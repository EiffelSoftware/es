note
	description: "Base class for all profiling events."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SCOOP_PROFILER_EVENT

inherit
	ANY
		redefine
			out
		end

feature {NONE} -- Creation

	make_now
			-- Create with actual time.
		do
			create time.make_now_utc
		ensure
			time_not_void: time /= Void
		end

	make_with_time (a_time: DATE_TIME)
			-- Create with given time.
		require
			time_not_void: a_time /= Void
		do
			time := a_time
		ensure
			time_set: time = a_time
		end

feature -- Access

	time: DATE_TIME
			-- Time when the event happened

	code: STRING
			-- Code of the event
		deferred
		end

feature -- Basic operations

	out: STRING
			-- String representation of the event
		do
			Result := "TIME " + time.out
		ensure then
			result_ok: Result /= Void and then not Result.is_empty
		end

feature -- Visitor

	visit (a_visitor: SCOOP_PROFILER_EVENT_VISITOR)
			-- Let `a_visitor` visit this.
		require
			visitor_not_void: a_visitor /= Void
		deferred
		end

feature {NONE} -- Implementation

	set_time (a_time: like time)
			-- Set `time` to `a_time`.
		require
			time_not_void: a_time /= Void
		do
			time := a_time
		ensure
			time_set: time = a_time
		end

invariant
	time_not_void: time /= Void

end
