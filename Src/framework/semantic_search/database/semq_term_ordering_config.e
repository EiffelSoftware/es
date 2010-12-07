note
	description: "Class to specify the ordering for a term"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_TERM_ORDERING_CONFIG

inherit
	IR_CONSTANTS

create
	make_by_value,
	make_by_boost

feature{NONE} -- Initialization

	make_by_value (a_priority: INTEGER; a_ascending: BOOLEAN)
			-- Initialize `criterion' with `by_value'.
		do
			priority := a_priority
			criterion := by_value
			is_ascending := a_ascending
			set_boost (default_boost_value)
		ensure
			priority_set: priority = a_priority
			criterion_set: criterion = by_value
			is_ascending_set: is_ascending = a_ascending
		end

	make_by_boost (a_priority: INTEGER; a_ascending: BOOLEAN)
			-- Initialize `criterion' with `by_boost'.
		do
			priority := a_priority
			criterion := by_boost
			is_ascending := a_ascending
			set_boost (default_boost_value)
		ensure
			priority_set: priority = a_priority
			criterion_set: criterion = by_boost
			is_ascending_set: is_ascending = a_ascending
		end

feature -- Access

	priority: INTEGER
			-- 1-based Priority indicating if the associated term should be orderred first
			-- 1 means the associated should be ordered first, 2 means the second, and so on.

	criterion: INTEGER
			-- Criterion for ordering
			-- See `by_value' and `by_boost' for valid values

	boost: DOUBLE
			-- Boost value of the associated term
			-- Default: 1.0			

feature -- Status report

	is_ascending: BOOLEAN
			-- Should ordering be ascending?

feature -- Setting

	set_boost (a_boost: DOUBLE)
			-- Set `boost' with `a_boost'.
		do
			boost := a_boost
		ensure
			boost_set: boost = a_boost
		end

feature -- Constants

	by_value: INTEGER = 1
			-- Order a term by its value

	by_boost: INTEGER = 2
			-- Order a term by its boost
			-- NOTE: If `criterion' is set to `by_boost', you have to make sure
			-- that the associated term has a boost value. That is: the associated
			-- term must be a single-path expression.

invariant
	prioprity_positive: priority > 0
	criterion_valid: criterion = by_value or criterion = by_boost
end
