note
	description: "Summary description for {ES_ADB_FIX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ES_ADB_FIX

inherit
	ANY
		redefine
			is_equal
		end

	HASHABLE
		redefine
			is_equal
		end

feature -- Access

	fix_id_string: STRING
			-- ID of the fix in string.
		deferred
		end

	fault: ES_ADB_FAULT assign set_fault
			-- Fault associated with Current.

	type: STRING
			-- Type of the fix.
			-- Possible value: FixToContract, FixToImplementation, ManualFix.

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

	is_equal (a_other: like Current): BOOLEAN
			-- <Precursor>
		do
			Result := type ~ a_other.type and then fault ~ a_other.fault and then fix_id_string ~ a_other.fix_id_string
		end

feature -- Query

	fix_summary: STRING
			-- Summary of current.
		local
		do
			if fix_summary_internal = Void then
				create fix_summary_internal.make (256)
				fix_summary_internal.append ("%T-- FaultID:")
				fix_summary_internal.append (fault.signature.id)
				fix_summary_internal.append (";%N%T-- FixID:")
				fix_summary_internal.append ("Subject=" + type + ";")
				fix_summary_internal.append ("ID=" + fix_id_string + ";")
				fix_summary_internal.append ("Validity=True;")
				fix_summary_internal.append ("Type=" + nature_of_change_string + ";")
			end
			Result := fix_summary_internal
		end

	nature_of_change_string: STRING
			-- Nature of the change in string.
		do
			Result := nature_of_change_strings.item (nature_of_change)
		end

	hunk: ES_EVE_CODE_DIFF_HUNK
			-- Hunk diff-ing `code_before_fix' and `code_after_fix'.
		do
			if hunk_internal = Void then
				create hunk_internal.make (code_before_fix, code_after_fix)
			end
			Result := hunk_internal
		end

	hash_code: INTEGER
			-- <Precursor>
		do
			Result := code_after_fix.hash_code
		end

	nature_of_change_strings: DS_HASH_TABLE [STRING, INTEGER]
			-- Nature of changes in strings.
		deferred
		end

feature -- Operation

	reset_hunk
			-- Reset `hunk'.
		do
			hunk_internal := Void
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
			-- Set `fault' with `a_fault'.
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
			-- Set `ranking' with `a_ranking'.
		do
			ranking := a_ranking
		end

feature -- Contant

	Type_contract_fix: STRING = "FixToContract"
	Type_implementation_fix: STRING = "FixToImplementation"
	Type_manual_fix: STRING = "ManualFix"

	Nature_unknown: INTEGER = 0
	Ranking_maximum: REAL = 100.0
	Ranking_minimum: REAL = 0.0

feature{NONE} -- Cache

	hunk_internal: like hunk

	fix_summary_internal: STRING

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
