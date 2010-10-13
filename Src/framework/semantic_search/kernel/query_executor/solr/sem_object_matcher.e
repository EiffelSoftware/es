note
	description: "Class to match objects in returned search results"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_OBJECT_MATCHER

inherit
	SEM_SHARED_EQUALITY_TESTER

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

	last_matches: LINKED_LIST [SEM_OBJECTS]
			-- Last matched objects

feature -- Basic operations

	match (a_query_config: SEM_QUERY_CONFIG; a_query_result: IR_QUERY_RESULT)
			-- Match objects from `a_query_result' to `a_query_config',
			-- make result available in `last_matches'.
		local
			l_candidates: LINKED_LIST [SEM_CANDIDATE_OBJECTS]
			l_candidate: SEM_CANDIDATE_OBJECTS
			l_searched_criteria: like searched_criteria
			l_time1: DATE_TIME
			l_time2: DATE_TIME
		do
				-- Construct candidate objects from query results.
			create l_candidates.make
			across a_query_result.documents as l_documents loop
				create l_candidate.make_from_document (l_documents.item)
				l_candidates.extend (l_candidate)
			end

				-- Construct data from `a_query_config'.
			l_searched_criteria := searched_criteria (searched_criterion_table (a_query_config))

				-- Iterate through all candidate object document,
				-- perform variable matching for each document.
			create l_time1.make_now
			across l_candidates as l_candidate_list loop
				match_document (a_query_config, l_searched_criteria, l_candidate_list.item)
			end
			create l_time2.make_now
			io.put_string (l_time1.out + "%N")
			io.put_string (l_time2
			.out + "%N")
		end

--	match_document (a_query_config: SEM_QUERY_CONFIG; a_searched_criteria: like searched_criterion_table; a_searched_criterion_names: LINKED_LIST [STRING]; a_candidate: SEM_CANDIDATE_OBJECTS)
--			-- Match `a_query_config' to `a_candidate', make result available in
--			-- `is_last_match_complete', `last_matched_variables' and `last_matched_terms'.
--		local
--			l_matching_order: like matching_order
--			l_matched_criterion_count: INTEGER	-- Number of matched criteria
--			l_searched_criterion_count: INTEGER -- Number of searched criteria
--			l_searched_criteria: ARRAYED_LIST [TUPLE [criterion: SEM_MATCHING_CRITERION; cursor: LINKED_LIST_ITERATION_CURSOR [SEM_MATCHING_CRITERION]]]
--			l_cri_name: STRING
--			l_candidates: LINKED_LIST [SEM_MATCHING_CRITERION]
--			l_done: BOOLEAN
--			l_current_cursor: LINKED_LIST_ITERATION_CURSOR [SEM_MATCHING_CRITERION]
--		do
--				-- Initialize.
--			create last_matched_variables.make (10)
--			create last_reversed_matched_variables.make (10)
--			create last_matched_terms.make
--			is_last_match_complete := False

--				-- Decide which searched criterion is to be matched first,
--				-- according to how many candidates for each criterion, the
--				-- fewer the candidates, the eariler the criterion.
----			l_matching_order := matching_order (a_searched_criteria, a_searched_criterion_names, a_candidate)
--			last_unmatchable_terms := l_matching_order.unmatched_terms

--				-- Get the list of all searched criteria, those are the terms to be matched.
--			create l_searched_criteria.make (10)
--			across l_matching_order.order as l_orders loop
--				l_cri_name := l_orders.item
--				l_candidates := a_candidate.criteria.item (l_cri_name)
--				across a_searched_criteria.item (l_cri_name) as l_criteria loop
--					l_searched_criteria.extend ([l_criteria.item, l_candidates.new_cursor])
--					l_searched_criterion_count := l_searched_criterion_count + 1
--				end
--			end

--				-- Use back-tracking to do object matching.
--			from
--				l_matched_criterion_count := 0
--				l_current_cursor := l_searched_criteria.i_th (l_matched_criterion_count + 1).cursor
--			until
--				l_done
--			loop

--			end

