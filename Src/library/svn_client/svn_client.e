note
	description: "[
			Object that allows to execute Subversion commands.
			
			--- Command execution ---
			The available Subversion commands are listed in the "SVN Client commands" feature clause
			For each command three procedures can be registered to receive
				1. partial data output by calling set_on_data_received (this procedure takes a STRING_8 as an argument)
				2. a notification when the command terminates, by calling set_on_command_terminated
					(also takes a STRING_8 as an argument)
				3. a notification when an error occurred and the command did not terminate successfully, by calling
					set_on_command_error
			`working_path' is the path of a directory where the commands are invoked and each command has one target path
			(by default ".", i.e. the current folder) and possibly one source path.
			Executing a command is equivalent, in a command line interface, to performing the tasks:
				$ cd working_path
				$ svn command [source] target
			
			--- Parsing ---
			By default the object uses a SVN_TEXT_PARSER to parse a command's output and error. After a command's completion,
			the output produced is available as plaintext in the command's `last_result' and `last_error' queries.
			The result may also be available in a different form, depending on whether the parser transforms the plaintext
			into another format.
				]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_CLIENT

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		local
--			l_exec_env: EXECUTION_ENVIRONMENT
			l_parser: SVN_TEXT_PARSER
		do
			create working_path.make_from_string (".")
			create pf
				-- TODO: get the svn path using the environment variable
--			create l_exec_env
--			svn_executable := l_exec_env.get ("PATH")
			create l_parser
			set_parser (l_parser)
			if {PLATFORM}.is_windows then
				svn_executable := "svn"
			else
				svn_executable := "/usr/bin/svn"
			end
			initialize_commands
		end

feature -- Element change

	set_working_path (a_working_path: detachable like working_path)
		do
			working_path := a_working_path
		end

	set_parser (a_svn_parser: like parser)
		require
			parser_not_void: a_svn_parser /= Void
		do
			parser := a_svn_parser
		end

feature -- Access

	working_path: STRING_32
		-- Path of the directory where all commands are invoked

feature -- SVN Client commands

	add: SVN_CLIENT_ADD_COMMAND
		-- Command to put files and folders under version control.

	checkout: SVN_CLIENT_CHECKOUT_COMMAND
		-- Command to check out a working copy from a repository.

	commit: SVN_CLIENT_COMMIT_COMMAND
		-- Command to send changes from the working copy to the repository.

	cp: SVN_CLIENT_COPY_COMMAND
		-- Command to duplicate files or folders in working copy or repository, remembering history.

	delete: SVN_CLIENT_DELETE_COMMAND
		-- Command to remove files and directories from version control.

	list: SVN_CLIENT_LIST_COMMAND
		-- Command to list directory entries in the repository.

	log: SVN_CLIENT_LOG_COMMAND
		-- Command to show the log messages for a set of revision(s) and/or file(s).

	merge: SVN_CLIENT_MERGE_COMMAND
		-- Command to apply the differences between two sources to a working copy path.

	status: SVN_CLIENT_STATUS_COMMAND
		-- Command to show the status of working copy files and directories.

	update: SVN_CLIENT_UPDATE_COMMAND
		-- Command to bring changes from the repository into the working copy.

--	branch: SVN_CLIENT_BRANCH_COMMAND

--	diff: SVN_CLIENT_DIFF_COMMAND

--	resolve: SVN_CLIENT_RESOLVE_COMMAND

--	revert: SVN_CLIENT_REVERT_COMMAND

feature {SVN_CLIENT_COMMAND} -- Implementation

	svn_executable: STRING

	pf: PROCESS_FACTORY

	parser: SVN_PARSER

	initialize_commands
		do
			create add.make (Current)
			create checkout.make (Current)
			create commit.make (Current)
			create cp.make (Current)
			create delete.make (Current)
			create list.make (Current)
			create log.make (Current)
			create merge.make (Current)
			create status.make (Current)
			create update.make (Current)
		end

invariant
	invariant_clause: True -- Your invariant here

end
