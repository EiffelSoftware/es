note
	description: "Iterator to generally extract holes from an AST."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_GENERAL_HOLE_EXTRACTOR

inherit
	AST_ITERATOR
		export
			{NONE} all
		redefine
			process_assign_as,
			process_creation_as,
			process_elseif_as,
			process_if_as,
			process_instr_call_as,
			process_loop_as,
			process_object_test_as,
			process_parameter_list_as
		end

	EXT_HOLE_EXTRACTOR

	EXT_HOLE_FACTORY_AWARE

	EXT_VARIABLE_CONTEXT_AWARE

	EPA_UTILITY

	REFACTORING_HELPER

create
	make_with_arguments

feature {NONE} -- Initialization

	make_with_arguments (a_variable_context: like variable_context; a_factory: EXT_HOLE_FACTORY)
			-- Default initialization.
		require
			attached a_variable_context
			attached a_factory
		local
			l_variable_set: DS_HASH_SET [STRING]
		do
			variable_context := a_variable_context
			hole_factory := a_factory

			create l_variable_set.make_equal (10)
			variable_context.variables_of_interest.current_keys.do_all (agent l_variable_set.put)

			create variable_of_interest_usage_checker.make_from_variables (l_variable_set)

			create feature_chaining_checker.make
		end

feature -- Basic operations

	extract (a_ast: AST_EIFFEL)
			-- Extract annotations from `a_ast' and
			-- make results available in `last_holes' and
			-- make transformed AST available in `last_ast'.
		do
				-- Freshly initialize variables holding the output of the run.
			initialize_hole_context

				-- Process and rewrite AST to output while collecting holes.
			a_ast.process (Current)
		end

feature {NONE} -- Implementation

	variable_of_interest_usage_checker: EXT_AST_VARIABLE_USAGE_CHECKER
			-- Checks if an AST is accessing any variable of interest.

	feature_chaining_checker: EXT_AST_CHAINED_FEATURE_CALL_CHECKER
			-- Checker if feature calls are chained together.

	process_assign_as (l_as: ASSIGN_AS)
		require else
			l_as_path_not_void: attached l_as.path
		do
			if variable_context.is_variable_of_interest (l_as.target.access_name_8) then
					-- Retain target, scan and annotate source expression.
				processing_expr (l_as.source)
			else
				variable_of_interest_usage_checker.check_ast (l_as.source)
				if variable_of_interest_usage_checker.passed_check then
						-- make hole: only source expression uses variable of interest
					process_as_hole (l_as)
				end
			end
		end

	process_creation_as (l_as: CREATION_AS)
		require else
			l_as_path_not_void: attached l_as.path
		do
			processing_call (l_as, l_as.target, l_as.call)
		end

	process_elseif_as (l_as: ELSIF_AS)
		require else
			l_as_path_not_void: attached l_as.path
		do
				-- Annotate the expression, continue parsing with the body.
			processing_expr (l_as.expr)
			safe_process (l_as.compound)
		end

	process_if_as (l_as: IF_AS)
		do
			processing_expr (l_as.condition)
			safe_process (l_as.compound)
			safe_process (l_as.elsif_list)
			safe_process (l_as.else_part)
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
			-- add NESTED_EXPR_AS
			-- add CREATION_EXPR_AS
			if attached {NESTED_AS} l_as.call as l_call_as then
					-- Check passes if feature calls are not chained.
				feature_chaining_checker.check_ast (l_call_as)
				if feature_chaining_checker.passed_check then
					processing_call (l_as, l_call_as.target, l_call_as.message)
				else
					process_as_hole (l_as)
				end
			elseif attached {ACCESS_AS} l_as.call as l_call_as then
				processing_call (l_as, l_call_as, Void)
			else
				Precursor (l_as)
			end
		end

	process_loop_as (l_as: LOOP_AS)
		do
			safe_process (l_as.iteration)
			safe_process (l_as.from_part)
			safe_process (l_as.invariant_part)

			if attached l_as.stop then
				processing_expr (l_as.stop)
			end

			safe_process (l_as.compound)
			safe_process (l_as.variant_part)
		end

	process_object_test_as (l_as: OBJECT_TEST_AS)
		do
--			Precursor (l_as)
			fixme ("Simple naive implementation of object test pruning.")
			if attached l_as.expression then
				variable_of_interest_usage_checker.check_ast (l_as.expression)
				if not variable_of_interest_usage_checker.passed_check then
						-- make hole: object test not refering to target variable.
					process_as_hole (l_as)
				elseif not is_expr_as_clean (l_as.expression) then
						-- make hole: expression to complex
					process_as_hole (l_as.expression)
				end
			end
		end

	process_parameter_list_as (l_as: PARAMETER_LIST_AS)
		do
			if attached {EIFFEL_LIST [EXPR_AS]} l_as.parameters as l_parameters then
				across l_parameters as l_cursor loop
					processing_expr (l_cursor.item)
				end
			end
		end

feature {NONE} -- Implementation (Helper)

	processing_call (l_as: AST_EIFFEL; l_target_as: ACCESS_AS; l_call_as: CALL_AS)
		require else
			l_as_path_not_void: attached l_as.path
			l_target_as_not_void: attached l_target_as
		do
				-- Check because PRECURSOR_AS does not have an access name.
			if attached l_target_as.access_name_8 and then variable_context.is_variable_of_interest (l_target_as.access_name_8) then
				if attached l_call_as then
					l_call_as.process (Current)
				end
			else
				if attached l_call_as then
						-- check call arguments
					variable_of_interest_usage_checker.check_ast (l_call_as)
					if variable_of_interest_usage_checker.passed_check then
							-- make hole: variables of interest used in call
						process_as_hole (l_as)
					end

					-- class feature call
				elseif attached {ACCESS_FEAT_AS} l_target_as as l_access_feat_as then
					if attached l_access_feat_as.internal_parameters as l_internal_parameter then
							-- make hole: variables of interest used in call
						process_as_hole (l_as)
					end
				end
			end
		end

	processing_class_feature_call (l_as: AST_EIFFEL; l_target_as: ACCESS_AS)
		require else
			l_as_path_not_void: attached l_as.path
			l_target_as_not_void: attached l_target_as
		do
			if variable_context.is_variable_of_interest (l_target_as.access_name_8) then
				l_target_as.process (Current)
			else
					-- make hole: variables of interest used in call
				fixme ("Processing argument list.")
				process_as_hole (l_as)
			end
		end

	processing_expr (l_as: EXPR_AS)
		require
			l_as_not_void: attached l_as
			l_as_path_not_void: attached l_as.path
		do
			if attached {OBJECT_TEST_AS} l_as as l_object_test_as then
				process_object_test_as (l_object_test_as)
			else
				if not is_expr_as_clean (l_as) then
						-- make hole: expression to complex to keep unchanged.
					process_as_hole (l_as)
				end
			end
		end

feature {NONE} -- Hole Handling

	create_hole (a_ast: AST_EIFFEL): EXT_HOLE
			-- Create a new `{EXT_HOLE}' with metadata.
		local
			l_annotation_extractor: EXT_MENTION_ANNOTATION_EXTRACTOR
		do
			create l_annotation_extractor.make_from_variable_context (variable_context)
			l_annotation_extractor.extract_from_ast (a_ast)

			Result := hole_factory.new_hole (l_annotation_extractor.last_annotations)
		end

	process_as_hole (a_ast: AST_EIFFEL)
			-- Creates a hole if `a_ast' is not ready one.
		local
			l_hole: EXT_HOLE
		do
			if not is_hole (a_ast) then
				l_hole := create_hole (a_ast)
				add_hole (l_hole, a_ast.path)
			end
		end

	is_hole (a_ast: AST_EIFFEL): BOOLEAN
			-- Checks if `a_ast' is an AST repressentation of an `{EXT_HOLE}'.
		do
			Result := text_from_ast (a_ast).starts_with ({EXT_HOLE}.hole_name_prefix)
		end

