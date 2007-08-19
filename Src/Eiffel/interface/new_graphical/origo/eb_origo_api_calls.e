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

	EB_ORIGO_CONSTANTS
		export
			{NONE} all
		end

create
	make

feature -- Initialisation

	make (a_parent_window: EV_WINDOW) is
		do
			parent_window := a_parent_window
		end

feature -- Access

	last_error: STRING
		-- error message of last call (is empty if no error occurred)

feature -- XML RPC calls

	login: STRING is
			-- perform a login and return the session id
		local
			l_process: PROCESS
			l_factory: PROCESS_FACTORY
			command_line: STRING
			session: STRING
			l_error: STRING
		do
			session := ""
			l_error := ""
			command_line := preferences.origo_data.xml_rpc_client_path.out
			command_line.append (" login -uk ")
			command_line.append (preferences.origo_data.user_key)
			command_line.append (" -ak ")
			command_line.append (application_key)
			create l_factory
			l_process := l_factory.process_launcher_with_command_line (command_line, Void)
			l_process.redirect_output_to_agent (agent session.append)
			l_process.redirect_error_to_agent (agent l_error.append)
			l_process.launch

				-- launch process
			if l_process.launched then
				l_process.wait_for_exit

					-- if everything went fine
				if l_error.is_empty then
					Result := session

					-- an error occurred
				else
					l_error.insert_string ("Error during login:%N", 1)
				end
				set_error (l_error)

				-- the process could not be launched
			else
				set_error ("Error during login:%NCommand line tool could not be launched")
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
			l_error: STRING
			username: STRING
		do
			username := ""
			l_error := ""
			command_line := preferences.origo_data.xml_rpc_client_path.out
			command_line.append (" my_name -s ")
			command_line.append (session)
			create l_factory
			l_process := l_factory.process_launcher_with_command_line (command_line, Void)
			l_process.redirect_output_to_agent (agent username.append)
			l_process.redirect_error_to_agent (agent l_error.append)
			l_process.launch

				-- launch process
			if l_process.launched then
				l_process.wait_for_exit

					-- if everything went fine
				if l_error.is_empty then
					Result := username

					-- an error occurred
				else
					l_error.insert_string ("Error during my_username:%N", 1)
				end
				set_error (l_error)

				-- the process could not be launched
			else
				set_error ("Error during my_username:%NCommand line tool could not be launched")
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
					l_error.insert_string ("Error during my_password:%N", 1)
				end
				set_error (l_error)

				-- the process could not be launched
			else
				set_error ("Error during my_password:%NCommand line tool could not be launched")
			end
		end

	project_list_of_user (session: STRING; username: STRING): DS_LINKED_LIST [TUPLE [id: INTEGER; name: STRING; is_owned: BOOLEAN]] is
			-- return project list of `username'
		require
			session_attached: session /= Void and not session.is_empty
			username_attached: username /= Void and not username.is_empty
		local
			l_process: PROCESS
			l_factory: PROCESS_FACTORY
			command_line: STRING
			l_error: STRING
			project_list_string: STRING
			l_lines: LIST [STRING]
			l_line_parts: LIST [STRING]
			l_project: TUPLE [id: INTEGER; name: STRING; is_owned: BOOLEAN]
		do
			project_list_string := ""
			l_error := ""
			command_line := preferences.origo_data.xml_rpc_client_path.out
			command_line.append (" project_list_of_user -s ")
			command_line.append (session)
			command_line.append (" -u ")
			command_line.append (username)
			create l_factory
			l_process := l_factory.process_launcher_with_command_line (command_line, Void)
			l_process.redirect_output_to_agent (agent project_list_string.append)
			l_process.redirect_error_to_agent (agent l_error.append)
			l_process.launch

				-- launch process
			if l_process.launched then
				l_process.wait_for_exit

					-- if everything went fine
				if l_error.is_empty then

						-- parse the result and fill the Result
					project_list_string.prune_all ('%R')
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
								l_project.is_owned := l_line_parts[3].is_equal ("3")
								Result.force_first (l_project)
							end
							l_lines.forth
						end
					end

					-- an error occurred
				else
					l_error.insert_string ("Error during project_list_of_user:%N", 1)
				end
				set_error (l_error)

				-- the process could not be launched
			else
				set_error ("Error during project_list_of_user:%NCommand line tool could not be launched")
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
			l_error: STRING
			username: STRING
		do
			username := ""
			l_error := ""
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
			l_process.redirect_error_to_agent (agent l_error.append)
			l_process.launch

				-- launch process
			if l_process.launched then
				l_process.wait_for_exit

					-- an error occurred
				if not l_error.is_empty then
					l_error.insert_string ("Error during release:%N", 1)
				end
				set_error (l_error)

				-- the process could not be launched
			else
				set_error ("Error during release:%NCommand line tool could not be launched")
			end
		end

	workitem_list (a_session: STRING; a_number: INTEGER; a_unread_only: BOOLEAN): DS_LINKED_LIST [EB_ORIGO_WORKITEM] is
			-- receive workitem list
		require
			session_attached: a_session /= Void and not a_session.is_empty
			a_days_positive: a_number > 0
		local
			l_process: PROCESS
			l_factory: PROCESS_FACTORY
			l_command_line: STRING
			l_error: STRING
			l_workitem_list_string: STRING
			l_workitem: EB_ORIGO_WORKITEM
			l_line: STRING
			l_type: INTEGER
		do
			l_error := ""
			l_workitem_list_string := ""
			l_command_line := preferences.origo_data.xml_rpc_client_path.out
			l_command_line.append (" workitem_list -s ")
			l_command_line.append (a_session)
			l_command_line.append (" -num " + a_number.out)
			if a_unread_only then
				l_command_line.append (" -uro")
			end
			create l_factory
			l_process := l_factory.process_launcher_with_command_line (l_command_line, Void)
			l_process.redirect_output_to_agent (agent l_workitem_list_string.append)
			l_process.redirect_error_to_agent (agent l_error.append)
			l_process.launch

				-- launch process
			if l_process.launched then
				l_process.wait_for_exit

					-- if everything went fine
				if l_error.is_empty then
					from
						create Result.make
						l_workitem_list_string.prune_all ('%R')
					until
						l_workitem_list_string.is_empty
					loop
						l_line := read_line_from_string (l_workitem_list_string)
						l_type := l_line.to_integer

						inspect
							l_type
						when workitem_type_issue then
							l_workitem := read_issue_workitem (l_workitem_list_string, False)
						when workitem_type_release then
							l_workitem := read_release_workitem (l_workitem_list_string, False)
						when workitem_type_commit then
							l_workitem := read_commit_workitem (l_workitem_list_string, False)
						when workitem_type_wiki then
							l_workitem := read_wiki_workitem (l_workitem_list_string, False)
						when workitem_type_blog then
							l_workitem := read_blog_workitem (l_workitem_list_string, False)
						else
							create l_workitem.make
							l_workitem.set_type (l_type)
							fill_general_workitem (l_workitem, l_workitem_list_string)
						end

						Result.force_last (l_workitem)

							-- skip the empty line between workitems
						l_line := read_line_from_string (l_workitem_list_string)
					end

					-- an error occurred
				else
					l_error.insert_string ("Error during workitem_list:%N", 1)
				end
				set_error (l_error)

				-- the process could not be launched
			else
				set_error ("Error during workitem_list:%NCommand line tool could not be launched")
			end
		end

	workitem_details (a_session: STRING; a_workitem_id: INTEGER):EB_ORIGO_WORKITEM is
			-- receive a detailed workitem
		require
			session_attached: a_session /= Void and not a_session.is_empty
			a_workitem_id_positive: a_workitem_id > 0
		local
			l_process: PROCESS
			l_factory: PROCESS_FACTORY
			l_command_line: STRING
			l_error: STRING
			l_workitem_string: STRING
			l_line: STRING
			l_type: INTEGER
		do
			l_error := ""
			l_workitem_string := ""
			l_command_line := preferences.origo_data.xml_rpc_client_path.out
			l_command_line.append (" workitem -s ")
			l_command_line.append (a_session)
			l_command_line.append (" -w " + a_workitem_id.out)
			create l_factory
			l_process := l_factory.process_launcher_with_command_line (l_command_line, Void)
			l_process.redirect_output_to_agent (agent l_workitem_string.append)
			l_process.redirect_error_to_agent (agent l_error.append)
			l_process.launch

				-- launch process
			if l_process.launched then
				l_process.wait_for_exit

					-- if everything went fine
				if l_error.is_empty then
					l_workitem_string.prune_all ('%R')
					l_line := read_line_from_string (l_workitem_string)
					l_type := l_line.to_integer

					inspect
						l_type
					when workitem_type_issue then
						Result := read_issue_workitem (l_workitem_string, True)
					when workitem_type_release then
						Result := read_release_workitem (l_workitem_string, True)
					when workitem_type_commit then
						Result := read_commit_workitem (l_workitem_string, True)
					when workitem_type_wiki then
						Result := read_wiki_workitem (l_workitem_string, True)
					when workitem_type_blog then
						Result := read_blog_workitem (l_workitem_string, True)
					else
						create Result.make
						Result.set_type (l_type)
						fill_general_workitem (Result, l_workitem_string)
					end

					check
						l_workitem_string_is_empty: l_workitem_string.is_empty
					end

					-- an error occurred
				else
					l_error.insert_string ("Error during workitem_details:%N", 1)
				end
				set_error (l_error)
				-- the process could not be launched
			else
				set_error ("Error during workitem_details:%NCommand line tool could not be launched")
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
				end
				set_error (l_error)

				-- the process could not be launched
			else
				set_error ("Error during ftp_upload:%NCommand line tool could not be launched")
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
				end
				set_error (l_error)

				-- the process could not be launched
			else
				set_error ("Error during ftp_file_list:%NCommand line tool could not be launched")
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
				end
				set_error (l_error)

				-- the process could not be launched
			else
				set_error ("Error during ftp_delete:%NCommand line tool could not be launched")
			end
		end



feature {NONE} -- Implementation

	set_error (error: STRING) is
			-- set `last_error'
		do
			error.prune_all ('%R')
			last_error := error.out
		end

