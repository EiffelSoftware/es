indexing
	description: "Summary description for {ES_PROOF_ASSISTANT_TOOL_PANEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_PROOF_ASSISTANT_TOOL_PANEL

inherit

	ES_DOCKABLE_STONABLE_TOOL_PANEL [EV_TEXT]

	EXCEPTIONS
	export {NONE} all end

	KL_SHARED_FILE_SYSTEM
	export {NONE} all end

create
	make

feature

	create_widget: EV_TEXT
		do
			create Result
		end

	build_tool_interface (root_widget: EV_TEXT)
		do
			create jstar_proofs.make
			propagate_drop_actions (Void)
		end

	create_tool_bar_items: ?DS_ARRAYED_LIST [SD_TOOL_BAR_ITEM]
		local
			texts: ARRAY [STRING]
			actions: ARRAY [PROCEDURE [ANY, TUPLE]]
			button: SD_TOOL_BAR_BUTTON
			i: INTEGER
		do
			texts := <<"Code", "Specs", "Logic", "Abs", "CFG", "Execution", "Output">>
			actions := <<agent show_external_editor ("Code", agent {JSTAR_PROOFS}.jimple_code_file_name),
						 agent show_external_editor ("Specs", agent {JSTAR_PROOFS}.specs_file_name),
						 agent show_external_editor ("Logic", agent {JSTAR_PROOFS}.logic_file_name),
						 agent show_external_editor ("Abstraction Rules", agent {JSTAR_PROOFS}.abs_file_name),
						 agent show_dot_file ("Control-flow graph", agent {JSTAR_PROOFS}.cfg_file_name),
						 agent show_dot_file ("Execution graph", agent {JSTAR_PROOFS}.execution_file_name),
						 agent show_external_editor ("JStar output", agent {JSTAR_PROOFS}.jstar_output_file_name)>>

			from
				create Result.make (texts.count)
				create window_references.make
				i := 1
			until
				i > texts.count
			loop
				create button.make
				button.set_text (texts [i])
				button.select_actions.extend (actions [i])
				Result.put (button, i)
				i := i + 1
			end
		end

