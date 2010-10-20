note
	description: "Class to match queryables in returned search results"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_QUERYABLE_MATCHER

inherit
	SEM_SHARED_EQUALITY_TESTER

	SHARED_WORKBENCH

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize.
		do
		end

feature -- Access

	query_config: SEM_QUERY_CONFIG
			-- The original query config

	query_result: IR_QUERY_RESULT
			-- Result from the query execution

	last_matches: LINKED_LIST [SEM_QUERYABLE_MATCHING_RESULT]
			-- Last matched objects

feature -- Access/Performance statistics

	last_match_start_time: DATE_TIME
			-- Time when matching starts

	last_match_end_time: DATE_TIME
			-- Time when matching ends

feature -- Basic operations

	match (a_query_config: SEM_QUERY_CONFIG; a_query_result: IR_QUERY_RESULT)
			-- Match objects from `a_query_result' to `a_query_config',
			-- make result available in `last_matches'.
		local
			l_candidates: LINKED_LIST [SEM_CANDIDATE_QUERYABLE]
			l_candidate: SEM_CANDIDATE_QUERYABLE
			l_searched_criteria: DS_HASH_SET [SEM_MATCHING_CRITERION]
			l_mentioned_variables_in_criterion: DS_HASH_SET [INTEGER] -- Indexes of variables that are mentioned in searchable criteria in the query.
			l_query_data: SEM_SEARCHED_QUERYABLE_DATA
		do
				-- Construct candidate objects from query results.
			create l_candidates.make
			across a_query_result.documents as l_documents loop
				create l_candidate.make_from_document (l_documents.item)
				if l_candidate.is_valid then
					l_candidates.extend (l_candidate)
				end
			end

				-- Construct data from `a_query_config'.
			create l_query_data.make (a_query_config)
			l_searched_criteria := l_query_data.searched_criteria
			l_mentioned_variables_in_criterion := l_query_data.variables_unmentioned_in_searched_criteria

				-- Iterate through all candidate object document,
				-- perform variable matching for each document.
			create last_match_start_time.make_now
			create last_matches.make
			across l_candidates as l_candidate_list loop
				match_document (l_query_data, l_candidate_list.item)
			end
			create last_match_end_time.make_now
		end

