note
	description: "Summary description for {SVN_CLIENT_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SVN_CLIENT_COMMAND

feature {NONE} -- Initialization

	make(a_process_factory: PROCESS_FACTORY; a_svn_executable_path: STRING_8; a_working_path: detachable STRING_8)
		require
			process_factory_not_void: a_process_factory /= Void
			a_svn_executable_path_not_void: a_svn_executable_path /= Void
		do
			pf := a_process_factory
			svn_executable_path := a_svn_executable_path

			if attached a_working_path as a_wp then
				working_path := a_working_path.twin
			else
				create working_path.make_from_string ("./")
			end

			create options.make (1)
		end

feature -- Execute

	execute
		local
			l_args: LINKED_LIST[STRING_8]
		do
			create l_args.make
			l_args.extend (command_name)
			l_args.append (options_to_args)

			launch_process (l_args)
		end

feature -- Element change

	set_working_path(a_working_path: detachable like working_path)
		do
			working_path := a_working_path
		end

	set_data_received_handler(a_data_received_handler: detachable like on_data_received_handler)
		do
			on_data_received_handler := a_data_received_handler
		end

	set_error_handler(a_error_handler: detachable like on_error_handler)
		do
			on_error_handler := a_error_handler
		end

	set_did_finish_handler(a_did_finish_handler: detachable like on_did_finish_handler)
		do
			on_did_finish_handler := a_did_finish_handler
		end

	put_option (a_option_name, a_option_value: STRING_8)
			-- Add or replace the option `a_option_name' with the value `a_option_value'
		require
			valid_option_name: a_option_name /= Void and then not a_option_name.is_empty
			valid_option_value: a_option_value /= Void and then not a_option_value.is_empty
		do
			if not options.has (a_option_name) then
				options.put (a_option_value, a_option_name)
			else
				options.replace (a_option_value, a_option_name)
			end
		end

feature {NONE} -- Implementation

	command_name: STRING_8
			-- Name of the command (used for the execution)
		deferred
		end

	pf: PROCESS_FACTORY

	launch_process (a_args: LINKED_LIST[STRING_8])
			-- Execute `svn command_name a_args working_path'
		require
			a_args_not_void: a_args /= Void
		local
			l_process: PROCESS
		do
			l_process := pf.process_launcher (svn_executable_path, a_args, working_path)

			l_process.redirect_error_to_agent (agent command_error)
			l_process.redirect_output_to_agent (agent command_data_received)
			l_process.set_on_exit_handler (agent command_did_finish)

			l_process.launch
		end

	options_to_args: LINKED_LIST[STRING_8]
		do
			create Result.make
			from options.start
			until options.after
			loop
				Result.extend(options.key_for_iteration)
				Result.extend(options.item_for_iteration)
				options.forth
			end
		ensure
			all_options_included: options.count * 2 = Result.count
		end

	svn_executable_path: STRING_8

	working_path: STRING_8
		-- Execute command at given `working_path' (folder or file)

	options: HASH_TABLE[STRING_8, STRING_8]
		-- Optional arguments used when executing `Current'

	on_error_handler: PROCEDURE[ANY, TUPLE[STRING_8]]
		-- Agent to call when an error has occurred

	on_data_received_handler: PROCEDURE[ANY, TUPLE[STRING_8]]
		-- Agent to call when partial data is received

	on_did_finish_handler: PROCEDURE[ANY, TUPLE[]]
		-- Agent to call when the command has been executed

	command_error(a_command_error: STRING_8)
		do
			-- Parse error
			if attached on_error_handler as error_handler then
				error_handler.call ([a_command_error])
			end
		end

	command_data_received(a_data_received: STRING_8)
		do
			print (a_data_received)
			-- Parse data...
			-- Call handler
			if attached on_data_received_handler as data_received_handler then
				data_received_handler.call ([a_data_received])
			end
		end

	command_did_finish
		do
			if attached on_did_finish_handler as did_finish_handler then
				did_finish_handler.call([])
			end
		end

	parse_string_to_list(a_data: STRING_8): LIST[STRING_8]
			-- Split `a_data' using the newline separator into a list of strings
		require
			data_not_void: a_data /= Void
		do
			create {ARRAYED_LIST[STRING_8]}Result.make (1)
			Result := a_data.split ('%N')
				-- Remove last line, because it is always empty
			Result.finish
			Result.remove
		end

invariant
	command_name_set: command_name /= Void and then not command_name.is_empty
	process_factory_set: pf /= Void

end
