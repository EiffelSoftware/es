note
	description: "Initializes the breakpoint_slot attributes in AST nodes."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_BP_SLOT_INITIALIZER

inherit
	ETR_UNIFORM_VISITOR
		rename
			process as init_from
		redefine
			init_from,
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
			process_inline_agent_creation_as
		end
	REFACTORING_HELPER
		export
			{NONE} all
		end
	ETR_SHARED_TOOLS

feature -- Operation

	init_from (a_node: AST_EIFFEL)
			-- Init breakpoint slots in `a_node' and its children
		do
			init_with_context (a_node, void)
		end

	init_with_context (a_node: AST_EIFFEL; a_context: like context)
			-- Init breakpoint slots in `a_node' and its children using `a_context' to handle inherited breakpoints
		require
			non_void: a_node /= void
		do
			context := a_context
			is_in_breakpoint_slot := false
			current_breakpoint_slot := 1

			process_and_check (a_node)
		end

feature {AST_EIFFEL} -- Roundtrip

	process_inline_agent_creation_as (l_as: INLINE_AGENT_CREATION_AS)
		local
			l_last_breakpoint: like current_breakpoint_slot
		do
			l_last_breakpoint := current_breakpoint_slot
			current_breakpoint_slot := 1
			is_in_breakpoint_slot := false
			is_in_inline_agent := true
			safe_process_and_check(l_as.body)
			is_in_inline_agent := false
			current_breakpoint_slot := l_last_breakpoint

			is_in_breakpoint_slot := true
			safe_process_and_check (l_as.operands)
		end

	process_feature_as (l_as: FEATURE_AS)
		do
			if attached context and then attached context.feature_named (l_as.feature_name.name) as l_feat then
				current_feature := l_feat
			end

			Precursor(l_as)
			current_feature := void
		end

	process_tagged_as (l_as: TAGGED_AS)
		do
			assign_current_slot (l_as)
			is_in_breakpoint_slot := true
			Precursor(l_as)
			is_in_breakpoint_slot := false
			current_breakpoint_slot := current_breakpoint_slot + 1
		end

	process_inspect_as (l_as: INSPECT_AS)
		local
			i: INTEGER
		do
			assign_current_slot (l_as)
			process_in_slot (l_as.switch)
			current_breakpoint_slot := current_breakpoint_slot + 1

			safe_process_and_check (l_as.case_list)
			safe_process_and_check (l_as.else_part)
		end

	process_retry_as (l_as: RETRY_AS)
		do
			assign_current_slot (l_as)
			current_breakpoint_slot := current_breakpoint_slot + 1
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
			assign_current_slot (l_as)
			is_in_breakpoint_slot := true
			Precursor(l_as)
			is_in_breakpoint_slot := false
			current_breakpoint_slot := current_breakpoint_slot + 1
		end

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
		do
			assign_current_slot (l_as)
			is_in_breakpoint_slot := true
			Precursor(l_as)
			is_in_breakpoint_slot := false
			current_breakpoint_slot := current_breakpoint_slot + 1
		end

	process_if_as (l_as: IF_AS)
		do
			assign_current_slot (l_as)
			process_in_slot (l_as.condition)
			current_breakpoint_slot := current_breakpoint_slot + 1
			safe_process_and_check (l_as.compound)
			safe_process_and_check (l_as.elsif_list)
			safe_process_and_check (l_as.else_part)
		end

	process_assign_as (l_as: ASSIGN_AS)
		do
			assign_current_slot (l_as)
			is_in_breakpoint_slot := true
			Precursor(l_as)
			is_in_breakpoint_slot := false
			current_breakpoint_slot := current_breakpoint_slot + 1
		end

	process_reverse_as (l_as: REVERSE_AS)
		do
			assign_current_slot (l_as)
			is_in_breakpoint_slot := true
			Precursor(l_as)
			is_in_breakpoint_slot := false
			current_breakpoint_slot := current_breakpoint_slot + 1
		end

	process_elseif_as (l_as: ELSIF_AS)
		do
			assign_current_slot (l_as)
			is_in_breakpoint_slot := true
			safe_process_and_check (l_as.expr)
			is_in_breakpoint_slot := false
			current_breakpoint_slot := current_breakpoint_slot + 1
			safe_process_and_check (l_as.compound)
		end

	process_loop_as (l_as: LOOP_AS)
		do
			safe_process_and_check(l_as.from_part)
			safe_process_and_check(l_as.invariant_part)
			if l_as.variant_part /= void then
				process_in_slot(l_as.variant_part)
				current_breakpoint_slot := current_breakpoint_slot + 1
			end

			process_in_slot (l_as.stop)
			current_breakpoint_slot := current_breakpoint_slot + 1

			safe_process_and_check(l_as.compound)
		end

	process_routine_as (l_as: ROUTINE_AS)
		do
			safe_process_and_check (l_as.obsolete_message)

			if not is_in_inline_agent and current_feature /= void then
				current_breakpoint_slot := contract_tools.inherited_precondition_count (current_feature)+1
			else
				current_breakpoint_slot := 1
			end

			safe_process_and_check (l_as.precondition)
			safe_process_and_check (l_as.locals)
			safe_process_and_check (l_as.routine_body)

			if not is_in_inline_agent and current_feature /= void then
				current_breakpoint_slot := contract_tools.inherited_postcondition_count (current_feature)
			end

			safe_process_and_check (l_as.postcondition)
			safe_process_and_check (l_as.rescue_clause)

			-- Breakpoint slot at the end of a routine
			assign_current_slot (l_as)
			current_breakpoint_slot := current_breakpoint_slot + 1
		end

feature {NONE} -- Implementation

	assign_current_slot (l_as: AST_EIFFEL)
			-- Assign current slot to `l_as'
		do
			l_as.set_breakpoint_slot (current_breakpoint_slot)
		end

	context: detachable CLASS_C
			-- The class the ast belongs to

	current_feature: detachable FEATURE_I
			-- The feature we're currently in

	is_in_inline_agent: BOOLEAN
			-- Are we currently processing an inline-agent

	process_in_slot(l_as: AST_EIFFEL)
			-- Process `l_as' in the current breakpoint slot
		do
			is_in_breakpoint_slot := true
			process_and_check (l_as)
			is_in_breakpoint_slot := false
		end

	is_in_breakpoint_slot: BOOLEAN
			-- Currently inside a breakpoint slot

	current_breakpoint_slot: INTEGER
			-- The current breakpoint slot

	safe_process_and_check (a_node: AST_EIFFEL)
		do
			if a_node /= void then
				process_node (a_node)
				a_node.process (Current)
			end
		end

	process_and_check (a_node: AST_EIFFEL)
		do
			process_node (a_node)
			a_node.process (Current)
		end

	process_node (a_node: AST_EIFFEL)
			-- <precursor>
		do
			if is_in_breakpoint_slot then
				assign_current_slot (a_node)
			end
		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
