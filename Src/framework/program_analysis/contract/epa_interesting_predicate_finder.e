note
	description: "Class to find interesting predicates for a feature"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_INTERESTING_PREDICATE_FINDER

inherit
	EPA_UTILITY

	EPA_SHARED_EQUALITY_TESTERS

	EPA_CONTRACT_EXTRACTOR

	EPA_TEMPORARY_DIRECTORY_UTILITY

feature -- Access

	last_predicates: DS_HASH_SET [EPA_EXPRESSION]
			-- Predicates that are found by last `find'

feature -- Basic operations

	find (a_class: CLASS_C; a_feature: FEATURE_I)
			-- Find interesting predicates from `a_feature', viewed in `a_class'.
		local
			l_expr_finder: EPA_INTERESTING_EXPRESSION_FINDER
			l_preconditions: DS_HASH_SET [EPA_EXPRESSION]
			l_stronger_exprs: DS_HASH_SET [EPA_EXPRESSION]
		do
			context_class := a_class
			written_class := a_feature.written_class
			feature_ := a_feature

			create last_predicates.make (20)
			last_predicates.set_equality_tester (expression_equality_tester)

			create l_expr_finder
			l_expr_finder.find (a_class, a_feature)

			last_predicates.merge (predicates_from_relevant_expressions (l_expr_finder.last_relevant_expressions))
			last_predicates.merge (l_expr_finder.last_path_conditions)

			create l_preconditions.make (10)
			l_preconditions.set_equality_tester (expression_equality_tester)
			across precondition_of_feature (a_feature, a_class) as l_pres loop
				l_preconditions.force_last (l_pres.item)
			end
			l_stronger_exprs := stronger_expressions (l_preconditions)
			last_predicates.merge (l_stronger_exprs)

			last_predicates.merge (integer_argument_bound_expressions)
		end

feature{NONE} -- Implementation

	stronger_expressions (a_exprs: DS_HASH_SET [EPA_EXPRESSION]): DS_HASH_SET [EPA_EXPRESSION]
			-- Stronger expressions
			-- For example:
			-- given x >= exp, we generate: x>exp, x=exp
			-- given x <= exp, we generate: x<exp, x=exp
			-- given x >= exp1 and x <= exp2, we generate x>exp1, x=exp1, x<exp2, x=exp2
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_expr: EPA_EXPRESSION
			l_new_expr: EPA_AST_EXPRESSION
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_written_class: CLASS_C
			l_candidates: LINKED_LIST [EPA_EXPRESSION]
			l_new_exprs: LINKED_LIST [EPA_EXPRESSION]
			l_ori_expr: EPA_EXPRESSION
			l_bin_as: BINARY_AS
		do
			create Result.make (10)
			Result.set_equality_tester (expression_equality_tester)

			from
				l_cursor := a_exprs.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				create l_candidates.make
				l_ori_expr := l_cursor.item
				l_class := l_ori_expr.class_
				l_written_class := l_ori_expr.written_class
				l_feature := l_ori_expr.feature_
				l_bin_as := Void
				if attached {BIN_AND_AS} l_ori_expr.ast as l_ast then
					l_bin_as := l_ast
				elseif attached {BIN_AND_THEN_AS} l_ori_expr.ast as l_ast then
					l_bin_as := l_ast
				elseif attached {BIN_OR_AS} l_ori_expr.ast as l_ast then
					l_bin_as := l_ast
				elseif attached {BIN_OR_ELSE_AS} l_ori_expr.ast as l_ast then
					l_bin_as := l_ast
				end
				if l_bin_as /= Void then
					create l_new_expr.make_with_text (l_class, l_feature, text_from_ast (l_bin_as.left), l_written_class)
					l_candidates.extend (l_new_expr)

					create l_new_expr.make_with_text (l_class, l_feature, text_from_ast (l_bin_as.right), l_written_class)
					l_candidates.extend (l_new_expr)
				else
					l_candidates.extend (l_ori_expr)
				end

				create l_new_exprs.make
				across l_candidates as l_exprs loop
					l_expr := l_exprs.item
					l_class := l_expr.class_
					l_written_class := l_expr.written_class
					l_feature := l_expr.feature_
					if attached {BIN_GE_AS} l_expr.ast as l_ast then
							-- x >= exp
						create l_new_expr.make_with_text (l_class, l_feature, text_from_ast (l_ast.left) + " > " + text_from_ast (l_ast.right), l_written_class)
						l_new_exprs.extend (l_new_expr)
						create l_new_expr.make_with_text (l_class, l_feature, text_from_ast (l_ast.left) + " = " + text_from_ast (l_ast.right), l_written_class)
						l_new_exprs.extend (l_new_expr)
					elseif attached {BIN_LE_AS} l_expr.ast as l_ast then
							-- x <= exp
						create l_new_expr.make_with_text (l_class, l_feature, text_from_ast (l_ast.left) + " < " + text_from_ast (l_ast.right), l_written_class)
						l_new_exprs.extend (l_new_expr)
						create l_new_expr.make_with_text (l_class, l_feature, text_from_ast (l_ast.left) + " = " + text_from_ast (l_ast.right), l_written_class)
						l_new_exprs.extend (l_new_expr)
					end
				end
				across l_new_exprs as l_exprs loop
					if l_exprs.item.type /= Void then
						Result.force_last (l_exprs.item)
					end
				end

				l_cursor.forth
			end
		end

	feature_: FEATURE_I
			-- Feature under analysis

	context_class: CLASS_C
			-- Class from which `feature_' is viewed

	written_class: CLASS_C
			-- Class where `feature_' is written

