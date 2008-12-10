indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_FEATURE_ACCESS_INSTRUMENTOR

inherit
	SAT_INSTRUMENTOR
		redefine
			config_sections
		end

	SAT_SHARED_INSTRUMENTATION

create
	make

feature{NONE} -- Initialization

	make is
			-- Initialize Current.
		do
			create {LINKED_LIST [STRING]} config_sections.make
			config_sections.extend (fac_section_name)
			config_sections.extend (setting_section_name)
		end

feature -- Status report

	is_instrument_enabled: BOOLEAN is
			-- Should instrumentation be generated?
		do
			Result :=
				config.there_exists (agent {SAT_INSTRUMENT_CONFIG}.is_instrument_enabled (context)) and then
				not is_auto_test_compiling
		end

feature -- Access

	summary: STRING is
			-- Summary of current instrument status
		do
			Result := fac_section_name + "=" + feature_index.out
		end

feature -- Reset

	reset is
			-- Reset
		do
			feature_index := 0
		ensure then
			feature_index_reset: feature_index = 0
		end

	clear_feature_data is
			-- Clear data related to currently processing feature.
		do
		end

feature -- Basic operation

	process_summary_record (a_section_name: STRING; a_record_line: STRING) is
			-- Process instrument summary line `a_record_line' in section named `a_section_name'.
		local
			l_slot_count: STRING
		do
			l_slot_count := property_table (a_record_line.split ('%T')).item (fac_section_name.as_lower)
			if l_slot_count /= Void and then l_slot_count.is_integer then
				feature_index := l_slot_count.to_integer
			end
		end

feature -- Byte node processing

	process_rescue_entry is
			-- Process when a rescue clause is entered.
		do
--			generate_slot_hook
		end

	process_feature_entry is
			-- Process when a feature is entered.			
		do
			generate_slot_hook
		end

	process_declaration is
			-- Process for possible function or variable declaration.
		do
			context.buffer.put_new_line
			context.buffer.put_string ("extern EIF_INTEGER sat_fac_slot_count;")
			context.buffer.put_new_line
			context.buffer.put_string ("extern EIF_BOOLEAN sat_fac_is_enabled;")
			context.buffer.put_new_line
		end

	process_initialization is
			-- Process for possible C code generation for current instrument strategy.
		do
			context.buffer.put_new_line
			context.buffer.put_string ("sat_fac_slot_count = " + feature_index.out + ";")
			context.buffer.put_new_line
			context.buffer.put_string ("sat_fac_is_enabled = EIF_TRUE;")
			context.buffer.put_new_line
		end

	process_header_file_initialization is
			-- Process for possible needed C header files
		do
			context.buffer.put_new_line
			context.buffer.put_string ("#include %"eif_main.h%"")
			context.buffer.put_new_line
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
		end

	process_then_part_end is
			-- Process at the end of a "Then_part" from a Conditional.
		do
		end

	process_if_else_part_start is
			-- Process at the beginning of a "Else_part" from a Conditional.
		do
		end

	process_if_else_part_end is
			-- Process at the end of a "Else_part" from a Conditional.
		do
		end

	process_if_b_end (a_node: IF_B) is
			-- Process after an entire "if" statement.
		do
		end

	process_when_part_start is
			-- Process at the beginning of a "When_part" from a Multi_branch instruction.
		do
		end

	process_when_part_end is
			-- Process at the end of a "When_part" from a Multi_branch_instruction.
		do
		end

	process_inspect_else_part_start is
			-- Process at the beginning of a "Else_part" from a Multi_branch_instruction.
		do
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
		end

	process_loop_body_part_end is
			-- Process at the end of a "Loop_body" part from Loop instruction.
		do
		end

	process_loop_b_end (a_node: LOOP_B) is
			-- Process after all code of `a_node' has been generated.
		do
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

feature{NONE} -- Implementation

	feature_index: INTEGER
			-- 0-based index of feature which we have processed
			-- Feature index increases through the whole system
			-- It is 0-based because the C array used in run-time is 0-based.

	satfacl: STRING is "SATFAC("
			-- Starting string for feature access coverage

	store_map_file is
			--
		local
			l_buffer: STRING
		do
			create l_buffer.make (128)
			l_buffer.append (fac_section_name)
			l_buffer.append_character (' ')
			l_buffer.append (context.associated_class.name_in_upper)
			l_buffer.append_character ('.')
			l_buffer.append (context.current_feature.feature_name)
			l_buffer.append_character ('%T')
			l_buffer.append ("global_id=")
			l_buffer.append (feature_index.out)
			l_buffer.append_character ('%N')
			log_string_in_map_file (l_buffer)
		end

	increase_feature_index is
			-- Increase `feature_index' by one.
		do
			feature_index := feature_index + 1
		ensure
			feature_index_increased: feature_index = old feature_index + 1
		end

	generate_slot_hook is
			-- Generate next hook to record feature/rescue entry.
		local
			l_buffer: GENERATION_BUFFER
		do
			if is_instrument_enabled then
				l_buffer := context.buffer
				l_buffer.put_new_line
				l_buffer.indent
				l_buffer.put_string (satfacl)
				l_buffer.put_integer (feature_index)
				l_buffer.put_character (')')
				l_buffer.put_character (';')
				l_buffer.put_new_line
				l_buffer.exdent

				store_map_file
				increase_feature_index
			end
		end


feature{NONE} -- Config file analysis

	config_analyzer_reset is
			-- Reset Current analyzer and prepare it for a new analysis.
		do
			config.wipe_out
		end

	process_config_record (a_section_name: STRING; a_record_line: STRING) is
			-- Process record line text in `a_record_line'.
			-- This record line is in one of the section defined in `sections'.
		local
			l_slot_count: STRING
		do
			if a_section_name.is_case_insensitive_equal (fac_section_name) then
					-- We are loading instrument config.
				config.extend (instrument_config_from_string (a_record_line))
			else
					-- We are loading instrument summary.
				check is_auto_test_compiling end
				l_slot_count := property_table (a_record_line.split ('%T')).item (fac_section_name)
				if l_slot_count /= Void and then l_slot_count.is_integer then
					feature_index := l_slot_count.to_integer
				end
			end
		end

	config_sections: LIST [STRING]
			-- List of name of sections that Current analyzer is interested in.
			-- Only data in sections contained in this list will be passed to Current analyzer.
			-- Section names are case-sensitive.

end
