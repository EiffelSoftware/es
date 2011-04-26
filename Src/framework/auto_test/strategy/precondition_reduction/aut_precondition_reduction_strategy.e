note
	description: "[
		Precondition reduction startegy
		This strategy tries to generate objects that violate the pre-state
		invariants that have been observed in already generated test cases.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PRECONDITION_REDUCTION_STRATEGY

inherit
	AUT_STRATEGY
		redefine
			make,
			start,
			cancel
		end

	AUT_SHARED_EQUALITY_TESTER

	EPA_UTILITY
		undefine
			system
		end

	EPA_SOLVER_UTILITY
		undefine
			system
		end

	EPA_SHARED_EQUALITY_TESTERS
		undefine
			system
		end

	EPA_SHARED_CLASS_THEORY

	EPA_STRING_UTILITY
		undefine
			system
		end

	ITP_SHARED_CONSTANTS

	EQA_TEST_CASE_SERIALIZATION_UTILITY

	EPA_STRING_UTILITY
		undefine
			system
		end

	AUT_SHARED_ONLINE_STATISTICS

create
	make

feature {NONE} -- Initialization

	make (a_interpreter: like interpreter; a_system: like system; an_error_handler: like error_handler)
			-- Create new strategy.	
		do
			Precursor (a_interpreter, a_system, an_error_handler)
			create prestate_predicates.make

			create satisfied_prestate_predicates.make (50)
			satisfied_prestate_predicates.set_equality_tester (aut_state_invariant_equality_tester)

			create unfinished_prestate_predicates.make (50)
			unfinished_prestate_predicates.set_equality_tester (aut_state_invariant_equality_tester)

			create prestate_predicates_by_feature.make (100)
			prestate_predicates_by_feature.compare_objects

			create tautologies_by_feature.make (100)
			tautologies_by_feature.compare_objects

			create invalid_predicates_by_feature.make (100)
			invalid_predicates_by_feature.compare_objects

			create ids_of_processed_invariants.make (50)
			ids_of_processed_invariants.set_equality_tester (string_equality_tester)

			connection := interpreter.configuration.semantic_database_config.connection
			connection.connect
			load_prestate_predicates

			if configuration.should_check_invariant_violating_objects then
					-- Check invariant-violating objects only,
					-- do not perform testing.
				check_invariant_violating_objects (prestate_predicates)
				prestate_predicates.wipe_out
			else
				setup_query_log_manager
				setup_progress_log_manager
			end
		end

feature -- Status report


	has_next_step: BOOLEAN
			-- <Precursor>
		do
			Result := not prestate_predicates.is_empty
		end

