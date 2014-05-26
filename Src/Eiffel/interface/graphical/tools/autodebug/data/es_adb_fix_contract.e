note
	description: "Summary description for {ES_ADB_FIX_CONTRACT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_FIX_CONTRACT

inherit
	ES_ADB_FIX_AUTOMATIC

create
	make

feature{NONE} -- Initialization

	make (a_fault: ES_ADB_FAULT; a_nature_str: STRING; a_ranking: REAL)
			-- Initialization.
		require
			a_fault /= Void
			is_valid_nature_of_change (nature_of_change_from_string (a_nature_str))
			Ranking_maximum >= a_ranking and then a_ranking >= Ranking_minimum
		local
		do
			set_fault (a_fault)
			set_nature_of_change (nature_of_change_from_string (a_nature_str))
			has_change_to_implementation := False
			has_change_to_contract := True
			has_been_applied := False
			type := Type_contract_fix
			set_ranking (a_ranking)
		end

feature -- Access

	changes: DS_HASH_TABLE [TUPLE[pre, post: STRING], EPA_FEATURE_WITH_CONTEXT_CLASS]
			-- Changes to the contracts of features.
		do
			if changes_internal = Void then
				create changes_internal.make_equal (10)
			end
			Result := changes_internal
		end

	code_before_fix: STRING
			-- <Precursor>
		do

		end

	code_after_fix: STRING
			-- <Precursor>
		do

		end

feature -- Operation

	is_valid_nature_of_change (a_nature: INTEGER): BOOLEAN
			-- <Precursor>
		do
			Result := Nature_strengthen <= a_nature and then a_nature <= Nature_weaken_and_strengthen
		end

	apply
			-- <Precursor>
		local
		do
		end

	load_changes (a_str: STRING)
			-- Load `changes' from `a_str'.
		local
		do
		end

feature -- Contant

	nature_of_change_strings: DS_HASH_TABLE [STRING_8, INTEGER]
			-- <Precursor>
		do
			if nature_of_change_strings_internal = Void then
				create nature_of_change_strings_internal.make_equal (10)
				nature_of_change_strings_internal.force ("Strengthen", Nature_strengthen)
				nature_of_change_strings_internal.force ("Weaken", Nature_weaken)
				nature_of_change_strings_internal.force ("WeakenAndStrengthen", Nature_weaken_and_strengthen)
			end
			Result := nature_of_change_strings_internal
		end

feature{NONE} -- Implementation

	Nature_strengthen: INTEGER = 5
	Nature_weaken: INTEGER = 6
	Nature_weaken_and_strengthen: INTEGER = 7

feature{NONE} -- Cache

	changes_internal: like changes
	nature_of_change_strings_internal: like nature_of_change_strings

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
