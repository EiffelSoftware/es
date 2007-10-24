indexing
	description: "Shared cdd factory"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_SHARED_FACTORY


feature -- Factories


	test_case_factory: CDD_TEST_CASE_FACTORY is
			-- Factory for manipulating test cases
		once
			create Result
		end


end
