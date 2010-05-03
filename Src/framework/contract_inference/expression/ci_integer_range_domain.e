note
	description: "Integer range domain for a function"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_INTEGER_RANGE_DOMAIN

inherit
	CI_DOMAIN
		redefine
			is_integer_range
		end

create
	make

feature{NONE} -- Initialization

	make (a_lower_bounds: like lower_bounds; a_upper_bounds: like upper_bounds)
			-- Initialize Current.
		require
			a_lower_bounds_valid: is_bound_valid (a_lower_bounds)
			a_upper_bounds_valid: is_bound_valid (a_upper_bounds)
		do
			lower_bounds := a_lower_bounds.twin
			upper_bounds := a_upper_bounds.twin
		end

feature -- Status report

	lower_bounds: LINKED_LIST [EPA_EXPRESSION]
			-- Lower bounds of current domain
			-- A range can have more than one lower bounds and more than one upper bounds.
			-- The number of the lower bounds can be different from the number of the upper bounds.
			-- The final bounds are determined by [min(lower_bounds), max(upper_bounds)].

	upper_bounds: LINKED_LIST [EPA_EXPRESSION]
			-- Upper bounds of current domain
			-- A range can have more than one lower bounds and more than one upper bounds.
			-- The number of the lower bounds can be different from the number of the upper bounds.
			-- The final bounds are determined by [min(lower_bounds), max(upper_bounds)].

feature -- Status report

	is_integer_range: BOOLEAN = True
			-- Does current represent an integer range domain?

	is_bound_valid (a_bounds: like lower_bounds): BOOLEAN
			-- Is `a_bounds' valid?
		do
			if not a_bounds.is_empty and then not a_bounds.has (Void) then
				Result := a_bounds.for_all (agent (a_expr: EPA_EXPRESSION): BOOLEAN do Result := a_expr.is_integer end)
			end
		end

end
