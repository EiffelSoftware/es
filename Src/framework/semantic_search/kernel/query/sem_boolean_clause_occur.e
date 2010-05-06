note
	description: "Occurrence criterion for boolean clauses"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_BOOLEAN_CLAUSE_OCCUR

feature -- Constants

	must_occur_criterion: INTEGER is 1
			-- Criterion that requires current property MUST occur in a document for that document to be matched

	should_occur_criterion: INTEGER is 2
		-- Criterion that requires current property SHOULD occur in a document for that document to be matched

	must_not_occur_criterion: INTEGER is 3
		-- Criterion that requires current property MUST NOT occur in a document for that document to be matched

feature -- Status report

	is_occur_criterion_valid (a_criterion: INTEGER): BOOLEAN
			-- Is `a_criterion' a valid occurrence criterion?
		do
			Result :=
				a_criterion = must_occur_criterion or
				a_criterion = should_occur_criterion or
				a_criterion = must_not_occur_criterion
		end

end
