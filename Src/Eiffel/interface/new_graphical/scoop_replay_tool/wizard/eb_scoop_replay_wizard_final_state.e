note
	description: "State for launching replay with selected logical schedule (.sls file)."
	author: "Rusakov Andrey"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_SCOOP_REPLAY_WIZARD_FINAL_STATE

inherit
	EB_WIZARD_FINAL_STATE_WINDOW
	redefine
			proceed_with_current_info
	end

	EB_SCOOP_REPLAY_WIZARD_SHARED_INFORMATION
	export
		{NONE} all
	end

	PROJECT_CONTEXT
	export
		{NONE} all
	end

	EB_SHARED_DEBUGGER_MANAGER

create
	make

feature -- Access

	display_state_text
		do
			title.set_text ("Completing the SCOOP Execution Replay Wizard")
			message.set_text ("Following file contains logical schedule for SCOOP application:%N%N" +
								information.file_name +
								"%N%NPlease, ensure that application is not executing at the moment.%N" +
								"%NTo launch replay please click 'Finish'.")
		end

	proceed_with_current_info
			-- destroy the window.
		local
			params : DEBUGGER_EXECUTION_RESOLVED_PROFILE
				-- Modified execution parameters
			args : STRING
				-- Command-line arguments for launching application
			date_time : DATE_TIME
				-- Timestamp for building filename
			l_directory : DIRECTORY
			l_date_filename : STRING
				-- Generated filename
			l_rec_rep_path : STRING
				-- Path for storing .sls files
		do
			first_window.destroy
			if	Eiffel_project.initialized and then not Eiffel_project.Workbench.is_compiling then
				if not debugger_manager.application_is_executing then
					params := debugger_manager.current_execution_parameters
					args := " " + {SCOOP_LIBRARY_CONSTANTS}.REPLAY_command_line_argument_beginning + " "
					if information.is_record_mode or debugger_manager.scoop_execution_diagram_enabled then
						create date_time.make_now
						l_rec_rep_path := project_location.target_path + operating_environment.directory_separator.out +
												{SCOOP_LIBRARY_CONSTANTS}.REPLAY_directory_name
						create l_directory.make (l_rec_rep_path)
						if not l_directory.exists then
							l_directory.create_dir
						end
						l_date_filename := date_time.formatted_out ("[0]dd-[0]mm-yyyy") + "_" + date_time.formatted_out ("hh-[0]mi-[0]ss-ff3")
						if information.is_record_mode then
							args := args + {SCOOP_LIBRARY_CONSTANTS}.REPLAY_command_line_argument_record + " " + l_rec_rep_path +
									operating_environment.directory_separator.out + "replay_" + l_date_filename + "." +
									{SCOOP_LIBRARY_CONSTANTS}.REPLAY_file_extension + " "
						end
						if debugger_manager.scoop_execution_diagram_enabled then
							args := args + {SCOOP_LIBRARY_CONSTANTS}.REPLAY_command_line_argument_diagram + " " + l_rec_rep_path +
									operating_environment.directory_separator.out + "diagram_" + l_date_filename + "." +
									{SCOOP_LIBRARY_CONSTANTS}.REPLAY_diagram_file_extension + " "
						end
					end

					args := args + {SCOOP_LIBRARY_CONSTANTS}.REPLAY_command_line_argument_replay + " " +
							information.directory_name + operating_environment.directory_separator.out +
							information.file_name + " " + {SCOOP_LIBRARY_CONSTANTS}.REPLAY_command_line_argument_end + " "

					params.set_arguments (params.arguments + args)
					debugger_manager.controller.debug_application ( params, {EXEC_MODES}.run)
				end
			end

		ensure then
			application_dead: first_window.is_destroyed
		end

note
	copyright:	"Copyright (c) 1984-2010, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
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
