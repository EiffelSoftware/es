note
	description: "Summary description for {AUT_PREDICATE_VALUATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUT_PREDICATE_VALUATION

inherit
	REFACTORING_HELPER

	DEBUG_OUTPUT

feature -- Access

	predicate: AUT_PREDICATE
			-- Predicate whose evaluation is to be stored in Current.

	arity: INTEGER is
			-- Arity of `predicate'
		do
			Result := predicate.arity
		ensure
			good_result: Result = predicate.arity
		end

	count: INTEGER is
			-- Number of object combinations that satisfy the associated predicate.
		deferred
		ensure
			good_result: Result >= 0
		end

	item (a_arguments: ARRAY [ITP_VARIABLE]): BOOLEAN is
			-- Valuation of objects in `a_arguments'
			-- Index of `a_arguments' is 1-based. They are arguments for `predicate'.
		require
			a_arguments_valid: is_valid_arguments (a_arguments)
		deferred
		end

feature -- Status report

	has (a_arguments: ARRAY [ITP_VARIABLE]): BOOLEAN is
			-- Does current have evaluation for `a_arguments'.
			-- It is True because we assume this valuation class containts
			-- all possible valuations for `predicate', although we only store
			-- those object combinations that have value True.
			-- Index of `a_arguments' is 1-based. They are arguments for `predicate'.
		require
			a_arguments_valid: is_valid_arguments (a_arguments)
		do
			Result := True
		end

	is_valid_arguments (a_arguments: ARRAY [ITP_VARIABLE]): BOOLEAN is
			-- Is `a_arguments' valid for `predcicate'?
			-- Index of `a_arguments' is 1-based. They are arguments for `predicate'.
		do
			Result :=
				a_arguments /= Void and then
				a_arguments.lower = 1 and then a_arguments.upper = arity
		ensure
			good_result:
				Result =
					a_arguments /= Void and then
					a_arguments.lower = 1 and then a_arguments.upper = arity and then
					not a_arguments.has (Void)
		end

	is_empty: BOOLEAN is
			-- Does current contain no element?
		do
			Result := count = 0
		ensure
			good_result: Result = (count = 0)
		end

	has_variable (a_variable: ITP_VARIABLE): BOOLEAN is
			-- Does `a_variable' exist in current valuation?
		require
			a_variable_attached: a_variable /= Void
		deferred
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := predicate.text + ", valuations: " + count.out
		end

feature -- Basic operations

	put (a_arguments: ARRAY [ITP_VARIABLE]; a_value: BOOLEAN) is
			-- Set valuation for `a_arguments' with `a_value'.
			-- Index of `a_arguments' is 1-based. They are arguments for `predicate'.
		require
			a_arguments_valid: is_valid_arguments (a_arguments)
		deferred
		ensure
			good_result: item (a_arguments) = a_value
		end

	wipe_out is
			-- Wipe out current all valuations.
		deferred
		ensure
			valuations_wiped_out: count = 0
		end

	remove_variable (a_variable: ITP_VARIABLE) is
			-- Remove all valuations related to `a_variable'.
		require
			a_variable_attached: a_variable /= Void
		deferred
		ensure
			a_variable_removed: not has_variable (a_variable)
		end

feature -- Process

	process (a_visitor: AUT_PREDICATE_VALUATION_VISITOR) is
			-- Prcoess current with `a_visitor'.
		require
			a_visitor_attached: a_visitor /= Void
		deferred
		end

feature{NONE} -- Implementation

	partial_operand_solution_anchor: ARRAY [detachable ITP_VARIABLE];
		-- Anchor type for partical solution
		-- The lower bound of this array must be 0.
		-- A detached item in the array means that the operand is not fixed, otherwise,
		-- it is fixed.

invariant
	predicate_attached: predicate /= Void
	arity_non_negative: arity >= 0
	count_non_negative: count >= 0

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
