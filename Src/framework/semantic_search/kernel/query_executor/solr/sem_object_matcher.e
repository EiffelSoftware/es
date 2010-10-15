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
				if l_candidate.is_valid then
					l_candidates.extend (l_candidate)
				end
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
			io.put_string (l_time2.out + "%N")
		end

	match_document (a_query_config: SEM_QUERY_CONFIG; a_searched_criteria: like searched_criteria; a_document: SEM_CANDIDATE_QUERYABLE)
			-- Match `a_document' to the query specified through `a_searched_criterion'.
			-- The original query is accessable through `a_query_config'.
			-- Make result available in `is_last_match_complete', `last_matched_variables', `last_reversed_matched_variables' and
			-- `last_unmatchable_terms'.
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
			l_solution_found: BOOLEAN -- Is a solution found.
			l_matched_variables: HASH_TABLE [INTEGER, INTEGER]
				-- Already established variable-object bindings, key is index of variables from the query side,
				-- value is the index of the matched object from the `a_document', -1 means that particular variable (from the query side) is not matched.
			l_var_fixture: like is_fixed_variables_matched  -- Data describing how a particular criterion can be matched.
			l_searched_criterion: SEM_MATCHING_CRITERION    -- Current searched criterion under consideration.
			l_cur_criterion: SEM_MATCHING_CRITERION         -- Current candidate criterion which may be matched to `l_searched_criterion'
			l_open_slots: LINKED_LIST [TUPLE [var_id: INTEGER; obj_id: INTEGER]]
				-- `l_open_slots' is a list of variable-object bindings that `a_criterion' can
				-- contribute to the already established bindings in `a_matched_variables'. `var_id' is the index of a variable in the query side,			
			l_steps: LINKED_LIST [LINKED_LIST [TUPLE [var_id: INTEGER; obj_id: INTEGER]]]
				-- All variable-object mapping steps that are performed so far, used for back-tracking.
				-- `var_id' is the index of a variable in the query side, `obj_id' is the index of an object in the result document side.
			l_exhausted: BOOLEAN -- Have we already exhausted all matching possibilities?					
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
			create l_matched_variables.make (a_query_config.variable_count)
			variable_indexes_from_queryable (a_query_config.queryable).do_all (agent l_matched_variables.force (-1, ?))

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
			-- In `a_queryable', each variable is associated with an index, this feature
			-- returns the set of indexes from all varaibles in `a_queryable'.
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
			-- Complete match means that all varaibles and all searched terms (criteria) were matched.

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
