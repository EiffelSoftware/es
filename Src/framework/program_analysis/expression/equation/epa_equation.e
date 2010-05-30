note
	description: "Summary description for {AFX_STATE_ITEM_VALUE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EQUATION

inherit
	HASHABLE
		undefine
			out
		end

	DEBUG_OUTPUT
		redefine
			out
		end

	EPA_CONSTANTS
		undefine
			out
		end

create
	make

feature{NONE} -- Initialization

	make (a_expr: like expression; a_value: like value)
			-- Initialize Current.
		do
			set_state_item (a_expr)
			set_value (a_value)
		ensure
			state_item_set: expression = a_expr
			value_set: value = a_value
		end

feature -- Access

	expression: EPA_EXPRESSION
			-- State item whose value is stored in Current

	value: EPA_EXPRESSION_VALUE
			-- Value

	type: detachable TYPE_A
			-- Type of `value'
			-- If `has_error', return Void.
		do
			if not has_error then
				Result := value.type
			end
		end

	as_predicate: EPA_EXPRESSION
			-- Current as an expression in the form of
			-- "expression = value"
		local
			l_gen: EPA_EQUATION_TO_EXPRESSION_GENERATOR
		do
			create l_gen
			l_gen.generate (Current)
			Result := l_gen.last_expression
		ensure
			result_is_predicate: Result.is_predicate
		end

	class_: CLASS_C
			-- Context class for `expression'
		do
			Result := expression.class_
		ensure
			good_result: Result = expression.class_
		end

	feature_: detachable FEATURE_I
			-- Context feature for `expression'
		do
			Result := expression.feature_
		ensure
			good_result: Result = expression.feature_
		end

	equation_with_value_negated: like Current
			-- A new equation with the value part being negated.
			-- For example "is_empty = True" becomes "is_empty = False".
		require
			expression_is_predicate: expression.is_predicate
		local
			l_new_value: EPA_BOOLEAN_VALUE
		do
			if attached {EPA_BOOLEAN_VALUE} value as l_bool then
				create l_new_value.make (not l_bool.item)
				create Result.make (expression, l_new_value)
			end
		end

	equation_with_expression_negated: like Current
			-- A new equation with the expression part being negated.
			-- For example "is_empty = True" becomes "not (is_empty) = True".
		require
			expression_is_predicate: expression.is_predicate
		do
			if attached {EPA_BOOLEAN_VALUE} value as l_bool then
				create Result.make (not expression, l_bool)
			end
		end

feature -- Status report

	out, debug_output, text: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			create Result.make (64)
			Result.append (expression.text)
			Result.append (equation_separator)
			Result.append (value.out)
		end

feature -- Conversion

--	to_normal_form: like Current
--			-- Turn current into normal form
--		require
--			expression_is_predicate: expression.is_predicate
--		do
--			Result := equation_in_normal_form (Current)
--		end

feature -- Status report

	has_error: BOOLEAN
			-- Was there an error when `expression' was evaluated?
			-- If True, `value' is not defined.
		do

		end

feature -- Hash code

	hash_code: INTEGER
			-- Hash code value
		do
			Result := expression.hash_code
		ensure then
			good_result: Result = expression.hash_code
		end

feature -- Setting

	set_state_item (a_state: like expression)
			-- Set `expression' with `a_state'.
		do
			expression := a_state
		ensure
			state_item_set: expression = a_state
		end

	set_value (a_value: like value)
			-- Set `value' with `a_value'.
		do
			value := a_value
		ensure
			value_set: value = a_value
		end

end
