note
	description: "Summary description for {AFX_EXECUTION_TRACE_STATISTICS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EXECUTION_TRACE_STATISTIC

inherit
	DS_HASH_TABLE [DS_HASH_TABLE [REAL, EPA_EXPRESSION], INTEGER]

create
	make_from_trace

feature -- Initialization

	make_from_trace (a_trace: AFX_PROGRAM_EXECUTION_TRACE)
			-- Initialization.
		require
			trace_attached: a_trace /= Void
		do
			make (30)
			trace := a_trace
			add_all_data_points (a_trace)
		end

feature -- Access

	trace: AFX_PROGRAM_EXECUTION_TRACE
			-- Trace from which the statistics is produced.

	id: STRING
			-- Id of the associated trace.
		do
			Result := trace.id
		end

	statistic_at_data_point_in_expr (a_expression: EPA_EXPRESSION; a_bp_index: INTEGER): REAL
			-- Statistic regarding the expression `a_expression' at `a_bp_index'.
			-- Using `is_equal' to compare equality. Pay attention to polymorphism.
			-- If no statistic data available, return 0.
		local
			l_table: DS_HASH_TABLE [REAL, EPA_EXPRESSION]
		do
			if has (a_bp_index) then
				l_table := item (a_bp_index)
				if l_table.has (a_expression) then
					Result := l_table.item (a_expression)
				end
			end
		end

	statistic_at_data_point_in_text (a_expression_text: STRING; a_bp_index: INTEGER): REAL
			-- Statistic regarding the expression `a_expression_text' at `a_bp_index'.
			-- If no statistic data available, return 0.
		local
			l_table: DS_HASH_TABLE [REAL, EPA_EXPRESSION]
			l_expr: EPA_EXPRESSION
			l_found: BOOLEAN
		do
			if has (a_bp_index) then
				l_table := item (a_bp_index)
				from l_table.start
				until l_found or else l_table.after
				loop
					l_expr := l_table.key_for_iteration
					if l_expr.text ~ a_expression_text then
						Result := l_table.item_for_iteration
						l_found := True
					end
					l_table.forth
				end
			end
		end

feature -- Status report

	is_passing: BOOLEAN
			-- Is current statistic for a passing execution?
		require
			trace_attached: trace /= Void
		do
			Result := trace.is_passing
		end

	is_failing: BOOLEAN
			-- Is current statistic for a failing execution?
		require
			trace_attached: trace /= VOid
		do
			Result := trace.is_failing
		end

	is_expression_in_text_hit (a_expression_text: STRING; a_bp_index: INTEGER): BOOLEAN
			-- Is expression in text hit at breakpoint `a_bp_index'?
		do
			Result := statistic_at_data_point_in_text (a_expression_text, a_bp_index) > 0
		end

	is_expression_in_expr_hit (a_expr: EPA_EXPRESSION; a_bp_index: INTEGER): BOOLEAN
			-- Is expression hit at breakpoint `a_bp_index'.
		do
			Result := statistic_at_data_point_in_expr (a_expr, a_bp_index) > 0
		end

feature{NONE} -- Implementation

	add_all_data_points (a_trace: like trace)
			-- Add all data points to the statistics.
		require
			trace_attached: a_trace /= Void
		local
			l_state: AFX_PROGRAM_EXECUTION_STATE
		do
			from a_trace.start
			until a_trace.after
			loop
				add_data_point (a_trace.item_for_iteration)

				a_trace.forth
			end
		end

	add_data_point (a_state: AFX_PROGRAM_EXECUTION_STATE)
			-- Add one data point to the statistics.
		require
			state_attached: a_state /= Void
		local
			l_bp_index: INTEGER
			l_state: EPA_STATE
			l_table: DS_HASH_TABLE [REAL, EPA_EXPRESSION]
			l_equation: EPA_EQUATION
			l_expression: EPA_EXPRESSION
			l_value: EPA_EXPRESSION_VALUE
			l_count: REAL
		do
			l_bp_index := a_state.breakpoint_slot_index
			l_state := a_state.state

			ensure_breakpoint_entry (l_bp_index, l_state.count)
			l_table := item (l_bp_index)

			from l_state.start
			until l_state.after
			loop
				l_equation := l_state.item_for_iteration

				l_expression := l_equation.expression
				l_value := l_equation.value

				check boolean_value: l_value.is_boolean end
				-- Update statistics if the value is "True".
				if l_value.as_boolean.item then
					if l_table.has (l_expression) then
						l_count := l_table.item (l_expression)
						l_count := l_count + 1
						l_table.replace (l_count, l_expression)
					else
						l_table.force (1.0, l_expression)
					end
				end

				l_state.forth
			end
		end

	ensure_breakpoint_entry (a_bp_index: INTEGER; a_size: INTEGER)
			-- Ensure that the statistics includes an entry, of size `a_size', for `a_bp_index'.
		local
			l_table: DS_HASH_TABLE [REAL, EPA_EXPRESSION]
		do
			if not has (a_bp_index) then
				create l_table.make_equal (a_size)
				force (l_table, a_bp_index)
			end
		end
end
