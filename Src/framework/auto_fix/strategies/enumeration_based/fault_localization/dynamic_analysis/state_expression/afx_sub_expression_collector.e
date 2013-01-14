note
	description: "Object to collect sub-expressions, in the context of a given feature from a class."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SUB_EXPRESSION_COLLECTOR

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
			process_nested_as,
			process_nested_expr_as,
			process_integer_as
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

feature -- Access

	last_sub_expressions: EPA_HASH_SET [EPA_EXPRESSION]
			-- Set of sub- expressions from last collecting.
		do
			if last_sub_expressions_cache = Void then
				create last_sub_expressions_cache.make_equal (20)
			end

			Result := last_sub_expressions_cache
		end

feature -- Basic operation

	collect_from_feature (a_feature_with_context: EPA_FEATURE_WITH_CONTEXT_CLASS)
			-- Collect all sub-expressions of 'a_feature_with_context' into `last_sub_expressions'.
			-- If a local variable is never used inside the feature,
			-- it will not be collected since it always has the default value.
			-- However, all arguments would be collected.
		local
			l_written_body: INTERNAL_AS
			l_ast: AST_EIFFEL
		do
			reset_collector

			l_ast := body_ast_from_feature (a_feature_with_context.feature_)
			if attached {DO_AS} l_ast as lvt_do then
				l_ast := lvt_do.compound
			end
			l_ast := ast_in_context_class (l_ast, a_feature_with_context.written_class, a_feature_with_context.written_feature, a_feature_with_context.context_class)

			collect_from_ast (a_feature_with_context, l_ast)
		end

	collect_from_expression_text (a_feature_with_context: EPA_FEATURE_WITH_CONTEXT_CLASS; a_expr_text: STRING)
			-- Collect all sub-expressions of `a_expr_text', in the context of `a_feature_with_context'.
			-- `a_expr_text' should be valid in `a_feature_with_context', in terms of renaming.
		require
			text_written_in_context: True
		do
			reset_collector

			collect_from_ast (a_feature_with_context, ast_from_expression_text (a_expr_text))
		end

	collect_from_ast (a_feature_with_context: EPA_FEATURE_WITH_CONTEXT_CLASS; a_ast: AST_EIFFEL)
			-- Collect all sub-expressions of `a_ast', in the context of `a_feature'.
			-- `a_ast' should be valid in `a_feature_with_context', in terms of renaming.
			--
			-- Note: only CLASS_AS, FEATURE_AS, INSTRUCTION_AS, EIFFEL_LIST [INSTRUCTION_AS], EXPR_AS, TYPE_AS
		require
			ast_in_context: True
		do
			reset_collector

			context_feature := a_feature_with_context
			a_ast.process (Current)
			collect_local_entities
		end

feature -- Status report

	should_collect_local_variables: BOOLEAN
			-- Should we collect local variables?

	should_collect_arguments: BOOLEAN
			-- Should we collect arguments?

	should_collect_current: BOOLEAN
			-- Should we collect `Current'?

	should_collect_result: BOOLEAN
			-- Should we collect result?

feature -- Status set

	set_should_collect_local_variables (a_flag: BOOLEAN)
			-- Set `should_collect_local_variables'.
		do
			should_collect_local_variables := a_flag
		end

	set_should_collect_arguments (a_flag: BOOLEAN)
			-- Set `should_collect_arguments'.
		do
			should_collect_arguments := a_flag
		end

	set_should_collect_current (a_flag: BOOLEAN)
			-- Set `should_collect_current'.
		do
			should_collect_current := a_flag
		end

	set_should_collect_result (a_flag: BOOLEAN)
			-- Set `should_collect_result'.
		do
			should_collect_result := a_flag
		end

feature{NONE} -- Implementation

	context_feature: EPA_FEATURE_WITH_CONTEXT_CLASS
			-- Context feature where the collecting happens.

	written_class: CLASS_C
			-- Written class of `context_feature'.
		require
			context_feature_attached: context_feature /= Void
		do
			Result := context_feature.written_class
		end

