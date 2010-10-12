note
	description: "Class to match objects in returned search results"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_OBJECT_MATCHER

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
			l_searched_criteria: like searched_criterion_table
			l_searched_criterion_names: LINKED_LIST [STRING]
		do
				-- Construct candidate objects from query results.
			create l_candidates.make
			across a_query_result.documents as l_documents loop
				create l_candidate.make_from_document (l_documents.item)
			end

				-- Construct data from `a_query_config'.
			l_searched_criteria := searched_criterion_table (a_query_config)
			create l_searched_criterion_names.make
			across l_searched_criteria as l_cris loop
				l_searched_criterion_names.extend (l_cris.key)
			end

				-- Iterate through all candidate object document,
				-- perform variable matching for each document.
			across l_candidates as l_candidate_list loop
				match_document (a_query_config, l_searched_criteria, l_searched_criterion_names, l_candidate_list.item)
			end

		end

	match_document (a_query_config: SEM_QUERY_CONFIG; a_searched_criteria: like searched_criterion_table; a_searched_criterion_names: LINKED_LIST [STRING]; a_candidate: SEM_CANDIDATE_OBJECTS)
			-- Match `a_query_config' to `a_candidate', make result available in
			-- `is_last_match_complete', `last_matched_variables' and `last_matched_terms'.
		local
			l_matching_order: like matching_order
			l_matched_criterion_count: INTEGER	-- Number of matched criteria
			l_searched_criterion_count: INTEGER -- Number of searched criteria
			l_searched_criteria: ARRAYED_LIST [TUPLE [criterion: SEM_MATCHING_CRITERION; cursor: LINKED_LIST_ITERATION_CURSOR [SEM_MATCHING_CRITERION]]]
			l_cri_name: STRING
			l_candidates: LINKED_LIST [SEM_MATCHING_CRITERION]
			l_done: BOOLEAN
			l_current_cursor: LINKED_LIST_ITERATION_CURSOR [SEM_MATCHING_CRITERION]
		do
				-- Initialize.
			create last_matched_variables.make (10)
			create last_matched_terms.make
			is_last_match_complete := False

				-- Decide which searched criterion is to be matched first,
				-- according to how many candidates for each criterion, the
				-- fewer the candidates, the eariler the criterion.
			l_matching_order := matching_order (a_searched_criterion_names, a_candidate)
			last_unmatchable_terms := l_matching_order.unmatched_terms

				-- Get the list of all searched criteria, those are the terms to be matched.
			create l_searched_criteria.make (10)
			across l_matching_order.order as l_orders loop
				l_cri_name := l_orders.item
				l_candidates := a_candidate.criteria.item (l_cri_name)
				across a_searched_criteria.item (l_cri_name) as l_criteria loop
					l_searched_criteria.extend ([l_criteria.item, l_candidates.new_cursor])
					l_searched_criterion_count := l_searched_criterion_count + 1
				end
			end

				-- Use back-tracking to do the matching
			from
				l_matched_criterion_count := 0
				l_current_cursor := l_searched_criteria.i_th (l_matched_criterion_count + 1).cursor
			until
				l_done
			loop
				
			end

		end

feature{NONE} -- Implementation

	matching_order (a_searched_criteria: LINKED_LIST [STRING]; a_candidates: SEM_CANDIDATE_OBJECTS): TUPLE [order: LINKED_LIST [STRING]; unmatched_terms: LINKED_LIST [STRING]]
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
			Result := [l_order, l_unmatched]
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

	last_matched_terms: LINKED_LIST [SEM_TERM]
			-- Terms that are last matched

	last_unmatchable_terms: LINKED_LIST [STRING]

end
