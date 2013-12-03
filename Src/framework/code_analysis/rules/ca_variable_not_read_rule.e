note
	description: "Summary description for {CA_VARIABLE_NOT_READ_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_VARIABLE_NOT_READ_RULE

inherit
	CA_CFG_RULE
		redefine check_feature end

	AST_ITERATOR
		redefine
			process_assign_as
		end

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
		do
			Precursor (a_class, a_feature)

				-- After we have done the fixed point iteration on the Control Flow Graph
				-- we iterate again through the AST in order to search for dead
				-- assignments.
			process_feature_as (a_feature.ast)
		end

feature {NONE} -- From {AST_ITERATOR}

	process_assign_as (a_assign: ASSIGN_AS)
		do

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
				l_lv.subtract (extract_assigned (l_assign.target))
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
				if attached {ACCESS_ID_AS} l_expr_call.call as l_aid then
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

	extract_assigned (a_assign: ACCESS_AS): LINKED_SET [INTEGER]
		require
			is_assignment: (attached {ASSIGN_AS} a_assign)
		do
			create Result.make

			if attached {ACCESS_ID_AS} a_assign as l_id and then l_id.is_local then
					-- Something is assigned to a local variable.
				Result.extend (l_id.feature_name.name_id)
					-- TODO: Result?
			end
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
