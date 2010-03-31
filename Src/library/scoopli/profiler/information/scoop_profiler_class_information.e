note
	description: "Class profiling information."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_CLASS_INFORMATION

create
	make

feature {NONE} -- Creation

	make
			-- Creation procedure.
		do
			create feature_names.make (0)
		ensure
			feature_names_not_void: feature_names /= Void
		end

feature -- Access

	name: STRING
			-- Class name

	feature_names: HASH_TABLE [STRING, INTEGER]
			-- Feature information
			-- key: feature id, value: feature name

feature -- Basic Operations

	set_name (a_name: like name)
			-- Set `name` to `a_name`.
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			name := a_name
		ensure
			name_set: name /= Void and then name.is_equal (a_name)
		end

invariant
	feature_names_not_void: feature_names /= Void

end
