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
			table.put 			(<< 	True			>>, enum_block_type.Bt_feature)				-- Always show features
			content_table.put 	(<< 	Tri_undefined	>>, enum_block_type.Bt_feature)

			table.put 			(<< 	True			>>, enum_block_type.Bt_arguments)			-- Always show arguments

			table.put 			(<< 	True			>>, enum_block_type.Bt_precondition)		-- Always show the existence of preconditions
			content_table.put	(<< 	Tri_undefined	>>, enum_block_type.Bt_precondition)		-- Never show the content of preconditions
			table.put 			(<< 	True			>>, enum_block_type.Bt_assertion)			-- Always show assertions

			table.put 			(<< 	True			>>, enum_block_type.Bt_locals)				-- Always show the existence of locals deckaratuibs
			content_table.put 	(<< 	Tri_undefined	>>, enum_block_type.Bt_locals)				-- Always hide the content of locals declarations

			table.put 			(<< 	True			>>, enum_block_type.Bt_routine_body)		-- Always show the existence of routine bodies
			content_table.put	(<< 	Tri_undefined	>>, enum_block_type.Bt_routine_body)		-- Always hide the content of routine bodies
			table.put 			(<< 	True			>>, enum_block_type.Bt_instruction)			-- Always show instructions

			table.put 			(<< 	True			>>, enum_block_type.Bt_if)					-- Always show the existence of if instructions
			content_table.put	(<< 	Tri_undefined	>>, enum_block_type.Bt_if)					-- Always hide the content of routine bodies
			table.put 			(<< 	True			>>, enum_block_type.Bt_if_condition)		-- Always show if conditions
			table.put 			(<< 	True			>>, enum_block_type.Bt_if_branch)			-- Always show if branches
			content_table.put	(<< 	Tri_undefined	>>, enum_block_type.Bt_if_branch)			-- Always show if branches

			table.put 			(<< 	True			>>, enum_block_type.Bt_loop)
			content_table.put	(<< 	Tri_undefined	>>, enum_block_type.Bt_loop)
			table.put 			(<< 	True			>>, enum_block_type.Bt_loop_initialization)
			content_table.put	(<< 	Tri_undefined	>>, enum_block_type.Bt_loop_initialization)
			table.put 			(<< 	True			>>, enum_block_type.Bt_loop_invariant)
			content_table.put	(<< 	Tri_undefined	>>, enum_block_type.Bt_loop_invariant)
			table.put 			(<< 	True			>>, enum_block_type.Bt_loop_termination_condition)
			table.put 			(<< 	True			>>, enum_block_type.Bt_loop_body)
			content_table.put	(<< 	Tri_undefined	>>, enum_block_type.Bt_loop_body)
			table.put 			(<< 	True			>>, enum_block_type.Bt_loop_variant)
			content_table.put	(<< 	Tri_undefined	>>, enum_block_type.Bt_loop_variant)

			table.put 			(<< 	True			>>, enum_block_type.Bt_postcondition)		-- Always show the existence of postconditions
			content_table.put	(<< 	Tri_undefined	>>, enum_block_type.Bt_postcondition)		-- Never show the content of postconditions
				-- We already inserted the row for assertions.

			table.put 			(<< 	True			>>, enum_block_type.Bt_class_invariant)		-- Always show the existence of class invariants
			content_table.put	(<< 	Tri_undefined	>>, enum_block_type.Bt_class_invariant)		-- Always hide the content of class invariants
				-- We already inserted the row for assertions.
		end

end
