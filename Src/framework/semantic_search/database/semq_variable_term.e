note
	description: "Class that represents a variable position term"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_VARIABLE_TERM

inherit
	SEMQ_TERM
		redefine
			is_variable
		end

create
	make,
	make_with_position,
	make_as_target,
	make_as_argument,
	make_as_some_argument,
	make_as_operand

feature{NONE} -- Initialization

	make (a_variable: like variable; a_queryable: like queryable)
			-- Initialize `variable' with `a_variable' and
			-- `queryable' with `a_queryable'.
		do
			variable := a_variable
			queryable := a_queryable
			hash_code := variable.hash_code
		end

	make_with_position (a_variable: like variable;  a_position: like position; a_queryable: like queryable)
			-- Initialize `variable' with `a_variable', `position' with `a_position' and
			-- `queryable' with `a_queryable'.
		do
			make (a_variable, a_queryable)
			position := a_position
		end

	make_as_target (a_variable: like variable; a_queryable: SEM_FEATURE_CALL_TRANSITION)
			-- Initialize Current with `a_variable', which is supposed to be the target
			-- operand of a transition.
		do
			create position.make_as_target
			make (a_variable, a_queryable)
		end

	make_as_argument (a_variable: like variable; a_arg_position: INTEGER; a_queryable: SEM_FEATURE_CALL_TRANSITION)
			-- Initialize Current with `a_variable', and `a_variable' is supposed to be the `a_arg_position'-th
			-- argument of a transition.
		require
			a_arg_position_positive: a_arg_position > 0
		do
			create position.make_as_argument (a_arg_position)
			make (a_variable, a_queryable)
		end

	make_as_some_argument (a_variable: like variable; a_queryable: SEM_FEATURE_CALL_TRANSITION)
			-- Initialize Current with `a_variable', and `a_variable' is supposed to be an
			-- argument of a transition, that is to say, the exact position of the argument is unspecified.
		do
			create position.make_as_unspecified_argument
			make (a_variable, a_queryable)
		end

	make_as_operand (a_variable: like variable; a_queryable: SEM_FEATURE_CALL_TRANSITION)
			-- Initialize Current with `a_variable', and `a_variable' is supposed to be an operand of a transition.
			-- That is to say, the variable can be either the target or an argument.
		do
			create position.make_as_unspecified_operand
			make (a_variable, a_queryable)
		end

feature -- Access

	variable: EPA_EXPRESSION
			-- Variable wrapped in Current term

	position: detachable SEM_TRANSITION_VARIABLE_POSITION
			-- Position requirement of `variable'
			-- Only have effect in a transition.
			-- If Void, there is no constrain over the position of `variable'

	entity: EXPR_AS
			-- Entity inside Current term
			-- This can be an expression described a searched criterion (in this case,
			-- the expression must evaluates to boolean type); or an expression describing
			-- the information to return.
		do
			Result := variable.ast
		end

	type: TYPE_A
			-- Type of `entity'
		do
			Result := variable.type
		end

	hash_code: INTEGER
			-- Hash code value

	text: STRING
			-- Text representation of Current term
		do
			create Result.make (128)
			Result.append (once "Variable: ")
			Result.append (variable.text)
			Result.append_character (',')
			Result.append_character (' ')
			if position /= Void then
				Result.append (position.text)
				Result.append_character (',')
				Result.append_character (' ')
			end
		end

	columns_in_result (a_start_column: INTEGER): INTEGER_INTERVAL
			-- 1-based column ranges in the resulting SQL table starting from `a_start_column'
			-- A to-be-returned variable occupies six columns:
			-- 1. uuid              (derived from Queryables.uuid)
			-- 2. object_id         (from PropertyBindings1.var1)
			-- 3. value             (from PropertyBindings1.value)
			-- 4. equal_value       (from PropertyBindings1.equal_value)
			-- 5. dynamic_type_name (derived from PropertyBindings1.type1)
			-- 6. position          (from PropertyBindings1.position)
		do
			create Result.make (a_start_column, a_start_column + 5)
		ensure then
			good_result: Result.lower = a_start_column and Result.upper = a_start_column + 5
		end

feature -- Status report

	is_variable: BOOLEAN = True
			-- Is current a variable term?

	is_position_set: BOOLEAN
			-- Is `position' information specified?
		do
			Result := position /= Void
		end

feature -- Process

	process (a_visitor: SEMQ_TERM_VISITOR)
			-- Visit Current using `a_visitor'.
		do
			a_visitor.process_variable_term (Current)
		end

end
