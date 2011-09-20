note
	description: "Summary description for {AFX_STATE_CHANGE_REQUIREMENT_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_STATE_CHANGE_REQUIREMENT_GENERATOR

inherit
	AFX_SHARED_SESSION

create
	default_create

feature -- Access

	last_generated_requirements: DS_ARRAYED_LIST [AFX_STATE_CHANGE_REQUIREMENT]
			-- Generated requirements from last generation.
		do
			if last_generated_requirements_cache = Void then
				create last_generated_requirements_cache.make (2)
			end
			Result := last_generated_requirements_cache
		ensure
			result_attached: Result /= Void
		end

feature -- Basic operation

	generate_change_requirements (a_target: AFX_FIXING_TARGET)
			-- Generate change requirements for `a_target'.
			-- Make the result requirements available in `last_generated_requirements'.
		require
			target_attached: a_target /= Void
		local
			l_target_expressions: EPA_HASH_SET [EPA_EXPRESSION]
			l_requirements: like last_generated_requirements
			l_server: AFX_SERVER_PROGRAM_STATE_SKELETON
			l_skeleton: EPA_STATE_SKELETON
			l_state_aspect: AFX_PROGRAM_STATE_ASPECT
		do
			set_current_fixing_target (a_target)
			l_skeleton := exception_recipient_feature.derived_state_skeleton
			if l_skeleton.has (a_target.expression) and then attached {AFX_PROGRAM_STATE_ASPECT} a_target.expression as lv_aspect then
				last_generated_requirements.append_last (lv_aspect.derived_change_requirements (False))
			end
--			l_skeleton := derived_state_skeleton_for_feature (exception_spot.recipient_class_, exception_spot.recipient_)
--			if a_target.expressions.count = 1 and then attached a_target.expressions.first.text as lvt_text and then l_skeleton.has (lvt_text) then
--				l_state_aspect := l_skeleton.item (a_target.expressions.first.text)
--				last_generated_requirements.append_last (l_state_aspect.derived_change_requirements (False))
--			end

--			l_target_expressions := a_target.expressions
--			if l_target_expressions.count = 1 then
--				generate_for_one_expression
--			else
--				generate_for_two_expression
--			end
		end

--	generate_for_two_expression
--			-- Generate change requirements for two expressions.
--			-- In this case, the two expressions are both of type {INTEGER},
--			--		and one of them may be a constant.
--		local
--			l_target_expressions: EPA_HASH_SET [EPA_EXPRESSION]
--			l_expr1, l_expr2: EPA_EXPRESSION
--			l_new_expr: EPA_AST_EXPRESSION
--			l_requirement: AFX_STATE_CHANGE_REQUIREMENT
--			l_requirements: DS_LINKED_LIST[TUPLE[expr1: EPA_EXPRESSION; expr2: EPA_EXPRESSION]]
--		do
--			l_target_expressions := current_fixing_target.expressions
--			check has_one_expression: l_target_expressions.count = 2 end

--			l_expr1 := l_target_expressions.first
--			l_expr2 := l_target_expressions.last
--			check both_integer: l_expr1.type.is_integer and then l_expr2.type.is_integer end

--			create l_requirements.make
--			last_generated_requirements.resize (16)

--			-- Change the second expression alone.
--			create l_new_expr.make_with_text (l_expr2.class_, l_expr2.feature_, l_expr2.text + " + 1", l_expr2.written_class)
--			l_requirements.force_last ([l_expr2, l_new_expr])

--			create l_new_expr.make_with_text (l_expr2.class_, l_expr2.feature_, l_expr2.text + " - 1", l_expr2.written_class)
--			l_requirements.force_last ([l_expr2, l_new_expr])

--			-- Change the first expression alone.
--			create l_new_expr.make_with_text (l_expr1.class_, l_expr1.feature_, l_expr1.text + " + 1", l_expr1.written_class)
--			l_requirements.force_last ([l_expr1, l_new_expr])

--			create l_new_expr.make_with_text (l_expr1.class_, l_expr1.feature_, l_expr1.text + " - 1", l_expr1.written_class)
--			l_requirements.force_last ([l_expr1, l_new_expr])

--			-- Change the second according to the first.
--			create l_new_expr.make_with_text (l_expr2.class_, l_expr2.feature_, l_expr1.text, l_expr2.written_class)
--			l_requirements.force_last ([l_expr2, l_new_expr])

--			create l_new_expr.make_with_text (l_expr2.class_, l_expr2.feature_, l_expr1.text + " + 1", l_expr2.written_class)
--			l_requirements.force_last ([l_expr2, l_new_expr])

