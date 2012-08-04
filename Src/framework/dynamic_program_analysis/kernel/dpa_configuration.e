note
	description: "Configuration specifying how a program should be dynamically analyzed."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_CONFIGURATION

inherit
	SHARED_EXEC_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	make (a_eiffel_system: like eiffel_system)
			-- Initialize `eiffel_system' with `a_eiffel_system'.
		require
			a_eiffel_system_not_void: a_eiffel_system /= Void
		do
			eiffel_system := a_eiffel_system
		ensure
			eiffel_system_set: eiffel_system = a_eiffel_system
		end

feature -- Access

	eiffel_system: SYSTEM_I
			-- Current compiled system

	class_: CLASS_C
			-- Class belonging to `feature_'

	feature_: FEATURE_I
			-- Feature under analysis

	variables: DS_HASH_SET [STRING]
			-- Variables used to construct expressions which are evaluated

	expressions: DS_HASH_SET [STRING]
			-- Expressions which are evaluated

	locations: DS_HASH_SET [INTEGER]
			-- Program locations at which expressions are evaluated

	locations_with_expressions: DS_HASH_TABLE [DS_HASH_SET [STRING], INTEGER]
			-- Expressions which are evaluated at a specific program location

	locations_with_variables: DS_HASH_TABLE [DS_HASH_SET [STRING], INTEGER]
			-- Variables used to construct expressions which are evaluated at a specific program location

	single_json_data_file_writer_options: TUPLE [output_path: STRING; file_name: STRING]
			-- Options used for writing a single JSON data file.

	multiple_json_data_files_writer_options: TUPLE [output_path: STRING; file_name_prefix: STRING]
			-- Options used for writing multiple JSON data files.

	serialized_data_files_writer_options: TUPLE [output_path: STRING; file_name_prefix: STRING]
			-- Options used for writing serialized data files.

	mysql_data_writer_options: TUPLE [host: STRING; user: STRING; password: STRING; database: STRING; port: INTEGER]
			-- Options used for writing a MYSQL database.

	working_directory: STRING
			-- Working directory of the project
		do
			Result := execution_environment.current_working_directory
		end

	root_class: CLASS_C
			-- Root class in `eiffel_system'.
		require
			eiffel_system_not_void: eiffel_system /= Void
		do
			Result := eiffel_system.root_type.associated_class
		ensure
			Result_set: Result = eiffel_system.root_type.associated_class
		end

feature -- Status report

	is_location_search_activated: BOOLEAN
			-- Are the program locations automatically chosen?

	is_set_of_locations_given: BOOLEAN
			-- Is a set of locations given?

	is_usage_of_all_locations_activated: BOOLEAN
			-- Are all program locations chosen?

	is_expression_search_activated: BOOLEAN
			-- Are expressions which are evaluated automatically chosen?

	is_set_of_variables_given: BOOLEAN
			-- Is a set of variables given?

	is_set_of_expressions_given: BOOLEAN
			-- Is a set of expressions given?

	is_set_of_locations_with_expressions_given: BOOLEAN
			-- Is a set of locations with expressions given?

	is_set_of_locations_with_variables_given: BOOLEAN
			-- Is a set of locations with variables given?

	is_single_json_data_file_writer_selected: BOOLEAN
			-- Is a single JSON data file writerselected?

	is_multiple_json_data_files_writer_selected: BOOLEAN
			-- Is a multiple JSON data files writer selected?

	is_serialized_data_files_writer_selected: BOOLEAN
			-- Is a serialized data files writer selected?

	is_mysql_data_writer_selected: BOOLEAN
			-- Is a MYSQL database writer selected?

