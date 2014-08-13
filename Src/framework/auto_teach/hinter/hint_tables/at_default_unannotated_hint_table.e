note
	description: "[
					Default table in unannotated (without hints) mode.
					Implements a (hopefully) reasonable default policy,
					which can as always be overridden by local annotations.
				]"
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_DEFAULT_UNANNOTATED_HINT_TABLE

inherit

	AT_HINT_TABLE

create
	make

feature {NONE} -- Initialization

		-- DO NOT PRETTIFY THIS CLASS!

	make
			-- Initialization for `Current'.
		do
			create table.make (16)

			-- Hint level:	1		2		3		4		5
			table.put (<< 	True,	True,	True,	True,	True >>, "feature")			-- Always show features
			table.put (<< 	False,	True,	True,	True,	True >>, "arguments")		-- Show arguments from level 2
			table.put (<< 	False,	False,	True,	True,	True >>, "precondition")	-- Show preconditions from level 3
			table.put (<< 	False,	False,	False,	True,	True >>, "locals")			-- Show locals from level 4
			table.put (<< 	False,	False,	False,	False,	True >>, "body")			-- Show body from level 5
			table.put (<< 	False,	False,	True,	True,	True >>, "postcondition")	-- Show postconditions from level 3
			table.put (<< 	False,	False,	True,	True,	True >>, "classinvariant")	-- Show class invariants from level 3
		end

end
