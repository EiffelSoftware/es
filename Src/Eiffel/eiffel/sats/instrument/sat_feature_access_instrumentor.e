indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_FEATURE_ACCESS_INSTRUMENTOR

inherit
	SAT_INSTRUMENTOR

	SAT_SHARED_INSTRUMENTATION


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

feature -- Byte node processing

	process_feature_entry is
			-- Process when a feature is entered.			
		local
			l_buffer: GENERATION_BUFFER
		do
			increase_feature_index
			l_buffer := context.buffer
			l_buffer.put_new_line
			l_buffer.indent
			l_buffer.put_string (satfacl)
			l_buffer.put_integer (feature_index)
			l_buffer.put_character (')')
			l_buffer.put_character (';')
			l_buffer.put_new_line
		end

	process_inspect_b (a_node: INSPECT_B) is
			-- Process `a_node'.
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

	process_loop_b (a_node: LOOP_B) is
			-- Process `a_node'.
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
			-- 1-based index of feature which we have processed

	satfacl: STRING is "SATFAC("
			-- Starting string for feature access coverage

	increase_feature_index is
			-- Increase `feature_index' by one.
		local
			l_buffer: STRING
		do
			feature_index := feature_index + 1
			create l_buffer.make (128)
			l_buffer.append ("FAC ")
			l_buffer.append (context.associated_class.name_in_upper)
			l_buffer.append_character ('.')
			l_buffer.append (context.current_feature.feature_name)
			l_buffer.append_character ('.')
			l_buffer.append (feature_index.out)
			l_buffer.append_character ('%N')
			map_file.put_string (l_buffer)
		ensure
			feature_index_increased: feature_index = old feature_index + 1
		end

end
