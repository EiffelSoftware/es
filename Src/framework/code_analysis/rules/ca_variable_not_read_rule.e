note
	description: "Summary description for {CA_VARIABLE_NOT_READ_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_VARIABLE_NOT_READ_RULE

inherit
	CA_CFG_RULE

create
	make

feature {NONE} -- Initialization

	make
		do
			is_enabled_by_default := True
			create {CA_WARNING} severity
			create violations.make
		end

feature -- Node Visitor

	initialize_processing (a_cfg: CA_CFG)
		local
			n, j: INTEGER
		do
			n := a_cfg.max_label

			create lv_entry.make (n)
			create lv_exit.make (n)

			from j := 1
			until j > a_cfg.max_label
			loop
				lv_entry.put_i_th (create {LINKED_SET [INTEGER]}.make, j)
				lv_exit.put_i_th (create {LINKED_SET [INTEGER]}.make, j)
			end
		end

	visit_edge (a_from, a_to: CA_CFG_BASIC_BLOCK): BOOLEAN
		local
			l_from, l_to: INTEGER
		do
			l_from := a_from.label
			l_to := a_to.label

			Result := node_union (l_from, l_to)

			if attached {CA_CFG_INSTRUCTION} a_from as l_instr then
				Result := process_assignment (l_instr) or Result
			elseif attached {CA_CFG_IF} a_from as l_if then
				Result := process_if (l_if) or Result
			elseif attached {CA_CFG_LOOP} a_from as l_loop then
				Result := process_loop (l_loop) or Result
			elseif attached {CA_CFG_INSPECT} a_from as l_inspect then
				Result := process_inspect (l_inspect) or Result
			end
		end

feature {NONE} -- Implementation

	node_union (a_from, a_to: INTEGER): BOOLEAN
		local
			l_old_count: INTEGER
		do
			l_old_count := lv_exit.at (a_from).count
			lv_exit.at (a_from).merge (lv_entry.at (a_to))
			Result := (l_old_count /= lv_exit.at (a_from).count)
		end

	process_assignment (a_from: CA_CFG_INSTRUCTION): BOOLEAN
		local
			l_old_count: INTEGER
			l_lv: LINKED_SET [INTEGER]
		do
			l_old_count := lv_entry.at (a_from.label).count

			create l_lv.make
			l_lv.copy (lv_exit.at (a_from.label))
			if attached {ASSIGN_AS} a_from.instruction as l_assign then
				l_lv.subtract (extract_assigned (l_assign))
				l_lv.merge (extract_generated (l_assign.source))
			elseif attached {ASSIGNER_CALL_AS} a_from.instruction as l_assign then
				l_lv.subtract (extract_assigned (l_assign))
				l_lv.merge (extract_generated (l_assign.source))
			end
			lv_entry.at (a_from.label).merge (l_lv)

			Result := (l_old_count /= lv_entry.at (a_from.label).count)
		end

	process_if (a_from: CA_CFG_IF): BOOLEAN
			-- Adds to lv_entry (`a_from'): lv_exit (`a_from') with gen's added.
			-- If something could be added then Result = True, otherwise False.
		local
			l_old_count: INTEGER
		do
			l_old_count := lv_entry.at (a_from.label).count
			lv_entry.at (a_from.label).copy (lv_exit.at (a_from.label))
			lv_entry.at (a_from.label).merge (extract_generated (a_from.condition))
			Result := (l_old_count /= lv_entry.at (a_from.label).count)
		end

	process_loop (a_from: CA_CFG_LOOP): BOOLEAN
		local
			l_old_count: INTEGER
		do
			l_old_count := lv_entry.at (a_from.label).count
			lv_entry.at (a_from.label).copy (lv_exit.at (a_from.label))
			lv_entry.at (a_from.label).merge (extract_generated (a_from.stop_condition))
			Result := (l_old_count /= lv_entry.at (a_from.label).count)
		end

	process_inspect (a_from: CA_CFG_INSPECT): BOOLEAN
		local
			l_old_count: INTEGER
		do
			l_old_count := lv_entry.at (a_from.label).count
			lv_entry.at (a_from.label).copy (lv_exit.at (a_from.label))
			lv_entry.at (a_from.label).merge (extract_generated (a_from.expression))
			Result := (l_old_count /= lv_entry.at (a_from.label).count)
		end

	extract_generated (a_condition: EXPR_AS): LINKED_SET [INTEGER]
		do
			create Result.make
		end

	extract_assigned (a_assign: INSTRUCTION_AS): LINKED_SET [INTEGER]
		do
			create Result.make
		end

feature {NONE} -- Analysis data

	lv_entry, lv_exit: ARRAYED_LIST [LINKED_SET [INTEGER]]
			-- Hash table containing a list of name IDs (live variables) for the CFG labels.

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.variable_not_read_title
		end

	description: STRING_32
		do
			Result :=  "---"
		end

	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		do

		end

end
