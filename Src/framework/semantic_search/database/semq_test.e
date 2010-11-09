note
	description: "Class to test the functionality of SQL-based semantic search system"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_TEST

inherit
	SEMQ_UTILITY

	SHARED_NAMES_HEAP

	ETR_SHARED_TOOLS

	EPA_CONTRACT_EXTRACTOR

	SHARED_TYPES

feature -- Tests

	test_basic_query (a_class_name: STRING; a_feature_name: STRING)
			-- Test queries to retrieve transitions.
		local
			l_transition: SEM_FEATURE_CALL_TRANSITION
			l_vars: HASH_TABLE [TYPE_A, STRING]
			l_query: SEMQ_QUERYABLE_QUERY
			l_position: SEM_TRANSITION_VARIABLE_POSITION
			l_query_executor: SEMQ_QUERY_EXECUTOR
		do
			io.put_string ("---------------------------------%N")

				-- Setup transition queryable.
			l_transition ?= queryable_from_class_and_feature_name (a_class_name, a_feature_name)

				-- Require that the variable named "l" must be the target of retrieved transitions.
			create l_position.make_as_target
			l_transition.interface_variable_positions.force_last (l_position, l_transition.variable_by_name ("l"))

				-- Build the query.
			create l_query.make (l_transition)
			add_default_searchable_properties (l_query, Void, Void)

				-- Print out query content.
			io.put_string (l_query.text)
			io.put_string ("%N")

				-- Execute the query.
			create l_query_executor
			l_query_executor.execute (l_query)

				-- Print out query results.
			io.put_string ("Result:%N")
			io.put_string (l_query_executor.last_results.count.out + "%N")
		end

feature{NONE} -- Implementation

	queryable_from_class_and_feature_name (a_class_name: STRING; a_feature_name: STRING): SEM_QUERYABLE
			-- Queryables from `a_class_name' and `a_feature_name'.
		local
			l_transition: SEM_FEATURE_CALL_TRANSITION
			l_objects: SEM_OBJECTS
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_vars: HASH_TABLE [TYPE_A, STRING]
		do
				-- Setup transition queryable.
			l_class := first_class_starts_with_name (a_class_name)
			l_feature := l_class.feature_named (a_feature_name)
			l_vars := variables_from_given_feature (l_class, l_feature)

			if postcondition_of_feature (l_feature, l_class).is_empty then
				l_objects := objects_for_variables (l_vars, l_class)
				l_objects.set_properties (state_from_expressions (precondition_of_feature (l_feature, l_class), l_objects.context))
				Result := l_objects
			else
				l_transition := feature_call_transition_for_variables (l_vars, l_class)
				l_transition.set_preconditions (state_from_expressions (precondition_of_feature (l_feature, l_class), l_transition.context))
				l_transition.set_postconditions (state_from_expressions (postcondition_of_feature (l_feature, l_class), l_transition.context))
				Result := l_transition
			end
		end

	state_from_expressions (a_expressions: LIST [EPA_EXPRESSION]; a_context: EPA_CONTEXT): EPA_STATE
			-- State containing expressions in `a_expressions' in `a_context'
		local
			l_equation: EPA_EQUATION
			l_value: EPA_BOOLEAN_VALUE
			l_expr: EPA_AST_EXPRESSION
			l_class: CLASS_C
			l_feature: FEATURE_I
		do
			l_class := a_context.class_
			l_feature := a_context.feature_
			create l_value.make (True)
			create Result.make (a_expressions.count, l_class, l_feature)
			across a_expressions as l_exprs loop
				create l_expr.make_with_text (l_class, l_feature, l_exprs.item.text, l_class)
				create l_equation.make (l_expr, l_value)
				Result.force_last (l_equation)
			end
		end

	variables_from_given_feature (a_class: CLASS_C; a_feature: FEATURE_I): HASH_TABLE [TYPE_A, STRING]
			-- Variables from the arguments in `a_feature' of `a_class'
		local
			l_transition: SEM_FEATURE_CALL_TRANSITION
			l_variables: like arguments_from_feature
		do
			l_variables := arguments_from_feature (a_feature, a_class)
			create Result.make (10)
			Result.compare_objects
			from
				l_variables.start
			until
				l_variables.after
			loop
				Result.force (l_variables.item_for_iteration, l_variables.key_for_iteration)
				l_variables.forth
			end
		end

end
