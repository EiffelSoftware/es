indexing
	description: "[
			Generated C code instrumentor
			]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SAT_INSTRUMENTOR

inherit
	SHARED_BYTE_CONTEXT

	BYTE_NODE_NULL_VISITOR
		undefine
			process_if_b,
			process_loop_b,
			process_inspect_b,
			process_case_b
		end

feature -- Status report

	should_generate_conditional_else_part: BOOLEAN is
			-- Should else part of a conditional always be generated?
		do
			Result := True
		end

	should_generate_inspect_else_part: BOOLEAN is
			-- Should else part of an inspect statement always be generated?
		do
			Result := True
		end

	is_instrumentation_enabled: BOOLEAN is
			-- Should instrumentation be generated?
		do
			Result := True
		end

feature -- Data clearing

	reset is
			-- Reset
		deferred
		end

	clear_feature_data is
			-- Clear data related to currently processing feature.
		deferred
		end

feature -- Byte node processing

	process_rescue_entry is
			-- Process when a rescue clause is entered.
		deferred
		end

	process_feature_entry is
			-- Process when a feature is entered.			
		deferred
		end

	process_header_file_initialization is
			-- Process for possible needed C header files
		deferred
		end

	process_declaration is
			-- Process for possible function or variable declaration.
		deferred
		end

	process_initialization is
			-- Process for possible C code generation for current instrument strategy.
		deferred
		end

	process_if_b (a_node: IF_B) is
			-- Process `a_node'.
		deferred
		end

	process_then_part_condition_start (a_expr: EXPR_B) is
			-- Process before the evaluation of the condition `a_expr' of some `Then_part' from Conditional instruction.
		require
			a_expr_attached: a_expr /= Void
		deferred
		end

	process_then_part_condition_end (a_expr: EXPR_B) is
			-- Process after the evaluation of the condition `a_expr' of some `Then_part' from Conditional instruction.
		require
			a_expr_attached: a_expr /= Void
		deferred
		end

	process_then_part_start is
			-- Process at the beginning of a "Then_part" from a Conditional.
		deferred
		end

	process_then_part_end is
			-- Process at the end of a "Then_part" from a Conditional.
		deferred
		end

	process_if_else_part_start is
			-- Process at the beginning of a "Else_part" from a Conditional.
		deferred
		end

	process_if_else_part_end is
			-- Process at the end of a "Else_part" from a Conditional.
		deferred
		end

	process_when_part_start is
			-- Process at the beginning of a "When_part" from a Multi_branch instruction.
		deferred
		end

	process_when_part_end is
			-- Process at the end of a "When_part" from a Multi_branch_instruction.
		deferred
		end

	process_inspect_else_part_start is
			-- Process at the beginning of a "Else_part" from a Multi_branch_instruction.
		deferred
		end

	process_inspect_else_part_end is
			-- Process at the end of a "Else_part" from a Multi_branch_instruction.
		deferred
		end

	process_from_part_start is
			-- Process at the beginning of a "Initialization" part from Loop instruction.
		deferred
		end

	process_from_part_end is
			-- Process at the end of a "Initialization" part from Loop instruction.
		deferred
		end

	process_loop_body_part_start is
			-- Process at the beginning of a "Loop_body" part from Loop instruction.
		deferred
		end

	process_loop_body_part_end is
			-- Process at the end of a "Loop_body" part from Loop instruction.
		deferred
		end

	process_loop_b (a_node: LOOP_B) is
			-- Process `a_node'.
		deferred
		end

	process_loop_b_end (a_node: LOOP_B) is
			-- Process after all code of `a_node' has been generated.
		deferred
		end

	process_loop_stop_condition_start (a_expr: EXPR_B) is
			-- Process beofre evaluating the stop condition `a_expr' of a loop.
		require
			a_expr_attached: a_expr /= Void
		deferred
		end

	process_loop_stop_condition_end (a_expr: EXPR_B) is
			-- Process after evaluating the stop condition `a_expr' of a loop.
		require
			a_expr_attached: a_expr /= Void
		deferred
		end

	process_inspect_end (a_node: INSPECT_B) is
			-- Process when finishing `a_node'.
		require
			a_node_attached: a_node /= Void
		deferred
		end

end

