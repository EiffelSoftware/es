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
		ensure
			expressions_set: expressions = a_expressions
		end

feature -- Access

	expressions: AFX_STATE
			-- Expressions to be evaluate

feature -- Basic operations

	execute (a_bp: BREAKPOINT; a_dm: DEBUGGER_MANAGER)
		local
			l_exprs: like expressions
			l_value: DUMP_VALUE
		do
			l_exprs := expressions
			from
				l_exprs.start
			until
				l_exprs.after
			loop
				l_value := a_dm.expression_evaluation (l_exprs.item_for_iteration.text)
				io.put_string ("BP_" + a_bp.breakable_line_number.out + "  ")
				io.put_string (l_exprs.key_for_iteration + " : ")
				io.put_string (l_value.output_for_debugger)
				io.put_string ("%N")
				l_exprs.forth
			end
		end

end
