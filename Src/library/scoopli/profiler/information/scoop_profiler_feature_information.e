note
	description: "Feature profiling information."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_FEATURE_INFORMATION

create
	make

feature {NONE} -- Initialization

	make
			-- Creation procedure.
		do
			-- Do nothing
		end

feature -- Access

	name: STRING
			-- Name

	has_separate_arguments: BOOLEAN
			-- Has separate arguments?

feature -- Basic operations

	set_name (a_name: like name)
			-- Set `name` to `a_name`.
		require
			name_not_void: a_name /= Void and then not a_name.is_empty
		do
			name := a_name
		ensure
			name_set: name /= Void and then name.is_equal (a_name)
		end

	set_has_separate_arguments
			-- Set `has_separate_arguments` to True.
		do
			has_separate_arguments := True
		ensure
			has_separate_arguments
		end
end