--		end

	match_document (a_query_config: SEM_QUERY_CONFIG; a_searched_criteria: like searched_criteria; a_document: SEM_CANDIDATE_QUERYABLE)
			-- Match one document.
		local
			l_matching: like matching_possibilities
			l_levels: ARRAYED_LIST [TUPLE [searched_criterion: SEM_MATCHING_CRITERION; cursor: LINKED_LIST_ITERATION_CURSOR [SEM_MATCHING_CRITERION]]]
			l_match: SEM_MATCHING
			l_cur_cursor: LINKED_LIST_ITERATION_CURSOR [SEM_MATCHING_CRITERION]
			l_cur_level: INTEGER
			l_level_count: INTEGER
			l_solution_found: BOOLEAN
			l_variable_indexes: DS_HASH_SET [INTEGER]    -- Indexes of variables to be matched.
			l_matched_variables: HASH_TABLE [INTEGER, INTEGER] -- Matches of variables, key is variable index, value is the matched object id, -1 means not matched.
			l_var_fixture: like is_fixed_variables_matched
			l_cur_criterion: SEM_MATCHING_CRITERION
			l_open_slots: LINKED_LIST [TUPLE [var_id: INTEGER; obj_id: INTEGER]]
			l_searched_criterion: SEM_MATCHING_CRITERION
			l_steps: LINKED_LIST [LINKED_LIST [TUPLE [var_id: INTEGER; obj_id: INTEGER]]]
			l_exhausted: BOOLEAN
		do
			l_matching := matching_possibilities (a_searched_criteria, a_document)

				-- Build up all levels that can be back-tracked.
			is_last_match_complete := True
			create l_levels.make (l_matching.count)
			across l_matching as l_matchings loop
				l_match := l_matchings.item
				if l_match.has_candidate then
					l_cur_cursor := l_match.candidate_criteria.new_cursor
					l_cur_cursor.start
					l_levels.extend ([l_match.searched_criterion, l_cur_cursor])
				else
					if is_last_match_complete then
						is_last_match_complete := False
					end
				end
			end

				-- Initialize matched variable indexes.
			l_variable_indexes := variable_indexes_from_queryable (a_query_config.queryable)
			create l_matched_variables.make (l_variable_indexes.count)
			l_variable_indexes.do_all (agent l_matched_variables.force (-1, ?))

				-- Use back-track to do object matching.
			create l_steps.make
			l_cur_level := 0
			l_level_count := l_levels.count
			from
				l_cur_level := 1
				l_cur_cursor := l_levels.i_th (l_cur_level).cursor
				l_searched_criterion := l_levels.i_th (l_cur_level).searched_criterion
				l_exhausted := l_cur_cursor.after
			until
				l_solution_found or l_exhausted
			loop
				if l_cur_cursor.after then
						-- We exhausted current level, need to back-track.										
						-- First, undo all matches in the last step.
					across l_steps.last as l_slots loop
						l_matched_variables.force (-1, l_slots.item.var_id)
					end
						-- Second, move current cursor to the first position.
					l_cur_cursor.start

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
						l_steps.extend (l_open_slots)
						if not l_open_slots.is_empty then
							across l_open_slots as l_slots loop
								l_matched_variables.force (l_slots.item.obj_id, l_slots.item.var_id)
							end
						end
							-- Then we move to the nexte level.
						l_cur_level := l_cur_level + 1
						if l_cur_level <= l_level_count then
								-- There is still new levels to match.
							l_cur_cursor := l_levels.i_th (l_cur_level).cursor
							l_searched_criterion := l_levels.i_th (l_cur_level).searched_criterion
						else
								-- We matched all variables, this means we found a solution.
							l_solution_found := True
						end
					else
							-- We found a conflict in the matching, need to move the cursor forward in the same level
							-- to see if there is some other fitting combination.
						l_cur_cursor.forth
					end
				end
			end

			if l_solution_found then
				io.put_string ("Found solution:%N")
				across l_matched_variables as l_matched loop
					io.put_string ("%Tvar_" + l_matched.key.out + " == " + l_matched.item.out)
					io.put_string ("%N")
				end
			else
				io.put_string ("There is no solution:%N")
			end
		end

	is_fixed_variables_matched (a_searched_criterion: SEM_MATCHING_CRITERION; a_criterion: SEM_MATCHING_CRITERION; a_matched_variables: HASH_TABLE [INTEGER, INTEGER]): TUPLE [is_matched: BOOLEAN; open_operands: LINKED_LIST [TUPLE [var_id: INTEGER; obj_id: INTEGER]]]
			-- Do operands `a_operand_ids' match the fixed variables in `a_matched_variables'?
			-- `is_matched' indicates if current candidate violates the already fixed variables.
			-- `open_operands' is the list of open operand ids for the criterion.
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
		do
			create l_open_indexes.make
			l_is_matched := True
			i := 1
			l_operand_ids := a_criterion.operands
			from
				i := 1
				c := l_operand_ids.count
			until
				i > c or not l_is_matched
			loop
				l_var_index := a_searched_criterion.operands.i_th (i)
				a_matched_variables.search (l_var_index)
				if a_matched_variables.found_item = -1 then
						-- The current variable is open.
					l_var_id := a_searched_criterion.operands.i_th (i)
					l_obj_id := a_criterion.operands.i_th (i)
					l_open_indexes.extend ([l_var_id, l_obj_id])
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
		do
			create Result.make (a_queryable.variables.count)
			across a_queryable.reversed_variable_position as l_positions loop
				Result.force_last (l_positions.key)
			end
		end

