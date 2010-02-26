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

	make (a_expressions: like expressions; a_class: like class_; a_feature: like feature_) is
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

	expressions: AFX_STATE_SKELETON
			-- Expressions to be evaluate

	on_hit_actions: LINKED_LIST [PROCEDURE [ANY, TUPLE [a_breakpoint: BREAKPOINT; a_state: AFX_STATE]]]
			-- List of actions to be performed when current is hit

	class_: CLASS_C
			-- Class from which Current state is derived

	feature_: detachable FEATURE_I
			-- Feature from which Current state is derived
			-- If Void, it means that Current state is derived for the whole class,
			-- instead of particular feature.

feature -- Basic operations

	execute (a_bp: BREAKPOINT; a_dm: DEBUGGER_MANAGER)
		local
			l_exprs: like expressions
			l_value: DUMP_VALUE
			l_concrete_state: AFX_STATE
			l_state_value: AFX_EQUATION
			l_actions: like on_hit_actions
			l_cursor: CURSOR
		do
			l_exprs := expressions
			create l_concrete_state.make (l_exprs.count, class_, feature_)

				-- Evaluate `expressions'.
			from
				l_exprs.start
			until
				l_exprs.after
			loop
				l_value := a_dm.expression_evaluation (l_exprs.item_for_iteration.text)
				create l_state_value.make (l_exprs.item_for_iteration, expression_value_from_dump (l_value))
				l_concrete_state.force_last (l_state_value)
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
				l_actions.item_for_iteration.call ([a_bp, l_concrete_state])
				l_actions.forth
			end
			l_actions.go_to (l_cursor)
		end

	expression_value_from_dump (a_dump_value: detachable DUMP_VALUE): EPA_EXPRESSION_VALUE
			-- Expression value from `a_dump_value'
		do
			if a_dump_value = Void or else a_dump_value.is_invalid_value then
				create {EPA_NONSENSICAL_VALUE} Result

			elseif a_dump_value.is_type_boolean then
				create {EPA_BOOLEAN_VALUE} Result.make (a_dump_value.output_for_debugger.to_boolean)

			elseif a_dump_value.is_type_integer_32 then
				create {EPA_INTEGER_VALUE} Result.make (a_dump_value.output_for_debugger.to_integer)

			elseif a_dump_value.is_void then
				create {EPA_VOID_VALUE} Result.make

			elseif a_dump_value.is_type_object then
				create {EPA_ANY_VALUE} Result.make (a_dump_value.string_representation)
			else
				check False end
			end
		end

end
