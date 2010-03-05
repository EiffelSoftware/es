note
	description: "Objects that represents integer ranges"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_INTEGER_RANGE

inherit
	EPA_EXPRESSION_CHANGE_VALUE_SET
		rename
			make as make_set
		redefine
			is_integer_range,
			is_valid
		end

create
	make,
	make_with_upper_bound,
	make_with_lower_bound

feature{NONE} -- Initialization

	make (a_context_class: CLASS_C; a_lower: INTEGER; a_upper: INTEGER; a_lower_included: BOOLEAN; a_upper_included: BOOLEAN)
			-- Initialize Current.
		local
			l_lower: EPA_AST_EXPRESSION
			l_upper: EPA_AST_EXPRESSION
		do
			lower := a_lower
			upper := a_upper

			is_lower_included := a_lower_included
			is_upper_included := a_upper_included

			create l_lower.make_with_text (a_context_class, Void, a_lower.out, a_context_class)
			create l_upper.make_with_text (a_context_class, Void, a_upper.out, a_context_class)
			make_set (2)
			set_equality_tester (expression_equality_tester)
		end

	make_with_upper_bound (a_context_class: CLASS_C; a_upper: INTEGER; a_upper_included: BOOLEAN)
			-- Initialize Current to [-Infinity, `a_upper'] if `a_upper_included' is True, and
			-- initialize current to [-Infinity, `a_upper') if `a_upper_included' is False.
		do
			make (a_context_class, negative_infinity, a_upper, True, a_upper_included)
		end

	make_with_lower_bound (a_context_class: CLASS_C; a_lower: INTEGER; a_lower_included: BOOLEAN)
			-- Initialize Current to [`a_lower', +Infinity] if `a_lower_included' is True, and
			-- initialize current to (`a_lower', +Infinity] if `a_lower_included' is False.
		do
			make (a_context_class, a_lower, positive_infinity, a_lower_included, True)
		end

feature -- Access

	lower: INTEGER
			-- Lower bound of Current range
			-- {INTEGER}.`min_value' represents -Infinity.

	upper: INTEGER
			-- Upper bound of Current range
			-- {INTEGER}.`max_value' represents +Infinity.

feature -- Constants

	negative_infinity: INTEGER
			-- Negative infinity
		do
			Result := {INTEGER}.min_value
		end

	positive_infinity: INTEGER
			-- Positive infinity
		do
			Result := {INTEGER}.max_value
		end

feature -- Status report

	is_lower_included: BOOLEAN
			-- Is `lower' included in Current range?

	is_upper_included: BOOLEAN
			-- Is `upper' included in Current range?

	is_integer_range: BOOLEAN = True
			-- Does Current represent an integer range?

	is_valid: BOOLEAN
			-- Is Current value set valid?
		do
			Result :=
				count = 2 and then
				first.is_integer and then
				last.is_integer and then
				first.is_integer_constant and then
				last.is_integer_constant
		end

end
