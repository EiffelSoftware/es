note
	description: "Class to analyze structure of an expression"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_EXPRESSION_STRUCTURE_ANALYZER

inherit
	EPA_UTILITY

	EPA_SHARED_EQUALITY_TESTERS

feature -- Basic operations

	decomposed_expressions (a_expression: EPA_EXPRESSION; a_separator: STRING): EPA_HASH_SET [EPA_EXPRESSION]
			-- Decomposed expressions `a_expression' (assume that `a_expression' is in a CNF form)			
			-- `a_separator' can be either " and " or " or "
			-- For example, if `a_expression' is "a and b", then Result contains two elements: "a", and "b".
		local
			l_text: STRING
			l_expr: EPA_AST_EXPRESSION
			l_class: CLASS_C
			l_written_class: CLASS_C
			l_feature: FEATURE_I
		do
			l_class := a_expression.class_
			l_written_class := a_expression.written_class
			l_feature := a_expression.feature_
			l_text := a_expression.text
			l_text.replace_substring_all (once "or else", once "or")
			l_text.replace_substring_all (once "and then", once "and")
			create Result.make (5)
			Result.set_equality_tester (expression_equality_tester)
			across string_slices (l_text, a_separator) as l_parts loop
				l_parts.item.left_adjust
				l_parts.item.right_adjust
				create l_expr.make_with_text (l_class, l_feature, l_parts.item, l_written_class)
				if l_expr.type /= Void then
					Result.force_last (l_expr)
				end
			end
		end

	partial_components (a_expression: EPA_EXPRESSION; a_separator: STRING; a_drop_count: INTEGER): LINKED_LIST [TUPLE [remaining_expression: EPA_EXPRESSION; dropped_components: DS_HASH_SET [EPA_EXPRESSION]]]
			-- Expressions from `a_expression' where `a_drop_count' number of sub-components
			-- are dropped. `remaining_expression' is the remaining part from `a_expression',
			-- `dropped_components' are the sub-expressions that are dropped from `a_expression'.
			-- `a_separator' can be either " and " or " or ".
		require
			a_drop_count_positive: a_drop_count > 0
		local
			l_components: EPA_HASH_SET [EPA_EXPRESSION]
			l_remain_text: STRING
			l_dropped: DS_HASH_SET [EPA_EXPRESSION]
			l_remain: EPA_HASH_SET [EPA_EXPRESSION]
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_class: CLASS_C
			l_written_class: CLASS_C
			l_feature: FEATURE_I
			l_expr: EPA_AST_EXPRESSION
		do
			l_class := a_expression.class_
			l_written_class := a_expression.written_class
			l_feature := a_expression.feature_
			create Result.make
			l_components := decomposed_expressions (a_expression, a_separator)
			if l_components.count > a_drop_count then
				across l_components.combinations (l_components.count - a_drop_count) as l_remainings loop
					l_remain := l_remainings.item
					create l_remain_text.make (128)
					create l_dropped.make (a_drop_count)
					l_components.do_all (agent l_dropped.force_last)
					l_dropped.set_equality_tester (expression_equality_tester)
					from
						l_cursor := l_remain.new_cursor
						l_cursor.start
					until
						l_cursor.after
					loop
						if not l_remain_text.is_empty then
							l_remain_text.append (a_separator)
						end
						l_remain_text.append (l_cursor.item.text)
						l_dropped.remove (l_cursor.item)
						l_cursor.forth
					end
					create l_expr.make_with_text (l_class, l_feature, l_remain_text, l_written_class)
					Result.extend ([l_expr, l_dropped])
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
