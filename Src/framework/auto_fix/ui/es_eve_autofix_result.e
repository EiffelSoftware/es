note
	description: "Summary description for {ES_EVE_AUTOFIX_RESULT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EVE_AUTOFIX_RESULT

inherit
	DS_ARRAYED_LIST [ES_EVE_AUTOFIX_FIXING_SUGGESTION]
		rename make as make_list end

	KL_SHARED_FILE_SYSTEM
		undefine is_equal, copy end

	SHARED_EIFFEL_PROJECT
		undefine is_equal, copy end

	EPA_UTILITY
		undefine is_equal, copy end

	AFX_UTILITY
		undefine is_equal, copy end

create
	make

feature{NONE} -- Initialization

	make (a_fault_signature: STRING)
			-- Initialize an AutoFix result for `a_fault_signature'.

			-- Load the fixing results, if any, from the AutoFix results directory of the current project.
		require
			fault_signature_valid: is_fault_signature_valid (a_fault_signature)
		local
			l_path_name: PATH_NAME
			l_file_name: FILE_NAME
		do
			make_list (40)
			fault_signature := a_fault_signature.twin
			resolve_fixing_target

			reload
		end

feature -- Access

	fix_index_applied: INTEGER assign set_fix_index_applied
			-- Index of the valid fix that has been applied.

	is_fixed: BOOLEAN
			-- Is the related fault fixed alreay, i.e. a valid fix was applied?
		do
			Result := fix_index_applied > 0
		end

	short_summary_text: STRING
			-- Short summary text.
		do
			if is_fixed then
				Result := fault_summary + " (Fixed)"
			else
				Result := fault_summary.twin
			end
		end

	backup_class_file: STRING
			-- Name of the backup class file, if the fix has been applied.

feature -- Result file

	result_file_name: FILE_NAME
			-- Name of the result file.
		do
			if result_file_name_cache = Void then
				create result_file_name_cache.make_from_string (eiffel_project.project_directory.fixing_results_path)
				result_file_name_cache.set_file_name (fault_signature)
				result_file_name_cache.add_extension ("afr")
			end
			Result := result_file_name_cache
		end

	is_result_file_ready: BOOLEAN
			-- Is the fixing session associated with the result finished?
		local
			l_retried: BOOLEAN
			l_file: PLAIN_TEXT_FILE
		do
			if not l_retried then
				create l_file.make_open_append (result_file_name)
				if l_file.is_open_append then
					l_file.close
					Result := True
				end
			end
		rescue
			l_retried := True
			retry
		end

	is_result_file_outdated: BOOLEAN
			-- Is the result file outdated?
		local
			l_new_time_stamp: INTEGER
		do
			if is_result_file_ready then
				l_new_time_stamp := file_system.file_time_stamp (result_file_name)
				Result := l_new_time_stamp > time_stamp_of_result_file
			else
				Result := True
			end
		end

	is_load_successful: BOOLEAN
			-- Is last load from file successful?

feature -- Information about the fault

	fault_signature: STRING
			-- Signature of the fault, to which the result provides fixes.

	faulty_class: CLASS_C
			-- Faulty class under fixing.

	faulty_feature: FEATURE_I
			-- Faulty feature under fixing.

	exception_type: INTEGER
			-- Type of the entailed exception.

	breakpoint: INTEGER
			-- Location of the breakpoint of the exception.

	faulty_feature_text: STRING
			-- Text of the faulty feature under fixing.

	is_fault_signature_valid (a_sig: STRING): BOOLEAN
			-- Is `a_sig' a valid fault signature?
		local
			l_tmp: STRING
			l_segs: LIST[STRING]
		do
			if a_sig /= Void and then not a_sig.is_empty then
				l_tmp := a_sig.twin
				l_tmp.replace_substring_all ("__", ".")
				l_segs := l_tmp.split ('.')
				Result := (l_segs.count = 6)
						and then (feature_from_class (l_segs[1], l_segs[2]) /= Void )
						and then l_segs[3].is_integer and then l_segs[4].is_integer
						and then (feature_from_class (l_segs[5], l_segs[6]) /= Void)
			end
		end

	fault_summary: STRING
			-- String summarizing the fault information.
		do
			if fault_summary_cache = Void then
				inspect exception_type
				when 1 then fault_summary_cache := "(Void) "
				when 3 then fault_summary_cache := "(Prec) "
				when 4 then fault_summary_cache := "(Post) "
				when 6 then fault_summary_cache := "(Invt) "
				when 7 then fault_summary_cache := "(Chck) "
				end
				fault_summary_cache := fault_summary_cache + faulty_class.name_in_upper + "." + faulty_feature.feature_name + " @ " + breakpoint.out
			end
			Result := fault_summary_cache
		end

