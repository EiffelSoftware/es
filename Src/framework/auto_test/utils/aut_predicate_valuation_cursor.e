note
	description: "Summary description for {AUT_PREDICATE_VALUATION_CURSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUT_PREDICATE_VALUATION_CURSOR

inherit
	DEBUG_OUTPUT

feature{NONE} -- Initialization

	make (a_container: like container; a_access_pattern: like predicate_access_pattern; a_constraint: like constraint; a_partical_candidate: like candidate) is
			-- Initialize.
		require
			a_container_attached: a_container /= Void
			a_access_pattern_attached: a_access_pattern /= void
			a_access_pattern_valid: a_access_pattern.predicate.is_equal (a_container.predicate)
			a_constraint_attached: a_constraint /= Void
			a_partical_candidate_attached: a_partical_candidate /= Void
			a_partial_candidate_valid: a_partical_candidate.lower = 0 and then a_partical_candidate.count = a_constraint.operand_count
		do
			container := a_container
			constraint := a_constraint
			candidate := a_partical_candidate
			predicate_access_pattern := a_access_pattern
			before := True
			calculate_free_variables
		ensure
			container_set: container = a_container
			constraint_set: constraint = a_constraint
			candidate_set: candidate = a_partical_candidate
			predicate_access_pattern_set: predicate_access_pattern = a_access_pattern
			is_before: before
		end

feature -- Status report

	before: BOOLEAN
			-- Is there no valid cursor position to the left of cursor?

	after: BOOLEAN is
			-- Is there no valid position to right of cursor?
		deferred
		end

	off: BOOLEAN is
			-- Is there a valid position under current cursor?
		do
			Result := before or after
		ensure
			good_result: Result = (before or after)
		end

feature -- Access

	container: AUT_PREDICATE_VALUATION
			-- Predicate valuation associated with current cursor

	predicate_access_pattern: AUT_PREDICATE_ACCESS_PATTERN
			-- Predicate access pattern for `container'.`predicate'

	candidate: ARRAY [detachable ITP_VARIABLE]
			-- Candidate object combination
			-- Void item in the array is item that are not chosen yet.
			-- Index of the array is 0-based, it is intened to be used as feature call objects.

	constraint: AUT_PREDICATE_CONSTRAINT
			-- Predicate constraint

	free_variables: DS_HASH_TABLE [INTEGER, INTEGER]
			-- Mapping of free variables for current cursor
			-- Free variables are variables in `candidate' which are not chosen yet.
			-- Current cursor can choose any object that satisfies `container' for free variables.
			-- [0-based feature call object index, 1-based predicate argument index]

	bound_variables: DS_HASH_TABLE [INTEGER, INTEGER]
			-- Mapping of bound variables for current cursor
			-- Bound variables are variables in `candidate' which are already chosen.
			-- [0-based operand index, 1-based predicate argument index]


feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			create Result.make (64)
			Result.append (predicate_access_pattern.debug_output)
		end

feature -- Cursor movement

	start is
			-- Move cursor to first position.
		deferred
		end

	forth is
			-- Move cursor to next position.
		require
			not_after: not after
		deferred
		end

feature -- Basic operations

	update_candidate_with_item is
			-- Update `candidate' with objects at the position of current cursor.
		require
			valid_position: not off
		deferred
		ensure
			candidate_updated: free_variables.for_all (agent (ind: INTEGER): BOOLEAN do Result := candidate.item (ind) /= Void end)
		end

	update_candidate_with_free_variables is
			-- Update `candidate' by setting all `free_variables' to Void.
		do
			free_variables.do_all (agent (ind: INTEGER) do candidate.put (Void, ind) end)
		ensure
			candidate_updated: free_variables.for_all (agent (ind: INTEGER): BOOLEAN do Result := candidate.item (ind) = Void end)
		end

	calculate_free_variables is
			-- Calculate `free_variables' from `candidate'.
		local
			l_cursor: DS_HASH_TABLE_CURSOR [INTEGER, INTEGER]
			l_candidate: like candidate
		do
			create free_variables.make (constraint.operand_count)
			create bound_variables.make (constraint.operand_count)
			from
				l_cursor := constraint.argument_operand_mapping.item (predicate_access_pattern).new_cursor
				l_candidate := candidate
				l_cursor.start
			until
				l_cursor.after
			loop
				if l_candidate.item (l_cursor.item) = Void then
					free_variables.put_last (l_cursor.item, l_cursor.key)
				else
					bound_variables.put_last (l_cursor.item, l_cursor.key)
				end
				l_cursor.forth
			end
		end

feature{NONE} -- Implementation

	variable_from_index (a_index: INTEGER): ITP_VARIABLE is
			-- Interpreter variable from `a_index'.
		do
			create Result.make (a_index)
		ensure
			good_result: Result /= Void and then Result.index = a_index
		end

	variable_in_candidate (a_index: INTEGER): ITP_VARIABLE is
			-- Variable at `a_index'-th position in `candidate'
		require
			a_index_valid: candidate.lower <= a_index and then a_index <= candidate.upper
			a_variable_exists: candidate.item (a_index) /= Void
		do
			Result := variable_from_index (candidate.item (a_index).index)
		ensure
			result_attached: Result /= Void
		end

invariant
	container_attached: container /= Void
	constraint_attached: constraint /= Void
	candidate_attached: candidate /= Void
	candidate_valid: candidate.lower = 0 and then candidate.count = constraint.operand_count
	free_variables_attached: free_variables /= Void
	predicate_access_pattern_attached: predicate_access_pattern /= Void
	predicate_access_pattern_valid: predicate_access_pattern.predicate.is_equal (container.predicate)

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
