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
			create table.make (suggested_tables_initial_size)
			create content_table.make (suggested_tables_initial_size)

			-- Level 1: Skeleteon only. Show only the existence of features. Hide all the rest.
			-- Level 2: Show routine arguments.
			-- Level 3: Show contracts.
			-- Level 4: Show locals.
			-- Level 5: Show the skeleton of if/inspect/loop statements
			-- Level 6: Show condition of if statements and initialization, termination condition, variant and invariant of loop statements.
			-- Level 7: Show body of everything.

				-- We take care of assertions and instructions as the last thing.

			table.put 			(<< 	Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true			>>, enum_block_type.Bt_feature)
			content_table.put 	(<< 	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined		>>, enum_block_type.Bt_feature)

			table.put 			(<< 	Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true			>>, enum_block_type.Bt_arguments)
			content_table.put	(<< 	Tri_false,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true			>>, enum_block_type.Bt_arguments)
			table.put 			(<< 	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined		>>, enum_block_type.Bt_argument_declaration)
				-- Rely on the content visibility of `arguments'.

			table.put 			(<< 	Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true			>>, enum_block_type.Bt_precondition)
			content_table.put	(<< 	Tri_false,		Tri_false,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true			>>, enum_block_type.Bt_precondition)
				-- Contains assertions.

			table.put 			(<< 	Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true			>>, enum_block_type.Bt_locals)
			content_table.put 	(<< 	Tri_false,		Tri_false,		Tri_false,		Tri_true,		Tri_true,		Tri_true,		Tri_true			>>, enum_block_type.Bt_locals)
			table.put 			(<< 	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined		>>, enum_block_type.Bt_local_declaration)
				-- Rely on the content visibility of `locals'.


			table.put 			(<< 	Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true			>>, enum_block_type.Bt_routine_body)
			content_table.put	(<< 	Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_true			>>, enum_block_type.Bt_routine_body)
				-- Contains instructions.

			table.put 			(<< 	Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_true,		Tri_true,		Tri_true			>>, enum_block_type.Bt_if)
			content_table.put	(<< 	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined		>>, enum_block_type.Bt_if)
			table.put 			(<< 	Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_true,		Tri_true			>>, enum_block_type.Bt_if_condition)
			table.put 			(<< 	Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true			>>, enum_block_type.Bt_if_branch)
			content_table.put	(<< 	Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_true			>>, enum_block_type.Bt_if_branch)
				-- Contains instructions.

			table.put 			(<< 	Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_true,		Tri_true,		Tri_true			>>, enum_block_type.Bt_inspect)
			content_table.put	(<< 	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined		>>, enum_block_type.Bt_inspect)
			table.put 			(<< 	Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true			>>, enum_block_type.Bt_inspect_branch)
			content_table.put	(<< 	Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_true			>>, enum_block_type.Bt_inspect_branch)
				-- Contains instructions.

			table.put 			(<< 	Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_true,		Tri_true,		Tri_true			>>, enum_block_type.Bt_loop)
			content_table.put	(<< 	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined		>>, enum_block_type.Bt_loop)
			table.put 			(<< 	Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_true,		Tri_true			>>, enum_block_type.Bt_loop_termination_condition)
			table.put 			(<< 	Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true			>>, enum_block_type.Bt_loop_initialization)
			content_table.put	(<< 	Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_true,		Tri_true			>>, enum_block_type.Bt_loop_initialization)
				-- Contains instructions.
			table.put 			(<< 	Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true			>>, enum_block_type.Bt_loop_invariant)
			content_table.put	(<< 	Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_true,		Tri_true			>>, enum_block_type.Bt_loop_invariant)
				-- Contains assertions.
			table.put 			(<< 	Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true			>>, enum_block_type.Bt_loop_body)
			content_table.put	(<< 	Tri_true,		Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_true			>>, enum_block_type.Bt_loop_body)
				-- Contains instructions.
			table.put 			(<< 	Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true			>>, enum_block_type.Bt_loop_variant)
			content_table.put	(<< 	Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_true,		Tri_true			>>, enum_block_type.Bt_loop_variant)

			table.put 			(<< 	Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true			>>, enum_block_type.Bt_postcondition)
			content_table.put	(<< 	Tri_false,		Tri_false,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true			>>, enum_block_type.Bt_postcondition)
				-- Contains assertions.

			table.put 			(<< 	Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true			>>, enum_block_type.Bt_class_invariant)
			content_table.put	(<< 	Tri_false,		Tri_false,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true			>>, enum_block_type.Bt_class_invariant)
				-- Contains assertions.

			table.put 			(<< 	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined		>>, enum_block_type.Bt_assertion)
				-- The visibility of assertions should not be fixed. Instead, it should be determined by their location.
			table.put 			(<< 	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined		>>, enum_block_type.Bt_instruction)
				-- The visibility of instructions should not be fixed. Instead, it should be determined by their location.

		end

end
