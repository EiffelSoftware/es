note
	description: "Class to extract snippet from code"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_SNIPPET_EXTRACTOR

inherit
	AST_ITERATOR

	EPA_UTILITY

	EPA_SHARED_EQUALITY_TESTERS

feature -- Access

	last_snippets: LINKED_LIST [EXT_SNIPPET]
			-- Snippets that are extracted by last `extract'

feature -- Basic operations

	extract (a_type: TYPE_A; a_feature: FEATURE_I; a_context_class: CLASS_C)
			-- Extract snippet for relevant target of type `a_type' from
			-- `a_feature' viewed in `a_context_class'.
			-- Make results available in `last_snippets'.
		local
			l_do_as: DO_AS
		do
			relevant_target_type := a_type
			feature_ := a_feature
			context_class := a_context_class

			create last_snippets.make

				-- Collect relevant variables from `a_feature'.
			collect_relevant_variables

				-- Process the feature body to extract snippets for each relevant variable.
			l_do_as := body_ast_from_feature (a_feature)
			if l_do_as /= Void then
				relevant_variables.do_all_with_key (agent process_feature_with_relevant_variable (l_do_as, ?, ?))
			end
		end

feature{NONE} -- Implementation

	relevant_target_type: TYPE_A
			-- Type of variable whose snippets are to be extracted

	feature_: FEATURE_I
			-- Feature from which snippets are to be extracted

	context_class: CLASS_C
			-- Class where `feature_' is viewed

	relevant_variables: DS_HASH_TABLE [TYPE_A, STRING]
			-- Table of relevant varaibles
			-- Keys are variable names, values are their types.
			-- Relevant variables are of either of the following kinds: Current, feature argument, local varaible, Result.
			-- Relevant varaibles must have types that conform to `relevant_target_type'. (See
			-- the first argument of `extract').

	collect_relevant_variables
			-- Collect relevant variables with respect to `relevant_target_type' from
			-- `feature_' and put results into `relevant_variables'.
		local
			operands: like operand_name_types_with_feature
			locals: like locals_from_feature_as
			l_candidates: HASH_TABLE [TYPE_A, STRING]
		do
			create relevant_variables.make (10)
			relevant_variables.set_key_equality_tester (string_equality_tester)
			relevant_variables.set_equality_tester (type_name_equality_tester)

				-- Collect all candidate variables.
			create l_candidates.make (10)
			l_candidates.compare_objects
			operand_name_types_with_feature (feature_, context_class).do_all_with_key (agent l_candidates.force)
			across locals_from_feature_as (feature_.e_feature.ast, context_class) as l_locals loop
				l_candidates.force (l_locals.item, l_locals.key)
			end

				-- Check type conformance against `relevant_target_type'.
			across l_candidates as l_variables loop
				if l_variables.item.conform_to (context_class, relevant_target_type) then
					relevant_variables.force_last (l_variables.item, l_variables.key)
				end
			end
		end

	process_feature_with_relevant_variable (a_do_as: DO_AS; a_variable_type: TYPE_A; a_variable_name: STRING)
			-- Process `a_do_as' to extract snippets for relevant variable named `a_variable_name'.
			-- The type of the relevant variable is given by `a_variable_type'.
		do
			to_implement ("To implement.")
		end

end
