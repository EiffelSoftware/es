indexing
	description : "function_test application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_agent: FUNCTION [ANY, TUPLE [INTEGER, INTEGER], INTEGER]
			l_result: INTEGER
		do
			l_agent := agent addition
			l_result := apply_function (l_agent)
			check l_result = 3 end
		end



	addition (a, b: INTEGER): INTEGER
		do
			Result := a + b
		ensure
			Result = a + b
		end

	apply_function (f: FUNCTION [ANY, TUPLE [INTEGER, INTEGER], INTEGER]): INTEGER
		require
			f.precondition ([1, 2])
		do
			Result := f.item ([1, 2])
		ensure
			f.postcondition ([1, 2])
		end

end
