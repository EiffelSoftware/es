indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_DECISION_INSTRUMENTOR

inherit
	SAT_INSTRUMENTOR
		redefine
			process_if_b
		end

	SHARED_WORKBENCH

	PROJECT_CONTEXT

create
	make

feature{NONE} -- Initialization

	make is
			-- Initialize.
		do
			set_is_decision_coverage_enabled (True)
			set_is_condition_coverage_enabled (True)
			create condition_stack.make
			create loop_stack.make
			create when_part_stack.make
		end

feature -- Access

	branch_slot_number: INTEGER
			-- 1-based Slot number for branches, used to locate the position of a particular covered branch in source code.			

	map_file: PLAIN_TEXT_FILE

	open_map_file is
			--
		local
			l_file_name: FILE_NAME
		do
			create l_file_name.make_from_string (project_location.workbench_path)
			l_file_name.set_file_name ("sat_dcs_map.txt")
			create map_file.make_create_read_write (l_file_name)
		end

	close_map_file is
			--
		do
			map_file.close
		end

feature -- Status report

	is_condition_coverage_enabled: BOOLEAN
			-- Is condition coverage enabled?

	is_decision_coverage_enabled: BOOLEAN
			-- Is decision coverage enabled?

feature -- Setting

	set_is_condition_coverage_enabled (b: BOOLEAN) is
			-- Set `is_condition_coverage_enabled' with `b'.
		do
			is_condition_coverage_enabled := b
		ensure
			is_condition_coverage_enabled_set: is_condition_coverage_enabled = b
		end

	set_is_decision_coverage_enabled (b: BOOLEAN) is
			-- Set `is_decision_coverage_enabled' with `b'.
		do
			is_decision_coverage_enabled := b
		ensure
			is_decision_coverage_enabled_set: is_decision_coverage_enabled = b
		end

feature -- Data clearing

	reset is
			-- Reset
		do
			branch_slot_number := 0
		end

	clear_feature_data is
			-- Clear data related to currently processing feature.
		do
			decision_index := 0
			condition_stack.wipe_out
			loop_stack.wipe_out
			when_part_stack.wipe_out
		ensure then
		end

