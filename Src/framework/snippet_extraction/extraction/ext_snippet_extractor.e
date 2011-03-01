note
	description: "Class to extract snippet from code"
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_SNIPPET_EXTRACTOR

inherit
	AST_ITERATOR

	EGX_UTILITY

	EPA_SHARED_EQUALITY_TESTERS

	EPA_TYPE_UTILITY

	EPA_UTILITY

feature -- Access

	last_snippets: LINKED_LIST [EXT_SNIPPET]
			-- Snippets that are extracted by last `extract'

feature -- Basic operations

	extract (a_type: TYPE_A; a_feature: FEATURE_I; a_context_class: CLASS_C)
			-- Extract snippet for relevant target of type `a_type' from
			-- `a_feature' viewed in `a_context_class'.
			-- Make results available in `last_snippets'.
		local
			l_compound_as: EIFFEL_LIST [INSTRUCTION_AS]
			l_path_initializer: ETR_AST_PATH_INITIALIZER
			l_cfg_builder: EPA_CFG_BUILDER
		do
			relevant_target_type := a_type
			feature_ := a_feature
			context_class := a_context_class

			create last_snippets.make

				-- Collect relevant variables from `a_feature'.
			collect_relevant_variables

				-- Debug output collected variables.
				-- TODO: to_be_removed
			io.put_string ("%N%N%N-------------------------------------------%N")
			from
				relevant_variables.start
			until
				relevant_variables.after
			loop
				io.put_string ("[relevant_variable] " + relevant_variables.key_for_iteration + ": " + relevant_variables.item_for_iteration.name + "%N")
				relevant_variables.forth
			end

				-- Process the feature body to extract snippets for each relevant variable.
			l_compound_as := body_compound_ast_from_feature (a_feature)
			if l_compound_as /= Void then
				if attached {EIFFEL_LIST [INSTRUCTION_AS]} ast_from_compound_text (text_from_ast (l_compound_as)) as l_compound then
						-- Gather control flow graph information.
					create l_cfg_builder
					l_cfg_builder.build_from_compound (l_compound, a_context_class, a_feature)
					check attached l_cfg_builder.last_control_flow_graph end

						-- Assign path IDs to nodes and continue processing.
					create l_path_initializer
					l_path_initializer.process_from_root (l_compound)
					relevant_variables.do_all_with_key (agent process_feature_with_relevant_variable (l_compound, ?, ?))
				end
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
			l_type: TYPE_A
			l_context_type: TYPE_A
		do
			fixme ("TODO: `l_sample_list: like a_sample_list' doesn't work.")

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
			l_context_type := context_class.constraint_actual_type
			across l_candidates as l_variables loop
				if l_variables.item.actual_type /= Void then
					l_type := l_variables.item.actual_type.instantiation_in (l_context_type, l_context_type.associated_class.class_id)
					l_type := explicit_type_in_context (l_type, l_context_type)
					if l_type.conform_to (context_class, relevant_target_type) then
						relevant_variables.force_last (l_variables.item, l_variables.key)
					end
				end
			end
		end

	process_feature_with_relevant_variable (a_compound_as: EIFFEL_LIST [INSTRUCTION_AS]; a_variable_type: TYPE_A; a_variable_name: STRING)
			-- Process `a_do_as' to extract snippets for relevant variable named `a_variable_name'.
			-- The type of the relevant variable is given by `a_variable_type'.
		local
			l_block_finder: EXT_AST_MARKER
		do
			to_implement ("To implement.")
			io.put_string ("%N== process_feature_with_relevant_variable (" + a_variable_name + ": " + a_variable_type.name + ") ==%N")

			create l_block_finder.make_from_variable (a_variable_type, a_variable_name)
			a_compound_as.process (l_block_finder)
		end

	collect_relevant_blocks (a_do_as: DO_AS; a_variable_type: TYPE_A; a_variable_name: STRING)
		local
		do
			-- Find the first basic block (called: head block) where `a_variable_name' is mentioned
			-- and start snippet extraction.


			-- Collect all basic blocks that mention `a_variable_name' and are at the same level as
			-- the head block.


		end

end
