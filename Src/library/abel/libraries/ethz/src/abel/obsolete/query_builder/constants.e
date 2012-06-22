note
	description: "Summary description for {CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONSTANTS

feature -- Access

	Or_: DISJUNCTION
		once
			create Result
		end

	And_: CONJUNCTION
		once
			create Result
		end

	Gt: GREATER_THAN
		once
			create Result
		end

	Eq: EQUALS
		once
			create Result
		end

	From_: FROM_CLAUSE
		once
			create Result
		end

	Select_: SELECT_CLAUSE
		once
			create Result
		end

	All_: ALL_CLAUSE
		once
			create Result
		end

	Terminator: TERMINATOR
		once
			create Result
		end

	Separator: SEPARATOR
		once
			create Result
		end

feature -- Basic operations

end
