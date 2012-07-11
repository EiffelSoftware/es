note
	description: "Command to collect runtime data through dynamic means"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_COMMAND

inherit
	EPA_DEBUGGER_UTILITY

	EPA_UTILITY

	EXCEPTIONS

create
	make

feature {NONE} -- Initialization

	make (a_configuration: like configuration)
			-- Initialize current command.
		require
			a_configuration_not_void: a_configuration /= Void
		do
			check_configuration_validity (a_configuration)
			if not is_configuration_valid then
				print_configuration_error_message
				die (-1)
			end
			configuration := a_configuration
			class_ := configuration.class_
			feature_ := configuration.feature_
		ensure
			configuration_set: configuration = a_configuration
			class_set: class_ = configuration.class_
			feature_set: feature_ = configuration.feature_
		end

feature -- Access

	configuration: DPA_CONFIGURATION
			-- Configuration specifying how a program should be dynamically analyzed.

feature -- Basic operations

	execute
			-- Execute current command
		do
			-- Find post-state(s) breakpoint slot(s) for all pre-state breakpoint slots in `l_feature'.
			find_all_post_state_breakpoint_slots

			-- Choose pre-states breakpoint slots
			choose_pre_state_breakpoint_slots

			-- Setup expressions which are evaluated
			setup_expressions

			-- Remove breakpoints set by previous debugging sessions.
			remove_breakpoint (debugger_manager, configuration.root_class)

			-- Set up the action for the evaluation of pre- and post-states.
			setup_action_for_evaluation

			-- Start program execution in debugger.
			start_debugger (debugger_manager, "", configuration.working_directory, {EXEC_MODES}.run, False)

			-- Remove the last debugging session.
			remove_debugger_session

			-- Post process data for writing to disk.
			processor.post_process

			-- Write data to disk
			write

			-- Generate additional files
			generate_meta_data_files
		end

feature {NONE} -- Implemenation

	check_configuration_validity (a_configuration: like configuration)
			-- Check if `a_configuration' is a valid configuration, make result available
			-- in `is_configuration_valid' and make message containing configuration errors available in `error_message'.
		require
			a_configuration_not_void: a_configuration /= Void
		local
			l_class_valid, l_feature_valid, l_program_location_options_valid, l_expression_options_valid: BOOLEAN
			l_expression_location_combinations_valid, l_writer_combination_valid: BOOLEAN
			l_single_json_data_file_writer_options_valid, l_multiple_json_data_files_writer_options_valid, l_serialized_data_writer_options_valid: BOOLEAN
			l_mysql_writer_options_valid: BOOLEAN
			l_single_json_data_file_writer_options: TUPLE [output_path: STRING; file_name: STRING]
			l_multiple_json_data_files_writer_options: TUPLE [output_path: STRING; file_name_prefix: STRING]
			l_serialized_data_files_writer_options: TUPLE [output_path: STRING; file_name_prefix: STRING]
			l_mysql_data_writer_options: TUPLE [host: STRING; user: STRING; password: STRING; database: STRING; port: INTEGER]
			l_directory_name: DIRECTORY_NAME
			l_file_name, l_file_name_prefix: FILE_NAME
		do
			is_configuration_valid := True
			error_message := ""

			l_class_valid := a_configuration.class_ /= Void
			if not l_class_valid then
				error_message.append ("Specified class is invalid.%N")
			end
			is_configuration_valid := is_configuration_valid and l_class_valid

			l_feature_valid := a_configuration.feature_ /= Void
			if not l_feature_valid then
				error_message.append ("Specified feature is invalid.%N")
			end
			is_configuration_valid := is_configuration_valid and l_feature_valid

			l_program_location_options_valid :=
				a_configuration.is_usage_of_all_locations_activated xor
				a_configuration.is_location_search_activated xor
				a_configuration.is_set_of_locations_given

			l_expression_options_valid :=
				a_configuration.is_expression_search_activated xor
				a_configuration.is_set_of_expressions_given xor
				a_configuration.is_set_of_variables_given

			l_expression_location_combinations_valid :=
				(l_program_location_options_valid and l_expression_options_valid) xor
				a_configuration.is_set_of_locations_with_expressions_given xor
				a_configuration.is_set_of_locations_with_variables_given

			if not l_expression_location_combinations_valid then
				error_message.append (
					"The combination of program locations and expressions must fulfill the following property: " +
					"((all_prgm_locs xor aut_choice_of_prgm_locs xor specific_prgm_locs) and " +
					"(aut_choice_of_exprs xor specific_exprs xor specific_vars)) xor " +
					"prgm_locs_with_exprs xor" +
					"prgm_locs_with_vars%N"
				)
			end
			is_configuration_valid := is_configuration_valid and l_expression_location_combinations_valid

			l_writer_combination_valid :=
				a_configuration.is_single_json_data_file_writer_selected xor
				a_configuration.is_multiple_json_data_files_writer_selected xor
				a_configuration.is_serialized_data_files_writer_selected xor
				a_configuration.is_mysql_writer_selected

			if not l_writer_combination_valid then
				error_message.append ("Multiple writers were specified.%N")
			end
			is_configuration_valid := is_configuration_valid and l_writer_combination_valid

			if a_configuration.is_single_json_data_file_writer_selected then
				l_single_json_data_file_writer_options := a_configuration.single_json_data_file_writer_options
				create l_directory_name.make_from_string (l_single_json_data_file_writer_options.output_path)
				l_single_json_data_file_writer_options_valid := l_directory_name.is_valid
				if not l_single_json_data_file_writer_options_valid then
					error_message.append ("Invalid output-path%N")
				end

				create l_file_name.make_from_string (l_single_json_data_file_writer_options.file_name)
				l_single_json_data_file_writer_options_valid := l_single_json_data_file_writer_options_valid and l_file_name.is_valid
				if not l_single_json_data_file_writer_options_valid then
					error_message.append ("Invalid file name%N")
				end

				is_configuration_valid := is_configuration_valid and l_single_json_data_file_writer_options_valid
			end

			if a_configuration.is_multiple_json_data_files_writer_selected then
				l_multiple_json_data_files_writer_options := a_configuration.multiple_json_data_files_writer_options
				create l_directory_name.make_from_string (l_multiple_json_data_files_writer_options.output_path)
				l_multiple_json_data_files_writer_options_valid := l_directory_name.is_valid
				if not l_multiple_json_data_files_writer_options_valid then
					error_message.append ("Invalid output-path%N")
				end

				create l_file_name_prefix.make_from_string (l_multiple_json_data_files_writer_options.file_name_prefix)
				l_multiple_json_data_files_writer_options_valid := l_multiple_json_data_files_writer_options_valid and l_file_name_prefix.is_valid
				if not l_multiple_json_data_files_writer_options_valid  then
					error_message.append ("Invalid file name prefix%N")
				end

				is_configuration_valid := is_configuration_valid and l_multiple_json_data_files_writer_options_valid
			end

			if a_configuration.is_serialized_data_files_writer_selected then
				l_serialized_data_files_writer_options := a_configuration.serialized_data_files_writer_options
				create l_directory_name.make_from_string (l_serialized_data_files_writer_options.output_path)
				l_serialized_data_writer_options_valid := l_directory_name.is_valid
				if not l_serialized_data_writer_options_valid then
					error_message.append ("Invalid output-path%N")
				end

				create l_file_name_prefix.make_from_string (l_serialized_data_files_writer_options.file_name_prefix)
				l_serialized_data_writer_options_valid := l_serialized_data_writer_options_valid and l_file_name_prefix.is_valid
				if not l_serialized_data_writer_options_valid then
					error_message.append ("Invalid file name prefix%N")
				end

				is_configuration_valid := is_configuration_valid and l_serialized_data_writer_options_valid
			end

			if a_configuration.is_mysql_writer_selected then
				l_mysql_data_writer_options := a_configuration.mysql_data_writer_options
				l_mysql_writer_options_valid := l_mysql_data_writer_options.port >= 1 and l_mysql_data_writer_options.port <= 65535
				if not l_mysql_writer_options_valid then
					error_message.append ("Port must be in the interval [1,65535]%N")
				end

				is_configuration_valid := is_configuration_valid and l_mysql_writer_options_valid
			end
		end

	is_configuration_valid: BOOLEAN
			-- Is `configuration' valid?

feature {NONE} -- Implementation

	print_configuration_error_message
			--
		require
			error_message_not_void: error_message /= Void
		do
			io.put_string ("%N----------------%NConfiguration invalid:%N----------------%N%N")
			io.put_string (error_message)
		end

	find_all_post_state_breakpoint_slots
			-- Find post-state breakpoint slots for every pre-state breakpoint slot.
		local
			l_post_state_bp_finder: DPA_POST_STATE_FINDER
		do
			create l_post_state_bp_finder.make (class_, feature_)
			l_post_state_bp_finder.find
			post_state_bp_map := l_post_state_bp_finder.post_state_bp_map
		end

	choose_pre_state_breakpoint_slots
			-- Choose pre-state breakpoint slots depending on specified options
			-- `configuration'
		local
			i, l_upper: INTEGER
			l_pre_state_bp_finder: DPA_INTERESTING_PRE_STATE_FINDER
			l_bp_interval: INTEGER_INTERVAL
		do
			-- Choose pre-states
			if configuration.is_usage_of_all_locations_activated then
				-- Use all pre-state breakpoint slots
				l_bp_interval := feature_body_breakpoint_slots (feature_)
				create program_locations.make_default
				l_bp_interval.do_all (agent program_locations.force_last)
			elseif configuration.is_set_of_locations_given then
				-- Use given pre-state breakpoint slots
				program_locations := configuration.locations
			elseif configuration.is_set_of_locations_with_expressions_given then
				-- Use given pre-state breakpoint slots
				create program_locations.make_default
				configuration.locations_with_expressions.keys.do_all (agent program_locations.force_last)
			elseif configuration.is_set_of_locations_with_variables_given then
				-- Use given pre-state breakpoint slots
				create program_locations.make_default
				configuration.locations_with_variables.keys.do_all (agent program_locations.force_last)
			elseif configuration.is_location_search_activated then
				-- Find and use interesting pre-state breakpoint slots in `l_feature'.
				create l_pre_state_bp_finder.make (feature_.e_feature.ast)
				l_pre_state_bp_finder.find
				program_locations := l_pre_state_bp_finder.interesting_pre_states
			end
		end

	setup_expressions
			-- Setup expressions which are evaluated
		local
			l_var_finder: DPA_INTERESTING_VARIABLE_FINDER
			l_expr_builder: DPA_EXPRESSION_BUILDER
			l_locs_with_exprs, l_locs_with_vars: DS_HASH_TABLE [DS_HASH_SET [STRING], INTEGER]
			l_keys: DS_BILINEAR [INTEGER]
			l_mapping: DS_HASH_TABLE [DS_HASH_SET [STRING], STRING]
			l_vars: DS_HASH_SET [STRING]
			l_set: DS_HASH_SET [STRING]
		do
			create l_expr_builder.make (class_, feature_)
			if configuration.is_set_of_variables_given then
				l_expr_builder.build_from_variables (configuration.variables)
			elseif configuration.is_set_of_locations_with_variables_given then
				l_expr_builder.store_vars_exprs_mapping (True)
				l_expr_builder.build_from_variables (configuration.variables)
			elseif configuration.is_set_of_expressions_given or configuration.is_set_of_locations_with_expressions_given then
				l_expr_builder.build_from_expressions (configuration.expressions)
			elseif configuration.is_expression_search_activated then
				create l_var_finder.make (feature_.e_feature.ast, program_locations)
				l_var_finder.find
				l_expr_builder.set_interesting_variables_from_assignments (l_var_finder.interesting_variables_from_assignments)
				l_expr_builder.build_from_variables (l_var_finder.interesting_variables)
			end

			expressions := l_expr_builder.expressions_to_evaluate

			if l_expr_builder.is_storage_of_vars_exprs_mapping_activated then
				create l_locs_with_exprs.make_default
				l_mapping := l_expr_builder.vars_with_exprs
				l_locs_with_vars := configuration.locations_with_variables
				l_keys := l_locs_with_vars.keys
				from
					l_keys.start
				until
					l_keys.after
				loop
					l_vars := l_locs_with_vars.item (l_keys.item_for_iteration)
					from
						l_vars.start
					until
						l_vars.after
					loop
						l_set := l_mapping.item (l_vars.item_for_iteration)
						if l_set = Void then
							create l_set.make_default
							l_set.set_equality_tester (string_equality_tester)
						end
						l_locs_with_exprs.force_last (l_set, l_keys.item_for_iteration)
						l_vars.forth
					end
					l_keys.forth
				end
				configuration.set_locations_with_expressions (l_locs_with_exprs)
			end
		end

	setup_action_for_evaluation
			-- Setup action for evaluation
		local
			l_bp_mgr: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
			l_bp_count, l_pre_state_bp: INTEGER
			l_threshold: DOUBLE
		do
			if configuration.is_offline_processor_selected then
				initialize_offline_processor
			elseif configuration.is_online_processor_selected then
				initialize_online_processor
			end

			if configuration.is_set_of_locations_with_expressions_given or configuration.is_set_of_locations_with_variables_given then
				processor.set_prgm_locs_with_exprs (configuration.locations_with_expressions)
			end

			if configuration.is_serialized_data_files_writer_selected then
				initialize_single_json_data_file_writer
			elseif configuration.is_multiple_json_data_files_writer_selected then
				initialize_multiple_json_data_files_writer
			elseif configuration.is_serialized_data_files_writer_selected then
				initialize_serialized_data_files_writer
			elseif configuration.is_mysql_writer_selected then
				initialize_mysql_data_writer
			end

			l_bp_count := breakpoint_count (feature_)
			across program_locations.to_array as l_pre_states loop
				l_pre_state_bp := l_pre_states.item
				if l_pre_state_bp < l_bp_count then
					create l_bp_mgr.make (class_, feature_)
					l_bp_mgr.set_breakpoint_with_expression_and_action (l_pre_state_bp, expressions, agent processor.process)
					l_bp_mgr.toggle_breakpoints (True)

					across post_state_bp_map.item (l_pre_state_bp).to_array as l_post_states loop
						create l_bp_mgr.make (class_, feature_)
						l_bp_mgr.set_breakpoint_with_expression_and_action (l_post_states.item, expressions, agent processor.process)
						l_bp_mgr.toggle_breakpoints (True)
					end
				end
			end
		end

	write
			-- Write data.
		do
			writer.set_analysis_order (processor.last_analysis_order)
			writer.set_collected_data (processor.last_data)
			writer.write
		end

	generate_meta_data_files
			-- Generate meta-data files if needed
		do
			if attached {DPA_MULTIPLE_JSON_DATA_FILES_WRITER} writer as l_multiple_json_data_files_writer then
				l_multiple_json_data_files_writer.set_keys (processor.last_keys)
				l_multiple_json_data_files_writer.generate_root_file
			end
			if attached {DPA_SERIALIZED_DATA_FILE_WRITER} writer as l_serialized_data_files_writer then
				l_serialized_data_files_writer.generate_root_file
				l_serialized_data_files_writer.generate_keys_file
			end
		end

feature {NONE} -- Implementation

	initialize_offline_processor
			-- Initialize `processor' with an offline processor
		do
			create {DPA_OFFLINE_PROCESSOR} processor.make (program_locations, post_state_bp_map, debugger_manager)
		end

	initialize_online_processor
			-- Initialize `processor' with an online processor
		do
			create {DPA_ONLINE_PROCESSOR} processor.make (program_locations, post_state_bp_map, debugger_manager)
		end

	initialize_single_json_data_file_writer
			-- Initialize `writer' with a single JSON data file writer
		local
			l_options: TUPLE [output_path: STRING; file_name: STRING]
		do
			l_options := configuration.single_json_data_file_writer_options
			create {DPA_SINGLE_JSON_DATA_FILE_WRITER} writer.make (class_, feature_, l_options.output_path, l_options.file_name)
		end

	initialize_multiple_json_data_files_writer
			-- Initialize `writer' with a multiple JSON data files writer
		local
			l_options: TUPLE [output_path: STRING; file_name_prefix: STRING]
		do
			l_options := configuration.multiple_json_data_files_writer_options
			create {DPA_MULTIPLE_JSON_DATA_FILES_WRITER} writer.make (class_, feature_, l_options.output_path, l_options.file_name_prefix)
		end

	initialize_serialized_data_files_writer
			-- Initialize `writer' with a serialized data files writer
		local
			l_options: TUPLE [output_path: STRING; file_name_prefix: STRING]
		do
			l_options := configuration.serialized_data_files_writer_options
			create {DPA_SERIALIZED_DATA_FILE_WRITER} writer.make (class_, feature_, l_options.output_path, l_options.file_name_prefix)
		end

	initialize_mysql_data_writer
			-- Initialize `writer' with a MYSQL data writer
		local
			l_options: TUPLE [host: STRING; user: STRING; password: STRING; database: STRING; port: INTEGER]
			l_mysql_client: MYSQL_CLIENT
		do
			l_options := configuration.mysql_data_writer_options
			create l_mysql_client.make_with_database (l_options.host, l_options.host, l_options.password, l_options.database, l_options.port)
			--create {DPA_MYSQL_DATA_WRITER} writer.make (class_, feature_, l_mysql_client)
		end

feature {NONE} -- Implementation

	class_: CLASS_C
			-- Class belonging to `feature_'

	feature_: FEATURE_I
			-- Feature which will be analyzed.

	expressions: DS_HASH_SET [EPA_EXPRESSION]
			-- Expressions which are evaluated

	program_locations: DS_HASH_SET [INTEGER]
			-- Pre-state breakpoint slots at which `expressions' are evaluated

	post_state_bp_map: DS_HASH_TABLE [DS_HASH_SET [INTEGER], INTEGER]
			-- Contains the found post-states.
			-- Keys are pre-states and values are (possibly multiple) post-states

	error_message: STRING
			-- Error message indicating why the configuration is not a valid configuration.

	processor: DPA_DATA_PROCESSOR
			-- Processor used for processing the runtime data during the execution
			-- of `feature_'.

	writer: DPA_DATA_WRITER
			-- Writer used to persistently store the runtime data.

	reference_feature
			-- Feature referencing all classes currently not used.
			-- This feature will be removed after testing.
		local
			--l_retriever: DPA_DATA_RETRIEVER
			--l_multiple: DPA_MULTIPLE_JSON_DATA_FILES_READER
			--l_single: DPA_SINGLE_JSON_DATA_FILE_READER
			--l_database: DPA_MYSQL_DATA_READER
			--l_serialized_reader: DPA_SERIALIZED_DATA_FILE_READER
			--l_serialized_writer: DPA_SERIALIZED_DATA_FILE_WRITER
		do
		end

end
