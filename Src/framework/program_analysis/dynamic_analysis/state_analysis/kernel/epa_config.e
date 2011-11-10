note
	description: "Configs for the annotation facilities"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_CONFIG

inherit
	SHARED_EXEC_ENVIRONMENT

create
	make

feature{NONE} -- Initialization

	make (a_system: like eiffel_system)
			-- Initialize Current.
		do
			eiffel_system := a_system
			create locations.make
			create variables.make
			create expressions.make
			create selected_program_locations.make_default
		ensure
			eiffel_system_set: eiffel_system = a_system
		end

feature -- Access

	eiffel_system: SYSTEM_I
			-- Current compiled system

	locations: LINKED_LIST [TUPLE [context_class: CLASS_C; feature_: FEATURE_I]]
			-- Locations where annotation collection should be performed

	variables: LINKED_LIST [STRING]
			-- Variables which should be used to construct interesting expressions

	expressions: LINKED_LIST [STRING]
			-- Expressions which should be evaluated

	selected_program_locations: DS_HASH_SET [INTEGER]
			-- Selected program locations which should be evaluated

	output_path: STRING assign set_output
			-- Output-path for storing the collected equations.

	working_directory: STRING
			-- Working directory of the project
		do
			Result := Execution_environment.current_working_directory
		end

	root_class: CLASS_C
			-- Root class in `system'.
		do
			Result := eiffel_system.root_type.associated_class
		end

feature -- Status report

	is_all_program_locations_specified: BOOLEAN
			-- Should all program locations be evaluated?

	is_variables_specified: BOOLEAN
			-- Are variables used to build expressions to evaluate specified?

	is_expressions_specified: BOOLEAN
			-- Are expressions to evaluate specified?

	is_output_path_specified: BOOLEAN
			-- Is a output path specified?

feature -- Setting

	set_is_all_program_locations_specified (b: BOOLEAN)
			-- Set `is_all_program_locations_specified' with `b'.
		do
			is_all_program_locations_specified := b
		ensure
			is_all_program_locations_specified_set: is_all_program_locations_specified = b
		end

	set_is_variables_specified (b: BOOLEAN)
			-- Set `is_variables_specified' with `b'.
		do
			is_variables_specified := b
		ensure
			is_variables_specified_set: is_variables_specified = b
		end

	set_is_expressions_specified (b: BOOLEAN)
			-- Set `is_expressions_specified' with `b'.
		do
			is_expressions_specified := b
		ensure
			is_expressions_specified_set: is_expressions_specified = b
		end

	set_is_output_path_specified (b: BOOLEAN)
			-- Set `is_output_path_specified' with `b'.
		do
			is_output_path_specified := b
		ensure
			is_output_path_specified_set: is_output_path_specified = b
		end

	set_output (a_output_path: like output_path)
			-- Set `output' with `a_output'.
		do
			output_path := a_output_path
		end

end
