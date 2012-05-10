note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	IV_FUNCTION_CALL

inherit

	IV_EXPRESSION

inherit {NONE}

	IV_HELPER

create
	make

feature {NONE} -- Initialization

	make (a_name: STRING; a_type: IV_TYPE)
			-- Initialize function call with `a_name' and `a_type'.
		do
			name := a_name.twin
			type := a_type
			create arguments.make
		ensure
			name_set: name ~ a_name
			type_set: type = a_type
		end

feature -- Access

	name: STRING
			-- Name of called function.

	arguments: LINKED_LIST [IV_EXPRESSION]
			-- Arguments of function call.

	type: IV_TYPE
			-- Type of function.

feature -- Element change

	add_argument (a_argument: IV_EXPRESSION)
			-- Add argument `a_argument'.
		require
			a_argument_attached: attached a_argument
		do
			arguments.extend (a_argument)
		end

feature -- Visitor

	process (a_visitor: IV_EXPRESSION_VISITOR)
			-- Process `a_visitor'.
		do
			a_visitor.process_function_call (Current)
		end

invariant
	name_valid: is_valid_name (name)
	arguments_attached: attached arguments
	arguments_valid: not arguments.has (Void)

end
