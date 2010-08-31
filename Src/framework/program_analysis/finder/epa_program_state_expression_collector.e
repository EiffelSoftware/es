note
	description: "Summary description for {AFX_PROGRAM_STATE_EXPRESSION_COLLECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_PROGRAM_STATE_EXPRESSION_COLLECTOR

inherit
	REFACTORING_HELPER

	AST_ITERATOR
		redefine
			process_access_feat_as,
			process_access_id_as,
			process_access_inv_as,
			process_binary_as,
			process_parameter_list_as,
			process_nested_as
		end

	EPA_ARGUMENTLESS_PRIMITIVE_FEATURE_FINDER
		export
			{NONE} all
		end

	EPA_UTILITY

create
	default_create

feature -- Access

	last_collection: DS_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION]
			-- Result set of program state expressions from last collecting.
		do
			if last_collection_cache = Void then
				create last_collection_cache.make_default
				last_collection_cache.set_equality_tester (Expression_equality_tester)
			end

			Result := last_collection_cache
		end

feature -- Operation

	collect_from_class (a_context_class: CLASS_C)
			-- Collect all expressions from 'a_context_class', and
			--		append the expressions into `last_collection'.
		local
			l_features: LIST [FEATURE_I]
			l_feat: FEATURE_I
			l_cursor: CURSOR
		do
			l_features := features_in_class (a_context_class, Void)
			l_cursor := l_features.cursor
			from l_features.start
			until l_features.after
			loop
				l_feat := l_features.item_for_iteration

				collect_from_feature (a_context_class, l_feat)

				l_features.forth
			end
			l_features.go_to (l_cursor)
		end

	collect_from_feature (a_context_class: CLASS_C; a_feature: FEATURE_I)
			-- Collect all expressions from 'a_feature' in the context of 'a_context_class', and
			--		append the expressions into `last_collection'.
		local
			l_written_class: CLASS_C
			l_ast: AST_EIFFEL
			l_initializer: ETR_BP_SLOT_INITIALIZER
		do
			context_class := a_context_class
			context_feature := a_feature
			l_written_class := a_feature.written_class

			-- Feature text as in 'context_class'.
			l_ast := context_feature.e_feature.ast
			l_ast := ast_in_context_class (l_ast, l_written_class, context_feature, context_class)

			-- Calculate breakpoint locations for ast nodes.
			create l_initializer
			l_initializer.init_with_context (l_ast, context_class)

			-- Collect all expressions.
			l_ast.process (Current)
		end

feature{NONE} -- Auxiliary

	reset_collector
			-- Reset the state of the collector.
		do
			last_collection.wipe_out
			nested_stacks.wipe_out
		end

feature --  Visitor routine

	process_binary_as (l_as: BINARY_AS)
			-- <Precursor>
		local
			l_expr: EPA_PROGRAM_STATE_EXPRESSION
			l_ot_checker: EPA_OBJECT_TEST_CHECKER
		do
			create l_ot_checker.make
			l_as.process (l_ot_checker)
			if not l_ot_checker.object_test_found then
				create l_expr.make_with_text (context_class, context_feature, text_from_ast (l_as), context_class)
				if not l_expr.has_syntax_error and then not l_expr.has_type_error then
					l_expr.set_breakpoint_slot (l_as.breakpoint_slot)
					last_collection.force_last (l_expr)
				end
			end
			precursor(l_as)
		end

	process_nested_as (l_as: NESTED_AS)
			-- <Precursor>
		do
			enter_nesting
			precursor(l_as)
			exit_nesting (l_as.breakpoint_slot)
		end

	process_parameter_list_as (l_as: PARAMETER_LIST_AS)
			-- <Precursor>
		local
			l_list: EIFFEL_LIST [EXPR_AS]
		do
			enter_parameters
			precursor(l_as)
			exit_parameters
		end

	process_access_id_as (l_as: ACCESS_ID_AS)
			-- <Precursor>
		do
			precursor(l_as)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
			-- <Precursor>
		local
			l_expr: EPA_PROGRAM_STATE_EXPRESSION
		do
			if is_nested then
				current_stack.put (text_from_ast (l_as))
			else
				create l_expr.make_with_text (context_class, context_feature, text_from_ast (l_as), context_class)
				if not l_expr.has_syntax_error and then not l_expr.has_type_error then
					l_expr.set_breakpoint_slot (l_as.breakpoint_slot)
					last_collection.force_last (l_expr)
				end
			end
			precursor(l_as)
		end

	process_access_inv_as (l_as: ACCESS_INV_AS)
			-- <Precursor>
		local
			l_expr: EPA_AST_EXPRESSION
		do
			precursor(l_as)
		end

