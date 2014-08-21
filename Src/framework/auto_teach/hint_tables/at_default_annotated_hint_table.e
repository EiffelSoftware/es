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

				-- All the rest is hidden:
			table.put 			(<< 	F		>>, enum_block_type.Bt_if)
			table.put 			(<< 	F		>>, enum_block_type.Bt_if_branch)
			table.put 			(<< 	F		>>, enum_block_type.Bt_inspect)
			table.put 			(<< 	F		>>, enum_block_type.Bt_inspect_branch)
			table.put 			(<< 	F		>>, enum_block_type.Bt_loop)
			table.put 			(<< 	F		>>, enum_block_type.Bt_loop_initialization)
			table.put 			(<< 	F		>>, enum_block_type.Bt_loop_invariant)
			table.put 			(<< 	F		>>, enum_block_type.Bt_loop_body)
			table.put 			(<< 	F		>>, enum_block_type.Bt_loop_variant)

			table.put 			(<< 	U		>>, enum_block_type.Bt_assertion)
				-- Assertions should never be visibile. However, it is a bad practice to impose it here.
			table.put 			(<< 	U		>>, enum_block_type.Bt_instruction)
				-- Instructions should never be visibile. However, it is a bad practice to impose it here.
		end

end
