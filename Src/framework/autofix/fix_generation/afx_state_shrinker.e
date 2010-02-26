note
	description: "Summary description for {AFX_STATE_SHRINKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_STATE_SHRINKER

inherit
	REFACTORING_HELPER

feature -- Access

	shrinked_state (a_state: EPA_STATE; a_assertion_number: INTEGER; a_spot: AFX_EXCEPTION_SPOT): EPA_STATE
			-- A possibly shrinked state from `a_state'.
			-- When possible, the number of the expressions in the returned state should not
			-- be larger than `a_assertion_number', but this is not guaranteed.
			-- The importance level of state expressions are retrieved from `a_spot'.
		require
			a_assertion_number_not_negative: a_assertion_number >= 0
		do
			fixme ("Should remove extra expressions according to their importance ranking. 27.12.2009 Jasonw")
			Result := a_state.cloned_object
			Result.do_if (
				agent Result.remove, agent not_is_abq)
		end

feature{NONE} -- Implementation

	abq_expression_analyzer: AFX_ABQ_STRUCTURE_ANALYZER
			-- ABQ expression analyzer
		once
			create Result
		end

	not_is_abq (a_equation: EPA_EQUATION): BOOLEAN
			-- Is the expression of `a_equation' NOT an argumentless boolean query?
		do
			abq_expression_analyzer.analyze (a_equation.expression)
			Result := not abq_expression_analyzer.is_matched
		end



end
