note
	description: "Summary description for {SVN_CLIENT}."
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
			create pf
				-- TODO: get the svn path using the shared environment
--			create l_exec_env
--			svn_executable := l_exec_env.get ("PATH")
			create l_parser
			set_parser (l_parser)
			svn_executable := "/usr/bin/svn"
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

feature -- SVN Client commands

	add: SVN_CLIENT_ADD_COMMAND

	checkout: SVN_CLIENT_CHECKOUT_COMMAND

	commit: SVN_CLIENT_COMMIT_COMMAND

	delete: SVN_CLIENT_DELETE_COMMAND

	list: SVN_CLIENT_LIST_COMMAND

	log: SVN_CLIENT_LOG_COMMAND

	status: SVN_CLIENT_STATUS_COMMAND

	update: SVN_CLIENT_UPDATE_COMMAND

--	branch: SVN_CLIENT_BRANCH_COMMAND

--	merge: SVN_CLIENT_MERGE_COMMAND

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
			create delete.make (Current)
			create list.make (Current)
			create log.make (Current)
			create status.make (Current)
		end

invariant
	invariant_clause: True -- Your invariant here

end
