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
--		local
--			l_class, l_feature: STRING
--			l_aop_count: INTEGER
--			l_expressions_and_locations: LINKED_LIST [TUPLE [expression: STRING; location: INTEGER]]
--			l_expression_location_count: INTEGER
--			l_expression: STRING
--			l_location: INTEGER
		do
			-- Find post-state(s) breakpoint slot(s) for all pre-state breakpoint slots in `l_feature'.
			find_all_post_state_breakpoint_slots

			-- Choose pre-states breakpoint slots
			choose_locations

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

			-- Write data to disk
			writer.write

--			if configuration.is_single_json_data_file_writer_selected then
--				create {DPA_SINGLE_JSON_DATA_FILE_READER} reader.make (configuration.single_json_data_file_writer_options.output_path, configuration.single_json_data_file_writer_options.file_name)
--			elseif configuration.is_multiple_json_data_files_writer_selected then
--				create {DPA_MULTIPLE_JSON_DATA_FILES_READER} reader.make (configuration.multiple_json_data_files_writer_options.output_path, configuration.multiple_json_data_files_writer_options.file_name_prefix)
--			elseif configuration.is_serialized_data_files_writer_selected then
--				create {DPA_SERIALIZED_DATA_FILE_READER} reader.make (configuration.serialized_data_files_writer_options.output_path, configuration.serialized_data_files_writer_options.file_name_prefix)
--			elseif configuration.is_mysql_data_writer_selected then
--				if attached {DPA_MYSQL_DATA_WRITER} writer as mysql_writer then
--					create {DPA_MYSQL_DATA_READER} reader.make (mysql_writer.mysql_client)
--				end
--			end

--			l_class := reader.class_
--			l_feature := reader.feature_
--			across reader.analysis_order_pairs as aop loop
--			end
--			l_aop_count := reader.analysis_order_pairs_count
--			across reader.limited_analysis_order_pairs (1, l_aop_count) as aop loop
--			end
--			l_expressions_and_locations := reader.expressions_and_locations
--			from
--				l_expressions_and_locations.start
--			until
--				l_expressions_and_locations.after
--			loop
--				l_expression := l_expressions_and_locations.item.expression
--				l_location := l_expressions_and_locations.item.location
--				l_expression_location_count := reader.expression_value_transitions_count (l_expression, l_location)
--				across reader.expression_value_transitions (l_expression, l_location) as evt loop
--				end
--				across reader.limited_expression_value_transitions (l_expression, l_location, 1, l_expression_location_count) as evt loop
--				end
--				l_expressions_and_locations.forth
--			end
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
				a_configuration.is_mysql_data_writer_selected

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

			if a_configuration.is_mysql_data_writer_selected then
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

	process_and_write (a_bp: BREAKPOINT; a_state: EPA_STATE)
			-- Process `a_bp' and `a_state' using `processor' and write
			-- results of processing using `writer'.
		require
			a_bp_not_void: a_bp /= Void
			a_state_not_void: a_state /= Void
		do
			processor.process (a_bp, a_state)
			writer.add_analysis_order_pairs (processor.last_analysis_order_pairs)
			writer.add_expression_value_transitions (processor.last_transitions)
			writer.try_write
		end

	process_filter_and_write (a_bp: BREAKPOINT; a_state: EPA_STATE)
			-- Process and filter `a_bp' and `a_state' using `processor' and
			-- write results of processing using `writer'.
		require
			a_bp_not_void: a_bp /= Void
			a_state_not_void: a_state /= Void
		do
			processor.process_and_filter (a_bp, a_state)
			writer.add_analysis_order_pairs (processor.last_analysis_order_pairs)
			writer.add_expression_value_transitions (processor.last_transitions)
			writer.try_write
		end

feature {NONE} -- Implementation

	print_configuration_error_message
			-- Print `error_message' in the standard output.
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

	choose_locations
			-- Choose pre-state breakpoint slots depending on specified options
			-- `configuration'
		local
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
			l_locs: DS_BILINEAR [INTEGER]
			l_vars_exprs_mapping: DS_HASH_TABLE [DS_HASH_SET [STRING], STRING]
			l_vars: DS_HASH_SET [STRING]
			l_var: STRING
			l_set: DS_HASH_SET [STRING]
			l_loc: INTEGER
		do
			create l_expr_builder.make (class_, feature_)
			if configuration.is_set_of_variables_given then
				l_expr_builder.set_interesting_variables (configuration.variables)
				l_expr_builder.build_from_variables
			elseif configuration.is_set_of_locations_with_variables_given then
				l_expr_builder.set_interesting_variables (configuration.variables)
				l_expr_builder.build_from_variables
			elseif configuration.is_set_of_expressions_given or configuration.is_set_of_locations_with_expressions_given then
				l_expr_builder.set_interesting_expressions (configuration.expressions)
				l_expr_builder.build_from_expressions
			elseif configuration.is_expression_search_activated then
				create l_var_finder.make (feature_.e_feature.ast, program_locations)
				l_var_finder.find
				l_expr_builder.set_interesting_variables (l_var_finder.interesting_variables)
				l_expr_builder.set_interesting_variables_from_assignments (l_var_finder.interesting_variables_from_assignments)
				l_expr_builder.build_from_variables
			end

			expressions := l_expr_builder.expressions_to_evaluate

			if configuration.is_set_of_locations_with_variables_given then
				create l_locs_with_exprs.make_default
				l_vars_exprs_mapping := l_expr_builder.vars_with_exprs
				l_locs_with_vars := configuration.locations_with_variables
				l_locs := l_locs_with_vars.keys
				from
					l_locs.start
				until
					l_locs.after
				loop
					l_loc := l_locs.item_for_iteration
					l_vars := l_locs_with_vars.item (l_loc)
					from
						l_vars.start
					until
						l_vars.after
					loop
						l_var := l_vars.item_for_iteration
						if l_vars_exprs_mapping.has (l_var) then
							l_set := l_vars_exprs_mapping.item (l_var)
							l_locs_with_exprs.force_last (l_set, l_loc)
						else
							create l_set.make_default
							l_set.set_equality_tester (string_equality_tester)

							l_set.force_last (l_var)
							l_locs_with_exprs.force_last (l_set, l_loc)
						end
						l_vars.forth
					end
					l_locs.forth
				end
				configuration.set_locations_with_expressions (l_locs_with_exprs)
			end
		end

	setup_action_for_evaluation
			-- Setup action for evaluation
		require
			pre_state_breakpoints_not_void: pre_state_breakpoints /= Void
			post_state_bp_map_not_void: post_state_bp_map /= Void
		local
			l_bp_mgr: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
			l_bp_count, l_pre_state_bp: INTEGER
			l_process_write_feature: PROCEDURE [ANY, TUPLE [BREAKPOINT, EPA_STATE]]
		do
			create processor.make (pre_state_breakpoints, post_state_bp_map, debugger_manager)

			if configuration.is_set_of_locations_with_expressions_given or configuration.is_set_of_locations_with_variables_given then
				processor.set_prgm_locs_with_exprs (configuration.locations_with_expressions)
				l_process_write_feature := agent process_filter_and_write
			else
				l_process_write_feature := agent process_and_write
			end

			if configuration.is_single_json_data_file_writer_selected then
				writer := new_single_json_data_file_writer
			elseif configuration.is_multiple_json_data_files_writer_selected then
				writer := new_multiple_json_data_files_writer
			elseif configuration.is_serialized_data_files_writer_selected then
				writer := new_serialized_data_files_writer
			elseif configuration.is_mysql_data_writer_selected then
				writer := new_mysql_data_writer
			end

			l_bp_count := breakpoint_count (feature_)

			across pre_state_breakpoints.to_array as l_pre_states loop
				l_pre_state_bp := l_pre_states.item
				if l_pre_state_bp < l_bp_count then
					create l_bp_mgr.make (class_, feature_)
					l_bp_mgr.set_breakpoint_with_expression_and_action (l_pre_state_bp, expressions, l_process_write_feature)
					l_bp_mgr.toggle_breakpoints (True)

					across post_state_bp_map.item (l_pre_state_bp).to_array as l_post_states loop
						create l_bp_mgr.make (class_, feature_)
						l_bp_mgr.set_breakpoint_with_expression_and_action (l_post_states.item, expressions, l_process_write_feature)
						l_bp_mgr.toggle_breakpoints (True)
					end
				end
			end
		ensure
			processor_not_void: processor /= Void
			writer_not_void: writer /= Void
		end

feature {NONE} -- Implementation

	new_single_json_data_file_writer: DPA_SINGLE_JSON_DATA_FILE_WRITER
			-- Initialize `writer' with a single JSON data file writer
		require
			single_json_data_file_writer_options_not_void: configuration.single_json_data_file_writer_options /= Void
			output_path_not_void: configuration.single_json_data_file_writer_options.output_path /= Void
			file_name_not_void: configuration.single_json_data_file_writer_options.file_name /= Void
		local
			l_options: TUPLE [output_path: STRING; file_name: STRING]
		do
			l_options := configuration.single_json_data_file_writer_options
			create Result.make (class_, feature_, l_options.output_path, l_options.file_name)
		ensure
			Result_not_void: Result /= Void
		end

	new_multiple_json_data_files_writer: DPA_MULTIPLE_JSON_DATA_FILES_WRITER
			-- Initialize `writer' with a multiple JSON data files writer
		require
			multiple_json_data_files_writer_options_not_void: configuration.multiple_json_data_files_writer_options /= Void
			output_path_not_void: configuration.multiple_json_data_files_writer_options.output_path /= Void
			file_name_prefix_not_void: configuration.multiple_json_data_files_writer_options.file_name_prefix /= Void
		local
			l_options: TUPLE [output_path: STRING; file_name_prefix: STRING]
		do
			l_options := configuration.multiple_json_data_files_writer_options
			create Result.make (class_, feature_, l_options.output_path, l_options.file_name_prefix)
		ensure
			Result_not_void: Result /= Void
		end

	new_serialized_data_files_writer: DPA_SERIALIZED_DATA_FILE_WRITER
			-- Initialize `writer' with a serialized data files writer
		require
			serialized_data_files_writer_options_not_void: configuration.serialized_data_files_writer_options /= Void
			output_path_not_void: configuration.serialized_data_files_writer_options.output_path /= Void
			file_name_prefix_not_void: configuration.serialized_data_files_writer_options.file_name_prefix /= Void
		local
			l_options: TUPLE [output_path: STRING; file_name_prefix: STRING]
		do
			l_options := configuration.serialized_data_files_writer_options
			create Result.make (class_, feature_, l_options.output_path, l_options.file_name_prefix)
		ensure
			Result_not_void: Result /= Void
		end

	new_mysql_data_writer: DPA_MYSQL_DATA_WRITER
			-- Initialize `writer' with a MYSQL data writer
		require
			mysql_data_writer_options_not_void: configuration.mysql_data_writer_options /= Void
			host_not_void: configuration.mysql_data_writer_options.host /= Void
			user_not_void: configuration.mysql_data_writer_options.user /= Void
			password_not_void: configuration.mysql_data_writer_options.password /= Void
			database_not_void: configuration.mysql_data_writer_options.database /= Void
		local
			l_options: TUPLE [host: STRING; user: STRING; password: STRING; database: STRING; port: INTEGER]
			l_mysql_client: MYSQL_CLIENT
		do
			l_options := configuration.mysql_data_writer_options
			create l_mysql_client.make_with_database (l_options.host, l_options.user, l_options.password, l_options.database, l_options.port)
			create Result.make (class_, feature_, l_mysql_client)
		ensure
			Result_not_void: Result /= Void
		end

feature {NONE} -- Implementation

	class_: CLASS_C
			-- Class belonging to `feature_'.

	feature_: FEATURE_I
			-- Feature which will be analyzed.

	expressions: DS_HASH_SET [EPA_EXPRESSION]
			-- Expressions which are evaluated

	program_locations: DS_HASH_SET [INTEGER]
			-- Program locations at which `expressions' are evaluated before
			-- and after the execution of every program location in this set.

	pre_state_breakpoints: DS_HASH_SET [INTEGER]
			-- Breakpoints at which `expressions' are evaluated as pre-states
		do
			Result := program_locations
		end

	post_state_bp_map: DS_HASH_TABLE [DS_HASH_SET [INTEGER], INTEGER]
			-- Contains the found post-states.
			-- Keys are pre-states and values are (possibly multiple) post-states

	error_message: STRING
			-- Error message indicating why the configuration is not a valid configuration.

	processor: DPA_PROCESSOR
			-- Processor used for processing the runtime data during the execution
			-- of `feature_'.

	writer: DPA_DATA_WRITER
			-- Writer used to persistently store the runtime data.

--	reader: DPA_DATA_READER
--			-- Temporarily for testing purposes used attribute.

end
