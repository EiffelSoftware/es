note
	description: "Interface for classes the make the result of an evaluation explicit."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EXT_CHECKER

feature -- Access

	passed_check: BOOLEAN
			-- The evaluation of the last iteration by this checker.
		deferred
		end

feature -- Basic Operations

	check_ast (a_ast: AST_EIFFEL)
			-- Checks if `a_ast' conforms to the specified checks and
			-- and makes the result of the check available in `passed_check'.
		deferred
		end

end
