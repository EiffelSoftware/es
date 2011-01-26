note
	description: "Class to find interesting expressions for a feature"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_INTERESTING_EXPRESSION_FINDER

inherit
	EPA_UTILITY

	EPA_SHARED_EQUALITY_TESTERS

feature -- Access

	last_relevant_expressions: DS_HASH_TABLE [DS_HASH_SET [EPA_EXPRESSION], EPA_EXPRESSION]
			-- Relevant expressions found by last `find'
			-- Keys are target and arguments of a feature call,
			-- values are expressions that are relevant to those operands.
			-- These relevant expressions may come from callees of the analyzed feature.

	last_path_conditions: DS_HASH_SET [EPA_EXPRESSION]
			-- Path conditions that are found by last `find'
			-- These path conditions may come from callees of the analyzed feature.

feature -- Basic operations

	find (a_class: CLASS_C; a_feature: FEATURE_I)
			-- Find interesting expressions from `a_feature' viewed in `a_class'.
		local
			l_callees: like callees
			l_cursor: DS_HASH_TABLE_CURSOR [DS_HASH_SET [EPA_EXPRESSION], EPA_EXPRESSION]
		do
			create last_relevant_expressions.make (10)
			last_relevant_expressions.set_key_equality_tester (expression_equality_tester)
			create last_path_conditions.make (10)
			if not (a_feature.is_constant or a_feature.is_attribute or a_feature.is_deferred or a_feature.is_external) then
				feature_ := a_feature
				context_class := a_class
				written_class := a_feature.written_class
				create feature_context.make (feature_, create{ETR_CLASS_CONTEXT}.make (context_class))
				local_table := feature_context.local_by_name
				if local_table = Void then
					create local_table.make (0)
					local_table.compare_objects
				end
				arguments := arguments_of_feature (feature_)

					-- Find expressions that are relevant to operands of `feature_'.				
				relevant_expressions (context_class, feature_).do_all_with_key (agent last_relevant_expressions.force_last)

					-- Find path conditions from `feature_'
				last_path_conditions.merge (path_conditions (context_class, feature_))

					-- Find callees, for each callee, find relevant expressions and path conditions.
				l_callees := callees (context_class, feature_)
				from
					l_callees.start
				until
					l_callees.after
				loop
					from
						l_cursor := relevant_expressions_from_callee (l_callees.item.feature_name, l_callees.item.operands).new_cursor
						l_cursor.start
					until
						l_cursor.after
					loop
						last_relevant_expressions.search (l_cursor.key)
						if last_relevant_expressions.found then
							last_relevant_expressions.found_item.merge (l_cursor.item)
						else
							last_relevant_expressions.force_last (l_cursor.item, l_cursor.key)
						end
						l_cursor.forth
					end

					last_path_conditions.merge (path_conditions_from_callee (l_callees.item.feature_name, l_callees.item.operands))
					l_callees.forth
				end
			end
		end

