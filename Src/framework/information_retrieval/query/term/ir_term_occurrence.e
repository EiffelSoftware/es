note
	description: "Term occurrences"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IR_TERM_OCCURRENCE

feature -- Term occurrences

	term_occurrence_must: INTEGER = 1
			-- Flag to indicate that a term must occur in a result document

	term_occurrence_must_not: INTEGER = 2
			-- Flag to indicate that a term must not occur in a result document

	term_occurrence_should: INTEGER = 3
			-- Flag to indicate that a term should occur in a result document

feature -- Term occurrence names

	term_occurrence_must_name: STRING = "MUST"
			-- Name of `term_occurrence_must'

	term_occurrence_must_not_name: STRING = "MUST_NOT"
			-- Name of `term_occurrence_must_not'

	term_occurrence_should_name: STRING = "SHOULD"
			-- Name of `term_occurrence_should'

	term_occurrence_name (a_occurrence: INTEGER): STRING
			-- Name of term occurrence `a_occurrence'
		require
			a_occurrence_valid: is_term_occurrence_valid (a_occurrence)
		do
			if a_occurrence = term_occurrence_must then
				Result := term_occurrence_must_name
			elseif a_occurrence = term_occurrence_must_not then
				Result := term_occurrence_must_not_name
			elseif a_occurrence = term_occurrence_should then
				Result := term_occurrence_should_name
			end
		end

feature -- Status report

	is_term_occurrence_valid (a_occurrence: INTEGER): BOOLEAN
			-- Is `a_occurrence' valid?
		do
			Result :=
				a_occurrence = term_occurrence_must or else
				a_occurrence = term_occurrence_must_not or else
				a_occurrence = term_occurrence_should
		end

end
