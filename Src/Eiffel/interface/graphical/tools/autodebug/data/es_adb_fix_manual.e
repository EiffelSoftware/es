note
	description: "Summary description for {ES_ADB_FIX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_FIX_MANUAL

inherit
	ES_ADB_FIX

create
	make

feature -- Initialization

	make (a_fault: ES_ADB_FAULT; a_change_implementation, a_change_contract: BOOLEAN)
			-- Initialization.
		do
			fault := a_fault
			has_change_to_implementation := a_change_implementation
			has_change_to_contract := a_change_contract
			set_nature_of_change (Nature_manual)
			set_ranking (Ranking_maximum)
			type := Type_manual_fix

			a_fault.add_fix (Current)
		end

feature -- Access

	fix_id_string: STRING = "Manual"
			-- <Precursor>

	code_before_fix: STRING = "Information unavailable"
			-- <Precursor>

	code_after_fix: STRING = "Information unavailable"
			-- <Precursor>

	has_been_applied: BOOLEAN = True
			-- <Precursor>

feature -- Status report

	is_valid_nature_of_change (a_nature: INTEGER): BOOLEAN
			-- <Precursor>
		do
			Result := a_nature = Nature_manual
		end

feature -- Constant

	nature_of_change_strings: DS_HASH_TABLE [STRING_8, INTEGER]
			-- <Precursor>
		do
			if nature_of_change_strings_internal = Void then
				create nature_of_change_strings_internal.make_equal (1)
				nature_of_change_strings_internal.force ("Manual", Nature_manual)
			end
			Result := nature_of_change_strings_internal
		end

feature -- Constant

	Nature_manual: INTEGER = 8

feature{NONE} -- Implementation

	nature_of_change_strings_internal: like nature_of_change_strings
;
note
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
