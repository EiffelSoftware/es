note
	description: "Summary description for {AFX_STATE_PARTITIONER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_STATE_PARTITIONER

inherit
	AFX_UTILITY

	REFACTORING_HELPER

feature -- Access

	partitions_by_expression_prefix (a_state: AFX_STATE): HASH_TABLE [AFX_STATE, STRING]
			-- A table of subsets from `a_state', partitioned by path prefix of expressions in `a_state'
		local
			l_cursor: DS_HASH_SET_CURSOR [AFX_EQUATION]
			l_state: AFX_STATE
			l_analyzer: AFX_ABQ_STRUCTURE_ANALYZER
			l_prefix: STRING
			l_expression: AFX_EXPRESSION
			l_equation: AFX_EQUATION
		do
			create Result.make (10)
			Result.compare_objects
			create l_analyzer
			from
				l_cursor := a_state.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_analyzer.analyze (l_cursor.item.expression)
				check l_analyzer.is_matched end
				if attached {AFX_EXPRESSION} l_analyzer.prefix_expression as l_pre then
					l_prefix := l_pre.text.twin
					l_expression := l_analyzer.argumentless_boolean_query
				else
					l_prefix := ""
					l_expression := l_cursor.item.expression
				end
				if Result.has (l_prefix) then
					l_state := Result.item (l_prefix)
				else
					create l_state.make (10, l_expression.class_, l_expression.feature_)
					Result.put (l_state, l_prefix)
				end
				create l_equation.make (l_expression, l_cursor.item.value)
				l_state.force_last (l_equation)
				l_cursor.forth
			end
		end

	partitions_by_premise (a_state: AFX_STATE): HASH_TABLE [AFX_STATE, AFX_EXPRESSION]
			-- A table of subsets from `a_state', partitioned by premises in `a_state'.
			-- Predicates without premises are treated with premise "True".
		local
			l_imp_analyzer: AFX_ABQ_IMPLICATION_STRUCTURE_ANALYZER
			l_cursor: DS_HASH_SET_CURSOR [AFX_EQUATION]
			l_true_expr: AFX_AST_EXPRESSION
			l_consequent: AFX_EXPRESSION
			l_premise: AFX_EXPRESSION
			l_found: BOOLEAN
			l_value: AFX_EXPRESSION_VALUE
			l_equation: AFX_EQUATION
			l_state: AFX_STATE
		do
			create Result.make (5)
			Result.compare_objects
			create l_true_expr.make_with_text (a_state.class_, a_state.feature_, "True", a_state.class_)
			create l_imp_analyzer
			from
				l_cursor := a_state.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_found := False
				l_imp_analyzer.analyze (l_cursor.item.expression)
				if l_imp_analyzer.is_matched then
					if attached {AFX_BOOLEAN_VALUE} l_cursor.item.value as l_bool then
						if l_bool.item then
							l_premise := l_imp_analyzer.premise
							l_consequent := l_imp_analyzer.consequent
							l_value := l_cursor.item.value
							l_found := True
						else
							fixme ("We ignore False implication for the moment. 17.12.2009 Jasonw")
						end
					else
						check should_not_happen: False end
					end
				else
					l_premise := l_true_expr
					l_consequent := l_cursor.item.expression
					l_value := l_cursor.item.value
					l_found := True
				end
				if l_found then
					create l_equation.make (l_consequent, l_value)
					if Result.has (l_premise) then
						l_state	:= Result.item (l_premise)
					else
						create l_state.make (10, a_state.class_, a_state.feature_)
						Result.put (l_state, l_premise)
					end
					l_state.force_last (equation_in_normal_form (l_equation))
				end
				l_cursor.forth
			end
		end

end
