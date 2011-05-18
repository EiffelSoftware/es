note
	description: "Summary description for {SVN_CLIENT_LIST_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_CLIENT_LIST_COMMAND

inherit
	SVN_CLIENT_COMMAND
		redefine
			execute,
			command_data_received,
			command_did_finish
		end

create
	make

feature -- Execute

	execute
		local
			l_args: LINKED_LIST[STRING_8]
		do
				-- Clear last status and internal last status
			set_last_list (Void)
			set_internal_last_list (Void)
				-- Initialize last_status and internal_last_status
			create last_list.make
			create internal_last_list.make

			create l_args.make
			l_args.extend (command_name)
			l_args.extend (target_url)
			l_args.append (options_to_args)

			launch_process (l_args)
		end

feature -- Access

	last_result: SVN_CLIENT_FOLDER
		-- Return last result for svn list command

	last_list: detachable LINKED_LIST[STRING_8]
		-- Return svn list for current `working_path' and depth `depth'

feature -- Element change

	set_target_url (a_target_url: detachable like target_url)
		do
			target_url := a_target_url
		end

feature {NONE} -- Implementation

	command_name: STRING_8
		do
			Result := "list"
		end

	target_url: detachable STRING_8

	command_data_received (a_data_received: STRING_8)
			-- Parse `a_data_received' to a list of files and directories paths
		local
			l_data_list: LIST[STRING_8]
		do
			l_data_list := parse_string_to_list (a_data_received)

			internal_last_list.append(l_data_list)

			Precursor (a_data_received)
		end

	command_did_finish
			-- Build tree hierarchy of the repository only after the list command successfully completed
		do

			create last_result.make_with_name (target_url)
			last_result.recursively_add_items (internal_last_list)

			set_last_list (internal_last_list)
			set_internal_last_list (Void)
			Precursor
		end

	set_last_list (a_list: like last_list)
		do
			last_list := a_list
		ensure
			last_lists_set: last_list = a_list
		end

	set_internal_last_list (a_list: like internal_last_list)
		do
			internal_last_list := a_list
		ensure
			internal_last_list_set: internal_last_list = a_list
		end

	internal_last_list: detachable like last_list

end
