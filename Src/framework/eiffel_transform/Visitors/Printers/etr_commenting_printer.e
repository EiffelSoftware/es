note
	description: "Prints a feature with comment."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_COMMENTING_PRINTER
inherit
	ETR_AST_STRUCTURE_PRINTER
		redefine
			process_body_as,
			process_feature_as
		end
create
	make_with_output

feature -- Operations

	print_feature_with_comment(a_feature: AST_EIFFEL; a_comment: attached like comment)
			-- Print `a_feature' with `a_comment'
		require
			non_void: a_feature /= void and a_comment /= void
		do
			comment := a_comment
			comments := void
			print_ast_to_output(a_feature)
		end

	print_class_with_comment(a_class: AST_EIFFEL; a_comments: attached like comments)
			-- Print `a_class' with `a_comments'
		require
			non_void: a_class /= void and a_comments /= void
		do
			comment := void
			comments := a_comments
			print_ast_to_output(a_class)
		end

feature {NONE} -- Implementation
	comment: detachable STRING

	comments: detachable HASH_TABLE[STRING,STRING]

	current_feature: STRING

	print_comments (a_comment: STRING)
			-- Extracted from `process_routine_as'
		local
			l_comments: LIST[STRING_8]
		do
			l_comments := a_comment.split ('%N')
			from
				l_comments.start
			until
				l_comments.after
			loop
				output.append_string ("--")
				output.append_string (l_comments.item)
				output.append_string (ti_new_line)
				l_comments.forth
			end
		end

	print_current_comments
			-- Extracted from `process_routine_as'
		do
			if attached comment and then not comment.is_empty then
				output.enter_block
				print_comments (comment)
				output.exit_block
			elseif (attached comments and current_feature /= Void) and then attached comments[current_feature] as l_comments then
				if not l_comments.is_empty then
					output.enter_block
					print_comments (l_comments)
					output.exit_block
				end
			end
		end

feature {AST_EIFFEL} -- Roundtrip

	process_feature_as (l_as: FEATURE_AS)
		do
			current_feature := l_as.feature_name.name
			process_child_list(l_as.feature_names, ti_comma+ti_Space, l_as, 1)
			process_child(l_as.body, l_as, 2)
			current_feature := void
		end

	process_body_as (l_as: BODY_AS)
		do
			if processing_needed (l_as.arguments, l_as, 1) then
				output.append_string (ti_space+ti_l_parenthesis)
				process_child_list(l_as.arguments, ti_semi_colon+ti_Space, l_as, 1)
				output.append_string (ti_r_parenthesis)
			end

			if processing_needed (l_as.type, l_as, 2) then
				output.append_string (ti_colon+ti_space)
				process_child (l_as.type, l_as, 2)
			end

			if l_as.is_constant then
				output.append_string(ti_Space+ti_equal+ti_Space)
			elseif processing_needed (l_as.assigner, l_as, 3) then
				output.append_string (ti_Space+ti_assign_keyword+ti_Space)
				process_child (l_as.assigner, l_as, 3)
				output.append_string(ti_New_line)
			elseif l_as.is_unique then
				output.append_string (ti_Space+ti_is_keyword+ti_Space+ti_unique_keyword)
			else
				output.append_string(ti_New_line)
			end

			output.enter_block

			if not attached {CONSTANT_AS}l_as.content then
				print_current_comments
			end

			if processing_needed (l_as.indexing_clause, l_as, 5) then
				output.append_string (ti_indexing_keyword+ti_new_line)
				process_child_block_list (l_as.indexing_clause, ti_new_line, l_as, 5)
				output.append_string (ti_new_line)
			end

			if processing_needed (l_as.content, l_as, 4) then
				process_child(l_as.content, l_as, 4)
			end

			if attached {CONSTANT_AS}l_as.content then
				print_current_comments
			end

			output.exit_block
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
