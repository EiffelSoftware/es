note
	description: "Summary description for {AUT_BINARY_PREDICATE_VALUATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_BINARY_PREDICATE_VALUATION

inherit
	AUT_PREDICATE_VALUATION
		redefine
			count
		end

create
	make

feature{NONE} -- Initialization

	make (a_predicate: like predicate) is
			-- Initialize `predicate' with `a_predicate'.
		require
			a_predicate_attached: a_predicate /= Void
			a_predicate_is_unary: a_predicate.is_binary
		do
			predicate := a_predicate
			create first_argument_table.make (argument_table_initial_capacity)
			create second_argument_table.make (argument_table_initial_capacity)
			create argument_tables.make (1, 2)
			argument_tables.put (first_argument_table, 1)
			argument_tables.put (second_argument_table, 2)
		end

feature -- Access

	count: INTEGER
			-- Number of object combinations that satisfy the associated predicate.

	item (a_arguments: ARRAY [ITP_VARIABLE]): BOOLEAN is
			-- Valuation of objects in `a_arguments'
			-- Index of `a_arguments' is 1-based. They are arguments for `predicate'.
		local
			l_first_tbl: like first_argument_table
		do
			l_first_tbl := first_argument_table
			l_first_tbl.search (a_arguments.item (1).index)
			if l_first_tbl.found then
				Result := l_first_tbl.found_item.has (a_arguments.item (2).index)
			end
		end

feature -- Status report

	is_predicate_valid (a_predicate: like predicate): BOOLEAN is
			-- Is `a_predicate' a valid predicate for current valuation?
			-- Check the arity of `a_predicate'.
		do
			Result := a_predicate.is_binary
		ensure then
			good_result: Result = a_predicate.is_binary
		end

feature -- Basic operations

	put (a_arguments: ARRAY [ITP_VARIABLE]; a_value: BOOLEAN) is
			-- Set valuation for `a_arguments' with `a_value'.
			-- Index of `a_arguments' is 1-based. They are arguments for `predicate'.
		local
			l_index1: INTEGER
			l_index2: INTEGER
			l_has: BOOLEAN
		do
			l_has := item (a_arguments)

			if l_has xor a_value then
					-- Update storage table.
				l_index1 := a_arguments.item (1).index
				l_index2 := a_arguments.item (2).index
				put_valuation (first_argument_table, l_index1, l_index2, a_value)
				put_valuation (second_argument_table, l_index2, l_index1, a_value)

					-- Update `count'.
				if l_has then
					count := count - 1
				else
					count := count + 1
				end
			end
		end

	put_valuation (a_table: like first_argument_table; a_index1, a_index2: INTEGER; a_value: BOOLEAN) is
			-- Put valuation `a_value' for object combination (a_index1, a_index2) into `a_table'.
		require
			a_table_attached: a_table /= Void
		local
			l_set: DS_HASH_SET [INTEGER]
		do
			if a_value then
				a_table.search (a_index1)
				if a_table.found then
					l_set := a_table.found_item
				else
					create l_set.make (barrel_set_initial_capacity)
					a_table.force_last (l_set, a_index1)
				end
				l_set.force_last (a_index2)
			else
				a_table.search (a_index1)
				if a_table.found then
					l_set := a_table.found_item
					l_set.remove (a_index2)
					if l_set.is_empty then
						a_table.remove (a_index1)
					end
				end
			end
		end

	wipe_out is
			-- Wipe out current all valuations.
		do
			first_argument_table.wipe_out
			second_argument_table.wipe_out
			count := 0
		ensure then
			first_argument_table_wiped_out: first_argument_table.is_empty
			second_argument_table_wiped_out: second_argument_table.is_empty
		end

feature -- Process

	process (a_visitor: AUT_PREDICATE_VALUATION_VISITOR) is
			-- Prcoess current with `a_visitor'.
		do
			a_visitor.process_binary_predicate_valuation (Current)
		end

feature{AUT_PREDICATE_VALUATION_CURSOR} -- Implementation

	first_argument_table: DS_HASH_TABLE [DS_HASH_SET [INTEGER], INTEGER]
			-- Table for the first argument

	second_argument_table: DS_HASH_TABLE [DS_HASH_SET [INTEGER], INTEGER]
			-- Table for the second argument

	argument_tables: ARRAY [like first_argument_table]
			-- Table for `first_argument_table' and `second_argument_table'

feature{NONE} -- Implementation

	argument_table_initial_capacity: INTEGER is 500
			-- Initial capacity for `first_argument_table' and
			-- `second_argument_table'

	barrel_set_initial_capacity: INTEGER is 10
			-- Initial capacity for second indexed arguments

invariant
	first_argument_table_attached: first_argument_table /= Void
	second_argument_table_attached: second_argument_table /= Void
	argument_tables_attached: argument_tables /= Void
	argument_tables_valid:
		argument_tables.lower = 1 and
		argument_tables.count = 1 and
		argument_tables.item (1) = first_argument_table and
		argument_tables.item (2) = second_argument_table

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
