note
	description: "A value in a term"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	IR_VALUE

inherit
	HASHABLE

	DEBUG_OUTPUT

	IR_VALUE_TYPES

feature -- Access

	item: ANY
			-- Value wrapped in Current
		deferred
		end

	text: STRING
			-- Text representation of Current
		deferred
		end

	type: INTEGER
			-- Type of current value

	type_name: STRING
			-- Name of `type'
		do
			Result := ir_value_type_name (type)
		end

feature -- Status report

	is_integer_value: BOOLEAN
			-- Is current an integer?
		do
		end

	is_boolean_value: BOOLEAN
			-- Is current a boolean?
		do
		end

	is_string_value: BOOLEAN
			-- Is current a string?
		do
		end

	is_integer_range: BOOLEAN
			-- Is current an integer range?
		do
		end

feature -- Process

	process (a_visitor: IR_TERM_VALUE_VISITOR)
			-- Process Current with `a_visitor'.
		deferred
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := text
		end

invariant
	type_valid: is_ir_value_type_valid (type)

end