feature -- Setting

	set_class (a_class: like class_)
			-- Set `class_' to `a_class'
		require
			a_class_not_void: a_class /= Void
		do
			class_ := a_class
		ensure
			class_set: class_ = a_class
		end

	set_feature (a_feature: like feature_)
			-- Set `feature_' to `a_feature'
		require
			a_feature_not_void: a_feature /= Void
		do
			feature_ := a_feature
		ensure
			feature_set: feature_ = a_feature
		end

	set_variables (a_variables: like variables)
			-- Set `variables' to `a_variables'
		require
			a_variables_not_void: a_variables /= Void
		do
			variables := a_variables
		ensure
			variables_set: variables = a_variables
		end

	set_expressions (a_expressions: like expressions)
			-- Set `expressions' to `a_expressions'
		require
			a_expressions_not_void: a_expressions /= Void
		do
			expressions := a_expressions
		ensure
			expressions_set: expressions = a_expressions
		end

	set_locations (a_locations: like locations)
			-- Set `locations' to `a_locations'
		require
			a_locations_not_void: a_locations /= Void
		do
			locations := a_locations
		ensure
			locations_set: locations = a_locations
		end

	set_locations_with_expressions (a_locations_with_expressions: like locations_with_expressions)
			-- Set `locations_with_expressions' to `a_locations_with_expressions'
		require
			a_locations_with_expressions_not_void: a_locations_with_expressions /= Void
		do
			locations_with_expressions := a_locations_with_expressions
		ensure
			locations_with_expressions_set: locations_with_expressions = a_locations_with_expressions
		end

	set_locations_with_variables (a_locations_with_variables: like locations_with_variables)
			-- Set `locations_with_variables' to `a_locations_with_variables'
		require
			a_locations_with_variables_not_void: a_locations_with_variables /= Void
		do
			locations_with_variables := a_locations_with_variables
		ensure
			locations_with_variables_set: locations_with_variables = a_locations_with_variables
		end

	set_single_json_data_file_writer_options (a_single_json_data_file_writer_options: like single_json_data_file_writer_options)
			-- Set `single_json_data_file_writer_options' to `a_single_json_data_file_writer_options'.
		require
			a_single_json_data_file_writer_options_not_void: a_single_json_data_file_writer_options /= Void
		do
			single_json_data_file_writer_options := a_single_json_data_file_writer_options
		ensure
			single_json_data_file_writer_options_set: single_json_data_file_writer_options = a_single_json_data_file_writer_options
		end

	set_multiple_json_data_files_writer_options (a_multiple_json_data_files_writer_options: like multiple_json_data_files_writer_options)
			-- Set `multiple_json_data_files_writer_options' to `a_multiple_json_data_files_writer_options'.
		require
			a_multiple_json_data_files_writer_options_not_void: a_multiple_json_data_files_writer_options /= Void
		do
			multiple_json_data_files_writer_options := a_multiple_json_data_files_writer_options
		ensure
			multiple_json_data_files_writer_options_set: multiple_json_data_files_writer_options = a_multiple_json_data_files_writer_options
		end

	set_serialized_data_files_writer_options (a_serialized_data_files_writer_options: like serialized_data_files_writer_options)
			-- Set `serialized_data_files_writer_options' to `a_serialized_data_files_writer_options'.
		require
			a_serialized_data_files_writer_options_not_void: a_serialized_data_files_writer_options /= Void
		do
			serialized_data_files_writer_options := a_serialized_data_files_writer_options
		ensure
			serialized_data_files_writer_options_set: serialized_data_files_writer_options = a_serialized_data_files_writer_options
		end

	set_mysql_data_writer_options (a_mysql_data_writer_options: like mysql_data_writer_options)
			-- Set `mysql_data_writer_options' to `a_mysql_data_writer_options'.
		require
			a_mysql_data_writer_options_not_void: a_mysql_data_writer_options /= Void
		do
			mysql_data_writer_options := a_mysql_data_writer_options
		ensure
			mysql_data_writer_options_set: mysql_data_writer_options = a_mysql_data_writer_options
		end

	set_is_location_search_activated (b: BOOLEAN)
			-- Set `is_location_search_activated' to `b'
		do
			is_location_search_activated := b
		ensure
			is_location_search_activated_set: is_location_search_activated = b
		end

	set_is_set_of_locations_given (b: BOOLEAN)
			-- Set `is_set_of_locations_given' to `b'
		do
			is_set_of_locations_given := b
		ensure
			is_set_of_locations_given_set: is_set_of_locations_given = b
		end

	set_is_usage_of_all_locations_activated (b: BOOLEAN)
			-- Set `is_usage_of_all_locations_activated' to `b'
		do
			is_usage_of_all_locations_activated := b
		ensure
			is_usage_of_all_locations_activated_set: is_usage_of_all_locations_activated = b
		end

	set_is_expression_search_activated (b: BOOLEAN)
			-- Set `is_expression_search_activated' to `b'
		do
			is_expression_search_activated := b
		ensure
			is_expression_search_activated_set: is_expression_search_activated = b
		end

	set_is_set_of_variables_given (b: BOOLEAN)
			-- Set `is_set_of_variables_given' to `b'
		do
			is_set_of_variables_given := b
		ensure
			is_set_of_variables_given_set: is_set_of_variables_given = b
		end

	set_is_set_of_expressions_given (b: BOOLEAN)
			-- Set `is_set_of_expressions_given' to `b'
		do
			is_set_of_expressions_given := b
		ensure
			is_set_of_expressions_given_set: is_set_of_expressions_given = b
		end

	set_is_set_of_locations_with_expressions_given (b: BOOLEAN)
			-- Set `is_set_of_locations_with_expressions_given' to `b'
		do
			is_set_of_locations_with_expressions_given := b
		ensure
			is_set_of_locations_with_expressions_given_set: is_set_of_locations_with_expressions_given = b
		end

	set_is_set_of_locations_with_variables_given (b: BOOLEAN)
			-- Set `is_set_of_locations_with_variables_given' to `b'
		do
			is_set_of_locations_with_variables_given := b
		ensure
			is_set_of_locations_with_variables_given_set: is_set_of_locations_with_variables_given = b
		end

	set_is_single_json_data_file_writer_selected (b: BOOLEAN)
			-- Set `is_single_json_data_file_writer_selected' to `b'
		do
			is_single_json_data_file_writer_selected := b
		ensure
			is_single_json_data_file_writer_selected_set: is_single_json_data_file_writer_selected = b
		end

	set_is_multiple_json_data_files_writer_selected (b: BOOLEAN)
			-- Set `is_multiple_json_data_files_writer_selected' to `b'
		do
			is_multiple_json_data_files_writer_selected := b
		ensure
			is_multiple_json_data_files_writer_selected_set: is_multiple_json_data_files_writer_selected = b
		end

	set_is_serialized_data_files_writer_selected (b: BOOLEAN)
			-- Set `is_serialized_data_files_writer_selected' to `b'
		do
			is_serialized_data_files_writer_selected := b
		ensure
			is_serialized_data_files_writer_selected_set: is_serialized_data_files_writer_selected = b
		end

	set_is_mysql_data_writer_selected (b: BOOLEAN)
			-- Set `is_mysql_data_writer_selected' to `b'
		do
			is_mysql_data_writer_selected := b
		ensure
			is_mysql_data_writer_selected_set: is_mysql_data_writer_selected = b
		end

end
