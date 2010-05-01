note
	description: "Class to extract contracts from program elements"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_CONTRACT_EXTRACTOR

inherit
	REFACTORING_HELPER

	ETR_CONTRACT_TOOLS

	EPA_UTILITY

feature -- Access

	invariant_of_class (a_class: CLASS_C): LINKED_LIST [EPA_EXPRESSION] is
			-- List of invariant clauses of `a_class'.
			-- `ast' is the TAGGED_AS for an invariant clause, and `written_class' is the class
			-- where that invariant clause is written.
		require
			a_class_attached: a_class /= Void
		local
			l_asserts: LIST [ETR_CONTRACT_EXPRESSION]
			l_exprs: LIST [TAGGED_AS]

		do
			create Result.make
			l_asserts := all_invariants (a_class)
			from
				l_asserts.start
			until
				l_asserts.after
			loop
				l_exprs := l_asserts.item_for_iteration.assertions
				Result.append (tags (l_asserts.item_for_iteration.source_class, Void, a_class, Void, l_exprs, False, False, False, False))
				l_asserts.forth
			end
		ensure
			result_attached: Result /= Void
		end

	precondition_of_feature (a_feature: FEATURE_I; a_context_class: CLASS_C): LINKED_LIST [detachable EPA_EXPRESSION] is
			-- List of preconditions of `a_feature' in `a_context_class'
		local
			l_assertions: like preconditions
			l_exprs: LIST [TAGGED_AS]
		do
			create Result.make
			from
				l_assertions := all_preconditions (a_feature)
				l_assertions.start
			until
				l_assertions.after
			loop
				l_exprs := l_assertions.item_for_iteration.assertions
				Result.append (
					tags (
						l_assertions.item_for_iteration.source_class,
						l_assertions.item_for_iteration.source_feature,
						a_context_class,
						a_feature,
						l_exprs,
						True,
						l_assertions.item_for_iteration.is_require_else,
						False,
						False))
				l_assertions.forth
			end
		end

	postcondition_of_feature (a_feature: FEATURE_I; a_context_class: CLASS_C): LINKED_LIST [detachable EPA_EXPRESSION] is
			-- List of postcondition of `a_feature' in `a_context_class'
		local
			l_assertions: like preconditions
			l_exprs: LIST [TAGGED_AS]
		do
			create Result.make
			from
				l_assertions := all_postconditions (a_feature)
				l_assertions.start
			until
				l_assertions.after
			loop
				l_exprs := l_assertions.item_for_iteration.assertions
				Result.append (
					tags (
						l_assertions.item_for_iteration.source_class,
						l_assertions.item_for_iteration.source_feature,
						a_context_class,
						a_feature,
						l_exprs,
						False,
						False,
						True,
						l_assertions.item_for_iteration.is_ensure_then))
				l_assertions.forth
			end
		end

feature{NONE} -- Implementation

	tags (a_written_class: CLASS_C; a_written_feature: detachable FEATURE_I; a_context_class: CLASS_C; a_context_feature: FEATURE_I; a_asserts: LIST [TAGGED_AS]; a_require: BOOLEAN; a_require_else: BOOLEAN; a_ensure: BOOLEAN; a_ensure_then: BOOLEAN): LINKED_LIST [EPA_EXPRESSION] is
			-- List of tuples of assert clauses, each associated with its `a_written_class'
		require
			a_written_class_attached: a_written_class /= Void
			a_asserts_attached: a_asserts /= Void
		local
			l_cursor: CURSOR
			l_expr: EPA_AST_EXPRESSION
			l_source_context: ETR_CONTEXT
			l_target_context: ETR_CONTEXT
			l_expr_as: EXPR_AS
		do
			l_source_context := context_from_class_feature (a_written_class, a_written_feature)
			l_target_context := context_from_class_feature (a_context_class, a_context_feature)

			create Result.make
			l_cursor := a_asserts.cursor
			from
				a_asserts.start
			until
				a_asserts.after
			loop
				l_expr_as ?= ast_in_other_context (a_asserts.item.expr, l_source_context, l_target_context)
				check l_expr_as /= Void end
				if a_written_feature = Void then
					create l_expr.make (l_expr_as, a_written_class, a_context_class)
				else
					create l_expr.make_with_feature (a_context_class, a_written_feature, l_expr_as, a_written_class)
				end
				if attached {ID_AS} a_asserts.item.tag as l_tag then
					l_expr.set_tag (l_tag.name)
				else
					l_expr.set_tag (Void)
				end
				Result.extend(l_expr)
				a_asserts.forth
			end
			a_asserts.go_to (l_cursor)

		ensure
			result_attached: Result /= Void
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
