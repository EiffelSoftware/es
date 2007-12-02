indexing
	description: "Objects that represent a manual test class containing test routines"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_MANUAL_TEST_CLASS

inherit

	CDD_TEST_CLASS
		rename
			is_valid_test_class as is_manual_test_class
		end

create
	make_with_class

end
