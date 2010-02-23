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

feature -- Operation

	rewrite_loops_in(a_ast: AST_EIFFEL; a_unroll_count: like unroll_count; a_first_only: BOOLEAN)
		require
			non_void: a_ast /= void
			count_pos: a_unroll_count>=0
		do
			first_only := a_first_only
			was_processed := false

			create {LINKED_LIST[ETR_AST_MODIFICATION]}modifications.make
			unroll_count := a_unroll_count
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
		do
			if not (first_only and was_processed) then
				create l_replacement_string.make_empty
				if l_as.from_part /= void then
					l_replacement_string.append (ast_tools.ast_to_string (l_as.from_part))
				end

				l_if_line := ti_if_keyword+ti_space+ti_not_keyword+ti_space+ti_l_parenthesis+ast_tools.ast_to_string (l_as.stop)+ti_r_parenthesis+ti_space+ti_then_keyword+ti_new_line
				l_compound_string := ast_tools.ast_to_string (l_as.compound)+ti_end_keyword+ti_new_line
				l_single_iteration := l_if_line+l_compound_string

				from
					l_index := 1
				until
					l_index > unroll_count
				loop
					l_replacement_string.append (l_single_iteration)

					l_index := l_index + 1
				end

				modifications.extend (basic_operators.replace_with_string (l_as.path, l_replacement_string))
				was_processed := true
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
