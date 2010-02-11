note
	description: "Prints a feature with comment"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_COMMENTING_PRINTER
inherit
	ETR_AST_STRUCTURE_PRINTER
		redefine
			process_routine_as
		end
create
	make_with_output

feature -- Operations

	print_feature_with_comment(a_feature: AST_EIFFEL; a_comment: STRING)
			-- Print `a_feature' with `a_comment'
		require
			non_void: a_feature /= void and a_comment /= void
		do
			comment := a_comment
			print_ast_to_output(a_feature)
		end

feature -- Implementation
	comment: detachable STRING

feature {AST_EIFFEL} -- Roundtrip

	process_routine_as (l_as: ROUTINE_AS)
		local
			l_comments: LIST[STRING]
		do
			if attached comment and then not comment.is_empty then
				output.enter_block
				l_comments := comment.split('%N')
				from
					l_comments.start
				until
					l_comments.after
				loop
					output.append_string("--")
					output.append_string(l_comments.item)
					output.append_string (ti_new_line)
					l_comments.forth
				end
				output.exit_block
			end

			if processing_needed (l_as.obsolete_message, l_as, 1) then
				output.append_string (ti_obsolete_keyword+ti_New_line)
				process_block (l_as.obsolete_message, l_as, 1)
				output.append_string (ti_New_line)
			end

			process_child (l_as.precondition, l_as, 2)

			if processing_needed (l_as.locals, l_as, 3) then
				output.append_string (ti_local_keyword+ti_New_line)
				output.enter_block
				process_child_list (l_as.locals, ti_New_line, l_as, 3)
				output.append_string (ti_New_line)
				output.exit_block
			end

			process_child(l_as.routine_body, l_as, 4)

			process_child (l_as.postcondition, l_as, 5)

			if processing_needed (l_as.rescue_clause, l_as, 6) then
				output.append_string(ti_rescue_keyword+ti_New_line)
				process_child_block (l_as.rescue_clause, l_as, 6)
			end

			output.append_string(ti_End_keyword+ti_New_line)
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
