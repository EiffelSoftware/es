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

feature -- Access

	last_snippets: LINKED_LIST [EXT_SNIPPET]
			-- Snippets that are extracted by last `extract'

feature -- Basic operations

	extract (a_type: TYPE_A; a_feature: FEATURE_I; a_context_class: CLASS_C)
			-- Extract snippet for relevant target of type `a_type' from
			-- `a_feature' viewed in `a_context_class'.
			-- Make results available in `last_snippets'.
		do
			relevant_target_type := a_type
			feature_ := a_feature
			context_class := a_context_class

			create last_snippets.make

				-- Collect relevant variables from `a_feature'.
			collect_relevant_variables

				-- Process the feature body to extract snippets.			
			if attached {DO_AS} body_ast_from_feature (a_feature) as l_body then
				l_body.process (Current)
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
		do
			to_implement ("To implement.")
		end

end
