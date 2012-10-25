note
	description: "Command to analyze the runtime behaviour of a feature through dynamic means."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_COMMAND

inherit
	EPA_DEBUGGER_UTILITY
		rename
			remove_breakpoint as remove_breakpoints,
			remove_debugger_session as remove_last_debugger_session
		export
			{NONE} all
		end

	EPA_UTILITY
		export
			{NONE} all
		end

	EXCEPTIONS
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (a_configuration: like configuration)
			-- Initialize command.
		require
			a_configuration_not_void: a_configuration /= Void
		local
			l_configuration_validator: DPA_CONFIGURATION_VALIDATOR
		do
			-- Validate configuration before usage.
			create l_configuration_validator.make (a_configuration)
			l_configuration_validator.validate

			if
				not l_configuration_validator.is_configuration_valid
			then
				-- Reject configuration and stop current analysis.
				io.put_string (l_configuration_validator.last_status_message)
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
			-- Execute command.
		do
			-- Find post-state breakpoint(s) for all pre-state breakpoints in `feature_'.
			find_post_state_breakpoints

			-- Choose program locations based on options specified in `configuration'.
			choose_program_locations

			-- Build expressions which are evaluated based on options specified in `configuration'.
			-- Build the expression evaluation plan based on options specified in `configuration'.
			build_expressions_and_expression_evaluation_plan

			-- Remove breakpoints set by previous debugging sessions.
			remove_breakpoints (debugger_manager, configuration.root_class)

			-- Initialize `processor' and `writer'.
			initialize_processor_and_writer

			-- Set up the action for the expression evaluation.
			set_up_action_for_expression_evaluation

			-- Start program execution and analysis in debugger.
			start_debugger (
				debugger_manager, "", configuration.working_directory, {EXEC_MODES}.run, False
			)

			-- Remove the last debugger session.
			remove_last_debugger_session

			-- Write unwritten analysis results to disk.
			write_unwritten_analysis_results
		end

