note
	description: "Class to load pre-state invariants"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PRESTATE_INVARIANT_LOADER

inherit
	REFACTORING_HELPER

	EPA_UTILITY

	EPA_STRING_UTILITY

	KL_SHARED_FILE_SYSTEM

	SHARED_AST_CONTEXT

	EPA_SHARED_EXPR_TYPE_CHECKER

feature -- Access

	last_invariants: LINKED_LIST [AUT_STATE_INVARIANT]
			-- Pre-state invariant loaded by last `load'

	last_feature: FEATURE_I
			-- Feature where `last_invariants' appear

	last_class: CLASS_C
			-- Class where `last_feature' is viewed

feature -- Basic operations

	load (a_path: STRING)
			-- Load pre-state invariants from file whose
			-- absolute path is given by `a_path'.
			-- Make results available in `last_invariants',
			-- `last_class' and `last_feature'.
		local
			l_parts: LIST [STRING]
			l_file: PLAIN_TEXT_FILE
			l_file_searcher: EPA_FILE_SEARCHER
			l_files: LINKED_LIST [STRING]
		do
			fixme ("This splitting does not work if some features ends with underscore.")
				-- Collect all invariant files specified by `a_path'.
			create l_files.make
			create l_file.make (a_path)
			if l_file.is_directory then
				create l_file_searcher.make_with_pattern (".+all__noname\.inv$")
				l_file_searcher.set_is_dir_matched (False)
				l_file_searcher.set_is_search_recursive (True)
				l_file_searcher.file_found_actions.extend (
					agent (a_full_path: STRING; a_file_name: STRING; l_list: LINKED_LIST [STRING])
						do
							l_list.extend (a_full_path)
						end (?, ?, l_files))
				l_file_searcher.search (a_path)
			else
				l_files.extend (a_path)
			end

				-- Collect all invariants from files.
			create last_invariants.make
			across l_files as l_inv_files loop
				l_parts := string_slices (file_system.basename (l_inv_files.item), "__")
				last_class := first_class_starts_with_name (l_parts.i_th (1).out)
				last_feature := last_class.feature_named (l_parts.i_th (2).out)

				if last_feature /= Void and then not last_feature.has_return_value then
						-- We only consider commands for the moment.
					create l_file.make_open_read (l_inv_files.item)
					from
						l_file.read_line
					until
						l_file.after
					loop
						parse_invariant_from_string (l_file.last_string.twin)
						l_file.read_line
					end
					l_file.close
				end
			end
		end

feature{NONE} -- Implementation

	parse_invariant_from_string (a_text: STRING)
			-- Parse invariant in `a_text', in form of curly-braced integers.
			-- For example, "{0}.has ({1}).
			-- If `a_text' is a supported invariant, put it in `last_invariants'.
		local
			l_done: BOOLEAN
			l_opd_index: INTEGER
			l_operands: like operands_with_feature
			l_text: STRING
			l_expr: EPA_AST_EXPRESSION
			l_index: INTEGER
			l_sub_text: STRING
			l_left, l_right: EPA_AST_EXPRESSION
			l_parts: LIST [STRING]
			l_status: BOOLEAN
			l_pre_status: BOOLEAN
		do
				-- Replace Daikon style "==" with Eiffel style "=".			
			l_text := a_text.twin
			l_index := l_text.substring_index (" == ", 1)

			if l_index > 0 then
				l_sub_text := l_text.substring (1, l_index - 1)
			end

			if l_text.has_substring (" == ") then
				l_text.replace_substring_all (" == ", ") = ")
				l_text.prepend ("(")
			end

				-- Ignore invariant stating that "Current /= Void", because
				-- it is a tautology.
			if l_text ~ once "{0} /= Void" then
				l_done := True
			end

				-- Ingore expressions which contain more than 1 nested level, for example, a.b.c,
				-- because the theory generator cannot support such expressions.
			if not l_done then
				l_parts := l_text.split (' ')
				from
					l_parts.start
				until
					l_parts.after or else l_done
				loop
					l_done := l_parts.item_for_iteration.occurrences ('.') > 1
					l_parts.forth
				end
			end

				-- Ignore Daikon "has only one value" invariant.
			if not l_done and then l_text.has_substring (once "has only one value") then
				l_done := True
			end

				-- Ignore pre-state invariants mentioning Result.
			if not l_done then
				if last_feature.has_return_value then
					if l_text.has_substring (curly_brace_surrounded_integer (operand_count_of_feature (last_feature))) then
						l_done := True
					end
				end
			end

			if not l_done then
				l_operands := operands_with_feature (last_feature)
				from
					l_opd_index := 0
				until
					l_opd_index > 9
				loop
					l_text.replace_substring_all (curly_brace_surrounded_integer (l_opd_index), l_operands.item (l_opd_index))
					if l_sub_text /= Void then
						l_sub_text.replace_substring_all (curly_brace_surrounded_integer (l_opd_index), l_operands.item (l_opd_index))
					end
					l_opd_index := l_opd_index + 1
				end

				if l_sub_text /= Void and then attached {BIN_EQ_AS} ast_from_expression_text (l_sub_text) as l_eq then
						-- Remove expressions "exp1 = exp2" where exp1 and exp2 have different type categories.
						-- For example, exp1 is of type ANY, and exp2 is of type INTEGER.
						-- If we don't remove those expressions, the last generated Boogie program will be incorrect.
						-- 27.2.2011 Jasonw
					create l_left.make_with_feature (last_class, last_feature, l_eq.left, last_class)
					create l_right.make_with_feature (last_class, last_feature, l_eq.right, last_class)
					if l_left.type /= Void and then l_right.type /= Void then
						if
							(l_left.type.is_integer and l_right.type.is_integer) or else
							(l_left.type.is_boolean and l_right.type.is_boolean) or else
							(l_left.type.is_reference and l_right.type.is_reference)
						then
						else
							l_done := True
						end
					end
				end

				if not l_done then
					l_status := context.is_ignoring_export
					l_pre_status := expression_type_checker.is_checking_precondition
					context.set_is_ignoring_export (False)
					expression_type_checker.set_is_checking_precondition (True)
					create l_expr.make_with_text (last_class, last_feature, l_text, last_class)
					if l_expr.type /= Void then
						last_invariants.extend (create {AUT_STATE_INVARIANT}.make (l_expr, last_class, last_feature))
					end
					context.set_is_ignoring_export (l_status)
					expression_type_checker.set_is_checking_precondition (l_pre_status)
				end
			end
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
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
