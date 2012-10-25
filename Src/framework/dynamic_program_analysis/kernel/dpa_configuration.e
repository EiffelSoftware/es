note
	description: "Configuration specifying how a program should be dynamically analyzed."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_CONFIGURATION

inherit
	SHARED_EXEC_ENVIRONMENT
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (a_eiffel_system: like eiffel_system)
			-- Initialize configuration.
		require
			a_eiffel_system_not_void: a_eiffel_system /= Void
		do
			eiffel_system := a_eiffel_system
		ensure
			eiffel_system_set: eiffel_system = a_eiffel_system
		end

feature -- Access

	eiffel_system: SYSTEM_I
			-- Current compiled system.

	class_: CLASS_C
			-- Context class of `feature_'.

	feature_: FEATURE_I
			-- Feature under analysis.

	variables: DS_HASH_SET [STRING]
			-- Variables which are used to build expressions.
			-- The built expressions are evaluated during analysis.

	expressions: DS_HASH_SET [STRING]
			-- Expressions which are evaluated during analysis.

	program_locations: DS_HASH_SET [INTEGER]
			-- Program locations which are used to evaluate expressions
			-- before and after the execution of a program location during analysis.

	localized_variables: DS_HASH_TABLE [DS_HASH_SET [INTEGER], STRING]
			-- Localized variables which are used to construct expressions.
			-- These expressions are evaluated before and after the execution of
			-- the associated program locations during analysis.
			-- Keys are variables.
			-- Values are progrm locations.

	localized_expressions: DS_HASH_TABLE [DS_HASH_SET [INTEGER], STRING]
			-- Expressions which are evaluated before and after the execution of
			-- its associated program locations during analysis.
			-- Keys are expressions.
			-- Values are program locations.

	json_file_writer_options: TUPLE [directory: STRING; file_name: STRING]
			-- JSON file writer options.

	mysql_writer_options:
		TUPLE [host: STRING; user: STRING; password: STRING; database: STRING; port: INTEGER]
			-- MYSQL writer options.

	working_directory: STRING
			-- Working directory of the project.
		do
			Result := execution_environment.current_working_directory
		end

	root_class: CLASS_C
			-- Root class in `eiffel_system'.
		do
			Result := eiffel_system.root_type.associated_class
		ensure
			Result_set: Result = eiffel_system.root_type.associated_class
		end

feature -- Status report

	is_program_location_search_option_used: BOOLEAN
			-- Is the program location search option used?

	is_program_locations_option_used: BOOLEAN
			-- Is the program locations option used?

	is_all_program_locations_option_used: BOOLEAN
			-- Is the all program locations option used?

	is_expression_search_option_used: BOOLEAN
			-- Is the expression search option used?

	is_variables_option_used: BOOLEAN
			-- Is the variables option used?

	is_expressions_option_used: BOOLEAN
			-- Is the expressions option used?

	is_localized_variables_option_used: BOOLEAN
			-- Is the localized variables option used?

	is_localized_expressions_option_used: BOOLEAN
			-- Is the localized expressions option used?

	is_json_file_writer_option_used: BOOLEAN
			-- Is the JSON file writer option used?

	is_mysql_writer_option_used: BOOLEAN
			-- Is the MYSQL writer option used?

