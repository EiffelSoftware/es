note
	description: "[
			Class to generate path conditions at feature entry point.
			NOTE: This class use heuristics to calculate path conditions,
			it only works on very simple cases, and may results in unsound
			conditions. Use this class with caution. 5.12.2010. Jason
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_SIMPLE_PATH_CONDITION_GENERATOR

inherit
	EPA_SHARED_EQUALITY_TESTERS

	EPA_UTILITY

	REFACTORING_HELPER

feature -- Access

	path_conditions: DS_HASH_SET [EPA_EXPRESSION]
			-- Path conditions resulting from last `generate'

feature -- Basic operations

	generate (a_class: CLASS_C; a_feature: FEATURE_I)
			-- Generate path condition for `a_feature' in
			-- context class `a_class'. Make results available
			-- in `path_condition'.
		local
			l_condition_collector: EPA_FEATURE_CONDITION_COLLECTOR
			l_source_context: ETR_FEATURE_CONTEXT
			l_target_context: ETR_FEATURE_CONTEXT
			l_new_set: like path_conditions
			l_expr: EPA_AST_EXPRESSION
		do
			context_feature := a_feature
			context_class := a_class
			written_class := a_feature.written_class
			locals := local_names_of_feature (a_feature)

			create path_conditions.make (10)
			path_conditions.set_equality_tester (expression_equality_tester)

			create l_condition_collector
			l_condition_collector.collect (a_class, a_feature)

			l_condition_collector.assignments.do_all_with_key (agent process_path_condition)

			if not path_conditions.is_empty then
				create l_source_context.make (a_feature, create {ETR_CLASS_CONTEXT}.make (written_class))
				create l_target_context.make (a_feature, create {ETR_CLASS_CONTEXT}.make (context_class))
				create l_new_set.make (path_conditions.count)
				l_new_set.set_equality_tester (expression_equality_tester)
				from
					path_conditions.start
				until
					path_conditions.after
				loop
					if attached {EXPR_AS} ast_in_other_context (path_conditions.item_for_iteration.ast, l_source_context, l_target_context) as l_ast then
						create l_expr.make_with_feature (context_class, context_feature, l_ast, context_class)
						l_new_set.force_last (l_expr)
					end
					path_conditions.forth
				end
				path_conditions := l_new_set
			end
		end

feature{NONE} -- Implemenation

	context_feature: FEATURE_I
			-- Context feature

	context_class: CLASS_C
			-- Context class

	written_class: CLASS_C
			-- Written class for `context_feature'

	locals: DS_HASH_SET [STRING]
			-- Locals in `context_feature'

	local_definitions: HASH_TABLE [LINKED_LIST [EXPR_AS], STRING]
			-- Definitions of local variables
			-- Keys are local variable names, values are its definitions.
			-- Since a local variables may be defined multiple times, the definitions
			-- are stored in a list.

