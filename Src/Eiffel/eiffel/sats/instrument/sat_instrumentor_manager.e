indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_INSTRUMENTOR_MANAGER

inherit
	SAT_INSTRUMENTOR
		rename
			is_instrumentation_enabled as is_instrument_enabled_in_class
		redefine
			is_instrument_enabled_in_class,
			process_if_b

		end

create
	make

feature{NONE} -- Initialization

	make is
			-- Initialize.
		do
			create {LINKED_LIST [SAT_INSTRUMENTOR]} instrumentors.make
		end

feature -- Access

	instrumentors: LIST [SAT_INSTRUMENTOR]
			-- List of registered instrumentors.

	veto_instrumentation_function: FUNCTION [ANY, TUPLE, BOOLEAN]
			-- Function to veto instrumentation
			-- If this function is false or returns true, instrumentation is generated,
			-- otherwise, instrumentation is not generated.

feature -- Status report

	instrumentor_count: INTEGER is
			-- Number of registered instrumentor.
		do
			Result := instrumentors.count
		ensure
			good_result: Result = instrumentors.count
		end

	is_instrument_enabled: BOOLEAN
			-- Is instrument enabled?

	is_instrument_enabled_in_class: BOOLEAN is
			-- Should instrumentation be generated?
		do
			Result := veto_instrumentation_function = Void
			if not Result then
				Result := veto_instrumentation_function.item (Void)
			end
		end

	has_instrumentor (a_instrumentor: SAT_INSTRUMENTOR): BOOLEAN is
			-- Is `a_instrumentor' registered in `instrumentor'?
		require
			a_instrumentor_attached: a_instrumentor /= Void
		do
			Result := not instrumentors.has (a_instrumentor)
		ensure
			good_result: Result = not instrumentors.has (a_instrumentor)
		end

feature -- Instrumentor registeration

	register_instrumentor (a_instrumentor: SAT_INSTRUMENTOR) is
			-- Register `a_instrumentor' into `instrumentors'.
		require
			a_instrumentor_attached: a_instrumentor /= Void
			not_a_instrumentor_registered: not has_instrumentor (a_instrumentor)
		do
			instrumentors.extend (a_instrumentor)
		ensure
			a_instrumentor_registered: has_instrumentor (a_instrumentor)
		end

	remove_instrumentor (a_instrumentor: SAT_INSTRUMENTOR) is
			-- Remove `a_instrumentor' from `instrumentors'.
		require
			a_instrumentor_attached: a_instrumentor /= Void
			a_instrumentor_registered: has_instrumentor (a_instrumentor)
		do
			instrumentors.start
			instrumentors.search (a_instrumentor)
			instrumentors.remove
		ensure
			a_instrumentor_removed: not has_instrumentor (a_instrumentor)
		end

feature -- Setting

	set_is_instrument_enabled (b: BOOLEAN) is
			-- Set `is_instrument_enabled' with `b'.
		do
			is_instrument_enabled := b
		ensure
			is_instrument_enabled_set: is_instrument_enabled = b
		end

	set_veto_instrumentation_function (a_function: like veto_instrumentation_function) is
			-- Set `veto_instrumentation_function' with `a_function'.
		do
			veto_instrumentation_function := a_function
		ensure
			veto_instrumentation_function_set: veto_instrumentation_function = a_function
		end

feature -- Data clearing

	reset is
			-- Reset
		do
			instrumentors.do_all (agent (a_instrumentor: SAT_INSTRUMENTOR) do a_instrumentor.reset end)
		end

	clear_feature_data is
			-- Clear data related to currently processing feature.
		do
			instrumentors.do_all (agent (a_instrumentor: SAT_INSTRUMENTOR) do a_instrumentor.clear_feature_data end)
		end

