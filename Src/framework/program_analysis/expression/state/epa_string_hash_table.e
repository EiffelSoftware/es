note
	description: "Summary description for {}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class EPA_STRING_HASH_TABLE [G]

inherit
	DS_HASH_TABLE [G, STRING]
		rename
			make_equal as make_equal_table
		end

	EPA_SHARED_STRING_EQUALITY_TESTER_GENERAL

create
	make_equal,
	make_case_insensitive_equal

feature{NONE} -- Initialization

	make_equal (n: INTEGER)
			-- Initialization.
		require
			positive_n: n >= 0
		do
			make_equal_table(n)
			set_key_equality_tester (string_equality_tester_general)
		end

	make_case_insensitive_equal (n: INTEGER)
			-- Initialization.
		require
			positive_n: n >= 0
		do
			make_equal_table(n)
			set_key_equality_tester (string_case_insensitive_equality_tester_general)
		end


end
