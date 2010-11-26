note
	description: "[
		Action to be performed when a break point is hit
		The action is to evaluate a set of expressions.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_BREAKPOINT_WHEN_HITS_ACTION_EXPR_EVALUATION

inherit
	EPA_BREAKPOINT_WHEN_HITS_ACTION_EVALUATION

	EPA_DEBUGGER_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_expressions: like expressions; a_class: like class_; a_feature: like feature_)
			-- Initialize Current.
		require
			a_expressions_attached: a_expressions /= Void
		do
			class_ := a_class
			feature_ := a_feature
			expressions := a_expressions
			create on_hit_actions.make
		ensure
			expressions_set: expressions = a_expressions
		end

feature -- Access

	expressions: DS_HASH_SET [EPA_EXPRESSION]
			-- Expressions to be evaluate
		note
     		option: transient
   		attribute
   		end

feature -- Basic operations

	execute (a_bp: BREAKPOINT; a_dm: DEBUGGER_MANAGER)
		local
			l_exprs: like expressions
			l_concrete_state: EPA_STATE
			l_state_value: EPA_EQUATION
		do
			l_exprs := expressions
			create l_concrete_state.make (l_exprs.count, class_, feature_)

				-- Evaluate `expressions'.
			from
				l_exprs.start
			until
				l_exprs.after
			loop
				create l_state_value.make (l_exprs.item_for_iteration, evaluated_value_from_debugger (a_dm, l_exprs.item_for_iteration))
				l_concrete_state.force_last (l_state_value)
				l_exprs.forth
			end

				-- Call agents.
			on_hit_actions.call ([a_bp, l_concrete_state])
		end

end
