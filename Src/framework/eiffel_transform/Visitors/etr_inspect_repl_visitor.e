note
	description: "Rewriting: Replaces inspects."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_INSPECT_REPL_VISITOR
inherit
	AST_ITERATOR
		export
			{AST_EIFFEL} all
		redefine
			process_inspect_as,
			process_case_as
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

feature -- Operations

	replace_inspects_in (a_ast: AST_EIFFEL)
		require
			non_void: a_ast /= void
		do
			create {LINKED_LIST[ETR_AST_MODIFICATION]}modifications.make
			a_ast.process (Current)
		end

feature {NONE} -- Implementation

	replacement_text: STRING
			-- Text to replace the current inspect with

	switch_expr: STRING
			-- Text of current switch expression

	is_first_case: BOOLEAN
			-- Are we in the first case of the switch statement (use if instead of elseif)

	inspect_bp_slot: INTEGER
			-- Breakpoint slot of the current inspect statement

	current_old_bp_slot: INTEGER
			-- Current old breakpoint slot

	current_new_bp_slot: INTEGER
			-- Current new breakpoint slot

	current_mapping: HASH_TABLE[INTEGER,INTEGER]
			-- Current breakpoint mapping

feature {AST_EIFFEL} -- Roundtrip

	process_case_list (a_case_list: EIFFEL_LIST[CASE_AS])
		local
			l_cursor: INTEGER
		do
			from
				l_cursor := a_case_list.index
				a_case_list.start
				is_first_case := true
			until
				a_case_list.after
			loop
				a_case_list.item.process (Current)
				is_first_case := false
				a_case_list.forth
			end
			a_case_list.go_i_th (l_cursor)
		end

	process_interval_list (a_interval_list: EIFFEL_LIST[INTERVAL_AS])
		local
			l_cursor: INTEGER
		do
			from
				l_cursor := a_interval_list.index
				a_interval_list.start
			until
				a_interval_list.after
			loop
				if a_interval_list.item.upper = void then
					replacement_text.append (switch_expr + ti_equal + ast_tools.ast_to_string (a_interval_list.item.lower))
				else
					replacement_text.append (
						ti_l_parenthesis + switch_expr + ti_greater_equal + ast_tools.ast_to_string (a_interval_list.item.lower) + ti_space + ti_and_keyword + ti_space +
						switch_expr + ti_less_equal + ast_tools.ast_to_string (a_interval_list.item.upper) + ti_r_parenthesis
						)
				end

				a_interval_list.forth

				if not a_interval_list.after then
					replacement_text.append (ti_space + ti_or_keyword + ti_space)
				end
			end
			a_interval_list.go_i_th (l_cursor)
		end

	process_inspect_as (l_as: INSPECT_AS)
		local
			l_old_bp_count: INTEGER
			l_else_bp_count: INTEGER
			l_mod: ETR_TRACKABLE_MODIFICATION
		do
			l_old_bp_count := ast_tools.num_breakpoint_slots_in (l_as)
			create current_mapping.make (l_old_bp_count*2)
			current_old_bp_slot := l_as.breakpoint_slot
			current_new_bp_slot := current_old_bp_slot
			inspect_bp_slot := current_old_bp_slot

			create replacement_text.make_empty
			switch_expr := ast_tools.ast_to_string (l_as.switch)
			process_case_list (l_as.case_list)

			if l_as.else_part /= void and then not l_as.else_part.is_empty then
				l_else_bp_count := ast_tools.num_breakpoint_slots_in (l_as.else_part)
				tracking_tools.map_region_shifted (current_mapping, current_new_bp_slot, current_old_bp_slot, l_else_bp_count)
				replacement_text.append (ti_else_keyword+ti_new_line+ast_tools.ast_to_string (l_as.else_part))
				current_new_bp_slot:=current_new_bp_slot+l_else_bp_count
				current_old_bp_slot:=current_old_bp_slot+l_else_bp_count
			end

			replacement_text.append (ti_end_keyword+ti_new_line)

			create l_mod.make_replace (l_as.path, replacement_text)
			l_mod.initialize_tracking_info (current_mapping, l_as.breakpoint_slot, l_old_bp_count, current_new_bp_slot-l_as.breakpoint_slot)
			modifications.extend (l_mod)
		end

	process_case_as (l_as: CASE_AS)
		local
			l_case_bp_count: INTEGER
		do
			if is_first_case then
				replacement_text.append (ti_if_keyword)
				current_old_bp_slot := current_old_bp_slot+1
			else
				replacement_text.append (ti_elseif_keyword)
			end
			current_mapping.extend (inspect_bp_slot, current_new_bp_slot)
			current_new_bp_slot := current_new_bp_slot+1

			replacement_text.append (ti_space)

			process_interval_list(l_as.interval)

			replacement_text.append (ti_space + ti_then_keyword + ti_new_line)

			if l_as.compound /= void and then not l_as.compound.is_empty then
				l_case_bp_count := ast_tools.num_breakpoint_slots_in (l_as.compound)
				tracking_tools.map_region_shifted (current_mapping, current_new_bp_slot, l_as.compound.first.breakpoint_slot, l_case_bp_count)
				current_new_bp_slot := current_new_bp_slot+l_case_bp_count
				current_old_bp_slot := current_old_bp_slot+l_case_bp_count
				replacement_text.append (ast_tools.ast_to_string (l_as.compound))
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
