note
	description: "Class to manage expressions to be evaluated by the debugger for a feature"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER

inherit
	SHARED_DEBUGGER_MANAGER

create
	make

feature{NONE} -- Initialization

	make (a_class: like class_; a_feature: like feature_) is
			-- Initialize Current.
		do
			class_ := a_class
			feature_ := a_feature
			create expressions.make (initial_capacity)
			create hit_actions.make (initial_capacity)
		end

feature -- Access

	class_: CLASS_C
			-- Class from which Current state is derived

	feature_: FEATURE_I
			-- Feature from which break points are put

	expressions: HASH_TABLE [DS_HASH_SET [EPA_EXPRESSION], BREAKPOINT_LOCATION]
			-- Breakpoints where the debuggee should be stopped and expressions should be evaluated.
			-- Key is the breakpoint, value is the state consisting expressions to be evaluated
			-- at the breakpoint.

	hit_actions: HASH_TABLE [LINKED_LIST [EPA_BREAKPOINT_WHEN_HITS_ACTION_EVALUATION], BREAKPOINT_LOCATION]
			-- Actions to perform when a breakpoint is hit.
			-- Key is the breakpoint, value is a list of actions to perform when that breakpoint is hit.
			-- When a break point is hit, the expressions registered in `expressions' for that break point are evaluated,
			-- and the values are passed to the actions.

feature -- Basic operations

	set_all_breakpoints_with_expression_and_actions (a_expressions: DS_HASH_SET [EPA_EXPRESSION]; a_action: PROCEDURE [ANY, TUPLE [a_bp: BREAKPOINT; a_state: EPA_STATE]])
			-- Set `a_action' to all break points to `a_feature'.
			-- Every time when the breakpoint is hit, all expressions in `a_expressions' are evaluated and
			-- their values are passed to `a_action' through the argument `a_state'.
		require
			a_expressions_attached: a_expressions /= Void
		local
			l_slot_count: INTEGER
			i: INTEGER
		do
			l_slot_count := feature_.number_of_breakpoint_slots
			from
				i := 1
			until
				i > l_slot_count
			loop
				set_breakpoint_with_expression_and_action (i, a_expressions, a_action)
				i := i + 1
			end
		end

	set_breakpoint_with_expression_and_action (a_bpslot: INTEGER; a_expressions: DS_HASH_SET [EPA_EXPRESSION]; a_action: PROCEDURE [ANY, TUPLE [a_bp: BREAKPOINT; a_state: EPA_STATE]])
			-- Set `a_action' to `a_bpslot'-th break point in `a_feature'.
			-- Every time when the breakpoint is hit, all expressions in `a_expressions' are evaluated and
			-- their values are passed to `a_action' through the argument `a_state'.
		require
			a_expressions_attached: a_expressions /= Void
		local
			l_bp_location: BREAKPOINT_LOCATION
			l_slot_count: INTEGER
			l_act_list: LINKED_LIST [EPA_BREAKPOINT_WHEN_HITS_ACTION_EXPR_EVALUATION]
			l_action:EPA_BREAKPOINT_WHEN_HITS_ACTION_EXPR_EVALUATION
		do
			create l_act_list.make
			create l_action.make (a_expressions, class_, feature_)
			l_action.on_hit_actions.extend (a_action)
			l_act_list.extend (l_action)
			l_bp_location := breakpoints_manager.breakpoint_location (feature_.e_feature, a_bpslot, False)
			hit_actions.force (l_act_list, l_bp_location)
			expressions.force (a_expressions, l_bp_location)
		end

	set_breakpoint_with_agent_and_action (a_bpslot: INTEGER; a_expression_retriever: FUNCTION [ANY, TUPLE, DS_HASH_SET [EPA_EXPRESSION]]; a_action: PROCEDURE [ANY, TUPLE [a_bp: BREAKPOINT; a_state: EPA_STATE]])
			-- Set `a_action' to `a_bpslot'-th break point in `a_feature'.
			-- Every time when the breakpoint is hit, all expressions returned by `a_expression_retriever' are evaluated and
			-- their values are passed to `a_action' through the argument `a_state'.
		local
			l_bp_location: BREAKPOINT_LOCATION
			l_slot_count: INTEGER
			l_act_list: LINKED_LIST [EPA_BREAKPOINT_WHEN_HITS_ACTION_EVALUATION]
			l_action:EPA_BREAKPOINT_WHEN_HITS_ACTION_AGENT_EVALUATION
			l_exprs: DS_HASH_SET [EPA_EXPRESSION]
		do
			create l_act_list.make
			create l_action.make (a_expression_retriever, class_, feature_)
			l_action.on_hit_actions.extend (a_action)
			l_act_list.extend (l_action)
			l_bp_location := breakpoints_manager.breakpoint_location (feature_.e_feature, a_bpslot, False)
			hit_actions.force (l_act_list, l_bp_location)
			create l_exprs.make (0)
			expressions.force (l_exprs, l_bp_location)
		end

	set_all_breakpoints_with_agent_and_actions (a_expression_retriever: FUNCTION [ANY, TUPLE, DS_HASH_SET [EPA_EXPRESSION]]; a_action: PROCEDURE [ANY, TUPLE [a_bp: BREAKPOINT; a_state: EPA_STATE]])
			-- Set `a_action' to all break points to `a_feature'.
			-- Every time when the breakpoint is hit, all expressions in `a_expressions' are evaluated and
			-- their values are passed to `a_action' through the argument `a_state'.
		local
			l_slot_count: INTEGER
			i: INTEGER
		do
			l_slot_count := feature_.number_of_breakpoint_slots
			from
				i := 1
			until
				i > l_slot_count
			loop
				set_breakpoint_with_agent_and_action (i, a_expression_retriever, a_action)
				i := i + 1
			end
		end

	wipe_out
			-- Clear `expressions' and `hit_actions'.
		do
			toggle_breakpoints (False)
			expressions.wipe_out
			hit_actions.wipe_out
		end

	toggle_breakpoints (b: BOOLEAN)
			-- If `b' is True, enabled break points to evaluate `expressions'; otherwise, disable those break points.
		local
			l_bps: like expressions
			l_bp_manager: BREAKPOINTS_MANAGER
			l_bp: BREAKPOINT_LOCATION
			l_routine: E_FEATURE
			l_bpslot: INTEGER
			l_actions: detachable LINKED_LIST [BREAKPOINT_WHEN_HITS_ACTION_I]
		do
			l_bp_manager := debugger_manager.breakpoints_manager
			l_bps := expressions
			from
				l_bps.start
			until
				l_bps.after
			loop
				l_bp := l_bps.key_for_iteration
				l_routine := l_bp.routine
				l_bpslot := l_bp.breakable_line_number
				l_actions := hit_actions.item (l_bp)
				if b then
					l_bp_manager.set_user_breakpoint (l_routine, l_bpslot)
					l_bp_manager.breakpoint_at (l_bp, False).set_continue_execution (True)

					if l_actions /= Void then
						l_actions.do_all (agent (l_bp_manager.breakpoint_at (l_bp, False)).add_when_hits_action)
					end
				else
					l_bp_manager.remove_user_breakpoint (l_routine, l_bpslot)
					if l_actions /= Void then
						l_actions.do_all (agent (l_bp_manager.breakpoint_at (l_bp, False)).remove_when_hits_action)
					end
				end
				l_bps.forth
			end
			l_bp_manager.notify_breakpoints_changes
		end

feature{NONE} -- Implementation

	initial_capacity: INTEGER is 10
			-- Initial capacity for `breakpoints' and `hit_actions'

invariant

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
