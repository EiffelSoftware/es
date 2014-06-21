note
	description: "Summary description for {ES_ADB_FAULT_REPOSITORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_FAULT_REPOSITORY

feature -- Access

	fault_repository: DS_HASH_TABLE [ES_ADB_FAULT, EPA_TEST_CASE_SIGNATURE]
			-- Current repository.
		do
			Result := fault_repository_storage.item
		end

feature -- Query

	filtered_faults (a_filter: PREDICATE[ANY, TUPLE[ES_ADB_FAULT]]): DS_ARRAYED_LIST [ES_ADB_FAULT]
			-- List of faults satisfying `a_filter'.
		local
			l_cursor: DS_HASH_TABLE_CURSOR [ES_ADB_FAULT, EPA_TEST_CASE_SIGNATURE]
		do
			create Result.make_equal (fault_repository.count)
			from
				l_cursor := fault_repository.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				if a_filter.item ([l_cursor.item]) then
					Result.force_last (l_cursor.item)
				end
				l_cursor.forth
			end
		end

	fault_with_signature (a_sig: EPA_TEST_CASE_SIGNATURE; a_instantiate_fault: BOOLEAN): ES_ADB_FAULT
			-- Fault with `a_sig' from `fault_repository'.
			--
			-- If no such fault exists in the repo:
			-- 	when `a_instantiate_fault', create it, add it to repo, and then return it.
			--	otherwise, return Void.
		require
			a_sig /= Void
		local
		do
			if fault_repository.has (a_sig) then
				Result := fault_repository.item (a_sig)
			elseif a_instantiate_fault then
				create Result.make (a_sig)
				fault_repository.force (Result, a_sig)
			end
		end

	fault_with_signature_id (a_id: STRING): ES_ADB_FAULT
			-- Get the fault with signature id `a_id' from `fault_repository'.
		require
			fault_signature_from_id (a_id) /= Void
		local
			l_sig: EPA_TEST_CASE_SIGNATURE
		do
			l_sig := fault_signature_from_id (a_id)
			Result := fault_with_signature (l_sig, False)
		end

	number_of_faults_for_feature (a_feature: EPA_FEATURE_WITH_CONTEXT_CLASS): INTEGER
			-- Number of faults in `fault_repository' with their feature under test being `a_feature'.
		require
			a_feature /= Void
		local
			l_feature_with_context_str: STRING
			l_cursor: DS_HASH_TABLE_CURSOR [ES_ADB_FAULT, EPA_TEST_CASE_SIGNATURE]
		do
			l_feature_with_context_str := a_feature.qualified_feature_name
			from
				l_cursor := fault_repository.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				if l_cursor.key.class_and_feature_under_test ~ l_feature_with_context_str then
					Result := Result + 1
				end
				l_cursor.forth
			end
		end

feature -- Operation

	reset
			-- Reset `fault_repository'.
		do
			fault_repository_storage.put (create {DS_HASH_TABLE [ES_ADB_FAULT, EPA_TEST_CASE_SIGNATURE]}.make_equal (100))
		end

feature -- Auxiliary

	fault_signature_from_id (a_id: STRING): EPA_TEST_CASE_SIGNATURE
			-- Fault signature with the same id as `a_id'.
		local
			l_keys: DS_BILINEAR [EPA_TEST_CASE_SIGNATURE]
			l_key_cursor: DS_BILINEAR_CURSOR [EPA_TEST_CASE_SIGNATURE]
		do
			l_keys := fault_repository.keys
			from
				l_key_cursor := l_keys.new_cursor
				l_key_cursor.start
			until
				Result /= Void or else l_key_cursor.after
			loop
				if l_key_cursor.item.id ~ a_id then
					Result := l_key_cursor.item
				end
				l_key_cursor.forth
			end
		end

feature{NONE} -- Implementation

	fault_repository_storage: CELL [DS_HASH_TABLE [ES_ADB_FAULT, EPA_TEST_CASE_SIGNATURE]]
			-- Shared storage for `fault_repository'.
		once
			create Result.put (create {DS_HASH_TABLE [ES_ADB_FAULT, EPA_TEST_CASE_SIGNATURE]}.make_equal (100))
		end
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