feature{NONE} -- Implementation

	path_conditions_from_callee (a_callee_feature_name: STRING; a_operands: HASH_TABLE [STRING, INTEGER]): like last_path_conditions
			-- Expressions that are relevant to operands of `feature_' viewed from `context_class'
		local
			l_target_name: STRING
			l_expr: EPA_AST_EXPRESSION
			l_callee_class: CLASS_C
			l_callee_feature: FEATURE_I
			l_path_conditions: like last_path_conditions
			l_callee_operands: like arguments_of_feature
			l_replacements: HASH_TABLE [STRING, STRING]
			l_rewriter: like expression_rewriter
			l_key: EPA_EXPRESSION
			l_set: DS_HASH_SET [EPA_EXPRESSION]
			l_text: STRING
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
		do
			create Result.make (10)
			Result.set_equality_tester (expression_equality_tester)

			l_target_name := a_operands.item (0)
			create l_expr.make_with_text (context_class, feature_, l_target_name, written_class)
			if l_expr.type /= Void and then l_expr.type.associated_class /= Void then
				l_callee_class := l_expr.type.associated_class
				l_callee_feature := l_callee_class.feature_named (a_callee_feature_name)
				if l_callee_feature /= Void then
					if not (l_callee_feature.is_attribute or else l_callee_feature.is_constant or else l_callee_feature.is_external) then

						l_path_conditions := path_conditions (l_callee_class, l_callee_feature)
						l_callee_operands := arguments_of_feature (l_callee_feature)
						l_callee_operands.force_last (0, ti_current)
						create l_replacements.make (l_callee_operands.count)
						from
							l_callee_operands.start
						until
							l_callee_operands.after
						loop
							l_replacements.force (a_operands.item (l_callee_operands.item_for_iteration), l_callee_operands.key_for_iteration)
							l_callee_operands.forth
						end

						l_rewriter := expression_rewriter
						from
							l_cursor := l_path_conditions.new_cursor
							l_cursor.start
						until
							l_cursor.after
						loop
							l_text := l_rewriter.expression_text (l_cursor.item, l_replacements)
							create l_expr.make_with_text (context_class, feature_, l_text, written_class)
							if l_expr.type /= Void then
								Result.force_last (l_expr)
							end
							l_cursor.forth
						end
					end
				end
			end
		end

	relevant_expressions_from_callee (a_callee_feature_name: STRING; a_operands: HASH_TABLE [STRING, INTEGER]): like last_relevant_expressions
			-- Expressions that are relevant to operands of `feature_' viewed from `context_class'
		local
			l_target_name: STRING
			l_expr: EPA_AST_EXPRESSION
			l_callee_class: CLASS_C
			l_callee_feature: FEATURE_I
			l_rev_exprs: like relevant_expressions
			l_callee_operands: like arguments_of_feature
			l_replacements: HASH_TABLE [STRING, STRING]
			l_rewriter: like expression_rewriter
			l_key: EPA_EXPRESSION
			l_set: DS_HASH_SET [EPA_EXPRESSION]
			l_text: STRING
			l_cursor1: DS_HASH_TABLE_CURSOR [DS_HASH_SET [EPA_EXPRESSION], EPA_EXPRESSION]
			l_cursor2: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
		do
			create Result.make (10)
			Result.set_key_equality_tester (expression_equality_tester)

			l_target_name := a_operands.item (0)
			create l_expr.make_with_text (context_class, feature_, l_target_name, written_class)
			if l_expr.type /= Void and then l_expr.type.associated_class /= Void then
				l_callee_class := l_expr.type.associated_class
				l_callee_feature := l_callee_class.feature_named (a_callee_feature_name)
				if l_callee_feature /= Void then
					if not (l_callee_feature.is_attribute or else l_callee_feature.is_constant or else l_callee_feature.is_external) then
						l_rev_exprs := relevant_expressions (l_callee_class, l_callee_feature)
						l_callee_operands := arguments_of_feature (l_callee_feature)
						l_callee_operands.force_last (0, ti_current)
						create l_replacements.make (l_callee_operands.count)
						from
							l_callee_operands.start
						until
							l_callee_operands.after
						loop
							l_replacements.force (a_operands.item (l_callee_operands.item_for_iteration), l_callee_operands.key_for_iteration)
							l_callee_operands.forth
						end

						l_rewriter := expression_rewriter
						from
							l_cursor1 := l_rev_exprs.new_cursor
							l_cursor1.start
						until
							l_cursor1.after
						loop
							l_key := l_cursor1.key
							create l_set.make (l_cursor1.item.count)
							l_set.set_equality_tester (expression_equality_tester)
							from
								l_cursor2 := l_cursor1.item.new_cursor
								l_cursor2.start
							until
								l_cursor2.after
							loop
								l_text := l_rewriter.expression_text (l_cursor2.item, l_replacements)
								create l_expr.make_with_text (context_class, feature_, l_text, written_class)
								if l_expr.type /= Void then
									l_set.force_last (l_expr)
								end
								l_cursor2.forth
							end
							l_text := l_rewriter.expression_text (l_key, l_replacements)
							create l_expr.make_with_text (context_class, feature_, l_text, written_class)
							if l_expr.type /= Void then
								Result.force_last (l_set, l_expr)
							end
							l_cursor1.forth
						end
					end
				end
			end
		end

	rewritten_relevant_expressions (a_exprs: like last_relevant_expressions; a_replacements: HASH_TABLE [STRING, STRING]): like last_relevant_expressions
			-- Expressions that are rewritten taking `a_replacements' into consideration
		local
			l_cursor1: DS_HASH_TABLE_CURSOR [DS_HASH_SET [EPA_EXPRESSION], EPA_EXPRESSION]
			l_cursor2: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_set: DS_HASH_SET [EPA_EXPRESSION]
			l_rewriter: like expression_rewriter
			l_key: EPA_EXPRESSION
			l_expr: EPA_AST_EXPRESSION
			l_text: STRING
		do
			create Result.make (10)
			Result.set_key_equality_tester (expression_equality_tester)

			l_rewriter := expression_rewriter
			from
				l_cursor1 := a_exprs.new_cursor
				l_cursor1.start
			until
				l_cursor1.after
			loop
				create l_set.make (l_cursor1.item.count)
				l_set.set_equality_tester (expression_equality_tester)
				from
					l_cursor2 := l_cursor1.item.new_cursor
					l_cursor2.start
				until
					l_cursor2.after
				loop
					l_text := l_rewriter.expression_text (l_cursor2.item, a_replacements)
					create l_expr.make_with_text (context_class, feature_, l_text, written_class)
					l_set.force_last (l_expr)
					l_cursor2.forth
				end
				l_key := l_cursor1.key
				l_text := l_rewriter.expression_text (l_key, a_replacements)
				create l_expr.make_with_text (context_class, feature_, l_text, written_class)
				Result.force_last (l_set, l_expr)
				l_cursor1.forth
			end
		end

	relevant_expressions (a_class: CLASS_C; a_feature: FEATURE_I): like last_relevant_expressions
			-- Expressions that are relevant to operands of `a_feature' viewed from `a_class'
		local
			l_finder: EPA_EXPRESSION_RELATION
			l_qualifier: EPA_EXPRESSION_QUALIFIER
			l_cursor: DS_HASH_TABLE_CURSOR [DS_HASH_SET [EPA_EXPRESSION], EPA_EXPRESSION]
			l_cursor2: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_set: DS_HASH_SET [EPA_EXPRESSION]
			l_key: EPA_EXPRESSION
			l_replacements: HASH_TABLE [STRING, STRING]
			l_expr: EPA_AST_EXPRESSION
			l_written_class: CLASS_C
		do
			l_written_class := a_feature.written_class
			create l_replacements.make (1)
			l_replacements.compare_objects
			l_replacements.force (ti_current + once ".", once "")
			create Result.make (10)
			Result.set_key_equality_tester (expression_equality_tester)

			create l_finder
			create l_qualifier
			from
				l_cursor := l_finder.relevant_expressions_for_operands (a_class, a_feature, True).new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_key := l_cursor.key
				create l_set.make (l_cursor.item.count)
				l_set.set_equality_tester (expression_equality_tester)
				from
					l_cursor2 := l_cursor.item.new_cursor
					l_cursor2.start
				until
					l_cursor2.after
				loop
					l_qualifier.process_expression (l_cursor2.item, l_replacements)
					if not l_qualifier.is_local_detected then
						create l_expr.make_with_text (a_class, a_feature, l_qualifier.last_expression, l_written_class)
						if l_expr.type /= Void then
							l_set.force_last (l_expr)
						end
					end
					l_cursor2.forth
				end
				l_qualifier.process_expression (l_key, l_replacements)
				create l_expr.make_with_text (a_class, a_feature, l_qualifier.last_expression, l_written_class)
				if l_expr /= Void then
					Result.force_last (l_set, l_expr)
				end
				l_cursor.forth
			end

			create l_qualifier

		end

	callees (a_class: CLASS_C; a_feature: FEATURE_I): LINKED_LIST [TUPLE [feature_name: STRING; operands: HASH_TABLE [STRING, INTEGER]]]
			-- Callees of `a_feature', viewed from `a_class'
		local
			l_finder: EPA_FEATURE_CALL_FINDER
		do
			create l_finder
			l_finder.find (a_class, a_feature)
			Result := l_finder.last_calls
		end

	path_conditions (a_class: CLASS_C; a_feature: FEATURE_I): DS_HASH_SET [EPA_EXPRESSION]
			-- Path conditions from `a_feature', viewed in `a_class'
		local
			l_finder: EPA_SIMPLE_PATH_CONDITION_GENERATOR
			l_qualifier: EPA_EXPRESSION_QUALIFIER
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_expr: EPA_AST_EXPRESSION
			l_written_class: CLASS_C
			l_replacements: HASH_TABLE [STRING, STRING]
		do
			l_written_class := a_feature.written_class
			create l_finder
			l_finder.generate (a_class, a_feature)

			create Result.make (l_finder.path_conditions.count)
			Result.set_equality_tester (expression_equality_tester)
			create l_qualifier

			create l_replacements.make (1)
			l_replacements.force (ti_current + once ".", once "")
			from
				l_cursor := l_finder.path_conditions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_qualifier.process_expression (l_cursor.item, l_replacements)
				if not l_qualifier.is_local_detected then
					create l_expr.make_with_text (a_class, a_feature, l_qualifier.last_expression, l_written_class)
					if l_expr.type /= Void then
						Result.force_last (l_expr)
					end
				end
				l_cursor.forth
			end
		end

feature{NONE} -- Implementation

	feature_: FEATURE_I
			-- Feature being processed

	context_class: CLASS_C
			-- Class where `feature_' is viewed

	written_class: CLASS_C
			-- Class where `feature_' is written

	calls: HASH_TABLE [AST_EIFFEL, STRING]
			-- Feature calls that have been collected
			-- Keys are string representation for ASTs.
			-- Values are the actual AST nodes

	feature_context: ETR_FEATURE_CONTEXT
			-- Featue context

	local_table: HASH_TABLE [ETR_TYPED_VAR, STRING]
			-- Table for locals
			-- Keys are local names, values are types of those locals

	arguments: like arguments_of_feature
			-- Table for arguments of `feature_'
			-- Keys are argument names, values are 1-based argument index.



end