feature {ROTA_S, ROTA_TASK_I, ROTA_TASK_COLLECTION_I} -- Status setting

	start
			-- Perform a start step.
		do
			Precursor
			interpreter.set_is_in_replay_mode (False)
			assign_void
		end

	cancel
		do
			prestate_predicates.wipe_out
			if sub_task /= Void and then sub_task.has_next_step then
				sub_task.cancel
			end
			sub_task := Void
			interpreter.stop
		end

	step
		local
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_invalids: like invalid_predicates
			l_inv_message: STRING
			l_object_selector_reductor: AUT_OBJECT_SELECTION_PRECONDITION_REDUCTOR
			l_state_changing_reductor: AUT_STATE_CHANGING_PRECONDITION_REDUCTOR
		do
				-- Get, and remove, one invariant to process each step.
			select_current_predicate
			online_statistics.set_last_fault_meta (current_predicate.structure + ";" + current_predicate.expression.text)
			if not ids_of_processed_invariants.has (current_predicate.invariant_id) then
				if not current_predicate.is_implication then
					ids_of_processed_invariants.force_last (current_predicate.invariant_id)
				end
				l_class := current_predicate.context_class
				l_feature := current_predicate.feature_
				l_inv_message := class_name_dot_feature_name (current_predicate.context_class, current_predicate.feature_) + " : " + current_predicate.text
				if current_predicate.is_implication then
					l_inv_message := l_inv_message + ", for invalidating " + " old (" + current_predicate.pre_state_context_expression.text + ") implies " + current_predicate.post_state_context_expression.text
				end

				progress_log_manager.put_string_with_time ("Try to satisfy: " + current_predicate.structure + " : " + l_inv_message + " ")
				interpreter.log_precondition_reduction ("Try to satisfy: " + l_inv_message)

					-- We first check if the current pre-state invariant is a tautology w.r.t. current class invairants.
					-- If so, we don't need to do anything, because by definition, that pre-state invariant cannot be violated.
				if current_predicate.text.has ('~') then
						-- We cannot handle object equality in the BoogiePL generation yet,
						-- so all predicates with object equalities are never ignored by the
						-- precondition reduction algorithm.
					create l_invalids.make (1)
					l_invalids.set_equality_tester (expression_equality_tester)
				else
					l_invalids := invalid_predicates (l_class, l_feature, predicates_as_expressions (prestate_predicates_by_feature.item (class_name_dot_feature_name (l_class, l_feature))))
				end
				if l_invalids.has (current_predicate.expression) then
					progress_log_manager.put_string (" [Invalid]")
					interpreter.log_precondition_reduction ("Failed in satisfying: " + l_inv_message + " [Invalid]")
				else
						-- We try to search in the semantic database to see if there are some object combination
						-- which satisfies `current_predicate'. If so, we use those objects as our new test inputs.
					l_object_selector_reductor := object_selection_reductor
					execute_task (l_object_selector_reductor)

					if l_object_selector_reductor.is_reduction_successful then
						progress_log_manager.put_string (" [Satisfied]")
						interpreter.log_precondition_reduction ("Succeeded in satisfying: " + l_inv_message)
						if current_predicate.is_implication then
							progress_log_manager.put_string (" [Implication invalidated] ")
							ids_of_processed_invariants.force_last (current_predicate.invariant_id)
						end
					else
						if current_predicate.is_implication then
							progress_log_manager.put_string (" [Implication not invalidated] ")
							interpreter.log_precondition_reduction ("Failed in satisfying: " + l_inv_message)
						else
								-- We try to use feature calls to change objects into states
								-- that satisfy `current_predicate'.
							l_state_changing_reductor := state_changing_reductor
							execute_task (l_state_changing_reductor)
							if l_state_changing_reductor.is_reduction_successful then
								progress_log_manager.put_string (" [Transition Satisfied]")
								interpreter.log_precondition_reduction ("Succeeded in satisfying: " + l_inv_message)
							else
								progress_log_manager.put_string (" [Not satisfied]")
								interpreter.log_precondition_reduction ("Failed in satisfying: " + l_inv_message)
							end
						end
					end
				end
				progress_log_manager.put_line ("")
			end
		end

	select_current_predicate
			-- Select next predicate from `prestae_predicates' as `current_predicate'
		do
			current_predicate := prestate_predicates.first
			prestate_predicates.start
			prestate_predicates.remove
		end

	object_selection_reductor : AUT_OBJECT_SELECTION_PRECONDITION_REDUCTOR
			-- Reductor which only selects existing objects from semantic database, which
			-- satisfy `current_predicate'
		do
			create Result.make (system, interpreter, error_handler, current_predicate, connection)
			Result.set_progress_log_manager (progress_log_manager)
			Result.set_query_log_manager (query_log_manager)
		end

	state_changing_reductor : AUT_STATE_CHANGING_PRECONDITION_REDUCTOR
			-- Reductor which can call features to change object states to
			-- satisfy `current_predicate'
		do
			create Result.make (system, interpreter, error_handler, current_predicate, connection)
			Result.set_progress_log_manager (progress_log_manager)
			Result.set_query_log_manager (query_log_manager)
		end

