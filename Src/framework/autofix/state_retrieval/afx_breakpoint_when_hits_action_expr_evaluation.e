note
	description: "Summary description for {AFX_BREAKPOINT_WHEN_HITS_ACTION_EXPR_EVALUATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BREAKPOINT_WHEN_HITS_ACTION_EXPR_EVALUATION

inherit
	BREAKPOINT_WHEN_HITS_ACTION_I

create
	make

feature{NONE} -- Initialization

	make (a_expressions: like expressions) is
			-- Initialize Current.
		do
			expressions := a_expressions
			create on_hit_actions.make
		ensure
			expressions_set: expressions = a_expressions
		end

feature -- Access

	expressions: AFX_STATE_MODEL
			-- Expressions to be evaluate

	on_hit_actions: LINKED_LIST [PROCEDURE [ANY, TUPLE [a_concrete_state: AFX_CONCRETE_STATE]]]
			-- List of actions to be performed when current is hit

feature -- Basic operations

	execute (a_bp: BREAKPOINT; a_dm: DEBUGGER_MANAGER)
		local
			l_exprs: like expressions
			l_value: DUMP_VALUE
			l_concrete_state: AFX_CONCRETE_STATE
			l_state_value: AFX_STATE_ITEM_VALUE
			l_actions: like on_hit_actions
			l_cursor: CURSOR
		do
			l_exprs := expressions
			create l_concrete_state.make (l_exprs.count)
			l_concrete_state.set_breakpoint (a_bp.location)

				-- Evaluate `expressions'.
			from
				l_exprs.start
			until
				l_exprs.after
			loop
				l_value := a_dm.expression_evaluation (l_exprs.item_for_iteration.text)
				create l_state_value.make (l_exprs.item_for_iteration, l_value)
				l_concrete_state.put (l_state_value, l_exprs.item_for_iteration)
				l_exprs.forth
			end

				-- Call agents.
			l_actions := on_hit_actions
			l_cursor := l_actions.cursor
			from
				l_actions.start
			until
				l_actions.after
			loop
				l_actions.item_for_iteration.call ([l_concrete_state])
				l_actions.forth
			end
			l_actions.go_to (l_cursor)
		end

end
