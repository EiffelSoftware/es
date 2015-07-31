note
	description: "Object that represents a inspect branching block in a CFG."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_INSPECT_BRANCHING_BLOCK

inherit
	EPA_BRANCHING_BLOCK
		redefine
			condition
		end

create
	make

feature {NONE} -- Initialization

	make (a_id: INTEGER; a_switch: like switch; a_intervals: like intervals)
			-- Initialize Current.
		local
			l_cond_str: STRING
			l_switch_str: STRING
			l_cursor: CURSOR
			l_interval: INTERVAL_AS
			l_count: INTEGER
		do
			create asts.make (initial_capacity)

			set_id (a_id)
			switch := a_switch
			intervals := a_intervals

			create l_cond_str.make (64)

			l_cursor := a_intervals.cursor
			from
				l_count := a_intervals.count
				a_intervals.start
			until
				a_intervals.after
			loop
				l_cond_str.append (switch_condition (a_switch, a_intervals.item_for_iteration))
				if a_intervals.index < l_count then
					l_cond_str.append (once " or ")
				end
				a_intervals.forth
			end
			a_intervals.go_to (l_cursor)

			expression_parser.set_syntax_version (expression_parser.provisional_syntax)
			expression_parser.parse_from_string_32 (once "check " + l_cond_str, class_)
			if attached {EXPR_AS} expression_parser.expression_node as l_cond then
				condition := l_cond
			else
				check should_not_happen: False end
			end
			asts.extend (condition)
			initialize_predecessors_and_successors
		ensure
			condition_attached: condition /= Void
		end

feature -- Access

	switch_condition (a_switch: EXPR_AS; a_interval: INTERVAL_AS): STRING
			-- A string representing the condition for `a_switch' and `a_internval'
		local
			l_switch_str: STRING
		do
			l_switch_str := text_from_ast (a_switch)
			create Result.make (64)
			Result.append_character ('(')
			if attached {ATOMIC_AS} a_interval.upper as l_upper then
				Result.append_character ('(')
				Result.append (a_interval.lower.string_value)
				Result.append (") <= (")
				Result.append (l_switch_str)
				Result.append (") and (")
				Result.append (l_switch_str)
				Result.append (") <= ")
				Result.append (l_upper.string_value)

			else
				Result.append_character ('(')
				Result.append (l_switch_str)
				Result.append (") = ")
				Result.append (a_interval.lower.string_value)
			end
			Result.append_character (')')
		end

	condition: EXPR_AS
			-- Condition on which execution branches

	switch: EXPR_AS
			-- Switch of the inspect statement

	intervals: ARRAYED_LIST [INTERVAL_AS]
			-- Interval of current case

feature -- Visitor

	process (a_visitor: EPA_CFG_BLOCK_VISITOR)
			-- Visitor feature.
		do
			a_visitor.process_inspect_branching_block (Current)
		end

end
