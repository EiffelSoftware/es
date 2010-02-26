note
	description: "Summary description for {AFX_ABQ_STRUCTURE_ANALYZER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_ABQ_STRUCTURE_ANALYZER

inherit
	AFX_EXPRESSION_STRUCTURE_ANALYZER

	REFACTORING_HELPER

feature -- Basic operations

	analyze (a_expression: like expression)
			-- Analyze the structure of `a_expression', set `is_matched' to True if
			-- the structure of `a_expression' matches:
			-- prefix.ABQ
			-- where ABQ is the set of argumentless boolean queries, possibly with negations),
			-- and prefix is a path expression.
			-- For example: "a.foo (b, c).is_empty" will be matched if "a.foo (b, c)" is a path expression
			-- and `is_empty' is an argumentless boolean query.
			-- "not a.foo (b, c).is_empty" will be matched too.
		local
			l_final_query: detachable ACCESS_FEAT_AS
			l_class: CLASS_C
			l_written_class: CLASS_C
			l_feature: FEATURE_I
		do
			expression := a_expression
			ast := expression.ast

			is_matched := False

				-- Only match expression of type BOOLEAN.
			if a_expression.is_predicate then
				analyze_paranthesis_and_negation
				if attached {NESTED_AS} ast as l_nested then
						-- `expression' is in the form of "prefix.ABQ".						
					create {EPA_AST_EXPRESSION} prefix_expression.make_with_text (
						expression.class_,
						expression.feature_,
						text_from_ast (l_nested.target),
						expression.written_class)

					if attached {ACCESS_FEAT_AS} l_nested.message as l_access then
						l_final_query := l_access
					end
				elseif attached {ACCESS_FEAT_AS} ast as l_access then
						-- `expression' is in the form of "ABQ".
					prefix_expression := Void
					l_final_query := l_access
				elseif attached {NESTED_EXPR_AS} ast as l_nested_expr then
					fixme("Not supported for the moment. 8.12.2009 Jasonw")
				end

					-- Analyze if the final query is argumentless.
				if l_final_query /= Void then
					if attached l_final_query.parameters as l_par then
						is_matched := l_par.count = 0
					else
						is_matched := True
					end
					if is_matched then
						if attached prefix_expression as l_prefix then
							l_class := l_prefix.type.actual_type.associated_class
							l_feature := l_class.feature_named (l_final_query.access_name)
							l_written_class := l_class
						else
							l_class := expression.class_
							l_feature := expression.feature_
							l_written_class := expression.written_class
						end
						fixme ("The following line, when used make instead of make_with_type, will crash on ARRAYED_CIRCULAR.merge_left. 8.12.2009 Jasonw.")
						create {EPA_AST_EXPRESSION} argumentless_boolean_query.make_with_type (l_class, l_feature, create {EXPR_CALL_AS}.initialize (l_final_query), l_written_class, expression.type)
					end
				end
			end
		end

feature -- Access

	negation_count: INTEGER
			-- Number of outer negations of `expression'
			-- Only has effect if `is_matched' is True.

	prefix_expression: detachable EPA_EXPRESSION
			-- The prefix part of `expression' if in the form "prefix.ABQ"
			-- Void if there is not prefix.
			-- Only has effect if `is_matched' is True.

	argumentless_boolean_query: detachable EPA_EXPRESSION
			-- The final argumentless boolean query in `expression'			
			-- Only has effect if `is_matched' is True.

feature{NONE} -- Implementation

	expression: EPA_EXPRESSION
			-- Expression that is being analyzed

	ast: AST_EIFFEL
			-- AST node that are currently analyzed.

	analyze_paranthesis_and_negation
			-- Analyze outer paranthesis and negations of `expression'.
		local
			l_ast: AST_EIFFEL
			l_done: BOOLEAN
		do
			negation_count := 0
			from
				l_ast := expression.ast
			until
				l_done
			loop
				if attached {PARAN_AS} l_ast as l_paran then
					l_ast := l_paran.expr
				elseif attached {UN_NOT_AS} l_ast as l_not then
					l_ast := l_not.expr
					negation_count := negation_count + 1
				else
					l_done := True
				end
			end
			if attached {EXPR_CALL_AS} l_ast as l_expr_call then
				l_ast := l_expr_call.call
			end
			ast := l_ast
		end

feature -- Visitor

	process (a_visitor: AFX_EXPRESSION_STRUCTURE_ANALYZER_VISITOR)
			-- Process Current with `a_visitor'.
		do
			a_visitor.process_abq_structure_analyzer (Current)
		end


end