feature -- Byte node processing

	process_if_b (a_node: IF_B) is
			-- Process `a_node'.
		do
		end

	process_then_part_condition_start (a_expr: EXPR_B) is
			-- Process before the evaluation of the condition `a_expr' of some `Then_part' from Conditional instruction.
		do
		end

	process_then_part_condition_end (a_expr: EXPR_B) is
			-- Process after the evaluation of the condition `a_expr' of some `Then_part' from Conditional instruction.
		do
		end

	process_then_part_start is
			-- Process at the beginning of a "Then_part" from a Conditional.
		do
			increase_decision_index
			generate_branch_hook (branch_slot_number)
		end

	increase_decision_index is
			-- Increase `branch_slot_number' by one.
		do
			branch_slot_number := branch_slot_number + 1
			decision_index := decision_index + 1
			map_file.put_string (context.associated_class.name_in_upper + "." + context.current_feature.feature_name + "." + decision_index.out + "." + branch_slot_number.out + "%N")
		ensure
			branch_slot_number_increased: branch_slot_number = old branch_slot_number + 1
		end

	process_then_part_end is
			-- Process at the end of a "Then_part" from a Conditional.
		do
		end

	process_if_else_part_start is
			-- Process at the beginning of a "Else_part" from a Conditional.
		do
			increase_decision_index
			generate_branch_hook (branch_slot_number)
		end

	process_if_else_part_end is
			-- Process at the end of a "Else_part" from a Conditional.
		do
		end

	process_when_part_start is
			-- Process at the beginning of a "When_part" from a Multi_branch instruction.
		do
			increase_decision_index
			generate_branch_hook (branch_slot_number)
		end

	process_when_part_end is
			-- Process at the end of a "When_part" from a Multi_branch_instruction.
		do
		end

	process_inspect_else_part_start is
			-- Process at the beginning of a "Else_part" from a Multi_branch_instruction.
		do
			increase_decision_index
			generate_branch_hook (branch_slot_number)
		end

	process_inspect_else_part_end is
			-- Process at the end of a "Else_part" from a Multi_branch_instruction.
		do
		end

	process_from_part_start is
			-- Process at the beginning of a "Initialization" part from Loop instruction.
		do
		end

	process_from_part_end is
			-- Process at the end of a "Initialization" part from Loop instruction.
		do
		end

	process_loop_body_part_start is
			-- Process at the beginning of a "Loop_body" part from Loop instruction.
		do
			increase_decision_index
			generate_branch_hook (branch_slot_number)
		end

	process_loop_body_part_end is
			-- Process at the end of a "Loop_body" part from Loop instruction.
		do
		end

	process_loop_b (a_node: LOOP_B) is
			-- Process `a_node'.
		do
		end

	process_loop_b_end (a_node: LOOP_B) is
			-- Process after all code of `a_node' has been generated.
		do
			increase_decision_index
			generate_branch_hook (branch_slot_number)
		end

	process_loop_stop_condition_start (a_expr: EXPR_B) is
			-- Process beofre evaluating the stop condition `a_expr' of a loop.
		do
		end

	process_loop_stop_condition_end (a_expr: EXPR_B) is
			-- Process after evaluating the stop condition `a_expr' of a loop.
		do
		end

	process_inspect_b (a_node: INSPECT_B) is
			-- Process `a_node'.
		do
			when_part_stack.extend (0)
		end

	process_inspect_end (a_node: INSPECT_B) is
			-- Process when finishing `a_node'.
		do
		end

	process_case_b (a_node: CASE_B) is
			-- Process `a_node'.
		do
		end

	process_declaration is
			-- Process for possible function or variable declaration.
		do
			context.buffer.put_new_line
			context.buffer.put_string ("extern EIF_INTEGER sat_dcs_count;")
			context.buffer.put_new_line
			context.buffer.put_string ("extern EIF_BOOLEAN sat_dcs_is_enabled;")
			context.buffer.put_new_line
			context.buffer.put_string ("extern time_t sat_dcs_last_flush_time;")
			context.buffer.put_new_line
		end

	process_initialization is
			-- Process for possible C code generation for current instrument strategy.
		do
			context.buffer.put_new_line
			context.buffer.put_string ("sat_dcs_count = " + branch_slot_number.out + ";")
			context.buffer.put_new_line
			context.buffer.put_string ("sat_dcs_is_enabled = EIF_TRUE;")
			context.buffer.put_new_line
			context.buffer.put_string ("time (&sat_dcs_last_flush_time);")
			context.buffer.put_new_line
		end

	process_header_file_initialization is
			-- Process for possible needed C header files
		do
			context.buffer.put_new_line
			context.buffer.put_string ("#include %"eif_main.h%"")
			context.buffer.put_new_line
			context.buffer.put_string ("#include %"time.h%"")
			context.buffer.put_new_line
		end

feature{NONE} -- Implementation

	generate_branch_hook (a_slot_number: INTEGER) is
			-- Generate branch hook for `a_slot_number'.
		local
			l_buffer: GENERATION_BUFFER
		do
			l_buffer := context.buffer
			l_buffer.indent
			l_buffer.put_new_line
			l_buffer.put_string (branch_hook_l_paran)
			l_buffer.put_string (a_slot_number.out)
			l_buffer.put_string (");")
			l_buffer.exdent
			l_buffer.put_new_line
		end

	condition_stack: LINKED_STACK [INTEGER]
			-- Stack of condition index

	loop_stack: LINKED_STACK [INTEGER]
			-- Stack of loop index

	loop_decision_index: INTEGER is
			-- Decision index in `loop_stack'
		require
			not_loop_stack_is_empty: not loop_stack.is_empty
		do
			Result := loop_stack.item
		ensure
			good_result: Result = loop_stack.item
		end

	when_part_stack: LINKED_STACK [INTEGER]
			-- Stack of when part

feature{NONE} -- Hooks

	branch_hook_l_paran: STRING is "SATDCS("

	decision_index: INTEGER
			-- Index of decision

	condition_index: INTEGER is
			-- Index of condition
		require
			not_stack_is_empty: not condition_stack.is_empty
		do
			Result := condition_stack.item
		ensure
			good_result: Result = condition_stack.item
		end

	increase_condition_index is
			-- Increase `condition_index' by 1.
		require
			not_stack_is_empty: not condition_stack.is_empty
		local
			l_new_condition_stack: INTEGER
			l_stack: like condition_stack
		do
			l_stack := condition_stack
			l_new_condition_stack := l_stack.item + 1
			l_stack.remove
			l_stack.extend (l_new_condition_stack)
		ensure
			condition_index_increased: condition_index = old condition_index + 1
		end

	leave_decision is
			-- Leave current decision.
		do
			condition_stack.remove
		end

end
