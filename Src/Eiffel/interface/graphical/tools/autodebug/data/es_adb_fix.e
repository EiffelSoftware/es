note
	description: "Summary description for {ES_ADB_FIX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ES_ADB_FIX

feature -- Access

	fault: ES_ADB_FAULT assign set_fault
			-- Fault associated with Current.

	type: STRING
			-- Type of the fix.
			-- Possible value: ContractFix, ImplementationFix, ManualFix.

	nature_of_change: INTEGER assign set_nature_of_change
			-- Nature of the change due to the fix.

	ranking: REAL assign set_ranking
			-- Ranking of the fix.

	code_before_fix: STRING
			-- Code before fix.
		deferred
		end

	code_after_fix: STRING
			-- Code after fix.
		deferred
		end

feature -- Status report

	has_change_to_implementation: BOOLEAN
			-- Has current any change to the implementation?

	has_change_to_contract: BOOLEAN
			-- Has current any change to the contract?

	has_been_applied: BOOLEAN
			-- Has current been applied to the code?
		deferred
		end

	is_valid_nature_of_change (a_nature: INTEGER): BOOLEAN
			-- Is `a_nature' a valid nature of change?
		deferred
		end

	nature_of_change_string: STRING
			-- Nature of the change in string.
		do
			Result := nature_of_change_strings.item (nature_of_change)
		end

feature -- Operation

--	subject_of_change: STRING
--			-- Subject that the fix changes.
--		do
--			create Result.make (32)
--			if has_change_to_implementation then
--				Result.append ("implementation")
--			end
--			if has_change_to_contract then
--				if not Result.is_empty then
--					Result.append (" and ")
--				end
--				Result.append ("contract")
--			end
--		end

	apply
			-- Apply the fix to code.
		require
			not has_been_applied
		deferred
		ensure
			has_been_applied
		end

	nature_of_change_from_string (a_str: STRING): INTEGER
			-- Get `nature_of_change' according to `a_str'.
		require
			nature_of_change_strings.to_array.has (a_str)
		local
			l_cursor: DS_HASH_TABLE_CURSOR [STRING, INTEGER]
			l_index, l_count: INTEGER
		do
			from
				l_cursor := nature_of_change_strings.new_cursor
				l_cursor.start
			until
				Result > 0 or else l_cursor.after
			loop
				if a_str ~ l_cursor.item then
					Result := l_cursor.key
				end
				l_cursor.forth
			end
		ensure
			is_valid_nature_of_change (Result)
		end

feature -- Setters

	set_fault (a_fault: like fault)
		require
			fault = Void
		do
			fault := a_fault
		end

	set_nature_of_change (a_nature: INTEGER)
			-- Set `nature_of_change' with `a_nature'.
		require
			is_valid_nature_of_change (a_nature)
		do
			nature_of_change := a_nature
		end

	set_ranking (a_ranking: REAL)
			--
		do
			ranking := a_ranking
		end

feature -- Contant

	nature_of_change_strings: DS_HASH_TABLE [STRING, INTEGER]
			-- Nature of changes in strings.
		deferred
		end

	Type_contract_fix: STRING = "ContractFix"
	Type_implementation_fix: STRING = "ImplementationFix"
	Type_manual_fix: STRING = "ManualFix"

	Nature_unknown: INTEGER = 0
	Ranking_maximum: REAL = 100.0
	Ranking_minimum: REAL = 0.0

--	Nature_unconditional_add: INTEGER = 1
--	Nature_conditional_add: INTEGER = 2
--	Nature_conditional_execute: INTEGER = 3
--	Nature_conditional_replace: INTEGER = 4

--	Nature_strengthen: INTEGER = 5
--	Nature_weaken: INTEGER = 6
--	Nature_weaken_and_strengthen: INTEGER = 7

--  Nature_manual: INTEGER = 8

;note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
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
