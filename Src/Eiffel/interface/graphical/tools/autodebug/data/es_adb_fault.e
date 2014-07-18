note
	description: "Summary description for {ES_ADB_FAULT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_FAULT

inherit

	ES_ADB_SHARED_INFO_CENTER
		redefine
			is_equal
		end

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
			create fixes.make_equal (20)
			if is_approachable then
				set_status (Status_not_yet_attempted)
			else
				set_status (Status_out_of_scope)
			end
		end

feature -- Access

	signature: EPA_TEST_CASE_SIGNATURE
			-- Signiture of the fault.

	test_cases: TUPLE [passing, failing: DS_HASH_SET [ES_ADB_TEST]]
		do
			Result := info_center.test_cases_for_fault (Current)
		end

	status: INTEGER assign set_status
			-- Status of the fault.

	fixes: DS_ARRAYED_LIST [ES_ADB_FIX]
			-- List of all candidate fixes to current.

feature -- Status report

	is_fixed: BOOLEAN
			-- Is the fault fixed?
		do
			Result := is_candidate_fix_accepted or is_manually_fixed
		end

	is_valid_status (a_status: INTEGER): BOOLEAN
			-- Is `a_status' a valid status for current?
		do
			Result := Status_out_of_scope <= a_status and then a_status <= Status_manually_fixed
		end

	is_exception_type_in_scope_of_implementation_fixing: BOOLEAN
			-- Is the exception type of current in the scope of implementation fixing?
		local
			l_code: INTEGER
		do
			l_code := signature.exception_code
			Result := l_code = {EXCEP_CONST}.void_call_target
					or else l_code = {EXCEP_CONST}.precondition
					or else l_code = {EXCEP_CONST}.postcondition
					or else l_code = {EXCEP_CONST}.class_invariant
		end

	is_exception_type_in_scope_of_contract_fixing: BOOLEAN
			-- Is the exception type of current in the scope of contract fixing?
		local
			l_code: INTEGER
		do
			l_code := signature.exception_code
			Result := l_code = {EXCEP_CONST}.void_call_target
					or else l_code = {EXCEP_CONST}.precondition
					or else l_code = {EXCEP_CONST}.postcondition
		end

	is_approachable: BOOLEAN
			-- Is current approachable by AutoFix?
		do
			Result := is_exception_type_in_scope_of_implementation_fixing or else is_exception_type_in_scope_of_contract_fixing
		end

	is_approachable_per_config (a_config: ES_ADB_CONFIG): BOOLEAN
			-- Is current approachable under the `a_config'?
		do
			Result := is_exception_type_in_scope_of_contract_fixing and then a_config.should_fix_contracts
							or else is_exception_type_in_scope_of_implementation_fixing and then a_config.should_fix_implementation
		end

	is_not_yet_attempted: BOOLEAN
			-- Is current not yet attempted by AutoFix?
		do
			Result := status = Status_not_yet_attempted
		end

	is_candidate_fix_available: BOOLEAN
			-- Is current a fault with candidate fix available?
		do
			Result := status = Status_candidate_fix_available
		end

	is_candidate_fix_unavailable: BOOLEAN
			-- Is current a fault with NO candidate fix available?
		do
			Result := status = Status_candidate_fix_unavailable
		end

	is_candidate_fix_accepted: BOOLEAN
			-- Is current a fault with candidate fix accepted?
		do
			Result := status = Status_candidate_fix_accepted
		end

	is_manually_fixed: BOOLEAN
			-- Is current manually fixed?
		do
			Result := status = Status_manually_fixed
		end

	is_equal (other: like Current): BOOLEAN
			-- <Precursor>
		do
			Result := signature ~ other.signature
		end

