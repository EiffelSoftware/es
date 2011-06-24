note
	description: "Decides if a snippet is valuable."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_SNIPPET_DECIDER

inherit
	REFACTORING_HELPER
		export {NONE} all end

feature -- Access

	decide_on_instruction_list (a_compound_as: EIFFEL_LIST [INSTRUCTION_AS]): BOOLEAN
			-- Decision function answering if a snippet should be kept or not.
		do
			Result := across criteria as criteria_cursor all criteria_cursor.item.item ([a_compound_as]) end
		end

feature {NONE} -- Implementation

	criteria: LINKED_SET [FUNCTION [EXT_SNIPPET_DECIDER, TUPLE [a_compound_as: EIFFEL_LIST [INSTRUCTION_AS]], BOOLEAN]]
		once
			create Result.make
			Result.force (agent check_empty_snippet_rule)
			Result.force (agent check_single_line_snippet_rule)
		end

	check_empty_snippet_rule (a_compound_as: EIFFEL_LIST [INSTRUCTION_AS]): BOOLEAN
			-- Returns false in case `a_compound_as' is empty.
		do
			Result := not a_compound_as.is_empty
		end

	check_single_line_snippet_rule (a_compound_as: EIFFEL_LIST [INSTRUCTION_AS]): BOOLEAN
			-- Returns false for snippets with one instruction that is not of type `{IF_AS}', `{LOOP_AS}' or `{INSPECT_AS}'.
		do
			if a_compound_as.count = 1 then
				if attached a_compound_as.i_th (1) as l_as then
					if attached {IF_AS} l_as or attached {LOOP_AS} l_as or attached {INSPECT_AS} l_as then
						Result := True
					end
				end
			else
				Result := True
			end
		end

end
