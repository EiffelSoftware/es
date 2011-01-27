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

feature -- Access

	last_predicates: DS_HASH_SET [EPA_EXPRESSION]
			-- Predicates that are found by last `find'

feature -- Basic operations

	find (a_class: CLASS_C; a_feature: FEATURE_I)
			-- Find interesting predicates from `a_feature', viewed in `a_class'.
		local
			l_expr_finder: EPA_INTERESTING_EXPRESSION_FINDER
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
		end

feature{NONE} -- Implementation

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

end
