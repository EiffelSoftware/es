note
	description: "Summary description for {}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class EPA_STRING_HASH_SET

inherit
	EPA_HASH_SET[STRING]
		redefine
			make_equal
		end

	EPA_SHARED_STRING_EQUALITY_TESTER_GENERAL

create
	make,
	make_equal,
	make_case_insensitive_equal

feature{NONE} -- Initialization

	make_equal (n: INTEGER)
			-- <Precursor>
		do
			make (n)
			set_equality_tester (string_equality_tester_general)
		end

	make_case_insensitive_equal (n: INTEGER)
			-- Initialization.
		do
			make (n)
			set_equality_tester (string_case_insensitive_equality_tester_general)
		end

end
