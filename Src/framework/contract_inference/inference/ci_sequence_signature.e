note
	description: "Signature of a sequence"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_SEQUENCE_SIGNATURE

inherit
	SHARED_TEXT_ITEMS
		undefine
			out,
			is_equal
		end

	HASHABLE
		redefine
			out,
			is_equal
		end

	DEBUG_OUTPUT
		undefine
			out,
			is_equal
		end

	EPA_STRING_UTILITY
		undefine
			out,
			is_equal
		end

create
	make

feature{NONE} -- Initialization

	make (a_target_variable_index: INTEGER; a_function_name: like function_name; a_function_type: TYPE_A; a_lower_bound_expr, a_upper_bound_expr: STRING)
			-- Initialize Current.
		do
			target_variable_index := a_target_variable_index
			function_name := a_function_name.twin
			create out.make (64)
			out.append (once " [")
			out.append (a_target_variable_index.out)
			out.append (once ", %"")
			out.append (a_function_name)
			out.append (once "%"]")
			hash_code := out.hash_code

			if a_lower_bound_expr = Void then
				lower_bound_expression := Void
			else
				lower_bound_expression := a_lower_bound_expr.twin
			end

			if a_upper_bound_expr = Void then
				upper_bound_expression := Void
			else
				upper_bound_expression := a_upper_bound_expr.twin
			end
		end

feature -- Access

	target_variable_index: INTEGER
			-- 0-based operand position of `target_variable_name'

	function_name: STRING
			-- Name of the function from which the sequence is extracted

	function_type: TYPE_A
			-- Type of `function_name'

	out: STRING
			-- String that should be displayed in debugger to represent `Current'.

	debug_output: STRING
			-- Debug output
		do
			Result := out
		end

	hash_code: INTEGER
			-- Hash code of current

	upper_bound_expression: STRING
			-- Expression to get upper bound

	lower_bound_expression: STRING
			-- Expression to get lower bound

feature -- Status report

	is_special: BOOLEAN
			-- Is current sequence special?
			-- A sequence is special if and only if it is made out of
			-- a single element.
		do
			Result := function_name ~ ti_current
		end

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result :=
				(target_variable_index = other.target_variable_index) and then
				(function_name ~ other.function_name)
		end

end