--			create l_new_expr.make_with_text (l_expr2.class_, l_expr2.feature_, l_expr1.text + " - 1", l_expr2.written_class)
--			l_requirements.force_last ([l_expr2, l_new_expr])

--			-- Change the first according to the second.
--			create l_new_expr.make_with_text (l_expr1.class_, l_expr1.feature_, l_expr2.text, l_expr1.written_class)
--			l_requirements.force_last ([l_expr1, l_new_expr])

--			create l_new_expr.make_with_text (l_expr1.class_, l_expr1.feature_, l_expr2.text + " + 1", l_expr1.written_class)
--			l_requirements.force_last ([l_expr1, l_new_expr])

--			create l_new_expr.make_with_text (l_expr1.class_, l_expr1.feature_, l_expr2.text + " - 1", l_expr1.written_class)
--			l_requirements.force_last ([l_expr1, l_new_expr])

----			create l_new_expr.make_with_text (l_expr1.class_, l_expr1.feature_, "0", l_expr1.written_class, l_expr1.breakpoint_slot)
----			l_requirements.force_last ([l_expr1, l_new_expr])

----			create l_new_expr.make_with_text (l_expr1.class_, l_expr1.feature_, "1", l_expr1.written_class, l_expr1.breakpoint_slot)
----			l_requirements.force_last ([l_expr1, l_new_expr])

----			create l_new_expr.make_with_text (l_expr1.class_, l_expr1.feature_, "-1", l_expr1.written_class, l_expr1.breakpoint_slot)
----			l_requirements.force_last ([l_expr1, l_new_expr])

----			create l_new_expr.make_with_text (l_expr2.class_, l_expr2.feature_, "0", l_expr2.written_class, l_expr2.breakpoint_slot)
----			l_requirements.force_last ([l_expr2, l_new_expr])

----			create l_new_expr.make_with_text (l_expr2.class_, l_expr2.feature_, "1", l_expr2.written_class, l_expr2.breakpoint_slot)
----			l_requirements.force_last ([l_expr2, l_new_expr])

----			create l_new_expr.make_with_text (l_expr2.class_, l_expr2.feature_, "-1", l_expr2.written_class, l_expr2.breakpoint_slot)
----			l_requirements.force_last ([l_expr2, l_new_expr])

--			-- Put the change requirements into the list of requirements.
--			from l_requirements.start
--			until l_requirements.after
--			loop
--				create l_requirement.make (l_requirements.item_for_iteration.expr1, l_requirements.item_for_iteration.expr2)
--				last_generated_requirements.force_last (l_requirement)

--				l_requirements.forth
--			end
--		end

--	generate_for_one_expression
--			-- Generate change requirements for one expression.
--			-- In this case, the expression is of type {BOOLEAN}.
--		local
--			l_target_expressions: EPA_HASH_SET [EPA_EXPRESSION]
--			l_expr: EPA_EXPRESSION
--			l_new_expr: EPA_AST_EXPRESSION
--			l_requirement: AFX_STATE_CHANGE_REQUIREMENT
--			l_target: AFX_FIXING_TARGET
--		do
--			l_target_expressions := current_fixing_target.expressions
--			check has_one_expression: l_target_expressions.count = 1 end
--			l_expr := l_target_expressions.first

----			if not l_expr.type.is_boolean then
----				l_target := current_fixing_target.most_relevant_fixing_condition
----				if l_target.expressions /= Void and then not l_target.expressions.is_empty then
----					l_expr := l_target.expressions.first
----				end
----			end

--			if l_expr.type.is_boolean then
--				create l_new_expr.make_with_text (l_expr.class_, l_expr.feature_, "not (" + l_expr.text + ")", l_expr.written_class)
--				create l_requirement.make (l_expr, l_new_expr)
--				last_generated_requirements.force_last (l_requirement)
----			elseif l_expr.type.is_reference then
----				
--			else
--				check should_not_happen: False end
--			end
--		end

feature{NONE} -- Implementation

	current_fixing_target: AFX_FIXING_TARGET assign set_current_fixing_target
			-- Current fixing target.

feature{NONE} -- Status set

	set_current_fixing_target (a_target: AFX_FIXING_TARGET)
			-- Set `current_fixing_target'.
		require
			target_attached: a_target /= Void
		do
			current_fixing_target := a_target
			if not last_generated_requirements.is_empty then
				last_generated_requirements_cache := Void
			end
		ensure
			target_assigned: current_fixing_target = a_target
			requirements_empty: last_generated_requirements.is_empty
		end

feature -- Cache

	last_generated_requirements_cache: like last_generated_requirements
			-- Cache for `last_generated_requirements'.

end
