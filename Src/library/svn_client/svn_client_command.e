note
	description: "Summary description for {SVN_CLIENT_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SVN_CLIENT_COMMAND

feature {NONE} -- Initialization

	make(a_svn_client: SVN_CLIENT)
		require
			a_svn_client_not_void: a_svn_client /= Void
		do
			svn_client := a_svn_client

			create target.make_from_string (".")
			create options.make (1)
		end

feature -- Execute

	execute
		local
			l_args: LINKED_LIST[STRING_8]
		do
				-- Clear last result and internal last result
			set_last_result (Void)
			set_internal_last_result (Void)
			set_last_error (Void)
			set_internal_last_error (Void)
				-- Initialize internal last result
			create internal_last_result.make_empty
			create internal_last_error.make_empty

			create l_args.make
			l_args.extend (command_name)
			l_args.extend (target)
			l_args.append (options_to_args)

			launch_process (l_args)
		end

feature -- Access

	target: STRING_8
		-- Execute command for `target' (folder or file) at given `working_path'

	last_result: detachable STRING_8

	last_error: detachable STRING_8

feature -- Element change

	set_target(a_target: like target)
		require
			valid_target: a_target /= Void and then not a_target.is_empty
		do
			target := a_target
		end

	put_option (a_option_name, a_option_value: STRING_8)
			-- Add or replace the option `a_option_name' with the value `a_option_value'
		require
			valid_option_name: a_option_name /= Void and then not a_option_name.is_empty
			valid_option_value: a_option_value /= Void
		do
			if not options.has (a_option_name) then
				options.put (a_option_value, a_option_name)
			else
				options.replace (a_option_value, a_option_name)
			end
		end

feature -- Observer pattern

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

feature {NONE} -- Command agents

	on_error_handler: PROCEDURE[ANY, TUPLE[STRING_8]]
		-- Agent to call when an error has occurred

	on_data_received_handler: PROCEDURE[ANY, TUPLE[STRING_8]]
		-- Agent to call when partial data is received

	on_did_finish_handler: PROCEDURE[ANY, TUPLE[]]
		-- Agent to call when the command has been executed

	command_error(a_command_error: STRING_8)
		do
			-- Parse error
			internal_last_error.append (a_command_error)
			if attached on_error_handler as error_handler then
				error_handler.call ([a_command_error])
			end
		end

	command_data_received(a_data_received: STRING_8)
		do
			-- For debugging purposes
			print (a_data_received)

			internal_last_result.append (a_data_received)

			-- Call handler
			if attached on_data_received_handler as data_received_handler then
				data_received_handler.call ([a_data_received])
			end
		end

	command_did_finish
		do
			set_last_result (internal_last_result)
			set_internal_last_result (Void)

			set_last_error (internal_last_error)
			set_internal_last_error (Void)

			if process.exit_code = 0 then
					-- Command successfully executed
				if attached on_did_finish_handler as did_finish_handler then
					did_finish_handler.call([])
				end
			else
				if attached on_error_handler as error_handler then
					error_handler.call ([last_error])
				end
			end
		end

feature {NONE} -- Result and error handling

	set_last_result (a_result: detachable like last_result)
		do
			last_result := a_result
		end

	set_internal_last_result (a_result: detachable like internal_last_result)
		do
			internal_last_result := a_result
		end

	internal_last_result: detachable STRING_8

	set_last_error (a_error: detachable like last_error)
		do
			last_error := a_error
		end

	set_internal_last_error (a_error: detachable like internal_last_error)
		do
			internal_last_error := a_error
		end

	internal_last_error: detachable STRING_8

feature {NONE} -- Result parsing

	parse_result (a_svn_parser: SVN_PARSER)
		require
			svn_parser_not_void: a_svn_parser /= Void
		deferred
		end

feature {NONE} -- Implementation

	command_name: STRING_8
			-- Name of the command (used for the execution)
		deferred
		end

	launch_process (a_args: LINKED_LIST[STRING_8])
			-- Execute `cd working_path; svn command_name a_args target'
		require
			a_args_not_void: a_args /= Void
		do
			process := svn_client.pf.process_launcher (svn_client.svn_executable, a_args, svn_client.working_path)

			process.redirect_error_to_agent (agent command_error)
			process.redirect_output_to_agent (agent command_data_received)
			process.set_on_exit_handler (agent command_did_finish)

			process.launch
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

	svn_client: SVN_CLIENT

	process: PROCESS
		-- The process that executes the svn command

	options: HASH_TABLE[STRING_8, STRING_8]
		-- Optional arguments used when executing `Current'

invariant
	command_name_set: command_name /= Void and then not command_name.is_empty
	svn_client_set: svn_client /= Void

end
