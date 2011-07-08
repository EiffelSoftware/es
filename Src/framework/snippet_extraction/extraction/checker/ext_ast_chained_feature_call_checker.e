note
	description: "Checks if a {NESTED_AS} call is using chained (nested) feature calls."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_CHAINED_FEATURE_CALL_CHECKER

inherit
	AST_ITERATOR
		redefine
			process_nested_as
		end

	EXT_CHECKER
		redefine
			passed_check
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Default initialization.
		do
		end

feature -- Access

	passed_check: BOOLEAN
			-- The evaluation of the last iteration by this checker.

feature -- Basic Operations

	check_ast (a_ast: AST_EIFFEL)
			-- Checks if `a_ast' conforms to the specified checks and
			-- and makes the result of the check available in `passed_check'.
		do
			passed_check := True
			a_ast.process (Current)
		end

feature {NONE} -- Implementation

	process_nested_as (a_as: NESTED_AS)
			-- Checks if a call is nested.
		do
			if attached {NESTED_AS} a_as.message then
				passed_check := False
			end
		end

end
