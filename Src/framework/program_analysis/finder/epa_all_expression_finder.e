note
	description: "Summary description for {EPA_ALL_EXPRESSION_FINDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_ALL_EXPRESSION_FINDER

inherit
	EPA_EXPRESSION_FINDER

	REFACTORING_HELPER

	AST_ITERATOR
	redefine
		process_access_feat_as, process_access_id_as, process_access_inv_as, process_binary_as, process_parameter_list_as, process_nested_as
	end

	EPA_ARGUMENTLESS_PRIMITIVE_FEATURE_FINDER

	EPA_UTILITY


create
	make


feature{NONE} -- Initialization

	make (a_context_class: like context_class)
			-- Initialze Current.
		do
			create nesting_stacks.make
			context_class := a_context_class
		end


feature -- Access

	context_class: CLASS_C

feature{EPA_ALL_EXPRESSION_FINDER}

	current_feature: FEATURE_I
	is_nesting: BOOLEAN
	nesting_stacks: LINKED_STACK[LINKED_STACK[STRING]]

	current_stack: LINKED_STACK[STRING]
		-- returns the current stack where we keep nesting expressions
	local
		l_stack: LINKED_STACK[STRING]
	do
		if nesting_stacks.is_empty then
			create l_stack.make
			nesting_stacks.put (l_stack)
		end
		Result := nesting_stacks.item
	end

feature{EPA_ALL_EXPRESSION_FINDER}

	handle_nesting
	do
		is_nesting := True
	end

	handle_end_nesting
	do
		is_nesting := False
		save_current_nesting
		current_stack.remove
		if current_stack.count = 1 then
			current_stack.wipe_out
		end
	end

	handle_parameters
	local
		l_stack: LINKED_STACK[STRING]
	do
		create l_stack.make
		nesting_stacks.put (l_stack)
	end

	handle_end_parameters
	do
		nesting_stacks.remove
	end

	save_current_nesting
	local
			l_list: ARRAYED_LIST[STRING]
			l_aggregate: STRING
			l_expr: EPA_AST_EXPRESSION
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
			create l_expr.make_with_text (context_class, current_feature, l_aggregate, context_class)
			last_found_expressions.put (l_expr)
		end
	end

feature --  Basic operations

	process_binary_as (l_as: BINARY_AS)
		local
			l_expr: EPA_AST_EXPRESSION
			l_ot_checker: EPA_OBJECT_TEST_CHECKER
		do
			create l_ot_checker
			l_as.process (l_ot_checker)
			if not l_ot_checker.object_test_found then
				create l_expr.make_with_text (context_class, current_feature, text_from_ast (l_as), context_class)
				last_found_expressions.put (l_expr)
			end
			precursor(l_as)
		end

	process_nested_as (l_as: NESTED_AS)
		do
			handle_nesting
			precursor(l_as)
			handle_end_nesting
		end
	process_parameter_list_as (l_as: PARAMETER_LIST_AS)
		local
			l_list: EIFFEL_LIST [EXPR_AS]
		do
			handle_parameters
			precursor(l_as)
			handle_end_parameters
		end


	process_access_id_as (l_as: ACCESS_ID_AS)
		do
			precursor(l_as)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		local
			l_expr: EPA_AST_EXPRESSION
		do
			if is_nesting then
				current_stack.put (text_from_ast (l_as))
			else
				create l_expr.make_with_text (context_class, current_feature, text_from_ast (l_as), context_class)
				if not l_expr.has_syntax_error and then not l_expr.has_type_error then
					last_found_expressions.put (l_expr)
				end
			end
			precursor(l_as)
		end

feature --invariants

	process_access_inv_as (l_as: ACCESS_INV_AS)
		local
			l_expr: EPA_AST_EXPRESSION
		do
			precursor(l_as)
		end

feature -- inherited

	search (a_expression_repository: EPA_HASH_SET [EPA_EXPRESSION])
			-- <Precursor>
		local
			l_features: LIST [FEATURE_I]
			l_expr: EPA_AST_EXPRESSION
			l_feat: FEATURE_I
			l_cursor: CURSOR
			l_ast: AST_EIFFEL
			l_written_class: CLASS_C
		do
				-- Create empty `last_found_expressions'.
			create last_found_expressions.make (200)
			last_found_expressions.set_equality_tester (expression_equality_tester)

				-- Go through the ASTs of all features in `context_class',
				-- searching for similar expressions.
			l_features := features_in_class (context_class, Void)
			l_cursor := l_features.cursor
			from
				l_features.start
			until
				l_features.after
			loop
				current_feature := l_features.item_for_iteration
				l_written_class := current_feature.written_class
				l_ast := current_feature.e_feature.ast
				l_ast := ast_in_context_class (l_ast, l_written_class, current_feature, context_class)
				l_ast.process (Current)
				l_features.forth
			end
			l_features.go_to (l_cursor)


			--------------------------------------------
--			current_feature := context_class.feature_named ("put_left")
--			l_written_class := current_feature.written_class
--			l_ast := current_feature.e_feature.ast
--			l_ast := ast_in_context_class (l_ast, l_written_class, current_feature, context_class)
--			l_ast.process (Current)

		end


	ast_in_context_class (a_ast: AST_EIFFEL; a_written_class: CLASS_C; a_written_feature: detachable FEATURE_I; a_context_class: CLASS_C): AST_EIFFEL
           -- AST representing `a_ast', which comes from `a_written_feature' in `a_written_class'.
           -- The resulting AST is viewed from `a_context_class' and with all renaming resolved.
           -- `a_written_class' and `a_context_class' should be in the same inheritance hierarchy.
       local
           l_source_context: ETR_CONTEXT
           l_target_context: ETR_CONTEXT
           l_feat_context: ETR_FEATURE_CONTEXT
           l_class_context: ETR_CLASS_CONTEXT
           l_feat: FEATURE_I
           l_transformable: ETR_TRANSFORMABLE
       do
           if a_written_class /= Void then
                   -- Calculate source context.
               create l_class_context.make (a_written_class)
               create l_feat_context.make (a_written_feature, l_class_context)
               l_source_context := l_feat_context

                   -- Calculate target context.
               l_feat := a_context_class.feature_of_rout_id_set (a_written_feature.rout_id_set)
               create l_class_context.make (a_context_class)
               create l_feat_context.make (l_feat, l_class_context)
               l_target_context := l_feat_context
           else
                   -- Calculate source context.
               create l_class_context.make (a_written_class)
               l_source_context := l_class_context

                   -- Calculate target context.
               create l_class_context.make (a_context_class)
               l_target_context := l_class_context
           end

           create l_transformable.make (a_ast, l_source_context, True)
           Result := l_transformable.as_in_other_context (l_target_context).to_ast
       end


end
