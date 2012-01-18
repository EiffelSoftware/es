note
	description: "Invokes a callback everytime a hole is identified within the AST."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_HOLE_CALLBACK_ITERATOR

inherit
	AST_ITERATOR
		redefine
			process_expr_call_as,
			process_instr_call_as
		end

	EXT_HOLE_UTILITY
		export
			{NONE} all
		end

	REFACTORING_HELPER

feature -- Access

	on_expr_hole: ROUTINE [ANY, TUPLE [a_hole: STRING]]
		assign set_on_expr_hole
			-- Callback agent triggered when an expression hole is identified.

	set_on_expr_hole (a_action: like on_expr_hole)
			-- Assigner for `on_expr_hole'.
		require
			a_action_not_void: attached a_action
		do
			on_expr_hole := a_action
		end

	on_instr_hole: ROUTINE [ANY, TUPLE [a_hole: STRING]]
		assign set_on_instr_hole
			-- Callback agent triggered when an expression hole is identified.

	set_on_instr_hole (a_action: like on_instr_hole)
			-- Assigner for `on_instr_hole'.
		require
			a_action_not_void: attached a_action
		do
			on_expr_hole := a_action
		end

	set_on_hole (a_action: like on_instr_hole)
			-- Assigns both `on_expr_hole' and `on_instr_hole' with the same callback.
		require
			a_action_not_void: attached a_action
		do
			on_expr_hole := a_action
			on_instr_hole := a_action
		end

feature {NONE} -- Access Recording

	process_expr_call_as (l_as: EXPR_CALL_AS)
			-- Recording hole identifier.
		do
				-- Invoke callback agent if configured.
			if is_hole (l_as) and attached on_expr_hole then
				on_expr_hole.call ([get_hole_name(l_as)])
			end
			Precursor (l_as)
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
			-- Recording hole identifier.
		do
				-- Invoke callback agent if configured.
			if is_hole (l_as) and attached on_instr_hole then
				on_instr_hole.call ([get_hole_name(l_as)])
			end
			Precursor (l_as)
		end

end