feature -- Basic operations

	reload
			-- Reload the result from `result_file_name'.
		local
			l_new_time_stamp: INTEGER
		do
			if is_result_file_outdated and then is_result_file_ready then
				load_from_file

				if is_load_successful then
					time_stamp_of_result_file := l_new_time_stamp
				end
			else
				reset
			end
		end

feature -- Applying and recalling a fix

	apply_fix (a_suggestion: ES_EVE_AUTOFIX_FIXING_SUGGESTION)
			-- Apply the fixing suggestion `a_suggestion'.
		require
			suggestion_attached: a_suggestion /= Void
		local
			l_exception: ES_EVE_AUTOFIX_EXCEPTION
			l_class_to_fix: CLASS_C
			l_should_preceed, l_should_backup, l_retried: BOOLEAN
			l_backup_dir_name: DIRECTORY_NAME
			l_origin_file_name, l_backup_file_name: FILE_NAME
			l_match_list: LEAF_AS_LIST
			l_routine_body_as: ROUT_BODY_AS
			l_new_body_text, l_new_class_content: STRING
			l_result_file_lines: DS_LINKED_LIST[STRING]
			l_content, l_line: STRING

			l_error_msg: STRING
			l_file: PLAIN_TEXT_FILE
			l_dir: DIRECTORY
			l_date_time: DATE_TIME
			l_date: DATE
			l_time_stamp: STRING
		do
			l_should_backup := True

			l_class_to_fix := a_suggestion.context_feature.written_class
			create l_origin_file_name.make_from_string (l_class_to_fix.file_name)

			if l_should_backup then
				create l_backup_dir_name.make_from_string (eiffel_project.project_directory.backup_path.to_string_32.as_string_8)
				create l_dir.make (l_backup_dir_name)
				if not l_dir.exists then
					file_system.recursive_create_directory (l_backup_dir_name)
				end
				if l_dir.exists and l_dir.is_writable then
						-- Construct a readable string for backup time.
					create l_date_time.make_now
					l_time_stamp := l_date_time.date.out
					l_time_stamp.replace_substring_all ("/", "")
					l_time_stamp.append ("-" + l_date_time.seconds.out)

					create l_backup_file_name.make_from_string (l_backup_dir_name)
					l_backup_file_name.set_file_name (l_class_to_fix.name.as_lower + "__" + l_time_stamp)
					l_backup_file_name.add_extension ("e")

					file_system.copy_file (l_origin_file_name, l_backup_file_name)
				end
			end

				-- Update the faulty feature body in the class text.
			l_match_list := match_list_server.item (l_class_to_fix.class_id)
			l_routine_body_as := a_suggestion.context_feature.body.body.as_routine.routine_body
			Entity_feature_parser.parse_from_utf8_string ("feature " + a_suggestion.diff_code, Void)
			l_new_body_text := text_from_ast (Entity_feature_parser.feature_node.body.as_routine.routine_body)
			l_new_body_text.replace_substring_all ("%N", "%N%T%T")
			l_routine_body_as.replace_text (l_new_body_text, l_match_list)
			l_new_class_content := l_class_to_fix.ast.text (l_match_list)

				-- Write back the updated class text to file.
			create l_file.make (l_origin_file_name)
			l_file.open_write
			if l_file.is_open_write then
				l_file.put_string (l_new_class_content)
				l_file.close
			end

				-- Update the result file.
			create l_file.make (result_file_name)
			l_file.open_read
			if l_file.is_open_read then
				create l_content.make(4096)
				from
				until l_file.end_of_file
				loop
					l_file.read_line
					l_line := l_file.last_string
					if not l_line.starts_with (Tag_valid_fix_applied) and not l_line.starts_with (Tag_backup_class_file) and not l_line.starts_with (Tag_last_fix_reverted)then
						l_content := l_content + l_line + "%N"
					end
				end
				l_file.close

				l_content := l_content + Tag_valid_fix_applied + a_suggestion.index.out + "%N"
				if l_should_backup then
					l_content := l_content + Tag_backup_class_file + l_backup_file_name + "%N"
				end
				l_file.open_write
				if l_file.is_open_write then
					l_file.put_string (l_content)
					l_file.close
				end
			end

				-- Update Current.
			fix_index_applied := a_suggestion.index
			backup_class_file := l_backup_file_name
		end

	revert
			-- Revert the fix applied before.
		require
			fault_fixed: is_fixed
			original_backuped: backup_class_file /= Void and then not backup_class_file.is_empty
		local
			l_backup_file_name, l_system_file_name: STRING
			l_backup_file, l_system_file, l_file: PLAIN_TEXT_FILE
			l_content, l_line: STRING
			l_size_backup, l_size_system: INTEGER
			l_exception: ES_EVE_AUTOFIX_EXCEPTION
		do
				-- Size of the backup class file.
			create l_backup_file.make (backup_class_file)
			l_size_backup := l_backup_file.count

				-- Copy the backup to system.
			l_system_file_name := faulty_feature.written_class.file_name
			file_system.copy_file (backup_class_file, l_system_file_name)

				-- Update the result file.
			create l_file.make (result_file_name)
			l_file.open_read
			if l_file.is_open_read then
				create l_content.make(4096)
				from
				until l_file.end_of_file
				loop
					l_file.read_line
					l_line := l_file.last_string
					if not l_line.starts_with (Tag_valid_fix_applied) and not l_line.starts_with (Tag_backup_class_file) and not l_line.starts_with (Tag_last_fix_reverted)then
						l_content := l_content + l_line + "%N"
					end
				end
				l_file.close

				l_content := l_content + Tag_last_fix_reverted + fix_index_applied.out + "%N"
				l_file.open_write
				if l_file.is_open_write then
					l_file.put_string (l_content)
					l_file.close
				end
			end

				-- Update Current.
			fix_index_applied := 0
			backup_class_file := Void
		end

