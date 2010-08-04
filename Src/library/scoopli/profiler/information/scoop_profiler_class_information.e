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
			create features.make (0)
		ensure
			features_not_void: features /= Void
		end

feature -- Access

	name: STRING
			-- Class name

	features: HASH_TABLE [SCOOP_PROFILER_FEATURE_INFORMATION, INTEGER]
			-- Feature information
			-- key: feature id, value: feature

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
	features_not_void: features /= Void

end
