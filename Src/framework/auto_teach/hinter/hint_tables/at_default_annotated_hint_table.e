note
	description: "[
					Default table in annotated (with hints) mode.
					Only shows the skeleton of features and hides the rest.
					This behaviour can of course be overridden by local annotations.
				]"
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_DEFAULT_ANNOTATED_HINT_TABLE

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

			-- Hint level:	1
			table.put (<< 	True	>>, enum_block_type.bt_feature)				-- Always show features
			table.put (<< 	True	>>, enum_block_type.bt_arguments)			-- Always show arguments
			table.put (<< 	False	>>, enum_block_type.bt_precondition)		-- Never show preconditions
			table.put (<< 	False	>>, enum_block_type.bt_locals)				-- Never show locals
			table.put (<< 	False	>>, enum_block_type.bt_routine_body)		-- Never show body
			table.put (<< 	False	>>, enum_block_type.bt_postcondition)		-- Never show postconditions
			table.put (<< 	False	>>, enum_block_type.bt_class_invariant)		-- Never show class invariants
		end

end
