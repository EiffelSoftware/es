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
			process_feature_as
		end
	REFACTORING_HELPER
		export
			{NONE} all
		end

feature -- Operation

	init_from (a_node: AST_EIFFEL)
			-- Init breakpoint slots in `a_node' and its children
		do
			is_in_breakpoint_slot := false
			current_breakpoint_slot := 0

			Precursor(a_node)
		end

feature {AST_EIFFEL} -- Roundtrip

	process_feature_as (l_as: FEATURE_AS)
		do
			current_breakpoint_slot := 0
			Precursor(l_as)
		end

	process_tagged_as (l_as: TAGGED_AS)
		do
			current_breakpoint_slot := current_breakpoint_slot + 1
			l_as.set_breakpoint_slot (current_breakpoint_slot)
			is_in_breakpoint_slot := true
			Precursor(l_as)
			is_in_breakpoint_slot := false
		end

	process_inspect_as (l_as: INSPECT_AS)
		local
			i: INTEGER
		do
			current_breakpoint_slot := current_breakpoint_slot + 1
			process_in_slot (l_as.switch)

			safe_process (l_as.case_list)
			safe_process (l_as.else_part)
		end

	process_retry_as (l_as: RETRY_AS)
		do
			current_breakpoint_slot := current_breakpoint_slot + 1
			l_as.set_breakpoint_slot (current_breakpoint_slot)
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
			current_breakpoint_slot := current_breakpoint_slot + 1
			l_as.set_breakpoint_slot (current_breakpoint_slot)
			is_in_breakpoint_slot := true
			Precursor(l_as)
			is_in_breakpoint_slot := false
		end

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
		do
			current_breakpoint_slot := current_breakpoint_slot + 1
			l_as.set_breakpoint_slot (current_breakpoint_slot)
			is_in_breakpoint_slot := true
			Precursor(l_as)
			is_in_breakpoint_slot := false
		end

	process_if_as (l_as: IF_AS)
		do
			current_breakpoint_slot := current_breakpoint_slot + 1
			l_as.set_breakpoint_slot (current_breakpoint_slot)
			is_in_breakpoint_slot := true
			Precursor(l_as)
			is_in_breakpoint_slot := false
		end

	process_assign_as (l_as: ASSIGN_AS)
		do
			current_breakpoint_slot := current_breakpoint_slot + 1
			l_as.set_breakpoint_slot (current_breakpoint_slot)
			is_in_breakpoint_slot := true
			Precursor(l_as)
			is_in_breakpoint_slot := false
		end

	process_reverse_as (l_as: REVERSE_AS)
		do
			current_breakpoint_slot := current_breakpoint_slot + 1
			l_as.set_breakpoint_slot (current_breakpoint_slot)
			is_in_breakpoint_slot := true
			Precursor(l_as)
			is_in_breakpoint_slot := false
		end

	process_elseif_as (l_as: ELSIF_AS)
		do
			current_breakpoint_slot := current_breakpoint_slot + 1
			l_as.set_breakpoint_slot (current_breakpoint_slot)
			is_in_breakpoint_slot := true
			Precursor(l_as)
			is_in_breakpoint_slot := false
		end

	process_loop_as (l_as: LOOP_AS)
		do
			safe_process(l_as.from_part)
			safe_process(l_as.invariant_part)
			if l_as.variant_part /= void then
				current_breakpoint_slot := current_breakpoint_slot + 1
				process_in_slot(l_as.variant_part)
			end

			current_breakpoint_slot := current_breakpoint_slot + 1
			process_in_slot (l_as.stop)

			safe_process(l_as.compound)
		end

feature {NONE} -- Implementation

	process_in_slot(l_as: AST_EIFFEL)
		do
			is_in_breakpoint_slot := true
			l_as.process (Current)
			is_in_breakpoint_slot := false
		end

	is_in_breakpoint_slot: BOOLEAN
	current_breakpoint_slot: INTEGER

	process_node (a_node: AST_EIFFEL)
			-- <precursor>
		do
			if is_in_breakpoint_slot then
				if a_node.breakpoint_slot /= 0 then
					io.put_integer (0)
				end

				a_node.set_breakpoint_slot (current_breakpoint_slot)
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
