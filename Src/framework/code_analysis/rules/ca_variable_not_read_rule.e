note
	description: "Summary description for {CA_VARIABLE_NOT_READ_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_VARIABLE_NOT_READ_RULE

inherit
	CA_CFG_RULE
		redefine check_feature, id end

create
	make

feature {NONE} -- Initialization

	make
		do
			is_enabled_by_default := True
			create {CA_WARNING} severity
			create violations.make
		end

feature {NONE} -- From {CA_CFG_RULE}

	check_feature (a_class: CLASS_C; a_feature: E_FEATURE)
		local
			l_assigned_id: INTEGER
			l_viol: CA_RULE_VIOLATION
		do
			Precursor (a_class, a_feature)

				-- Iterate through all assignment in search for dead assignments.
			across assignment_nodes as l_assigns loop
				if attached {ASSIGN_AS} l_assigns.item.instruction as l_assign then
					l_assigned_id := extract_assigned (l_assign.target)
					if not lv_exit.at (l_assigns.item.label).has (l_assigned_id) then
						create l_viol.make_with_rule (Current)
						l_viol.set_location (l_assign.start_location)
						l_viol.long_description_info.extend (l_assign.target.access_name_32)
						violations.extend (l_viol)
					end
				end
			end
		end

feature -- Node Visitor

	initialize_processing (a_cfg: CA_CFG)
		local
			n, j: INTEGER
		do
			n := a_cfg.max_label

			create lv_entry.make (n)
			create lv_exit.make (n)
			create assignment_nodes.make

			from j := 1
			until j > n
			loop
				lv_entry.extend (create {LINKED_SET [INTEGER]}.make)
				lv_exit.extend (create {LINKED_SET [INTEGER]}.make)
				j := j + 1
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
			else
				Result := process_default (a_from.label) or Result
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

	process_default (a_from: INTEGER): BOOLEAN
		local
			l_old_count: INTEGER
		do
			l_old_count := lv_entry.at (a_from).count
			lv_entry.at (a_from).copy (lv_exit.at (a_from))
			Result := (l_old_count /= lv_entry.at (a_from).count)
		end

	process_assignment (a_from: CA_CFG_INSTRUCTION): BOOLEAN
		local
			l_old_count, l_assigned_id: INTEGER
			l_lv: LINKED_SET [INTEGER]
		do
			l_old_count := lv_entry.at (a_from.label).count

			create l_lv.make
			l_lv.copy (lv_exit.at (a_from.label))
			if attached {ASSIGN_AS} a_from.instruction as l_assign then
				l_assigned_id := extract_assigned (l_assign.target)
				l_lv.prune (l_assigned_id)
				l_lv.merge (extract_generated (l_assign.source))
					-- Make sure the node is stored for later lookup:
				if l_assigned_id /= -1 then
					assignment_nodes.extend (a_from)
				end
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

			if attached {ID_AS} a_condition as l_id then
				Result.extend (l_id.name_id)
			elseif attached {BINARY_AS} a_condition as l_bin then
				Result.merge (extract_generated (l_bin.left))
				Result.merge (extract_generated (l_bin.right))
			elseif attached {ARRAY_AS} a_condition as l_array then
				across l_array.expressions as l_e loop
					Result.merge (extract_generated (l_e.item))
				end
			elseif attached {BRACKET_AS} a_condition as l_bracket then
				Result.merge (extract_generated (l_bracket.target))
				across l_bracket.operands as l_op loop
					Result.merge (extract_generated (l_op.item))
				end
			elseif attached {CONVERTED_EXPR_AS} a_condition as l_c then
				Result.merge (extract_generated (l_c.expr))
			elseif attached {EXPR_CALL_AS} a_condition as l_expr_call then
				if attached {ACCESS_ID_AS} l_expr_call.call as l_aid and then l_aid.is_local then
					Result.extend (l_aid.feature_name.name_id)
				end
			elseif attached {OBJECT_TEST_AS} a_condition as l_ot then
				Result.merge (extract_generated (l_ot.expression))
			elseif attached {OPERAND_AS} a_condition as l_op then
				if attached l_op.expression then
					Result.merge (extract_generated (l_op.expression))
				end
			elseif attached {PARAN_AS} a_condition as l_paran then
				Result.merge (extract_generated (l_paran.expr))
			elseif attached {UNARY_AS} a_condition as l_unary then
				Result.merge (extract_generated (l_unary.expr))
				-- TODO: Other types of expressions.
			end
		end

	extract_assigned (a_assign: ACCESS_AS): INTEGER
			-- Extracts the variable ID of the target `a_assign' of an
			-- assignment if a local variable gets assigned. If no local
			-- variable gets assigned then Result = -1.
		require
			is_assignment: (attached {ASSIGN_AS} a_assign)
		do
			Result := -1

			if attached {ACCESS_ID_AS} a_assign as l_id and then l_id.is_local then
					-- Something is assigned to a local variable.
				Result := l_id.feature_name.name_id
					-- TODO: Result?
			end
		end

feature {NONE} -- Analysis data

	lv_entry, lv_exit: ARRAYED_LIST [LINKED_SET [INTEGER]]
			-- Hash table containing a list of name IDs (live variables) for the CFG labels.

	assignment_nodes: LINKED_SET [CA_CFG_INSTRUCTION]

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.variable_not_read_title
		end

	description: STRING_32
		do
			Result :=  ca_names.variable_not_read_description
		end

	id: STRING_32 = "CA020T"
			-- "T" stands for 'under test'.

	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.variable_not_read_violation_1)

			if attached {STRING_32} a_violation.long_description_info.first as l_local then
				a_formatter.add_local (l_local)
			end

			a_formatter.add (ca_messages.variable_not_read_violation_2)
		end

end
