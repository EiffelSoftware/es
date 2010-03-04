note
	description: "Rewriting: Replaces elseifs by if/else."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_ELSEIF_REMOVING_VISITOR
inherit
	AST_ITERATOR
		export
			{AST_EIFFEL} all
		redefine
			process_if_as
		end
	SHARED_TEXT_ITEMS
		export
			{NONE} all
		end
	ETR_SHARED_TOOLS
	ETR_SHARED_BASIC_OPERATORS
	ETR_SHARED_ERROR_HANDLER

feature -- Access

	modifications: LIST[ETR_AST_MODIFICATION]
			-- Modifications computed	

feature -- Operation

	remove_elseifs_in (a_ast: AST_EIFFEL)
		require
			non_void: a_ast /= void
		do
			create {LINKED_LIST[ETR_AST_MODIFICATION]}modifications.make
			a_ast.process (Current)
		end

feature {NONE} -- Implementation

	replacement_string: STRING
	has_else: BOOLEAN
	else_string: STRING

	process_elseif_list (a_elseif_list: EIFFEL_LIST[ELSIF_AS])
		local
			l_index: INTEGER
			l_cur: ELSIF_AS
		do
			-- Note: This Rewriting doesn't change any breakpoint slots.

			from
				l_index := a_elseif_list.index
				a_elseif_list.start
			until
				a_elseif_list.after
			loop
				l_cur := a_elseif_list.item

				replacement_string.append (	ti_if_keyword+ti_space+ast_tools.ast_to_string (l_cur.expr)+ti_space+ti_then_keyword+ti_new_line+
											ast_tools.ast_to_string (l_cur.compound) )

				a_elseif_list.forth

				if not a_elseif_list.after then
					replacement_string.append ( ti_else_keyword + ti_new_line )
				elseif has_else then
					replacement_string.append ( ti_else_keyword + ti_new_line + else_string)
				end
			end

			-- add all the ends
			from
				a_elseif_list.start
			until
				a_elseif_list.after
			loop
				replacement_string.append (ti_end_keyword+ti_new_line)
				a_elseif_list.forth
			end

			a_elseif_list.go_i_th (l_index)
		end

feature {AST_EIFFEL} -- Roundtrip

	process_if_as (l_as: IF_AS)
		local
			l_mod: ETR_TRACKABLE_MODIFICATION
		do
			if l_as.elsif_list /= void then
				replacement_string := 	ti_if_keyword + ti_space + ast_tools.ast_to_string (l_as.condition) + ti_space + ti_then_keyword + ti_new_line+
										ast_tools.ast_to_string (l_as.compound) + ti_else_keyword + ti_new_line

				has_else := l_as.else_part /= void

				if has_else then
					else_string := ast_tools.ast_to_string (l_as.else_part)
				end

				process_elseif_list(l_as.elsif_list)

				replacement_string.append (ti_end_keyword+ti_new_line)

				create l_mod.make_replace (l_as.path, replacement_string)
				l_mod.initialize_unchanged_tracking
				modifications.extend (l_mod)
			else
				Precursor(l_as)
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
