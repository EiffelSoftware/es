note
	description: "Class that represents a variable position term"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_VARIABLE_TERM

inherit
	SEMQ_TERM
		rename
			expression as variable
		redefine
			is_precondition,
			is_postcondition,
			is_property,
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

	make (a_variable: like variable)
			-- Initialize `variable' with `a_variable'.
		do
			variable := a_variable
			hash_code := text_from_ast (variable).hash_code
		end

	make_with_position (a_variable: like variable;  a_position: like position)
			-- Initialize `variable' with `a_variable', `position' with `a_position'.
		do
			make (a_variable)
			position := a_position
		end

	make_as_target (a_variable: like variable)
			-- Initialize Current with `a_variable', which is supposed to be the target
			-- operand of a transition.
		do
			create position.make_as_target
			make (a_variable)
		end

	make_as_argument (a_variable: like variable; a_arg_position: INTEGER)
			-- Initialize Current with `a_variable', and `a_variable' is supposed to be the `a_arg_position'-th
			-- argument of a transition.
		require
			a_arg_position_positive: a_arg_position > 0
		do
			create position.make_as_argument (a_arg_position)
			make (a_variable)
		end

	make_as_some_argument (a_variable: like variable)
			-- Initialize Current with `a_variable', and `a_variable' is supposed to be an
			-- argument of a transition, that is to say, the exact position of the argument is unspecified.
		do
			create position.make_as_unspecified_argument
			make (a_variable)
		end

	make_as_operand (a_variable: like variable)
			-- Initialize Current with `a_variable', and `a_variable' is supposed to be an operand of a transition.
			-- That is to say, the variable can be either the target or an argument.
		do
			create position.make_as_unspecified_operand
			make (a_variable)
		end

feature -- Access

	variable: EXPR_AS
			-- Variable wrapped in Current term

	value: EXPR_AS
		do
			Result := Void
		end

	position: detachable SEM_TRANSITION_VARIABLE_POSITION
			-- Position requirement of `variable'
			-- Only have effect in a transition.
			-- If Void, there is no constrain over the position of `variable'

	type: detachable TYPE_A
			-- Type of `variable'
			-- If not Void, only variables with types conforming to
			-- `type' will be matched in a query.

	type_name: STRING
			-- Name of `type'
		require
			type_attached: type /= Void
		do
			Result := output_type_name (type.name)
		end

	hash_code: INTEGER
			-- Hash code value

	text: STRING
			-- Text representation of Current term
		do
			create Result.make (128)
			Result.append (once "Variable: ")
			Result.append (text_from_ast (variable))
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

	column_types_in_result (a_start_column: INTEGER): HASH_TABLE [INTEGER, INTEGER]
			-- <Precursor>
		local
			l_columns: like columns_in_result
		do
			create Result.make (6)
			l_columns := columns_in_result (a_start_column)
			Result.force (mysql_string_type, l_columns.item (1))
			Result.force (mysql_integer_type, l_columns.item (2))
			Result.force (mysql_integer_type, l_columns.item (3))
			Result.force (mysql_integer_type, l_columns.item (4))
			Result.force (mysql_string_type, l_columns.item (5))
			Result.force (mysql_integer_type, l_columns.item (6))
		end

feature -- Status report

	is_precondition: BOOLEAN
			-- Is current a precondition term?

	is_postcondition: BOOLEAN
			-- Is current a postcondition term?

	is_property: BOOLEAN
			-- Is current a property term (for objects)?

	is_variable: BOOLEAN = True
			-- Is current a variable term?

	is_position_set: BOOLEAN
			-- Is `position' information specified?
		do
			Result := position /= Void
		end

feature -- Setting

	set_is_precondition (b: BOOLEAN)
			-- Set `is_precondition' with `b'.
			-- Note: specify consistent values according to `is_postcondition', `is_property'.
		do
			is_precondition := b
		ensure
			is_precondition_set: is_precondition = b
		end

	set_is_postcondition (b: BOOLEAN)
			-- Set `is_postcondition' with `b'.
			-- Note: specify consistent values according to `is_pretcondition', `is_property'.
		do
			is_postcondition := b
		ensure
			is_postcondition_set: is_postcondition = b
		end

	set_is_property (b: BOOLEAN)
			-- Set `is_property' with `b'.
			-- Note: specify consistent values according to `is_precondition', `is_postcondition'.
		do
			is_property := b
		ensure
			is_property_set: is_property = b
		end

	set_type (a_type: like type)
			-- Set `type' with `a_type'.
		do
			type := a_type
		ensure
			type_set: type = a_type
		end

feature -- Process

	process (a_visitor: SEMQ_TERM_VISITOR)
			-- Visit Current using `a_visitor'.
		do
			a_visitor.process_variable_term (Current)
		end

end
