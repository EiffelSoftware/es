note
	description: "Occurrence criterion for boolean clauses"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_BOOLEAN_CLAUSE_OCCUR

feature -- Constants

	must_occur_criterion_string: STRING = "MUST"
	must_occur_criterion: INTEGER = 1
			-- Criterion that requires current property MUST occur in a document for that document to be matched

	should_occur_criterion_string: STRING = "SHOULD"
	should_occur_criterion: INTEGER = 2
		-- Criterion that requires current property SHOULD occur in a document for that document to be matched

	must_not_occur_criterion_string: STRING = "MUST_NOT"
	must_not_occur_criterion: INTEGER = 3
		-- Criterion that requires current property MUST NOT occur in a document for that document to be matched

feature -- Conversion

	criterion_as_string (a_occur_criterion: INTEGER): STRING
			-- `a_occur_criterion' as string
		require
			occur_criterion_valid: is_occur_criterion_valid (a_occur_criterion)
		do
			if a_occur_criterion = must_occur_criterion then
				Result := must_occur_criterion_string
			elseif a_occur_criterion = should_occur_criterion then
				Result := should_occur_criterion_string
			elseif a_occur_criterion = must_not_occur_criterion then
				Result := must_not_occur_criterion_string
			end
		end

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
