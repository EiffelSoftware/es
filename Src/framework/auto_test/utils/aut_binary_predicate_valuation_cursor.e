note
	description: "Summary description for {AUT_BINARY_PREDICATE_VALUATION_CURSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_BINARY_PREDICATE_VALUATION_CURSOR

inherit
	AUT_PREDICATE_VALUATION_CURSOR
		redefine
			container
		end

create
	make

feature -- Status report

	after: BOOLEAN
			-- Is there no valid position to right of cursor?

feature -- Access

	container: AUT_BINARY_PREDICATE_VALUATION
			-- Predicate valuation associated with current cursor

feature -- Cursor movement

	start is
			-- Move cursor to first position.
		local
			l_free_vars: like free_variables
			l_bounded_var_index: INTEGER
			l_mapping: DS_HASH_TABLE [INTEGER, INTEGER]
			l_bounded_var_tbl: DS_HASH_TABLE [DS_HASH_SET [INTEGER], INTEGER]
		do
			before := False
			l_free_vars := free_variables
			l_mapping := constraint.argument_mapping.item (container.predicate)
			if l_free_vars.count = 2 then
					-- Both arguments are free.
				main_cursor := container.first_argument_table.new_cursor
				main_cursor.start
				after := main_cursor.after
				if not after then
					barrel_cursor := main_cursor.item.new_cursor
					barrel_cursor.start
					after := barrel_cursor.after
				end

			elseif l_free_vars.count = 1 then
					-- One argument is free.
				main_cursor := Void
				l_free_vars.start
				l_bounded_var_tbl := container.argument_tables.item (l_free_vars.key_for_iteration)
				l_bounded_var_index := candidate.item (l_mapping.item (l_free_vars.key_for_iteration)).index
				barrel_cursor := l_bounded_var_tbl.item (l_bounded_var_index).new_cursor
				barrel_cursor.start
				after := barrel_cursor.after

			else
					-- Both arguments are bounded.
				after := container.item (<<variable_from_index (candidate.item (free_variables.item (1)).index),
										   variable_from_index (candidate.item (free_variables.item (2)).index)>>)
			end
		end

	forth is
			-- Move cursor to next position.
		do
			if free_variables.count = 0 then
				after := True
			else
				if barrel_cursor /= Void then
					if barrel_cursor.is_last then
						if main_cursor = Void then
							after := True
						else
							main_cursor.forth
							after := main_cursor.after
							if not after then
								barrel_cursor := main_cursor.item.new_cursor
								barrel_cursor.start
								after := barrel_cursor.after
							end
						end
					else
						barrel_cursor.forth
					end
				end
			end
		end

feature -- Basic operations

	update_candidate_with_item is
			-- Update `candidate' with objects at the position of current cursor.
		local
			l_free_vars: like free_variables
			l_free_var_index: INTEGER
			l_mapping: DS_HASH_TABLE [INTEGER, INTEGER]
			l_candidate: like candidate
		do
			l_free_vars := free_variables
			if not l_free_vars.is_empty then
				l_free_vars := free_variables
				l_mapping := constraint.argument_mapping.item (container.predicate)
				l_candidate := candidate
				l_free_vars.start
				if l_free_vars.count = 1 then
					l_free_var_index := l_candidate.item (l_mapping.item (l_free_vars.key_for_iteration)).index
					l_candidate.put (variable_from_index (barrel_cursor.item), l_free_var_index)
				elseif l_free_vars.count = 2 then
					l_free_var_index := l_mapping.item (l_free_vars.key_for_iteration)
					l_candidate.put (variable_from_index (main_cursor.key), l_free_var_index)
					l_free_vars.forth
					l_free_var_index := l_mapping.item (l_free_vars.key_for_iteration)
					l_candidate.put (variable_from_index (barrel_cursor.item), l_free_var_index)
				end
			end
		end

feature{NONE} -- Implementation

	main_cursor: detachable DS_HASH_TABLE_CURSOR [DS_HASH_SET [INTEGER], INTEGER]
			--- Cursor to iterate through the first indexed arguments

	barrel_cursor: detachable DS_HASH_SET_CURSOR [INTEGER]
			-- Cursor to iterate through the second indexed arguments

invariant
	free_variables_valid: free_variables.count >= 0 and then free_variables.count <= 2

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
