note
	description: "Some tools to use with AST's"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_AST_TOOLS

feature {NONE} -- Implementation

	printer: ETR_AST_STRUCTURE_PRINTER
			-- prints small ast fragments to text
		once
			create Result.make_with_output(printer_output)
		end

	commenting_printer: ETR_COMMENTING_PRINTER
			-- prints features with comment to text
		once
			create Result.make_with_output(printer_output)
		end

	printer_output: ETR_AST_STRING_OUTPUT
			-- output used for `mini_printer'
		once
			create Result.make
		end

feature -- Access

	duplicated_ast: detachable AST_EIFFEL
			-- Result of `duplicate_ast'

feature -- Output

	extract_feature_comments(a_feature: FEATURE_AS; a_matchlist: LEAF_AS_LIST): STRING
			-- Extract comments from `a_feature' and return them as multiline-string
		require
			non_void: a_feature /= void and a_matchlist /= void
		local
			l_comments: EIFFEL_COMMENTS
		do
			l_comments := a_feature.comment (a_matchlist)

			from
				create Result.make_empty
				l_comments.start
			until
				l_comments.after
			loop
				Result.append (l_comments.item.content)
				l_comments.forth
				if not l_comments.after then
					Result.append("%N")
				end
			end
		end

	extract_class_comments(a_class: CLASS_AS; a_matchlist: LEAF_AS_LIST): HASH_TABLE[STRING,STRING]
			-- Extract comments from `a_class' and return them in a hash table
		require
			non_void: a_class /= void and a_matchlist /= void
		local
			l_cur_comment: STRING
		do
			create Result.make (20)

			from
				a_class.features.start
			until
				a_class.features.after
			loop
				from
					a_class.features.item.features.start
				until
					a_class.features.item.features.after
				loop
					l_cur_comment := extract_feature_comments(a_class.features.item.features.item, a_matchlist)
					Result.put (l_cur_comment, a_class.features.item.features.item.feature_name.name)

					a_class.features.item.features.forth
				end

				a_class.features.forth
			end
		end

	commented_class_to_string(a_class: AST_EIFFEL; a_comments: HASH_TABLE[STRING,STRING]): STRING
			-- prints `a_ast' to text using `mini_printer'
		require
			non_void: a_class /= void and a_comments /= void
		do
			printer_output.reset
			commenting_printer.print_class_with_comment (a_class, a_comments)

			Result := printer_output.string_representation
		end

	commented_feature_to_string(a_feature: AST_EIFFEL; a_comment: STRING): STRING
			-- prints `a_ast' to text using `mini_printer'
		require
			non_void: a_feature /= void and a_comment /= void
		do
			printer_output.reset
			printer_output.enter_block

			commenting_printer.print_feature_with_comment(a_feature, a_comment)

			Result := printer_output.string_representation
		end

	ast_to_string(a_ast: detachable AST_EIFFEL): STRING
			-- Prints `a_ast' to text
		do
			if attached a_ast then
				printer_output.reset
				printer.print_ast_to_output(a_ast)

				Result := printer_output.string_representation
			else
				create Result.make_empty
			end
		end

	ast_to_string_with_indentation(a_ast: detachable AST_EIFFEL; an_indentation: INTEGER): STRING
			-- Prints `a_ast' starting at indentation level `an_indentation'
		require
			non_void: a_ast /= void
			valid_indent: an_indentation>=0
		local
			l_index: INTEGER
		do
			if attached a_ast then
				from
					l_index := 1
					printer_output.reset
				until
					l_index > an_indentation
				loop
					printer_output.enter_block
					l_index := l_index + 1
				end

				printer.print_ast_to_output(a_ast)

				Result := printer_output.string_representation
			else
				create Result.make_empty
			end
		end

feature -- Operations

	duplicate_ast(an_ast: AST_EIFFEL)
			-- Duplicates `an_ast' and stores the result in `duplicated_ast'
		require
			non_void: an_ast /= void
		do
			duplicated_ast := an_ast.deep_twin
		end

	single_instr_list(instr: INSTRUCTION_AS): EIFFEL_LIST [like instr]
			-- creates list with a single instruction `instr'
		require
			instr_not_void: instr/=void
		do
			create Result.make (1)
			Result.extend (instr)
		ensure
			one: Result.count = 1
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
