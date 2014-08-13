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
			create content_table.make (16)

			-- Hint level:	1
			table.put 			(<< 	True			>>, enum_block_type.bt_feature)				-- Always show features
			content_table.put 	(<< 	Tri_undefined	>>, enum_block_type.bt_feature)

			table.put 			(<< 	True			>>, enum_block_type.bt_arguments)			-- Always show arguments
			content_table.put	(<< 	Tri_false		>>, enum_block_type.bt_arguments)

			table.put 			(<< 	True			>>, enum_block_type.bt_precondition)		-- Always show the existence of preconditions
			content_table.put	(<< 	Tri_false		>>, enum_block_type.bt_precondition)		-- Never show the content of preconditions
			table.put 			(<< 	False			>>, enum_block_type.bt_assertion)			-- Never show assertions

			table.put 			(<< 	True			>>, enum_block_type.bt_locals)				-- Always show the existence of locals deckaratuibs
			content_table.put 	(<< 	Tri_false		>>, enum_block_type.bt_locals)				-- Always hide the content of locals declarations

			table.put 			(<< 	True			>>, enum_block_type.bt_routine_body)		-- Always show the existence of routine bodies
			content_table.put	(<< 	Tri_false		>>, enum_block_type.bt_routine_body)		-- Always hide the content of routine bodies
			table.put 			(<< 	False			>>, enum_block_type.bt_instruction)			-- Never show instructions

			table.put 			(<< 	True			>>, enum_block_type.bt_postcondition)		-- Always show the existence of postconditions
			content_table.put	(<< 	Tri_false		>>, enum_block_type.bt_postcondition)		-- Never show the content of postconditions
				-- We already inserted the row for assertions.

			table.put 			(<< 	True			>>, enum_block_type.bt_class_invariant)		-- Always show the existence of class invariants
			content_table.put	(<< 	Tri_false		>>, enum_block_type.bt_class_invariant)		-- Always hide the content of class invariants
				-- We already inserted the row for assertions.
		end

end