feature{NONE} -- Implementation

	match_document (a_query_data: SEM_SEARCHED_QUERYABLE_DATA; a_document: SEM_CANDIDATE_QUERYABLE)
			-- Match `a_document' to the query specified through `a_query_data'.
			-- Extend result in `last_matches'.
		local
			l_matching: like matching_possibilities
			l_levels: ARRAYED_LIST [TUPLE [searched_criterion: SEM_MATCHING_CRITERION; cursor: LINKED_LIST_ITERATION_CURSOR [SEM_MATCHING_CRITERION]]]
				-- Levels for variable-object binding.
				-- Each level represents a searched criterion, the matching will start for the first criterion, and go through all criteria.				
				-- `searched_criterion' represents a criterion in the query, `cursor' is a cursor which iterate through all candidates
				-- retrieved from the result document for that `searched_criterion'.
			l_match: SEM_MATCHING
			l_cur_cursor: LINKED_LIST_ITERATION_CURSOR [SEM_MATCHING_CRITERION]  -- The candidate cursor in current level
			l_cur_level: INTEGER      -- Current level
			l_level_count: INTEGER    -- The number of total levels.
			l_full_solution_found: BOOLEAN -- Is a solution found.
			l_matched_variables, l_mvars, l_newly_matched_variables: HASH_TABLE [INTEGER, INTEGER]
				-- Already established variable-object bindings, key is index of variables from the query side,
				-- value is the index of the matched object from the `a_document', -1 means that particular variable (from the query side) is not matched.
			l_var_fixture: like is_fixed_variables_matched  -- Data describing how a particular criterion can be matched.
			l_searched_criterion: SEM_MATCHING_CRITERION    -- Current searched criterion under consideration.
			l_cur_criterion: SEM_MATCHING_CRITERION         -- Current candidate criterion which may be matched to `l_searched_criterion'
			l_open_slots: LINKED_LIST [TUPLE [var_id: INTEGER; obj_id: INTEGER]]
				-- `l_open_slots' is a list of variable-object bindings that `a_criterion' can
				-- contribute to the already established bindings in `a_matched_variables'. `var_id' is the index of a variable in the query side,			
			l_steps, l_max_partial_steps, l_solution_steps: LINKED_LIST [TUPLE [matches: LINKED_LIST [TUPLE [var_id: INTEGER; obj_id: INTEGER]]; criterion: SEM_MATCHING_CRITERION; candidate_criterion: SEM_MATCHING_CRITERION]]
				-- All variable-object mapping steps that are performed so far, used for back-tracking.
				-- `var_id' is the index of a variable in the query side, `obj_id' is the index of an object in the result document side.
				-- `criterion' is the matched crierion from the query side.
				-- `candidate_criterion' is the criterion from the document side.
				-- `l_mat_partial_steps' are the longest matching that we have seen so far.			
			l_exhausted: BOOLEAN -- Have we already exhausted all matching possibilities?					
			l_unmentioned_unmatched_variables: DS_HASH_SET [INTEGER] -- Set of indexes of variables (from the query side) that are both unmentioned in searched criteria and unmatched so far.
			l_result: SEM_QUERYABLE_MATCHING_RESULT
			l_is_last_match_complete: BOOLEAN
		do
			l_matching := matching_possibilities (a_query_data.searched_criteria, a_document)

				-- Build up all levels that can be back-tracked.
			l_is_last_match_complete := True
			create l_levels.make (l_matching.count)
			across l_matching as l_matchings loop
				l_match := l_matchings.item
				if l_match.has_candidate then
					l_cur_cursor := l_match.candidate_criteria.new_cursor
					l_cur_cursor.start
					l_levels.extend ([l_match.searched_criterion, l_cur_cursor])
				else
					if l_match.should_be_matched then
						if l_is_last_match_complete then
							l_is_last_match_complete := False
						end
					end
				end
			end

				-- Initialize matched variable indexes.
			create l_matched_variables.make (a_query_data.query_config.variable_count)
			variable_indexes_from_queryable (a_query_data.queryable).do_all (agent l_matched_variables.force (-1, ?))

				-- Use back-track to do object matching.			
			l_cur_level := 0
			l_level_count := l_levels.count
			if l_level_count > 0 then
					-- There are some criteria to satisfy, use back-track to satisfy all of them.
				create l_steps.make
				create l_max_partial_steps.make
				from
					l_cur_level := 1
					l_cur_cursor := l_levels.i_th (l_cur_level).cursor
					l_searched_criterion := l_levels.i_th (l_cur_level).searched_criterion
					l_exhausted := l_cur_cursor.after
				until
					l_full_solution_found or l_exhausted
				loop
					if l_cur_cursor.after then
							-- We exhausted current level, need to back-track.										
							-- First, undo all matches in the last step.						
						if l_cur_level > 1 then
							check not l_steps.is_empty end
							l_steps.finish
							across l_steps.item.matches as l_slots loop
								l_matched_variables.force (-1, l_slots.item.var_id)
							end
							l_steps.remove
								-- Second, move current cursor to the first position.
							l_cur_cursor.start
						end

							-- Third, go one level back.
						l_cur_level := l_cur_level - 1
						if l_cur_level = 0 then
								-- We exhausted all possibilities, must terminate now.
							l_exhausted := True
						else
							l_searched_criterion := l_levels.i_th (l_cur_level).searched_criterion
							l_cur_cursor := l_levels.i_th (l_cur_level).cursor
							l_cur_cursor.forth
						end
					else
							-- Check if the object combination under current cursor position will fix more variables.
						l_cur_criterion := l_cur_cursor.item
						l_var_fixture := is_fixed_variables_matched (l_searched_criterion, l_cur_criterion, l_matched_variables)
						if l_var_fixture.is_matched then
								-- We made progress in the matching, can now move to the next level.
								-- First, we setup the newly fixed variables.
							l_open_slots := l_var_fixture.open_operands
							l_steps.extend ([l_open_slots, l_searched_criterion, l_cur_criterion])
								-- Update `l_max_partial_steps' when we improves in matching more criteria.
							if l_steps.count > l_max_partial_steps.count then
								l_max_partial_steps.wipe_out
								across l_steps as l_tmp_steps loop
									l_max_partial_steps.extend (l_tmp_steps.item)
								end
							end
							if not l_open_slots.is_empty then
								across l_open_slots as l_slots loop
									l_matched_variables.force (l_slots.item.obj_id, l_slots.item.var_id)
								end
							end
								-- Then we move to the next level.
							l_cur_level := l_cur_level + 1
							if l_cur_level <= l_level_count then
									-- There is still new levels to match.
								l_cur_cursor := l_levels.i_th (l_cur_level).cursor
								l_searched_criterion := l_levels.i_th (l_cur_level).searched_criterion
							else
									-- We matched all variables, this means we found a solution.
								l_full_solution_found := True
							end
						else
								-- We found a conflict in the matching, need to move the cursor forward in the same level
								-- to see if there is some other fitting combination.
							l_cur_cursor.forth
						end
					end
				end
			end

				-- Check if we can match some variables that are NOT mentioned in any criterion.
			l_unmentioned_unmatched_variables := a_query_data.variables_unmentioned_in_searched_criteria.intersection (variable_match_status (l_matched_variables, False))
			if not l_unmentioned_unmatched_variables.is_empty then
				l_newly_matched_variables := variable_matches (l_unmentioned_unmatched_variables, a_query_data, a_document)
			end

				-- Fabricate final result.
			create l_result.make (a_query_data.query_config, a_document, l_full_solution_found and then l_is_last_match_complete, a_query_data)
			l_result.set_content (a_document.content)

				-- Setup matched criteria.
			if l_full_solution_found then
				l_solution_steps := l_steps
			else
				l_solution_steps := l_max_partial_steps
			end

				-- Setup matched variables.			
			create l_mvars.make (l_matched_variables.count)
			across l_matched_variables as l_vars loop l_mvars.extend (-1, l_vars.key) end
			if l_solution_steps /= Void then
				across l_solution_steps as l_sol_steps loop
					across l_sol_steps.item.matches as l_matches loop
						l_mvars.replace (l_matches.item.obj_id, l_matches.item.var_id)
					end
				end
			end

			if l_newly_matched_variables /= Void and then not l_newly_matched_variables.is_empty then
				l_mvars.merge (l_newly_matched_variables)
			end

			across l_mvars as l_matched_vars loop
				if l_matched_vars.item /= -1 then
					l_result.matched_variables.force (l_matched_vars.item, l_matched_vars.key)
				end
			end

			if l_solution_steps /= Void then
				across l_solution_steps as l_sol_steps loop
					l_result.matched_criteria.force_last (l_sol_steps.item.candidate_criterion, l_sol_steps.item.criterion)
				end
			end
			last_matches.extend (l_result)
		end

	variable_match_status (a_matches: HASH_TABLE [INTEGER, INTEGER]; a_matched: BOOLEAN): DS_HASH_SET [INTEGER]
			-- Set of indexes of variables (from the query side) that are matched if `a_matched' is True;
			-- otherwise, set of indexes of varibables (from the query side) that are NOT matched.
			-- `a_matches' is a table from variable indexes (key) to object indexes (value)
		do
			create Result.make (a_matches.count)

			if a_matched then
				across a_matches as l_matches loop
					if l_matches.item /= -1 then
						Result.force (l_matches.key)
					end
				end
			else
				across a_matches as l_matches loop
					if l_matches.item = -1 then
						Result.force (l_matches.key)
					end
				end
			end
		end

	variable_matches (a_unmatched_variables: DS_HASH_SET [INTEGER]; a_query_data: SEM_SEARCHED_QUERYABLE_DATA; a_document: SEM_CANDIDATE_QUERYABLE): HASH_TABLE [INTEGER, INTEGER]
			-- Set of variables that can be matched from `a_document' to `a_query_data'
			-- `a_unmatched_variables' is a set of variable indexes (from the query side) that needs to be matched.
			-- Result is a set of variable index (key) to object id (value) mappings.
		local
			l_objects: HASH_TABLE [TYPE_A, INTEGER]
			l_variables: HASH_TABLE [TYPE_A, INTEGER]
			l_unmatched: DS_HASH_SET [INTEGER]
			l_cursor: DS_HASH_SET_CURSOR [INTEGER]
			l_var_type: TYPE_A
			l_done: BOOLEAN
			l_context: CLASS_C
			l_obj_type: TYPE_A
		do
			create Result.make (5)
			create l_unmatched.make (5)
			l_unmatched.append (a_unmatched_variables)
			l_variables := a_query_data.variable_types
			l_objects := a_document.variable_types

				-- Try to match variables according to dynamic types (more constraining).
			from
				l_cursor := a_unmatched_variables.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
					-- Get dynamic type of the variable.
				l_var_type := l_variables.item (l_cursor.item)
				if l_var_type /= Void then
					l_done := False
					across l_objects as l_types until l_done loop
						l_obj_type := l_types.item
						if l_obj_type /= Void then
							if l_obj_type.is_none then
								if l_var_type.is_none then
									l_done := True
									Result.force (l_types.key, l_cursor.item)
									l_unmatched.remove (l_cursor.item)
								end
							else
								if l_obj_type.is_equivalent (l_var_type) then
									l_done := True
									Result.force (l_types.key, l_cursor.item)
									l_unmatched.remove (l_cursor.item)
								end
							end
						end
					end
				end
				l_cursor.forth
			end

				-- There are still some variables that are not matched,
				-- try to match them according to static types (less constraining).	
			if not l_unmatched.is_empty then
				l_context := workbench.system.root_type.associated_class
				from
					l_cursor := l_unmatched.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
						-- Get static type of the variable.
					l_var_type := l_variables.item (l_cursor.item)
					if l_var_type /= Void then
						l_done := False
						across l_objects as l_types until l_done loop
							l_obj_type := l_types.item
							if l_obj_type /= Void then
								if l_obj_type.is_none then
									if l_var_type.is_none then
										l_done := True
										Result.force (l_types.key, l_cursor.item)
										l_unmatched.remove (l_cursor.item)
									end
								else
									if l_obj_type.conform_to (l_context, l_var_type) then
										l_done := True
										Result.force (l_types.key, l_cursor.item)
										l_unmatched.remove (l_cursor.item)
									end
								end
							end
						end
					end
					if not l_cursor.after then
						l_cursor.forth
					end
				end
			end
		end

	is_fixed_variables_matched (
		a_searched_criterion: SEM_MATCHING_CRITERION;
		a_criterion: SEM_MATCHING_CRITERION;
		a_matched_variables: HASH_TABLE [INTEGER, INTEGER]): TUPLE [is_matched: BOOLEAN; open_operands: LINKED_LIST [TUPLE [var_id: INTEGER; obj_id: INTEGER]]]
			-- Is `a_criterion' matching the varaibles in `a_searched_criterion'?
			-- `a_searched_criterion' is a criterion given in the query. `a_criterion' is a matching criterion returned as the query results.
			-- This feature tries to see if objects inside `a_criterion' can match the variables specified in `a_searched_criterion'
			-- `a_matched_variables' is a table of already established variable-object mappings. Key is indexes of variables in the query,
			-- value is the indexes of objects in a result document, if the value is -1, that particular variable has not been matched to any object
			-- in the result document.
			-- Return value:
			-- `is_matched' indicates if `a_criterion' can be used to match `a_criterion_criterion' and also the matching conforms to all other
			-- variable-object bindings in `a_matched_variables'.
			-- `open_operands' has meanings only when `is_matched' is True. It is a list of variable-object bindings that `a_criterion' can
			-- contribute to the already established bindings in `a_matched_variables'. `var_id' is the index of a variable in the query side,
			-- `obj_id' is the index of an object in the result document side.
		local
			l_open_indexes: LINKED_LIST [TUPLE [var_id: INTEGER; obj_id: INTEGER]]
			l_operand_ids: ARRAYED_LIST [INTEGER]
			l_var_index: INTEGER
			l_is_matched: BOOLEAN
			l_done: BOOLEAN
			i: INTEGER
			l_var_id: INTEGER
			l_obj_id: INTEGER
			c: INTEGER
			l_var_type: TYPE_A
			l_obj_type: TYPE_A
			l_var_types: HASH_TABLE [TYPE_A, INTEGER]
			l_obj_types: HASH_TABLe [TYPE_A, INTEGER]
		do
			create l_open_indexes.make
			l_is_matched := True
			i := 1
			l_operand_ids := a_criterion.variables
			from
				i := 1
				c := l_operand_ids.count
			until
				i > c or not l_is_matched
			loop
				l_var_index := a_searched_criterion.variables.i_th (i)
				a_matched_variables.search (l_var_index)
				if a_matched_variables.found_item = -1 then
						-- The current variable is open.
					l_var_id := a_searched_criterion.variables.i_th (i)
					l_obj_id := a_criterion.variables.i_th (i)
					l_obj_types := a_criterion.variable_types
					l_obj_types.search (l_obj_id)
					if l_obj_types.found and then l_obj_types.found_item /= Void then
						l_obj_type := l_obj_types.found_item
						l_var_types := a_searched_criterion.variable_types
						l_var_types.search (l_var_id)
						if l_var_types.found and then l_var_types.found_item /= Void then
							l_var_type := l_var_types.found_item
							if l_obj_type.is_none then
								if l_var_type.is_none then
									l_open_indexes.extend ([l_var_id, l_obj_id])
								else
									l_is_matched := False
								end
							else
								if a_criterion.is_variable_type_conformant_to (l_obj_type, l_var_type) then
									l_open_indexes.extend ([l_var_id, l_obj_id])
								else
									l_is_matched := False
								end
							end
						else
							l_is_matched := False
						end
					else
						l_is_matched := False
					end
				else
						-- The current variable is fixed.
					if l_operand_ids.i_th (i) /= a_matched_variables.found_item then
						l_is_matched := False
					end
				end
				i := i + 1
			end
			Result := [l_is_matched, l_open_indexes]
		end

	variable_indexes_from_queryable (a_queryable: SEM_QUERYABLE): DS_HASH_SET [INTEGER]
			-- List of variable indexes from `a_queryable'
			-- In `a_queryable', each variable is associated with an index, this feature
			-- returns the set of indexes from all varaibles in `a_queryable'.
		do
			create Result.make (a_queryable.variables.count)
			across a_queryable.reversed_variable_position as l_positions loop
				Result.force_last (l_positions.key)
			end
		end

	matching_possibilities (a_searched_criteria: DS_HASH_SET [SEM_MATCHING_CRITERION]; a_candidates: SEM_CANDIDATE_QUERYABLE): SORTED_TWO_WAY_LIST [SEM_MATCHING]
			-- Matching possibilities from `a_searched_criteria' to `a_candidates'
			-- The result is sorted according to the number of possiblities for each searched criterion, the fewer the possibilities,
			-- the earlier a matching appears in the resulting list.
		local
			l_cursor: DS_HASH_SET_CURSOR [SEM_MATCHING_CRITERION]
			l_searched_criterion: SEM_MATCHING_CRITERION
			l_list: detachable LINKED_LIST [SEM_MATCHING_CRITERION]
			l_matching: SEM_MATCHING
		do
			create Result.make
			from
				l_cursor := a_searched_criteria.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_searched_criterion := l_cursor.item
				l_list := a_candidates.criteria_by_value (l_searched_criterion.criterion, l_searched_criterion.value)
				create l_matching.make (l_searched_criterion, l_list)
				Result.extend (l_matching)
				l_cursor.forth
			end
		end

end