feature{NONE} -- Implementation

	execute_task (a_task: AUT_TASK)
			-- Execute `a_task' until it is finished.
		do
			from
				a_task.start
			until
				not a_task.has_next_step
			loop
				if interpreter.is_running and not interpreter.is_ready then
					interpreter.stop
				end
				if not interpreter.is_running then
					a_task.cancel
					interpreter.start
					assign_void
				end
				if interpreter.is_running and interpreter.is_ready then
					a_task.step
				else
					a_task.cancel
				end
			end
		end

feature{NONE} -- Implementation

	sub_task: AUT_TASK
			-- Current sub task

	configuration: TEST_GENERATOR
			-- Config of current test session
		do
			Result := interpreter.configuration
		end

	connection: MYSQL_CLIENT
			-- Database connection

	current_predicate: AUT_STATE_INVARIANT
			-- Predicate that we are currently trying to SATISFY.

	prestate_predicates: LINKED_LIST [AUT_STATE_INVARIANT]
			-- List of pre-state predicates that are to be satisfied

	prestate_predicates_by_feature: HASH_TABLE [DS_HASH_SET [AUT_STATE_INVARIANT], STRING]
			-- List of pre-state predicates, organized by features
			-- Keys are feature identifier, in form of "CLASS_NAME.feature_name",
			-- values are pre-state predicates associated with those features

	satisfied_prestate_predicates: DS_HASH_SET [AUT_STATE_INVARIANT]
			-- Set of pre-state predicates that are already satisfied

	unfinished_prestate_predicates: DS_HASH_SET [AUT_STATE_INVARIANT]
			-- Set of pre-state predicates that we fail to satisfy
			-- after a maximum steps of tries

	tautologies_by_feature: HASH_TABLE [DS_HASH_SET [EPA_EXPRESSION], STRING]
			-- Tautology expressions in pre-state of features
			-- Keys are feature identifiers in form of "CLASS_NAME.feature_name",
			-- values are tautologies in the pre-state of those features.

	invalid_predicates_by_feature: HASH_TABLE [DS_HASH_SET [EPA_EXPRESSION], STRING]
			-- Invalid expressions in pre-state of features
			-- Keys are feature identifiers in form of "CLASS_NAME.feature_name",
			-- values are invalid predicates in the pre-state of those features.

feature{NONE} -- Implementation/precondition reduction

	assign_void
			-- Assign void to the next free variable.
			-- Note: Copied from {AUT_RANDOM_STRATEGY}
			-- This causes code duplication, but avoid merge
			-- problem when synchronizing with trunk.
		local
			void_constant: ITP_CONSTANT
		do
			if interpreter.is_running and interpreter.is_ready then
				create void_constant.make (Void)
				interpreter.assign_expression (interpreter.variable_table.new_variable, void_constant)
			end
		end

	load_prestate_predicates
			-- Load pre-state invariants into `prestate_predicates'.
		local
			l_loader: AUT_PRESTATE_INVARIANT_LOADER
		do
			create l_loader
			l_loader.load (configuration.prestate_invariant_path)
			prestate_predicates.append (l_loader.last_invariants)
			put_predicates_in_prestate_predicates_by_feature (l_loader.last_invariants)
		end

	tautology_predicates (a_class: CLASS_C; a_feature: FEATURE_I; a_candidates: DS_HASH_SET [EPA_EXPRESSION]): DS_HASH_SET [EPA_EXPRESSION]
			-- Tautology predicates from `a_candidates'.
			-- Expression validity is check in the context of `a_feature' from `a_class'.
			-- Tautology is nice, because if we know that some expression are valid in the context of `a_feature' from `a_class',
			-- we don't need to find objects violating that expression anymore -- because there must be no such objects.
			-- Note: This feature breaks the Command-Query separation, it will update
			-- `tautologies_by_feature' when necessary.
		local
			l_feat_id: STRING
		do
			l_feat_id := class_name_dot_feature_name (a_class, a_feature)
			tautologies_by_feature.search (l_feat_id)
			if tautologies_by_feature.found then
				Result := tautologies_by_feature.found_item
			else
					-- If feature pre-state tautologies have not
					-- been checked, we do that now.
				Result := tautologies_in_feature_context (a_class, a_feature, a_candidates)
				tautologies_by_feature.force (Result, l_feat_id)
			end
		end

	invalid_predicates (a_class: CLASS_C; a_feature: FEATURE_I; a_candidates: DS_HASH_SET [EPA_EXPRESSION]): DS_HASH_SET [EPA_EXPRESSION]
			-- Invalid predicates from `a_candidates'.
			-- Expression invalidity is check in the context of `a_feature' from `a_class'.
			-- Note: This feature breaks the Command-Query separation, it will update
			-- `invalid_predicates_by_feature' when necessary.
		local
			l_feat_id: STRING
			l_negations: DS_HASH_SET [EPA_EXPRESSION]
			l_negation_map: DS_HASH_TABLE [EPA_EXPRESSION, EPA_EXPRESSION]
			l_negated_expr: EPA_AST_EXPRESSION
			l_expr: EPA_EXPRESSION
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
		do
			l_feat_id := class_name_dot_feature_name (a_class, a_feature)
			invalid_predicates_by_feature.search (l_feat_id)
			if invalid_predicates_by_feature.found then
				Result := invalid_predicates_by_feature.found_item
			else
					-- If feature pre-state invalid expressions have not
					-- been checked, we do that now.
				create l_negations.make (a_candidates.count)
				l_negations.set_equality_tester (expression_equality_tester)
				create l_negation_map.make (a_candidates.count)
				l_negation_map.set_key_equality_tester (expression_equality_tester)
				from
					l_cursor := a_candidates.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					l_expr := l_cursor.item
					create l_negated_expr.make_with_text (l_expr.class_, l_expr.feature_, "not (" + l_expr.text + ")", l_expr.written_class)
					if l_negated_expr.type /= Void then
						l_negations.force_last (l_negated_expr)
						l_negation_map.force_last (l_expr, l_negated_expr)
					end
					l_cursor.forth
				end
				create Result.make (a_candidates.count)
				from
					l_cursor := tautologies_in_feature_context (a_class, a_feature, l_negations).new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					Result.force_last (l_negation_map.item (l_cursor.item))
					l_cursor.forth
				end
				invalid_predicates_by_feature.force (Result, l_feat_id)
			end
		end


	predicates_as_expressions (a_predicates: DS_HASH_SET [AUT_STATE_INVARIANT]): DS_HASH_SET [EPA_EXPRESSION]
			-- List of expressions from `a_predicates'
		local
			l_cursor: DS_HASH_SET_CURSOR [AUT_STATE_INVARIANT]
		do
			create Result.make (a_predicates.count)
			Result.set_equality_tester (expression_equality_tester)
			from
				l_cursor := a_predicates.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.force_last (l_cursor.item.expression)
				l_cursor.forth
			end
		end

	ids_of_processed_invariants: DS_HASH_SET [STRING]
			-- Set of processed invariants, in form of "CLASS_NAME.feature_name.invariant_text"			