feature {NONE}

	on_stone_changed (a_old_stone: ?like stone)
		local
			l_retry: BOOLEAN
			l_error_prompt: ES_ERROR_PROMPT
		do
			if not l_retry then
				user_widget.set_text ("")
				ev_application.process_events
				if {st: !CLASSC_STONE} stone and then {c: !CLASS_C} st.e_class then
					jstar_proofs.prove (c)
					if jstar_proofs.timed_out then
						user_widget.set_text ("Timed out! Your logic and abstraction rules possibly cause looping.")
					else
						user_widget.set_text ("Done!")
					end
				end
			end
				-- The following line forces postcondition satisfaction.
				-- Violations happen once in a blue moon, and are possibly related to compilation.
			has_performed_stone_change_notification := False
		rescue
			create l_error_prompt.make_standard (tag_name)
			l_error_prompt.set_title ("Separation logic proof tool error")
			l_error_prompt.show_on_active_window
			l_retry := True
			retry
		end

	jstar_proofs: JSTAR_PROOFS

	show_external_editor (unavailable_title: STRING; source: FUNCTION [ANY, TUPLE, STRING])
		local
			filename: STRING
		do
			filename := source.item ([jstar_proofs])
			if filename /= Void then
				open_external_editor_for_file (filename)
			else
				create_text_window (unavailable_title, "Unavailable")
			end
		end

	open_external_editor_for_file (a_file_name: STRING)
		local
			req: COMMAND_EXECUTOR
		do
			create req
				-- Here, the 1 is the line number.
			req.execute (preferences.misc_data.external_editor_cli (a_file_name, 1))
		end

	open_web_browser_for_file (a_file_name: STRING)
		local
			req: COMMAND_EXECUTOR
		do
			create req
			req.execute (preferences.misc_data.web_browser_command.twin + " " + a_file_name)
		end

	show_dot_file (window_title: STRING; filename_agent: FUNCTION [ANY, TUPLE, STRING])
		local
			l_filename: STRING
			l_process_factory: PROCESS_FACTORY
			l_arguments: ARRAYED_LIST [STRING]
			l_process: PROCESS
			l_executable_name: STRING
			l_map_name: STRING
			l_image_name: STRING
			l_html_name: STRING
			l_absolute_html_file_name: STRING
			l_absolute_map_file_name: STRING
			l_html_file: KL_TEXT_OUTPUT_FILE
		do
			l_filename := filename_agent.item ([jstar_proofs])

			if l_filename = Void then
				create_text_window (window_title, "Unavailable")
			else
				l_map_name := "execution.map"
				l_image_name := "execution.gif"
				l_html_name := "execution.html"

				-- Invoke dot
				create l_process_factory
				create l_arguments.make_from_array (<<"-Tcmapx", "-o" + l_map_name, "-Tgif", "-o" + l_image_name, l_filename>>)
				l_executable_name := solved_path ("dot")
				l_process := l_process_factory.process_launcher (l_executable_name, l_arguments, jstar_proofs.dot_file_directory)
				l_process.redirect_output_to_agent (agent (o: STRING) do end)
				l_process.redirect_error_to_same_as_output
				l_process.set_on_fail_launch_handler (agent cannot_start_dot)
				l_process.launch
				if l_process.launched then
					l_process.wait_for_exit
				end

				-- Set up the html file
				l_absolute_html_file_name := file_system.pathname (jstar_proofs.dot_file_directory, l_html_name)
				l_absolute_map_file_name := file_system.pathname (jstar_proofs.dot_file_directory, l_map_name)
				create l_html_file.make (l_absolute_html_file_name)
				l_html_file.open_write
				l_html_file.put_string ("<html><img src=%"" + l_image_name + "%" usemap=%"#main%"/>")
				l_html_file.close
				file_system.concat_files (l_absolute_html_file_name, l_absolute_map_file_name)
				l_html_file.open_append
				l_html_file.put_string ("</html>")
				l_html_file.close

				-- Invoke the browser
				open_web_browser_for_file (l_absolute_html_file_name)
			end
		end

	cannot_start_dot
		local
			l_error_prompt: ES_ERROR_PROMPT
		do
			create l_error_prompt.make_standard ("")
			l_error_prompt.set_title ("Could not execute dot - make sure it's installed and in your PATH")
			l_error_prompt.show_on_active_window
		end

	create_text_window (window_title: STRING; text_content: STRING)
		local
			l_text_widget: EV_TEXT
			l_window: EV_TITLED_WINDOW
		do
			create l_window.make_with_title (window_title)
			create l_text_widget.make_with_text (text_content)
			l_window.put (l_text_widget)
			l_window.set_size (500, 300)
			l_window.close_request_actions.put_front (agent close_window (l_window))
			window_references.put_front (l_window)
			l_window.show
		end

	close_window (a_window: EV_TITLED_WINDOW)
		do
			window_references.prune_all (a_window)
			a_window.destroy
		end

	window_references: LINKED_LIST [EV_TITLED_WINDOW]
		-- References to the displayed windows, so that they don't get garbage collected.

feature {NONE} -- Unused, but possibly handy

	show_window_for_file (window_title: STRING; filename_agent: FUNCTION [ANY, TUPLE, STRING])
		local
			l_filename: STRING
			l_text_file: PLAIN_TEXT_FILE
			l_text: STRING
			l_retried: BOOLEAN
		do
			if not l_retried then
				l_filename := filename_agent.item ([jstar_proofs])
				if l_filename = Void then
					create_text_window (window_title, "Unavailable")
				else
					from
						create l_text_file.make_open_read (l_filename)
						l_text_file.start
						l_text := ""
					until
						l_text_file.off
					loop
						l_text_file.read_line
						if l_text.count > 0 then
							l_text.append ("%N")
						end
						l_text.append (l_text_file.last_string)
					end
					create_text_window (window_title, l_text)
				end
			else
				create_text_window (window_title, "Unavailable")
			end
		rescue
			l_retried := True
			retry
		end

	show_text_window (window_title: STRING; source: FUNCTION [ANY, TUPLE, STRING])
		do
			create_text_window (window_title, source.item ([jstar_proofs]))
		end


	solved_path (a_executable_name: STRING): STRING
           -- Solved path of `a_executable_name'.
           -- If in Windows, Result will be equal to `a_executable_name'.
       local
           l_prc_factory: PROCESS_FACTORY
           l_prc: PROCESS
       do
           if {PLATFORM}.is_windows then
               Result := a_executable_name.twin
           else
               Result := output_from_program ("/bin/sh -c %"which " + a_executable_name + "%"", Void)
               Result.replace_substring_all ("%N", "")
           end
       end


   output_from_program (a_command: STRING; a_working_directory: STRING): STRING
           -- Output from the execution of `a_command' in (possibly) `a_working_directory'.
           -- Note: You may need to prune the final new line character.
       local
           l_prc_factory: PROCESS_FACTORY
           l_prc: PROCESS
           l_buffer: STRING
       do
           create l_prc_factory
           l_prc := l_prc_factory.process_launcher_with_command_line (a_command, a_working_directory)
           create Result.make (1024)
           l_prc.redirect_output_to_agent (agent Result.append ({STRING}?))
           l_prc.launch
           if l_prc.launched then
               l_prc.wait_for_exit
           end
       end

;indexing
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
