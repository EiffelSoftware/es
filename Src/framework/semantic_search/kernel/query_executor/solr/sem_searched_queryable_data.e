note
	description: "Class that hold data describing a search queryable, used for result matching"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_SEARCHED_QUERYABLE_DATA

inherit
	SEM_SHARED_EQUALITY_TESTER

create
	make

feature{NONE} -- Initialization

	make (a_query_config: like query_config)
			-- Initialize Current with `a_query_config'.
		do
			query_config := a_query_config
			searched_criteria := searched_criteria_internal (searched_criterion_table (a_query_config))
			variables_mentioned_in_searched_criteria := variables_mentioned_in_criteria (searched_criteria)
			variable_indexes := query_config.variable_indexes
			variables_unmentioned_in_searched_criteria := variable_indexes.subtraction (variables_mentioned_in_searched_criteria)
		end

feature -- Access

	query_config: SEM_QUERY_CONFIG
			-- Config of the query

	queryable: SEM_QUERYABLE
			-- Queryable of the query
		do
			Result := query_config.queryable
		end

	variable_types: HASH_TABLE [TYPE_A, INTEGER]
			-- Table from variable indexes (key) to variable types (value)
		do
			Result := queryable.variable_types
		end

	searched_criteria: DS_HASH_SET [SEM_MATCHING_CRITERION]
			-- Set of searched criteria

	variables_mentioned_in_searched_criteria: DS_HASH_SET [INTEGER]
			-- Indexes of variables in the query that are mentioned in any of the
			-- criterion in `searched_criteria'

	variables_unmentioned_in_searched_criteria: DS_HASH_SET [INTEGER]
			-- Indexes of variables in the query that are NOT mentioned in any of the
			-- criterion in `searched_criteria'

	variable_indexes: DS_HASH_SET [INTEGER]
			-- Set of indexes of variables in the query

feature -- Status report

	has_unmentioned_variable_searched_criteria: BOOLEAN
			-- Is there any varaible unmentioned in `searched_criteria'?
		do
			Result := not variables_unmentioned_in_searched_criteria.is_empty
		end

feature{NONE} -- Implementation

	searched_criteria_internal (a_table: like searched_criterion_table): DS_HASH_SET [SEM_MATCHING_CRITERION]
			-- Set of searched criteria in `a_table'
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
					if attached {SEM_EXPR_VALUE_TERM} l_term as l_expr_value_term and then l_expr_value_term.should_be_considered_in_result then
						l_expr := l_expr_value_term.expression
						l_value := l_expr_value_term.value
						if l_value.is_integer then
							create {IR_INTEGER_VALUE} l_term_value.make (l_value.text.to_integer)
						elseif l_value.is_boolean then
							create {IR_BOOLEAN_VALUE} l_term_value.make (l_value.text.to_boolean)
						elseif attached {EPA_NUMERIC_RANGE_VALUE} l_value as l_range then
							create {IR_INTEGER_RANGE_VALUE} l_term_value.make (l_range.item.lower, l_range.item.upper)
						elseif attached {EPA_INTEGER_EXCLUSION_VALUE} l_value as l_int_ex then
							create {IR_INTEGER_VALUE} l_term_value.make (l_int_ex.item)
						end
						l_name := l_expr_value_term.field_content_in_type_form (l_type_form)
						create l_criterion.make (l_name, l_term_value, l_expr_value_term.operands, a_query_config.queryable.variable_types)
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

	variables_mentioned_in_criteria (a_criteria: DS_HASH_SET [SEM_MATCHING_CRITERION]): DS_HASH_SET [INTEGER]
			-- Indexes of variables mentioned in `a_criteria'
		local
			l_cursor: DS_HASH_SET_CURSOR [SEM_MATCHING_CRITERION]
		do
			create Result.make (10)
			from
				l_cursor := a_criteria.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				across l_cursor.item.variables as l_vars loop
					Result.force_last (l_vars.item)
				end
				l_cursor.forth
			end
		end

end
