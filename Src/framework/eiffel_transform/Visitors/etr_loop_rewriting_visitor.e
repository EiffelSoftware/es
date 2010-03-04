note
	description: "Rewriting: Unrolls loops."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_LOOP_REWRITING_VISITOR
inherit
	AST_ITERATOR
		export
			{AST_EIFFEL} all
		redefine
			process_loop_as
		end
	SHARED_TEXT_ITEMS
		export
			{NONE} all
		end
	ETR_SHARED_TOOLS
	ETR_SHARED_BASIC_OPERATORS

feature -- Access

	modifications: LIST[ETR_AST_MODIFICATION]
			-- Modifications computed

feature -- Operation

	rewrite_loops_in (a_ast: AST_EIFFEL; a_unroll_count: like unroll_count; a_first_only: BOOLEAN)
		require
			non_void: a_ast /= void
			count_pos: a_unroll_count>=0
		do
			first_only := a_first_only
			was_processed := false
			unroll_count := a_unroll_count

			create {LINKED_LIST[ETR_AST_MODIFICATION]}modifications.make
			a_ast.process (Current)
		end

feature {NONE} -- Implementation

	unroll_count: INTEGER
	first_only: BOOLEAN
	was_processed: BOOLEAN

feature {AST_EIFFEL} -- Roundtrip

	process_loop_as (l_as: LOOP_AS)
		local
			l_replacement_string: STRING
			l_if_line: STRING
			l_compound_string: STRING
			l_single_iteration: STRING
			l_index: like unroll_count
			l_current_slot: INTEGER
			l_stop_slot, l_body_first_slot: INTEGER
			l_from_bp_count, l_body_bp_count: INTEGER
			l_first_new_slot: INTEGER
			l_old_total_bp_count, l_new_total_bp_count: INTEGER
			l_current_mapping: HASH_TABLE[INTEGER,INTEGER]
			l_mod: ETR_TRACKABLE_MODIFICATION
		do
			if not (first_only and was_processed) then
				create l_replacement_string.make_empty
				l_old_total_bp_count := ast_tools.num_breakpoint_slots_in (l_as)
				create l_current_mapping.make (l_old_total_bp_count*unroll_count*2)
				l_stop_slot := l_as.stop.breakpoint_slot
				if l_as.from_part /= void then
					-- mappings of from-part are 1:1
					l_current_slot := l_as.from_part.first.breakpoint_slot
					l_first_new_slot := l_current_slot
					l_replacement_string.append (ast_tools.ast_to_string (l_as.from_part))
					l_from_bp_count := ast_tools.num_breakpoint_slots_in (l_as.from_part)
					tracking_tools.map_region_one_to_one(l_current_mapping, l_current_slot, l_current_slot+l_from_bp_count-1)
				else
					l_first_new_slot := l_stop_slot
				end

				l_if_line := ti_if_keyword+ti_space+ti_not_keyword+ti_space+ti_l_parenthesis+ast_tools.ast_to_string (l_as.stop)+ti_r_parenthesis+ti_space+ti_then_keyword+ti_new_line
				l_compound_string := ast_tools.ast_to_string (l_as.compound)+ti_end_keyword+ti_new_line
				l_single_iteration := l_if_line+l_compound_string

				l_body_bp_count := ast_tools.num_breakpoint_slots_in(l_as.compound)

				if l_as.compound /= void then
					l_body_first_slot := l_as.compound.first.breakpoint_slot
				end

				from
					l_current_slot := l_stop_slot
					l_index := 1
				until
					l_index > unroll_count
				loop
					-- map current slot to stop slot
					l_current_mapping.extend (l_stop_slot,l_current_slot)
					l_current_slot := l_current_slot+1
					-- map if-body to original loop body
					if l_as.compound/=void then
						tracking_tools.map_region_shifted(l_current_mapping, l_current_slot, l_body_first_slot, l_body_bp_count)
						l_current_slot := l_current_slot+l_body_bp_count
					end

					l_replacement_string.append (l_single_iteration)

					l_index := l_index + 1
				end

				l_new_total_bp_count := l_current_slot - l_first_new_slot
				create l_mod.make_replace (l_as.path, l_replacement_string)
				l_mod.initialize_tracking_info (l_current_mapping, l_first_new_slot, l_old_total_bp_count, l_new_total_bp_count)
				modifications.extend (l_mod)
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
