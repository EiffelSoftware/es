note
	description: "Summary description for {AFX_EXPRESSION_VALUE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_EXPRESSION_VALUE

inherit
	SHARED_TYPES
		redefine
			is_equal,
			out
		end

	HASHABLE
		undefine
			is_equal,
			out
		end

feature -- Access

	type: TYPE_A
			-- Type of current value
		deferred
		end

	item: ANY
			-- Value item in current
		deferred
		end

	out: STRING
			-- Text representation of Current.
		do
			Result := text
		end

	text: STRING
			-- New string containing terse printable representation
			-- of current object
		do
			Result := item.out
		end

	as_integer: detachable EPA_INTEGER_VALUE
			-- Current as integer
		do
		end

	as_boolean: detachable EPA_BOOLEAN_VALUE
			-- Current as integer
		do
		end

	as_void: detachable EPA_VOID_VALUE
			-- Current as integer
		do
		end

	as_real: detachable EPA_REAL_VALUE
			-- Current as integer
		do
		end

	as_reference: detachable EPA_REFERENCE_VALUE
			-- Current as integer
		do
		end

	as_pointer: detachable EPA_POINTER_VALUE
			-- Current as pointer
		do
		end

	as_nonsensical: detachable EPA_NONSENSICAL_VALUE
			-- Current as nonsensical value
		do
		end

	as_string: detachable EPA_STRING_VALUE
			-- Current as string value
		do
		end

	type_name: STRING
			-- Type name of current value
		do
			if is_void then
				Result := void_type_name
			elseif is_integer then
				Result := integer_type_name
			elseif is_boolean then
				Result := boolean_type_name
			elseif is_real then
				Result := real_type_name
			elseif is_reference then
				Result := reference_type_name
			elseif is_pointer then
				Result := pointer_type_name
			elseif is_nonsensical then
				Result := nonsensical_type_name
			end
		end

feature -- Constants

	boolean_type_name: STRING = "BOOLEAN"

	integer_type_name: STRING = "INTEGER"

	void_type_name: STRING = "NONE"

	real_type_name: STRING = "REAL"

	reference_type_name: STRING = "REFERENCE"

	pointer_type_name: STRING = "POINTER"

	nonsensical_type_name: STRING = "NONSENSICAL"

feature -- Status report

	is_void: BOOLEAN
			-- Is current a Void value?
		do
		end

	is_boolean: BOOLEAN
			-- Is current a boolean value?
		do
		end

	is_true_boolean: BOOLEAN
			-- Is current a boolean value True?
		do
		end

	is_false_boolean: BOOLEAN
			-- Is current a boolean value False?
		do
		end

	is_integer: BOOLEAN
			-- Is current an integer value?
		do
		end

	is_real: BOOLEAN
			-- Is current a real value?
		do
		end

	is_pointer: BOOLEAN
			-- Is current a pointer value?
		do
		end

	is_reference: BOOLEAN
			-- Is current a reference value?
		do
		end

	is_nonsensical: BOOLEAN
			-- Does current represent a value that is not retrievable?
			-- A nonsensical value happens when there is an exception during the
			-- evaluation of the expression.
		do
		end

	is_random: BOOLEAN
			-- Does current represent a random value?
		do
		end

	is_deterministic: BOOLEAN
			-- Does current represent a deterministic value?
		do
			Result := not is_random
		ensure
			good_result: Result = not is_random
		end

	is_ast_expression_value: BOOLEAN
			-- Does current represent an AST expression value?
		do
		end

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result := type.is_equivalent (other.type) and then is_item_equal (other)
		end

	is_item_equal (other: like Current): BOOLEAN
			-- Is `item' equal to `other'.`item'?
		do
			Result := item ~ other.item
		end

	is_string: BOOLEAN
			-- Is current a string value?
		do
		end

	is_numeric_range: BOOLEAN
			-- Is current a numeric range value?
		do
		end

	is_any: BOOLEAN
			-- Is current an any value?
		do
		end

feature -- Hashing

	hash_code: INTEGER
			-- Hash code value
		do
			Result := text.hash_code
		end

feature -- Process

	process (a_visitor: EPA_EXPRESSION_VALUE_VISITOR)
			-- Process Current using `a_visitor'.
		deferred
		end

end
