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
		undefine
			is_equal
		end

	COMPARABLE

create
	make_with_class

feature -- Comparism

	infix "<" (other: like Current): BOOLEAN is
			-- Is `Current' less than `other'?
		do
			Result := test_class < other.test_class
		end

end
