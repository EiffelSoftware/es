note
	description: "Summary description for {ES_ADB_FIX_IMPLEMENTATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_FIX_IMPLEMENTATION

inherit
	ES_ADB_FIX_AUTOMATIC

create
	make

feature{NONE} -- Initialization

	make (a_fault: ES_ADB_FAULT; a_fixed_body: STRING; a_nature_str: STRING; a_ranking: REAL)
			-- Initialization.
		require
			a_fault /= Void
			a_fixed_body /= Void and then not a_fixed_body.is_empty
			Ranking_maximum >= a_ranking and then a_ranking >= Ranking_minimum
		local
		do
			set_fault (a_fault)
			set_nature_of_change (nature_of_change_from_string (a_nature_str))
			has_change_to_implementation := True
			has_change_to_contract := False
			has_been_applied := False
			type := Type_implementation_fix
			set_ranking (a_ranking)
		end

feature -- Status report

	is_valid_nature_of_change (a_nature: INTEGER): BOOLEAN
			-- <Precursor>
		do
			Result := Nature_unconditional_add <= a_nature and then a_nature <= Nature_conditional_replace
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

	apply
			-- <Precursor>
		local
		do
		end

feature -- Constant

	nature_of_change_strings: DS_HASH_TABLE [STRING_8, INTEGER]
			-- <Precursor>
		do
			if nature_of_change_strings_internal = Void then
				create nature_of_change_strings_internal.make_equal (10)
				nature_of_change_strings_internal.force ("UnconditionalAdd", Nature_unconditional_add)
				nature_of_change_strings_internal.force ("ConditionalAdd", Nature_conditional_add)
				nature_of_change_strings_internal.force ("ConditionalExecute", Nature_conditional_execute)
				nature_of_change_strings_internal.force ("ConditionalReplace", Nature_conditional_replace)
			end
			Result := nature_of_change_strings_internal
		end

	Nature_unconditional_add: INTEGER = 1
	Nature_conditional_add: INTEGER = 2
	Nature_conditional_execute: INTEGER = 3
	Nature_conditional_replace: INTEGER = 4

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