feature{NONE} -- Implementation

	predicates_from_relevant_expressions (a_revelant_expressions: DS_HASH_TABLE [DS_HASH_SET [EPA_EXPRESSION], EPA_EXPRESSION]): DS_HASH_SET [EPA_EXPRESSION]
			-- Predicates that are constructed from relevant expressions in `a_relevant_expressions'
			-- Keys of `a_relevant_expressions' are expressions, values are expressions that are relevant to those
			-- key expressions.
		local
			l_processed: LINKED_LIST [DS_HASH_SET [EPA_EXPRESSION]]
			l_cursor1: DS_HASH_TABLE_CURSOR [DS_HASH_SET [EPA_EXPRESSION], EPA_EXPRESSION]
			l_cursor2: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_set: DS_HASH_SET [EPA_EXPRESSION]
			l_key: EPA_EXPRESSION
			l_expr: EPA_AST_EXPRESSION
		do
			create Result.make (20)
			Result.set_equality_tester (expression_equality_tester)

			create l_processed.make
			from
				l_cursor1 := a_revelant_expressions.new_cursor
				l_cursor1.start
			until
				l_cursor1.after
			loop
				l_key := l_cursor1.key
				from
					l_cursor2 := l_cursor1.item.new_cursor
					l_cursor2.start
				until
					l_cursor2.after
				loop
					if not expression_equality_tester.test (l_key, l_cursor2.item) then
						if not (l_key.text ~ ti_current and then l_cursor2.item.text ~ ti_void) then
							create l_set.make (2)
							l_set.set_equality_tester (expression_equality_tester)
							l_set.force_last (l_key)
							l_set.force_last (l_cursor2.item)
							if not across l_processed as l_sets some l_sets.item.is_equal (l_set) end then
								l_processed.extend (l_set)
								if l_key.type.is_integer then
									create l_expr.make_with_text (context_class, feature_, l_key.text + " > " + l_cursor2.item.text, written_class)
									if l_expr.type /= Void then
										Result.force_last (l_expr)
									end
									create l_expr.make_with_text (context_class, feature_, l_key.text + " = " + l_cursor2.item.text, written_class)
									if l_expr.type /= Void then
										Result.force_last (l_expr)
									end
									create l_expr.make_with_text (context_class, feature_, l_key.text + " < " + l_cursor2.item.text, written_class)
									if l_expr.type /= Void then
										Result.force_last (l_expr)
									end
								elseif l_key.type.is_boolean then
									create l_expr.make_with_text (context_class, feature_, l_key.text + " = " + l_cursor2.item.text, written_class)
									if l_expr.type /= Void then
										Result.force_last (l_expr)
									end
								else
									create l_expr.make_with_text (context_class, feature_, l_key.text + " = " + l_cursor2.item.text, written_class)
									if l_expr.type /= Void then
										Result.force_last (l_expr)
									end
									if l_cursor2.item.text /~ ti_void then
										create l_expr.make_with_text (context_class, feature_, l_key.text + " ~ " + l_cursor2.item.text, written_class)
										if l_expr.type /= Void then
											Result.force_last (l_expr)
										end
									end
								end
							end
						end
					end
					l_cursor2.forth
				end
				l_cursor1.forth
			end
		end

	integer_bounds (a_class: CLASS_C; a_feature: FEATURE_I; a_argument_index: INTEGER): detachable EPA_INTEGER_RANGE_DOMAIN
			-- Integer bounds for input of `a_feature' viewed from `a_class'
			-- Void if no such bounds exist
		local
			l_bound_checker: EPA_LINEAR_BOUNDED_ARGUMENT_FINDER
			l_feat_id: STRING
		do
			l_feat_id := feature_identifier (a_class, a_feature)

			create l_bound_checker.make (temporary_directory, a_class.actual_type)
			l_bound_checker.analyze_bounds (a_class, a_feature, a_argument_index)
			if l_bound_checker.is_bound_found then
				Result := integer_domain_from_bounds (l_bound_checker.minimal_values, l_bound_checker.maximal_values)
			end
		end

	feature_identifier (a_class: CLASS_C; a_feature: FEATURE_I): STRING
			-- Identifier from `a_feature' in `a_class' in form "CLASS_NAME.feature_name'
		do
			Result := a_class.name_in_upper + "." + a_feature.feature_name
		end

	integer_domain_from_bounds (a_lower_bounds: LINKED_LIST [EPA_EXPRESSION]; a_upper_bounds: LINKED_LIST [EPA_EXPRESSION]): EPA_INTEGER_RANGE_DOMAIN
			-- Integer bounds from `a_lower_bounds' and `a_upper_bounds'
		do
			create Result.make (a_lower_bounds, a_upper_bounds)
		end

	integer_argument_bound_expressions: DS_HASH_SET [EPA_EXPRESSION]
			-- Expressions to capture integer bounds, if any
		local
			l_bounds: like integer_bounds
			l_arg: STRING
			l_expr: EPA_AST_EXPRESSION
			l_arg_index: INTEGER
			l_replacements: HASH_TABLE [STRING, STRING]
			l_qualifier: EPA_EXPRESSION_QUALIFIER
			l_candidates: DS_HASH_SET [EPA_EXPRESSION]
		do
			create Result.make (10)
			Result.set_equality_tester (expression_equality_tester)
			if feature_.has_arguments then
				create l_candidates.make (10)
				l_candidates.set_equality_tester (expression_equality_tester)

				l_arg_index := 1
				across feature_.arguments as l_arguments loop
					if l_arguments.item.is_integer then
						l_bounds := integer_bounds (context_class, feature_, l_arg_index)
						if l_bounds /= Void then
							l_arg := feature_.arguments.item_name (l_arg_index).twin
							across l_bounds.lower_bounds as l_lowers loop
								create l_expr.make_with_text (context_class, feature_, l_arg + " > " + l_lowers.item.text, written_class)
								if l_expr.type /= Void then
									l_candidates.force_last (l_expr)
								end
								create l_expr.make_with_text (context_class, feature_, l_arg + " = " + l_lowers.item.text, written_class)
								if l_expr.type /= Void then
									l_candidates.force_last (l_expr)
								end
							end
							across l_bounds.upper_bounds as l_uppers loop
								create l_expr.make_with_text (context_class, feature_, l_arg + " < " + l_uppers.item.text, written_class)
								if l_expr.type /= Void then
									l_candidates.force_last (l_expr)
								end
								create l_expr.make_with_text (context_class, feature_, l_arg + " = " + l_uppers.item.text, written_class)
								if l_expr.type /= Void then
									l_candidates.force_last (l_expr)
								end
							end
						end
					end
					l_arg_index := l_arg_index + 1
				end
				if not l_candidates.is_empty then
					create l_replacements.make (1)
					l_replacements.compare_objects
					l_replacements.force (ti_current + once ".", once "")
					create l_qualifier

					from
						l_candidates.start
					until
						l_candidates.after
					loop
						l_qualifier.qualify (l_candidates.item_for_iteration, l_replacements)
						create l_expr.make_with_text (context_class, feature_, l_qualifier.last_expression, written_class)
						if l_expr.type /= Void then
							Result.force_last (l_expr)
						end
						l_candidates.forth
					end
				end
			end
		end

end