feature{NONE} -- Invariant-violating invariants checking

	put_predicates_in_prestate_predicates_by_feature (a_predicates: LINKED_LIST [AUT_STATE_INVARIANT])
			-- Put `a_predicates' into `prestate_predicates_by_feature'.
		local
			l_feat_id: STRING
			l_set: DS_HASH_SET [AUT_STATE_INVARIANT]
			l_inv_by_feat: like prestate_predicates_by_feature
		do
			l_inv_by_feat := prestate_predicates_by_feature
			across a_predicates as l_invs loop
				l_feat_id := l_invs.item.feature_id
				l_inv_by_feat.search (l_feat_id)
				if l_inv_by_feat.found then
					l_set := l_inv_by_feat.found_item
				else
					create l_set.make (100)
					l_set.set_equality_tester (aut_state_invariant_equality_tester)
					l_inv_by_feat.force (l_set, l_feat_id)
				end
				l_set.force_last (l_invs.item)
			end
		end

	processed_predicates (a_path: STRING): DS_HASH_SET [STRING]
			-- List of predicates that are already processed, given
			-- the file name storing all the processed predicates in `a_path'.
		local
			l_parts: LIST [STRING]
			l_file: PLAIN_TEXT_FILE
		do
			create Result.make (1000)
			Result.set_equality_tester (string_equality_tester)

			create l_file.make (a_path)
			if l_file.exists then
				create l_file.make_open_read (configuration.data_output)
				from
					l_file.read_line
				until
					l_file.after
				loop
					if not l_file.last_string.is_empty then
						l_parts := l_file.last_string.split ('%T')
						if l_parts.count = 4 then
							Result.force_last (l_parts.first)
						end
					end
					l_file.read_line
				end
				l_file.close
			end
		end

	check_invariant_violating_objects (a_invariants: LINKED_LIST [AUT_STATE_INVARIANT])
			-- Check if there are objects violating invariants from `a_invariants'.
			-- Put invariants with no violating objects into `configuration'.`data_output'.
		local
			l_retriever: AUT_QUERYABLE_QUERYABLE_RETRIEVER
			l_processed: DS_HASH_SET [STRING]
			l_tautologies: DS_HASH_SET [EPA_EXPRESSION]
			l_log_manager: ELOG_LOG_MANAGER
			l_log_file_name: FILE_NAME
			l_result_log: ELOG_LOG_MANAGER
			l_gen: AUT_OBJECT_STATE_RETRIEVAL_FEATURE_GENERATOR
			l_inv: AUT_STATE_INVARIANT
		do
			create l_log_file_name.make_from_string (configuration.output_dirname)
			l_log_file_name.set_file_name ("queries.txt")
			create l_log_manager.make_with_logger_array (<<create {ELOG_FILE_LOGGER}.make_with_path (l_log_file_name)>>)
			l_log_manager.set_start_time_as_now
			l_log_manager.set_duration_time_mode

				-- Check which invariants are already processed in
				-- `configuration'.`data_output'.
			l_processed := processed_predicates (configuration.data_output)

			create l_result_log.make_with_logger_array (
				<<create {ELOG_FILE_LOGGER}.make_with_path (configuration.data_output),
				  create {ELOG_CONSOLE_LOGGER}>>)
			l_result_log.set_duration_time_mode
			l_result_log.set_start_time_as_now
			l_result_log.put_line ("%N")
				-- Iterate through invariants in `a_invariants' and
				-- for each invariant, check if there exists some objects
				-- in the semantic database which break that invariant.
			create l_retriever
			l_retriever.set_log_manager (l_log_manager)
			across a_invariants as l_invs loop
				l_inv := l_invs.item
				if not l_processed.has (l_invs.item.id) then
					create l_gen
					l_gen.generate_for_expressions (
						predicates_by_feature (l_inv.context_class, l_inv.feature_),
						l_inv.context_class,
						l_inv.feature_,
						True,
						False,
						l_inv.context_class.constraint_actual_type)
					l_processed.force_last (l_invs.item.id)
						-- We first check if the invariant is a tautology.
					l_tautologies := tautology_predicates (
						l_invs.item.context_class,
						l_invs.item.feature_,
						predicates_as_expressions (prestate_predicates_by_feature.item (l_invs.item.feature_id)))

						-- We only check invariants which are not tautologies.
					l_result_log.put_string_with_time (l_invs.item.context_class.name_in_upper + "%T" + l_invs.item.feature_.feature_name + "%T" + l_invs.item.expression.text)
					if l_tautologies.has (l_invs.item.expression) then
						l_result_log.put_line ("%T[Theory]")
					else
						l_retriever.retrieve_objects (
							l_invs.item.expression,
							l_invs.item.context_class,
							l_invs.item.feature_,
							False,
							False,
							connection, Void, True, 0, True)
						if l_retriever.last_objects.is_empty then
							l_result_log.put_line ("%T[No]")
						else
							l_result_log.put_line ("%T[Objects]")
						end
					end
				end
			end
		end

	predicates_by_feature (a_class: CLASS_C; a_feature: FEATURE_I): LINKED_LIST [EPA_EXPRESSION]
			-- Predicates by `a_feature' in `a_class', data
			-- comes from `prestate_predicates_by_feature'.
		local
			l_cursor: DS_HASH_SET_CURSOR [AUT_STATE_INVARIANT]
			l_feature: STRING
		do
			create Result.make
			l_feature := class_name_dot_feature_name (a_class, a_feature)
			if prestate_predicates_by_feature.has (l_feature) then
				from
					l_cursor := prestate_predicates_by_feature.item (l_feature).new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					Result.extend (l_cursor.item.expression)
					l_cursor.forth
				end
			end
			Result.extend (create {EPA_AST_EXPRESSION}.make_with_text (a_class, a_feature, "Current ~ v", a_class))
		end

feature{NONE} -- Logging

	query_log_manager: ELOG_LOG_MANAGER
			-- Manger to print executed SQL statement information

	progress_log_manager: ELOG_LOG_MANAGER
			-- Manager to log progress of precondition reduction

	setup_query_log_manager
			-- Setup `query_log_manager'.
		local
			l_log_file_name: FILE_NAME
		do
			create l_log_file_name.make_from_string (configuration.log_dirname)
			l_log_file_name.set_file_name ("precondition_reduction_queries.txt")
			create query_log_manager.make_with_logger_array (<<create {ELOG_FILE_LOGGER}.make_with_path (l_log_file_name)>>)
			query_log_manager.set_start_time_as_now
			query_log_manager.set_duration_time_mode
		end

	setup_progress_log_manager
			-- Setup `progress_log_manager'.
		local
			l_log_file_name: FILE_NAME
		do
			create l_log_file_name.make_from_string (configuration.log_dirname)
			l_log_file_name.set_file_name ("precondition_reduction_progress.txt")
			create progress_log_manager.make_with_logger_array (<<create {ELOG_FILE_LOGGER}.make_with_path (l_log_file_name), create {ELOG_CONSOLE_LOGGER}>>)
			progress_log_manager.set_start_time_as_now
			progress_log_manager.set_duration_time_mode
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
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

