note
	description: "Summary description for {EPA_CFG_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_CFG_UTILITY

inherit
	REFACTORING_HELPER

feature -- Status report

	is_branching_instruction (a_instrution: AST_EIFFEL): BOOLEAN
			-- Is `a_instruction' a branching instruction?
		do
			fixme ("Use a visitor to avoid object tests is a better solution. 28.2.2010 Jasonw")
			Result :=
				attached {IF_AS} a_instrution or else
				attached {LOOP_AS} a_instrution or else
				attached {INSPECT_AS} a_instrution
		end

	is_sequential_instruction (a_instrution: AST_EIFFEL): BOOLEAN
			-- Is `a_instruction' a sequential (not branching) instruction?
		do
			Result := not is_branching_instruction (a_instrution)
		end

end