feature {NONE} -- Implementation

	class_: CLASS_C
			-- Context class of `feature_'.

	feature_: FEATURE_I
			-- Feature under analysis.

	expressions: DS_HASH_SET [EPA_EXPRESSION]
			-- Expressions which are evaluated.

	program_locations: DS_HASH_SET [INTEGER]
			-- Program locations at which `expressions' are evaluated before and after the
			-- execution of a program location.

	pre_state_breakpoints: DS_HASH_SET [INTEGER]
			-- Breakpoints at which `expressions' are evaluated to gain pre-state values.
		require
			program_locations_not_void: program_locations /= Void
		do
			Result := program_locations
		ensure
			Result_set: Result = program_locations
		end

	post_state_breakpoints: DS_HASH_TABLE [DS_HASH_SET [INTEGER], INTEGER]
			-- Breakpoints at which `expressions' are evaluated to gain post-state values.
			-- Keys are pre-state breakpoints.
			-- Values are (possibly multiple) post-state breakpoints.

	expression_evaluation_plan: DS_HASH_TABLE [DS_HASH_SET [INTEGER], EPA_EXPRESSION]
			-- Expression evaluation plan specifying the program locations at which an expression
			-- is evaluated before and after the execution of a program location.
			-- Keys are expressions.
			-- Values are program locations.

	processor: DPA_PROCESSOR
			-- Processor used to process the analysis results during the
			-- execution of `feature_'.

	writer: DPA_WRITER
			-- Writer used to persistently store the analysis results.

feature {NONE} -- Implementation

	find_post_state_breakpoints
			-- Find post-state breakpoints for every pre-state breakpoint in `feature_'.
		local
			l_post_state_breakpoint_finder: DPA_POST_STATE_BREAKPOINT_FINDER
		do
			create l_post_state_breakpoint_finder.make (class_, feature_)
			l_post_state_breakpoint_finder.find
			post_state_breakpoints := l_post_state_breakpoint_finder.last_post_state_breakpoints
		ensure
			post_state_breakpoints_not_void: post_state_breakpoints /= Void
		end

	choose_program_locations
			-- Choose program locations to be considered according to options specified in `configuration'.
		local
			l_program_location_finder: DPA_PROGRAM_LOCATION_FINDER
			l_feature_body_breakpoints: INTEGER_INTERVAL
		do
			if
				configuration.is_all_program_locations_option_used
			then
				-- Use all program locations of the feature body of `feature_'.
				l_feature_body_breakpoints := feature_body_breakpoint_slots (feature_)
				create program_locations.make (l_feature_body_breakpoints.count)
				l_feature_body_breakpoints.do_all (agent program_locations.force_last)
			elseif
				configuration.is_program_locations_option_used or else
				configuration.is_localized_expressions_option_used or else
				configuration.is_localized_variables_option_used
			then
				-- Use given program locations.
				program_locations := configuration.program_locations
			elseif
				configuration.is_program_location_search_option_used
			then
				-- Find program locations to be considered using abstract syntax tree of `l_feature'.
				create l_program_location_finder.make (feature_.e_feature.ast)
				l_program_location_finder.find
				program_locations := l_program_location_finder.last_program_locations
			end
		ensure
			program_locations_not_void: program_locations /= Void
		end

	build_expressions_and_expression_evaluation_plan
			-- Build expressions which are evaluated and expression evaluation plan.
		local
			l_expression_builder: DPA_EXPRESSION_BUILDER
			l_expression_evaluation_planer: DPA_EXPRESSION_EVALUATION_PLANER
		do
			-- Build expressions which are evaluated according to options specified in
			-- `configuration'.
			create l_expression_builder.make (class_, feature_)

			if
				configuration.is_variables_option_used or else
				configuration.is_localized_variables_option_used
			then
				-- Use given variables.
				l_expression_builder.build_from_variables (configuration.variables)
			elseif
				configuration.is_expressions_option_used or else
				configuration.is_localized_expressions_option_used
			then
				-- Use given expressions.
				l_expression_builder.build_from_expressions (configuration.expressions)
			elseif
				configuration.is_expression_search_option_used
			then
				-- Build expressions from abstract syntax tree of `l_feature' and previously choosen program locations.
				l_expression_builder.build_from_ast (
					feature_.e_feature.ast, program_locations
				)
			end

			expressions := l_expression_builder.last_expressions

			-- Plan evaluation of expressions according to options specified in `configuration'.
			create l_expression_evaluation_planer

			if
				configuration.is_localized_variables_option_used
			then
				-- Use localized variables.
				l_expression_evaluation_planer.plan_from_localized_variables (
					configuration.localized_variables,
					l_expression_builder.last_expression_mapping
				)
			elseif
				configuration.is_localized_expressions_option_used
			then
				-- Use localized expressions.
				l_expression_evaluation_planer.plan_from_localized_expressions (
					configuration.localized_expressions,
					expressions
				)
			else
				-- Use program locations and expressions.
				l_expression_evaluation_planer.plan_from_expressions_and_program_locations (
					expressions,
					program_locations
				)
			end

			expression_evaluation_plan :=
				l_expression_evaluation_planer.last_expression_evaluation_plan
		ensure
			expressions_not_void: expressions /= Void
			expression_evaluation_plan_not_void: expression_evaluation_plan /= Void
		end

	initialize_processor_and_writer
			-- Initialize `processor' and `writer'.
		do
			-- Initialize processor.
			create processor.make (
				pre_state_breakpoints,
				post_state_breakpoints,
				expression_evaluation_plan
			)

			-- Initialize writer according to the options specified in `configuration'.
			if
				configuration.is_json_file_writer_option_used
			then
				writer := new_json_file_writer
			elseif
				configuration.is_mysql_writer_option_used
			then
				writer := new_mysql_writer
			end
		ensure
			processor_not_void: processor /= Void
			writer_not_void: writer /= Void
		end

	set_up_action_for_expression_evaluation
			-- Set up action for the evaluation of expressions.
		local
			l_breakpoint_manager: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
			l_pre_state_breakpoint: INTEGER
			l_post_state_breakpoints: DS_HASH_SET [INTEGER]
		do
			-- Iterate over pre-state breakpoints to set up action for evaluation of expressions.
			from
				pre_state_breakpoints.start
			until
				pre_state_breakpoints.after
			loop
				l_pre_state_breakpoint := pre_state_breakpoints.item_for_iteration

				-- Set up action for evaluation of expressions at current pre-state
				-- breakpoint.
				create l_breakpoint_manager.make (class_, feature_)
				l_breakpoint_manager.set_breakpoint_with_expression_and_action (
					l_pre_state_breakpoint, expressions, agent process_and_write
				)
				l_breakpoint_manager.toggle_breakpoints (True)

				-- Retrieve post-state breakpoints for current pre-state breakpoint.
				l_post_state_breakpoints := post_state_breakpoints.item (l_pre_state_breakpoint)

				-- Iterate over possible post-state breakpoints of current pre-state breakpoint
				-- to set up action for evaluation of expressions.
				from
					l_post_state_breakpoints.start
				until
					l_post_state_breakpoints.after
				loop
					-- Set up action for evaluation of expressions at current post-state
					-- breakpoint.
					create l_breakpoint_manager.make (class_, feature_)
					l_breakpoint_manager.set_breakpoint_with_expression_and_action (
						l_post_state_breakpoints.item_for_iteration,
						expressions,
						agent process_and_write
					)
					l_breakpoint_manager.toggle_breakpoints (True)

					l_post_state_breakpoints.forth
				end

				pre_state_breakpoints.forth
			end
		end

	process_and_write (a_breakpoint: BREAKPOINT; a_state: EPA_STATE)
			-- Process `a_breakpoint' and `a_state' using `processor' and write
			-- analysis results to disk using `writer'.
		require
			a_breakpoint_not_void: a_breakpoint /= Void
			a_state_not_void: a_state /= Void
		do
			processor.process (a_breakpoint, a_state)
			writer.extend (processor.last_transitions)
			writer.try_write
		end

	write_unwritten_analysis_results
			-- Write unwritten analysis results to disk using `writer'.
		do
			writer.write
		end

feature {NONE} -- Implementation

	new_json_file_writer: DPA_JSON_FILE_WRITER
			-- JSON file writer configured according to the options specified in
			-- `configuration'.
		local
			l_json_file_writer_options: TUPLE [directory: STRING; file_name: STRING]
		do
			l_json_file_writer_options := configuration.json_file_writer_options

			create Result.make (
				class_,
				feature_,
				l_json_file_writer_options.directory,
				l_json_file_writer_options.file_name
			)
		ensure
			Result_not_void: Result /= Void
		end

	new_mysql_writer: DPA_MYSQL_WRITER
			-- MYSQL writer configured according to the options specified in
			-- `configuration'.
		local
			l_mysql_writer_options: TUPLE [
				host: STRING; user: STRING; password: STRING; database: STRING; port: INTEGER
			]
			l_mysql_client: MYSQL_CLIENT
		do
			l_mysql_writer_options := configuration.mysql_writer_options

			create l_mysql_client.make_with_database (
				l_mysql_writer_options.host,
				l_mysql_writer_options.user,
				l_mysql_writer_options.password,
				l_mysql_writer_options.database,
				l_mysql_writer_options.port)

			create Result.make (class_, feature_, l_mysql_client)
		ensure
			Result_not_void: Result /= Void
		end

end