feature {NONE} -- Implementation

	read_line_from_string (a_string: STRING): STRING is
			-- removes everything from the start of `a_string' until the first '%N' is encountred and returns it
			-- if there is a '%N' just before the '%N' it will not be part of the returned string
		require
			a_string_not_void: a_string /= Void
		do
			Result := read_head_from_string (a_string, '%N')
		ensure
			set: 		Result /= Void
			was_start: 	(old a_string.out).is_equal (Result + "%N" + a_string)
		end

	read_head_from_string (a_string: STRING; a_seperator: CHARACTER): STRING is
			--  removes everything from the start of `a_string' until the first `a_seperator' is encountred and returns it
		require
			a_string_not_void: a_string /= Void
		local
			l_index: INTEGER
		do
			l_index := a_string.index_of (a_seperator, 1)

				-- if it was the first sign the result is an empty string
			if l_index = 1 then
				Result := ""

				-- if `a_seperator' was not found, remove the whole string		
			elseif l_index = 0 then
				l_index := a_string.count
				Result := a_string.out
			else
				Result := a_string.substring (1, l_index - 1)
			end
			a_string.remove_head (l_index)
		ensure
			set: Result /= Void
			was_start: (old a_string.out).is_equal (Result + a_seperator.out + a_string)
		end

	read_text_block_from_string (a_string: STRING): STRING is
			-- reads a text block which starts with length + ":" and then the text and terminates with a %N
		require
			not_void: a_string /= Void
		local
			l_line: STRING
			l_length: INTEGER
		do
				-- the next part of `a_string' is a text block. because a text block can contain new line signs
				-- the length of the text block is the start of it, terminated by a ':'
			l_line := read_head_from_string (a_string, ':')
			check
				is_integer: l_line.is_integer
				is_not_too_long: l_line.to_integer <= a_string.count
			end
			l_length := l_line.to_integer
			Result := (a_string.substring (1, l_length))
			a_string.remove_head (l_length)

				-- read the new line sign at the end
			l_line := read_line_from_string (a_string)
			check
				l_line_empty: l_line.is_empty
			end

		ensure
			set: Result /= Void
		end

	read_issue_workitem (a_string: STRING; read_details: BOOLEAN): EB_ORIGO_ISSUE_WORKITEM is
			-- read `a_string' and convert the data into an issue workitem
			-- the processed part of `a_string' will be removed from it
		do
			create Result.make
			fill_general_workitem (Result, a_string)

		end

	read_release_workitem (a_string: STRING; read_details: BOOLEAN): EB_ORIGO_RELEASE_WORKITEM is
			-- read `a_string' and convert the data into a release workitem
			-- the processed part of `a_string' will be removed from it
		local
			l_file_count: INTEGER
			i: INTEGER
			l_strings: LIST [STRING]
		do
			create Result.make
			fill_general_workitem (Result, a_string)
			Result.set_name (read_line_from_string (a_string))
			Result.set_version (read_line_from_string (a_string))
			Result.set_description (read_text_block_from_string (a_string))

			if read_details then
				Result.set_detailed (True)
				l_file_count := read_line_from_string (a_string).to_integer
				Result.files.wipe_out

				from
					i := 1
				until
					i > l_file_count
				loop
						-- a file line looks like this: "<file_name>:<platform>"
					l_strings := read_line_from_string (a_string).split (':')
					check
						correct_length: l_strings.count = 2
					end

						-- add the platform if it doesn't exist
					if not Result.files.has (l_strings[2]) then
						Result.files.force (create {DS_LINKED_LIST [STRING]}.make, l_strings[2].out)
					end

					Result.files.item (l_strings[2]).force_last (l_strings[1])

					i := i + 1
				end
			end
		end

	read_commit_workitem (a_string: STRING; read_details: BOOLEAN): EB_ORIGO_COMMIT_WORKITEM is
			-- read `a_string' and convert the data into a commit workitem
			-- the processed part of `a_string' will be removed from it
		local
			l_line: STRING
		do
			create Result.make
			fill_general_workitem (Result, a_string)
			l_line := read_line_from_string (a_string)
			Result.set_revision (l_line.to_integer)
			Result.set_log (read_text_block_from_string (a_string))

			if read_details then
				Result.set_detailed (True)
				Result.set_diff (read_text_block_from_string (a_string))
			end
		end

	read_wiki_workitem (a_string: STRING; read_details: BOOLEAN): EB_ORIGO_WIKI_WORKITEM is
			-- read `a_string' and convert the data into a wiki workitem
			-- the processed part of `a_string' will be removed from it
		do
			create Result.make
			fill_general_workitem (Result, a_string)
			Result.set_title (read_line_from_string (a_string))
			Result.set_url (read_line_from_string (a_string))
			Result.set_diff_url (read_line_from_string (a_string))

			if read_details then
				Result.set_detailed (True)
				Result.set_revision (read_line_from_string (a_string).to_integer)
				Result.set_old_revision (read_line_from_string (a_string).to_integer)
				Result.set_diff (read_text_block_from_string (a_string))
			end
		end

	read_blog_workitem (a_string: STRING; read_details: BOOLEAN): EB_ORIGO_BLOG_WORKITEM is
			-- read `a_string' and convert the data into a blog workitem
			-- the processed part of `a_string' will be removed from it
		do
			create Result.make
			fill_general_workitem (Result, a_string)
			Result.set_title (read_line_from_string (a_string))
			Result.set_url (read_line_from_string (a_string))
			Result.set_diff_url (read_line_from_string (a_string))

			if read_details then
				Result.set_detailed (True)
				Result.set_revision (read_line_from_string (a_string).to_integer)
				Result.set_old_revision (read_line_from_string (a_string).to_integer)
				Result.set_diff (read_text_block_from_string (a_string))
			end
		end

	fill_general_workitem (a_workitem: EB_ORIGO_WORKITEM; a_string: STRING) is
			-- process `a_string' and fill it's data into `a_workitem'
			-- the processed part of `a_string' will be removed from it
		local
			l_line: STRING
			l_date: DATE_TIME
		do
			l_line := read_line_from_string (a_string)
			a_workitem.set_workitem_id (l_line.to_integer)
			l_line := read_line_from_string (a_string)
			create l_date.make (1970, 1, 1, 0, 0, 0)
			l_date.second_add (l_line.to_integer)
			a_workitem.set_creation_time (l_date)
			l_line := read_line_from_string (a_string)
			a_workitem.set_project_id (l_line.to_integer)
			l_line := read_line_from_string (a_string)
			a_workitem.set_project (l_line)
			l_line := read_line_from_string (a_string)
			a_workitem.set_user (l_line)
		end

feature {NONE} -- Implementation

	parent_window: EV_WINDOW
		-- window which causes the calls

	application_key: STRING is "KEYFORTHEEIFFELSTUDIOINTEGRATION"

end