feature {DPA_COMMAND_LINE_PARSER} -- Setting

	set_is_program_location_search_option_used (b: BOOLEAN)
			-- Set `is_program_location_search_option_used' to `b'.
		do
			is_program_location_search_option_used := b
		ensure
			is_program_location_search_option_used_set: is_program_location_search_option_used = b
		end

	set_is_program_locations_option_used (b: BOOLEAN)
			-- Set `is_program_locations_option_used' to `b'.
		do
			is_program_locations_option_used := b
		ensure
			is_program_locations_option_used_set: is_program_locations_option_used = b
		end

	set_is_all_program_locations_option_used (b: BOOLEAN)
			-- Set `is_all_program_locations_option_used' to `b'.
		do
			is_all_program_locations_option_used := b
		ensure
			is_all_program_locations_option_used_set: is_all_program_locations_option_used = b
		end

	set_is_expression_search_option_used (b: BOOLEAN)
			-- Set `is_expression_search_option_used' to `b'.
		do
			is_expression_search_option_used := b
		ensure
			is_expression_search_option_used_set: is_expression_search_option_used = b
		end

	set_is_variables_option_used (b: BOOLEAN)
			-- Set `is_variables_option_used' to `b'.
		do
			is_variables_option_used := b
		ensure
			is_variables_option_used_set: is_variables_option_used = b
		end

	set_is_expressions_option_used (b: BOOLEAN)
			-- Set `is_expressions_option_used' to `b'.
		do
			is_expressions_option_used := b
		ensure
			is_expressions_option_used_set: is_expressions_option_used = b
		end

	set_is_localized_variables_option_used (b: BOOLEAN)
			-- Set `is_localized_variables_option_used' to `b'.
		do
			is_localized_variables_option_used := b
		ensure
			is_localized_variables_option_used_set: is_localized_variables_option_used = b
		end

	set_is_localized_expressions_option_used (b: BOOLEAN)
			-- Set `is_localized_expressions_option_used' to `b'.
		do
			is_localized_expressions_option_used := b
		ensure
			is_localized_expressions_option_used_set: is_localized_expressions_option_used = b
		end

	set_is_json_file_writer_option_used (b: BOOLEAN)
			-- Set `is_json_file_writer_option_used' to `b'.
		do
			is_json_file_writer_option_used := b
		ensure
			is_json_file_writer_option_used_set: is_json_file_writer_option_used = b
		end

	set_is_mysql_writer_option_used (b: BOOLEAN)
			-- Set `is_mysql_writer_option_used' to `b'.
		do
			is_mysql_writer_option_used := b
		ensure
			is_mysql_writer_option_used_set: is_mysql_writer_option_used = b
		end

feature {DPA_COMMAND_LINE_PARSER} -- Setting

	set_class (a_class: like class_)
			-- Set `class_' to `a_class'.
		require
			a_class_not_void: a_class /= Void
		do
			class_ := a_class
		ensure
			class_set: class_ = a_class
		end

	set_feature (a_feature: like feature_)
			-- Set `feature_' to `a_feature'.
		require
			a_feature_not_void: a_feature /= Void
		do
			feature_ := a_feature
		ensure
			feature_set: feature_ = a_feature
		end

	set_program_locations (a_program_locations: like program_locations)
			-- Set `program_locations' to `a_program_locations'.
		require
			a_program_locations_not_void: a_program_locations /= Void
		do
			program_locations := a_program_locations
		ensure
			program_locations_set: program_locations = a_program_locations
		end

	set_variables (a_variables: like variables)
			-- Set `variables' to `a_variables'.
		require
			a_variables_not_void: a_variables /= Void
		do
			variables := a_variables
		ensure
			variables_set: variables = a_variables
		end

	set_expressions (a_expressions: like expressions)
			-- Set `expressions' to `a_expressions'.
		require
			a_expressions_not_void: a_expressions /= Void
		do
			expressions := a_expressions
		ensure
			expressions_set: expressions = a_expressions
		end

	set_localized_variables (a_localized_variables: like localized_variables)
			-- Set `localized_variables' to `a_localized_variables'.
		require
			a_localized_variables_not_void: a_localized_variables /= Void
		do
			localized_variables := a_localized_variables
		ensure
			localized_variables_set: localized_variables = a_localized_variables
		end

	set_localized_expressions (a_localized_expressions: like localized_expressions)
			-- Set `localized_expressions' to `a_localized_expressions'.
		require
			a_localized_expressions_not_void: a_localized_expressions /= Void
		do
			localized_expressions := a_localized_expressions
		ensure
			localized_expressions_set: localized_expressions = a_localized_expressions
		end

	set_json_file_writer_options (a_json_file_writer_options: like json_file_writer_options)
			-- Set `json_file_writer_options' to `a_json_file_writer_options'.
		require
			a_json_file_writer_options_not_void: a_json_file_writer_options /= Void
		do
			json_file_writer_options := a_json_file_writer_options
		ensure
			json_file_writer_options_set: json_file_writer_options = a_json_file_writer_options
		end

	set_mysql_writer_options (a_mysql_writer_options: like mysql_writer_options)
			-- Set `mysql_writer_options' to `a_mysql_writer_options'.
		require
			a_mysql_writer_options_not_void: a_mysql_writer_options /= Void
		do
			mysql_writer_options := a_mysql_writer_options
		ensure
			mysql_writer_options_set: mysql_writer_options = a_mysql_writer_options
		end

end
