note
	description: "[Utility object that rewrite unqulified accesses in an expression into their fully qualified form.]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PRECONDITION_ASSERTION_REWRITER

inherit
	ETR_AST_STRUCTURE_PRINTER
		redefine
			process_access_feat_as,
			process_current_as,
			process_eiffel_list,
			process_nested_as,
			process_nested_expr_as
		end

	EPA_UTILITY

	REFACTORING_HELPER

feature -- Result

	last_rewritten_assertion: EPA_EXPRESSION
			-- Assertion written.

feature -- Basic operation

	rewrite_precondition_assertion (a_assertion: EPA_EXPRESSION; a_operand_mapping: DS_HASH_TABLE [STRING, STRING]; a_context_class: CLASS_C; a_context_feature: FEATURE_I)
			-- Rewrite `a_assertion' as the feature is called with operands of `a_operand_mapping', in the given context.
		require
			assertion_attached: a_assertion /= Void
		local
			l_exp: EPA_AST_EXPRESSION
		do
			fixme ("Check if nested level is necessary.")
			assertion := a_assertion
			context_class := a_context_class
			context_feature := a_context_feature
			operand_mapping := a_operand_mapping

				-- Output the expression with full qualification.
			set_output(create {ETR_AST_STRING_OUTPUT}.make)
			assertion.ast.process (Current)

				-- Put result in `last_qualified_expression'.
			check attached {ETR_AST_STRING_OUTPUT} output as lt_output then
				create l_exp.make_with_text (context_class,
						context_feature, lt_output.string_representation, context_class)
				last_rewritten_assertion := l_exp
			end
		end

feature{NONE} -- Access

	context_class: CLASS_C
			-- Context class.

	context_feature: FEATURE_I
			-- Context feature.

	assertion: EPA_EXPRESSION
			-- Assertion to rewrite.

	operand_mapping: DS_HASH_TABLE [STRING, STRING]
			-- Mapping from operands of the enclosing feature to strings encoding the actual arguments.
			-- Key: argument names and "Current"
			-- Val: text of actual arguments and  the target.

--	local_names: DS_HASH_SET [STRING]
--			-- Local names that can be used in `expression'.
--		do
--			if local_names_cache = Void then
--				collect_local_names
--			end
--			Result := local_names_cache
--		ensure
--			result_attached: Result /= Void
--		end

feature{NONE} -- Status report

	is_within_nested: BOOLEAN
			-- Is process currently within a nested?
		require
			stack_not_empty: not nested_level_stack.is_empty
		do
			Result := current_nested_level > 0
		end

feature{NONE} -- Data structures for processing nested

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

feature -- Visitor routine

	process_nested_as (l_as: NESTED_AS)
			-- <Precursor>
			-- Refer to {NESTED_BL}.generate for calculating breakpoint nested indexes.
		do
			l_as.target.process (Current)
			enter_nested
			l_as.message.process (Current)
			exit_nested
		end

	process_nested_expr_as (l_as: NESTED_EXPR_AS)
			-- <Precursor>
			-- Refer to {NESTED_BL}.generate for calculating breakpoint nested indexes.
		do
			l_as.target.process (Current)
			enter_nested
			l_as.message.process (Current)
			exit_nested
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
			-- <Precursor>
		local
			l_text: STRING
			l_access_name: STRING
			l_expr: EPA_AST_EXPRESSION
		do
			l_access_name := l_as.access_name_8
			if is_within_nested then
				output.append_string ("." + l_access_name)
			else
				if operand_mapping.has (l_access_name) then
					output.append_string ("(" + operand_mapping.item (l_access_name) + ")")
				else
					output.append_string (operand_mapping.item ("Current") + ".")
					Precursor (l_as)
				end
			end
		end

	process_current_as (l_as: CURRENT_AS)
			-- <Precursor>
		do
			output.append_string (operand_mapping.item ("Current"))
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

--	collect_local_names
--			-- Collect local names that can be used in the expression into `local_names'.
--		require
--			local_names_cache_void: local_names_cache = Void
--		local
--			l_arguments: DS_HASH_TABLE [TYPE_A, STRING]
--		do
--			create local_names_cache.make (10)
--			if is_using_locals then
--				local_names_cache.append (local_names_of_feature (context_feature))
--			end
--			if is_using_arguments then
--				l_arguments := arguments_from_feature (context_feature, context_class)
--				from l_arguments.start
--				until l_arguments.after
--				loop
--					local_names_cache.force (l_arguments.key_for_iteration)
--					l_arguments.forth
--				end
--			end
--		end

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
			nested_level_stack.put (0)
		end

	exit_sub_expression
			-- Exit a sub-expression.
		require
			nested_level_stack_not_empty: not nested_level_stack.is_empty
			not_within_nested: not is_within_nested
		do
			nested_level_stack.remove
		end

feature -- Cache

--	local_names_cache: DS_HASH_SET [STRING]
--			-- Cache for `local_names'.	

	nested_level_stack_cache: like nested_level_stack
			-- Cache for `nested_level_stack'.

end
