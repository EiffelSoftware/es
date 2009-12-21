note
	description: "Summary description for {AFX_INTERPRETER}."
	author: ""
	date: ""
	revision: ""

deferred class
	AFX_INTERPRETER

inherit
	ARGUMENTS

feature{NONE} -- Implementation

	make
			-- Initialize.
		do
			if argument_count = 1 then
				if argument (1).is_case_insensitive_equal ("--analyze-tc") then
						-- Analyze test cases to construct fixes.					
					execute_test_cases
				end
			elseif argument_count = 2 then
				if argument (1).is_case_insensitive_equal ("--validate-fix") then
						-- Validate fix candidates.
				end
			end
		end

feature{NONE} -- Implementation

	test_cases: LINKED_LIST [PROCEDURE [ANY, TUPLE]]
			-- Agents to test cases to be invoked.

	execute_test_cases
			-- Run test cases and do analysis to support fix generation.
		do
			initialize_test_cases
			from
				test_cases.start
			until
				test_cases.after
			loop
				test_cases.item_for_iteration.call (Void)
				test_cases.forth
			end
		end

feature{NONE} -- Implementation

	initialize_test_cases
			-- Initialize `test_cases'.
		deferred
		end

end

