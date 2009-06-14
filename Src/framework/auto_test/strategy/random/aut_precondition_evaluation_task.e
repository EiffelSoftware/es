note
	description: "Summary description for {AUT_PRECONDITION_EVALUATION_TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PRECONDITION_EVALUATION_TASK

inherit
	AUT_TASK

	ERL_G_TYPE_ROUTINES

	AUT_SHARED_RANDOM

	AUT_PREDICATE_UTILITY
		undefine
			system
		end

	AUT_SHARED_PREDICATE_CONTEXT
		undefine
			system
		end

create
	make

feature{NONE} -- Initialization

	make (a_feature: like feature_; a_vars: DS_LIST [ITP_VARIABLE]; a_interpreter: like interpreter) is
			-- Initialize current.
		local
			i: INTEGER
		do
			feature_ := a_feature
			interpreter := a_interpreter
			object_pool := interpreter.typed_object_pool
			steps_completed := True

			create variables.make (1, a_vars.count)
			from
				i := 1
				a_vars.start
			until
				a_vars.after
			loop
				variables.put (a_vars.item_for_iteration, i)
				i := i + 1
				a_vars.forth
			end

			if is_linear_constraint_solving_enabled then
				setup_linear_solvable_arguments
			end

			if is_evaluation_enabled then
				setup_mentioned_argument_indexes
			end
		end

feature -- Access

	system: SYSTEM_I is
			-- Current system
		do
			Result := interpreter.system
		end

	interpreter: AUT_INTERPRETER_PROXY
			-- Interpreter to execute test cases

	feature_: AUT_FEATURE_OF_TYPE
			-- Feature whose precondition is to be evaluated

	variables: ARRAY [ITP_VARIABLE]
			-- Variables used to evaluate the precondition of
			-- `feature_'
			-- The first item in the list is the target to be used
			-- to call `feature_'. The rest items are (possibly) arguments
			-- of that feature.

	object_pool: AUT_TYPED_OBJECT_POOL
			-- Ojbect pool from which objects are selected
			-- to satisfy the precondition of `feature_'

	types: DS_ARRAYED_LIST [TYPE_A]
			-- Types related to `feature_', including target type and
			-- argument types.

	tried_count: INTEGER
			-- Number of object combinations that were tried so far
			-- to satisfying the precondition of `feature_'

	worst_case_search_count: INTEGER
			-- Number of object combinations that need to be
			-- tried out in the worst case

	start_time: INTEGER
			-- Start time (in millisecond) when current precondition evaluation starts

	end_time: INTEGER
			-- End time (in millisecond) when current precondition evauation ends.

feature -- Status

	steps_completed: BOOLEAN
			-- Has all steps completed?

	has_next_step: BOOLEAN is
			-- Is there a next step to execute?
		do
			Result := interpreter.is_running and interpreter.is_ready and not steps_completed
		end

	is_precondition_satisfied: BOOLEAN
			-- Is precondition of `feature_' satisfied by `variables'?

	is_evaluation_enabled: BOOLEAN is
			-- Is feature precondition evaluation enabled?
		do
			Result := interpreter.configuration.is_precondition_checking_enabled
		end

	is_linear_constraint_solving_enabled: BOOLEAN is
			-- Is linear constraint solving for integers enabled?
		do
			Result := interpreter.configuration.is_linear_constraint_solving_enabled
		end

	has_linear_constrained_arguments: BOOLEAN is
			-- Is there any linearly constrained arguments?
		do
			Result := linear_solvable_arguments /= Void and then linear_solvable_arguments.count > 0
		end

feature -- Setting

	set_tried_count (a_tried_count: INTEGER) is
			-- Set `tried_count' with `a_tried_count'.
		do
			tried_count := a_tried_count
		ensure
			tried_count_set: tried_count = a_tried_count
		end

	set_worst_case_search_count (a_worst_case_search_count: INTEGER) is
			-- Set `worst_case_search_count' with `a_worst_case_search_count'.
		do
			worst_case_search_count := a_worst_case_search_count
		ensure
			worst_case_search_count_set: worst_case_search_count = a_worst_case_search_count
		end

	set_start_time (a_start_time: INTEGER) is
			-- Set `start_time' with `a_start_time'.
		do
			start_time := a_start_time
		ensure
			start_time_set: start_time = a_start_time
		end

	set_end_time (a_end_time: INTEGER) is
			-- Set `end_time' with `a_end_time'.
		do
			end_time := a_end_time
		ensure
			end_time_set: end_time = a_end_time
		end

