note
	description: "Summary description for {AUT_RANDOM_NNARY_PREDICATE_VALUATION_CURSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_RANDOM_NNARY_PREDICATE_VALUATION_CURSOR

inherit
	AUT_PREDICATE_VALUATION_CURSOR
		redefine
			make,
			container
		end

	AUT_SHARED_RANDOM

create
	make

feature{NONE} -- Initialization

	make (a_container: like container; a_predicate_access_pattern: like predicate_access_pattern; a_constraint: like constraint; a_partical_candidate: like candidate) is
			-- Initialize.
		do
			Precursor (a_container, a_predicate_access_pattern, a_constraint, a_partical_candidate)
			create predicate_arguments.make (1, container.arity)
			set_bound_arguments
		end

feature -- Status report

	after: BOOLEAN
			-- Is there no valid position to right of cursor?

feature -- Access

	container: AUT_NNARY_PREDICATE_VALUATION
			-- Predicate valuation associated with current cursor

feature -- Cursor movement

	start is
			-- Move cursor to first position.
		do
			before := False
			create storage_cursor.make (container.storage.to_array, random)
			forth_until_found
		end

	forth is
			-- Move cursor to next position.
		do
			forth_until_found
		end

feature -- Basic operations

	update_candidate_with_item is
			-- Update `candidate' with objects at the position of current cursor.
		local
			l_item: AUT_HASHABLE_ITP_VARIABLE_ARRAY
			l_cursor: DS_HASH_TABLE_CURSOR [INTEGER, INTEGER]
			l_candidate: like candidate
		do
			from
				l_item := storage_cursor.item
				l_candidate := candidate
				l_cursor := free_variables.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_candidate.put (l_item.item (l_cursor.key), l_cursor.item)
				l_cursor.forth
			end
		end

feature{NONE} -- Implementation

	predicate_arguments: ARRAY [detachable ITP_VARIABLE]
			-- Arguments for predicate
			-- Array index is 1-based.

	set_bound_arguments is
			-- Set bound arguments from `candidate' into `predicate_arguments'.
		local
			l_mapping: DS_HASH_TABLE [INTEGER, INTEGER]
			l_cursor: DS_HASH_TABLE_CURSOR [INTEGER, INTEGER]
			l_args: like predicate_arguments
		do
			l_args := predicate_arguments
			l_mapping := constraint.argument_operand_mapping.item (predicate_access_pattern)
			from
				l_cursor := l_mapping.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_args.put (candidate.item (l_cursor.item), l_cursor.key)
				l_cursor.forth
			end
		end

	forth_until_found is
			-- Forth current until a satisfying object combination
			-- is found or after.
		require
			not_after: not after
			storage_cursor_not_off: not storage_cursor.off
		local
			l_found: BOOLEAN
			l_cursor: like storage_cursor
		do
			l_cursor := storage_cursor
			if l_cursor.before then
				l_cursor.start
			end
			if not l_cursor.after then
				from
				until
					l_cursor.after or else l_found
				loop
					l_found := is_predicate_argument_matched (l_cursor.item)
					if not l_found then
						l_cursor.forth
					end
				end
			end
			after := l_cursor.after
		end

	is_predicate_argument_matched (a_valuation: AUT_HASHABLE_ITP_VARIABLE_ARRAY): BOOLEAN is
			-- Is `predicate_arguments' match the corresponding ones in `a_valuation'?
		require
			a_valuation_attached: a_valuation /= Void
		local
			l_pred_args: like predicate_arguments
			i: INTEGER
			l_count: INTEGER
			l_variable: detachable ITP_VARIABLE
		do
			from
				l_pred_args := predicate_arguments
				Result := True
				i := 1
				l_count := container.arity
			until
				i > l_count or else not Result
			loop
				l_variable := l_pred_args.item (i)
				Result :=  l_variable /= Void implies (l_variable.index = a_valuation.item (i).index)
				i := i + 1
			end
		end

	storage_cursor: AUT_RANDOM_CURSOR [AUT_HASHABLE_ITP_VARIABLE_ARRAY]
			-- Storage of items

invariant
	predicate_arguments_attached: predicate_arguments /= Void
	predicate_arguments_valid: predicate_arguments.lower = 1 and then predicate_arguments.count = container.arity


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
