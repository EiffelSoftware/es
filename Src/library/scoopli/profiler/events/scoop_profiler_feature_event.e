note
	description: "Base class for feature related events."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SCOOP_PROFILER_FEATURE_EVENT

inherit
	SCOOP_PROFILER_PROCESSOR_EVENT
		redefine
			out
		end

feature -- Access

	class_name: STRING
			-- Class name

	feature_name: STRING
			-- Feature name

feature -- Basic operations

	set_class_name (a_name: like class_name)
			-- Set `class_name` to `a_name`.
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			class_name := a_name
		ensure
			class_name_set: class_name /= Void and then class_name.is_equal (a_name)
		end

	set_feature_name (a_name: like feature_name)
			-- Set `feature_name` to `a_name`.
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			feature_name := a_name
		ensure
			feature_name_set: feature_name /= Void and then feature_name.is_equal (a_name)
		end

	out: STRING
			-- What's the string representation of the current event?
		do
			create Result.make_from_string (Precursor)
			Result.append (" CLASS " + class_name)
			Result.append (" FEATURE " + feature_name)
		end

end