feature -- Query

	class_and_feature_under_test: EPA_FEATURE_WITH_CONTEXT_CLASS
			-- Feature under test when current is detected.
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

	recipient_class_and_feature: EPA_FEATURE_WITH_CONTEXT_CLASS
			-- Recipient feature when current is triggered.
		local
			l_class_name, l_feat_name: STRING
		do
			if recipient_class_and_feature_internal = Void then
				l_class_name := signature.recipient_class
				l_feat_name := signature.recipient
				create recipient_class_and_feature_internal.make_from_names (l_feat_name, l_class_name)
			end
			Result := recipient_class_and_feature_internal
		end

	failing_feature_with_context: EPA_FEATURE_WITH_CONTEXT_CLASS
			-- Failing feature when current is triggered.
		require
			is_exception_type_in_scope_of_contract_fixing
		local
			l_test_path: PATH
			l_file: PLAIN_TEXT_FILE
			l_dashes: STRING
			l_is_in_trace: BOOLEAN
			l_cache: STRING
			l_line: STRING
			l_exception_trace: STRING
			l_explainer: EPA_EXCEPTION_TRACE_EXPLAINER
			l_last_explanation: EPA_EXCEPTION_TRACE_SUMMARY
		do
			l_dashes := "-------------------------------------------------------------------------------"
			l_test_path := test_cases.failing.first.location
			check l_test_path /= Void end
			create l_exception_trace.make (1024 * 4)
			create l_cache.make (1024)
			create l_file.make_with_path (l_test_path)
			l_file.open_read
			from
				l_file.read_line
				l_is_in_trace := False
			until
				l_file.end_of_file
			loop
				l_line := l_file.last_string

				if l_line.starts_with (l_dashes) then
					if not l_is_in_trace then
						l_exception_trace.append (l_line + "%N")
						l_is_in_trace := True
					else
						l_exception_trace.append (l_cache)
						l_cache.wipe_out
						l_exception_trace.append (l_line + "%N")
					end
				else
					if l_is_in_trace then
						l_cache.append (l_line + "%N")
					end
				end

				l_file.read_line
			end
			l_file.close

			create l_explainer
			l_explainer.explain (l_exception_trace)
			l_last_explanation := l_explainer.last_explanation
			create Result.make (l_last_explanation.failing_feature, l_last_explanation.failing_context_class)
		end

	has_fix (a_fix: ES_ADB_FIX): BOOLEAN
			-- Has current a fix `a_fix'?
		require
			a_fix /= Void
		do
			Result := fix_with_id_string (a_fix.fix_id_string) ~ a_fix
		end

	fix_with_id_string (a_id_string: STRING): ES_ADB_FIX
			-- Fix from `fixes' that has `a_id_string'.
			-- Return Void if no such fix is found.
		local
			l_cursor: DS_ARRAYED_LIST_CURSOR [ES_ADB_FIX]
		do
			from
				l_cursor := fixes.new_cursor
				l_cursor.start
			until
				l_cursor.after or else Result /= Void
			loop
				if l_cursor.item.fix_id_string ~ a_id_string then
					Result := l_cursor.item
				else
					l_cursor.forth
				end
			end
		end

	applied_fix: ES_ADB_FIX
			-- Fix from `fixes' that has been applied to correct current.
			-- Return Void if no fix has been applied.
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
			Result := (<<
						Fault_status_out_of_scope,
						Fault_status_to_be_attempted,
						Fault_status_candidate_fix_available,
						Fault_status_candidate_fix_unavailable,
						Fault_status_candidate_fix_accepted,
						Fault_status_manually_fixed>>).item (status)
		end

	hash_code: INTEGER
			-- <Precursor>
		do
			Result := signature.hash_code
		end

feature -- Operation

	add_fix (a_fix: ES_ADB_FIX)
			-- Add `a_fix' as a fix to current.
		require
			a_fix.fault = Current
		do
			fixes.force_last (a_fix)
			if attached {ES_ADB_FIX_AUTOMATIC} a_fix then
				set_status (Status_candidate_fix_available)
			elseif attached {ES_ADB_FIX_MANUAL} a_fix then
				set_status (status_manually_fixed)
			end
		end

	discard_all_fixes
			-- Discard all fixes.
		do
			fixes.wipe_out
		end

feature -- Setter

	manual_fix: ES_ADB_FIX_MANUAL
			-- A manual fix for current.
		do
			create Result.make (Current, True, True)
		ensure
			Result /= Void
		end

	set_status (a_status: INTEGER)
			-- Set `status' with `a_status'.
		require
			is_valid_status (a_status)
		do
			status := a_status
		end

feature -- Constant

	Status_out_of_scope: INTEGER = 1
	Status_not_yet_attempted: INTEGER = 2
	Status_candidate_fix_available: INTEGER = 3
	Status_candidate_fix_unavailable: INTEGER = 4
	Status_candidate_fix_accepted: INTEGER = 5
	Status_manually_fixed: INTEGER = 6

feature{NONE} -- Cache

	class_and_feature_under_test_internal: like class_and_feature_under_test
	recipient_class_and_feature_internal:  like recipient_class_and_feature

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
