note
	description: "Summary description for {AFX_STATE_ITEM_VALUE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EQUATION

inherit
	HASHABLE
		undefine
			out
		end

	DEBUG_OUTPUT
		redefine
			out
		end

create
	make

convert
	to_state: {AFX_STATE}

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

	expression: AFX_EXPRESSION
			-- State item whose value is stored in Current

	value: AFX_EXPRESSION_VALUE
			-- Value

	type: detachable TYPE_A
			-- Type of `value'
			-- If `has_error', return Void.
		do
			if not has_error then
				Result := value.type
			end
		end

	as_predicate: AFX_EXPRESSION
			-- Current as an expression in the form of
			-- "expression = value"
		local
			l_gen: AFX_EQUATION_TO_EXPRESSION_GENERATOR
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

feature -- Status report

	out, debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			create Result.make (64)
			Result.append (expression.text)
			Result.append (once " : ")
			Result.append (value.out)
		end

feature -- Conversion

	to_state: AFX_STATE
			-- State representation for Current.
			-- The returned state only contains Current as the only predicate.
		do
			create Result.make (1, class_, feature_)
			Result.force_last (Current)
		end

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