feature{NONE} -- Implementation

	matching_possibilities (a_searched_criteria: like searched_criteria; a_candidates: SEM_CANDIDATE_QUERYABLE): SORTED_TWO_WAY_LIST [SEM_MATCHING]
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

	matching_order (a_searched_criteria: LINKED_LIST [STRING]; a_candidates: SEM_CANDIDATE_OBJECTS): TUPLE [order: LINKED_LIST [STRING]; combinations: HASH_TABLE [LINKED_LIST [SEM_MATCHING_CRITERION], STRING]; unmatched_terms: LINKED_LIST [STRING]]
			-- The order of matching for searched criteria
		local
			l_done: BOOLEAN
			l_criterion: STRING
			l_candidate_criteria: HASH_TABLE [LINKED_LIST [SEM_MATCHING_CRITERION], STRING]
			l_unmatched: LINKED_LIST [STRING]
			l_candidate_count: INTEGER
			l_found: HASH_TABLE [INTEGER, STRING]
			l_order: LINKED_LIST [STRING]
		do
			create l_unmatched.make
			create l_found.make (10)
			l_found.compare_objects

			create l_order.make
			l_candidate_criteria := a_candidates.criteria
			across a_searched_criteria as l_criteria loop
				l_criterion := l_criteria.item
				l_candidate_criteria.search (l_criterion)
				if l_candidate_criteria.found then
					l_candidate_count := l_candidate_criteria.found_item.count
					l_done := False
					from
						l_order.start
					until
						l_order.after or l_done
					loop
						if l_candidate_count > l_found.item (l_order.item) then
							l_done := True
						end
						l_order.forth
					end
					if l_order.after then
						l_order.extend (l_criterion)
					else
						l_order.put_left (l_criterion)
					end
					l_found.force (l_candidate_count, l_criterion)
				else
					l_unmatched.extend (l_criterion)
				end
			end
--			Result := [l_order, l_unmatched]
		end

	searched_criteria (a_table: like searched_criterion_table): DS_HASH_SET [SEM_MATCHING_CRITERION]
			-- Set of matching criteria in `a_table'
		do
			create Result.make (20)
			Result.set_equality_tester (sem_matching_criterion_equality_tester)
			across a_table as l_table loop
				across l_table.item as l_criteria loop
					Result.force_last (l_criteria.item)
				end
			end
		end

	searched_criterion_table (a_query_config: SEM_QUERY_CONFIG): HASH_TABLE [LINKED_LIST [SEM_MATCHING_CRITERION], STRING]
			-- Table of searched criteria from `a_query_config'
			-- Key is criterion content, value is criterion information
		local
			l_term: SEM_TERM
			l_criterion: SEM_MATCHING_CRITERION
			l_expr: EPA_EXPRESSION
			l_value: EPA_EXPRESSION_VALUE
			l_term_value: IR_VALUE
			l_type_form: INTEGER
			l_list: LINKED_LIST [SEM_MATCHING_CRITERION]
			l_name: STRING
		do
			create Result.make (10)
			Result.compare_objects

			l_type_form := a_query_config.primary_property_type_form
			across a_query_config.terms as l_terms loop
				l_term := l_terms.item
				if l_term.is_change or l_term.is_contract or l_term.is_property then
					if attached {SEM_EXPR_VALUE_TERM} l_term as l_expr_value_term then
						l_expr := l_expr_value_term.expression
						l_value := l_expr_value_term.value
						if l_value.is_integer then
							create {IR_INTEGER_VALUE} l_term_value.make (l_value.text.to_integer)
						elseif l_value.is_boolean then
							create {IR_BOOLEAN_VALUE} l_term_value.make (l_value.text.to_boolean)
						elseif attached {EPA_NUMERIC_RANGE_VALUE} l_value as l_range then
							create {IR_INTEGER_RANGE_VALUE} l_term_value.make (l_range.item.lower, l_range.item.upper)
						end
						l_name := l_expr_value_term.field_content_in_type_form (l_type_form)
						create l_criterion.make (l_name, l_expr_value_term.operands, l_term_value)
						l_criterion.set_term (l_term)
						Result.search (l_name)
						if Result.found then
							l_list := Result.found_item
						else
							create l_list.make
							Result.put (l_list, l_name)
						end
						l_list.extend (l_criterion)
					end
				end
			end
		end

feature{NONE} -- Implementation

	is_last_match_complete: BOOLEAN
			-- Is last match complete?
			-- Complete match means that all varaibles and all searched terms were matched.

	last_matched_variables: HASH_TABLE [INTEGER, INTEGER]
			-- Table of last matched variables
			-- Key is object indexes in the original query.
			-- Value is the matched object index in a document.

	last_reversed_matched_variables: HASH_TABLE [INTEGER, INTEGER]
			-- Table of last matched variables
			-- Key is the matched object index in a document.
			-- Value is object indexes in the original query.
			-- This is the reversed table as `last_matched_variables'

	last_matched_terms: LINKED_LIST [SEM_TERM]
			-- Terms that are last matched

	last_unmatchable_terms: LINKED_LIST [STRING]

end