feature {NONE} -- Helper

	is_expr_as_clean (a_as: EXPR_AS): BOOLEAN
			-- AST iterator processing `a_as' answering if that expression can stay as it is.
		local
			l_variable_set: DS_HASH_SET [STRING]
			l_ast_node_checker: EXT_AST_EIFFEL_NODE_CHECKER
			l_no_unknown_variable_checker: EXT_AST_VARIABLE_USAGE_CHECKER
		do
			create l_ast_node_checker.make
			l_ast_node_checker.allow_all
			l_ast_node_checker.deny_node ({EXT_AST_EIFFEL_NODE_CHECKER}.node_string_as)
			l_ast_node_checker.deny_node ({EXT_AST_EIFFEL_NODE_CHECKER}.node_integer_as)
			l_ast_node_checker.deny_node ({EXT_AST_EIFFEL_NODE_CHECKER}.node_creation_expr_as)
			l_ast_node_checker.deny_node ({EXT_AST_EIFFEL_NODE_CHECKER}.node_agent_routine_creation_as)
			l_ast_node_checker.deny_node ({EXT_AST_EIFFEL_NODE_CHECKER}.node_inline_agent_creation_as)
			l_ast_node_checker.check_ast (a_as)

			create l_variable_set.make_equal (10)
			variable_context.variables_of_interest.current_keys.do_all (agent l_variable_set.put)

			create l_no_unknown_variable_checker.make_from_variables (l_variable_set)
			l_no_unknown_variable_checker.set_check_function (agent l_no_unknown_variable_checker.check_is_ast_using_no_other_variables)
			l_no_unknown_variable_checker.check_ast (a_as)

			feature_chaining_checker.check_ast (a_as)

			Result := l_ast_node_checker.passed_check and
						then l_no_unknown_variable_checker.passed_check and
						then feature_chaining_checker.passed_check
		end

end
