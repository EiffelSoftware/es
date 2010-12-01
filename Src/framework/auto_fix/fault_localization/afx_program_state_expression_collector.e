note
	description: "Summary description for {AFX_PROGRAM_STATE_EXPRESSION_COLLECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_STATE_EXPRESSION_COLLECTOR

inherit

	AST_ITERATOR
		redefine
			process_binary_as,
			process_unary_as,
			process_access_feat_as,
			process_access_id_as,
			process_access_assert_as,
			process_precursor_as,
			process_current_as,
			process_result_as,
			process_access_inv_as,
			process_eiffel_list,
			process_nested_as
		end

	EPA_ARGUMENTLESS_PRIMITIVE_FEATURE_FINDER
		export
			{NONE} all
		end

	SHARED_TYPES

	AFX_SHARED_SERVER_VARIABLES_IN_SCOPE

	EPA_UTILITY

	AFX_SHARED_SESSION

	REFACTORING_HELPER

--	AFX_SHARED_SERVER_VARIABLES_IN_SCOPE

create
	default_create

feature -- Access

	last_collection_in_written_class: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			-- Set of program state expressions collected regarding "written_class"es of the features.
		do
			if last_collection_in_written_class_cache = Void then
				create last_collection_in_written_class_cache.make_default
				last_collection_in_written_class_cache.set_equality_tester (program_state_expression_equality_tester)
			end

			Result := last_collection_in_written_class_cache
		end

	last_collection_in_written_class_cache: like last_collection_in_written_class
			-- Cache for `last_collection_in_written_class'.

feature -- Basic operation

	collect_from_class (a_context_class: CLASS_C)
			-- Collect all expressions from 'a_context_class',
			--		and make the expressions available in `last_collection'.
		local
			l_features: LIST [FEATURE_I]
			l_feat: FEATURE_I
			l_cursor: CURSOR
		do
			reset_collector

			l_features := features_in_class (a_context_class, Void)
			l_cursor := l_features.cursor

			from l_features.start
			until l_features.after
			loop
				l_feat := l_features.item_for_iteration

				collect_from_feature (a_context_class, l_feat, False)

				l_features.forth
			end

			l_features.go_to (l_cursor)
		end

	collect_from_expression (a_context_class: CLASS_C; a_feature: FEATURE_I; a_expr_ast: EXPR_AS; a_should_reset_collector: BOOLEAN)
			-- Collect all sub-expressions of `a_expr_ast', in the context of `a_context_class'.`a_feature'.
			-- If `a_reset_collection' is set, the internal state of the current collector would be reset before starting.
			-- The result expression objects don't have any breakpoint index information in this case.
		local
		do
			if a_should_reset_collector then
				reset_collector
			end

			context_class := a_context_class
			context_feature := a_feature
			a_expr_ast.process (Current)
		end

	collect_from_feature (a_context_class: CLASS_C; a_feature: FEATURE_I; a_should_reset_collector: BOOLEAN)
			-- Collect all expressions in 'a_feature' from 'a_context_class', and add the expressions into `last_collection'.
			-- If `a_reset_collection' is set, the internal state of the current collector would be reset before starting.
			--
			-- If a local variable is never used inside the feature, it will not be collected since it always has the default value.
			-- However, all arguments would be collected since each of them holds some potentially interesting value.
		local
			l_written_class: CLASS_C
			l_ast: AST_EIFFEL
			l_initializer: ETR_BP_SLOT_INITIALIZER
		do
			if a_should_reset_collector then
				fixme ("Check wiping out nested_stacks during resetting would not cause problem. -- Oct. 27, 2010 Max")
				reset_collector
			end

			context_class := a_context_class
			context_feature := a_feature
			l_written_class := a_feature.written_class

			-- Expressions are collected from feature text as in the "written_class", and need to be
			--		transformed into the "context_class" before evaluation.
			l_ast := context_feature.e_feature.ast

			-- Initialize breakpoint locations in ast nodes.
			create l_initializer
			l_initializer.init_with_context (l_ast, context_class)

			-- Collect all expressions.
			l_ast.process (Current)

			add_arguments_current_and_result
		end

--	feature_names_table: DS_HASH_TABLE [EPA_HASH_SET[STRING], INTEGER]
--			-- Table of feature names for classes.
--			-- Key: class_id
--			-- Val: set of feature names

feature{NONE} -- Auxiliary

	reset_collector
			-- Reset the state of the collector.
		do
			last_collection_in_written_class_cache := Void
			expression_stack_cache := Void
			nested_level_stack_cache := Void
		end

	add_arguments_current_and_result
			-- Add arguments, "Current" and "Result" into the expression set.
		local
		    l_feature: FEATURE_I
		    l_class: CLASS_C
		    l_name: STRING
			l_expr: AFX_PROGRAM_STATE_EXPRESSION
			l_indx, l_count: INTEGER
		do
		    l_feature := context_feature

		    -- Arguments.
		    from
		    	l_indx := 1
		    	l_count := l_feature.argument_count
		    until
		    	l_indx > l_count
		    loop
		    	l_name := l_feature.arguments.item_name (l_indx)

				create l_expr.make_with_text (context_class, context_feature, l_name, written_class, 0)
				add_expression (l_expr)

		    	l_indx := l_indx + 1
		    end

			-- "Current".
			create l_expr.make_with_text (context_class, context_feature, "Current", written_class, 0)
			add_expression (l_expr)

			-- "Result" if applicable.
			if context_feature.type /= Void and then context_feature.type /= Void_type then
				create l_expr.make_with_text (context_class, context_feature, "Result", written_class, 0)
				add_expression (l_expr)
			end
		end

	add_expression (a_expr: AFX_PROGRAM_STATE_EXPRESSION)
			-- Add `a_expr' to the collection of expressions.
			-- `a_exp' was collected from "written_class".
			-- It would be transformed and put into the collection for "context_class" also.
		do
			if not a_expr.has_syntax_error and then not a_expr.has_type_error and then a_expr.type /= Void and then not a_expr.type.is_void then
				last_collection_in_written_class.force (a_expr)
			end
		end

feature --  Visitor routine

	process_binary_as (l_as: BINARY_AS)
			-- <Precursor>
		local
			l_expr: AFX_PROGRAM_STATE_EXPRESSION
		do
			precursor(l_as)

			create l_expr.make_with_text (context_class, context_feature, text_from_ast (l_as), written_class, l_as.breakpoint_slot)
			add_expression (l_expr)
		end

	process_unary_as (l_as: UNARY_AS)
			-- <Precursor>
		local
			l_expr: AFX_PROGRAM_STATE_EXPRESSION
		do
			precursor(l_as)

			create l_expr.make_with_text (context_class, context_feature, text_from_ast (l_as), written_class, l_as.breakpoint_slot)
			add_expression (l_expr)
		end

	process_nested_as (l_as: NESTED_AS)
			-- <Precursor>
		do
			enter_nested
			precursor(l_as)
			exit_nested
		end

	process_precursor_as (l_as: PRECURSOR_AS)
			-- <Precursor>
		do
			precursor (l_as)
			process_access (l_as)
		end

	process_current_as (l_as: CURRENT_AS)
			-- <Precursor>
		do
			precursor (l_as)
			process_access (l_as)
		end

	process_result_as (l_as: RESULT_AS)
			-- <Precursor>
		do
			precursor (l_as)
			process_access (l_as)
		end

	process_access_id_as (l_as: ACCESS_ID_AS)
			-- <Precursor>
		do
			precursor(l_as)
			process_access (l_as)
			process_feature_call_on_current (l_as)
		end

	process_access_assert_as (l_as: ACCESS_ASSERT_AS)
			-- <Precursor>
		do
			precursor(l_as)
			process_access (l_as)
			process_feature_call_on_current (l_as)
		end

	process_access_inv_as (l_as: ACCESS_INV_AS)
			-- <Precursor>
		do
			precursor(l_as)
			process_access (l_as)
			process_feature_call_on_current (l_as)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
			-- <Precursor>
		do
			precursor(l_as)
			process_access (l_as)
		end

	process_eiffel_list (l_as: EIFFEL_LIST [AST_EIFFEL])
			-- <Precursor>
		local
			l_cursor: INTEGER
		do
			if attached {EIFFEL_LIST [EXPR_AS]} l_as as lt_list then
				from
					l_cursor := l_as.index
					l_as.start
				until
					l_as.after
				loop
					if attached l_as.item as l_item then
						enter_sub_expression
						l_item.process (Current)
						exit_sub_expression
					else
						check False end
					end
					l_as.forth
				end
				l_as.go_i_th (l_cursor)
			else
				precursor (l_as)
			end
		end

feature{NONE} -- Implementation

	process_access (l_as: AST_EIFFEL)
			-- Process all "acess_*_as" nodes in a similar way.
		local
			l_text: STRING
			l_expr: AFX_PROGRAM_STATE_EXPRESSION
		do
			l_text := text_from_ast (l_as)
			if is_within_nested then
				-- Save prefix expression processed so far.
				current_nested_expression_stack.put (l_text)
				save_current_nesting (l_as.breakpoint_slot)
			else
				-- Save standalone expression.
				create l_expr.make_with_text (context_class, context_feature, l_text, written_class, l_as.breakpoint_slot)
				add_expression (l_expr)
			end
		end

	process_feature_call_on_current (l_as: ACCESS_FEAT_AS)
			-- Process feature call on the "Current" object.
			-- If a feature call "after" is used in `l_as', we add the implicit target object, i.e. "Current", to the expression list.
		local
			l_feature_name: STRING
			l_feature_names: EPA_HASH_SET [STRING]
			l_expr: AFX_PROGRAM_STATE_EXPRESSION
		do
			l_feature_name := l_as.feature_name.name.as_lower
			l_feature_names := server_variables_in_scope.feature_names_from_class (written_class)
			if l_feature_names.has (l_feature_name) then
				create l_expr.make_with_text (context_class, context_feature, "Current", written_class, l_as.breakpoint_slot)
				add_expression (l_expr)
			end
		end

	save_current_nesting (a_bp_slot: INTEGER)
			-- Save a expression recognized so far.
		local
			l_list: ARRAYED_LIST[STRING]
			l_aggregate: STRING
			l_expr: AFX_PROGRAM_STATE_EXPRESSION
		do
			create l_aggregate.make_empty
			l_list := current_nested_expression_stack.linear_representation
			from
				l_list.finish
			until
				l_list.before
			loop
				l_aggregate.append (l_list.item_for_iteration)
				l_aggregate.append (".")
				l_list.back
			end

			if not l_aggregate.is_empty and then l_aggregate /~ "." then
				l_aggregate.remove_tail (1)
				create l_expr.make_with_text (context_class, context_feature, l_aggregate, written_class, a_bp_slot)
				add_expression (l_expr)
			end
		end

