note
	description: "Configuration specifying how a program should be dynamically analyzed."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_DYNAMIC_ANALYSIS_CONFIG

inherit
	SHARED_EXEC_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	make (a_system: like eiffel_system)
			-- Initialize `eiffel_system' with `a_system'.
		do
			eiffel_system := a_system
		ensure
			eiffel_system_set: eiffel_system = a_system
		end

feature -- Access

	eiffel_system: SYSTEM_I
			-- Current compiled system

	location: TUPLE [class_: CLASS_C; feature_: FEATURE_I]
			-- Location specifying the feature which should be dynamically analyzed

	variables: LINKED_LIST [STRING]
			-- Variables which should be used to construct expressions to be evaluated

	expressions: LINKED_LIST [STRING]
			-- Expressions which should be evaluated

	specific_prgm_locs: DS_HASH_SET [INTEGER]
			-- Specific program locations where expressions should be evaluated

	prgm_locs_with_exprs: DS_HASH_TABLE [DS_HASH_SET [STRING], INTEGER]
			-- Program locations where the associated expressions should
			-- be evaluated.

	output_path: STRING
			-- Output-path where the collected runtime data should be stored.

	working_directory: STRING
			-- Working directory of the project
		do
			Result := Execution_environment.current_working_directory
		end

	root_class: CLASS_C
			-- Root class in `eiffel_system'.
		do
			Result := eiffel_system.root_type.associated_class
		end

feature -- Status report

	is_aut_choice_of_prgm_locs_set: BOOLEAN
			-- Are the program locations where expressions should be
			-- evaluated automatically chosen?

	is_specific_prgm_locs_set: BOOLEAN
			-- Are specific program locations where expressions should
			-- be evaluated specified?

	is_all_prgm_locs_set: BOOLEAN
			-- Are expresions at all program locations evaluated?

	is_aut_choice_of_exprs_set: BOOLEAN
			-- Are expressions which are evaluated automatically chosen?

	is_specific_vars_set: BOOLEAN
			-- Are specific variables which are used to build expressions
			-- to be evaluated specified?

	is_specific_exprs_set: BOOLEAN
			-- Are specific expressions which are evaluated specified?

	is_prgm_locs_with_exprs_set: BOOLEAN
			-- Are program locations where the associated expressions should be
			-- evaluated specified?

	is_output_path_set: BOOLEAN
			-- Is a output path set?

feature -- Setting

	set_location (a_location: TUPLE [CLASS_C, FEATURE_I])
			-- Set `location' to `a_location'
		require
			a_location_not_void: a_location /= Void
		do
			location := a_location
		ensure
			location_set: location = a_location
		end

	set_variables (a_variables: LINKED_LIST [STRING])
			-- Set `variables' to `a_variables'
		require
			a_variables_not_void: a_variables /= Void
		do
			variables := a_variables
		ensure
			variables_set: variables = a_variables
		end

	set_expressions (a_expressions: LINKED_LIST [STRING])
			-- Set `expressions' to `a_expressions'
		require
			a_expressions_not_void: a_expressions /= Void
		do
			expressions := a_expressions
		ensure
			expressions_set: expressions = a_expressions
		end

	set_specific_prgm_locs (a_specific_prgm_locs: DS_HASH_SET [INTEGER])
			-- Set `specific_prgm_locs' to `a_specific_prgm_locs'
		require
			a_specific_prgm_locs_not_void: a_specific_prgm_locs /= Void
		do
			specific_prgm_locs := a_specific_prgm_locs
		ensure
			specific_prgm_locs_set: specific_prgm_locs = a_specific_prgm_locs
		end

	set_prgm_locs_with_exprs (a_prgm_locs_with_exprs: DS_HASH_TABLE [DS_HASH_SET [STRING], INTEGER])
			-- Set `prgm_locs_with_exprs' to `a_prgm_locs_with_exprs'
		require
			a_prgm_locs_with_exprs_not_void: a_prgm_locs_with_exprs /= Void
		do
			prgm_locs_with_exprs := a_prgm_locs_with_exprs
		ensure
			prgm_locs_with_exprs_set: prgm_locs_with_exprs = a_prgm_locs_with_exprs
		end

	set_is_aut_choice_of_prgm_locs_set (b: BOOLEAN)
			-- Set `is_aut_choice_of_prgm_locs_set' to `b'
		do
			is_aut_choice_of_prgm_locs_set := b
		ensure
			is_aut_choice_of_prgm_locs_set_set: is_aut_choice_of_prgm_locs_set = b
		end

	set_is_specific_prgm_locs_set (b: BOOLEAN)
			-- Set `is_specific_prgm_locs_set' to `b'
		do
			is_specific_prgm_locs_set := b
		ensure
			is_specific_prgm_locs_set_set: is_specific_prgm_locs_set = b
		end

	set_is_all_prgm_locs_set (b: BOOLEAN)
			-- Set `is_all_progm_locs_set' to `b'
		do
			is_all_prgm_locs_set := b
		ensure
			is_all_prgm_locs_set_set: is_all_prgm_locs_set = b
		end

	set_is_aut_choice_of_exprs_set (b: BOOLEAN)
			-- Set `is_aut_choice_of_exprs_set' to `b'
		do
			is_aut_choice_of_exprs_set := b
		ensure
			is_aut_choice_of_exprs_set_set: is_aut_choice_of_exprs_set = b
		end

	set_is_specific_vars_set (b: BOOLEAN)
			-- Set `is_specific_vars_set' to `b'
		do
			is_specific_vars_set := b
		ensure
			is_specific_vars_set_set: is_specific_vars_set = b
		end

	set_is_specific_exprs_set (b: BOOLEAN)
			-- Set `is_specific_exprs_set' to `b'
		do
			is_specific_exprs_set := b
		ensure
			is_specific_exprs_set: is_specific_exprs_set = b
		end

	set_is_prgm_locs_with_exprs_set (b: BOOLEAN)
			-- Set `is_prgm_locs_with_exprs_set' to `b'
		do
			is_prgm_locs_with_exprs_set := b
		ensure
			is_prgm_locs_with_exprs_set_set: is_prgm_locs_with_exprs_set = b
		end

	set_is_output_path_specified (b: BOOLEAN)
			-- Set `is_output_path_specified' to `b'.
		do
			is_output_path_set := b
		ensure
			is_output_path_set_set: is_output_path_set = b
		end

	set_output (a_output_path: like output_path)
			-- Set `output_path' to `a_output_path'.
		require
			a_output_path_not_void: a_output_path /= Void
		do
			output_path := a_output_path
		ensure
			output_path_set: output_path.is_equal (a_output_path)
		end

end
