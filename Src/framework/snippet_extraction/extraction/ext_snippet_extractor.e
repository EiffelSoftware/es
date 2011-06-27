note
	description: "Class to extract snippet from code."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_SNIPPET_EXTRACTOR

inherit
	AST_ITERATOR

	EGX_UTILITY

	EPA_CFG_UTILITY

	EPA_SHARED_EQUALITY_TESTERS

	EPA_TYPE_UTILITY

	EPA_UTILITY

	EXT_DEFERRED_SNIPPET_EXTRACTOR

	EXT_SNIPPET_DECIDER

	EXT_SHARED_LOGGER

create
	make

feature {NONE} -- Initialization

	make
			-- Default initialization.
		do
			set_logging_active (True)
		end

feature -- Access

	last_snippets: LINKED_SET [EXT_SNIPPET]
			-- Snippets that are extracted by last `extract_from_feature'

	is_logging_active: BOOLEAN
		assign set_logging_active
			 -- Should logging commands be executed?

	set_logging_active (a_active: BOOLEAN)
			-- Set `is_logging_active' to `a_active'.
		require
			a_active_attached: attached a_active
		do
			is_logging_active := a_active
		end

feature -- Basic operations

	extract_from_feature (a_type: TYPE_A; a_feature: FEATURE_I; a_context_class: CLASS_C; a_source: detachable STRING)
			-- Extract snippet for relevant target of type `a_type' from
			-- `a_feature' viewed in `a_context_class'.
			-- Make results available in `last_snippets'.
		local
			l_compound_as: EIFFEL_LIST [INSTRUCTION_AS]
			l_path_initializer: ETR_AST_PATH_INITIALIZER
		do
			log_feature_processing_header (a_context_class.name_in_upper, a_feature.feature_name, a_type.name)

			relevant_target_type := a_type
			feature_ := a_feature
			context_class := a_context_class
			if attached a_source then
				origin := a_source
			else
				origin := "unknown@unknown@unknown"
			end

			create last_snippets.make

				-- Collect relevant variables from `a_feature'.
			collect_relevant_variables

			if relevant_variables.is_empty then
				log.put_string ("> Dropping feature; no relevant variables for snippet extraction found%N")
			else
					-- Process the feature body to extract snippets for each relevant variable.
				l_compound_as := body_compound_ast_from_feature (a_feature)

					-- If features contains body compound, copy AST by roundtripping: AST -> TEXT -> AST
				if l_compound_as /= Void and then
					attached {EIFFEL_LIST [INSTRUCTION_AS]} ast_from_compound_text (text_from_ast (l_compound_as)) as l_compound then

					log_relevant_variables (relevant_variables)

						-- Assign path IDs to nodes, print AST and continue processing.
					create l_path_initializer
					l_path_initializer.process_from_root (l_compound)

					log.put_string ("%N")
					log_ast_structure (l_compound)
					log.put_string ("%N")
--					log_ast_text (l_compound)
--					log.put_string ("%N")

					relevant_variables.do_all_with_key (agent process_feature_with_relevant_variable (l_compound, ?, ?))
				else
					log.put_string ("> Dropping feature; empty AST body%N")
				end
			end

			log.put_string ("[Finished extraction]")
			log.put_string ("%N%N%N")
		end

