note
	description: "Finders to collect argumentless queries in a class"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_ARGUMENTLESS_EXPRESSION_FINDER

inherit
	EPA_EXPRESSION_FINDER

	EPA_ARGUMENTLESS_PRIMITIVE_FEATURE_FINDER
		export{NONE} all end

create
	make,
	make_with_boolean_queries,
	make_with_queries

feature{NONE} -- Initialization

	make (a_context_class: CLASS_C; a_criterion: like criterion)
			-- Initialize Current.
		do
			context_class := a_context_class
			criterion := a_criterion
		end

	make_with_boolean_queries (a_context_class: CLASS_C; a_include_non_exported: BOOLEAN)
			-- Initialze current to select argumentless boolean queries from `a_context_class'.
			-- Include non exported ABQs if `a_include_non_exported' is True.
		local
			l_agents: ARRAY [FUNCTION [ANY, TUPLE [FEATURE_I], BOOLEAN]]
		do
			context_class := a_context_class

				-- Setup selection agents.
			l_agents := <<
				agent is_argumentless_query,
				agent is_boolean_query,
				agent is_non_any_feature
				>>


			if not a_include_non_exported then
				l_agents.grow (1)
				l_agents.put (agent is_exported_to_any, l_agents.count)
			end
			criterion := anded_agents (l_agents)
		end

	make_with_queries (a_context_class: like context_class; a_include_primitive: BOOLEAN; a_include_reference: BOOLEAN; a_include_non_exported: BOOLEAN)
			-- Initialze current to select argumentless queries from `a_context_class'.
			-- Include queries of primitive types if `a_include_primitive' is True.
			-- Include queries of reference types if `a_include_reference' is True.
			-- Include non-exported queries if `a_include_non_exported' is True.
		local
			l_agents: ARRAY [FUNCTION [ANY, TUPLE [FEATURE_I], BOOLEAN]]
			l_ored_agents: ARRAY [FUNCTION [ANY, TUPLE [FEATURE_I], BOOLEAN]]
		do
			l_agents := <<
				agent is_argumentless_query,
				agent is_non_any_feature
			>>
			if not a_include_non_exported then
				l_agents.grow (1)
				l_agents.put (agent is_exported_to_any, l_agents.count)
			end

			l_ored_agents := <<>>
			if a_include_primitive then
				l_ored_agents.grow (1)
				l_ored_agents.put (agent is_primitive_query, l_agents.count)
			end

			if a_include_reference then
				l_ored_agents.grow (1)
				l_ored_agents.put (agent is_reference_query, l_agents.count)
			end

			if not l_ored_agents.is_empty then
				l_agents.grow (1)
				l_agents.put (ored_agents (l_ored_agents), l_agents.count)
			end
			criterion := anded_agents (l_agents)
			context_class := a_context_class
		end


feature -- Access

	context_class: CLASS_C
			-- Class from which expressions are searched

	criterion: detachable FUNCTION [ANY, TUPLE [FEATURE_I], BOOLEAN]
			-- Criterion to decide which expression gets picked

feature --  Basic operations

	search (a_expression_repository: EPA_HASH_SET [EPA_EXPRESSION])
			-- <Precursor>
			-- Find queries from `context_class' which satisfy `criterion'
		local
			l_features: LINKED_LIST [FEATURE_I]
			l_expr: EPA_AST_EXPRESSION
			l_feat: FEATURE_I
			l_context_class: like context_class
			l_last_found_expressions: like last_found_expressions
		do
			last_found_expressions := new_expression_set
			l_last_found_expressions := last_found_expressions

			from
				l_context_class := context_class
				l_features := features_in_class (context_class, criterion)
				l_features.start
			until
				l_features.after
			loop
				l_feat := l_features.item_for_iteration
				create l_expr.make_with_text (context_class, Void, l_feat.feature_name.as_lower, l_context_class)
				if not a_expression_repository.has (l_expr) then
					l_last_found_expressions.force_last (l_expr)
				end
				l_features.forth
			end
		end

end
