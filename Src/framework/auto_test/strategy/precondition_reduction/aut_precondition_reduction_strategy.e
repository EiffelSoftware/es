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

create
	make

feature {NONE} -- Initialization

	make (a_interpreter: like interpreter; a_system: like system; an_error_handler: like error_handler)
			-- Create new strategy.
		do
			Precursor (a_interpreter, a_system, an_error_handler)
			create prestate_invariants.make

			create violated_prestate_invariants.make (50)
			violated_prestate_invariants.set_equality_tester (aut_state_invariant_equality_tester)

			create failed_prestate_invariants.make (50)
			failed_prestate_invariants.set_equality_tester (aut_state_invariant_equality_tester)

			create prestate_invariants_by_feature.make (100)
			prestate_invariants_by_feature.compare_objects

			create tautologies_by_feature.make (100)
			tautologies_by_feature.compare_objects

			connection := interpreter.configuration.semantic_database_config.connection
			load_prestate_invariants

			if configuration.should_check_invariant_violating_objects then
					-- Check invariant-violating objects only,
					-- do not perform testing.
				check_invariant_violating_objects (prestate_invariants)
				prestate_invariants.wipe_out
			end
		end

feature -- Status report

	has_next_step: BOOLEAN
			-- <Precursor>
		do
			Result := not prestate_invariants.is_empty
		end

feature {ROTA_S, ROTA_TASK_I, ROTA_TASK_COLLECTION_I} -- Status setting

	start
			-- Perform a start step.
		do
			Precursor
			interpreter.set_is_in_replay_mode (False)
			assign_void
--			if queue.highest_dynamic_priority > 0 then
--				select_new_sub_task
--			end
		end

	cancel
		do
			sub_task := Void
			interpreter.stop
		end

	step
		do
--			if interpreter.is_running and interpreter.is_ready then
--				sub_task.step
--			end
--			if interpreter.is_running and not interpreter.is_ready then
--				interpreter.stop
--			end
--			if not interpreter.is_running then
--				if sub_task /= Void and then sub_task.has_next_step then
--					sub_task.cancel
--				end
--				interpreter.start
--				assign_void
--			end
--			if not sub_task.has_next_step then
--				if queue.highest_dynamic_priority > 0 then
--					select_new_sub_task
--				else
--					sub_task := Void
--				end
--			end
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

	prestate_invariants: LINKED_LIST [AUT_STATE_INVARIANT]
			-- List of pre-state invariants that are to be considered

	prestate_invariants_by_feature: HASH_TABLE [DS_HASH_SET [AUT_STATE_INVARIANT], STRING]
			-- List of pre-state invariants, organized by features
			-- Keys are feature identifier, in form of "CLASS_NAME.feature_name",
			-- values are pre-state invariants associated with those features

	violated_prestate_invariants: DS_HASH_SET [AUT_STATE_INVARIANT]

			-- Set of pre-state invariants that are already violated

	failed_prestate_invariants: DS_HASH_SET [AUT_STATE_INVARIANT]
			-- Set of pre-state invariants that we fail to violate
			-- (after a maximum steps of tries)

	tautologies_by_feature: HASH_TABLE [DS_HASH_SET [EPA_EXPRESSION], STRING]
			-- Tautology expressions in pre-state of features
			-- Keys are feature identifiers in form of "CLASS_NAME.feature_name",
			-- values are tautologies in the pre-state of those features.

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

	load_prestate_invariants
			-- Load pre-state invariants into `prestate_invariants'.
		local
			l_loader: AUT_PRESTATE_INVARIANT_LOADER
		do
			create l_loader
			l_loader.load (configuration.prestate_invariant_path)
			prestate_invariants.append (l_loader.last_invariants)
			put_invariants_in_prestate_invariants_by_feature (l_loader.last_invariants)
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

	invariants_as_expressions (a_invariants: DS_HASH_SET [AUT_STATE_INVARIANT]): DS_HASH_SET [EPA_EXPRESSION]
			-- List of expressions from `a_invariants'
		local
			l_cursor: DS_HASH_SET_CURSOR [AUT_STATE_INVARIANT]
		do
			create Result.make (a_invariants.count)
			Result.set_equality_tester (expression_equality_tester)
			from
				l_cursor := a_invariants.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.force_last (l_cursor.item.expression)
				l_cursor.forth
			end
		end

feature{NONE} -- Invariant-violating invariants checking

	put_invariants_in_prestate_invariants_by_feature (a_invariants: LINKED_LIST [AUT_STATE_INVARIANT])
			-- Put `a_invariants' into `prestate_invariants_by_feature'.
		local
			l_feat_id: STRING
			l_set: DS_HASH_SET [AUT_STATE_INVARIANT]
			l_inv_by_feat: like prestate_invariants_by_feature
		do
			l_inv_by_feat := prestate_invariants_by_feature
			across a_invariants as l_invs loop
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

	processed_invariants (a_path: STRING): DS_HASH_SET [STRING]
			-- List of invariants that are already processed, given
			-- the file name storing all the processed invariants in `a_path'.
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
						if not l_file.last_string.starts_with (once "---")  then
							l_parts := l_file.last_string.split (';')
							if l_parts.count = 2 then
								Result.force_last (l_parts.first)
							end
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
		do
			create l_log_file_name.make_from_string (configuration.output_dirname)
			l_log_file_name.set_file_name ("queries.txt")
			create l_log_manager.make_with_logger_array (<<create {ELOG_FILE_LOGGER}.make_with_path (l_log_file_name)>>)
			l_log_manager.set_start_time_as_now
			l_log_manager.set_duration_time_mode

				-- Check which invariants are already processed in
				-- `configuration'.`data_output'.
			l_processed := processed_invariants (configuration.data_output)

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
				if not l_processed.has (l_invs.item.id) then
					l_processed.force_last (l_invs.item.id)
						-- We first check if the invariant is a tautology.
					l_tautologies := tautology_predicates (
						l_invs.item.context_class,
						l_invs.item.feature_,
						invariants_as_expressions (prestate_invariants_by_feature.item (l_invs.item.feature_id)))

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
							connection)
						if l_retriever.last_objects.is_empty then
							l_result_log.put_line ("%T[No]")
						else
							l_result_log.put_line ("%T[Objects]")
						end
					end
				end
			end
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