feature {NONE} -- Implementation

	relevant_target_type: TYPE_A
			-- Type of variable whose snippets are to be extracted

	feature_: FEATURE_I
			-- Feature from which snippets are to be extracted

	context_class: CLASS_C
			-- Class where `feature_' is viewed

	origin: STRING
			-- Textual representation of the origin of a snippet.

	relevant_variables: DS_HASH_TABLE [TYPE_A, STRING]
			-- Table of relevant variables
			-- Keys are variable names, values are their types.
			-- Relevant variables are of either of the following kinds: Current, feature argument, local variable, Result, argumentless class feature.
			-- Relevant variables must have types that conform to `relevant_target_type'. (See
			-- the first argument of `extract_from_feature').


	variable_context: EXT_VARIABLE_CONTEXT
			-- Container to store variable information necessary for extraction process.


	collect_relevant_variables
			-- Collect relevant variables with respect to `relevant_target_type' from
			-- `feature_' and put results into `relevant_variables'.
		local
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
			l_candidates.merge (collect_argumentless_features (context_class))

				-- Check type conformance against `relevant_target_type'.
			l_context_type := context_class.constraint_actual_type
			across l_candidates as l_variables loop
				if attached l_variables.item and then attached l_variables.item.actual_type then

					l_type := l_variables.item.actual_type.instantiation_in (l_context_type, l_context_type.associated_class.class_id)
--					l_type := explicit_type_in_context (l_type, l_context_type)

					if l_type.conform_to (context_class, relevant_target_type) then
						relevant_variables.force_last (l_variables.item, l_variables.key)
					end
				end
			end
		end

	collect_candidate_interface_variables: HASH_TABLE [TYPE_A, STRING]
			-- Collect all variables that might potentially become an interface variable.		
		require
			target_variables_configured: attached variable_context.target_variables
		do
			create Result.make (10)
			Result.compare_objects

				-- Collect all possible candidate variables.
--			operand_name_types_with_feature (feature_, context_class).do_all_with_key (agent Result.force)
			across locals_from_feature_as (feature_.e_feature.ast, context_class) as l_locals loop
				Result.force (l_locals.item, l_locals.key)
			end
--			Result.merge (collect_argumentless_features (context_class))

				-- Remove the target variables from the candidate variables, if present.
			across variable_context.target_variables as l_target_variable_iterator loop
				Result.remove (l_target_variable_iterator.key)
			end
		end

	collect_interface_variables (a_compound_as: EIFFEL_LIST [INSTRUCTION_AS]; a_variable_type: TYPE_A; a_variable_name: STRING): HASH_TABLE [TYPE_A, STRING]
			-- Collect interface variables.
			-- Keys are variable names, values are their types.
			-- Interface variables are of either of the following kinds: Current, feature argument, local variable, Result.
			-- Interface variables are mentioned in control flow statements solely witout a feature call.
		require
			target_variables_configured: attached variable_context.target_variables
			candidate_interface_variables_configured: attached variable_context.candidate_interface_variables
		local
			l_interface_variable_finder: EXT_INTERFACE_VARIABLE_FINDER
		do
			create Result.make (10)
			Result.compare_objects

				-- Check type conformance against defintion.
			create l_interface_variable_finder.make
			l_interface_variable_finder.set_variable_context (variable_context)

			a_compound_as.process (l_interface_variable_finder)

			across l_interface_variable_finder.last_interface_variables as l_interface_variables loop
				Result.force (l_interface_variables.item, l_interface_variables.key)
			end
		ensure
			all_types_attached: across Result as l_interface_variable_table all l_interface_variable_table.item /= Void end
		end

	collect_argumentless_features (a_class: CLASS_C): HASH_TABLE [TYPE_A, STRING]
			-- Collecting all features of `a_class' that do not have arguments but a return value.
		do
			create Result.make (5)

			if a_class.has_feature_table then
				across a_class.feature_table.features as l_feature_cursor loop
					if attached {FEATURE_I} l_feature_cursor.item as l_feature then
							-- Check if feature does not have arguments but a return value
						if l_feature.argument_count = 0 and l_feature.has_return_value then
							Result.force (l_feature.type, l_feature.feature_name)
						end
					end
				end
			end
		end

	setup_variable_context (a_compound_as: EIFFEL_LIST [INSTRUCTION_AS]; a_variable_type: TYPE_A; a_variable_name: STRING)
			-- Initialization of variable context on which the extraction relies.
		local
			l_target_variable_table: HASH_TABLE [TYPE_A, STRING]
			l_object_test_as_alias_finder: EXT_OBJECT_TEST_AS_ALIAS_FINDER
		do
				-- Create variable context.
			create l_target_variable_table.make (5)
			l_target_variable_table.compare_objects
			l_target_variable_table.force (a_variable_type, a_variable_name)

			fixme ("EXPERIMENTAL")
			fixme ("Add `{OBJECT_TEST_AS}' aliases as target variables.")
			create l_object_test_as_alias_finder.make (l_target_variable_table, context_class)
			a_compound_as.process (l_object_test_as_alias_finder)

			l_target_variable_table.merge (l_object_test_as_alias_finder.last_object_test_aliases)

				-- Create and configure class feature `variable_context'.
			create variable_context.make
			variable_context.set_target_variables (l_target_variable_table)
			variable_context.set_candidate_interface_variables (collect_candidate_interface_variables)
			variable_context.set_interface_variables (collect_interface_variables (a_compound_as, a_variable_type, a_variable_name))

				-- Log
			log_interface_variables (variable_context.interface_variables)
		end

	process_feature_with_relevant_variable (a_compound_as: EIFFEL_LIST [INSTRUCTION_AS]; a_variable_type: TYPE_A; a_variable_name: STRING)
			-- Process `a_do_as' to extract snippets for relevant variable named `a_variable_name'.
			-- The type of the relevant variable is given by `a_variable_type'.
		require
			attached a_compound_as
			attached a_variable_type
			attached a_variable_name
		local
			l_snippet: EXT_SNIPPET
			l_snippet_operands: DS_HASH_TABLE [TYPE_A, STRING]
			l_compound_as: EIFFEL_LIST [INSTRUCTION_AS]
			l_hole_result: like perform_ast_hole_step
		do
			log.put_string ("%N")
			log_ast_processing_header (a_variable_name, a_variable_type.name)

				-- Find the entry point for the extraction, that is either the
				-- `a_compound_as' or smaller compound contained inside.
			l_compound_as := find_entry_point (a_compound_as, a_variable_type, a_variable_name)

				-- Setup `variable_context'.
			setup_variable_context (l_compound_as, a_variable_type, a_variable_name)

				-- AST modification steps.
			l_compound_as := perform_ast_prune_step (l_compound_as)
			l_compound_as := perform_ast_rewrite_if_as (l_compound_as)
			l_compound_as := perform_ast_rewrite_if_as (l_compound_as)
			l_compound_as := perform_ast_rewrite_loop_as (l_compound_as)

			l_hole_result := perform_ast_hole_step (l_compound_as)
			l_compound_as := l_hole_result.compound_as

			if decide_on_instruction_list (l_compound_as) then
				log.put_string ("%N")
				log_ast_text (l_compound_as)

				fixme ("Clean-up snippet object creation.")
				create l_snippet_operands.make (5)
				across variable_context.target_variables    as c loop l_snippet_operands.force (c.item, c.key) end
				across variable_context.interface_variables as c loop l_snippet_operands.force (c.item, c.key) end

				create l_snippet.make (
					text_from_ast (l_compound_as),
					l_snippet_operands,
					l_hole_result.annotations,
					origin)

				l_snippet.set_variable_context (variable_context)
				l_snippet.set_content_original (text_from_ast (a_compound_as))

				last_snippets.force (l_snippet)
			else
				log.put_string ("> Dropping feature; empty AST body after processing%N")
			end

			log_ast_processing_footer
		end

	find_entry_point (a_compound_as: EIFFEL_LIST [INSTRUCTION_AS]; a_variable_type: TYPE_A; a_variable_name: STRING): EIFFEL_LIST [INSTRUCTION_AS]
		local
			l_target_variable_table: HASH_TABLE [TYPE_A, STRING]
			l_variable_context: EXT_VARIABLE_CONTEXT
			l_entry_point_finder: EXT_ENTRY_POINT_FINDER
		do
				-- Create temporary variable context.
			create l_target_variable_table.make (1)
			l_target_variable_table.compare_objects
			l_target_variable_table.force (a_variable_type, a_variable_name)
			create l_variable_context.make
			l_variable_context.set_target_variables (l_target_variable_table)

			create l_entry_point_finder.make
			l_entry_point_finder.set_variable_context (l_variable_context)
			a_compound_as.process (l_entry_point_finder)

			if attached l_entry_point_finder.last_entry_point as l_entry_point then
					-- Set entry point that is a sub part of `a_compound_as'
				Result := l_entry_point
			else
					-- Fallback to original AST if no dedicated entry point was found.
				Result := a_compound_as
			end

		ensure
			attached Result
		end

	perform_ast_hole_step (a_compound_as: EIFFEL_LIST [INSTRUCTION_AS]): TUPLE [compound_as: EIFFEL_LIST [INSTRUCTION_AS]; annotations: DS_HASH_TABLE [EXT_ANN_HOLE, STRING]]
		local
			l_annotation_context: EXT_ANNOTATION_CONTEXT
			l_shared_annotations: like {EXT_ANNOTATION_CONTEXT}.annotations
			l_path_initializer: ETR_AST_PATH_INITIALIZER

			l_ast_marker: EXT_AST_HOLE_MARKER
			l_ast_rewriter: EXT_AST_HOLE_REWRITER

			l_annotations: DS_HASH_TABLE [EXT_ANN_HOLE, STRING]
		do
				-- Create shared annotation information passed from `{EXT_AST_HOLE_MARKER}' to `{EXT_AST_HOLE_REWRITER}'.
			create l_shared_annotations.make (10)
			l_shared_annotations.compare_objects

			create l_annotation_context.make
			l_annotation_context.set_annotations (l_shared_annotations)

				-- Apply `EXT_HOLE_PRUNE' tags.
			create l_ast_marker.make
			l_ast_marker.set_variable_context (variable_context)
			l_ast_marker.set_annotation_context (l_annotation_context)

			a_compound_as.process (l_ast_marker)

				-- Remove statements with `EXT_ANN_HOLE' tags.
			create l_ast_rewriter.make_with_output (ast_printer_output)
			l_ast_rewriter.set_annotation_context (l_annotation_context)

			if attached {EIFFEL_LIST [INSTRUCTION_AS]} ast_from_compound_text (text_from_ast_with_printer (a_compound_as, l_ast_rewriter)) as l_rewritten_compound_as then
					-- Assign path IDs to nodes, print AST and continue processing.
				create l_path_initializer
				l_path_initializer.process_from_root (l_rewritten_compound_as)

				create l_annotations.make_default
				across
					l_shared_annotations as l_cursor
				loop
					if attached {EXT_ANN_HOLE} l_cursor.item as l_annotation then
						l_annotations.force (l_annotation, l_annotation.out)
					end
				end

				create Result
				Result.compound_as := l_rewritten_compound_as
				Result.annotations := l_annotations
			else
				check false end
			end
		end

	perform_ast_prune_step (a_compound_as: EIFFEL_LIST [INSTRUCTION_AS]): EIFFEL_LIST [INSTRUCTION_AS]
		local
			l_ast_rewriter: EXT_AST_PRUNE_REWRITER
			l_path_initializer: ETR_AST_PATH_INITIALIZER
		do
			create l_ast_rewriter.make_with_output (ast_printer_output)
			l_ast_rewriter.set_variable_context (variable_context)

			if attached {EIFFEL_LIST [INSTRUCTION_AS]} ast_from_compound_text (text_from_ast_with_printer (a_compound_as, l_ast_rewriter)) as l_rewritten_compound_as then
				Result := l_rewritten_compound_as

					-- Assign path IDs to nodes, print AST and continue processing.
				create l_path_initializer
				l_path_initializer.process_from_root (Result)
			else
				check false end
			end
		end

	perform_ast_rewrite_if_as (a_compound_as: EIFFEL_LIST [INSTRUCTION_AS]): EIFFEL_LIST [INSTRUCTION_AS]
		local
			l_ast_rewriter: EXT_AST_IF_AS_REWRITER
			l_path_initializer: ETR_AST_PATH_INITIALIZER
		do
			create l_ast_rewriter.make_with_output (ast_printer_output)
			l_ast_rewriter.set_variable_context (variable_context)

			if attached {EIFFEL_LIST [INSTRUCTION_AS]} ast_from_compound_text (text_from_ast_with_printer (a_compound_as, l_ast_rewriter)) as l_rewritten_compound_as then
				Result := l_rewritten_compound_as

					-- Assign path IDs to nodes, print AST and continue processing.
				create l_path_initializer
				l_path_initializer.process_from_root (Result)
			else
				check false end
			end
		end

	perform_ast_rewrite_loop_as (a_compound_as: EIFFEL_LIST [INSTRUCTION_AS]): EIFFEL_LIST [INSTRUCTION_AS]
		local
			l_ast_rewriter: EXT_AST_LOOP_AS_REWRITER
			l_path_initializer: ETR_AST_PATH_INITIALIZER
		do
			create l_ast_rewriter.make_with_output (ast_printer_output)
			l_ast_rewriter.set_variable_context (variable_context)

			if attached {EIFFEL_LIST [INSTRUCTION_AS]} ast_from_compound_text (text_from_ast_with_printer (a_compound_as, l_ast_rewriter)) as l_rewritten_compound_as then
				Result := l_rewritten_compound_as

					-- Assign path IDs to nodes, print AST and continue processing.
				create l_path_initializer
				l_path_initializer.process_from_root (Result)
			else
				check false end
			end
		end

