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

			-- Hint level:				1				2				3				4				5				6				7
			table.put 			(<< 	True,			True,			True,			True,			True,			True,			True				>>, enum_block_type.Bt_feature)
			content_table.put 	(<< 	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined		>>, enum_block_type.Bt_feature)

			table.put 			(<< 	False,			True,			True,			True,			True,			True,			True				>>, enum_block_type.Bt_arguments)

			table.put 			(<< 	True,			True,			True,			True,			True,			True,			True				>>, enum_block_type.Bt_precondition)
			content_table.put	(<< 	Tri_false,		Tri_false,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true			>>, enum_block_type.Bt_precondition)
			table.put 			(<< 	False,			False,			False,			False,			False,			False,			False				>>, enum_block_type.Bt_assertion) -- Should always be overridden by something

			table.put 			(<< 	True,			True,			True,			True,			True,			True,			True				>>, enum_block_type.Bt_locals)
			content_table.put 	(<< 	Tri_false,		Tri_false,		Tri_false,		Tri_true,		Tri_true,		Tri_true,		Tri_true			>>, enum_block_type.Bt_locals)

			table.put 			(<< 	True,			True,			True,			True,			True,			True,			True				>>, enum_block_type.Bt_routine_body)
			content_table.put	(<< 	Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_true			>>, enum_block_type.Bt_routine_body)
			table.put 			(<< 	False,			False,			False,			False,			False,			False,			False				>>, enum_block_type.Bt_instruction)  -- Should always be overridden by something

			table.put 			(<< 	False,			False,			False,			False,			True,			True,			True				>>, enum_block_type.Bt_if)
			content_table.put	(<< 	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_true,		Tri_true			>>, enum_block_type.Bt_if)
			table.put 			(<< 	False,			False,			False,			False,			False,			True,			True				>>, enum_block_type.Bt_if_condition)
			table.put 			(<< 	True,			True,			True,			True,			True,			True,			True				>>, enum_block_type.Bt_if_branch)
			content_table.put	(<< 	Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_true			>>, enum_block_type.Bt_if_branch)

			table.put 			(<< 	False,			False,			False,			False,			True,			True,			True				>>, enum_block_type.Bt_inspect)
			content_table.put	(<< 	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined		>>, enum_block_type.Bt_inspect)
			table.put 			(<< 	True,			True,			True,			True,			True,			True,			True				>>, enum_block_type.Bt_inspect_branch)
			content_table.put	(<< 	Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_true			>>, enum_block_type.Bt_inspect_branch)

			table.put 			(<< 	False,			False,			False,			False,			True,			True,			True				>>, enum_block_type.Bt_loop)
			content_table.put	(<< 	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_undefined,	Tri_true,		Tri_true			>>, enum_block_type.Bt_loop)
			table.put 			(<< 	False,			False,			False,			False,			False,			True,			True				>>, enum_block_type.Bt_loop_termination_condition)
			table.put 			(<< 	True,			True,			True,			True,			True,			True,			True				>>, enum_block_type.Bt_loop_initialization)
			content_table.put	(<< 	Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_true,		Tri_true			>>, enum_block_type.Bt_loop_initialization)
			table.put 			(<< 	True,			True,			True,			True,			True,			True,			True				>>, enum_block_type.Bt_loop_invariant)
			content_table.put	(<< 	Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_true,		Tri_true			>>, enum_block_type.Bt_loop_invariant)
			table.put 			(<< 	True,			True,			True,			True,			True,			True,			True				>>, enum_block_type.Bt_loop_body)
			content_table.put	(<< 	Tri_true,		Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_true			>>, enum_block_type.Bt_loop_body)
			table.put 			(<< 	True,			True,			True,			True,			True,			True,			True				>>, enum_block_type.Bt_loop_variant)
			content_table.put	(<< 	Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_false,		Tri_true,		Tri_true			>>, enum_block_type.Bt_loop_variant)

			table.put 			(<< 	True,			True,			True,			True,			True,			True,			True				>>, enum_block_type.Bt_postcondition)
			content_table.put	(<< 	Tri_false,		Tri_false,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true			>>, enum_block_type.Bt_postcondition)
				-- We already inserted the row for assertions

			table.put 			(<< 	True,			True,			True,			True,			True,			True,			True				>>, enum_block_type.Bt_class_invariant)
			content_table.put	(<< 	Tri_false,		Tri_false,		Tri_true,		Tri_true,		Tri_true,		Tri_true,		Tri_true			>>, enum_block_type.Bt_class_invariant)
				-- We already inserted the row for assertions.

		end

end
