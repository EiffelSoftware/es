note
	description: "Class to extract contracts from program elements"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_CONTRACT_EXTRACTOR

feature -- Access

	invariant_of_class (a_class: CLASS_C): LINKED_LIST [TUPLE [tag: TAGGED_AS; written_class: CLASS_C]] is
			-- List of invariant clauses of `a_class'.
			-- `tag' is the TAGGED_AS for an invariant clause, and `written_class' is the class
			-- where that invariant clause is written.
		require
			a_class_attached: a_class /= Void
		local
			l_inv: INVARIANT_AS
			l_ancestors: LINKED_LIST [CLASS_C]
			l_current_class: CLASS_C
		do
			create Result.make

				-- Get ancestors of `a_class'.
			create l_ancestors.make
			record_ancestors_of_class (a_class, l_ancestors, Void)

				-- Get all invariant asts from `a_class' as well as its ancestors.
			from
				l_ancestors.start
			until
				l_ancestors.after
			loop
				l_current_class := l_ancestors.item
				l_inv := l_current_class.invariant_ast
				if l_inv /= Void then
					Result.append (tags (l_current_class, l_inv.assertion_list))
				end
				l_ancestors.forth
			end
		ensure
			result_attached: Result /= Void
		end

feature{NONE} -- Implementation

	record_ancestors_of_class (a_class: CLASS_C; a_ancestors: LIST [CLASS_C]; a_processed: SEARCH_TABLE [INTEGER])
			-- Record all ancestores of `a_class' in `a_ancestors'.
			-- Add processed class to `a_processed' if not Void.
		require
			class_not_void: a_class /= Void
			ancestors_parents_not_void: a_ancestors /= Void
		local
			parents: FIXED_LIST [CL_TYPE_A];
			a_parent: CLASS_C
			l_processed: SEARCH_TABLE [INTEGER]
		do
			from
				l_processed := a_processed
				if l_processed = Void then
					create l_processed.make (5)
				end
				parents := a_class.parents;
				parents.start
				if not l_processed.has (a_class.class_id) then
					a_ancestors.extend (a_class)
					l_processed.put (a_class.class_id)
				end
			until
				parents.after
			loop
				a_parent := parents.item.associated_class;
				if not l_processed.has (a_parent.class_id) then
					l_processed.put (a_parent.class_id)
					a_ancestors.extend (a_parent);
					record_ancestors_of_class (a_parent, a_ancestors, l_processed)
				end;
				parents.forth
			end
		end

	tags (a_written_class: CLASS_C; a_asserts: LIST [TAGGED_AS]): LINKED_LIST [TUPLE [tag: TAGGED_AS; written_class: CLASS_C]] is
			-- List of tuples of assert clauses, each associated with its `a_written_class'
		require
			a_written_class_attached: a_written_class /= Void
			a_asserts_attached: a_asserts /= Void
		local
			l_cursor: CURSOR
		do
			create Result.make
			l_cursor := a_asserts.cursor
			from
				a_asserts.start
			until
				a_asserts.after
			loop
				Result.extend([a_asserts.item, a_written_class])
				a_asserts.forth
			end
			a_asserts.go_to (l_cursor)

		ensure
			result_attached: Result /= Void
		end

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
