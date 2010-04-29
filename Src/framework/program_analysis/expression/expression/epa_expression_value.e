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
			-- New string containing terse printable representation
			-- of current object
		do
			Result := item.out
		end

feature -- Status report

	is_boolean: BOOLEAN
			-- Is current a boolean value?
		do
		end

	is_integer: BOOLEAN
			-- Is current an integer value?
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

feature -- Process

	process (a_visitor: EPA_EXPRESSION_VALUE_VISITOR)
			-- Process Current using `a_visitor'.
		deferred
		end

end
