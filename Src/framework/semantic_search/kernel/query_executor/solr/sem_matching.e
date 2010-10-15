note
	description: "Class that represents a binding from a search criterion in a query to the set of possible solutions from a document"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_MATCHING

inherit
	COMPARABLE

create
	make

feature{NONE} -- Initialization

	make (a_searched_criterion: like searched_criterion; a_candidates: like candidate_criteria)
			-- Initialize Current.
		do
			searched_criterion := a_searched_criterion
			candidate_criteria := a_candidates
		ensure
			searched_criterion_set: searched_criterion = a_searched_criterion
			candidate_criteria_set: candidate_criteria = a_candidates
		end

feature -- Access

	searched_criterion: SEM_MATCHING_CRITERION
			-- Criterion that is used in searching
			-- This is a criterion specified in the original query.

	candidate_criteria: detachable LINKED_LIST [SEM_MATCHING_CRITERION]
			-- Criteria returned as result of a query which may match `searched_criterion'
			-- Void if there is no candidates for `searched_criterion'
			-- A candidate criterion is a fact stored in a document, this fact may match what
			-- is asked for through `searched_criterion'.

	candidate_criteria_count: INTEGER
			-- Number of candidates in `candidate_criteria'
			-- If `candidate_criteria' is Void, return the max integer value
		do
			if candidate_criteria = Void then
				Result := {INTEGER}.max_value
			else
				Result := candidate_criteria.count
			end
		end

feature -- Status report

	has_candidate: BOOLEAN
			-- Is there any candidates in `candidate_criteria'?
		do
			Result := candidate_criteria /= Void
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			Result := candidate_criteria_count < other.candidate_criteria_count
		end

end
