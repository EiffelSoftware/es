indexing
	description: "Objects that provide a command line interface for executing test cases"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	EWB_CDD_EXECUTOR

inherit

	EWB_CDD_CMD

	THREAD_CONTROL
		export
			{NONE} all
		end

feature -- Access

	name: STRING is "Run"

	help_message: STRING is "Run all test cases in system"

	abbreviation: CHARACTER is 'r'

feature -- Execution

	execute is
			-- Execute all test cases.
		do
			if cdd_manager.is_cdd_enabled then
				if cdd_manager.test_suite.test_cases.count > 0 then
					if cdd_manager.executor.can_start then
						io.put_string ("Starting execution...")
						cdd_manager.executor.test_all
					else
						io.put_string ("Could not start executing of some reason")
					end
				else
					io.put_string ("There are no test cases in system. Try recompiling the system.%N")
				end
			else
				io.put_string ("CDD is currently not enabled. To create%N, view or run test cases enable CDD through `Status' menu.")
			end
		end

end
