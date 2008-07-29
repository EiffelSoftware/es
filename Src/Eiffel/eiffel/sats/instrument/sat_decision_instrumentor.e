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
			config_sections
		end

	SHARED_WORKBENCH

	PROJECT_CONTEXT

	SAT_SHARED_INSTRUMENTATION

create
	make

feature{NONE} -- Initialization

	make is
			-- Initialize.
		do
				-- Initialize `config_sections'.
			create {LINKED_LIST [STRING]} config_sections.make
			config_sections.extend (dcs_section_name)
		end

feature -- Status report

	is_instrument_enabled: BOOLEAN is
			-- Should instrumentation be generated?
		do
			Result := config.there_exists (agent {SAT_INSTRUMENT_CONFIG}.is_instrument_enabled (context))
		end

feature -- Data clearing

	reset is
			-- Reset
		do
			branch_slot_number := 0
			decision_index := 0
			config.wipe_out
		ensure then
			branch_slot_number_is_zero: branch_slot_number = 0
			decision_index_is_zero: decision_index = 0
		end

	clear_feature_data is
			-- Clear data related to currently processing feature.
		do
			decision_index := 0
		ensure then
			decision_index_is_zero: decision_index = 0
		end

feature -- Byte node processing

	process_rescue_entry is
			-- Process when a rescue clause is entered.
		do
		end

	process_feature_entry is
			-- Process when a feature is entered.			
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
			generate_instrument
		end

	process_then_part_end is
			-- Process at the end of a "Then_part" from a Conditional.
		do
		end

	process_if_else_part_start is
			-- Process at the beginning of a "Else_part" from a Conditional.
		do
			generate_instrument
		end

	process_if_else_part_end is
			-- Process at the end of a "Else_part" from a Conditional.
		do
		end

	process_when_part_start is
			-- Process at the beginning of a "When_part" from a Multi_branch instruction.
		do
			generate_instrument
		end

	process_when_part_end is
			-- Process at the end of a "When_part" from a Multi_branch_instruction.
		do
		end

	process_inspect_else_part_start is
			-- Process at the beginning of a "Else_part" from a Multi_branch_instruction.
		do
			generate_instrument
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
			generate_instrument
		end

	process_loop_body_part_end is
			-- Process at the end of a "Loop_body" part from Loop instruction.
		do
		end

	process_loop_b_end (a_node: LOOP_B) is
			-- Process after all code of `a_node' has been generated.
		do
			generate_instrument
		end

	process_loop_stop_condition_start (a_expr: EXPR_B) is
			-- Process beofre evaluating the stop condition `a_expr' of a loop.
		do
		end

	process_loop_stop_condition_end (a_expr: EXPR_B) is
			-- Process after evaluating the stop condition `a_expr' of a loop.
		do
		end

	process_inspect_end (a_node: INSPECT_B) is
			-- Process when finishing `a_node'.
		do
		end

	process_declaration is
			-- Process for possible function or variable declaration.
		do
			context.buffer.put_new_line
			context.buffer.put_string ("extern EIF_INTEGER sat_dcs_slot_count;")
			context.buffer.put_new_line
			context.buffer.put_string ("extern EIF_BOOLEAN sat_dcs_is_enabled;")
			context.buffer.put_new_line
		end

	process_initialization is
			-- Process for possible C code generation for current instrument strategy.
		do
			context.buffer.put_new_line
			context.buffer.put_string ("sat_dcs_slot_count = " + branch_slot_number.out + ";")
			context.buffer.put_new_line
			context.buffer.put_string ("sat_dcs_is_enabled = EIF_TRUE;")
			context.buffer.put_new_line
		end

	process_header_file_initialization is
			-- Process for possible needed C header files
		do
			context.buffer.put_new_line
			context.buffer.put_string ("#include %"eif_main.h%"")
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

feature{NONE} -- Implementation

	branch_hook_l_paran: STRING is "SATDCS("

	decision_index: INTEGER
			-- Index of decision

	branch_slot_number: INTEGER
			-- 0-based Slot number for branches, used to locate the position of a particular covered branch in source code.			
			-- It is 0-based because the C array used in run-time is 0-based.

	increase_decision_index is
			-- Increase `branch_slot_number' by one.
		do
			branch_slot_number := branch_slot_number + 1
			decision_index := decision_index + 1
		ensure
			branch_slot_number_increased: branch_slot_number = old branch_slot_number + 1
		end

	store_map_entry is
			-- Generate map information for mapping from branch slot number to class and feature.
		local
			l_buffer: STRING
		do
			create l_buffer.make (128)
			l_buffer.append (dcs_section_name)
			l_buffer.append_character (' ')
			l_buffer.append (context.associated_class.name_in_upper)
			l_buffer.append_character ('.')
			l_buffer.append (context.current_feature.feature_name)
			l_buffer.append_character ('%T')
			l_buffer.append ("local_id=")
			l_buffer.append (decision_index.out)
			l_buffer.append_character ('%T')
			l_buffer.append ("global_id=")
			l_buffer.append (branch_slot_number.out)
			l_buffer.append_character ('%N')
			log_string_in_map_file (l_buffer)
		end

	generate_instrument is
			-- Generate next branch slot instrument.
		do
			if is_instrument_enabled then
				generate_branch_hook (branch_slot_number)
				store_map_entry
				increase_decision_index
			end
		end

feature{NONE} -- Config file analysis

	config_analyzer_reset is
			-- Reset Current analyzer and prepare it for a new analysis.
		do
		end

	process_config_record (a_section_name: STRING; a_record_line: STRING) is
			-- Process record line text in `a_record_line'.
			-- This record line is in one of the section defined in `sections'.
		do
			config.extend (instrument_config_from_string (a_record_line))
		end

	config_sections: LIST [STRING]
			-- List of name of sections that Current analyzer is interested in.
			-- Only data in sections contained in this list will be passed to Current analyzer.
			-- Section names are case-sensitive.

invariant
	config_sections_attached: config_sections /= Void

end
