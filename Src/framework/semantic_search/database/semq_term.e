note
	description: "Class that represents a term in SQL-implementation of the semantic search system"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEMQ_TERM

inherit
	HASHABLE

	EPA_UTILITY

	SHARED_TYPES

	DEBUG_OUTPUT

	SEM_CONSTANTS

feature -- Access

	queryable: SEM_QUERYABLE
			-- Queryable whose property Current term is describing

	entity: EXPR_AS
			-- Entity inside Current term
			-- This can be an expression described a searched criterion (in this case,
			-- the expression must evaluates to boolean type); or an expression describing
			-- the information to return.
		deferred
		end

	type: TYPE_A
			-- Type of `entity'
		deferred
		end

	text: STRING
			-- Text representation of Current term
		deferred
		end

	occurrence: INTEGER
			-- Occurrence flag for this term
			-- Check `is_valid_occurrence' for valid values.
			-- Default: `term_occurrence_must'

	boost: DOUBLE
			-- Boost value of for this term
			-- Default: `default_boost_value'		

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := text
		end

feature -- Status report

	is_searched: BOOLEAN
			-- Does Current term specify some searched criterion of
			-- the containing query?
			-- If a term is used to constrain the result, for example,
			-- "l.has (a) = True", then `is_searched' is True.

	is_required: BOOLEAN
			-- Should the value of the entity specified in Current term
			-- be returned in the result.
			-- For some of the entities, we don't want to search them, but we want to have
			-- their values in the result set, `is_required' is devise for this purpose.
			-- For example, We want to search for a list which is not empty by specifying
			-- "not l.is_empty", and we also want to return the length of that list,
			-- we can provide a term for "l.count", whose `is_searched' is False,
			-- and whose `is_required' is True.

feature -- Status report

	is_contract: BOOLEAN
			-- Is Current a contract term?
		do
			Result := is_precondition or is_postcondition
		end

	is_precondition: BOOLEAN
			-- Is Current a precondition term?
		do
		end

	is_postcondition: BOOLEAN
			-- Is Current a postcondition term?
		do
		end

	is_human_written: BOOLEAN
			-- Is Current a contract term and that contract is human-written?
		do
		end

	is_property: BOOLEAN
			-- Is Current a property term (for objects)?
		do
		end

	is_variable: BOOLEAN
			-- Is Current a variable term?
		do
		end

	is_meta: BOOLEAN
			-- Is Current a meta term?
		do
		end

feature -- Setting

	set_is_searched (b: BOOLEAN)
			-- Set `is_searched' with `b'.
		do
			is_searched := b
		ensure
			is_searched_set: is_searched = b
		end

	set_is_required (b: BOOLEAN)
			-- Set `is_required' with `b'.
		do
			is_required := b
		ensure
			is_required_set: is_required = b
		end

	set_occurrence (a_occurrence: INTEGER)
			-- Set `occurrence' with `a_occurrence'.
		require
			a_occurrence_valid: is_term_occurrence_valid (a_occurrence)
		do
			occurrence := a_occurrence
		ensure
			occurrence_set: occurrence = a_occurrence
		end

	set_boost (a_boost: DOUBLE)
			-- Set `boost' with `a_boost'.
		do
			boost := a_boost
		ensure
			boost_set: boost = a_boost
		end

feature -- Process

	process (a_visitor: SEMQ_TERM_VISITOR)
			-- Visit Current using `a_visitor'.
		deferred
		end

invariant
	queryable_attached: queryable /= Void

end
