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
		do
			create pf
				-- TODO: get the svn path using the shared environment
			svn_executable := "/usr/bin/svn"
			initialize_commands
		end

feature -- Element change

	set_working_path (a_working_path: detachable like working_path)
		do
			working_path := a_working_path
		end

feature -- Access

	working_path: STRING

feature -- SVN Client commands

	add: SVN_CLIENT_ADD_COMMAND

	checkout: SVN_CLIENT_CHECKOUT_COMMAND

	list: SVN_CLIENT_LIST_COMMAND

	status: SVN_CLIENT_STATUS_COMMAND

	update(a_path: STRING_8; a_output_handler: detachable PROCEDURE[ANY, TUPLE[STRING_8]])
		local
			l_args: LINKED_LIST[STRING_8]
		do
			create l_args.make
			l_args.extend (a_path)
--			perform_task ("update", l_args, a_output_handler)
		end

	commit(a_path, a_message: STRING_8; a_output_handler: detachable PROCEDURE [ANY, TUPLE [STRING_8]])
		local
			l_args: LINKED_LIST[STRING_8]
		do
			create l_args.make

			l_args.extend (a_path)

			l_args.extend ("--message")
			l_args.extend (a_message)

--			perform_task ("update", l_args, a_output_handler)
		end

	delete(a_path: STRING_8; a_output_handler: detachable PROCEDURE [ANY, TUPLE [STRING_8]])
		local
			l_args: LINKED_LIST[STRING_8]
		do
			create l_args.make
			l_args.extend (a_path)

--			perform_task ("delete", l_args, a_output_handler)
		end

	branch(a_source_path, a_dest_path, a_message: STRING_8; a_output_handler: detachable PROCEDURE [ANY, TUPLE [STRING_8]])
		local
			l_args: LINKED_LIST[STRING_8]
		do
			create l_args.make

			l_args.extend (a_source_path)
			l_args.extend (a_dest_path)

			l_args.extend ("--message")
			l_args.extend (a_message)

--			perform_task ("copy", l_args, a_output_handler)
		end

	merge
		do
		end

	diff
		do

		end

feature {SVN_CLIENT_COMMAND} -- Implementation

	svn_executable: STRING

	pf: PROCESS_FACTORY

	initialize_commands
		do
			create add.make (Current)
			create checkout.make (Current)
			create list.make (Current)
			create status.make (Current)
		end

invariant
	invariant_clause: True -- Your invariant here

end
