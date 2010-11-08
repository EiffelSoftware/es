note
	description: "Utilities for SQL-implmentation of the semantic search system"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_UTILITY

feature -- Basic operations

	add_default_searchable_properties (a_config: SEMQ_QUERYABLE_QUERY [SEM_QUERYABLE]; a_term_veto_function: detachable FUNCTION [ANY, TUPLE [SEMQ_TERM], BOOLEAN]; a_term_occurrence_function: detachable FUNCTION [ANY, TUPLE [SEMQ_TERM], INTEGER])
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
		do
				-- Generate all terms from `queryable'.
			create l_term_generator
			l_term_generator.generate (a_config.queryable)

				-- Filter terms that do not satisfy `a_term_veto_function'.
			l_terms := a_config.terms
			across l_term_generator.last_terms as l_all_terms loop
				if a_term_veto_function = Void or else a_term_veto_function.item ([l_all_terms.item]) then
					if a_term_occurrence_function /= Void then
						l_all_terms.item.set_occurrence (a_term_occurrence_function.item ([l_all_terms.item]))
					end
					l_terms.extend (l_all_terms.item)
				end
			end
		end

end
