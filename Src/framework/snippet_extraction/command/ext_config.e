note
	description: "Options for snippet extraction engine."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_CONFIG

inherit
	KL_SHARED_STRING_EQUALITY_TESTER

create
	make

feature {NONE} -- Initialization

	make (a_system: like eiffel_system)
			-- Initialize `eiffel_system' with `a_system'.
		require
			a_system_not_void: attached a_system
		do
			eiffel_system := a_system
		end

feature -- Access

	eiffel_system: SYSTEM_I
			-- Current system.

	target_type: STRING
		assign set_target_type
			-- Target class type for extraction.

	class_name: detachable STRING
		assign set_class_name
			-- Class context for mining where `feature_name' can be found.

	feature_name: detachable STRING
		assign set_feature_name
			-- Feature from `class_name' that for mining. 		

	group_name: detachable STRING
		assign set_group_name
			-- Name of library or cluster that restricts search space for classes.

	output: detachable STRING
		assign set_output
			-- Output directory for some operations.

	log_file_name: detachable STRING
		assign set_log_file_name
			-- File name used to write logging information to.

feature -- Setting

	set_target_type (a_target_type: like target_type)
			-- Set `target_type' with `a_target_type'.
		do
			if a_target_type = Void then
				target_type := Void
			else
				target_type := a_target_type.twin
			end
		end

	set_class_name (a_class_name: like class_name)
			-- Set `class_name' with `a_class_name'.
		do
			if a_class_name = Void then
				class_name := Void
			else
				class_name := a_class_name.twin
				class_name.to_upper
			end
		end

	set_feature_name (a_feature_name: like feature_name)
			-- Set `feature_name' with `a_feature_name'.
		do
			if a_feature_name = Void then
				feature_name := Void
			else
				feature_name := a_feature_name.twin
			end
		end

	set_group_name (a_group_name: like group_name)
			-- Set `group_name' with `a_group_name'.
		do
			if a_group_name = Void then
				group_name := Void
			else
				group_name := a_group_name.twin
			end
		end

	set_output (a_output: like output)
			-- Set `output' with `a_output'.
		do
			output := a_output
		end

	set_log_file_name (a_log_file_name: like log_file_name)
			-- Set `log_file_name' with `a_log_file_name'.
		do
			log_file_name := a_log_file_name
		end

end
