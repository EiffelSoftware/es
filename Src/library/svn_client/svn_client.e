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
			create checkout.make (pf, svn_executable, Void)
			create status.make (pf, svn_executable, Void)
			create list.make (pf, svn_executable, Void)
		end


feature -- SVN Client commands

	checkout: SVN_CLIENT_CHECKOUT_COMMAND

	status: SVN_CLIENT_STATUS_COMMAND

	list: SVN_CLIENT_LIST_COMMAND

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

	add(a_path: STRING_8; a_output_handler: detachable PROCEDURE [ANY, TUPLE [STRING_8]])
		local
			l_args: LINKED_LIST[STRING_8]
		do
			create l_args.make
			l_args.extend (a_path)

--			perform_task ("add", l_args, a_output_handler)
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

feature {NONE} -- Implementation

	svn_executable: STRING

	working_path: STRING

	pf: PROCESS_FACTORY

	initialize_commands
		do

		end

invariant
	invariant_clause: True -- Your invariant here

end
