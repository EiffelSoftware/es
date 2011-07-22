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

			create {LINKED_LIST [STRING]} target_types.make
			target_types.compare_objects
		end

feature -- Access

	eiffel_system: SYSTEM_I
			-- Current system.

	target_types: LIST [STRING]
		assign set_target_types
			-- Target class types for extraction.

	namespace: detachable STRING
		assign set_namespace
			-- Identifying the snippet source, i.e. project name.

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

	maximum_lines_of_code: INTEGER
			-- The allowed maximum lines of code for a snippet to be reported
			-- 0 means no limit. Default: 0.
			-- This option is used to ignore snippets which are too large.

	maximum_cfg_structure_level: INTEGER
			-- The allowed maximum structure levels for a snippet to be reported
			-- 0 means no limit. Default: 0.
			-- This option is used to ignore snippets which have too complicated control flow structures.

	snippet_log_file: detachable STRING
			-- If attached, the absolute path of the file used to log only snippets
			-- Default: Void

	should_extract_contract: BOOLEAN
			-- Should extract contracts from callees of snippets?
			-- Default: False

	should_normalize_variable_name: BOOLEAN
			-- Should normalize variable names in snippets?
			-- Default: False

feature -- Setting

	set_target_types (a_target_types: like target_types)
			-- Set `target_types' with `a_target_types'.
		require
			attached a_target_types
		do
			target_types := a_target_types.twin
		end

	set_namespace (a_namespace: like namespace)
			-- Set `namespace' with `a_namespace'.
		do
			if a_namespace = Void then
				namespace := Void
			else
				namespace := a_namespace.twin
				namespace.to_upper
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

	set_maximum_lines_of_code (i: INTEGER)
			-- Set `maximum_lines_of_code'with `i'.
		do
			maximum_lines_of_code := i
		end

	set_maximum_cfg_structure_level (i: INTEGER)
			-- Set `maximum_cfg_structure_level' with `i'.
		do
			maximum_cfg_structure_level := i
		end

	set_snippet_log_file (a_path: STRING)
			-- Set `snippet_log_file' with `a_path'.
		do
			snippet_log_file := a_path.twin
		end

	set_should_extract_contract (b: BOOLEAN)
			-- Set `should_extract_contract' with `b'.
		do
			should_extract_contract := b
		end

	set_should_normalize_variable_name (b: BOOLEAN)
			-- Set `should_normalize_variable_name' with `b'.
		do
			should_normalize_variable_name := b
		end

end
