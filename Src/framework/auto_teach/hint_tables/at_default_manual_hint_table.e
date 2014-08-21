note
	description: "[
					Table to be used in manual mode. Manual mode means that everything
					is handled manually	by the user through annotations.
					Only shows the skeleton of features (including arguments) and hides the rest,
					giving total freedom to the user to do what he wants with manual annotations
					(and possibly textual hints).
				]"
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_DEFAULT_MANUAL_HINT_TABLE

inherit

	AT_HINT_TABLE

create
	make

feature {NONE} -- Initialization

		-- DO NOT PRETTIFY THIS CLASS!

	make
			-- Initialization for `Current'.
		do
			create table.make (suggested_tables_initial_size)
			create content_table.make (suggested_tables_initial_size)

				-- We take care of assertions and instructions as the last thing.

			-- Hint level:				1
			table.put 			(<< 	T		>>, enum_block_type.Bt_feature)				-- Always show features...
			content_table.put 	(<< 	F		>>, enum_block_type.Bt_feature)				-- ...but always hide all their content...

			table.put 			(<< 	T		>>, enum_block_type.Bt_arguments)			-- ...with the exception of arguments...

				-- ...and of the following *complex* blocks, of which we only want to show the skeleton.

			table.put 			(<< 	T		>>, enum_block_type.Bt_precondition)
			table.put 			(<< 	T		>>, enum_block_type.Bt_locals)
			table.put 			(<< 	T		>>, enum_block_type.Bt_routine_body)
			table.put 			(<< 	T		>>, enum_block_type.Bt_postcondition)

				-- If, inspect and loop blocks are hidden, but their inner complex blocks
				-- (e.g. branches) must be shown if the parent blocks are shown.
			table.put 			(<< 	F		>>, enum_block_type.Bt_if)
			table.put 			(<< 	T		>>, enum_block_type.Bt_if_branch)

			table.put 			(<< 	F		>>, enum_block_type.Bt_inspect)
			table.put 			(<< 	T		>>, enum_block_type.Bt_inspect_branch)

			table.put 			(<< 	F		>>, enum_block_type.Bt_loop)
			table.put 			(<< 	T		>>, enum_block_type.Bt_loop_initialization)
			table.put 			(<< 	T		>>, enum_block_type.Bt_loop_invariant)
			table.put 			(<< 	T		>>, enum_block_type.Bt_loop_body)
			table.put 			(<< 	T		>>, enum_block_type.Bt_loop_variant)

			table.put 			(<< 	U		>>, enum_block_type.Bt_assertion)
				-- Assertions should never be visibile. However, it is a bad practice to impose it here.
			table.put 			(<< 	U		>>, enum_block_type.Bt_instruction)
				-- Instructions should never be visibile. However, it is a bad practice to impose it here.
		end

end
