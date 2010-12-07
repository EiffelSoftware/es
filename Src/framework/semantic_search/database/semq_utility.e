note
	description: "Utilities for SQL-implmentation of the semantic search system"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_UTILITY

inherit
	EPA_UTILITY

	EPA_SHARED_EQUALITY_TESTERS

	SEM_UTILITY

feature -- Basic operations

	add_default_searchable_properties (a_config: SEMQ_QUERYABLE_QUERY; a_term_veto_function: detachable FUNCTION [ANY, TUPLE [SEMQ_TERM], BOOLEAN]; a_term_occurrence_function: detachable FUNCTION [ANY, TUPLE [SEMQ_TERM], INTEGER])
			-- Add default searchable properties from `queryable' into `a_config'.`terms'.
			-- Searchable properties include:
			-- For transitions: variables, precondition, postcondition
			-- For objects: variables, properties.
			-- A candidate term is only added into `terms' if `a_term_veto_function' returns True on it.
			-- If `a_term_veto_function' is Void, all candidate terms are added.
			-- `a_term_occurrence_function' is a function to set the occurrence flag into the argument term.
			-- If `a_term_occurrence_function' is Void, the default occurrence flag of terms are not changed.
		local
			l_term_generator: SEMQ_TERM_GENERATOR
			l_terms: LINKED_LIST [SEMQ_TERM]
			l_type_term: SEMQ_META_TERM
		do
				-- Generate all terms from `queryable'.
			create l_term_generator
			l_term_generator.generate (a_config.queryable)

				-- Filter terms that do not satisfy `a_term_veto_function'.
			l_terms := a_config.terms
			across l_term_generator.last_terms as l_all_terms loop
				if a_term_veto_function = Void or else a_term_veto_function.item ([l_all_terms.item]) then
					l_all_terms.item.set_is_searched (True)
					l_terms.extend (l_all_terms.item)
				end
			end
			if a_config.queryable.is_transition then
				create l_type_term.make_with_string (document_type_field + " = " + transition_field_value, boolean_type, a_config.queryable)
			else
				create l_type_term.make_with_string (document_type_field + " = " + object_field_value, boolean_type, a_config.queryable)
			end
			l_terms.extend (l_type_term)
		end

	context_for_variables (a_variables: HASH_TABLE [TYPE_A, STRING]; a_context_class: CLASS_C): EPA_CONTEXT
			-- Context containing `a_variables'
			-- Key of `a_variables' is variable name, value is the type of that variable.
			-- `a_context_class' is the context where `a_variables' are evaluated.
		require
			variable_names_not_empty: across a_variables as l_vars all not l_vars.key.is_empty end
			types_are_explicit: across a_variables as l_vars all l_vars.item.is_explicit end
		do
			create Result.make_with_class (a_context_class, a_variables)
		end

	feature_call_transition_for_variables (a_variables: HASH_TABLE [TYPE_A, STRING]; a_context_class: CLASS_C): SEM_FEATURE_CALL_TRANSITION
			-- Feature call transtion for `a_variables'.
			-- Key of `a_variables' is variable name, value is the type of that variable.
		local
			l_context: EPA_CONTEXT
			l_variables: HASH_TABLE [STRING, INTEGER]
		do
			l_context := context_for_variables (a_variables, a_context_class)
			l_variables := variable_position_mapping_from_context (l_context)
			create Result.make_with_context_type (a_context_class, l_context.feature_, l_variables, l_context, False, a_context_class.actual_type)
		end

	objects_for_variables (a_variables: HASH_TABLE [TYPE_A, STRING]; a_context_class: CLASS_C): SEM_OBJECTS
			-- Semantic objects for `a_variables'.
			-- Key of `a_variables' is variable name, value is the type of that variable.
		local
			l_context: EPA_CONTEXT
			l_variables: DS_HASH_TABLE [INTEGER, EPA_EXPRESSION]
		do
			l_context := context_for_variables (a_variables, a_context_class)
			create l_variables.make (10)
			l_variables.set_key_equality_tester (expression_equality_tester)
			across variable_position_mapping_from_context (l_context) as l_positions loop
				l_variables.force_last (l_positions.key, variable_expression_from_context (l_positions.item, l_context))
			end
			create Result.make (l_context, l_variables)
		end

end