feature{NONE} -- Auxiliary

	reset_collector
			-- Reset the state of the collector.
		do
			last_sub_expressions_cache := Void
			expression_stack_cache := Void
			nested_level_stack_cache := Void
		end

	collect_local_entities
			-- Collect local entities, like variables, arguments, Current, and Result.
		local
		    l_feature: FEATURE_I
		    l_class: CLASS_C
		    l_name: STRING
			l_expr: EPA_AST_EXPRESSION
			l_indx, l_count: INTEGER
		do
		    l_feature := context_feature.feature_

		    	-- Arguments.
			if should_collect_arguments then
			    from
			    	l_indx := 1
			    	l_count := l_feature.argument_count
			    until
			    	l_indx > l_count
			    loop
			    	l_name := l_feature.arguments.item_name (l_indx)

					add_expression_from_text (l_name)

			    	l_indx := l_indx + 1
			    end
			end

				-- "Current".
			if should_collect_current then
				add_expression_from_text ("Current")
			end

				-- "Result" if applicable.
			if should_collect_result and then l_feature.type /= Void and then l_feature.type /= Void_type then
				add_expression_from_text ("Result")
			end
		end

	add_expression_from_text (a_text: STRING)
			-- Add the expression from `a_text'.
		local
			l_expr: EPA_AST_EXPRESSION
			l_retried: BOOLEAN
		do
			if not l_retried then
				create l_expr.make_with_text (context_feature.context_class, context_feature.feature_, a_text, context_feature.written_class)
				if not l_expr.has_syntax_error and then not l_expr.has_type_error and then l_expr.type /= Void and then not l_expr.type.is_void then
					last_sub_expressions.force (l_expr)
				end
			end
		rescue
			l_retried := True
			retry
		end

	add_expression_from_ast (a_ast: AST_EIFFEL)
			-- Add an expression from `a_ast'.
		local
			l_expr: EPA_AST_EXPRESSION
		do
			if attached {EXPR_AS} a_ast as lt_expr then
				create l_expr.make_with_feature (context_feature.context_class, context_feature.feature_, lt_expr, context_feature.written_class)
				if not l_expr.has_syntax_error and then not l_expr.has_type_error and then l_expr.type /= Void and then not l_expr.type.is_void then
					last_sub_expressions.force (l_expr)
				end
			end
		end

feature --  Visitor routine

	process_binary_as (l_as: BINARY_AS)
			-- <Precursor>
		local
			l_expr: EPA_AST_EXPRESSION
		do
			precursor(l_as)

			add_expression_from_ast (l_as)
		end

	process_unary_as (l_as: UNARY_AS)
			-- <Precursor>
		local
			l_expr: EPA_AST_EXPRESSION
		do
			precursor(l_as)

			add_expression_from_ast (l_as)
		end

	process_nested_expr_as (l_as: NESTED_EXPR_AS)
			-- <Precursor>
		do
			enter_nested
			precursor(l_as)
			exit_nested
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
			process_feature_call_on_current (l_as)
		end

	process_integer_as (l_as: INTEGER_AS)
			-- <Precursor>
		do
			process_access (l_as)
		end

	process_access_assert_as (l_as: ACCESS_ASSERT_AS)
			-- <Precursor>
		do
			precursor(l_as)
			process_feature_call_on_current (l_as)
		end

	process_access_inv_as (l_as: ACCESS_INV_AS)
			-- <Precursor>
		do
			precursor(l_as)
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
			l_expr: EPA_AST_EXPRESSION
		do
			l_text := text_from_ast (l_as)
			if is_within_nested then
					-- Save prefix expression processed so far.
				current_nested_expression_stack.put (l_text)
				save_current_nesting (l_as.breakpoint_slot)
			else
					-- Save standalone expression.
				add_expression_from_ast (l_as)
			end
		end

	process_feature_call_on_current (l_as: ACCESS_FEAT_AS)
			-- Process feature call on the "Current" object.
			-- If a feature call "after" is used in `l_as', we add the implicit target object, i.e. "Current", to the expression list.
		local
			l_feature_name: STRING
			l_feature_names: EPA_STRING_HASH_SET
			l_expr: EPA_AST_EXPRESSION
		do
			l_feature_name := l_as.feature_name.name.as_lower
			l_feature_names := server_variables_in_scope.feature_names_from_class (written_class)
			if l_feature_names.has (l_feature_name) then
				add_expression_from_text ("Current")
			end
		end

	save_current_nesting (a_bp_slot: INTEGER)
			-- Save a expression recognized so far.
		local
			l_list: ARRAYED_LIST[STRING]
			l_aggregate: STRING
			l_expr: EPA_AST_EXPRESSION
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
				add_expression_from_text (l_aggregate)
			end
		end

feature{NONE} -- Process nested/sub expressions: access

	nested_level_stack: LINKED_STACK [INTEGER]
			-- Stack for storing nested levels within expressions.
		do
			if nested_level_stack_cache = Void then
				create nested_level_stack_cache.make
				nested_level_stack_cache.put (0)
			end

			Result := nested_level_stack_cache
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

	current_nested_level: INTEGER
			-- Nested level within the expression currently under process.
		require
			stack_not_empty: not nested_level_stack.is_empty
		do
			Result := nested_level_stack.item
		end

	is_within_nested: BOOLEAN
			-- Is process currently within a nested?
		require
			stack_not_empty: not nested_level_stack.is_empty
		do
			Result := current_nested_level > 0
		end

feature{NONE} -- Process nested/sub expressions: operation

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

feature{NONE} -- Cache

	last_sub_expressions_cache: like last_sub_expressions
			-- Cache for `last_collection_in_written_class'.

	expression_stack_cache: like expression_stack
			-- Cache for `expression_stack'.

	nested_level_stack_cache: like nested_level_stack
			-- Cache for `nested_level_stack'.

end
