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

	EPA_CFG_UTILITY

	EXT_SHARED_ANNOTATIONS

	EXT_SHARED_LOGGER

feature -- Access

	last_snippets: LINKED_LIST [EXT_SNIPPET]
			-- Snippets that are extracted by last `extract'

feature -- Basic operations

	extract (a_type: TYPE_A; a_feature: FEATURE_I; a_context_class: CLASS_C)
			-- Extract snippet for relevant target of type `a_type' from
			-- `a_feature' viewed in `a_context_class'.
			-- Make results available in `last_snippets'.
		require
			a_type_not_void: a_type /= Void
			a_feature_not_void: a_feature /= Void
			a_context_class_not_void: a_context_class /= Void
		local
			l_compound_as: EIFFEL_LIST [INSTRUCTION_AS]
			l_path_initializer: ETR_AST_PATH_INITIALIZER
			l_cfg_builder: EPA_CFG_BUILDER
			l_ast_printer: EXT_AST_PRINTER
		do
			relevant_target_type := a_type
			feature_ := a_feature
			context_class := a_context_class

			create last_snippets.make

				-- Collect relevant variables from `a_feature'.
			collect_relevant_variables

				-- Log debug information.
			log.put_string ("%N-----%N")
			from
				relevant_variables.start
			until
				relevant_variables.after
			loop
				log.put_string ("[relevant_variable] " + relevant_variables.key_for_iteration + ": " + relevant_variables.item_for_iteration.name + "%N")
				relevant_variables.forth
			end

				-- Process the feature body to extract snippets for each relevant variable.
			l_compound_as := body_compound_ast_from_feature (a_feature)
			if l_compound_as /= Void then
				if attached {EIFFEL_LIST [INSTRUCTION_AS]} ast_from_compound_text (text_from_ast (l_compound_as)) as l_compound then
						-- Assign path IDs to nodes, print AST and continue processing.
					create l_path_initializer
					l_path_initializer.process_from_root (l_compound)

						-- Print AST.
					log.put_string ("%N")
					create l_ast_printer
					l_compound.process (l_ast_printer)

						-- Gather control flow graph information.
					create l_cfg_builder
					l_cfg_builder.is_auxilary_nodes_created := True
					l_cfg_builder.build_from_compound (l_compound, a_context_class, a_feature)
					check attached l_cfg_builder.last_control_flow_graph end

					save_graph_to_dot_file (l_cfg_builder.last_control_flow_graph, "/tmp/cfg.dot")

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
			-- Table of relevant variables
			-- Keys are variable names, values are their types.
			-- Relevant variables are of either of the following kinds: Current, feature argument, local variable, Result.
			-- Relevant variables must have types that conform to `relevant_target_type'. (See
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

	collect_interface_variables (a_compound_as: EIFFEL_LIST [INSTRUCTION_AS]; a_variable_type: TYPE_A; a_variable_name: STRING): HASH_TABLE [TYPE_A, STRING]
			-- Collect interface variables.
			-- Keys are variable names, values are their types.
			-- Interface variables are of either of the following kinds: Current, feature argument, local variable, Result.
			-- Interface variables are mentioned in control flow statements solely witout a feature call.
		local
			operands: like operand_name_types_with_feature
			locals: like locals_from_feature_as
			l_candidates: HASH_TABLE [TYPE_A, STRING]
			l_iv_finder: EXT_INTERFACE_VARIABLE_FINDER
			l_shared_variable_context: EXT_SHARED_VARIABLE_CONTEXT
		do
			create Result.make (10)
			Result.compare_objects

				-- Collect all candidate variables.
			to_implement ("Include aliasing in form of: attached l_var.feature as l_alias.")
			create l_candidates.make (10)
			l_candidates.compare_objects
			operand_name_types_with_feature (feature_, context_class).do_all_with_key (agent l_candidates.force)
			across locals_from_feature_as (feature_.e_feature.ast, context_class) as l_locals loop
				l_candidates.force (l_locals.item, l_locals.key)
			end

				-- Remove the target variable from the list of candidate variables, if present.
			l_candidates.remove (a_variable_name)

				-- Set shared variable context used within AST processing.
			create l_shared_variable_context
			l_shared_variable_context.set_target_variable (a_variable_type, a_variable_name)

				-- Check type conformance against defintion.
			create l_iv_finder.make
			l_iv_finder.set_candidate_interface_variables (l_candidates)

			a_compound_as.process (l_iv_finder)

			across l_iv_finder.last_interface_variables as l_interface_variables loop
				Result.force (l_interface_variables.item, l_interface_variables.key)
			end
		end

	process_feature_with_relevant_variable (a_compound_as: EIFFEL_LIST [INSTRUCTION_AS]; a_variable_type: TYPE_A; a_variable_name: STRING)
			-- Process `a_do_as' to extract snippets for relevant variable named `a_variable_name'.
			-- The type of the relevant variable is given by `a_variable_type'.
		local
			l_ast_marker: EXT_AST_MARKER
			l_ast_pruner: EXT_AST_PRUNER
			l_interface_variables: HASH_TABLE [TYPE_A, STRING]
			l_shared_variable_context: EXT_SHARED_VARIABLE_CONTEXT
		do
				-- Debug
			log.put_string ("%N== process_feature_with_relevant_variable (" + a_variable_name + ": " + a_variable_type.name + ") ==%N")

				-- Reset shared annotation data structures.
			reset_annotations

				-- Collect interface variables from `a_compound_as'.
			l_interface_variables := collect_interface_variables (a_compound_as, a_variable_type, a_variable_name)

				-- Debug output collected interface.
			log.put_string ("%N-----%N")
			across l_interface_variables as l_iv loop
				log.put_string ("[interface_variable] " + l_iv.key + ": " + l_iv.item.name + "%N")
			end

				-- Set shared variable context used within AST processing.
			create l_shared_variable_context
			l_shared_variable_context.set_target_variable (a_variable_type, a_variable_name)
			l_shared_variable_context.set_interface_variables (l_interface_variables)

				-- Annotate AST.
			create l_ast_marker.make
			a_compound_as.process (l_ast_marker)

				-- Rewrite AST by removing obsolete statments and performing snippet tranformations.
			create l_ast_pruner.make_with_output (ast_printer_output)

			log.put_string ("%N")
			log.put_string (text_from_ast_with_printer (a_compound_as, l_ast_pruner))
		end

end