feature{NONE} -- Implementation

	calculate_local_definitions (a_locals: DS_HASH_SET [STRING]; a_assignments: LINKED_LIST [ASSIGN_AS])
			-- Calculate `local_definitions' for `a_locals' and `a_assignments'.
		local
			l_target_name: STRING
			l_definitions: LINKED_LIST [EXPR_AS]
		do
			create local_definitions.make (10)
			local_definitions.compare_objects
			across a_assignments as l_assignments loop
				l_target_name := text_from_ast (l_assignments.item.target)
				if a_locals.has (l_target_name) then
					if local_definitions.has (l_target_name) then
						l_definitions := local_definitions.item (l_target_name)
					else
						create l_definitions.make
						local_definitions.force (l_definitions, l_target_name)
					end
					l_definitions.extend (l_assignments.item.source)
				end
			end
		end

	process_path_condition (a_assignments: LINKED_LIST [ASSIGN_AS]; a_condition: EPA_EXPRESSION)
			-- Process `a_condition' with `a_assignments'.
			-- Try to replace all local variables (if any) in `a_condition' with the definitions of those
			-- local variables.
			-- If succeeded, put result into `path_conditions', otherwie, ignore `a_condition'.
		local
			l_should_continue: BOOLEAN
			l_local_collector: EPA_MENTIONED_LOCAL_COLLECTOR
			l_done: BOOLEAN
			l_count: INTEGER
			l_exprs: like expression_with_local_replaced_with_definitions
			l_condition: EPA_AST_EXPRESSION
			l_data: TUPLE [expr: EPA_EXPRESSION; has_changed: BOOLEAN]
		do
			l_should_continue := True

			if a_condition.text.has_substring (once "attached") then
				fixme ("We don't handle object tests for the moment. 5.12.2010. Jason")
				l_should_continue := False
			end

			if a_condition.text.has_substring (once "{") then
				fixme ("We don't static access for the moment. Also this is an unsafe way to check appearance of static asccess. 5.12.2010. Jason")
				l_should_continue := False
			end

			if l_should_continue then
				calculate_local_definitions (locals, a_assignments)
				create l_condition.make_with_text (a_condition.class_, a_condition.feature_, a_condition.text, a_condition.written_class)
				from
					l_count := 1
				until
					l_done or else l_count > 3
				loop
					l_exprs := expression_with_local_replaced_with_definitions (l_condition, locals, local_definitions)
					if not l_exprs.is_empty then
						l_data := l_exprs.first
						l_done := not l_data.has_changed
						l_condition ?= l_data.expr
					end
					l_count := l_count + 1
				end

				if not is_any_local_mentioned (l_condition, locals) then
					path_conditions.force_last (l_condition)
				end
			end
		end

	expression_with_local_replaced_with_definitions (a_expression: EPA_EXPRESSION; a_all_locals: DS_HASH_SET [STRING]; a_local_definitions: like local_definitions): LINKED_LIST [TUPLE [expresion: EPA_EXPRESSION; has_changed: BOOLEAN]]
			-- Expressions froms `a_expression' with local references replaced with local definitions'.
			-- There can be multiple solutions after replacement.
			-- NOTE: only do one step replacement, call expression_with_local_replaced_with_definitions multiple times until results do not change anymore.
			-- `a_all_locals' are names of all declared locals.
		local
			l_mentioned_locals: DS_HASH_SET [STRING]
			l_mentioned_local_collector: EPA_MENTIONED_LOCAL_COLLECTOR
			l_original_text: STRING
			l_new_text: STRING
			l_cursor: DS_HASH_SET_CURSOR [STRING]
			l_local: STRING
			l_rewriter: like expression_rewriter
			l_replacements: HASH_TABLE [STRING, STRING]
			l_new_expr: EPA_AST_EXPRESSION
		do
			create Result.make

			create l_mentioned_local_collector
			l_mentioned_local_collector.collect (a_expression.ast, a_all_locals)
			l_mentioned_locals := l_mentioned_local_collector.mentioned_locals
			if l_mentioned_locals.is_empty then
				Result.extend ([a_expression, False])
			else
				l_rewriter := expression_rewriter
					-- For each local and each its definition, calculate a new expression.
				l_original_text := a_expression.text.twin
				create l_replacements.make (l_mentioned_locals.count)
				from
					l_cursor := l_mentioned_locals.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					l_local := l_cursor.item
					if a_local_definitions.has (l_local) then
						fixme ("We only take the first definition of a local variable. 5.12.2010 Jasonw")
						l_replacements.force ("(" + text_from_ast (a_local_definitions.item (l_local).first) + ")", l_local)
					end
					l_cursor.forth
				end
				l_new_text := l_rewriter.ast_text (a_expression.ast, l_replacements)
				create l_new_expr.make_with_text (a_expression.class_, a_expression.feature_, l_new_text, a_expression.written_class)
				if not l_new_expr.has_syntax_error and then not l_new_expr.has_type_error and then l_new_expr.type /= Void then
					Result.extend ([l_new_expr, l_new_text /~ l_original_text])
				end
			end
		end

	is_any_local_mentioned (a_expression: EPA_EXPRESSION; a_locals: DS_HASH_SET [STRING]): BOOLEAN
			-- Is any local variables in `a_locals' mentioned in `a_expression'?
		local
			l_mentioned_local_collector: EPA_MENTIONED_LOCAL_COLLECTOR
		do
			create l_mentioned_local_collector
			l_mentioned_local_collector.collect (a_expression.ast, a_locals)
			Result := not l_mentioned_local_collector.mentioned_locals.is_empty
		end

end
