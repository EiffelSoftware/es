note
	description: "Class to evaluate a set of expressions in at a break point. That set of expressions are retrieved through an agent"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_BREAKPOINT_WHEN_HITS_ACTION_AGENT_EVALUATION

inherit
	EPA_BREAKPOINT_WHEN_HITS_ACTION_EVALUATION

	EPA_DEBUGGER_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_expression_retriever: like expression_retriever; a_class: like class_; a_feature: like feature_) is
			-- Initialize Current.
		do
			class_ := a_class
			feature_ := a_feature
			expression_retriever := a_expression_retriever
			create on_hit_actions.make
		end

feature -- Access

	expression_retriever: FUNCTION [ANY, TUPLE, DS_HASH_SET [EPA_EXPRESSION]]
			-- Agent to fetch expressions to be evaluate

feature -- Basic operations

	execute (a_bp: BREAKPOINT; a_dm: DEBUGGER_MANAGER)
		local
			l_exprs: DS_HASH_SET [EPA_EXPRESSION]
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_concrete_state: EPA_STATE
			l_state_value: EPA_EQUATION
		do

			l_exprs := expression_retriever.item (Void)
			create l_concrete_state.make (l_exprs.count, class_, feature_)

				-- Evaluate `expressions'.
			from
				l_cursor := l_exprs.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				create l_state_value.make (l_cursor.item, evaluated_value_from_debugger (a_dm, l_cursor.item))
				l_concrete_state.force_last (l_state_value)
				l_cursor.forth
			end

				-- Call agents.
			on_hit_actions.call ([a_bp, l_concrete_state])
		end

end
