note
	description: "Class to represent a function"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CI_FUNCTION

feature -- Access

	argument_types: LIST [TYPE_A]
			-- Types of arguments of Current function
			-- The order in the list is important. The first element
			-- is the type of the first argument, and so on.
		deferred
		end

	result_type: TYPE_A
			-- Type of the result of current function
		deferred
		end

	types: DS_HASH_SET [TYPE_A]
			-- Types of operands (including arguments and result) of current function
		deferred
		end

	arity: INTEGER
			-- Arity of current function
		do
			Result := argument_types.count
		end

invariant
	operand_types_valid: argument_types.for_all (agent types.has) and types.has (result_type)

end
