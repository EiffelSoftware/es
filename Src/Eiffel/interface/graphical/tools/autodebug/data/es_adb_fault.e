note
	description: "Summary description for {ES_ADB_FAULT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_FAULT

inherit
	EPA_UTILITY
		redefine
			is_equal
		end

	ES_ADB_INTERFACE_STRINGS
		redefine
			is_equal
		end

	HASHABLE
		redefine
			is_equal
		end

create
	make

feature{NONE} -- Initialization

	make (a_sig: EPA_TEST_CASE_SIGNATURE)
			-- Initialization
		require
			a_sig /= Void
		do
			signature := a_sig.twin
			create passing_tests.make_equal (10)
			create failing_tests.make_equal (10)
			create fixes.make_equal (20)
			set_status (Status_not_yet_attempted)
		end

feature -- Access

	signature: EPA_TEST_CASE_SIGNATURE
			-- Signiture of the fault.

	passing_tests: DS_ARRAYED_LIST [PATH]
			-- List of passing test paths.

	failing_tests: DS_ARRAYED_LIST [PATH]
			-- List of failing test paths.

	status: INTEGER assign set_status
			-- Status of the fault.

	fixes: DS_ARRAYED_LIST [ES_ADB_FIX]
			-- List of all candidate fixes to current.

	applied_fix: ES_ADB_FIX
			-- Fix from `fixes' that has been applied to correct current.
		local
			l_cursor: DS_ARRAYED_LIST_CURSOR [ES_ADB_FIX]
		do
			from
				l_cursor := fixes.new_cursor
				l_cursor.start
			until
				l_cursor.after or else Result /= Void
			loop
				if l_cursor.item.has_been_applied then
					Result := l_cursor.item
				else
					l_cursor.forth
				end
			end
		end

	status_string: STRING
			-- Status in string.
		do
			Result := (<<fault_status_to_be_attempted,
						Fault_status_candidate_fix_available,
						Fault_status_candidate_fix_unavailable,
						Fault_status_candidate_fix_accepted,
						Fault_status_manually_fixed>>).item (status)
		end

feature -- Setter

	set_status (a_status: INTEGER)
			--
		require
			is_valid_status (a_status)
		do
			status := a_status
		end

feature -- Status report

	is_fixed: BOOLEAN
			-- Is the fault fixed?
		do
			Result := applied_fix /= Void
		end

	is_valid_status (a_status: INTEGER): BOOLEAN
			--
		do
			Result := Status_not_yet_attempted <= a_status and then a_status <= Status_manually_fixed
		end

feature -- Constant

	Status_not_yet_attempted: INTEGER = 1
	Status_candidate_fix_available: INTEGER = 2
	Status_candidate_fix_unavailable: INTEGER = 3
	Status_candidate_fix_accepted: INTEGER = 4
	Status_manually_fixed: INTEGER = 5

feature -- Query

	class_and_feature_under_test: EPA_FEATURE_WITH_CONTEXT_CLASS
		local
			l_class_name, l_feat_name: STRING
		do
			if class_and_feature_under_test_internal = Void then
				l_class_name := signature.class_under_test
				l_feat_name := signature.feature_under_test
				create class_and_feature_under_test_internal.make_from_names (l_feat_name, l_class_name)
			end
			Result := class_and_feature_under_test_internal
		end

	is_equal (other: like Current): BOOLEAN
			-- <Precursor>
		do
			Result := signature ~ other.signature
		end

	hash_code: INTEGER
			-- <Precursor>
		do
			Result := signature.hash_code
		end

feature -- Basic operation

	add_passing_test (a_path: PATH)
			-- Add the passing test at `a_path' as one associated with Current.
		require
			a_path /= Void
			attached {EPA_TEST_CASE_SIGNATURE} (create {EPA_TEST_CASE_SIGNATURE}.make_with_string (a_path.entry.out)) as lt_sig
				and then lt_sig.is_passing and then lt_sig.class_and_feature_under_test ~ signature.class_and_feature_under_test
		do
			passing_tests.force_last (a_path)
		end

	add_failing_test (a_path: PATH)
			-- Add the failing test at `a_path' as one associated with Current.
		require
			a_path /= Void
			attached {EPA_TEST_CASE_SIGNATURE} (create {EPA_TEST_CASE_SIGNATURE}.make_with_string (a_path.entry.out)) as lt_sig
				and then lt_sig ~ signature
		do
			failing_tests.force_last (a_path)
		end

	add_fix (a_fix: ES_ADB_FIX)
			-- Add `a_fix' as a candidate fix to current.
		require
			a_fix.fault ~ Current
		do
			fixes.force_last (a_fix)
		end

--	apply_fix (a_fix: ES_ADB_FIX)
--			-- Apply `a_fix' to fix the current fault.
--		require
--			a_fix /= Void
--			fixes.has (a_fix)
--		do
--			a_fix.apply
--			applied_fix := a_fix
--		end

	copy_tests_to (a_dir: PATH)
			-- Copy all available tests into `a_dir'.
		require
			a_dir /= Void
		local
			l_tests: like passing_tests
			l_cursor: DS_ARRAYED_LIST_CURSOR [PATH]
		do
			across <<passing_tests, failing_tests>> as lt_tests_cursor loop
				l_tests := lt_tests_cursor.item
				from
					l_cursor := l_tests.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					copy_test_to (l_cursor.item, a_dir)
					l_cursor.forth
				end
			end
		end

feature{NONE} -- Implementation

	copy_test_to (a_path: PATH; a_dir: PATH)
			--
		local
			l_source, l_target: RAW_FILE
			l_retried: BOOLEAN
		do
			if not l_retried then
				create l_source.make_with_path (a_path)
				create l_target.make_with_path (a_dir.extended_path (a_path.entry))
				if l_source.exists then
					l_source.open_read
					l_target.open_write
					l_source.copy_to (l_target)
					l_source.close
					l_target.close
					l_target.set_date (l_source.date)
				end
			end
		rescue
			l_retried := True
			retry
		end

feature{NONE} -- Cache

	class_and_feature_under_test_internal: like class_and_feature_under_test

invariant
	fixes /= Void
	applied_fix /= Void implies (applied_fix.has_been_applied and fixes.has (applied_fix))

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
