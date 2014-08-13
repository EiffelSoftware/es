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
			table.put (<< 	True,	True,	True,	True,	True	>>, enum_block_type.bt_feature)				-- Always show features
			table.put (<< 	False,	True,	True,	True,	True	>>, enum_block_type.bt_arguments)			-- Show arguments from level 2
			table.put (<< 	False,	False,	True,	True,	True	>>, enum_block_type.bt_precondition)		-- Show preconditions from level 3
			table.put (<< 	False,	False,	False,	True,	True	>>, enum_block_type.bt_locals)				-- Show locals from level 4
			table.put (<< 	False,	False,	False,	False,	True	>>, enum_block_type.bt_routine_body)		-- Show body from level 5
			table.put (<< 	False,	False,	True,	True,	True 	>>, enum_block_type.bt_postcondition)		-- Show postconditions from level 3
			table.put (<< 	False,	False,	True,	True,	True	>>, enum_block_type.bt_class_invariant)		-- Show class invariants from level 3
		end

end