feature {ES_AUTOFIX_WIDGET} -- Status set

	set_fix_index_applied (a_index: INTEGER)
			-- Set `fix_index_applied' with `a_index'.
		do
			fix_index_applied := a_index
		end

feature{NONE} -- Information about the fault

	resolve_fixing_target
			-- Resolve information about the fixing target,
			-- including the `faulty_class', `faulty_feature', and `faulty_feature_text'.
		local
			l_tmp: STRING
			l_segs: LIST[STRING]
			l_feat: FEATURE_I
		do
			l_tmp := fault_signature.twin
			l_tmp.replace_substring_all ("__", ".")
			l_segs := l_tmp.split ('.')

			faulty_class := first_class_starts_with_name (l_segs[5])
			faulty_feature := faulty_class.feature_named (l_segs[6])
			exception_type := l_segs[3].to_integer
			breakpoint := l_segs[4].to_integer
			faulty_feature_text := formated_feature (faulty_feature)
		end

feature {NONE} -- Implementation

	reset
			-- Reset the result status.
		do
			is_load_successful := False
			time_stamp_of_result_file := 0
			fix_index_applied := 0
			wipe_out
		end

	load_from_file
			-- Reload the result from `result_file_name'.
		local
			l_retried: BOOLEAN
			l_file: PLAIN_TEXT_FILE
			l_line: STRING
			l_index: INTEGER
			l_ranking: DOUBLE
			l_inside_valid_fix, l_inside_summary: BOOLEAN
			l_fix_content: STRING
			l_suggestion: ES_EVE_AUTOFIX_FIXING_SUGGESTION
			l_segs: LIST[STRING]
		do
			reset
			if not l_retried then
				create l_file.make (result_file_name)
				l_file.open_read
				if l_file.is_open_read then
					l_inside_valid_fix := False
					l_inside_summary := False
					create l_fix_content.make (1024)

					from l_file.read_line
					until l_file.after
					loop
						l_line := l_file.last_string.twin

						if l_line.starts_with (Tag_valid_fix_start) then
							l_line := l_line.substring (l_line.index_of ('@', 1) + 1, l_line.count)
							l_ranking := l_line.to_double
							l_inside_valid_fix := True
						elseif l_line.ends_with (Tag_valid_fix_end) then
							l_inside_valid_fix := False
							create l_suggestion.make (Current, faulty_class, faulty_feature, faulty_feature_text, l_fix_content, l_ranking)
							force_last (l_suggestion)
							create l_fix_content.make (1024)
						elseif l_line.starts_with (Tag_summary_start) then
							l_inside_summary := True
						elseif l_line.starts_with (Tag_summary_end) then
							l_inside_summary := False
						elseif l_line.starts_with (Tag_valid_fix_applied) then
							l_segs := l_line.split (':')
							if l_segs.count > 1 and then l_segs[2].is_integer then
								fix_index_applied := l_segs[2].to_integer
							end
						elseif l_line.starts_with (Tag_backup_class_file) then
							backup_class_file := l_line.substring (l_line.index_of (':', 1) + 1, l_line.count)
							backup_class_file.prune_all_leading (' ')
						elseif l_line.starts_with (Tag_last_fix_reverted) then
							fix_index_applied := 0
							backup_class_file := Void
--						elseif l_inside_summary then
--							l_segs := l_line.split (':')
--							if l_segs.count > 1 and then l_segs[1].starts_with (Tag_summary_session_length) and then l_segs[2].is_integer then
--								session_length := l_segs[2].to_integer
--							end
						elseif l_inside_valid_fix then
							if not l_line.starts_with ("--") and then not l_line.is_empty then
								l_fix_content.append (l_line + "%N")
							end
						end
						l_file.read_line
					end
					l_file.close
				end

				sort_and_index_by_ranking
			end
		rescue
			l_retried := True
			is_load_successful := False
			retry
		end

	sort_and_index_by_ranking
			-- Sort and index the fixing suggestions by their ranking.
		local
			l_order: AGENT_BASED_EQUALITY_TESTER [ES_EVE_AUTOFIX_FIXING_SUGGESTION]
			l_sorter: DS_QUICK_SORTER [ES_EVE_AUTOFIX_FIXING_SUGGESTION]
			l_index: INTEGER
		do
				-- Sort
			create l_order.make (
					agent (a_suggestion1, a_suggestion2: ES_EVE_AUTOFIX_FIXING_SUGGESTION): BOOLEAN
						do
							Result := a_suggestion1.ranking < a_suggestion2.ranking
						end
				)
			create l_sorter.make (l_order)
			sort (l_sorter)

				-- Index
			from
				start
				l_index := 1
			until
				after
			loop
				item_for_iteration.index := l_index
				l_index := l_index + 1
				forth
			end
		end

feature {NONE} -- Access

	time_stamp_of_result_file: INTEGER
			-- Time stamp of the result file, from which the AutoFix result is loaded.

	result_file_name_cache: FILE_NAME
			-- Cache for `result_file_name'.

	fault_summary_cache: STRING
			-- Cache for `fault_summary'.

feature -- Constants

	Tag_valid_fix_start: STRING = ">> valid_fix_candidate_start_tag <<"
	Tag_valid_fix_end:	 STRING = ">> valid_fix_candidate_end_tag <<"
	Tag_summary_start:	 STRING = ">> Summary_start_tag <<"
	Tag_summary_end:	 STRING = ">> Summary_end_tag <<"

	Tag_summary_session_length: STRING = "Session length (ms)"
	Tag_summary_number_of_valid_fixes: STRING = "Nr. of valid candidates"

	Tag_valid_fix_applied: 	 STRING = "Candidate fix applied: "
	Tag_backup_class_file:	 STRING = "Class file backuped: "
	Tag_last_fix_reverted:   STRING = "Recall: "

;note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
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