feature {NONE} -- Temporary

	locals_from_feature_as (a_feature: FEATURE_AS; a_context_class: CLASS_C): HASH_TABLE [TYPE_A, STRING]
			-- Locals from `a_feature'
			-- The returned TYPE_As are not guaranteed to be explicit.
		local
			l_type: TYPE_AS
			l_type_a: TYPE_A
			l_names_heap: like names_heap
		do
			create Result.make (10)
			Result.compare_objects
			if attached {BODY_AS} a_feature.body as l_body and then attached {ROUTINE_AS} l_body.as_routine as l_routine then
				if attached {EIFFEL_LIST [TYPE_DEC_AS]} l_routine.locals as l_lcls then
					l_names_heap := names_heap
					across l_lcls as l_locals loop
						l_type := l_locals.item.type

						if text_from_ast (l_type).has_substring ("[like") then
							log.put_string ("> Skipping variable(s). Couldn't resolve type of local variable(s) ")
							across l_locals.item.id_list as l_vars loop
								log.put_string (l_names_heap.item (l_vars.item))
								log.put_string (" ")
							end
							log.put_string ("- Contains 'like' keyword in generics that is not supported.%N")
						else
								-- `type_a_from_string' does not succeed always in resolving the type. It is known to
								-- not support the occurence of the `like' keyword in the generics part of a type declaration.
								-- It resolves neither generics in general.
							l_type_a := type_a_from_string (text_from_ast (l_type), a_context_class)

								-- Attempt to resolve type once again if previous evaluation failed. The following call
								-- succeeds for generic delarations.
							if not attached l_type_a then
								l_type_a := type_a_generator.evaluate_type_if_possible (l_type, a_context_class)
							end

								-- Did type evaluation finally succeed?
							if attached l_type_a then
								across l_locals.item.id_list as l_vars loop
									Result.put (l_type_a, l_names_heap.item (l_vars.item))
								end
							else
								log.put_string ("> Skipping variable(s). Couldn't resolve type of local variable(s) ")
								across l_locals.item.id_list as l_vars loop
									log.put_string (l_names_heap.item (l_vars.item))
									log.put_string ("; ")
								end
								log.put_string ("%N")
							end
						end
					end
				end
			end
		end

feature {NONE} -- Debug

	is_logging_ast_structure: BOOLEAN = True
			-- Should the structural information of the AST for snippet extraction be logged?

	is_logging_ast_text: BOOLEAN = True
			-- Should the text representation of the extracted snippet be logged?

	is_logging_relevant_variables: BOOLEAN = True
			-- Should the list of relevant variables be logged?

	is_logging_interface_variables: BOOLEAN = True
			-- Should the list of interface variables be logged?

	log_ast_structure (a_as: AST_EIFFEL)
			-- Logs the textual representation of `a_as' structure.
		local
			l_ast_structure_printer: EXT_AST_HIERARCHICAL_STRUCTURE_PRINTER
		do
			if is_logging_active and is_logging_ast_structure then
					-- Print AST.
				fixme ("Refactor AST Printer to not make directly use of LOGGING library.")
				create l_ast_structure_printer
				a_as.process (l_ast_structure_printer)
			end
		end


	log_ast_text (a_as: AST_EIFFEL)
			-- Logs the textual representation of `a_as'.	
		do
			if is_logging_active and is_logging_ast_text then
				log.put_string (text_from_ast (a_as))
			end
		end

	log_relevant_variables (a_relevant_variables: like relevant_variables)
			-- Logs the textual representation of `a_relevant_variables'.
		do
			if is_logging_active and is_logging_relevant_variables then
				from
					relevant_variables.start
				until
					relevant_variables.after
				loop
					log.put_string ("[relevant_variable] " + relevant_variables.key_for_iteration + ": " + relevant_variables.item_for_iteration.name + "%N")
					relevant_variables.forth
				end
			end
		end

	log_interface_variables (a_interface_variables: like collect_interface_variables)
			-- Logs the textual representation of `a_interface_variables'.
		do
			if is_logging_active and is_logging_interface_variables then
				across a_interface_variables as l_iv loop
					log.put_string ("[interface_variable] " + l_iv.key)
					if attached l_iv.item then
						log.put_string (": " + l_iv.item.name)
					end
					log.put_string ("%N")
				end
			end
		end

	log_ast_processing_header (a_variable_name, a_variable_type_name: STRING)
			-- Logs header information for processing a target variable.
		do
			if is_logging_active then
				log.put_string ("[Start processing AST w.r.t target variable (" + a_variable_name + ": " + a_variable_type_name + ")]%N")
			end
		end

	log_ast_processing_footer
			-- Logs footer information for processing a target variable.
		do
			if is_logging_active then
				log.put_string ("[Stop processing]%N")
			end
		end

	log_feature_processing_header (a_class_name, a_feature_name, a_type_name: STRING)
			-- Logs header information on starting processing a feature.
		do
			if is_logging_active then
				log.put_string ("[Start extracting from ")
				log.put_string (a_class_name)
				log.put_string (".")
				log.put_string (a_feature_name)
				log.put_string (" usage information about type ")
				log.put_string (a_type_name)
				log.put_string ("]%N")
			end
		end

feature {NONE} -- Dummy

	examples: EXT_EXAMPLES
			-- Reference to `EXT_EXAMPLE' class that it will get compiled.
			-- Contains simple benchmark examples for analysis.
			-- To be removed!

end