feature{NONE} -- Implementation

	enter_nesting
			-- Enter a nested expression.
		do
			is_nested := True
		end

	exit_nesting (a_bp_slot: INTEGER)
			-- Exit a nested expression.
		do
			is_nested := False
			save_current_nesting (a_bp_slot)
			current_stack.remove
			if current_stack.count = 1 then
				current_stack.wipe_out
			end
		end

	enter_parameters
			-- Enter parameter list.
		local
			l_stack: LINKED_STACK[STRING]
		do
			create l_stack.make
			nested_stacks.put (l_stack)
		end

	exit_parameters
			-- Exit parameter list.
		do
			nested_stacks.remove
		end

	save_current_nesting (a_bp_slot: INTEGER)
			-- Save a sub-expression recognized so far.
		local
			l_list: ARRAYED_LIST[STRING]
			l_aggregate: STRING
			l_expr: EPA_PROGRAM_STATE_EXPRESSION
		do
			create l_aggregate.make_empty
			l_list := current_stack.linear_representation
			from
				l_list.finish
			until
				l_list.before
			loop
				l_aggregate.append (l_list.item_for_iteration)
				l_aggregate.append (".")
				l_list.back
			end
			l_aggregate.remove_tail (1)
			if not l_aggregate.is_empty then
				create l_expr.make_with_text (context_class, context_feature, l_aggregate, context_class)
				if not l_expr.has_syntax_error and then not l_expr.has_type_error then
					l_expr.set_breakpoint_slot (a_bp_slot)
					last_collection.force_last (l_expr)
				end
			end
		end

feature{NONE} -- Implementation

	context_class: CLASS_C
			-- Context class where expressions would be collected.

	context_feature: FEATURE_I
			-- Feature from which to collect expressions.

	is_nested: BOOLEAN
			-- Is processing inside an {NESTED_AS} node?

	nested_stacks: LINKED_STACK[LINKED_STACK[STRING]]
			-- Stacks for processing nested expressions.
		do
			if nested_stacks_cache = Void then
				create nested_stacks_cache.make
			end

			Result := nested_stacks_cache
		ensure
			result_attached: Result /= Void
		end

	current_stack: LINKED_STACK[STRING]
			-- The current stack where nested expressions are kept.
		local
			l_stack: LINKED_STACK[STRING]
		do
			if nested_stacks.is_empty then
				create l_stack.make
				nested_stacks.put (l_stack)
			end
			Result := nested_stacks.item
		end

feature{NONE} -- Caches

	Expression_equality_tester: EPA_PROGRAM_STATE_EXPRESSION_EQUALITY_TESTER
			-- Equality tester for expressions.
		once
			create Result
		end

	last_collection_cache: like last_collection
			-- Cache for `last_collection'.

	nested_stacks_cache: like nested_stacks
			-- Cache for `nested_stacks'.

end



--	ast_in_context_class (a_ast: AST_EIFFEL; a_written_class: CLASS_C; a_written_feature: detachable FEATURE_I; a_context_class: CLASS_C): AST_EIFFEL
--           -- AST representing `a_ast', which comes from `a_written_feature' in `a_written_class'.
--           -- The resulting AST is viewed from `a_context_class' and with all renaming resolved.
--           -- `a_written_class' and `a_context_class' should be in the same inheritance hierarchy.
--       local
--           l_source_context: ETR_CONTEXT
--           l_target_context: ETR_CONTEXT
--           l_feat_context: ETR_FEATURE_CONTEXT
--           l_class_context: ETR_CLASS_CONTEXT
--           l_feat: FEATURE_I
--           l_transformable: ETR_TRANSFORMABLE
--       do
--           if a_written_class /= Void then
--                   -- Calculate source context.
--               create l_class_context.make (a_written_class)
--               create l_feat_context.make (a_written_feature, l_class_context)
--               l_source_context := l_feat_context

--                   -- Calculate target context.
--               l_feat := a_context_class.feature_of_rout_id_set (a_written_feature.rout_id_set)
--               create l_class_context.make (a_context_class)
--               create l_feat_context.make (l_feat, l_class_context)
--               l_target_context := l_feat_context
--           else
--                   -- Calculate source context.
--               create l_class_context.make (a_written_class)
--               l_source_context := l_class_context

--                   -- Calculate target context.
--               create l_class_context.make (a_context_class)
--               l_target_context := l_class_context
--           end

--           create l_transformable.make (a_ast, l_source_context, True)
--           Result := l_transformable.as_in_other_context (l_target_context).to_ast
--       end

