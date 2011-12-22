note
	description: "Class to find first and last breakpoint slots of a given AST."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_AST_BP_SLOTS_FINDER

inherit
	AST_ITERATOR
	redefine
			process_if_as,
			process_assign_as,
			process_elseif_as,
			process_inspect_as,
			process_instr_call_as,
			process_assigner_call_as,
			process_retry_as,
			process_loop_as,
			process_reverse_as,
			process_tagged_as,
			process_feature_as,
			process_routine_as,
			process_inline_agent_creation_as,
			process_creation_as
		end

feature -- Basic operation

	find
			-- Find first and last breakpoint slot of the feature body
			-- of `feature_' and make result available in `first_bp_slot'
			-- respectively `last_bp_slot'.
		require
			feature_not_void: feature_ /= Void
			ast_not_void: ast /= Void
		do
			first_bp_slot := feature_.number_of_breakpoint_slots
			last_bp_slot := 0
			ast.process (Current)
		end

feature -- Access

	ast: AST_EIFFEL
			-- AST which should be examined.

	feature_: FEATURE_I
			-- Feature in whose body the first and last breakpoint
			-- slot should be looked for.

	first_bp_slot: INTEGER
			-- First breakpoint slot of the feature body of `ast'

	last_bp_slot: INTEGER
			-- Last breakpoint slot of the feature body of `ast'

feature -- Setting

	set_ast (a_ast: like ast)
			-- Set `ast' to `a_ast'
		require
			a_ast_not_void: a_ast /= Void
		do
			ast := a_ast
		ensure
			ast_set: ast = a_ast
		end

	set_feature (a_feature: like feature_)
			-- Set `feature_' to `a_feature'
		require
			a_feature_not_void: a_feature /= Void
		do
			feature_ := a_feature
		ensure
			feature_set: feature_ = a_feature
		end

feature -- Roundtrip

	process_inline_agent_creation_as (l_as: INLINE_AGENT_CREATION_AS)
			-- Process `l_as'.
		do
			Precursor (l_as)
			adjust_first_last_bp_slot (l_as.breakpoint_slot)
		end

	process_routine_as (l_as: ROUTINE_AS)
		do
			Precursor (l_as)
			adjust_first_last_bp_slot (l_as.breakpoint_slot)
		end

	process_tagged_as (l_as: TAGGED_AS)
		do
			Precursor (l_as)
			adjust_first_last_bp_slot (l_as.breakpoint_slot)
		end

	process_feature_as (l_as: FEATURE_AS)
		do
			Precursor (l_as)
			adjust_first_last_bp_slot (l_as.breakpoint_slot)
		end

	process_assign_as (l_as: ASSIGN_AS)
		do
			Precursor (l_as)
			adjust_first_last_bp_slot (l_as.breakpoint_slot)
		end

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
		do
			Precursor (l_as)
			adjust_first_last_bp_slot (l_as.breakpoint_slot)
		end

	process_reverse_as (l_as: REVERSE_AS)
		do
			Precursor (l_as)
			adjust_first_last_bp_slot (l_as.breakpoint_slot)
		end

	process_creation_as (l_as: CREATION_AS)
		do
			Precursor (l_as)
			adjust_first_last_bp_slot (l_as.breakpoint_slot)
		end

	process_if_as (l_as: IF_AS)
		do
			Precursor (l_as)
			adjust_first_last_bp_slot (l_as.breakpoint_slot)
		end

	process_inspect_as (l_as: INSPECT_AS)
		do
			Precursor (l_as)
			adjust_first_last_bp_slot (l_as.breakpoint_slot)
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
			Precursor (l_as)
			adjust_first_last_bp_slot (l_as.breakpoint_slot)
		end

	process_loop_as (l_as: LOOP_AS)
		do
			Precursor (l_as)
			adjust_first_last_bp_slot (l_as.breakpoint_slot)
		end

	process_retry_as (l_as: RETRY_AS)
		do
			Precursor (l_as)
			adjust_first_last_bp_slot (l_as.breakpoint_slot)
		end

	process_elseif_as (l_as: ELSIF_AS)
		do
			Precursor (l_as)
			adjust_first_last_bp_slot (l_as.breakpoint_slot)
		end

feature {NONE} -- Implementation

	adjust_first_last_bp_slot (a_bp_slot: INTEGER)
			-- Adjust `first_bp_slot' respectively `last_bp_slot' if a
			-- lower respectively higher breakpoint slot is found.
		require
			a_bp_slot_valid: a_bp_slot >= 1
		do
			if a_bp_slot < first_bp_slot then
				first_bp_slot := a_bp_slot
			end
			if a_bp_slot > last_bp_slot then
				last_bp_slot := a_bp_slot
			end
		end

end