feature -- Byte node processing

	process_if_b (a_node: IF_B) is
			-- Process `a_node'.
		do
			if is_instrument_enabled_in_class then
				instrumentors.do_all (agent a_node.process ({SAT_INSTRUMENTOR}?))
			end
		end

	process_then_part_condition_start (a_expr: EXPR_B) is
			-- Process before the evaluation of the condition `a_expr' of some `Then_part' from Conditional instruction.
		local
			l_instrumentors: like instrumentors
			l_cursor: CURSOR
		do
			if is_instrument_enabled_in_class then
				l_instrumentors := instrumentors
				l_cursor := l_instrumentors.cursor
				from
					l_instrumentors.start
				until
					l_instrumentors.after
				loop
					l_instrumentors.item.process_then_part_condition_start (a_expr)
					l_instrumentors.forth
				end
				l_instrumentors.go_to (l_cursor)
			end
		end

	process_then_part_condition_end (a_expr: EXPR_B) is
			-- Process after the evaluation of the condition `a_expr' of some `Then_part' from Conditional instruction.
		local
			l_instrumentors: like instrumentors
			l_cursor: CURSOR
		do
			if is_instrument_enabled_in_class then
				l_instrumentors := instrumentors
				l_cursor := l_instrumentors.cursor
				from
					l_instrumentors.start
				until
					l_instrumentors.after
				loop
					l_instrumentors.item.process_then_part_condition_end (a_expr)
					l_instrumentors.forth
				end
				l_instrumentors.go_to (l_cursor)
			end
		end

	process_then_part_start is
			-- Process at the beginning of a "Then_part" from a Conditional.
		do
			if is_instrument_enabled_in_class then
				instrumentors.do_all (agent (a_ins: SAT_INSTRUMENTOR) do a_ins.process_then_part_start end)
			end
		end

	process_then_part_end is
			-- Process at the end of a "Then_part" from a Conditional.
		do
			if is_instrument_enabled_in_class then
				instrumentors.do_all (agent (a_ins: SAT_INSTRUMENTOR) do a_ins.process_then_part_end end)
			end
		end

	process_if_else_part_start is
			-- Process at the beginning of a "Else_part" from a Conditional.
		do
			if is_instrument_enabled_in_class then
				instrumentors.do_all (agent (a_ins: SAT_INSTRUMENTOR) do a_ins.process_if_else_part_start end)
			end
		end

	process_if_else_part_end is
			-- Process at the end of a "Else_part" from a Conditional.
		do
			if is_instrument_enabled_in_class then
				instrumentors.do_all (agent (a_ins: SAT_INSTRUMENTOR) do a_ins.process_if_else_part_end end)
			end
		end

	process_when_part_start is
			-- Process at the beginning of a "When_part" from a Multi_branch instruction.
		do
			if is_instrument_enabled_in_class then
				instrumentors.do_all (agent (a_ins: SAT_INSTRUMENTOR) do a_ins.process_when_part_start end)
			end
		end

	process_when_part_end is
			-- Process at the end of a "When_part" from a Multi_branch_instruction.
		do
			if is_instrument_enabled_in_class then
				instrumentors.do_all (agent (a_ins: SAT_INSTRUMENTOR) do a_ins.process_when_part_end end)
			end
		end

	process_inspect_else_part_start is
			-- Process at the beginning of a "Else_part" from a Multi_branch_instruction.
		do
			if is_instrument_enabled_in_class then
				instrumentors.do_all (agent (a_ins: SAT_INSTRUMENTOR) do a_ins.process_inspect_else_part_start end)
			end
		end

	process_inspect_else_part_end is
			-- Process at the end of a "Else_part" from a Multi_branch_instruction.
		do
			if is_instrument_enabled_in_class then
				instrumentors.do_all (agent (a_ins: SAT_INSTRUMENTOR) do a_ins.process_inspect_else_part_end end)
			end
		end

	process_from_part_start is
			-- Process at the beginning of a "Initialization" part from Loop instruction.
		do
			if is_instrument_enabled_in_class then
				instrumentors.do_all (agent (a_ins: SAT_INSTRUMENTOR) do a_ins.process_from_part_start end)
			end
		end

	process_from_part_end is
			-- Process at the end of a "Initialization" part from Loop instruction.
		do
			if is_instrument_enabled_in_class then
				instrumentors.do_all (agent (a_ins: SAT_INSTRUMENTOR) do a_ins.process_from_part_end end)
			end
		end

	process_loop_body_part_start is
			-- Process at the beginning of a "Loop_body" part from Loop instruction.
		do
			if is_instrument_enabled_in_class then
				instrumentors.do_all (agent (a_ins: SAT_INSTRUMENTOR) do a_ins.process_loop_body_part_start end)
			end
		end

	process_loop_body_part_end is
			-- Process at the end of a "Loop_body" part from Loop instruction.
		do
			if is_instrument_enabled_in_class then
				instrumentors.do_all (agent (a_ins: SAT_INSTRUMENTOR) do a_ins.process_loop_body_part_end end)
			end
		end

	process_loop_b (a_node: LOOP_B) is
			-- Process `a_node'.
		do
			if is_instrument_enabled_in_class then
				instrumentors.do_all (agent a_node.process ({SAT_INSTRUMENTOR}?))
			end
		end

	process_loop_b_end (a_node: LOOP_B) is
			-- Process after all code of `a_node' has been generated.
		local
			l_instrumentors: like instrumentors
			l_cursor: CURSOR
		do
			if is_instrument_enabled_in_class then
				l_instrumentors := instrumentors
				l_cursor := l_instrumentors.cursor
				from
					l_instrumentors.start
				until
					l_instrumentors.after
				loop
					l_instrumentors.item.process_loop_b_end (a_node)
					l_instrumentors.forth
				end
				l_instrumentors.go_to (l_cursor)
			end
		end

	process_loop_stop_condition_start (a_expr: EXPR_B) is
			-- Process beofre evaluating the stop condition `a_expr' of a loop.
		local
			l_instrumentors: like instrumentors
			l_cursor: CURSOR
		do
			if is_instrument_enabled_in_class then
				l_instrumentors := instrumentors
				l_cursor := l_instrumentors.cursor
				from
					l_instrumentors.start
				until
					l_instrumentors.after
				loop
					l_instrumentors.item.process_loop_stop_condition_start (a_expr)
					l_instrumentors.forth
				end
				l_instrumentors.go_to (l_cursor)
			end
		end

	process_loop_stop_condition_end (a_expr: EXPR_B) is
			-- Process after evaluating the stop condition `a_expr' of a loop.
		local
			l_instrumentors: like instrumentors
			l_cursor: CURSOR
		do
			if is_instrument_enabled_in_class then
				l_instrumentors := instrumentors
				l_cursor := l_instrumentors.cursor
				from
					l_instrumentors.start
				until
					l_instrumentors.after
				loop
					l_instrumentors.item.process_loop_stop_condition_end (a_expr)
					l_instrumentors.forth
				end
				l_instrumentors.go_to (l_cursor)
			end
		end

	process_inspect_b (a_node: INSPECT_B) is
			-- Process `a_node'.
		do
			if is_instrument_enabled_in_class then
				instrumentors.do_all (agent a_node.process ({SAT_INSTRUMENTOR}?))
			end
		end

	process_inspect_end (a_node: INSPECT_B) is
			-- Process when finishing `a_node'.
		do
			if is_instrument_enabled_in_class then
				instrumentors.do_all (agent a_node.process ({SAT_INSTRUMENTOR}?))
			end
		end

	process_case_b (a_node: CASE_B) is
			-- Process `a_node'.
		do
			if is_instrument_enabled_in_class then
				instrumentors.do_all (agent a_node.process ({SAT_INSTRUMENTOR}?))
			end
		end

	process_header_file_initialization is
			-- Process for possible needed C header files
		local
			l_instrumentors: like instrumentors
			l_cursor: CURSOR
		do
			if is_instrument_enabled then
				l_instrumentors := instrumentors
				l_cursor := l_instrumentors.cursor
				from
					l_instrumentors.start
				until
					l_instrumentors.after
				loop
					l_instrumentors.item.process_header_file_initialization
					l_instrumentors.forth
				end
				l_instrumentors.go_to (l_cursor)
			end
		end

	process_initialization is
			-- Process for possible C code generation for current instrument strategy.
		local
			l_instrumentors: like instrumentors
			l_cursor: CURSOR
		do
			if is_instrument_enabled then
				l_instrumentors := instrumentors
				l_cursor := l_instrumentors.cursor
				from
					l_instrumentors.start
				until
					l_instrumentors.after
				loop
					l_instrumentors.item.process_initialization
					l_instrumentors.forth
				end
				l_instrumentors.go_to (l_cursor)
			end
		end

	process_declaration is
			-- Process for possible function or variable declaration.
		local
			l_instrumentors: like instrumentors
			l_cursor: CURSOR
		do
			if is_instrument_enabled then
				l_instrumentors := instrumentors
				l_cursor := l_instrumentors.cursor
				from
					l_instrumentors.start
				until
					l_instrumentors.after
				loop
					l_instrumentors.item.process_declaration
					l_instrumentors.forth
				end
				l_instrumentors.go_to (l_cursor)
			end
		end

invariant
	instrumentors_attached: instrumentors /= Void

end
