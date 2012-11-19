note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	IV_ASSERTION

feature {NONE} -- Initialization

	make (a_expression: like expression)
			-- Initialize axiom with expression `a_expression'.
		require
			a_expression_attached: attached a_expression
			boolean_expression: a_expression.type.is_boolean
		do
			expression := a_expression
		ensure
			expression_set: expression = a_expression
		end

feature -- Access

	expression: IV_EXPRESSION
			-- Axiom expression.

	information: detachable IV_ASSERTION_INFORMATION
			-- Assertion type information.

	attribute_string: detachable STRING
			-- Attribute string.

feature -- Element change

	set_assertion_type (a_string: STRING)
			-- Create `assertion_information' with type `a_string'.
		require
			no_information_yet: information = Void
		do
			create information.make (a_string)
		ensure
			type_set: information.type ~ a_string
		end

	set_information (a_information: IV_ASSERTION_INFORMATION)
			-- Set `information' to `a_information'.
		do
			information := a_information
		ensure
			information_set: information = a_information
		end

	set_attribute_string (a_string: STRING)
			-- Set `attribute_string' to `a_string'.
		do
			attribute_string := a_string
		ensure
			attribute_string_set: attribute_string = a_string
		end

invariant
	expression_attached: attached expression
	boolean_expression: expression.type.is_boolean

end
