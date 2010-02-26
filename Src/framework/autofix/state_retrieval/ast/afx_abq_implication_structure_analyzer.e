note
	description: "Summary description for {AFX_ABQ_IMPLICATION_STRUCTURE_ANALYZER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_ABQ_IMPLICATION_STRUCTURE_ANALYZER

inherit
	AFX_EXPRESSION_STRUCTURE_ANALYZER

feature -- Basic operations

	analyze (a_expression: EPA_EXPRESSION)
			-- Analyze the structure of `a_expression', set `is_matched' to True if
			-- the structure of `a_expression' matches current analyzer.
			-- Here is a list of possible structure of `a_expression':
			-- ABQ -> ABQ (ABQ is the set of argumentless boolean queries, possibly with negations)
		local
			l_abq_analyzer: AFX_ABQ_STRUCTURE_ANALYZER
			l_left: EPA_AST_EXPRESSION
			l_right: EPA_AST_EXPRESSION
			l_class: CLASS_C
			l_written_class: CLASS_C
			l_feature: FEATURE_I
			l_type: TYPE_A
		do
			premise_negation_count := 0
			consequent_negation_count := 0
			is_matched := False

			if a_expression.is_predicate and then attached {BIN_IMPLIES_AS} a_expression.ast as l_implies then
				l_type := a_expression.type
				l_class := a_expression.class_
				l_feature := a_expression.feature_
				l_written_class := a_expression.written_class
				create l_left.make_with_type (l_class, l_feature, l_implies.left, l_written_class, l_type)
				create l_right.make_with_type (l_class, l_feature, l_implies.right, l_written_class, l_type)
				premise := l_left
				consequent := l_right

					-- Analyze premise part of the implication.
				create l_abq_analyzer
				l_abq_analyzer.analyze (l_left)
				is_matched := l_abq_analyzer.is_matched
				if is_matched then
					premise_negation_count := l_abq_analyzer.negation_count
					premise_prefix_expression := l_abq_analyzer.prefix_expression
					premise_argumentless_boolean_query := l_abq_analyzer.argumentless_boolean_query

						-- Analyze consequent part of the implication.
					create l_abq_analyzer
					l_abq_analyzer.analyze (l_right)
					is_matched := l_abq_analyzer.is_matched
					if is_matched then
						consequent_negation_count := l_abq_analyzer.negation_count
						consequent_prefix_expression := l_abq_analyzer.prefix_expression
						consequent_argumentless_boolean_query := l_abq_analyzer.argumentless_boolean_query
					end
				end
			end
		end

feature -- Access

	premise_negation_count: INTEGER
			-- Number of outer negations of the premise part of the analyzed expression
			-- Only has effect if `is_matched' is True.

	premise_prefix_expression: detachable EPA_EXPRESSION
			-- The prefix part of the premise part of the analyzed expression if in the form "prefix.ABQ"
			-- Void if there is not prefix.
			-- Only has effect if `is_matched' is True.

	premise_argumentless_boolean_query: detachable EPA_EXPRESSION
			-- The final argumentless boolean query in the premise part of the analyzed expression			
			-- Only has effect if `is_matched' is True.

	premise: detachable EPA_EXPRESSION
			-- Premise expression
			-- Only has effect if `is_matched' is True.

	consequent_negation_count: INTEGER
			-- Number of outer negations of the consequent part of the analyzed expression
			-- Only has effect if `is_matched' is True.

	consequent_prefix_expression: detachable EPA_EXPRESSION
			-- The prefix part of the consequent part of the analyzed expression if in the form "prefix.ABQ"
			-- Void if there is not prefix.
			-- Only has effect if `is_matched' is True.

	consequent_argumentless_boolean_query: detachable EPA_EXPRESSION
			-- The final argumentless boolean query in the consequent part of the analyzed expression			
			-- Only has effect if `is_matched' is True.

	consequent: detachable EPA_EXPRESSION
			-- Consequent
			-- Only has effect if `is_matched' is True.

feature -- Visitor

	process (a_visitor: AFX_EXPRESSION_STRUCTURE_ANALYZER_VISITOR)
			-- Process Current with `a_visitor'.
		do
			a_visitor.process_abq_implication_structure_analyzer (Current)
		end

end
