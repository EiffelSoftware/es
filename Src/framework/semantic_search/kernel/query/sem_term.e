note
	description: "Class that represents a searchable term"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_TERM

inherit
	SEM_CONSTANTS

feature -- Access

	occurrence: INTEGER
			-- Occurrence flag for this term
			-- Check `is_valid_occurrence' for valid values.
			-- Default: `term_occurrence_should'

	boost: DOUBLE
			-- Boost value of for this term
			-- Default: `default_boost_value'

	queryable: SEM_QUERYABLE
			-- Queryable where current term is from

feature -- Status report

	is_contract: BOOLEAN
			-- Is current a contract term?
		do
		end

	is_precondition: BOOLEAN
			-- Is current a precondition term?
		do
		end

	is_postcondition: BOOLEAN
			-- Is current a postcondition term?
		do
		end

	is_human_written: BOOLEAN
			-- Is current a contract term and that contract is human-written?
		do
		end

	is_change: BOOLEAN
			-- Is current a term for a change?
		do
		end

	is_property: BOOLEAN
			-- Is current a property term (for objects)?
		do
		end

	is_variable: BOOLEAN
			-- Is current a variable term?
		do
		end

feature{NONE} -- Implementation

	initialize
			-- Initialize.
		do
			occurrence := term_occurrence_should
			boost := default_boost_value
		end

invariant
	occurrence_valid: is_term_occurrence_valid (occurrence)

end