feature -- Execution

	start
			-- Start execution of task.
		local
			l_list: DS_ARRAYED_LIST [ITP_VARIABLE]
		do
			if should_cancel then
				cancel
			else
				if is_evaluation_enabled then
					set_start_time (interpreter.duration_until_now.millisecond_count)
					if has_next_step then
						create l_list.make (variables.count)
						variables.do_all (agent l_list.force_last)
						if variables.count = feature_.feature_.argument_count + 1 then
							is_precondition_satisfied := interpreter.is_precondition_satisfied (feature_, l_list)
							steps_completed := is_precondition_satisfied

							if has_next_step then
								tried_count := 0
								setup_indexes
							end
						else
							cancel
						end
					end
				else
						-- If precondition evaluation is disabled, we
						-- assume the preconditions is satisfied.
					is_precondition_satisfied := True
					steps_completed := True
				end
				if steps_completed then
					set_end_time (interpreter.duration_until_now.millisecond_count)
				end
			end
		end

	step
			-- Perform the next step of the task.
		local
			l_done: BOOLEAN
			l_indexes: DS_ARRAYED_LIST [INTEGER]
			l_count: INTEGER
			l_index: INTEGER
			l_ran: INTEGER
			l_list: DS_ARRAYED_LIST [ITP_VARIABLE]
			l_variable: ITP_VARIABLE
			l_pool: like object_pool
			l_available_count: like candicate_object_count
			l_available_indexes: like candidate_object_indexes
			l_variables: like variables
			l_real_index: like real_argument_indexes
			l_real_ind: INTEGER
			l_should_continue: BOOLEAN
			l_time_now: INTEGER
		do
			l_pool := object_pool
			l_available_count := candicate_object_count
			l_available_indexes := candidate_object_indexes
			l_variables := variables
			l_real_index := real_argument_indexes
				-- Iterate to a new object combination.
			from
				l_indexes := l_available_indexes.item (current_argument_index)
				l_count := l_available_count.item (current_argument_index)
			until
				l_done
			loop
					-- If there is no candidate object for current argument, backtrack.
				if l_count = 0 then
					l_available_count.put (l_indexes.count, current_argument_index)
					current_argument_index := current_argument_index - 1
					if current_argument_index = 0 then
							-- We have exhausted all possibilities.
						steps_completed := True
						l_done := True
					end
				else
					l_real_ind := l_real_index.item (current_argument_index)
					random.forth
					l_ran := (random.item_for_iteration \\ l_count) + 1
					l_variable := l_pool.variable_table.item (types.item (l_real_ind)).item (l_indexes.item (l_ran))

					l_variables.put (l_variable, l_real_ind)
					l_indexes.swap (l_count, l_ran)
					l_count := l_count - 1
					l_available_count.put (l_count, current_argument_index)


					if
						(current_argument_index = 1 and then interpreter.variable_table.variable_type (l_variable).is_none) or else
						interpreter.variable_table.invalid_objects.has (l_variable.index)
					then
							-- A Void object is selected as the target object.
							-- Do nothing here, make the search to select another object for the target object.
						l_should_continue := False
					else
							-- If a new target object is selected, the linear constraint solving (if enabled)
							-- needs to be done again.
						if
							current_argument_index = 1 and then
							is_linear_constraint_solving_enabled and then
							has_linear_constrained_arguments
						then
							choose_constraint_arguments
							if has_constraint_model then
								l_should_continue := True
							else
								l_should_continue := False
							end
						else
							l_should_continue := True
						end

							-- If there are some arguments that are not chosen yet,
							-- continue search for them, otherwise, finish current search
							-- for one object combination.
						if l_should_continue then
							if current_argument_index = argument_count then
								l_done := True
							else
								current_argument_index := current_argument_index + 1
							end
						end
					end
				end

				if not l_done and then l_should_continue then
					l_indexes := l_available_indexes.item (current_argument_index)
					l_count := l_available_count.item (current_argument_index)
				end
			end

				-- Evaluate current preconditions on selected objects in `variables'.
			if has_next_step then
				create l_list.make (variables.count)
				l_variables.do_all (agent l_list.force_last)
				is_precondition_satisfied := interpreter.is_precondition_satisfied (feature_, l_list)
				tried_count := tried_count + 1
				steps_completed := is_precondition_satisfied

					-- Check if object searching should be stopped according to tries or time constraints.
				if max_precondition_search_tries > 0 and then tried_count > max_precondition_search_tries then
					cancel
				end

				if has_next_step then
					if max_precondition_search_time > 0 then
						l_time_now := interpreter.duration_until_now.millisecond_count
						if (l_time_now - start_time) // 1000 > max_precondition_search_time then
							cancel
						end
					end
				end
			end

			if steps_completed then
				set_end_time (interpreter.duration_until_now.millisecond_count)
			end
		end

	choose_constraint_arguments is
			-- Choose values for constraint arguments.
			-- Set those arguments directly in `variables'.
			-- If there is no model for the constraint arguments,
			-- set `has_constraint_model' to True, other set it to False.
		local
			l_state: HASH_TABLE [STRING, STRING]
			l_smt_generator: AUT_CONSTRAINT_SOLVER_GENERATOR
			l_proof_obligation: STRING
			l_constraining_queries: DS_HASH_SET [STRING]
			l_new_query_name: STRING
			l_query_name: detachable STRING
		do
				-- Ask for states of the target object.
				-- the value of constraining queries are in the retrieved states.
			l_state := interpreter.object_state (variables.item (1))
			has_constraint_model := not l_state.is_empty

				-- Generate linear constraint solving proof obligation.
			if has_constraint_model then
				create l_smt_generator
				l_smt_generator.generate_smtlib (feature_, precondition_access_pattern.item (feature_))
				check l_smt_generator.has_linear_constraints end
				l_proof_obligation := l_smt_generator.last_smtlib.twin

					-- Replace constraining queires by their actual value.
				from
					l_constraining_queries := l_smt_generator.constraining_queries
					l_constraining_queries.start
				until
					l_constraining_queries.after or else not has_constraint_model
				loop
					l_query_name := l_state.item (l_constraining_queries.item_for_iteration)
					if l_query_name = Void then
							-- If the value of some constraining query cannot be retrieved,
							-- the model for constrained arguments doesn't exist.
						has_constraint_model := False
					else
						l_new_query_name := "$" + l_constraining_queries.item_for_iteration + "$"
						l_proof_obligation.replace_substring_all (l_new_query_name, l_query_name)
					end
					l_constraining_queries.forth
				end
			end

				-- Launch constraint solver to solve constrained arguments.
			if has_constraint_model then
				generate_smtlib_file (l_proof_obligation)
				solve_arguments
			end

			if has_constraint_model then
				insert_integers_in_pool
			end
		end

	has_constraint_model: BOOLEAN
			-- It there is model for constraint arguments?

	cancel
			-- Cancel task.
		do
			steps_completed := True
			set_end_time (interpreter.duration_until_now.millisecond_count)
		end

feature{NONE} -- Implementation

	types_of_feature (a_feature: AUT_FEATURE_OF_TYPE): DS_ARRAYED_LIST [TYPE_A] is
			-- List of types (target type and argument type) of `a_feature'
		local
			l_types: LIST [TYPE_A]
		do
			create Result.make (a_feature.feature_.argument_count + 1)
			Result.force_last (a_feature.type)
			l_types := feature_argument_types (a_feature.feature_, a_feature.type)
			l_types.do_all (agent Result.force_last)
		end

	setup_indexes is
			-- Setup `candidate_object_indexes' and `candidate_object_count'.
		local
			l_type: TYPE_A
			l_objects: DS_LIST [ITP_VARIABLE]
			i: INTEGER
			l_worst_count: INTEGER
		do
			l_worst_count := 0
			types := types_of_feature (feature_)
			create candidate_object_indexes.make (types.count)
			create candicate_object_count.make (1, types.count)
			create real_argument_indexes.make (types.count)
			from
				types.start
				i := 1
			until
				types.after
			loop
				if
					types.index =1 or else
					(mentioned_argument_indexes.has (types.index) and then
					(is_linear_constraint_solving_enabled implies not linear_solvable_arguments.has (types.index - 1)))
				then
					l_type := types.item_for_iteration
					l_objects := object_pool.conforming_variables (l_type)
					candidate_object_indexes.force_last (index_interval (l_objects.count))
					candicate_object_count.put (l_objects.count, i)
					real_argument_indexes.force_last (types.index)
					if l_worst_count = 0 then
						l_worst_count := l_objects.count
					else
						l_worst_count := l_worst_count * l_objects.count
					end
					i := i + 1
				end
				types.forth
			end

			set_worst_case_search_count (l_worst_count)
			current_argument_index := 1
			argument_count := real_argument_indexes.count
		end

	candidate_object_indexes: DS_ARRAYED_LIST [DS_ARRAYED_LIST [INTEGER]]
			-- List of indexes for objects in object pool for each argument for current predicate.

	candicate_object_count: ARRAY [INTEGER]
			-- Number of objects which are to be searched yet
			-- Array index is the index for arguments.

	current_argument_index: INTEGER
			-- Index of currently searched argument

	argument_count: INTEGER
			-- Number of argument that needs to be searched
			-- argument (including call target) that are not mentioned in the precondition
			-- are not to be searched.

	index_interval (a_count: INTEGER): DS_ARRAYED_LIST [INTEGER] is
			-- List of integers from 1 to `a_count'
		local
			l_interval: INTEGER_INTERVAL
		do
			create Result.make (a_count)
			create l_interval.make (1, a_count)
			l_interval.do_all (agent (i: INTEGER; l: DS_ARRAYED_LIST [INTEGER]) do l.force_last (i) end (?, Result))
		end

	real_argument_indexes: DS_ARRAYED_LIST [INTEGER]
			-- Real argument indexes
			-- Index of this array is 1-based, and represents the i-th argument to search
			-- value in this array is the real argument index for the predicate.

	mentioned_argument_indexes: DS_HASH_SET [INTEGER]
			-- 1-based indexes of arguments that are mentioned in preconditions
			-- of current feature.
			-- The argument with index 1 is the target object
			-- The argument with index 2 is the first argument of the feature to call

	linear_solvable_arguments: DS_HASH_SET [INTEGER]
			-- Indexes of arguments that are linearly solvable
			-- 1 is the first argument (not the target)

	linear_solvable_argument_names: DS_HASH_SET [STRING]
			-- Names of linearly solvable arguments

	has_linear_constraint_argument: BOOLEAN
			-- Is there any argument that can be linearly solved?

	setup_mentioned_argument_indexes is
			-- Setup `mentioned_argument_indexes'.
		local
			l_patterns: DS_LINEAR [AUT_PREDICATE_ACCESS_PATTERN]
			l_access_pattern: DS_HASH_TABLE [INTEGER, INTEGER]
		do
			create mentioned_argument_indexes.make (variables.count)
			check precondition_access_pattern.has (feature_) end
			l_patterns := precondition_access_pattern.item (feature_)
			if l_patterns /= Void then
				from
					l_patterns.start
				until
					l_patterns.after
				loop
					l_access_pattern := l_patterns.item_for_iteration.access_pattern
					from
						l_access_pattern.start
					until
						l_access_pattern.after
					loop
						mentioned_argument_indexes.force_last (l_access_pattern.key_for_iteration + 1)
						l_access_pattern.forth
					end
					l_patterns.forth
				end
			else
				should_cancel := True
			end
		end

	setup_linear_solvable_arguments is
			-- Check if current feature to call has any linearly constraint solvable
			-- arguments, set `linear_solvable_arguments' and `has_linear_constraint_argument'
			-- accordingly.
		local
			l_patterns: DS_LIST [AUT_PREDICATE_ACCESS_PATTERN]
			l_set: like linear_solvable_arguments
		do
			l_patterns := precondition_access_pattern.item (feature_)
			if l_patterns /= Void then
				create linear_solvable_arguments.make (2)
				create linear_solvable_argument_names.make (2)
				linear_solvable_argument_names.set_equality_tester (string_equality_tester)
				from
					l_patterns.start
				until
					l_patterns.after
				loop
					if attached {AUT_LINEAR_SOLVABLE_PREDICATE} l_patterns.item_for_iteration.predicate as l_linear_pred then
						has_linear_constraint_argument := True
						l_set := l_linear_pred.constrained_argument_indexes (l_patterns.item_for_iteration)
						l_set.do_all (agent linear_solvable_arguments.force_last)
					end
					l_patterns.forth
				end
				from
					linear_solvable_arguments.start
				until
					linear_solvable_arguments.after
				loop
					linear_solvable_argument_names.force_last (normalized_argument_name (linear_solvable_arguments.item_for_iteration))
					linear_solvable_arguments.forth
				end
			end
		end

	smtlib_file_path: FILE_NAME is
			-- Full path for the generated SMT-LIB file
		do
			create Result.make_from_string (universe.project_location.workbench_path)
			Result.set_file_name ("linear.smt")
		end

	generate_smtlib_file (a_content: STRING) is
			-- Generate SMT-LIB file with `a_content'
			-- at location `smtlib_file_path'.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_create_read_write (smtlib_file_path)
			l_file.put_string (a_content)
			l_file.close
		end

	solve_arguments is
			-- Solve linear constraints for constrained argument.
			-- Store result in `last_solver_output'.
		local
			l_prc_factory: PROCESS_FACTORY
			l_prc: PROCESS
			l_model_loader: AUT_SOLVED_LINEAR_MODEL_LOADER
			l_stream: KL_STRING_INPUT_STREAM
			l_arg_table: like argument_table
			l_valuation: HASH_TABLE [INTEGER, STRING]
		do
			create l_prc_factory
			create last_solver_output.make (1024)
			l_prc := l_prc_factory.process_launcher_with_command_line (linear_constraint_solver_command (smtlib_file_path), Void)
			l_prc.redirect_output_to_agent (agent append_solver_output)
			l_prc.redirect_error_to_same_as_output
			l_prc.launch
			if l_prc.launched then
				l_prc.wait_for_exit
				last_solver_output.replace_substring_all ("%R", "")
				create l_stream.make (last_solver_output)
				l_model_loader := sovled_linear_model_loader
				l_model_loader.set_constrained_arguments (linear_solvable_argument_names)
				l_model_loader.set_input_stream (l_stream)
				l_model_loader.load_model
				has_constraint_model := l_model_loader.has_model

					-- We found a model for the constrained arguments.
					-- Store that model in `last_solved_arguments'.
				if has_constraint_model then

					l_arg_table := argument_table (feature_)
					l_valuation := l_model_loader.valuation
					create last_solved_arguments.make (l_valuation.count)
					from
						l_valuation.start
					until
						l_valuation.after
					loop
						last_solved_arguments.force (l_valuation.item_for_iteration, l_arg_table.item (l_valuation.key_for_iteration))
						l_valuation.forth
					end
				end
			else
				has_constraint_model := False
			end
		end

	argument_table (a_feature: AUT_FEATURE_OF_TYPE): HASH_TABLE [INTEGER, STRING] is
			-- Table of arguments of `a_feature'.
			-- [1-based argument index, argument name]
		local
			l_feat: FEATURE_I
			i: INTEGER
			l_arg_count: INTEGER
		do
			l_feat := a_feature.feature_
			l_arg_count := l_feat.argument_count
			create Result.make (l_arg_count)
			Result.compare_objects
			from
				i := 1
			until
				i > l_arg_count
			loop
				Result.force (i, l_feat.arguments.item_name (i))
				i := i + 1
			end
		end

	insert_integers_in_pool is
			-- Insert model in `last_solved_arguments' in object pool.
			-- Update arguments in `variables' accordingly.
		local
			l_constant: ITP_CONSTANT
			l_variable: ITP_VARIABLE
		do
			from
				last_solved_arguments.start
			until
				last_solved_arguments.after
			loop
				create l_constant.make (last_solved_arguments.item_for_iteration)
				l_variable := interpreter.variable_table.new_variable
				interpreter.assign_expression (l_variable, l_constant)
				variables.put (l_variable, last_solved_arguments.key_for_iteration + 1)

				last_solved_arguments.forth
			end
		end

	last_solver_output: STRING
			-- Output from last launched solver

	append_solver_output (a_string: STRING) is
			-- Append `a_string' at the end of `last_solver_output'.
		do
			last_solver_output.append (a_string)
		end

	last_solved_arguments: HASH_TABLE [INTEGER, INTEGER]
			-- Table of last linearly sovled arguments
			-- [argument value, argument index]
			-- Argument index is 1-based.

	max_precondition_search_tries: INTEGER
			-- See `interpreter'.`configuration'.`max_precondition_search_tries'.
		do
			Result := interpreter.configuration.max_precondition_search_tries
		ensure
			good_result: Result = interpreter.configuration.max_precondition_search_tries
		end

	max_precondition_search_time: INTEGER
			-- See `interpreter'.`configuration'.`max_precondition_search_time'.
		do
			Result := interpreter.configuration.max_precondition_search_time
		ensure
			good_result: Result = interpreter.configuration.max_precondition_search_time
		end

	should_cancel: BOOLEAN
			-- Should current task be canceled?

;note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
