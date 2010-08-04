note
	description: "Base class for processor events."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SCOOP_PROFILER_PROCESSOR_EVENT

inherit
	SCOOP_PROFILER_EVENT
		redefine
			out
		end

feature -- Access

	processor_id: INTEGER
			-- Processor id

feature -- Basic operations

	set_processor (a_id: like processor_id)
			-- Set `processor_id` to `a_id`.
		require
			id_positive: a_id > 0
		do
			processor_id := a_id
		ensure
			processor_id_set: processor_id = a_id
		end

	out: STRING
			-- What's the string representation of the current event?
		do
			create Result.make_from_string (Precursor)
			Result.append (" PROCESSOR " + processor_id.out)
		end

end
