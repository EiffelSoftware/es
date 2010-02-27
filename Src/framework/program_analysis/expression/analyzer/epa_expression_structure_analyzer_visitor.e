note
	description: "Summary description for {AFX_EXPRESSION_STRUCTURE_ANALYZER_VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_EXPRESSION_STRUCTURE_ANALYZER_VISITOR

feature -- Access

	process_abq_structure_analyzer (a_analyzer: EPA_ABQ_STRUCTURE_ANALYZER)
			-- Process `a_analyzer'.
		deferred
		end

	process_abq_implication_structure_analyzer (a_analyzer: EPA_ABQ_IMPLICATION_STRUCTURE_ANALYZER)
			-- Process `a_analyzer'.
		deferred
		end

	process_linear_constrained_structure_analyzer (a_analyzer: EPA_LINEAR_CONSTRAINED_EXPRESSION_STRUCTURE_ANALYZER)
			-- Process `a_analyzer'.
		deferred
		end

	process_any_structure_analyzer (a_analyzer: EPA_ANY_STRUCTURE_ANALYZER)
			-- Process `a_analyzer'.
		deferred
		end

end
