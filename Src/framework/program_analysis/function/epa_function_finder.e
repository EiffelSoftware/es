note
	description: "Function finder"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_FUNCTION_FINDER

inherit
	EPA_SHARED_EQUALITY_TESTERS

feature -- Access

	functions: DS_HASH_SET [EPA_FUNCTION]
			-- Functions that are found by last `search'.
		deferred
		ensure
			result_attached: Result /= Void
			result_equality_tester_set: Result.equality_tester = function_equality_tester
		end

feature -- Search

	search (a_repository: detachable like functions)
			-- Search for functions, make results available in `functions'.
			-- `a_repository' is a set of functions. The idea is that `a_repository' contains
			-- the functions that are already found, so current finder can ignore those.
			-- But current search may ignore `a_repository', in that case, use Void as `a_repository'.
		deferred
		ensure
			functions_initialized: functions /= Void
			functions_equality_tester_set: functions.equality_tester = function_equality_tester
		end

	search_with_empty_repository
			-- Search for functions, make result available in `functions'.
		local
			l_emtpy_set: like functions
		do
			create l_emtpy_set.make (100)
			l_emtpy_set.set_equality_tester (function_equality_tester)
			search (l_emtpy_set)
		end

feature{NONE} -- Implementation

	new_function_set: like functions
			-- New function set
		do
			create Result.make (50)
			Result.set_equality_tester (function_equality_tester)
		end

end
