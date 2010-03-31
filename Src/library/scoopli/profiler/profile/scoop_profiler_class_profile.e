note
	description: "Class profile."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_CLASS_PROFILE

inherit
	SCOOP_PROFILER_HELPER
		export
			{NONE} all
		end

create {SCOOP_PROFILER_APPLICATION_PROFILE}
	make

feature {NONE} -- Creation

	make
			-- Creation procedure.
		do
			create features.make (1)
		ensure
			features_not_void: features /= Void
		end

feature -- Access

	name: STRING
			-- Class name

	features: HASH_TABLE [SCOOP_PROFILER_FEATURE_PROFILE, STRING]
			-- References to feature profiles

	application: SCOOP_PROFILER_APPLICATION_PROFILE
			-- Reference to application profile

feature -- Basic operations

	set_name (a_name: like name)
			-- Set `name` to `a_name`.
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			name := a_name
		ensure
			name_set: name /= Void and then name.is_equal (a_name)
		end

	set_application (a_application: like application)
			-- Set `application` to `a_application`.
		require
			application_not_void: a_application /= Void
		do
			application := a_application
		ensure
			application_set: application = a_application
		end

invariant
	features_not_void: features /= Void

end
