
class ES_ADB_TOOL_HELPER

inherit

	ES_ADB_SHARED_INFO_CENTER
		undefine
			default_create,
			copy,
			is_equal
		end

	ES_SHARED_PROMPT_PROVIDER

	SHARED_EXECUTION_ENVIRONMENT
		undefine
			copy,
			default_create,
			is_equal
		end

	EPA_UTILITY
		undefine
			copy,
			default_create,
			is_equal
		end

feature -- Execution environment

	eve_path: PATH
		do
			create Result.make_from_string (execution_environment.arguments.command_name)
		end

	project_path: PATH
		do
			Result := workbench.eiffel_project.project_directory.path
		end

	project_ecf_path: PATH
		do
			Result := workbench.eiffel_ace.lace.conf_system.file_path
		end

	target_of_project: STRING
		do
			Result := workbench.eiffel_project.project_directory.target.as_string_8
		end

feature -- Access

	show_error_message (a_error_agent: FUNCTION [ANY, TUPLE, EB_METRIC_ERROR]; a_clear_error_agent: PROCEDURE [ANY, TUPLE]; a_window: EV_WINDOW)
			-- Show error message retrieved from `a_error_agent' if any in `a_window'.
			-- And then clear error by calling `a_clear_error_agent'.
		require
			a_error_agent_attached: a_error_agent /= Void
			a_clear_error_agent_attached: a_clear_error_agent /= Void
		local
			l_error: EB_METRIC_ERROR
		do
			l_error := a_error_agent.item (Void)
			if l_error /= Void then
				prompts.show_error_prompt (l_error.message_with_location, a_window, Void)
				a_clear_error_agent.call (Void)
			end
		end

feature -- Copy project

	directory_content_filter (a_entry: STRING): BOOLEAN
			--
		require
			a_entry /= Void and then not a_entry.is_empty
		do
			Result := a_entry /~ "CVS" and then a_entry /~ ".svn" and then a_entry /~ "EIFGENs"
		end

	copy_recursive (a_source_directory_name, a_target_directory_name: READABLE_STRING_GENERAL; a_filter: PREDICATE [ANY, TUPLE [STRING]])
			-- Copy `a_source_directory_name' to `a_target_directory_name' recursively.
			-- Only directories with named satisfying `a_filter' will be copied.

			-- Adapted from {AUT_FILE_SYSTEM_ROUTINES}.
		require
			a_source_directory_name_not_void: a_source_directory_name /= Void
			a_target_directory_name_not_void: a_target_directory_name /= Void
		local
			source_directory: DIRECTORY
			sub_directory: DIRECTORY
			file: RAW_FILE
			entry_name: STRING
			full_entry_name, target_full_entry_name: PATH
			dirname: PATH
			u: FILE_UTILITIES
		do
			create dirname.make_from_string (a_target_directory_name)
			create sub_directory.make_with_path (dirname)
			if not sub_directory.exists then
				sub_directory.create_dir
				if not sub_directory.is_closed then
					sub_directory.close
				end
			end
			create dirname.make_from_string (a_source_directory_name)
			create source_directory.make_with_path (dirname)
			if source_directory.exists then
				source_directory.open_read
				if not source_directory.is_closed then
					from
						source_directory.start
						source_directory.readentry
					until
						source_directory.lastentry = Void
					loop
						entry_name := source_directory.lastentry
						if not entry_name.same_string_general (".") and not entry_name.same_string_general ("..") then
							create full_entry_name.make_from_string (a_source_directory_name)
							full_entry_name := full_entry_name.extended (entry_name)
							create target_full_entry_name.make_from_string (a_target_directory_name)
							target_full_entry_name := target_full_entry_name.extended (entry_name)
							create sub_directory.make_with_path (full_entry_name)
							if sub_directory.exists then
								if a_filter (entry_name) then
									create sub_directory.make_with_path (target_full_entry_name)
									if not sub_directory.exists then
										sub_directory.create_dir
									end
									if not sub_directory.is_closed then
										sub_directory.close
									end
									copy_recursive (full_entry_name.name, target_full_entry_name.name, a_filter)
								end
							else
								u.copy_file_path (full_entry_name, target_full_entry_name)
							end
						end
						source_directory.readentry
					end
					source_directory.close
				end
			end
		end

	copy_project (a_project: E_PROJECT; a_working_dir: ES_ADB_WORKING_DIRECTORY)
			--
		require
			a_project /= Void
			a_working_dir /= Void
		local
			l_src_dir, l_dest_dir: PATH
		do
			l_src_dir := a_project.project_directory.location
			l_dest_dir := a_working_dir.temp_dir
			copy_recursive (l_src_dir.out, l_dest_dir.out, agent directory_content_filter)
		end

	is_project_copied_into_working_dir: BOOLEAN
			--
--		require
--			a_project /= Void
--			a_working_dir /= Void
		local
--			l_ecf_file_name: STRING
--			l_ecf_path_in_working_dir: PATH

--			l_prj_path_str, l_ecf_path_str: STRING
--			l_location: PATH
--			l_path: PATH
			l_file: RAW_FILE
		do
--			l_ecf_file_name := project_ecf_path.entry.out
--			l_ecf_path_in_working_dir := config.working_directory.root_dir.extended (l_ecf_file_name)
--			l_ecf_path_str := project_ecf_path.out
--			l_prj_path_str := project_path.out
--			check l_ecf_path_str.starts_with (l_prj_path_str) end
--			l_location := a_project.project_directory.location
--			l_path := a_working_dir.temp_dir.extended (l_location.entry.out)

			create l_file.make_with_path (ecf_path_in_working_directory)
			Result := l_file.exists
		end

	project_path_in_working_directory: PATH
		do
			Result := config.working_directory.temp_dir
		end

	ecf_path_in_working_directory: PATH
		do
			Result := project_path_in_working_directory.extended_path (project_ecf_path.entry)
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
