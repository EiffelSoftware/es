indexing
	description: "Objects that perform XML RPC calls to Origo through the XML RPC client"
	author: "Rafael Bischof <rafael@xanis.ch>"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_ORIGO_API_CALLS

inherit
	EB_SHARED_PREFERENCES
		export
			{NONE} all
		end

create
	make

feature -- Initialisation

	make (a_parent_window: EV_WINDOW) is
		require
			a_parent_window_not_void: a_parent_window /= Void
		do
			parent_window := a_parent_window
		end

feature -- XML RPC calls

	login: STRING is
			-- perform a login and return the session id
		local
			l_process: PROCESS
			l_factory: PROCESS_FACTORY
			command_line: STRING
			session: STRING
			error: STRING
		do
			session := ""
			error := ""
			command_line := preferences.origo_data.xml_rpc_client_path.out
			command_line.append (" login -uk ")
			command_line.append (preferences.origo_data.user_key)
			command_line.append (" -ak ")
			command_line.append (application_key)
			create l_factory
			l_process := l_factory.process_launcher_with_command_line (command_line, Void)
			l_process.redirect_output_to_agent (agent session.append)
			l_process.redirect_error_to_agent (agent error.append)
			l_process.launch

				-- launch process
			if l_process.launched then
				l_process.wait_for_exit

					-- if everything went fine
				if error.is_empty then
					Result := session

					-- an error occurred
				else
					error.insert_string ("Error during login:%N", 1)
					show_warning (error)
				end

				-- the process could not be launched
			else
				show_warning ("Error during login:%NCommand line tool could not be launched")
			end
		end

	my_username (session: STRING): STRING is
			-- receive your own username
		require
			session_attached: session /= Void and not session.is_empty
		local
			l_process: PROCESS
			l_factory: PROCESS_FACTORY
			command_line: STRING
			error: STRING
			username: STRING
		do
			username := ""
			error := ""
			command_line := preferences.origo_data.xml_rpc_client_path.out
			command_line.append (" my_name -s ")
			command_line.append (session)
			create l_factory
			l_process := l_factory.process_launcher_with_command_line (command_line, Void)
			l_process.redirect_output_to_agent (agent username.append)
			l_process.redirect_error_to_agent (agent error.append)
			l_process.launch

				-- launch process
			if l_process.launched then
				l_process.wait_for_exit

					-- if everything went fine
				if error.is_empty then
					Result := username

					-- an error occurred
				else
					error.insert_string ("Error during my_username:%N", 1)
					show_warning (error)
				end

				-- the process could not be launched
			else
				show_warning ("Error during my_username:%NCommand line tool could not be launched")
			end
		end

	my_password (a_session: STRING): STRING is
			-- receive your own password
		require
			session_attached: a_session /= Void and not a_session.is_empty
		local
			l_process: PROCESS
			l_factory: PROCESS_FACTORY
			l_command_line: STRING
			l_error: STRING
			l_password: STRING
		do
			l_password := ""
			l_error := ""
			l_command_line := preferences.origo_data.xml_rpc_client_path.out
			l_command_line.append (" my_password -s ")
			l_command_line.append (a_session)
			create l_factory
			l_process := l_factory.process_launcher_with_command_line (l_command_line, Void)
			l_process.redirect_output_to_agent (agent l_password.append)
			l_process.redirect_error_to_agent (agent l_error.append)
			l_process.launch

				-- launch process
			if l_process.launched then
				l_process.wait_for_exit

					-- if everything went fine
				if l_error.is_empty then
					Result := l_password

					-- an error occurred
				else
					l_error.insert_string ("Error during my_username:%N", 1)
					show_warning (l_error)
				end

				-- the process could not be launched
			else
				show_warning ("Error during my_username:%NCommand line tool could not be launched")
			end
		end

	project_list_of_user (session: STRING; username: STRING): DS_LINKED_LIST [TUPLE [id: INTEGER; name: STRING]] is
			-- return project list of `username'
		require
			session_attached: session /= Void and not session.is_empty
			username_attached: username /= Void and not username.is_empty
		local
			l_process: PROCESS
			l_factory: PROCESS_FACTORY
			command_line: STRING
			error: STRING
			project_list_string: STRING
			l_lines: LIST [STRING]
			l_line_parts: LIST [STRING]
			l_project: TUPLE [id: INTEGER; name: STRING]
		do
			project_list_string := ""
			error := ""
			command_line := preferences.origo_data.xml_rpc_client_path.out
			command_line.append (" project_list_of_user -s ")
			command_line.append (session)
			command_line.append (" -u ")
			command_line.append (username)
			create l_factory
			l_process := l_factory.process_launcher_with_command_line (command_line, Void)
			l_process.redirect_output_to_agent (agent project_list_string.append)
			l_process.redirect_error_to_agent (agent error.append)
			l_process.launch

				-- launch process
			if l_process.launched then
				l_process.wait_for_exit

					-- if everything went fine
				if error.is_empty then

						-- parse the result and fill the Result
					l_lines := project_list_string.split ('%N')
					create Result.make
					if l_lines.count > 0 then
						from
							l_lines.start
						until
							l_lines.after
						loop
							if not l_lines.item.is_equal ("") then
								l_line_parts := l_lines.item.split ('%T')
								check
									correct_line_format: l_line_parts.count = 3
								end
								create l_project
								l_project.name := l_line_parts[2]
								l_project.id := l_line_parts[1].to_integer
								Result.force_first (l_project)
							end
							l_lines.forth
						end
					end

					-- an error occurred
				else
					error.insert_string ("Error during project_list_of_user:%N", 1)
					show_warning (error)
				end

				-- the process could not be launched
			else
				show_warning ("Error during project_list_of_user:%NCommand line tool could not be launched")
			end
		end

	release (session: STRING; a_project_id: INTEGER; a_release_dialog: EB_ORIGO_RELEASE_DIALOG; a_file_list: DS_LINKED_LIST [TUPLE[filename: STRING; platform: STRING]]) is
			-- build a release
		require
			session_attached: session /= Void and not session.is_empty
			a_project_id_positive: a_project_id > 0
			a_release_dialog_not_void: a_release_dialog /= Void
			a_release_dialog_closed_with_ok: a_release_dialog.closed_with_ok
			a_file_list_attached: a_file_list /= Void and not a_file_list.is_empty
		local
			l_process: PROCESS
			l_factory: PROCESS_FACTORY
			command_line: STRING
			error: STRING
			username: STRING
		do
			username := ""
			error := ""
			command_line := preferences.origo_data.xml_rpc_client_path.out
			command_line.append (" release -s " + session)
			command_line.append (" -pid " + a_project_id.out)
			command_line.append (" -n %"" + a_release_dialog.name + "%"")
			command_line.append (" -ver %"" + a_release_dialog.version + "%"")
			if not a_release_dialog.description.is_empty then
				command_line.append (" -d %"" + a_release_dialog.description + "%"")
			end

			command_line.append (" -fl %"")

			from
				a_file_list.start
			until
				a_file_list.after
			loop
				command_line.append (a_file_list.item_for_iteration.filename + ":" + a_file_list.item_for_iteration.platform + ";")
				a_file_list.forth
			end

			command_line.prune_all_trailing (';')
			command_line.append ("%"")

			create l_factory
			l_process := l_factory.process_launcher_with_command_line (command_line, Void)
			l_process.redirect_output_to_agent (agent username.append)
			l_process.redirect_error_to_agent (agent error.append)
			l_process.launch

				-- launch process
			if l_process.launched then
				l_process.wait_for_exit

					-- an error occurred
				if not error.is_empty then
					error.insert_string ("Error during release:%N", 1)
					show_warning (error)
				end

				-- the process could not be launched
			else
				show_warning ("Error during release:%NCommand line tool could not be launched")
			end
		end


feature -- FTP functions

	ftp_upload (a_username: STRING; a_password: STRING; a_filename: STRING) is
			-- upload `filename' to the origo ftp server
		require
			username_attacked: a_username /= Void and not a_username.is_empty
			password_attached: a_password /= Void and not a_password.is_empty
			filename_attached: a_filename /= Void and not a_filename.is_empty
		local
			l_process: PROCESS
			l_factory: PROCESS_FACTORY
			l_command_line: STRING
			l_error: STRING
		do
			l_error := ""
			l_command_line := preferences.origo_data.xml_rpc_client_path.out
			l_command_line.append (" ftp_upload -u ")
			l_command_line.append (a_username)
			l_command_line.append (" -p ")
			l_command_line.append (a_password)
			l_command_line.append (" -f %"")
			l_command_line.append (a_filename)
			l_command_line.append ("%"")
			create l_factory
			l_process := l_factory.process_launcher_with_command_line (l_command_line, Void)
			l_process.redirect_error_to_agent (agent l_error.append)
			l_process.launch

				-- launch process
			if l_process.launched then
				l_process.wait_for_exit

					-- an error occurred
				if not l_error.is_empty then
					l_error.insert_string ("Error during ftp_upload:%N", 1)
					show_warning (l_error)
				end

				-- the process could not be launched
			else
				show_warning ("Error during ftp_upload:%NCommand line tool could not be launched")
			end
		end

	ftp_file_list (a_username: STRING; a_password: STRING): DS_LINKED_LIST [STRING] is
			-- return project list of `username'
		require
			password_attached: a_password /= Void and not a_password.is_empty
			username_attached: a_username /= Void and not a_username.is_empty
		local
			l_process: PROCESS
			l_factory: PROCESS_FACTORY
			l_command_line: STRING
			l_error: STRING
			l_file_list_string: STRING
			l_lines: LIST [STRING]
		do
			l_file_list_string := ""
			l_error := ""
			l_command_line := preferences.origo_data.xml_rpc_client_path.out
			l_command_line.append (" ftp_file_list -p ")
			l_command_line.append (a_password)
			l_command_line.append (" -u ")
			l_command_line.append (a_username)
			create l_factory
			l_process := l_factory.process_launcher_with_command_line (l_command_line, Void)
			l_process.redirect_output_to_agent (agent l_file_list_string.append)
			l_process.redirect_error_to_agent (agent l_error.append)
			l_process.launch

				-- launch process
			if l_process.launched then
				l_process.wait_for_exit

					-- if everything went fine
				if l_error.is_empty then

						-- parse the result and fill the Result
					l_lines := l_file_list_string.split ('%N')
					create Result.make
					if l_lines.count > 0 then
						from
							l_lines.start
						until
							l_lines.after
						loop
							l_lines.item.prune_all ('%R') -- necessary because the process library seems to add them in windows
							if not l_lines.item.is_equal ("") then
								Result.force_first (l_lines.item)
							end
							l_lines.forth
						end
					end

					-- an error occurred
				else
					l_error.insert_string ("Error during ftp_file_list:%N", 1)
					show_warning (l_error)
				end

				-- the process could not be launched
			else
				show_warning ("Error during ftp_file_list:%NCommand line tool could not be launched")
			end
		end

	ftp_delete (a_username: STRING; a_password: STRING; a_filename: STRING) is
			-- delete `filename' to the origo ftp server
		require
			username_attacked: a_username /= Void and not a_username.is_empty
			password_attached: a_password /= Void and not a_password.is_empty
			filename_attached: a_filename /= Void and not a_filename.is_empty
		local
			l_process: PROCESS
			l_factory: PROCESS_FACTORY
			l_command_line: STRING
			l_error: STRING
		do
			l_error := ""
			l_command_line := preferences.origo_data.xml_rpc_client_path.out
			l_command_line.append (" ftp_delete -u ")
			l_command_line.append (a_username)
			l_command_line.append (" -p ")
			l_command_line.append (a_password)
			l_command_line.append (" -f %"")
			l_command_line.append (a_filename)
			l_command_line.append ("%"")
			create l_factory
			l_process := l_factory.process_launcher_with_command_line (l_command_line, Void)
			l_process.redirect_error_to_agent (agent l_error.append)
			l_process.launch

				-- launch process
			if l_process.launched then
				l_process.wait_for_exit

					-- an error occurred
				if not l_error.is_empty then
					l_error.insert_string ("Error during ftp_delete:%N", 1)
					show_warning (l_error)
				end

				-- the process could not be launched
			else
				show_warning ("Error during ftp_delete:%NCommand line tool could not be launched")
			end
		end



feature {NONE} -- Implementation

	show_warning (warning: STRING) is
			-- show a warning dialog
		local
			warning_dialog: EV_WARNING_DIALOG
		do
			create warning_dialog.make_with_text (warning)
			if parent_window = Void then
				warning_dialog.show
			else
				warning_dialog.show_modal_to_window (parent_window)
			end
		end


feature {NONE} -- Implementation

--	session: STRING
--		-- session string

	parent_window: EV_WINDOW
		-- window which causes the calls

	application_key: STRING is "KEYFORTHEEIFFELSTUDIOINTEGRATION"


end
