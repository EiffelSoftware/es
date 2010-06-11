note
	description: "Signature of single argument queries"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_SINGLE_ARG_FUNCTION_SIGNATURE

inherit
	HASHABLE

	DEBUG_OUTPUT

create
	make


feature{NONE} -- Initialization

	make (a_arg_type: like argument_type; a_result_type: like result_type)
			-- Initialize.
		local
			l_hash_str: STRING
		do
			argument_type := a_arg_type
			result_type := a_result_type
			create l_hash_str.make (32)
			l_hash_str.append (argument_type.name)
			l_hash_str.append_character ('.')
			l_hash_str.append (result_type.name)
			hash_code := l_hash_str.hash_code
		end

feature -- Access

	argument_type: TYPE_A
			-- Type of argument

	result_type: TYPE_A
			--Type of result

	hash_code: INTEGER
			-- Hash code value

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			create Result.make (64)
			Result.append (argument_type.name)
			Result.append (once " x ")
			Result.append (result_type.name)
		end

end