feature{NONE} -- Implementation

	context_class: CLASS_C
			-- Context class of `context_feature'.

	context_feature: FEATURE_I
			-- Feature from which to collect expressions.

	written_class: CLASS_C
			-- Written class of `context_feature'.
		require
			context_feature_attached: context_feature /= Void
		do
			Result := context_feature.written_class
		end

	is_within_nested: BOOLEAN
			-- Is process currently within a nested?
		require
			stack_not_empty: not nested_level_stack.is_empty
		do
			Result := current_nested_level > 0
		end

	current_nested_level: INTEGER
			-- Nested level within the expression currently under process.
		require
			stack_not_empty: not nested_level_stack.is_empty
		do
			Result := nested_level_stack.item
		end

	nested_level_stack: LINKED_STACK [INTEGER]
			-- Stack for storing nested levels within expressions.
		do
			if nested_level_stack_cache = Void then
				create nested_level_stack_cache.make
				nested_level_stack_cache.put (0)
			end

			Result := nested_level_stack_cache
		end

	nested_level_stack_cache: like nested_level_stack
			-- Cache for `nested_level_stack'.

	enter_nested
			-- Process enters another level of nested.
		require
			stack_not_empty: not nested_level_stack.is_empty
		local
			l_current_level: INTEGER
		do
			l_current_level := nested_level_stack.item
			l_current_level := l_current_level + 1

			nested_level_stack.remove
			nested_level_stack.put (l_current_level)
		ensure
			nested_level_stack_same_count: nested_level_stack.count = old nested_level_stack.count
		end

	exit_nested
			-- Process exits a level of nested.
		require
			stack_not_empty: not nested_level_stack.is_empty
		local
			l_current_level: INTEGER
		do
			l_current_level := nested_level_stack.item
			l_current_level := l_current_level - 1

			nested_level_stack.remove
			nested_level_stack.put (l_current_level)

			if l_current_level = 0 then
				-- Clear `current_nested_expression_stack'
				current_nested_expression_stack.wipe_out
			end
		ensure
			nested_level_stack_same_count: nested_level_stack.count = old nested_level_stack.count
		end

	enter_sub_expression
			-- Enter a sub-expression.
			-- A sub-expression is a standalone expression used as part of the current expression.
			-- For example, an actual argument expression, or a field of a TUPLE.
		local
			l_nested_stack: LINKED_STACK [STRING]
		do
			expression_stack.put (create {LINKED_STACK [STRING]}.make)
			nested_level_stack.put (0)
		end

	exit_sub_expression
			-- Exit a sub-expression.
		require
			expression_stack_not_empty: not expression_stack.is_empty
			nested_level_stack_not_empty: not nested_level_stack.is_empty
			not_within_nested: not is_within_nested
		do
			expression_stack.remove
			nested_level_stack.remove
		end

	current_nested_expression_stack: LINKED_STACK [STRING]
			-- Nested expression stack for processing current expression.
		require
			expression_stack_not_empty: not expression_stack.is_empty
		do
			Result := expression_stack.item
		end

	expression_stack: LINKED_STACK [LINKED_STACK [STRING]]
			-- Stack to keep track of nested expressions from different expressions.
		do
			if expression_stack_cache = Void then
				create expression_stack_cache.make
				expression_stack_cache.put (create {LINKED_STACK [STRING]}.make)
			end

			Result := expression_stack_cache
		end

	expression_stack_cache: like expression_stack
			-- Cache for `expression_stack'.

end
