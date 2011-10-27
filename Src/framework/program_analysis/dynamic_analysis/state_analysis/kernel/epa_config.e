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

	output_path: detachable STRING assign set_output
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

	is_dynamic_annotation_enabled: BOOLEAN
			-- Is annotation by dynamic means enabled?

	is_static_annotation_enabled: BOOLEAN
			-- Is annotation by static means enabled?

feature -- Setting

	set_is_dynamic_annotation_enabled (b: BOOLEAN)
			-- Set `is_dynamic_annotation_enabled' with `b'.
		do
			is_dynamic_annotation_enabled := b
		ensure
			is_dynamic_annotation_enabled_set: is_dynamic_annotation_enabled = b
		end

	set_is_static_annotation_enabled (b: BOOLEAN)
			-- Set `is_static_annotation_enabled' with `b'.
		do
			is_static_annotation_enabled := b
		ensure
			is_static_annotation_enabled_set: is_static_annotation_enabled = b
		end

	set_output (a_output_path: like output_path)
			-- Set `output' with `a_output'.
		do
			output_path := a_output_path
		end

end
